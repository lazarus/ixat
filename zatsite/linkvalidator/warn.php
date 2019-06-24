<?php
error_reporting(E_ALL ^ E_NOTICE);

include("/home/admin/cgi-bin/Net/DNS.php");
//require_once('Net/DNS.php'); // ubuntu version
require_once('/home/admin/cgi-bin/xatdata.php');

//if($_SERVER["HTTP_HOST"] !== 'xatlinks.com') exit(0);

header("Cache-Control: public,max-age=3600"); // HTTP/1.1

$BanTL = array('tc' => 1,'gs'=>1); // ,''=>1 banned top level domains

$Ban = array('beastradio' => 'net', 'club-ignition' => 'com', 'co' => 'nr', 'killstupidpeople' => 'net',
'redtube' => '*', "0fees" => "net", "educasis" => "com",
'webspacemania'=>'com','smashbl4ck'=>'com','hacksantana'=>'com','friendmusix'=>'com','eu'=>'kz',
'br00tality'=>'com','palimpalem'=>'com','comyr'=>'com','logindais'=>'tk','site90'=>'net',
'ultra-zone'=>'es','club-shadow'=>'com','t35'=>'com','jotform'=>'com','gratishost'=>'com'
,'get-powers'=>'tk','idoo'=>'com','webcindario'=>'com','esp'=>'st','teamviewer'=>'com',
'rapidshare'=>'com','justfree'=>'com','110mb'=>'com', 'ripway'=>'com','nimp'=>'org',
'megaupload'=>'com','days-for-free'=>'com','sick-minded-radio'=>'com','iespana'=>'es','mediafire'=>'com','freepowers'=>'info'
,'magicaleffect'=>'net','xatbook' => 'com', 'blogcu'=>'com','retailmenot'=>'com','110mb'=>'com','4shared'=>'com','plunder'=>'com'
,'xp3'=>'biz','flappi'=>'com','bubbleegum'=>'com','formfacil'=>'com','soyof'=>'com','chatpremium'=>'com'
);
$Ban2 = array( 
'it.gg'=>1,'ni.kz'=>1,'ar.gd'=>1,'ar.gs'=>1,'ar.kz'=>1,'ar.tc'=>1,'ar.vg'=>1,'bo.kz'=>1,'bo.tc'=>1,'bo.tf'=>1,'bo.vg'=>1,
'cl.gd'=>1,'cl.kz'=>1,'cl.tc'=>1,'cl.tf'=>1,'cl.vg'=>1,'col.n'=>1,'cr.gs'=>1,'cr.kz'=>1,'cr.tc'=>1,'cu.tc'=>1,'do.kz'=>1,
'ec.kz'=>1,'ec.tf'=>1,'es.gd'=>1,'es.kz'=>1,'esp.tc'=>1,'esp.vg'=>1,'gt.gs'=>1,'gt.tc'=>1,'gt.tf'=>1,'gt.vg'=>1,'hn.gs'=>1,
'hn.tc'=>1,'hn.tf'=>1,'hn.vg'=>1,'mex.tc'=>1,'mex.vg'=>1,'mx.gd'=>1,'mx.gs'=>1,'mx.kz'=>1,'mx.vg'=>1,'ni.kz'=>1,'pa.kz'=>1,
'pe.kz'=>1,'pr.kz'=>1,'py.gs'=>1,'py.tc'=>1,'py.tf'=>1,'py.vg'=>1,'sv.tc'=>1,'uy.gs'=>1,'uy.kz'=>1,'uy.tc'=>1,'uy.tf'=>1,
'uy.vg'=>1,'ve.gs'=>1,'ve.tc'=>1,'ve.tf'=>1,'ve.vg'=>1,'ven.nu'=>1, 'xr.com'=>1, 'zonadeldesorden.es'=>1,'albtrade.eu'=>1, 'webself.net' => 1, 'x4t.es' => 1, 'co.cc' => 1,'urpage.me'=>'1','new.fr'=>'1','cwahi.net'=>'1'
); //  ,''=>'com' 

