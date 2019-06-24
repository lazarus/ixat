<?php
require_once("/home/admin/cgi-bin/xatdata.php");
require_once('/home/admin/cgi-bin/xatchatmg.php');
//include('../web_gear/chat/connect2.php');
include('../web_gear/chat/CapNum.php');
require_once('/var/www/html/web_gear/chat/htmlhead.php');
$xp=array('ad'=>'top', 'title'=>'Report moderator', 'cache'=>3600, 'meta'=>array('xt'=>'chat,buy,login'), 'forcedom'=>'web.xat.com');//);

HtmlHead2();
$_REQUEST['g'] = mytrim(($_REQUEST['g']));
$_REQUEST['i'] = intval(rangetrim($_REQUEST['i'], '0-9', 99));
?>
<h1><span data-localize=chat.grassmod>Report moderator</span></h1>
<h3><span data-localize=buy.groupname>Group Name:</span> <?php echo $_REQUEST['g'];?></h3>
<div style="display:none">
<span data-localize=chat.grassmod>Report moderator</span>
<p><span data-localize=chat.feelunfair>If you feel you have been unfairly treated by a moderator you can report it to the owner of the group. Owners are not obliged to answer emails but they certainly won't if you don't provide a valid email address.</span></p>
<span data-localize=chat.grassmod>Report moderator</span>
<span data-localize=chat.thxsent>Thanks. Your message has been sent</span>
<?php echo GetString(''); ?>
</div>
<?php 
$EmailErr = $CapNumErr = '';
$_REQUEST['email'] = mytrim(($_REQUEST['email']));
$_REQUEST['feedback'] = mytrim(($_REQUEST['feedback']));
if($_REQUEST['submit'])// && $_REQUEST['email'] && )
{
	CheckReCapNum();
	preg_match('/([a-z_A-Z0-9\\-\\.]+\\@[a-zA-Z0-9\\-\\.]+)/', $_REQUEST['email'], $matches);
	$_REQUEST['email'] = $matches[0];

	if((strlen($_REQUEST['email']) > 0) && !isValidEmail($_REQUEST['email'])) $EmailErr = ErrHtml("<span data-localize=main.evalid>email is not valid</span>");
	
	
	if(!$EmailErr && !$CapNumErr) // all ok so far?
		DoIt();
}
echo "$DbErr $CapNumErr" ; 
?>
	
<p><span data-localize=chat.feelunfair>If you feel you have been unfairly treated by a moderator you can report it to the owner of the group. Owners are not obliged to answer emails but they certainly won't if you don't provide a valid email address.</span></p>

<form method="post" >
<input name="g" type="hidden" value="<?php echo $_REQUEST['g']; ?>" >
<input name="i" type="hidden" value="<?php echo $_REQUEST['i']; ?>" >
  <table>
<tr><td><p>Email:<?php echo $EmailErr; ?></p></td><td colspan="3"><input name="email" type="text" value="<?php echo ($_REQUEST['email']); ?>" size="60" maxlength="100" /></td><td><p>(<span data-localize=chat.optemail>Optional but you will not get a reply if this is not valid</span>)</p></td></tr>
<tr>
  <td><p><span data-localize=chat.message>Message</span>:</p></td><td colspan="4">
<textarea name="feedback" rows="20" cols="70" style="width:400px"><?php echo $_REQUEST['feedback']; ?></textarea>
</td></tr>
<tr><td></td><td>
<?php ReCapNumForm(); ?></td></tr>
</table>
<p>
<button name="submit" type="submit" id="submit" value="Send" class="btn"><i class="icon-envelope"></i>&nbsp;<span data-localize=chat.send>Send</span></button>  
</p>
</form>
<?php
EndHtml2();

