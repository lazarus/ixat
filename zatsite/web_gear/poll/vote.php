<?php
error_reporting(E_ALL ^ E_NOTICE);
// Vote in a poll

$MaxAns = 12;

$id = intval($_GET['id']); // remove nasties 

$count = intval($_GET['count']); // remove nasties 

if($count >= 1 && $count <= $MaxAns)
{
	require_once('/home/admin/cgi-bin/xatdata.php');
	$key = "webgear.poll.$id.v";
	$wgv = xatGet($key); // Read counters
	if (is_array($wgv)) 
	{
		$wgv["count$count"]++;
		xatPut($key, $wgv, ''); // use funky update feature
	}
}
?>

