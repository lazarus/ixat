<?php
die("Disabled for now");
error_reporting(E_ALL ^ E_NOTICE);

$a_BADXATSPACE = (1<<18);
$a_NO_SPEND = (1<<9);
$a_NO_PROMO = (1<<15);
$a_HAS_PROFILE = 32;
$a_TRANSFER_HELD = 64;
$a_TRUSTED		= 128;
$a_NO_TRANSFER = (1<<8);
$a_GIFT = (1<<24);
$a_NO_PROTECT = (1<<10);
$a_LOCKED = (1<<19);
$a_LOCKED2 = (1<<20);

// local $Flags
$f_Advanced = (1<<0);

//if($_SERVER["HTTP_HOST"] === 'chatsgroup.com') exit(0);

//if(($_POST['ChangeBackground'] === 'Choose background') || ($_POST['ChangeBackground_x'] > 0))
if($_POST['ChangeBackground2'] || $_POST['ChangeBackground3'])
{
	$_POST['BackSel'] = $_POST['ChangeBackground2'];
	$NoSearch = true; // clobber google image search
    //include('../background/change_background3.php');
}

$email = $_REQUEST['email'] = rangetrim($_REQUEST['email'], '^a-zA-Z0-9_', 256);
	
$root = 'http://ixat.io/web_gear';
// Flag bits
//$f_zzzz = 1;

// See if background was updated
if(strlen($_POST['urlbackground']) > 2) $_POST['background'] = $_POST['urlbackground'];
foreach ($_POST as $i => $value) {
    if(substr($i, 0, 9) === 'newimage_')
        $_POST['background'] = $root . '/background/' . substr(substr($i, 9),0, -2) . '.jpg'; // remove _x/y
    if(substr($i, 0, 7) === 'fromweb')
	{
		$t = urldecode($_REQUEST['i'. substr(substr($i, 7),0, -2)]); // remove _x/y
        if(strlen($t) > 0) $_POST['background'] = $t;
	}
    if(substr($i, 0, 5) === 'color')
        $_POST['background'] = '#'.substr($i, 5, 5+6);
}

if(strlen($_POST['background']) > 2) 
{
	if($_POST['BackSel'])
		$_REQUEST['back'] = $_POST['background'];	
	else	
		$_REQUEST['back3'] = $_POST['background'];	
}
	$flags = 0;
	$id = intval($_REQUEST['id']);
	$Token = mytrim($_REQUEST['Token'], 32);
	//$password = mytrim($_REQUEST['password'], 99);
	$Whiz = array(1,0); // default on, off