function mytrim($s)
{
	$s = str_replace('<', ' ', $s);
	$s = str_replace('>', ' ', $s);
	$s = str_replace(';', ' ', $s);
	$s = str_replace('#', ' ', $s);
	$s = str_replace('%', ' ', $s);
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
	global $xatchat, $roomid, $roompass, $MGData;
	//global $_REQUEST;

	// Now look up
// TODO tidy name

	$NoGoogDb = true;
	$MGData = ReadMGData($id, $_REQUEST['g']);		

	if(!is_array($MGData))
	{
		$DbErr = ErrHtml("System problem (1). Please try later, sorry.");
		return;
	}

	$owner = explode(';=', $MGData['owner']);
	$owner = $owner[0];	
	$data = $MGData['data'];
	$t = explode(';=', $MGData['tags']);
	$_COOKIE['lang'] = $t[1]; // set lang to owner lang

$g = $_REQUEST['g'];
//$Subject = "xat chat group: $g - " . ($_REQUEST['GroupDescription']);

//use pair to send email

$to = urlencode($data);

$e = $_REQUEST['email'];

$s = urlencode(sprintf(GetString('chat.modrpt1'), $g));

$b = sprintf(GetString('chat.modrpt2'), "$owner,\n\n");

if(strlen($e) < 1) 
{
	$b .= "(".GetString('chat.noemail').")\n\n";
}
else
	$b .= "$e\n\n";

$e = 'noreply@xat.com' ;
$e = urlencode($e);

$b .= "\n";
$b .= htmlspecialchars_decode($_REQUEST['feedback']);

$b .= sprintf("\n\n".GetString('chat.modrpt3'), "http://web.xat.com/report/transcript.php?i=".$_REQUEST['i'])."\n\n";

$b .= GetString('login.forhelp')."\n\n".GetString('login.noreply');

$b = urlencode($b);

//if(strlen($_REQUEST['feedback']) > 10)
{
	$messgo = 'https://www1.ixat.io:10090/web_gear/chat/messgo8.php' ;
	
	$ip = getOurIp();

	$zz = DoCurl("$messgo?t=5&b=$b&to=$to&s=$s&e=$e&ip=$ip");
	// xat copy

	if(strpos($zz, 'GIT4561') === false) // no copy if git
	{
		$to = urlencode('info@xat.com');	
		$zz = DoCurl("$messgo?t=5&b=$b&to=$to&s=$s-$ip&e=$e");
	}
}

	echo'
<p><span data-localize=chat.thxsent>Thanks. Your message has been sent</span>.</p>
';
EndHtml2();
}

function DoCurl($url, $post)
{
//print "curl:$url\n";

	$ch = curl_init ();
	if(strpos($url, '?'))
	{
		$url = explode('?', $url, 2);
		$t = explode('&', $url[1]);
		$url = $url[0];
		$post = array();
		foreach($t as $v)
		{
			$v = explode('=', $v);
			$post[$v[0]] = urldecode($v[1]);
		}
	}
	curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt ($ch, CURLOPT_URL, $url);
	curl_setopt ($ch, CURLOPT_TIMEOUT, 60);
	curl_setopt ($ch, CURLOPT_REFERER, $url);
	if($post)
	{
		curl_setopt ($ch, CURLOPT_POST, 1);
		curl_setopt ($ch, CURLOPT_POSTFIELDS, $post);
	}
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

function GetString($str)
// Get string possibly in forign
{
	global $e_strings, $j_strings;
	$t = explode('.', $str);
	$file = $t[0];;
	$s = $t[1];
	if(!$e_strings) $e_strings = LoadEnglish();
	if($str==='') // dummy call only to return all
	{
		$t = '';
		foreach($e_strings as $k=>$v)
			$t .= "<span data-localize=$k>$v</span>\n";	
		return $t;
	}

	$r = $e_strings[$str];
	
	// read strings for sending mail
	if(!$j_strings[$file])
	{
		$lang = mytrim($_COOKIE['lang'], 3);
		if(strlen($lang) == 2 && $lang !== 'en')
		{
			$t = json_decode(file_get_contents("/tmp/lang/{$lang}_{$file}.json"), true); // use cached version on disk
			$j_strings[$file] = $t[$file];
		}
		if(!is_array($j_strings[$file])) $j_strings[$file] = true; // dont load again if fails
	}
	if(is_array($j_strings[$file]) && $j_strings[$file][$s]) $r = $j_strings[$file][$s];
	
	if($s === 'forhelp') $r = sprintf($r, 'http://xat.com/help_', 'http://xat.com/forum');
	
	return $r;
}

function LoadEnglish()
{
return 
array(
'login.forhelp' => 
'For instant help with your xat go here: %s

For other problems, comments or suggestions please use the xat community here: %s

xat
',

'login.noreply' =>
'=== THIS IS AN AUTOMATED MESSAGE, PLEASE DO NOT REPLY ===',

'chat.noemail' => 'The user did not supply their email address',
'chat.thxsent' => 'Thanks. Your message has been sent',
'chat.modrpt1' => 'xat group: %s - Moderator report',
'chat.modrpt2' => "Hello %s You have received this report about a moderator on your group",
'chat.modrpt3' => 'Click here: %s to see a transcript of events.'

);
}

function rangetrim($s, $ok, $maxlen)
{
	$s = trim($s);
	$s = preg_replace("/[^$ok]/i", '', $s); 
	if(strlen($s) > ($maxlen))
		$s = substr ($s, 0, $maxlen);
	return $s;
}

?>