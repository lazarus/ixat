<div style="display:none"><span data-localize=chat.grassmod>Report moderator</span>
<span data-localize=chat.feelunfair>If you feel you have been unfairly treated by a moderator you can report it to the owner of the</span>
</div>
<?php
header("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); // Date in the past
include('../web_gear/chat/connect2.php');
include('../web_gear/chat/CapNum.php');
require_once('/var/www/html/web_gear/chat/htmlhead.php');
$xp=array('ad'=>'top', 'title'=>'<span data-localize=chat.grassmod>Report moderator</span>', 'cache'=>3600, 'meta'=>array('xt'=>'chat'), 'forcedom'=>'web.xat.com');

HtmlHead2();
?>

<h3><span data-localize=chat.grassmod>Report moderator</span></h3>
<?php 
$EmailErr = $CapNumErr = '';
$_REQUEST['g'] = mytrim(($_REQUEST['g']));
$_REQUEST['email'] = mytrim(($_REQUEST['email']));
$_REQUEST['feedback'] = mytrim(($_REQUEST['feedback']));
if($_REQUEST['submit'])// && $_REQUEST['email'] && )
{
	CheckReCapNum();
	preg_match('/([a-z_A-Z0-9\\-\\.]+\\@[a-zA-Z0-9\\-\\.]+)/', $_REQUEST['email'], $matches);
	$_REQUEST['email'] = $matches[0];

	if((strlen($_REQUEST['email']) > 0) && !isValidEmail($_REQUEST['email'])) $EmailErr = ErrHtml(<span data-localize=main.evalid>email is not valid</span>);
	
	
	if(!$EmailErr && !$CapNumErr) // all ok so far?
		DoIt();
}
echo "$DbErr $CapNumErr" ; 
?>
	
<p><span data-localize=chat.feelunfair>If you feel you have been unfairly treated by a moderator you can report it to the owner of the</span> <?php echo $_REQUEST['g']; ?> group. Owners are not obliged to answer emails but they certainly won't if you don't provide a valid email address.</p>

<form method="post" >
<input name="g" type="hidden" value="<?php echo $_REQUEST['g']; ?>" >
<input name="i" type="hidden" value="<?php echo $_REQUEST['i']; ?>" >
  <table>
<tr><td><p>E-mail:<?php echo $EmailErr; ?></p></td><td><input name="email" type="text" value="<?php echo ($_REQUEST['email']); ?>" size="60" maxlength="100" /></td><td><p>(<span data-localize=chat.optemail>Optional but you will not get a reply if this is not valid</span>)</p></td></tr>
<tr>
  <td><p><span data-localize=chat.message>Message</span>:</p></td><td colspan="2">
<textarea name="feedback" rows="20" cols="70"><?php echo $_REQUEST['feedback']; ?></textarea>
</td></tr>
<tr><td></td><td>
<?php ReCapNumForm(); ?></td></tr>
</table>
<p>
  <input name="submit" type="submit" id="submit" value="Send"/>
</p>
</form>
<?php
EndHtml2();

function mytrim($s)
{
	$s = str_replace('<', ' ', $s);
	$s = str_replace('>', ' ', $s);
	return str_replace('"', '', htmlspecialchars(trim($s)));
}

function ErrHtml($s)
{
	return '<p style="color:#FF0000"><strong>**'. "$s**</strong></p> \n" ;
}

function isValidEmailCrap($email)
    {
        return preg_match("/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*$/i", $email);
    }

function isValidEmail($email) { 
	if( (preg_match('/(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)/', $email)) || 
		(preg_match('/^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$/',$email)) ) { 
		$host = explode('@', $email);
		if(checkdnsrr($host[1].'.', 'MX') ) return true;
		if(checkdnsrr($host[1].'.', 'A') ) return true;
		if(checkdnsrr($host[1].'.', 'CNAME') ) return true;
	}
	return false;
}


function DoIt()
{
	// see if available

	global $NameErr, $gErr, $GroupDescErr, $EmailErr, $DbErr;
	global $xatchat, $roomid, $roompass;
	//global $_REQUEST;

	// Now look up
// TODO tidy name

	$id	= crcKw(strtolower($_REQUEST['g']));

    $query = "SELECT owner,data FROM xatchatg WHERE ID=$id";
    $result = mysql_query($query,$xatchat) ;

	if(!$result)
	{
		$DbErr = ErrHtml("System problem (1). Please try later, sorry.");
		return;
	}

	$row = mysql_fetch_row($result);

	$owner = explode(';=', $row[0]);
	$owner = $owner[0];	
	$data = $row[1];

$g = $_REQUEST['g'];
//$Subject = "xat chat group: $g - " . ($_REQUEST['GroupDescription']);

//use pair to send email

$to = urlencode($data);

$e = $_REQUEST['email'];

$s = urlencode("xat group: $g - Moderator report");

$b = "Hello $owner,\n\nYou have received this report about a moderator on your group\n" ;

if(strlen($e) < 1) 
{
	$e = 'noreply@xat.com' ;
	$b .= "(The user did not supply their email address)\n";
}
$e = urlencode($e);

$b .= "\n";
$b .= $_REQUEST['feedback'];

$b .= "\n\nClick here: http://web.xat.com/report/transcript.php?i=".$_REQUEST['i']." to see a transcript of events.

For instant help with your chat box go here: http://xat.com/help

For other problems, comments or suggestions please use the xat community here: http://xat.com/community

:-)

xat.com

=== THIS IS AN AUTOMATED MESSAGE, PLEASE DO NOT REPLY ===

Ref:grp8" ;

$b = urlencode($b);

//if(strlen($_REQUEST['feedback']) > 10)
{
	$messgo = 'https://www20.ixat.io:10090/web_gear/chat/messgo8.php' ;
	
	$ip = getOurIp();

	$zz = DoCurl("$messgo?t=5&b=$b&to=$to&s=$s&e=$e&ip=$ip");
	// xat copy

	if(strpos($zz, 'GIT4561') === false) // no copy if git
	{
		$to = urlencode('x1go@xat.com');	
		$zz = DoCurl("$messgo?t=5&b=$b&to=$to&s=$s-$ip&e=$e");
	}
}

	echo'
<p>Thanks. Your message has been sent.</p>
';
EndHtml();
}