if(($_REQUEST['submit1'] || $_REQUEST['Pages'] || $_POST['returncode1'] ||
	$_REQUEST['Backup']) && !$_REQUEST['Restore'] )
{
	$name = mytrim($_POST['name'], 64);
	
	$Key = "chatu.user.$id.x";
	$TokenKey = "EditprofileToken.$Key";
	$TokenData = MemObj(0, $TokenKey)->get($TokenKey);
	
	if("$Token$name" !== $TokenData['Token'])
		ErrHtml("Update failed, please try again or try later. (1)");

	$HasMe = $TokenData["HasMe"]; // has power ?

	// add ok domains
	foreach($TokenData['Doms'] as $k => $v)
		$_SESSION['BadDomainsCache'][$k] = $v;
		
	if($id > 900000000) $NoGoogDb = true;
	$Profile = xatGet($Key);
	
	if($Profile === '#MISS' && $id < 900000000)
	{
		$xatReadGoog = true; // force try google
		$Profile = xatGet($Key);
	}
	if($Profile === '#FAIL')
	{
		header("Location: http://ixat.io/web_gear/maintenance.html");
		exit(0);
	}		

	GetInfo();

	//if($_POST['UserShow'] !== 'ON') $flags |= $f_NoUserShow; else $flags &= ~$f_NoUserShow ;
	
	$Whiz[0] = ($_POST['Whiz0'] === 'ON'); 
	$Whiz[1] = ($_POST['Whiz1'] === 'ON'); 
	
	//$Vars = $_REQUEST['Vars'];
	//$Vars = explode(';=', $Vars);
	//$Vars[0] = $_REQUEST['Lang'];

	//$FoundComments = ($flags & $f_NoComments) != 0;

	$media = array();
// tmp
if(strlen($_REQUEST["media"]) > 0) $_REQUEST["media0"] = $_REQUEST["media"];
// tmp
	$media[0] = CleanPost(urldecode($_REQUEST["media0"]), 20000);
	$media[1] = CleanPost1(urldecode($_REQUEST["media1"]), 40000);
	StripBadDomains3($media[0]);
	StripBadDomains3($media[1]);
	// was $back = CheckOneImage(mytrimback(($_REQUEST['back']), 512), 5);
	$back = mytrimback($_REQUEST['back'], $HasMe?10240:1024);
	StripBadDomains3($back);

	$back3 = CheckOneImage(mytrimback(($_REQUEST['back3']), 1024), 5);
	$OutWidth = intval($_REQUEST['OutWidth']);
	if($OutWidth > 5) $OutWidth = 5;
	$OutCol = GetColor($_REQUEST['OutCol']);
	if($OutCol[0] != '#') $OutCol = '#FFFFFF';
	$Album = ExtractAlbum($_REQUEST['Album']);
	$Album = urldecode(CleanPost($Album, 120));
	if(($_REQUEST["Advanced"] == "ON") && !$HasMe) $AdvancedErr = "<font color=red><span data-localize=buy.nome>You don't have the ME power</span></font>";
	$Flags = ($_REQUEST["Advanced"] == "ON") && $HasMe ? $f_Advanced : 0;
	
	$About = implode(';=', $media);
		
	$Vars = "$back;=$back3;=$OutWidth;=$OutCol;=$Album;=$Flags";
/////////////////////////////////////////////////////
// remove later	
    //$query = "REPLACE INTO Profiles SET ";
	//$query .= "About='".mysql_real_escape_string($About)."',";
	//$query .= "Back='".mysql_real_escape_string($Vars)."', Info='$Info'";
	//$query .= ", ID='$id'";//&&pin='$crcpw'";

	//if(!$result) ErrHtml("Update failed, please try later. (2)");
	
	//if(mysql_affected_rows() > 0)
	{
/////////////////////////////////////////////////////
		$AdStop = time()+2*24*3600; // 2 days
		if($Profile['NoAd'] > $AdStop) $AdStop = $Profile['NoAd'];
		$Profile = array('Info'=>$Info,'Back'=>$Vars,'About'=>$About, 'Name'=>$name, 'NoAd'=>$AdStop);
		xatPut($Key, $Profile);
	}
	// Store updates?
	if(!$TokenData['DoneUpdate'])
	{
		$TokenData['DoneUpdate'] = true; // only once
		$obj = array('time'=>time(), 'id'=>$id, 'action'=>"ProfileUpdate",'ip'=>getIp(), 'name'=>$name);
		LLogWrite($obj, 'general', 'temp');			
	}
	
	// BAD_PICS ?
	if(!empty($BadImageList2) && !$TokenData['DoneBadPics']) // bad domains!
	{
		$TokenData['DoneBadPics'] = true; // only once
		
		mail('x1go@ixat.io', "BAD_PICS_PROFILE $name ", 
			getIp()."\nhttp://xatspace.com/$name\nhttps://secure8.ixat.io:10090/web_gear/chat/editpro92475343.php?id=$id\n\n$BadDomainsList\n\nXatMailArchive\n\n".
			print_r($BadImageList2, true)."\n\n$t".			
			print_r($Profile, true));			
		
		$obj = array('time'=>time(), 'id'=>$id, 'action'=>"BadPic",'ip'=>getIp(), 'name'=>$name);
		if(!empty($BadImageList2))
		{
			$t = '';
			foreach($BadImageList2 as $k => $v)
			{
				if(strlen($k) < 256) $t= "$t;=$k";
				if(strlen($t) > 3000) break; // limit size
			}
			$obj['urls'] = $t;
		}
		LLogWrite($obj, 'general', 'temp');			
		
	}
	
	// Save known domains in memcache
	foreach($_SESSION['BadDomainsCache'] as $k => $v)
		$TokenData['Doms'][$k] = $v;
		
	if(!MemObj(0, $TokenKey)->set($TokenKey, $TokenData, 3600))
		ErrHtml("Update failed, please try again or try later. (2)");
	
//		print "$query<BR>\n";
	
	if($_REQUEST['Backup']) Backup($mediaAll);
}
else
if($_REQUEST['SubmitPass'])// || $_REQUEST['password'])
{
	$_SESSION['BadDomainsCache'] = array(); // start again
	CheckEmailPass();
    $query = "SELECT id,pw,data,name from RegUser WHERE name='$email'";// && pin='$crcpw'";

    $result = mysql_query($query,$xatchat) ;
//print "<BR>$query<BR>$result<BR>\n";
	
	if(!$result || (mysql_numrows($result) < 1)) ErrHtml("<span data-localize=buy.notfound>not found</span>");
    $pw = mysql_result($result,0,"pw");
    $id = mysql_result($result,0,"id");
    $data = mysql_result($result,0,"data");
    $name = mysql_result($result,0,"name");
	
	if($crcpw != $pw) ErrHtml("<span data-localize=buy.wrongpassword>Wrong password</span>");

	$DataS = explode(';', $data);
	for($z=0; $z<4; $z++)
		$DataS[$z] = intval($DataS[$z]);
	
	if(($DataS[3] & ($a_LOCKED|$a_LOCKED2) || !($DataS[3] & $a_NO_PROTECT)) &&
	uIntIp() != $DataS[7])	
		ErrHtml('Please <a href="http://ixat.io/login">login</a> before editing your profile');

	if(($DataS[3] & $a_BADXATSPACE) === $a_BADXATSPACE)
		ErrHtml("<span data-localize=edit.problkd>Profile is blocked.</span>");
			
	$Token = GenCoupon(18);
	
	GetInfo();
	
	$t ='';
	if(strlen($Info) > 10) 
	{
		if($id == intval($Info)) // only if same id
			$t = ",Info='".mysql_real_escape_string($Info)."' "; // not used ?
		else 
			$Info = '';
	}
	else $Info = '';
	
	$Key = "chatu.user.$id.x";
	$TokenKey = "EditprofileToken.$Key";
	
	$row = xatGet($Key);

	if($row === '#FAIL')
		ErrHtml("Edit profile is closed for updating. Please try later (3).");

	if($row['Info'] === '#BAD' || $row['Bad'] == 1)
		ErrHtml("Your profile is blocked.");
		
	if($row === '#MISS' || $row['timestamp'] < 1301135300) // try www1
	{
		$xatchat2 = mysql_connect("www1.ixat.io", "rem", "remuser101");
		mysql_select_db("comments", $xatchat2);
	
		$query = "SELECT Info,Back,About FROM Profiles WHERE id=$id";
		$result = mysql_query($query, $xatchat2) ;
		//print "Read from SQL<BR>\n";
	//print "<BR>$query<BR>$result<BR>";
		if(!$result) ErrHtml("Edit profile is closed for updating. Please try later (5).");
		if(mysql_numrows($result) > 0)
		{
			$row = mysql_fetch_assoc($result);
		}
		else
			$row = array("Info"=>'', "Back"=>'', "About"=>'');
	
		mysql_close($xatchat2);
		mysql_select_db("chat_count", $xatchat);
	}

	if(!empty($Info)) $row["Info"] = $Info;
	$Info  = $row["Info"];
    $media = explode(';=', $row["About"]);
    $Vars = $row["Back"];
	$Vars = explode(';=', $Vars);
	$back = $Vars[0];
	$back3 = $Vars[1];
	$OutWidth = $Vars[2];
	$OutCol = $Vars[3];
	$Album = $Vars[4];
	$Flags = intval($Vars[5]);
	$Whiz = array(1,0); // default on, off

	// Now update the got profile bit
	//if(strlen($media[0]) > 5) 
	{
		if(($DataS[3] & $a_HAS_PROFILE) == 0) // not allready set ?
		{
			$DataS[3] = $DataS[3] | $a_HAS_PROFILE; // Add got a profile
			$DataNew = implode(';', $DataS);
			$query = "UPDATE RegUser SET data='$DataNew'  WHERE id='$id' && data='$data'";
			$result = mysql_query($query,$xatchat) ;
			$Login = 1; // force login
		}
	}
	// get original domains
	$t = array_merge(GetDomains($Info), GetDomains($row["About"]), GetDomains($row["Back"]));
	$a = array();
	foreach($t as $k => $v)
		$a["IsBadDom$k"] = $v; // add the stupid thing

	$me = 349;
	$pow = explode('|', $DataS[5]);
	$HasMe = ($pow[$me>>5] & (1<<($me % 32))) != 0; //has me power?

	// stash token and original domains
	MemObj(0, $TokenKey)->set($TokenKey, array("Token"=>"$Token$name", "Doms"=>$a, "HasMe"=>$HasMe), 3600);
}
else
	ErrHtml(""); // Password

	$Advanced = $Flags & $f_Advanced;
	if($Advanced)
	{
		$Album = 
		$media[0] = "";
	}

	HtmlHead2();
