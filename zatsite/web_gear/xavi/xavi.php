<?php

header("Content-Type: text/json");


// Get xavi config 

$xavi = array(
'ver' => 1,
//'hat' => array(1,100,1,1,1,1,50,1,1,1,1,1,1,25,100,50,25,100,50,100, 100,100,100,100,100,100,100,100,100,100,100,100,100),
//'hat' => array(1,100,1,1,1,1,50,1,1,1,1,1,1,1,100,50,1,1,1,1,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100),
'hat' => array(1,100,100,100,100,100,50,100,100,100,100,100,100,1,100,50,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100),
//'head' => array(0,0,0,0,0,0,0,0),
'hair' => array(0,0,0,50,100,0,0,0,50,50,50,50,50)
//'mouth' => array(0,0,0,0,0,200),
//'eye' => array(0,0,0,0,0,0,0,0),
//'brow' => array(0,0,0,0,0,0,0,0),
//'spectacles' => array(50,200),
//'moustache' => array(0,0,0,0,0,0),
//'action' => array('smile'=>0,'frown'=>0, 'tongue'=>100),
//'options' => array(
// 'hat' => array(3=>array(0x1ff0000=>400, 0x00ff00=>200), // cowboy hat, 2 types
// 				4=>array(0xff0000=>300)) // hoodie
//)
);

error_reporting(E_ALL ^ (E_NOTICE|E_WARNING));
	
header("Cache-Control: max-age=60,public"); // temp

if($_SERVER['REQUEST_METHOD'] !== 'GET') exit;
//if(!empty($_GET)) exit; // 
	
echo json_encode($xavi);
?>
