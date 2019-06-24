<?php
ob_implicit_flush();
date_default_timezone_set(@date_default_timezone_get());
define('_sep', str_replace('\\', '\\\\', DIRECTORY_SEPARATOR));
define('_root', str_replace('\\', '\\\\', "/usr/share/nginx/html") . _sep);
require _root . '_class' . _sep . 'class.php';

$mysql = new Database();
if(!$mysql->conn) die("Nope!");

if(isset($_GET['taco'])) {
	ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);
}
	
//header("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1
//header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); // Date in the past
//if($_SERVER["HTTP_HOST"] === 'ixat.io')
if($_SERVER["HTTP_HOST"] !== 'me.ixat.io')
{
 	header("Location: http://me.ixat.io".$_SERVER["REQUEST_URI"]);
	exit(0); 
}
//if($_SERVER["HTTP_HOST"] === 'me.ixat.io' && ($Mobile = $_GET["m"]))
//if($Mobile = $_GET["m"]) // temp todo use above
//header("Access-Control-Allow-Origin: *");
$Mobile = array_key_exists("m", $_GET);

// local $Flags
$f_Advanced = (1<<0);

if(isset($_GET["id"]) || isset($_GET["name"]))
{
	$id = isset($_GET['id']) ? $_GET["id"]: 0;
	if($id)
	{
		ReadSql($id);
		print $RegUser["username"];
	}
	else
	{
		ReadSql(mytrim($_GET['name'], 32));
		print $RegUser["id"];
	}
	exit;
}

//require_once('/home/admin/cgi-bin/xatdata.php');

function ReadSql($user)
{
	global $RegUser, $mysql;
	
	if(!$RegUser)
	{
		$RegUser = $mysql->fetch_array("select `username`, `id`, `nickname`, `avatar`, `url`, `desc`, `css` from `users` where `username`=:uname or `id`=:uid;", array('uname' => $user, 'uid' => $user))[0];
	}
	return $RegUser;
}

$a_HAS_PROFILE = 32;
$a_BADXATSPACE = (1<<18);
$a_V_HELD = (1<<26);

$id = 0;
$Media = array();

if(isset($_GET['n']) || isset($_GET['i']) || isset($_GET['u']))
{
	if(array_key_exists('n', $_GET)) $user = mytrim($_GET['n'], 32);
	else if(array_key_exists('i', $_GET)) $user = $_GET['i'];
	else $user = $_GET['u'];
	$Profile = ReadSql($user);
	$id = $Profile['id'];
}
$UserName = $Profile['username'];
$Profile['Info'] = "{$Profile['id']};={$Profile['username']};=".explode("##", base64_decode($Profile['nickname']))[0].";=".explode("#", $Profile['avatar'])[0].";=".explode("##", $Profile['url'])[0].";=";
if($Profile['Info'] === '#BAD')// || $Profile['Bad'] == 1)
{
	header("Location: http://ixat.io");
	exit(0);
}

if(empty($Profile['username']))	
	$Profile = array('Name'=>'Profile');
else
	$Profile['Name'] = "Profile for ".$Profile['username'];
	
	if($id)
	{
	    //$Info = mysql_result($result,0,"Info");
	    //$Vars = mysql_result($result,0,"Back");
	    //$About = mysql_result($result,0,"About");
		$Media = explode(';=', $Profile['desc']);//About
		$Vars = explode(';=', $Profile['css']);//Back

		if(strlen($Vars[0]) < 4)
			$Vars[0] = "background-color: #EEEEEE;";
		if(substr($Vars[0], 0, 7) === 'http://')
			$Vars[0] = "BACKGROUND-POSITION: Center;
BACKGROUND-ATTACHMENT: fixed;
BACKGROUND-IMAGE: url({$Vars[0]});
";

		$Back = 'body {'.$Vars[0].'}
';
		
		$Box = '';
		if(isset($Vars[2]))
			$Box = "border: {$Vars[2]}px solid {$Vars[3]};";
		if(isset($Vars[1]))
			$Box .= 
"background-image:url({$Vars[1]});
background-repeat: repeat;
background-attachment: scroll
";

		if($Box)
		{
			$Back .= '#xatstyinfo{'.$Box.'}
';
			$Back .= '#xatstyabout{'.$Box.'}
';
			$Back .= '#xatstysidead{'.$Box.'}
';
			$Back .= '#xatstymedia{'.$Box.'}
';
		}
	
	}
	else
		$id = 0;


