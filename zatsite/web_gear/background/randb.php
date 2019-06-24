<?php
include('background.php');

$arr = GetBackgrounds();

echo "&back=". $arr[array_rand($arr)] ;

?>