function EndHtml()
{
 $xAd=1; 
 include("/var/www/html/css/footer.php");

	exit(0);
}

function DoCurl($url)
{
//print "curl:$url\n";
	$ch = curl_init ();
	curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt ($ch, CURLOPT_URL, $url);
	curl_setopt ($ch, CURLOPT_TIMEOUT, 60);
	curl_setopt ($ch, CURLOPT_REFERER, $url);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
	curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
	$content = curl_exec ($ch);
	curl_close ($ch);

	return $content;
}

function send_mail($emailaddress, $fromaddress, $emailsubject, $body)
{
  $eol="\r\n";
 
  # Common Headers
  $headers .= 'From: xat<'.$fromaddress.'>'.$eol;
  $headers .= 'Reply-To: xat<'.$fromaddress.'>'.$eol;
  $headers .= 'Return-Path: xat<'.$fromaddress.'>'.$eol;    // these two to set reply address
  //$headers .= "Message-ID: <".time()."System@".$_SERVER['SERVER_NAME'].">".$eol;
  $headers .= "X-Mailer: PHP v".phpversion().$eol;          // These two to help avoid spam-filters

  # SEND THE EMAIL
  ini_set(sendmail_from,$fromaddress);  // the INI lines are to force the From Address to be used !
  mail($emailaddress, $emailsubject, $body, $headers);
  ini_restore(sendmail_from);
}

 function crcKw($num){
    $crc = crc32($num);
    if($crc & 0x80000000){
        $crc ^= 0xffffffff;
        $crc += 1;
        $crc = -$crc;
    }
    return $crc;
}

function getOurIp()
{
	$ip = $_SERVER['REMOTE_ADDR'];
	if(strlen($ip) < 1 || $ip === '127.0.0.1') // varnish stuff
		$ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
		
	return $ip;
}

function getIp()
{
	return getOurIp();
}
?>