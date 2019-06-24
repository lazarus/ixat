<?php
error_reporting(E_ALL ^ E_NOTICE);
include('connect.php');

  $root = 'http://www.ixat.io/web_gear' ;


function MakeObject($w, $h, $id, $demo, $back, $pass, $obj)
{
    global $root;
    global $portrait;

    $h = intval($w * 3 / 4 + 0.5 );
    if($portrait)
    {
        $h = 350;
        $w = 160;
    }
    
    if(substr($back, 0, 1) != '#') $back = '#000000';
    $back = substr($back, 0, 7);
    $param = "poll.swf" ;
    if($portrait)
        $param = "pollv.swf" ;
    $vars = "\"id=$id\"" ;
    //if ($demo) $param .= "&demo=$demo" ;
    //if (strlen($pass) == 5) $param .= "&pass=$pass" ;
    $s = '';

    if ($obj)
    {
    $s = '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" width=';
    $s .= "$w height=$h id=poll align=middle>\n";
    $s .= '<param name="allowScriptAccess" value="sameDomain" />' . "\n";
    $s .= "<param name=movie value=$root/poll/$param /><param name=quality value=high />";
    $s .= "<param name=bgcolor value=$back />\n";
    $s .= "<param name=FlashVars value=$vars />\n";
    }
    $s .= "<embed src=$root/poll/$param quality=high bgcolor=$back width=$w height=$h name=poll " ;
	$s .= "FlashVars=$vars ";
    $s .= 'align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.xat.com/update_flash.shtml" />' . "\n";
    if ($obj)
    $s .= '</object>' . "\n" ;

    return $s;
}



?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<title>xatpoll: Update your free xat poll.</title>
<LINK REL="SHORTCUT ICON" href="<?php echo $root; ?>/poll/icon.ico">

<link type="text/css" rel="stylesheet" href="../../css/style.css">

</head>

<body>
?l=n dump last n polls<br>
?d=1 to display polls <br>
<table border="0" cellpadding="3" cellspacing="0">
  <tr>
    <td bgcolor="#000080">&nbsp;</td>
    <td align="left" bgcolor="#000080"><a href="http://www.xat.com/"><img src="../../images/xat.gif" width="357" height="64" border="0"></a></td>
  </tr>
  <tr>
    <td><img src="../images/t.gif" width="3" height="3"></td>
    <td align="left"></td>
  </tr>
  <tr>
    <td valign="top">
	<div class="sidebox">
      <div class="boxhead1">
        <h2>&nbsp;</h2>
      </div>
      <div class="boxbody1">
	  <DIV class="nav" >
        <ul>
<li><a href="http://www.xat.com/">home</a>
<li class="nav2"><a href="poll.php">free poll</a>
<li><a href="../products.html">products</a>
<li><a href="../internet_technology/download.html">download</a>
<li><a href="../internet_technology/index.html">company</a>
<li><a href="../internet_technology/index.html#contact">contact&nbsp;us</a>
<li><a href="../internet_technology/index.html#privacy">privacy&nbsp;policy</a>
</ul>
 
</DIV>
      </div>
</div>
	</td>
    <td valign="top">
	<div class="sidebox">
      <div class="boxhead1">
        <h2>&nbsp;</h2>
      </div>
      <div class="boxright">
	  <div class="boxleft">
        <h3>xat.com free poll or mini survey </h3>
        <!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
<?php

$l = intval($_GET['l']);

    $query = "SELECT * FROM xatpoll ORDER BY ID";
	
if ($l > 0) $query .= " DESC LIMIT $l"; 

    $result = mysql_query($query,$xatpoll) or die (Dbg($query) . mysql_error());

$num=mysql_numrows($result);

mysql_close();

$d = intval($_GET['d']);
//if ($id < 1) $id = 1;

$i=1;
while ($i < ($num+1)) {

$question=mysql_result($result,$i-1,"question");
$flags=mysql_result($result,$i-1,"flags");
//$passnum=mysql_result($result,$i-1,"passnum");
$ReadId=mysql_result($result,$i-1,"ID");
$portrait = '';
if(($flags & $f_portrait) != 0) $portrait = " (vert)";

echo "$ReadId,  $question$portrait $passnum<br>\n";

$i++;
}

if($d >0)
{

echo "<table>\n";

$i=1;
while ($i < ($num+1)) {

$myid=mysql_result($result,$i-1,"id");
$flags=mysql_result($result,$i-1,"flags");
$portrait = (($flags & $f_portrait) != 0);
$background =mysql_result($result,$i-1,"background"); 


echo "<tr><td>" . MakeObject(420, 0, $myid, 0, $background, 0, 1) . "</td></tr>\n" ;

$i++;
}

echo "</table>\n";

 }
?>

<!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->

        <p>&nbsp;</p>
            <p>&nbsp;</p>
		
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
    <td>&nbsp;</td>
  </tr>
</table>

</body>
</html>
