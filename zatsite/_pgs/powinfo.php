<?php
// ----------------------------------------------------------------------------------
// Revision: 	02:04 03.10.2016
//===================================================================================
?>
<?php
If (!isset($core->user)) 
{
    return include $pages['profile'];
} // Check if the user logged...
$power = "bloonie";
if(isset($_GET['power'])) $power = $_GET['power'];
if(!is_string($power)) die();
$row = $mysql->fetch_array("SELECT * FROM powers WHERE name=:power;", ["power" => $power]);
?>

	<section class="section bg-gray p-25">
		<div class="container">
			<div class="row gap-y">
				<div class="col-12">
<?php

if(!empty($row[0])){
	$topsh = $row[0]['topsh'];
	
	$poder = $row[0]['name'];
	$limited = $row[0]['limited'];
	$explode = explode(",", $topsh);

	if($limited == 1) 
	{
	$char = "LIMITED"; 
	}
	else 
	{
	$char = "UNLIMITED"; 
	}
	echo '<div style="font-size:132%; font-weight:bold; margin: 10px 0 5px 0; padding-left: 5px; border-bottom: 1px solid #aaa"> 
<img src="http://' . $config->info['server_domain'] . '/images/smw/'.$power.'.png" alt="'.$power.'.png"> ('.$power.') - '.$poder.' <i><b>'.$char.'.</b></i> </div>
<ul><li><b>The smilies are:</b>
</li></ul>';
	if(!empty($topsh))
	{
	   foreach($explode as $e)
	   {
		echo '<div style="width:100px; float:left; margin:0 15px 15px 0">
<div style="width:100%; background: white; border: 1px solid #aaa; text-align:center">
<embed src="http://' . $config->info['server_domain'] . '/web_gear/flash/smiliesshow.swf" flashvars="r='.$e.'" type="application/x-shockwave-flash" height="50px" width="50px"></div>
<div style="width:100%; background: #f2f2f2; font-weight: bold; border: 1px solid #aaa; border-top: 0; text-align:center; font-size:10px">('.$e.')</div></div>';
	   }

	}
		else
		{
		    print '<p style="color:#FF0000"><strong>**<span style="display: inline;">No smilies</span>**</strong></p>' ;
	    }
}
echo '<div style="clear:both"></div>' ;
/*
if(!empty($row[0])){
	$topshpawn = $row[0]['topshpawn'];
	$explode = explode(",", $topshpawn);
	
echo '<ul><li><b>Limited pawns:</b>
</li></ul>' ;
	if(!empty($topshpawn))
	{
	   foreach($explode as $pwns)
	   {
	   echo '<div style="width:100px; float:left; margin:0 15px 15px 0">
<div style="width:100%; background: white; border: 1px solid #aaa; text-align:center">
<embed src="http://' . $config->info['server_domain'] . '/web_gear/flash/smiliesshow.swf" flashvars="r='.$pwns.'" width="50px" height="50px" wmode="transparent"></div>
<div style="width:100px; background: #f2f2f2; font-weight: bold; border: 1px solid #aaa; border-top: 0; text-align:center; font-size:10px">(hat#h)</div></div>' ;
	   }
	}
	else
		{
		    print '<p style="color:#FF0000"><strong>**<span style="display: inline;">No tiene Pawns</span>**</strong></p>' ;
	    }
}
*/
?>
</div>
</div>

</section>