<?php
error_reporting(E_ALL ^ E_NOTICE);
session_start();
$wa = array();
$ha = array();
$WebPageUrls = array();

?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<title>Change background image.</title>
<LINK REL="SHORTCUT ICON" href="http://www.ixat.io/web_gear/poll/icon.ico">
<link type="text/css" rel="stylesheet" href="http://www.xat.com/css/xat.css">
</head>

<body>

<TABLE cellSpacing=0 cellPadding=0 width="100%" background="http://www.xat.com/images/vbkbl.gif" border=0>
  <TBODY>
    <TR>
      <TD width="16" rowSpan=2>&nbsp;</TD>
      <TD width="138" height=90 rowSpan=2 vAlign=center><a href="http://www.xat.com"><IMG height=49 alt="xat - Get Connected..." src="http://www.xat.com/images/xatblk.gif" width=138 longDesc=http://www.xat.com></a></TD>
      <TD height=20 colspan="2" vAlign=center><DIV align=right><A class="topmenulink" 
      href="http://web.xat.com/wiki/index.php/Main_Page">Help</A>&nbsp;</DIV></TD>
      <TD width="16">&nbsp;</TD>
    </TR>
    <TR>
      <TD width="99%" valign="bottom" align="center">
	    <TABLE cellSpacing=0 cellPadding=0 width="448" border=0>
          <TBODY>
            <TR>
              <TD width="100" background="http://www.xat.com/images/mmtab.gif" height="28"><DIV align="center"><A 
            href="http://web.xat.com/chat_groups2.htm" class="tablink">Groups</A></DIV></TD>
              <TD width=16 height=28><DIV align=center></DIV></TD>
              <TD width=100 background="http://www.xat.com/images/mmtabw.gif" height=28><DIV align=center><A 
            href="http://www.xat.com/web_gear/" class="tablink">Widgets</A></DIV></TD>
              <TD width=16 height=28><DIV align=center></DIV></TD>
              <TD width=100 background="http://www.xat.com/images/mmtab.gif" height=28><DIV align=center><A 
            href="http://www.xatquiz.com/forum/forumdisplay.php?f=10" class="tablink">Community</A></DIV></TD>
              <TD width=16 height=28><DIV align=center></DIV></TD>
              <TD width=100 background="http://www.xat.com/images/mmtab.gif" height=28 class="tablink"><DIV align=center><A 
            href="http://www.xat.com/products.html">Applications</A></DIV></TD>
            </TR>
          </TBODY>
        </TABLE>
	  </TD>
      <TD width="1%" align="right">

<!-- SiteSearch Google -->
<form method="get" action="http://www.google.com/custom" target="google_window">
<table border="0">
<tr><td nowrap="nowrap" valign="top" align="left" height="32" width="15">
</td>
<td nowrap="nowrap">
<input type="hidden" name="domains" value="ixat.io"></input>
<label for="sbi" style="display: none">Enter your search terms</label>
<input type="text" name="q" size="31" maxlength="255" value="" id="sbi"></input>
<label for="sbb" style="display: none">Submit search form</label>
<input type="submit" name="sa" value="Google Search" id="sbb"></input></td>
<td>
<input type="radio" name="sitesearch" value="ixat.io" checked id="ss1"></input>
<label for="ss1" title="Search xat.com"><font size="-1" color="#FFFFFF">xat</font></label></td>
<td>
<input type="radio" name="sitesearch" value="" id="ss0"></input>
<label for="ss0" title="Search the Web"><font size="-1" color="#FFFFFF">web</font></label></td>
<td>
<input type="hidden" name="client" value="pub-3915747564069545"></input>
<input type="hidden" name="forid" value="1"></input>
<input type="hidden" name="channel" value="6645636414"></input>
<input type="hidden" name="ie" value="ISO-8859-1"></input>
<input type="hidden" name="oe" value="ISO-8859-1"></input>
<input type="hidden" name="cof" value="GALT:#008000;GL:1;DIV:#000080;VLC:663399;AH:center;BGC:FFFFFF;LBGC:000080;ALC:000080;LC:000080;T:000000;GFNT:0000FF;GIMP:0000FF;LH:50;LW:279;L:http://www.xat.com/images/xat.gif;S:http://;FORID:1"></input>
<input type="hidden" name="hl" value="en"></input></td></tr></table>
</form>
<!-- SiteSearch Google -->			
</TD>
    </TR>
  </TBODY>
