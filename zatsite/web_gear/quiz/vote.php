<?php
error_reporting(E_ALL ^ E_NOTICE);
// Vote in a quiz
$MaxAns = 10;
// Save number of right ans in a quiz

$id = intval($_GET['id']); // remove nasties 

$count = intval($_GET['count']); // remove nasties 
if($count >= 0 && $count <= $MaxAns)
{
	require_once('/home/admin/cgi-bin/xatdata.php');
	$key = "webgear.quiz.$id.v";
	$wgv = xatGet($key); // Read counters
	if (is_array($wgv)) 
	{
		$wgv["count$count"] += 1;
		xatPut($key, $wgv, ''); // use funky update feature
	}
}
?>