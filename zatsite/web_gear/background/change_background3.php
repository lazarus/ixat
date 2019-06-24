<?php
error_reporting(E_ALL ^ E_NOTICE);
//session_start();
include('background.php');
$wa = array();
$ha = array();
$WebPageUrls = array();
/*
print "\n<PRE>\n";
print_r($_POST);
print "\n</PRE>\n";
*/
$NoSearch = $NoSearch || $_POST['NoSearch'];
$NoSearch = false;

$NoXatImages = $NoXatImages || $_POST['NoXatImages'];
$SkipText = $SkipText || $_POST['SkipText'];

require_once('/var/www/html/web_gear/chat/htmlhead.php');
$xp=array('ad'=>'bot', 'title'=>'Change background image.', 'cache'=>3600, 'nores'=>1, 'meta'=>array('xt'=>'edit'));

HtmlHead2();
?>
<script type="text/javascript">
var seedurl="http://<?php echo $_SERVER["HTTP_HOST"]; ?>/web_gear/chat/photobucketcallback.html";
window.onload = function()
{
	loadiframe();
};

function loadiframe()
{
    nurl = escape(seedurl);
    document.getElementById('jwidget').src='http://photobucket.com/svc/jwidget.php?width=600&height=600&largeThumb=true&pbaffsite=342&bg=%23FFFFFF&border=true&bordercolor=%23000000&url=' + nurl + '&linkType=url&textcolor=%23FFFFFF&linkcolor=%230000FF&media=image&btntxt=Use this&searchenabled=true&searchlinkcolor=%23FFFFFF&searchbgcolor=%23000040';
}

function photobucket_complete(inurl, width, height)
{
    document.form1.i999.value = inurl;
	document.form1.fromweb999_x.value=1;
	document.form1.submit();
}
</script>
<?php  
// ?? if($NoHeader != true)
?>
<br>
<table border="0" cellpadding="16" cellspacing="0">
  <tr>
    <td valign="top" colspan="2">
<form name="form0" method="post" action="/web_gear/background/change_background3.php#searchweb">
<input name="NoXatImages" type="hidden" value="<?php echo $NoXatImages?1:0; ?>" />
<input name="SkipText" type="hidden" value="<?php echo $SkipText?1:0; ?>" />
<?php
// Use post value if present ...
EchoPosts(1);

$s = $_POST['ChangeBackground'] ;

//GetWebPageImages($s);
//$_SESSION['WebPageUrls'] = $WebPageUrls;
//$_SESSION['WebPageUrls'] = SmartBackground($s, 30, 30);
$WebPageUrls = SmartBackground($s, 30, 30);
//$_SESSION['WebPageUrls'] = $WebPageUrls;

if(!$SkipText) {
?>
	<h3 data-localize=edit.chgyourback>Change your Background Image</h3>
	<p>
<?php } ?>
	  <ul>
<?php
//		<li>Register with Photobucket and upload your own background image </li>
//		<li>Search Photobucket for a background image to use</li>
//		<li>Login and use a background image from Photobucket</li>
?>
<?php if(!$NoSearch) { ?>
		<li><a href="#searchweb"><span data-localize=edit.searchweb>Search the web for an  image</span></a></li>
<?php if(!$NoXatImages) { ?>
		<li><a href="#selectbackground"><span data-localize=edit.selectback>Select a default image</span></a></li>
<?php } ?>
<?php } ?>		
	  </ul>
	</p>
<?php if(0) { ?>		

		  <iframe src="" id="jwidget" bgcolor="transparent" width="620" height="630" frameborder="0" scrolling="no"></iframe>
        <div><a id="searchweb" name="searchweb"></a> <?php if(!$NoSearch) { ?><h3>Search the Web for a Background Image </h3><?php } ?> </div>
<?php } ?>		
<?php if(!$NoSearch) { ?>
        <p><span data-localize=edit.searchterm>Enter a search term or URL here and press the button. (e.g. cat, dog)</span><BR>
		<input name="ChangeBackground" type="text" size="60" maxlength="255" value="<?php echo htmlspecialchars($_POST['ChangeBackground']); ?>">
<button  type="submit" name="Submit1" value="1" class="btn"><i class=" icon-search"></i>&nbsp;<span data-localize=edit.getimg>Get Images</span></button> 		
        <img src="http://xat.com/images/pbgoogle.gif" width="101" height="18"></p>
		  
<a id="selectbackground" name="selectbackground"></a><h3 data-localize=edit.clkback>Click on an Image Below</h3>
<?php }

$returncode1 = preg_replace("@[^:/0-9a-z_\\.]@i", '', $_REQUEST['returncode1']); 
 ?>
</form>		
<form name="form1" method="post" action="<?php echo htmlspecialchars($returncode1); ?>">
<P>
<?php
EchoPosts(2);
if(!$NoSearch) {
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

	if(substr($value, 0 , 1) === '#')
	{
		$alt = htmlspecialchars($_POST['ChangeBackground']);
		$Name = substr($value, 1);
    	echo "<input  style=\"background-color:#$Name\" type=image name=color$Name src=\"http://xat.com/images/t.gif\" alt=\"$alt\" WIDTH=$w2 HEIGHT=$h2 />\n";
	}
	else
	{
		$Name = "fromweb$bz";
		if(substr($value, 0 , 7) !== 'http://')
		{
			if($NoXatImages) continue;
	    	$Name = "newimage_xat_$value";
			$value = "http://xat.com/web_gear/background/jdothumb/xat_$value.jpg" ;
		}
		else
	    	echo "<input type=hidden name=i$bz value=\"".urlencode($value)."\" />\n";

		$alt = substr($value,strrpos($value, '/')+1);
    	echo "<input type=image name=$Name src=\"$value\" alt=\"$alt\" WIDTH=$w2 HEIGHT=$h2 />\n";
	}
	$bz++;
  }
 }
?>
</p>
<P>
<input type=hidden name="i999" value="" >
<input type=hidden name="fromweb999_x" value="" >
<button  type="submit" name="Submit" value="1" class="btn"><i class=" icon-search"></i>&nbsp;<span data-localize=main.cancel>Cancel</span>
</button> 	
</P>
</form>		
</TD>
</TR>
</TABLE>
<?php

EndHtml2();

function EchoPosts($Type)
{
	global $NoSearch;
	
	if($NoSearch) $_POST['NoSearch'] = 1; // propogate

	foreach ($_POST as $i => $value) {

	if($Type == 2)
		$Skip = (substr($i,0,16) === 'ChangeBackground' || substr($i,0,7) === 'fromweb' || 
					substr($i,0,8) === 'newimage');
	else
		$Skip = ($i === 'ChangeBackground' || substr($i,0,7) === 'fromweb' || substr($i,0,8) === 'newimage');
	
		//if(substr($i, 0, 5) === 'media') { $_POST[$i] = urlencode($_POST[$i]); } // editgroup fix
	
		if(!$Skip)
		{
			if(substr($i, 0, 5) === 'media')
				echo 
	'<textarea style="display:none" name="'.htmlspecialchars($i).'" cols="1" rows="1">
	'.htmlspecialchars($_POST[$i]).'
	</textarea>
	';
			else
				echo "<input type=\"hidden\" name=\"".htmlspecialchars($i)."\" value=\"".htmlspecialchars($_POST[$i])."\">\n" ;
			
		}
	}
}

exit;
?>