</TABLE>

<br>

<div class="pad16">

<form name="form0" method="post" action="http://www.ixat.io/web_gear/background/change_background.php">
<?php
foreach ($_POST as $i => $value) {

    if(!($i === 'webackground'))
        echo "<input type=hidden name=\"$i\" value=\"$_POST[$i]\">\n" ;
}

if(strlen($_POST['searchbackground']) > 2) 
{
	$s = $_POST['searchbackground'];
    $s = str_replace ( '"', "", $s); // ditch any "
    $s = str_replace ( "'", "", $s); // ditch any '
    $s = str_replace ( ' ', "+", $s); // ditch any "
    $s = mysql_real_escape_string($s);
	//$s = 'http://images.google.com/images?imgsz=large&q=' . $s ;
	
	$s = 'http://search.msn.com/images/results.aspx?q=' .$s .'&imagesize=medium&mkt=en-US#imagesize=medium' ;
	
GetWebPageImages($s);
$_SESSION['WebPageUrls'] = $WebPageUrls;

$_POST['webbackground'] = "http://" ;
}

if(strlen($_POST['webbackground']) > 8) 
{
GetWebPageImages($_POST['webbackground']);
$_SESSION['WebPageUrls'] = $WebPageUrls;
//echo "hi " . $_POST['webbackground'] . " ". $WebPageUrls[0] . "<BR>";
}
else
$_POST['webbackground'] = "http://" ;

