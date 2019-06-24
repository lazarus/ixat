<?php
error_reporting(E_ALL ^ (E_NOTICE | E_WARNING));
require_once('/var/www/html/web_gear/chat/connect2.php');
mysql_select_db("chat_count");
require_once('tfiles.php'); // known files

$lang = rangetrim(strtolower($_REQUEST['lang']), '^a-z0-9', 2);
if(strlen($lang) != 2) EndNow("Bad lang");

$files = rangetrim(strtolower($_REQUEST['file']), '^a-z0-9,', 256);
$files = explode(',', $files);
$files[] = 'main';
foreach($files as $f)
	if(!$tfiles[$f]) EndNow("Bad file $f");

$uid = intval($_REQUEST['uid']);
$cachetime = 10;

foreach($files as $file)
{
	$query = "SELECT uid,json FROM Translate WHERE (uid='1' OR uid='$uid') AND lang='$lang' AND file='$file' ORDER BY uid";
	$result = mysql_query($query,$xatchat) ;
	if(!$result) EndNow("SystemErr 2");
	
	$ret[$file]= array();
	for($n=0; $n<2; $n++)
	{
		$row = mysql_fetch_assoc($result);
		$strings = json_decode($row["json"], true);
		if($row["uid"]==1) 
		{
			$ret[$file] = $strings[$file];
			continue;
		}
		foreach($strings[$file] as $k=>$v)
			$ret[$file][$k] = 'green';
		break;
	}
}
EndNow(json_encode($ret));

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
	global $cachetime;
if($cachetime > 11) $cachetime = 11; // debug
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