if($id == 0)
{
	$Profile['Info'] = '';
	$Media[0] = "<p>User has nothing much to tell.</p>".Waffle();
}
$DoAds = false;//$id == 0 || $Profile['NoAd'] < time() || $_SERVER["HTTP_HOST"] !== 'ixat.io' ;
//if($id && strlen($Profile['About']) < 100 && $_SERVER["HTTP_HOST"] === 'ixat.io' ) $DoAds = false;
if(!$Mobile) {
header("Cache-Control: max-age=600"); // 10 mins

if($Vars[5] & $f_Advanced) Advanced();
$Back = substr($Back, 0, 1024);
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>xat online chat. <?php echo $Profile['Name']; ?></title>
<LINK REL="SHORTCUT ICON" href="//ixat.io/favicon.ico">
<link type="text/css" rel="stylesheet" href="//ixat.io/cache/cache.php?f=profile.css&d=css">
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
<?php echo $Back; ?>
</style>
</head>
<body>
<?php 
}
else // Mobile 
{
	$t = trim($Profile["MobMedia"]);
	if(empty($t))
		$t = trim($Media[1]);
	if(empty($t))
		$t = trim($Media[0]);
	echo '<html><head><meta charset="UTF-8"></head><body>'.$t.'<body></html>';

	exit;
}
?>
<div id="xatstyheader">
<div id="xatstyheaderad">
  </div>
  <div id="xatstyheadernav">
    <span class="xatstynavlink">
      <a href="http://ixat.io"><IMG src="http://ixat.io/images/xatblk2.png" alt="xat - Get Connected..." border=0 align="absmiddle" longDesc=http://ixat.io></a> &nbsp;  
      <A href="http://web.ixat.io/chat_groups.html">Groups</A> | 
      <A href="http://ixat.io/wiki">Wiki (help)</A> | 
      <A href="http://community.ixat.io/">Forum</A>    
<?php
	$u = "http://ixat.io/web_gear/chat/inappropriateprofile.php?id=$id&UserName=$UserName";
 	echo ' | <A href="'.$u.'">Inappropriate</A>
';
?>	  
</span>  
</div>
</div>

<div id="xatstyinfo">
<embed src="http://ixat.io/web_gear/flash/profile.swf?a30" wmode="transparent" quality="high" width="425" height="600" name="profile" FlashVars="Info=<?php echo $Profile['Info']; ?>" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" />
</div>

<div id="xatstyabout0">
  <div id="xatstyabout">
    <div style="margin:16px 16px 16px 16px;">
<?php echo $Media[0]; ?>
    </div>
  </div>
</div>

<div id="xatstysidead">
</div>
<?php
if(strlen($Vars[4]) > 2)
echo
'<div id="xatstymedia0">
<div id="xatstymedia">
  <embed src="http://ixat.io/web_gear/flash/gallery.swf?a7" quality="high" wmode="transparent" width="100%" height="200" FlashVars="album='.$Vars[4].'" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://ixat.io/update_flash.shtml" />
</div>
</div>
';

if(strlen($Media[1]) > 2)
echo
'<div id="xatstymedia0">
<div id="xatstymedia">
<div style="margin:16px 16px 16px 16px;">
'.$Media[1].'
</div>
</div>
</div>
';
?>
<br><hr>
<table width="100%">
  <tr>
    <td width="50%">
<div id="xatstywhatpoll">
  <embed src="http://ixat.io/web_gear/poll/poll.swf" quality="high" bgcolor="#000000" width="420" height="315" name="poll" FlashVars="id=2639693" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://ixat.io/update_flash.shtml" /><br><a target="_BLANK" href="http://www.ixat.io/web_gear/?p">Get your own Poll!</a><br>
</div>
	</td>
    <td width="50%">
	  <div id="xatstybigad">
      </div>
    </td>
  </tr>