?>
<script language="JavaScript"><!--
function jsBackground() {
	document.Main1.ChangeBackground2.value = 1;
	document.Main1.submit();
}
function jsBackground3() {
	document.Main1.ChangeBackground3.value = 1;
	document.Main1.submit();
}
<?php
if(!empty($BadImageList))
{
	echo "alert('Sorry, the following images are not allowed (unapproved domain):\\n\\n";
	$n=0;
	foreach($BadImageList as $k => $v)
	{
		echo "$k\\n";
		$n++;
		if($n > 35)
		{
			echo "More images were not listed...";
			break;
		}
	}
	echo "\\n\\nPlease use Tinypic, Photobucket or Imageshack');\n";
	$t = '';
	foreach($BadImageList as $k => $v) $t .= "$k\n";
	//file_put_contents('/tmp/z.z', $t, FILE_APPEND);
}
?>
//-->
</script>
<?php
if($Whiz[0] || $Whiz[1])
{
	if($_COOKIE['lang'] !== 'en')
	{
		$t = array('da'=>'DK', 'de'=>'DE', 'es'=>'ES', 'fi'=>'FI', 'fr'=>'FR', 'it'=>'IT', 'nl'=>'NL', 'nn'=>'NO', 'sv'=>'SE', 'zh'=>'CHS');
		$c = $t[$_COOKIE['lang']];
		if($c) echo '<script language="Javascript" src="/cgi-bin/innov2/scripts/language/'.$_COOKIE['lang'].'-'.$c.'/editor_lang.js"></script>'."\n";
	}
	echo '<script language="javascript" type="text/javascript" src="/cgi-bin/innov2/scripts/innovaeditor.js"></script>'."\n";
}
?>
<?php 
if($Login) echo Embed();
?>
<h3><span data-localize=edit.editpro>Edit your profile</span></h3>
<div style="display:none">
<span data-localize=edit.problkd>Profile is blocked.</span>
<span data-localize=edit.uploadsearch>Upload or search for image</span>
<span data-localize=edit.aboutbkg>About Background - optional (URL):</span>
<span data-localize=buy.notfound>not found</span>
<span data-localize=buy.wrongpassword>Wrong password</span>
<span data-localize=edit.urlcss>Optional (URL or background CSS)</span>
<span  data-localize=edit.album>Enter an address of a picture from a <a href="http://photobucket.com">Photobucket</a> album</span>
<span  data-localize=edit.color>Color</span>
<span  data-localize=edit.width>Width</span>
<span  data-localize=edit.outline>About outline</span
><span  data-localize=edit.colinfo>Color or hex code e.g. #FF00FF</span>
<span data-localize=edit.albopt>Picture album - optional</span>
<span data-localize=edit.wysiwyg>Check this box to use WYSIWYG editing</span>
<span data-localize=buy.nome>You don't have the ME power</span>
</div>

