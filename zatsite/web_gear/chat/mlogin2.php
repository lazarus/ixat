<?php

header("Content-Type: text/json");

$dir = "../../_class/";

$dir = str_replace('\\', '\\\\', $dir);
require $dir . 'config.php';
require $dir . 'pdo.php';

$pdo = new Database($config->db[0], $config->db[1], $config->db[2], $config->db[3]);
if (!$pdo->conn) {
	exit;
}

if (!empty($_SERVER['HTTP_X_FORWARDED_FOR']))
{
	$_SERVER['REMOTE_ADDR'] = array_shift(explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']));
}

if (true || isset($_SERVER['HTTP_REFERER']) && stripos($_SERVER['HTTP_REFERER'], 'ixat.io') !== false)
{
	if (!isset($_REQUEST["json"])) {
		die('1');
	}
	$_REQUEST["json"] = json_decode($_REQUEST["json"]);

	if (json_last_error() !== 0) {
		die('4');
	}
	
	if (!isset($_REQUEST["json"]->n) || !isset($_REQUEST["json"]->P)) {
		die('5');
	}
	
	$user = $pdo->fetch_array('select id, xats, username, k, k2, k3, d0, days, d2, powers, dO from `users` where `id`=:a and `password`=:p;', array('a' => $_REQUEST['json']->n, 'p' => $_REQUEST['json']->P));
	// and `username`=\'\'
	if (count($user) < 1) {
		die('2');
	}
	
	$usr = $user[0];
	
	if (!empty($_GET['id'])) {
		foreach ($user as $u) {
			if ($u['id'] == $_GET['id']) {
				$usr = $u;
				break;
			}
		}
	}

	$powers = explode('|', $usr["powers"] ?? '');
	$pp = '';
	foreach($powers as $d => $p) {
		if($p == '0') {
			continue;
		}
		$pp .= ' d' . ($d + 4) . '="' . $p . '"';
	}

	die(json_encode(
	[
		'v' 		=> '<v i="' . ($usr['id']) . '" c="' . ($usr['xats']) . '" dt="0" n="' . $usr['username'] . '" k1="' . ($usr['k']) . '" k2="' . ($usr['k2']) . '" k3="' . ($usr['k3']) . '" d0="' . ($usr['d0']) . '" d1="' . ($usr['days']) . '" d2="' . ($usr['d2']) . '" d3=""' . ($pp) . ' dx="' . ($usr['xats']) . '" dO="' . ($usr['dO']) . '" PowerO="' . ($usr['dO']) . '" />',
		'c' 		=> time(),
		'timestamp' => time(),
		'p' 		=> $_REQUEST['json']->P
	]));
} else {
	die('1');
}
die('3');
?>