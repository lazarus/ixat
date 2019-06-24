<?php
//$debug = true;
/*
	Read a language file from SQL (or cache)
*/
error_reporting(E_ALL ^ (E_NOTICE | E_WARNING));
require_once('/var/www/html/web_gear/chat/connect2.php');
mysql_select_db("chat_count");
require_once('tfiles.php'); // known files

$file = rangetrim(strtolower($_REQUEST['file']), '^a-z0-9\\-', 80);
$file = explode('-', $file);

$lang = $file[1];
if(strlen($lang) != 2) EndNow("Bad lang");

$file = $file[0];
if(!$tfiles[$file]) EndNow("Bad file");

$uid = intval($_REQUEST['uid']);
$cachetime = 10;
//	header("Cache-Control: max-age=".());
$cachefile = "/tmp/lang/{$lang}_$file.json";

$ulf = array("uid='0'", "lang='$lang'", "file='$file'");
$foreign = ReadSql($ulf);
if(!$foreign) // try cache
{ // try cache
	$foreign = json_decode(file_get_contents($cachefile), true);
	$cachetime = 3600; // only cache panic copy for 1 hour
}
else if($uid == 0) // rad ok cache it
{
	if($foreign == 0) EndNow("SystemErr 2");
	if($uid == 0) $cachetime = 30*24*3600; // main language
	mkdir("/tmp/lang");
	file_put_contents($cachefile, json_encode($foreign));
}
if($foreign == 0) EndNow("SystemErr 3");

if($uid)
{
	$ulf = array("uid='$uid'", "lang='$lang'", "file='$file'");
	$custom = ReadSql($ulf);
	foreach($custom[$file] as $n => $s)
		$foreign[$file][$n] = $s;
}

EndNow(json_encode($foreign));

function ReadSql($ulf)
{
	global $TimeNow, $xatchat, $debug;
	
	$query = "SELECT json FROM Translate WHERE ".implode(' AND ', $ulf);
	$result = mysql_query($query,$xatchat) ;
	if(!$result) return 0;
	$row = mysql_fetch_assoc($result);
	return json_decode($row['json'], true);
}

function rangetrim($s, $nok, $maxlen)
{
	$s = trim($s);
	$s = preg_replace("/[$nok]/i", '', $s); 
	if(strlen($s) > ($maxlen))
		$s = substr ($s, 0, $maxlen);
	return $s;
}

function EndNow($s)
{
	global $cachetime, $debug;
	if($debug && $cachetime > 11) $cachetime = 11; // debug
	header("Cache-Control: max-age=$cachetime");
	header('Access-Control-Allow-Origin: http://web.xat.com');	
	echo $s;
	exit;
}

function getIp()
{
	$ip = $_SERVER['HTTP_X_REAL_IP'];
	if(empty($ip) || $ip === '127.0.0.1') $ip = $_SERVER['REMOTE_ADDR'];
	if(empty($ip) || $ip === '127.0.0.1')
	{
		$ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
		if(strpos($ip, ',')) // CSV ?
		{
			$ip = explode(',', $ip);
			$ip = trim(array_pop($ip));
		}
	}	
		
	return $ip;
}


function RawIp()
// get our ip as sock style reversed word, maybe signed :S
{
	$ip = getIp();
	$ip = ip2long($ip);	
	if($ip === false) return 0;
	
	$ip = (($ip >> 24) & 0xFF) | (($ip >> 8) & 0xFF00) | (($ip << 8) & 0xFF0000) | (($ip << 24) & 0xFF000000);
	return $ip;
}	
	
function uIntIp()
// get our ip as sock style reversed unsigned word
{
	$ip = RawIp();
	if($ip >= 0) return $ip;
	
	$ip += (float)"4294967296";
	
	return (string)$ip;
}
?>