<form enctype="multipart/form-data" name="Main1" method="post" >
<input name="returncode1" type="hidden" value="http://ixat.io/web_gear/chat/editprofile.php" > 
<input name="id" type="hidden" value="<?php echo $id;?>">
<input name="Token" type="hidden" value="<?php echo $Token;?>">
<input name="Info" type="hidden" value="<?php echo $Info;?>">
<input name="name" type="hidden" value="<?php echo $name;?>">
<input name="Flags" type="hidden" value="<?php echo $Flags;?>">
<table>
<tr>
  <td><p><span data-localize=edit.advanced>Advanced mode (requires ME power)</span>:</p></td><td>
	<input class="xcheck" name="Advanced" type="checkbox" value="ON" 
	<?php if ($Advanced) echo ' checked' ;?> >&nbsp;<?php echo $AdvancedErr; ?>
  </td>
</tr>
<tr>
  <td><p><span data-localize=edit.urlcss>Optional (URL or background CSS)</span>:<?php echo $BackErr; ?></p></td>
  <td><input name="back" type="text" value="<?php echo ($back); ?>" size="60" maxlength="<?php echo $HasMe?10240:1024; ?>" />
  <a href="http://util.ixat.io/wiki/index.php?title=CSS_Guidelines" target="_blank">Rules</a>
  </td><td>
