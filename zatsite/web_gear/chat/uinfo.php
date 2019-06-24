<?php
header('Content-type: text/plain');


require str_replace('\\', '\\\\', "../../_class/") . 'pdo.php';

$select = array(
	'`id`','`torched`','`username`','`nickname`', '`time_online`',
	'`avatar`','`url`','`bride`','`xats`', '`days`', 
	'`xavi`', '`custpawn`', '`custcyclepawn`', '`powers`', '`dO`', '`friends`'
);			

$pdo = new Database();

if(!$pdo->conn)
	die(json_encode(array('e'=>true,'t'=>'Failed to connect.')));

if(isset($_GET['u'])) {
	$chat = $pdo->fetch_array('SELECT '.implode(',',$select).' FROM `users` WHERE `username`=:reg;', array('reg'=>$_GET['u']));
	if(empty($chat)) {
		die(json_encode(array('e'=>true,'t'=>'User not found.'), JSON_PRETTY_PRINT));
	}
	die(json_encode($chat[0], JSON_PRETTY_PRINT));
} else if(isset($_GET['id']) && is_numeric($_GET['id'])) {
	$chat = $pdo->fetch_array('SELECT '.implode(',',$select).' FROM `users` WHERE `id`=:id;', array('id'=>$_GET['id']));
	if(empty($chat)) {
		die(json_encode(array('e'=>true,'t'=>'User not found.'), JSON_PRETTY_PRINT));
	}

	die(json_encode($chat[0], JSON_PRETTY_PRINT));
} else {
	die(json_encode(array('e'=>true,'t'=>'No user defined.'), JSON_PRETTY_PRINT));
}
?>