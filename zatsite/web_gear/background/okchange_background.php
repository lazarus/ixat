<?php
session_start();

// Const
/*
  $root = 'http://www.xat.com/web_gear' ;

  limit ($_POST['width'], 50, 1024);
  limit ($_POST['height'], 50, 1024);
*/
?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<title>Update your xat free poll.</title>
<LINK REL="SHORTCUT ICON" href="<?php echo $root; ?>/poll/icon.ico">

<link type="text/css" rel="stylesheet" href="<?php echo $css; ?>">

</head>

<body>
<table border="0" cellpadding="3" cellspacing="0">
  <tr>
    <td align="left" bgcolor="#000080"><a href="http://www.xat.com/"><img src="../images/xat.gif" width="357" height="64" border="0"></a></td>
  </tr>
  <tr>
    <td align="left"></td>
  </tr>
  <tr>
    <td valign="top">
	<div class="sidebox">
      <div class="boxhead1">
        <h2>&nbsp;</h2>
      </div>
      <div class="boxright">
	  <div class="boxleft">
        <h3>change the background image </h3>
		<p>Click a thumbnail image below to use this as the background image.</p>
		<p>If you have changed your mind press the cancel button (do not press the browser back button).</p>
		<p>If you want to use your own image <a href="#urlimage">see below</a>. </p>
		<p>
<form name="form1" method="post" action="<?php echo $_SESSION['returncode1']; ?>">

<?php
foreach ($_POST as $i => $value) {

    if(!($i === 'ChangeBackground'))
        echo "<input type=hidden name=\"$i\" value=\"$_POST[$i]\">\n" ;
}


 $arr = array(
'xat_balls',
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
'xat_tree_line',
'xat_winter_holiday'
);

//echo '<table

  foreach ($arr as $value) {

    echo "<input type=image name=newimage_$value src=background/jdothumb/$value.jpg alt=\"Click to use this image ($value)\" WIDTH=150 HEIGHT=112 />\n";
  }
?>


<P>
<input type="submit" name="Submit" value="Cancel">
<P>
<a name="urlimage"></a>
<h3>use any  background image </h3>
		<p>You can use any background image by uploading it to your web site, to Imageshack or to Photobucket.</p>
		<p>To use<a href="http://www.imageshack.us/" target="_blank"> Imageshack click here</a> and copy the &quot;Direct link to image&quot; into the box below.</p>
		<p>To use <a href="http://www.photobucket.com/" target="_blank">Photobucket click here</a> and copy the &quot;Url&quot; into the box below.  </p>
		<p><input name="urlbackground" type="text" size="60" maxlength="255">
		<input type="submit" name="Submit" value="Submit">
		</p>
</form>		
            <div class="bodline">
		  </div>
	  </div>
      </div>
	  <div class="boxbody1">
	  </div>
</div>
<img src="../images/t.gif" width="1" height="1">
</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>


</body>
</html>
<?php exit ?>