</table>
<TABLE width="100%" border=0 cellpadding="0" cellspacing="0">
  <TBODY>
    <TR>
      <TD bgColor=#dedede height=36><P align=center>&copy;2017 ixat - <A 
      href="http://ixat.io/privacy.html">Privacy</A> - <A 
      href="http://ixat.io/terms.html">Terms</A> - 
      <A href="http://ixat.io/safety.html">Safety</A>
	  </P>
	  </TD>
    </TR>
  </TBODY>
</TABLE>
</body>
</html>
<?php
function mytrim($s, $len)
{
	$s = preg_replace('/[^0-9A-Za-z]/', '', $s);

	if(strlen($s) > ($len-1))
		$s = substr ($s, 0, $len-1);
	return $s;
}

// New stripped down xatpsce
function Advanced()
{
	global $Back, $Profile, $id, $RegUser, $Media, $core;

	ReadSql($id);

	if(!$core->GetUserPower($id, 377)) return; //doesnt have me power

?>
<!DOCTYPE HTML>
<html>
<head>
<title>xat online chat. <?php echo $Profile['Name']; ?></title>
<LINK REL="SHORTCUT ICON" href="//ixat.io/favicon.ico">
<?php /*<link type="text/css" rel="stylesheet" href="//ixat.io/cache/cache.php?f=profile.css&d=css">*/ ?>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
body {
	/*padding:0px;
	margin: 0px 0px 0px 0px;*/
	FONT-SIZE: 12pt;
	FONT-FAMILY: Arial, Helvetica, sans-serif;
}
div#xatstyme {
	background:#0;
	color: #00; 
	overflow: auto;
}
<?php echo $Back; /* User CSS */?>
div#noowayfixed {
	z-index: 2147483647;
    position: fixed;
    bottom: 0;
    left: 0;
}
div#noowaymenu
{
	background-color:#009;
	background: linear-gradient(#000014, #000024, #00004e);
    border-radius: 0px 5px 0px 0px;
	display: none;
	FONT-SIZE: 12pt;
	FONT-FAMILY: Arial, Helvetica, sans-serif;
}
div#noowayitems
{
	padding-top: 5px;
    padding-right: 0px;
    /*padding-bottom: 5px;*/
    padding-left: 0px;
    margin-left: 6px;
    line-height: 130%;
	color:#fff;
}
div#noowayitems > a
{
	color:#fff;
    text-decoration: none;
}
div#noowayitems > a:hover {
    text-decoration: underline;
}
</style>
<div id="xatstyme">
<?php echo $Media[1]; ?>
</div>
<div onmouseover="showMenu(this)" onmouseout="hideMenu(this)" id="noowayfixed">
  <img id="noowayplanet" src="https://ixat.io/images/logow2.svg">
  <div id="noowaymenu">
    <div id="noowayitems">
<a href="http://ixat.io">xat</a><br>
<a href="http://ixat.io/editprofile?email=<?php echo $RegUser['username']; ?>">Edit</A><br>

<A href="http://ixat.io/wiki">Wiki (help)</A><br> 
<A href="http://community.ixat.io/">Forum</A><br>    

<A href="http://ixat.io/privacy.html">Privacy</A><br>
<A href="http://ixat.io/terms.html">Terms</A><br>
<A href="http://ixat.io/safety.html">Safety</A><br>

<A href="http://ixat.io/web_gear/chat/inappropriateprofile.php?id=<?php echo $id ?>">Inappropriate&#x1F44E;</A><br>
&copy;<?php echo date("Y") ?> xat<br>

    </div>
    <a href="http://ixat.io"><img src="https://ixat.io/images/logow.svg"></a>
  </div>
</div>

<script>
function showMenu(x) {
    document.getElementById("noowaymenu").style.display = "block";
    document.getElementById("noowayplanet").style.display = "none";
}

function hideMenu(x) {
    document.getElementById("noowaymenu").style.display = "none";
    document.getElementById("noowayplanet").style.display = "block";
}
</script>
</head>
<body>
<?php
exit;
}