$Ban3 = array('cpicemafia.wordpress.com'=>1,'hd1.com.br'=>1,'hdfree.com.br'=>1); // ,''=>1

$Good = array('xatspace' => 'com', 'xat' => 'com', 'facebook' => 'com', 'twitter'=>'com'); 				
$Good2 = array('xatblogs' => 'net','mundoxat' => 'net','xatradio' => 'net','xatchats' => 'net','xatblog' => 'net', 'xat' => 'co' );
$Good3 = array('z.z'=>1); // still has phish warning
$Good4 = array('z.z' => 1); // still has phish warning / 

	//    ,'' => 'net' 

//print "p:".$_REQUEST['p']."<BR>\n";
//$_REQUEST['p'] = 'aHR0cDovL3Blb3BsZS5tb3ppbGxhLmNvbS9+Y2JlYXJkL2xhYnMvaW1hZ2VzL3Rlc3QtcGlsb3QucG5n';

$_REQUEST['p'] = str_replace(' ','+',$_REQUEST['p']);
$Page = CleanUrl(base64_decode($_REQUEST['p']));
//$Page = CleanUrl(($_REQUEST['p'])); // debug

if($argv[1]) 
{
	$Page = CleanUrl($argv[1]);
	$debug = true;
}

file_put_contents( '/home/admin/data/xatlinkslog.txt'  , time().",$Page\n", FILE_APPEND | LOCK_EX );

