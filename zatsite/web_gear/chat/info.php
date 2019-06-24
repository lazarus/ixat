<?php
header('Content-type: text/plain');


require str_replace('\\', '\\\\', "../../_class/") . 'pdo.php';

$pdo = new Database();

if(!$pdo->conn)
	die(json_encode(array('e'=>true,'t'=>'Failed to connect.')));

if(isset($_GET['gn'])) {
	$chat = $pdo->fetch_array('SELECT * FROM `chats` WHERE `name`=:gn;', array('gn'=>$_GET['gn']));
	if(empty($chat)) {
		die(json_encode(array('e'=>true,'t'=>'Chat not found.'), JSON_PRETTY_PRINT));
	}
	unset($chat[0]['pass'], $chat[0]['email']);
	$gp = $pdo->fetch_array("select * from `group_powers` where `chat`=:name", array("name" => $_GET['gn']));
	foreach($gp as $power) {
		$pid = $power['power'];
		unset($power['chat'], $power['power']);
		$chat[0]["gp_{$pid}"] = $power;
	}
	die(json_encode($chat[0], JSON_PRETTY_PRINT));
} else if(isset($_GET['id']) && is_numeric($_GET['id'])) {
	$chat = $pdo->fetch_array('SELECT * FROM `chats` WHERE `id`=:id;', array('id'=>$_GET['id']));
	if(empty($chat)) {
		die(json_encode(array('e'=>true,'t'=>'Chat not found.'), JSON_PRETTY_PRINT));
	}
	unset($chat[0]['pass'], $chat[0]['email']);
	$gp = $pdo->fetch_array("select * from `group_powers` where `chat`=:name", array("name" => $chat[0]['name']));
	foreach($gp as $power) {
		$pid = $power['power'];
		unset($power['chat'], $power['power']);
		$chat[0]["gp_{$pid}"] = $power;
	}

	die(json_encode($chat[0], JSON_PRETTY_PRINT));
} else {
	die(json_encode(array('e'=>true,'t'=>'No chat defined.'), JSON_PRETTY_PRINT));
}
?>