?>
        <h3>get a background image from the web </h3>
        <p>To grab an image from a web page enter the URL here and press the button. (e.g. http://www.mysite.com/mypics/index.html )<BR>
		<input name="webbackground" type="text" size="60" maxlength="255" value="<?php echo $_POST['webbackground']; ?>">
		<input type="submit" name="Submit1" value="Get more images"></p>
<p>To get images about something you like enter it here. (e.g. hot rods, horses)<BR>
		<input name="searchbackground" type="text" size="60" maxlength="255" value="<?php echo $_POST['searchbackground']; ?>">
		<input type="submit" name="Submit2" value="Get more images">
		</p>
</form>		
<form name="form1" method="post" action="<?php echo $_SESSION['returncode1']; ?>">
  <h3>use any  background image </h3>
		<p>You can use any background image by uploading it to your web site, to Imageshack or to Photobucket and enter the URL for the image in the box below.</p>
		<p>To use<a href="http://www.imageshack.us/" target="_blank"> Imageshack click here</a> and copy the &quot;Direct link to image&quot; into the box below.</p>
		<p>To use <a href="http://www.photobucket.com/" target="_blank">Photobucket click here</a> and copy the &quot;Url&quot; into the box below.  </p>
		<p><input name="urlbackground" type="text" size="60" maxlength="255">
		<input type="submit" name="Submit" value="Use this">
		</p>
<h3>use a solid color e.g. "Blue"</h3>
		<p>If you want to use an ordinary color type it into the box above and press the &quot;Use this&quot; button. You can use terms like light blue etc. You can also put in a HTML hex code, e.g. #0000FF</p>
		<h3>Click a thumbnail image below to use this as the background image.</h3>
		<p>If you have changed your mind press the cancel button (do not press the browser back button).
		<input type="submit" name="Submit" value="Cancel"></p>
		<p>

<?php
foreach ($_POST as $i => $value) {

    if(!(($i === 'ChangeBackground') || ($i === 'ChangeBackground_x')))
        echo "<input type=hidden name=\"$i\" value=\"$_POST[$i]\">\n" ;
}

 $arr = array(
'xat_drops',
'xat_rock1',
'xat_splash',
'xat_light',
'xat_globe',
'xat_circuit',
'xat_lime_splash',
'xat_rock2',
'xat_disco',
'xat_car',
'xat_jigsaw',
'xat_gears',
'xat_fireworks',
'xat_bauble',
'xat_snowman',
'xat_velvet',
'xat_bliss_like',
'xat_causeway',
'xat_drops_of_rain',
'xat_fallen_leaves',
'xat_flames',
'xat_green',
'xat_on_the_beach',
'xat_paper',
'xat_pebbles',
'xat_pool',
'xat_sand',
'xat_south_pacific',
'xat_stars',
'xat_winter_holiday',
'xat_tree_line',
'xat_metalglass',
'xat_cash',
'xat_jeans',
'xat_skin',
'xat_hearts',
'xat_balls',
'xat_beams'
);
$bz = 0;
  foreach ($WebPageUrls as $value) {
    $w = (int)$wa[$bz] ;
    $h = (int)$ha[$bz] ;
//print "$w $h ".$wa[$bz]." ".$ha[$bz]."<BR>";
    if ($w < 1 || $h < 1)
    {
       $w2=150; $h2=112;
    }
	else
	{
	   if($w/$h > 2)
	   {
	      $w2 = 112*2;
		  $h2 = $w2 * $h / $w;
	   } 
	   else
	   {
	     $h2 = 112;
		 $w2 = $h2 * $w / $h;
	   }
	}
    
    echo "<input type=image name=fromweb$bz src=\"$value\" alt=\"Click to use this image\" WIDTH=$w2 HEIGHT=$h2 />\n";
	$bz++;
  }

  foreach ($arr as $value) {

    echo "<input type=image name=newimage_$value src=http://www.ixat.io/web_gear/background/jdothumb/$value.jpg alt=\"Click to use this image ($value)\" WIDTH=150 HEIGHT=112 />\n";
  }
  
?>

<P>
<input type="submit" name="Submit" value="Cancel">
</P>
</form>		

</div>

<TABLE width="100%" border=0 cellpadding="0" cellspacing="0">
  <TBODY>
    <TR>
      <TD bgColor=#dedede height=36><P align=center>&copy;2007 xat - <A 
      href="http://www.xat.com/privacy.html">Privacy</A> - <A 
      href="http://www.xat.com/terms.html">Terms</A> - <A 
      href="http://www.xat.com/safety.html">Safety</A></P></TD>
    </TR>
  </TBODY>
</TABLE>

</body>
</html>
<?php exit;

function GetWebPageImages($webpage)
{
	global $WebPageUrls, $wa, $ha;
	$MaxAns = 30;
	
	//unset($WebPageUrls);
	//unset($wa);
	//unset($ha);
//$url = "http://www.xatquiz.com/" ;
//$url = "http://pic6.piczo.com/glamour-tanita/?g=648896&cr=6";

$url = $webpage;
trim($url);

// strip http://
$pos = strrpos($url, '://');
if ($pos !== false) 
	$url = substr($url, $pos+3);

$pos = strrpos($url, '/');
if ($pos === false) 
	$folder = $url . '/' ;
else
	$folder = substr($url, 0, $pos+1);

$pos = strpos($url, '/');
if ($pos === false) 
	$home = $url . '/' ;
else
	$home = substr($url, 0, $pos+1);

//    print "$url, $folder, $home<BR>\n";

$content="";
$ch = curl_init ();
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt ($ch, CURLOPT_URL, $url);
curl_setopt ($ch, CURLOPT_TIMEOUT, 60);
curl_setopt ($ch, CURLOPT_REFERER, $url);
$content = curl_exec ($ch);
curl_close ($ch);
//CURLOPT_HEADER and CURLOPT_HEADERFUNCTION

$pos = strpos($webpage, 'search.msn.com/images') ;

if( $pos !== false && $pos < 10) // msn image search
	return MsnImages($content, $MaxAns);

$tags = explode('<', $content);

$i = 0;
foreach($tags as $el)
{
    if(strcasecmp(substr($el, 0, 3), 'img') == 0) // got an image?
	{
	    preg_match('@width="?(\d*)@is', $el, $m);
    	$width = $m[1];
    	preg_match('@height="?(\d*)@is', $el, $m);
    	$height = $m[1];
    	preg_match('@src="?(.*?)["\s]@is', $el, $m);
    	$adr = $m[1];
	}
	else
	{
    	if(strcasecmp(substr($el, 0, 1), 'a') == 0) // link?
		{
	    	preg_match('@href="?(.*?)["\s]@is', $el, $m);
    		$adr = $m[1];
		}
		else
			continue;
	}
	
	if($width > 0 && $width < 20) continue;
	if($height > 0 && $height < 20) continue;
    if (!stristr($adr, '.jpg')) continue; // ignore if not a JPG
	if(strlen($adr) < 10) continue;
	
    if(strcasecmp(substr($home, 0, 13), 'images.google') == 0) // hack for google
	{
//print "$adr<BR>\n";
		$p = '@.*:(.*)@s' ;
    	preg_match($p, $adr, $m);
		$adr = 'http:' . $m[1];
	}

    if(strcasecmp(substr($adr, 0, 7), 'http://') != 0)
	{ // here if rel url
	    if(strcasecmp(substr($adr, 0, 1), '/') == 0) 
			$adr = 'http://' . $home . $adr;
		else
			$adr = 'http://' . $folder . $adr;
	}
	$wa[$i] = $width;
	$ha[$i] = $height;
//print "$width,$height,$adr,".$wa[$i].",".$ha[$i]."<BR>\n";
	$WebPageUrls[$i++] = $adr;
	if($i >= $MaxAns) break;
}
	return $i;
}
/*
<a href="details.aspx?q=shark&size=1p&ht=300&wd=250&tht=160&twd=133&su=http%3a%2f%2fnews.nationalgeographic.com%2fnews%2f2005%2f07%2f0701_050701_sharktagging.html&iu=http%3a%2f%2fnews.nationalgeographic.com%2fnews%2f2005%2f07%2fimages%2f050701_sharktagging2.jpg&tu=http%3a%2f%2ft1.images.live.com%2fimages%2fthumbnail.aspx%3fq%3d857503635810%26amp%3bid%3d6819ff11f4320cec246f64bf2e9fdc28&ti=050701_sharktagging2.jpg&ru=%2fimages%2fresults.aspx%3fq%3dshark%26imagesize%3dmedium%26mkt%3den-US%26setlang%3den-US%26setflight%3d0&sz=13" title="050701_sharktagging2.jpg">

*/
function MsnImages($content, $MaxAns)
{
	global $WebPageUrls, $wa, $ha;

//print "<pre>\n$content\n</pre>\n<BR>\n";
//return 0;

$tags = explode('href=', $content);

$tags[0] = '';

$i = 0;
foreach($tags as $el)
{
	$img = '';
   	$width = 0;
   	$height = 0;

	$args = explode('&', $el); // split into get args
	foreach($args as $el)
	{
		$bits = explode('=', $el); // split in two
		if($bits[0] === 'iu') $img = $bits[1];
		if($bits[0] === 'ht') $height = intval($bits[1]);
		if($bits[0] === 'wd') $width = intval($bits[1]);
	}
		
	$img = strtolower($img); 
// http%3a%2f%2fwww.wallsofthewild.com%2fshark.jpg

	if ( (preg_match( '/jpg$/', $img) == 1 ) && (preg_match( '/^http\%3a\%2f\%2f/', $img) == 1) ) // got a jpg image
	{
		$img = 'http://' . substr($img, 13);
    	$img = str_replace ( '%2f', '/', $img); // ditch any "
		if(strpos($img, '%') !== false) continue ; // junk if still has %

//print "<pre>\n".$img."\n</pre>\n<BR>\n";
		$wa[$i] = $width;
		$ha[$i] = $height;
		$WebPageUrls[$i++] = $img;
		if($i >= $MaxAns) break;
	}
}
return $i;
}
?>