for($loop=0; $loop<2; $loop++) // add redirection
{
if($debug) print "Loop: $loop\n";
//$Page = $_REQUEST['p'];
$Bad = -1;
// -1:frame, 0:Good, 1:phish, 2:blocked, 3:Warn, 4:frame

//$Page = read_input();

if(strpos($Page, '@') !== false)
{
	$Page = str_replace('http://', '', $Page);
	$Page = "mailto://".$Page;
}
else
if(strtolower(substr($Page,0,7)) != 'http://')
	$Page = "http://".$Page;

//print "$Page\n";

if(strpos($Page, 'Bounce.php')) $Page = 'http://xat.com';
$u = xparse_url(strtolower($Page));
$domain = $u['host'];
if(isset($u['port']) && $u['port'] != 80) $Bad = 2;
if(strpos($u['path'], '.swf') !== false) $Bad = 3;
if(strpos($u['path'], '.zip') !== false) $Bad = 3;
if(strpos($u['path'], '.exe') !== false) $Bad = 1;
if($domain{strlen($domain)-1} === '.') $Bad = 1; // dont allow trailing dot
if(substr_count($domain, '.') === 3) // possible ip eg 123.123.123.123
{
	$t = explode('.', $domain);
	if(is_numeric($t[0]) && is_numeric($t[1]) && is_numeric($t[2]) && is_numeric($t[3])) $Bad = 1;
}

// Twitter bodge
//if($domain === 'twitter.com' && $u['path']{1} !== '#')
//	$Page = "{$u['scheme']}://${u['host']}/#!{$u['path']}";

$s = explode('.', $domain);
//print_r($domain);
while(count($s) > 2) // get last two
	array_shift($s);
//print_r($s);

// Bad, 0:Good, 1:Block, 
	
if($u === false)
	$Bad = 2;
else if($Good[$s[0]] === $s[1] || $Good2[$s[0]] === $s[1])
{
	$Bad = 0;
	if($u['scheme'] === 'mailto' && $u['host'] === 'xat.com' && $u['user'] !== 'info' )
		$Bad = 1; // bad email
}
else if('tk' === $s[1] || 'am' === $s[1])
	$Bad = 1;
else if(strpos($domain, 'xat') !== false)
	$Bad = 1;
else if(strpos($domain, 'x4t') !== false)
	$Bad = 1;
else if(strpos($domain, 'freeday') !== false)
	$Bad = 1;
else if(strpos($domain, 'trialpay') !== false)
	$Bad = 1;
else if($Ban[$s[0]] === $s[1] || $Ban[$s[0]] === '*' || $BanTL[$s[1]])
	$Bad = 1;
else if($Ban2[$s[0].'.'.$s[1]])
	$Bad = 1;
else if(strpos($domain, 'day') !== false)
	$Bad2 = 3;
else if(strpos($domain, 'free') !== false)
	$Bad2 = 3;
else if(strpos($domain, 'sub') !== false && $s[0] !== 'subepic')
	$Bad2 = 3;
	
if($Bad2 === 3 && ($Bad!=1 && $Bad!=2)) $Bad=3;

if($Bad != 0) // lookup in xatdata
{
	$d = "chatu.linkvalidator";
	$s = explode('.', $domain);
	while(count($s) > 3) array_shift($s); // max 3 bits
	if(count($s) > 1) // sanity
	{
		if(count($s) == 2) // common
			$get = array("$d.{$s[0]}.{$s[1]}");
		else
			$get = array("$d.{$s[0]}.{$s[1]}.{$s[2]}", "$d.{$s[1]}.{$s[2]}");
			
		$res = xatGet($get);
		$ExpTime = time()-4*3600; // Refresh cache if 4 hours old
		for($n=0; $n<count($get); $n++)
		{
			if($res[$n] === '#MISS' || ($res[$n]['bad'] == -1 && $res[$n]['time'] < $ExpTime)) // refresh cache
			{
				$res[$n] = array('bad'=>-1, 'time'=>time(), 'timestamp'=>time());
				MemObj(0, $get[$n])->set($get[$n], json_encode($res[$n]), 12*3600);
			}	
		}
		
		foreach($res as $v)
		{
			if(!is_array($v) || !isset($v['bad']))
				$t = -1;
			else
				$t = intval($v['bad']);
			if($t > 4) $t = 4; // other codes give frame
			if($t < 0) continue; 
			$Bad = $t;
			break;
		}
		if($debug)
		{		
			print_r($get);		
			print_r($res);
			print "Bad $Bad\n";	
		}
	}
}
/*
else // try opendns ;)
{
	preg_match('=//(.*?)/=', "$Page/", $matches);
	
	$Domain = strtolower($matches[1]);
	
	// create object
	$ndr = new Net_DNS_Resolver();
	
	//$ndr->nameservers(array('208.67.222.222'));
	$ndr->nameservers(array('resolver1.opendns.com')); // use this nameserver list
	
	// query for IP address
	$answer = $ndr->search($Domain, "A");
	
	if($answer->answer[0]->address === '208.67.219.132') $Bad = 3;
}
*/
$Dodgy = preg_match('=xat|x4t|free|sub|day|boombly=', strtolower($Page)) && $domain !== 'subepic.com';
if($Bad < 0 && $Dodgy) $Bad = 3;
if($Good4[$s[0].'.'.$s[1]]  || $Good3[$domain]) $Bad = -1;
if($Ban3[$domain]) $Bad = 1;
/*if($Bad < 0 && ($s[0] === 'tinyurl' || $s[1] === 'ly')) // tinyurl stuff
	if($Dodgy) $Bad = 1;*/

if($debug) print "Bad: $Bad\n";

if(!$Bad && $Page !== '' )
{
	
	header("Location: $Page");
	//print "Location: $Page";
	exit(0);
}

if($Bad == -1 || $Bad == 3) // check for redirects
{
	$nd = IsRedirect($Page);
	if($debug) print "IsRedirect: $nd\n";
	if($nd == false) break; // not a redirect, ok
	if($loop==1 || $nd === true) { $Bad=2; break; } // barf if multiple redirect
	$Page = CleanUrl($nd); // try again with this page
	continue;
}
break;
} // end loop

if($debug) print "Bad2: $Bad\n";