<?php if(!$Advanced) { ?>
  <input name="ChangeBackground2" type=hidden value="0"  />
  <button onClick="jsBackground()" class="btn"><i class=" icon-picture"></i>&nbsp;<span data-localize=edit.uploadsearch>Upload or search for image</span></button> 
<?php } ?>
  </td>
</tr>
<?php if(!$Advanced) { ?>
<tr>
  <td><p><span data-localize=edit.aboutbkg>About Background - optional (URL):</span><?php echo $BackErr3; ?></p></td>
  <td><input name="back3" type="text" value="<?php echo ($back3); ?>" size="60" maxlength="1024" /></td><td>
  <input name="ChangeBackground3" type=hidden value="0"  >
  <button  onClick="jsBackground3()" class="btn"><i class=" icon-picture"></i>&nbsp;<span data-localize=edit.uploadsearch>Upload or search for image</span></button> 
  </td>
</tr>
<tr><td></td>
  <td colspan="2"><p>
<span  data-localize=edit.imagesmust>Note: Images must be on <a target="_blank" href="http://tinypic.com">tinypic</a>, <a target="_blank" href="http://photobucket.com">photobucket</a> or <a target="_blank" href="http://imageshack.us">imageshack</a>
  </p></td>
</tr>
<tr>
  <td><p><span  data-localize=edit.outline>About outline</span>:<?php echo $BackErr3; ?></p></td>
  <td colspan="2"><span  data-localize=edit.width>Width</span>:<input name="OutWidth" type="text" value="<?php echo $OutWidth; ?>" size="1" maxlength="1" /> (0-5)
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span  data-localize=edit.color>Color</span>:<input name="OutCol" type="text" value="<?php echo $OutCol; ?>" size="10" maxlength="30" /> (<span  data-localize=edit.colinfo>Color or hex code e.g. #FF00FF</span>)</td>
</tr>
<tr>
  <td><p><span data-localize=edit.albopt>Picture album - optional</span><?php echo $BackErr4; ?></p></td>
  <td><input name="Album" type="text" value="<?php echo ($Album); ?>" size="60" maxlength="100" /></td><td>
  <span  data-localize=edit.album>Enter an address of a picture from a <a href="http://photobucket.com">Photobucket</a> album</span>.
  </td>
</tr>
<?php } ?>
</table>
<?php if(!$Advanced) { ?>
<span  data-localize=edit.enterstuff>Enter stuff for the about me section of your profile (simple html is allowed)</span>
<input class="xcheck" name="Whiz0" type="checkbox" value="ON" 
<?php if ($Whiz[0]) echo ' checked' ;?> >
<span data-localize=edit.wysiwyg>Check this box to use WYSIWYG editing</span><BR>
<textarea id="media0" name="media0" rows=<?php echo $Whiz[0]?28:20; ?> style="width:90%">
<?php
if($Whiz[0])
	echo encodeHTML(stripslashes($media[0]));
else
	echo $media[0];
?>
</textarea>
<?php
if($Whiz[0])
echo '
<script language="javascript" type="text/javascript">
	var oEdit1 = new InnovaEditor("oEdit1");
	oEdit1.width = "100%";
	oEdit1.height = 500;
		
    oEdit1.groups = [
        ["group1", "", ["FontName", "FontSize", "Superscript", "ForeColor", "BackColor", "FontDialog", "LTR", "RTL", "BRK", "Bold", "Italic", "Underline", "Strikethrough", "TextDialog","CompleteTextDialog", "Styles", "RemoveFormat"]],
        ["group2", "", ["JustifyLeft", "JustifyCenter", "JustifyRight", "Paragraph", "BRK", "Bullets", "Numbering", "Indent", "Outdent"]],
        ["group3", "", ["Table","TableDialog", "Emoticons",  "BRK",  "ImageDialog"]],
        ["group4", "", ["CharsDialog", "BRK", "Line"]],
        ["group5", "", ["SearchDialog", "SourceDialog", "BRK", "Undo", "Redo", "FullScreen"]]
        ];	//"FlashDialog",, "YoutubeDialog", "CustomObject", "CustomTag", "MyCustomButton""InternalLink", "LinkDialog",	
		
	oEdit1.css = "/cgi-bin/innov2/styles/default.css";
	oEdit1.REPLACE("media0");
</script>
';
?>
<BR>
<?php } ?>
<span data-localize=edit.mediastuff>Enter stuff for the media box of your profile (simple html and embeds are allowed)</span>
<input class="xcheck" name="Whiz1" type="checkbox" value="ON" 
<?php if ($Whiz[1]) echo ' checked' ;?> >
<span data-localize=edit.wysiwyg>Check this box to use WYSIWYG editing</span><BR>
<textarea id="media1" name="media1" rows=<?php echo $Whiz[1]?28:20; ?> style="width:90%">
<?php
if($Whiz[1])
	echo encodeHTML(stripslashes($media[1]));
else
	echo $media[1];
?>
</textarea>
<?php
if($Whiz[1])
echo '
<script language="javascript" type="text/javascript">
	var oEdit2 = new InnovaEditor("oEdit2");
	oEdit2.width = "100%";
	oEdit2.height = 500;
		
    oEdit2.groups = [
        ["group1", "", ["FontName", "FontSize", "Superscript", "ForeColor", "BackColor", "FontDialog", "LTR", "RTL", "BRK", "Bold", "Italic", "Underline", "Strikethrough", "TextDialog","CompleteTextDialog", "Styles", "RemoveFormat"]],
        ["group2", "", ["JustifyLeft", "JustifyCenter", "JustifyRight", "Paragraph", "BRK", "Bullets", "Numbering", "Indent", "Outdent"]],
        ["group3", "", ["Table","TableDialog", "Emoticons",  "BRK",  "ImageDialog"]],
        ["group4", "", ["CharsDialog", "BRK", "Line"]],
        ["group5", "", ["SearchDialog", "SourceDialog", "BRK", "Undo", "Redo", "FullScreen"]]
        ];	//"FlashDialog",, "YoutubeDialog", "CustomObject", "CustomTag", "MyCustomButton""InternalLink", "LinkDialog",	
		
	oEdit2.css = "/cgi-bin/innov2/styles/default.css";
	oEdit2.REPLACE("media1");
</script>
';
?>
<BR>
<button type="submit" name="submit1"  value="1" class="btn"><i class=" icon-ok"></i>&nbsp;<span data-localize=edit.savechanges>Save changes</span></button> 
<!--
<input type="submit" value="Backup profile" name="Backup">
<input type="hidden" name="MAX_FILE_SIZE" value="66000" />
File to restore from: <input name="restorefile" type="file" />
<input type="submit" value="Restore" name="Restore">
-->
</form>
(<span data-localize=edit.mins10>View changes, changes may take up to 30 mins to go live</span>)
<BR />
<button onClick="window.open('http://me.ixat.io/xatprofile.php?i=<?php echo "$id&t=".time(); ?>','preview','toolbar=1,resizable=1,scrollbars=1')" class="btn"><i class=" icon-eye-open"></i>&nbsp;<span data-localize=edit.viewchanges>View changes</span></button> 
<?php
EndHtml2();

function rangetrim($s, $nok, $maxlen)
{
	$s = trim($s);
	$s = preg_replace("/[$nok]/i", '', $s);
	$s = preg_replace('/[\x00-\x1F\x7F]/', '', $s); // junk control chars
	if(strlen($s) > ($maxlen))
		$s = substr ($s, 0, $maxlen);
	return $s;
}

function mytrim($s, $len)
{
	$s = str_replace('<', ' ', $s);
	$s = str_replace('>', ' ', $s);
	$s = str_replace(';=', '', $s);
	$s = str_replace(';', '', $s);
	$s = str_replace('&', '', $s);
	$s = str_replace("'", '', $s);
	$s = str_replace('"', '', trim($s));
	if(strlen($s) > ($len-1))
		$s = substr ($s, 0, $len-1);
	return $s;
}

function mytrimInfo($s, $len)
{
	$s = str_replace('<', ' ', $s);
	$s = str_replace('>', ' ', $s);
	$s = str_replace("'", '', $s);
	$s = str_replace('"', '', trim($s));
	if(strlen($s) > ($len-1))
		$s = substr ($s, 0, $len-1);
	return $s;
}

function mytrimmedia($s, $len)
{
	$s = str_replace(';=', '', $s);
	if(strlen($s) > ($len-1))
		$s = substr ($s, 0, $len-1);
	if(substr($s, 0, 7) === 'http://')
		return CleanUrl($s);
	return $s;
}

function CleanUrl($s)
{
	$myFilter = new InputFilter();
	$s =  $myFilter->process($s);
	$s = preg_replace('/\\s.*/', '', $s); // stip anything after whitespace
	$s = preg_replace('/[^:a-zA-Z0-9-_~\\?=\\/\\.#%]/', '', $s);
	return $s;
}

function CleanPost($s, $len)
{

	if(strlen($s) > ($len-1))
		$s = substr ($s, 0, $len-1);
		
	$tags = array("style","em", "strong", "h1", "h2", "h3", "h4", "h5", "h6", "p", "img", "a", "b", "br","span","div","li","ul","ol","hr","table","tr","td");
	$attributes = array("src", "href","style");//,"background","border");
	
	$myFilter = new InputFilter($tags, $attributes,0,0,0);
	$s =  $myFilter->process($s);
	return CleanPostCommon($s);
}

function CleanPost1($s, $len) // media box
{

	if(strlen($s) > ($len-1))
		$s = substr ($s, 0, $len-1);
		
	$tags = array("style","em", "strong", "h1", "h2", "h3", "h4", "h5", "h6", "p", "img", "a", "b", "br","span","div","li","ul","ol","hr","table","tr","td", "embed");
	$attributes = array("src", "href","style",
"quality","bgcolor","FlashVars","WIDTH","HEIGHT","ALIGN","NAME","AUTOSTART","type");
//"allowScriptAccess","pluginspage","PLUGINSPAGE","PLUGINURL","HIDDEN","HREF","TARGET",
//"LOOP","PLAYCOUNT","VOLUME","CONTROLS","CONTROLLER","MASTERSOUND","STARTTIME","ENDTIME",
//,"background","border");
	
	$myFilter = new InputFilter($tags, $attributes,0,0,0);
	$s =  $myFilter->process($s);
	return CleanPostCommon($s);
}

function CleanPostCommon($s)
{
	/*
	preg_match('=<a.*?<img=is', $s, $m); // get links
	foreach ($m as $v)
	{
		if(!preg_match('=</a=is', $v) || preg_match('=</a.*[\'"]=is', $v))
			$s = str_replace($v, ' Links cannot contain images ', $s);
	}
	*/
	$s = str_replace('\0', 'nope', $s);
	$s = str_replace('/*', 'nope', $s);
	$s = str_replace('*/', 'nope', $s);
	$s = preg_replace('/body/i', 'b0dy', $s);
	$s = preg_replace('/\\beval\\b/i', 'nope', $s);
	//$s = preg_replace('/\\bdiv\\b/i', 'block', $s);
	$s = preg_replace('/html/i', 'htmI', $s);
	$s = preg_replace('/script/i', 'nope', $s);
	$s = preg_replace('/<style/i', 'nope', $s);
	$s = preg_replace('/\\son(mouse|blur|change|click|contextmenu|copy|cut|dblclick|focus|hashchange|key|paste|reset|resize|scroll|select|submit|textinput|unload|wheel)/i', ' nope', $s);
	
//$s = preg_replace('=///+=', '', $s);
	$s = preg_replace('=[\w:\s]*///*=i', 'http://', $s); // get rid of http:, ftp etc
	//$s = str_replace('///', 'nope', $s);
	$s = preg_replace('=<style />=i', 'nope', $s);
	$s = preg_replace('/(margin[\-a-z]*?\s*?:|position\s*?:|firefox-view|z-index|xatsty|display\s*?:\s*none|visibility\s*?:\s*?hidden|width\s*?:|height\s*?:|@import|transform\s*?:|transition\s*?:|filter\s*?:|opacity)/i', 'NotAllowed', $s);
	$s = str_replace('pw=', 'PW=', $s);
	$s = str_replace('xc=', 'XC=', $s);
	$s = str_replace('em=', 'EM=', $s);
	$s = str_replace('nooway', 'noway', $s);
	
	return $s;
}
function mytrimback($s, $len)
{
	if(strlen($s) > ($len-1))
		$s = substr ($s, 0, $len-1);
		
	$s = preg_replace('/import/i', 'imp0rt', $s);
	$s = str_replace('nooway', 'noway', $s);
		
	if(substr($s, 0, 7) === 'http://')
		return CleanUrl($s);

	if(preg_match_all('@background[^<>]*?;@is', $s, $m, PREG_PATTERN_ORDER))
	{
		$myFilter = new InputFilter();
		$m[0] = $myFilter->process($m[0]);
		$s = implode(" ", $m[0]);
		return $s;
	}	
	else return '';	
}

function ErrHtml($s)
{
global $email,$Info;

if(empty($Info)) GetInfo();

HtmlHead2();

echo'
<h3><span data-localize=edit.editpro>Edit your profile</span></h3>
';
if(strlen($s) > 0)
	echo '<p style="color:#FF0000"><strong>**'. "$s**</strong></p> \n" ;
echo'
<form name="Pass" method="post">
<input name="Info" type="hidden" value="'.$Info.'">
<p><span data-localize=buy.xatname>xat user name:</span> <input name="email" type="text" value="'.$email.'" size="60" maxlength="60" /></p>  
<label><p><span data-localize=buy.password>Password:</span>
  <input name="password" type="password" size="32" maxlength="64">
  </label>
<br><button type="submit" name="SubmitPass" value="1" class="btn"><i class=" icon-wrench"></i>&nbsp;<span data-localize=main.submit>Submit</span></button>   
</form>
<div class="bodline">
</div>
';
EndHtml2();
}

function CheckEmailPass()
{
	global $password, $email, $crcpw;

	$password = mytrim($_REQUEST['password'],99);
	$crcpw = crcKw($password);
	$email = mytrim($_REQUEST['email'],128);
	
	//preg_match('/([a-z_A-Z0-9\\-\\.]+\\@[a-zA-Z0-9\\-\\.]+)/', $email, $matches);
	//$email = $matches[0];
}

function Backup($media)
{
	global $GroupName;
	$fsize = strlen($media);
	header("Content-type: application/octet-stream");
	header("Content-Disposition: filename=\"$GroupName.xatg\"");
    header("Content-length: $fsize");
    header("Cache-control: private"); //use this to open files directly
    echo $media;
	exit(0);
}

function Restore($V)
{
	$fn = $_FILES['restorefile']['tmp_name'];
	if(filesize($fn) > 65000 || filesize($fn) == 0) return $V;
	return file_get_contents($fn);
}

function GenCoupon($len)
// rand string, length $l
{
	$s = '';
	$let = array('1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','J','K','L',
		'M','N','P','Q','R','S','T','V','W','X','Y','Z');
	$c = count($let) - 1;
		
	for($n=0; $n< $len; $n++)
		$s .= $let[rand(0, $c)];
	return $s;
}

function Embed()
{
	//xc=512&
	$fv = 'id=9&pw=##' ;
	
	$embed = '<embed src="http://www.ixat.io/web_gear/chat/chat.swf" quality="high" width="1" height="1" name="chat" FlashVars="'.$fv.'" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://ixat.io/update_flash.php" />';

	return $embed;	
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

function encodeHTML($sHTML)
{
$sHTML=preg_replace("/&/","&amp;",$sHTML);
$sHTML=preg_replace("/</","&lt;",$sHTML);
$sHTML=preg_replace("/>/","&gt;",$sHTML);
return $sHTML;
}

function ExtractAlbum($Album)
{
	// photobucket.com/albums/j131/chrisrixon/doodles/
	
	$Album = trim($Album);
	
	if (!preg_match('=photobucket.com/albums/\w+/([^\?$& <>\'"]+)=i', $Album, $m)) return $Album;
	
	if(strpos($m[1], '.') === false)
		return trim($m[1], '/');
	else
	{
		if(($p = strrpos($m[1], '/')) === false) return '';
		return substr($m[1], 0, $p);
	}
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

function uIntIp()
// get our ip as sock style reversed unsigned word
{
	$ip = RawIp();
	if($ip >= 0) return $ip;
	
	$ip += (float)"4294967296";
	
	return (string)$ip;
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

function GetInfo()
{
	global $Info;
	$Info = mytrimInfo($_POST['Info'], 2000);
	StripBadDomains3($Info);
}
?>