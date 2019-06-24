<?php
$ad = array();
$ad["m1"] = "on sale in %1";
$ad["m2"] = "on sale NOW! Max:1";
$ad["t"] = 1450920048;
if(($ad["t"] + 300) - time() < 1)
	exit('{"m1":"","m2":"","t":1}');
else
	exit(json_encode($ad));
?>