if(($Bad == -1 || $Bad == 4)&& $Page !== '')// && $s[1] != 'com' )
{

echo '<HTML>
<HEAD>
<TITLE>Anti-Phishing - Dont Get Scammed by Phishing Sites!</TITLE>
<META NAME="ROBOTS" CONTENT="NOINDEX">
</HEAD>
<FRAMESET rows=108,*>
<FRAME marginHeight=0 src="http://xat.com/web_gear/chat/linkvalidator.php?link='.$Page.'" marginWidth=0 scrolling=no>
<FRAME src="'.$Page.'">
<NOFRAMES></NOFRAMES>
</FRAMESET>
</HTML>
';
exit();
}

echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Chat box xat external page check</title>
<LINK REL="SHORTCUT ICON" href="icon.ico">
<link type="text/css" rel="stylesheet" href="http://www.xat.com/css/xat.css">
<style type="text/css">
</style>
<META NAME="ROBOTS" CONTENT="NOINDEX">
</head>
<body>
';
 $xTab=0; include('/var/www/html/css/header.php');
echo '<div class="pad16">
<h1>xat external page check</h1>
';

if($Bad == 1)
	echo '<P><b><font color="#FF0000">**** WARNING! This page is blocked.<BR>This user MIGHT be trying to steal your xats.<BR>Be careful of phishing scams.<BR>Do not enter your details in other sites!<BR>Do not install anything from linked sites.<BR>Do not give this user xats in exchange for anything.<BR>If you ignore this warning you may lose your xats. ****</font></b></P><P>Please read: <a href="http://util.xat.com/wiki/index.php/Phishing">how to protect yourself from being scammed or phished</a>';
else
if($Bad == 2)
	echo '<P>This page is blocked.</P>';
else
if($Bad == 3)
	echo '
<h1>External website does not exist or has been blocked.</h1>
<p style="color:#FF0000">DO NOT ENTER YOUR XAT OR EMAIL PASSWORD on this new website!<BR>
DO NOT RUN PROGRAMS OR INSTALL ANYTHING FROM THIS WEBSITE.</p>
<p>To continue to the external website ignoring the warnings click the link: <a href="'.$Page.'">'.$Page.'</a>.</p>
';
else
	echo '<P>The page was not recognised.</P>';

echo '<BR>
<embed src="http://util.xat.com/linkvalidator/thiefbig.swf?a2" quality="high" bgcolor="#ffffff" height="480" width="600" align="middle" type="application/x-shockwave-flash" /></td>
</div>
';
 $xAd=1; include("/var/www/html/css/footer.php");
echo '
</body>
</html>
';

function read_input()
{
    $fp    = fopen("/dev/stdin", "r");
    $input = trim(fgets($fp, 255));
    fclose($fp);
    return $input;
}

function CleanUrl($s)
{
	//$myFilter = new InputFilter();
	//$s =  $myFilter->process($s);
	$s = preg_replace('/\\s.*/', '', $s); // stip anything after whitespace
	$s = preg_replace('/#.*/', '', $s); // stip anything after #
	$s = preg_replace('/[^:a-zA-Z0-9\\-_~\\?=\\/\\.#%&\\(\\)\\+!\\*\\$]/', '', $s);
	return $s;
}

function IsRedirect($u)
{
	global $debug;
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL,            $u);
    curl_setopt($ch, CURLOPT_HEADER,         true);
    curl_setopt($ch, CURLOPT_NOBODY,         true);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT,        5);

    $r = curl_exec($ch);
	if(strpos($r, "window.location")) return true;
	
    $r = explode("\n", $r);
	$count = count($r);
	
    for ($i=0; $i < $count; $i++)
    {
        if ($loc = strpos($r[$i], "ocation:"))
        {
			$t = $r[$i];
			if($debug) print "$t\n";
			$t = substr($t, $loc+9);
			if($t{0} === '/') //relative ?
			{
				$u = xparse_url($u);
				$t = "http://{$u['host']}$t";
			}
			return $t;
        }
    } 
	if(strpos($r, "Content-Length: 0")) return true;
	return false;
}

function xparse_url($u)
{
	$u = parse_url($u);
	if(preg_match('=[^a-zA-Z0-9\-\:\.]=', $u["host"]))
		$u["host"] = "."; // clobber it
	return $u;
}
?>
