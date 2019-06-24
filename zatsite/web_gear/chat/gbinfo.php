<?php
header('Content-type: text/plain');


require str_replace('\\', '\\\\', "../../_class/") . 'pdo.php';

$select = array(
	'`name`','`doodlerace`', '`matchrace`', '`snakerace`',
	'`spacewar`', '`hearts`', '`switch`', '`darts`',
	'`zwhack`',
);			

$pdo = new Database();

if(!$pdo->conn)
	die(json_encode(array('e'=>true,'t'=>'Failed to connect.')));

if(isset($_GET['id']) && is_numeric($_GET['id'])) {
	$chat = $pdo->fetch_array('SELECT '.implode(',',$select).' FROM `chats` WHERE `id`=:id;', array('id'=>$_GET['id']));
	if(empty($chat)) {
		die(json_encode(array('e'=>true,'t'=>'Chat not found.'), JSON_PRETTY_PRINT));
	}
	$res = array();
	$hasFunction = array('doodlerace' => 188, 'matchrace' => 192, 'snakerace' => 194, 'spacewar' => 200, 'hearts' => 224, 'switch' => 238, 'darts' => 246, 'zwhack' => 256, 'name' => 'name');	
	foreach($chat[0] as $key => $value)
		$res[$hasFunction[$key]] = $value;

	die(json_encode($res, JSON_PRETTY_PRINT));
} else {
	die(json_encode(array('e'=>true,'t'=>'No chat defined.'), JSON_PRETTY_PRINT));
}
?>