function Waffle()
{
return 
'<p><b>ixat.io is a fun social networking site with the best online chat
box. Make friends, join a group, run your own chat - 10,000s online now.</b></p>
<div id="sbox">
<span class="vh1">Find what people are talking about:</span><br />
<form method="post" action="http://ixat.io/web_gear/chat/search.php" ><input id="sval" autocomplete="off" maxlength="100" size="60" title="Type a search term here" name="search" value=""><input type=submit value="Search"></form>
</div>
<script type="text/javascript" charset="utf-8"> 
function Sviz(d)
{
divId = document.getElementById(\'sbox\');
var f = document.getElementById(\'sval\');
var t = f.value;
var s;
if(d == \'imess\') {
s=\'<span class="vh1">See what people are talking about:</span><br /><form method="post" action="http://ixat.io/web_gear/chat/search.php" ><input id="sval" autocomplete="off" maxlength=100 size=60 title="Type a search term here" name="search" value=""><input type=submit value="Search"></form>\';
} else {
if(d == \'ixat\') s=\'<span class="vh1">Search all of xat:</span><br />\';
else s=\'<span class="vh1">Search the Internet:</span><br />\';
s += \'<div class="cse-branding-right" style="background-color:#FFFFFF;color:#000000"><div class="cse-branding-form"><form action="http://www.google.com/cse" id="cse-search-box" target="_blank">      <div><input type="hidden" name="cx" value="partner-pub-3915747564069545:\';
if(d == \'ixat\') s +=\'4155635009\';
if(d == \'iweb\') s +=\'7403843107\';
s += \'" /><input type="hidden" name="ie" value="UTF-8" /><input id="sval" type="text" name="q" size="55" /><input type="submit" name="sa" value="Search" /></div></form></div><div class="cse-branding-logo"><img src="http://www.google.com/images/poweredby_transparent/poweredby_FFFFFF.gif" alt="Google" /></div><div class="cse-branding-text">Custom Search</div></div>\'+"\n";
}
divId.innerHTML = s;
f = document.getElementById(\'sval\');
f.value = t;
}
</script> 
<input id="smess" type="radio" name="srad" value="smess" checked onclick="Sviz(\'imess\');">messages 
<input id="sxat" type="radio" name="srad" value="sxat" onclick="Sviz(\'ixat\');">xat
<input id="sweb" type="radio" name="srad" value="sweb" onclick="Sviz(\'iweb\');">web<br />
</td>
</tr>
</table>
<!--<p>xat updates:</p>-->
<script src="http://twitterjs.googlecode.com/svn/trunk/src/twitter.min.js" type="text/javascript" charset="utf-8"></script> 
<script type="text/javascript" charset="utf-8"> 
/*
  getTwitters(\'twitters\', { 
      id: \'xat\', 
      clearContents: true, 
      count: 10, 
      ignoreReplies: false,
      template: \'<span class="prefix"><img height="16" width="16" src="%user_profile_image_url%" /> <a href="http://twitter.com/%user_screen_name%">%user_name%</a> said: </span> <span class="status">"%text%"</span> <span class="time"><a href="http://twitter.com/%user_screen_name%/statuses/%id%">%time%</a></span>\'
  });
*/
</script> 
<STYLE type="text/css">
#twitters {
  border: 1px solid #e5e5e5;
  padding: 5px;
}
#twitters UL {
  list-style: none;
  padding: 0;
}
#twitters LI {
  padding: 3px;
  background: none;
}
#twitters SPAN.prefix {
  font-weight: bold;
}
#twitters SPAN.time {
  font-style: italic;
  color: #c5c5c5;
}
#twitters SPAN..status {
  font-style: italic;
}
</STYLE>
<!--<div id="twitters"><p>Loading...</p> 
</div>-->
<h1>Further reading:</h1>
<table cellpadding="10px">
  <tbody>
    <tr>
      <td width="50%" valign="top"><a name="News" id="News"></a>
          <h2><a href="http://util.ixat.io/wiki/index.php/News" title="News">News</a></h2>
        <p>What\'s new with the xat online chat rooms and groups</p>
        <a name="Frequently_Asked_Questions" id="Frequently_Asked_Questions"></a>
        <h2><a href="http://util.ixat.io/wiki/index.php/FAQ" title="FAQ">Frequently Asked Questions</a></h2>
        <p>Check out this guide for the most frequently asked questions by people new to xat.</p>
        <a name="User_Guide" id="User_Guide"></a>
        <h2><a href="http://util.ixat.io/wiki/index.php/UserGuide" title="UserGuide">User Guide</a></h2>
        <p>This guide is for xat visitors and shows you all the basic functions of the chat box.</p>
        <a name="Owner.2FModerator_Guide" id="Owner.2FModerator_Guide"></a>
        <h2><a href="http://util.ixat.io/wiki/index.php/OwnerGuide" title="OwnerGuide">Owner/Moderator Guide</a></h2>
        <p>What can owners and moderators do? What makes a good one? This guide is for owners and moderators.</p>
        <a name="xats_Guide" id="xats_Guide"></a>
        <h2><a href="http://util.ixat.io/wiki/index.php/Xats" title="Xats">xats Guide</a></h2>
        <p>If you have xats you can use them to buy kisses, marriages, promotion, and previously registered groups. This guide explains what you can do with xats.</p>
        <a name="Subscriber_Guide" id="Subscriber_Guide"></a>
        <h2><a href="http://util.ixat.io/wiki/index.php/SubscriberGuide" title="SubscriberGuide">Subscriber Guide</a></h2>
        <p>If you have days you have access to special features such as glitter effects for your avatars. This guide covers what subscribers can do.</p>
        <a name="Powers_Guide" id="Powers_Guide"></a>
        <h2><a href="http://util.ixat.io/wiki/index.php/Powers" title="Powers">Powers Guide</a></h2>
        <p>You can use your xats / days to buy special powers and abilities for the xat chat. These abilities make you stand out from others that do not have xats / days. There are bonus features with powers you could receive. This guide will help you with powers.</p>
        <a name="Gifts" id="Gifts"></a>
        <h2><a href="http://util.ixat.io/wiki/index.php/Gifts" title="Gifts">Gifts</a></h2>
        <p>Sending and receiving gifts.</p></td>
      <td width="50%" valign="top"><a name="Trading_Guide" id="Trading_Guide"></a>
          <h2><a href="http://util.ixat.io/wiki/index.php/Trading" title="Trading">Trading Guide</a></h2>
        <p>Sometime you have days and you need xats, sometimes you have xats and you need days. This guide will show you how to use the xat trade engine for easier and safer trading.</p>
        <a name="Applications_Guide" id="Applications_Guide"></a>
        <h2><a href="http://util.ixat.io/wiki/index.php/Applications" title="Applications">Applications Guide</a></h2>
        <p>Grid, Player, IM, Games, Doodle, Groups, Smilies and Translate are applications found on tabs on the left of chat group pages. That can be activated and used while chatting with your friends. This Guide will help you get started with applications.</p>
        <a name="xatspace_Guide" id="xatspace_Guide"></a>
        <h2><a href="http://util.ixat.io/wiki/index.php/Xatspace" title="Xatspace">xatspace Guide</a></h2>
        <p>xatspace is your page on xat, where you can put profile information, photos, widgets, music and videos. This guide will help you set up your xatspace.</p>
        <a name="xat_Live_Guide" id="xat_Live_Guide"></a>
        <h2><a href="http://util.ixat.io/wiki/index.php/Live" title="Live">xat Live Guide</a></h2>
        <p>xatLive is a special mode for xat boxes for online events.</p>
        <a name="Phishing" id="Phishing"></a>
        <h2><a href="http://util.ixat.io/wiki/index.php/Phishing" title="Phishing">Phishing</a></h2>
        <p>Have you ever heard of anyone who has lost their xats, or had their account taken over? It\'s probably because they got &quot;phished&quot;. This guide will help you avoid getting phished.</p>
        <a name="Account_Protection" id="Account_Protection"></a>
        <h2><a href="http://util.ixat.io/wiki/index.php/AccountProtection" title="AccountProtection">Account Protection</a></h2>
        <p>When xat Account Protection is activated the xat servers detect if someone else tries to login to you xat account.</p>
        <a name="xats_Reserve" id="xats_Reserve"></a>
        <h2><a href="http://util.ixat.io/wiki/index.php/XatsReserve" title="XatsReserve">xats Reserve</a></h2>
        <p>The xats Reserve sets limits as to how much you can give away. This can also protect your xats, days and powers from other people who might try to scam them from you.</p></td>
    </tr>
  </tbody>
</table> 
';
}

?>