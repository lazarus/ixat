<?php
$dir = "../../_class/";

$dir = str_replace('\\', '\\\\', $dir);
require $dir . 'config.php';
require $dir . 'pdo.php';

$pdo = new Database($config->db[0], $config->db[1], $config->db[2], $config->db[3]);
if(!$pdo->conn) exit;

if(isset($_SERVER['HTTP_X_FORWARDED_FOR']))
{
	$_SERVER['REMOTE_ADDR'] = array_shift(explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']));
}

if(isset($_SERVER['HTTP_REFERER']))
{
	$user = $pdo->fetch_array('select `id`, `k`, `k2` from `users` where `connectedlast`=:a and `username`=\'\';', array('a' => $_SERVER["REMOTE_ADDR"]));
	
	if(!empty($user)) {
		$userid = $user[0]["id"];
		$k1     = $user[0]["k"];
		$k2     = $user[0]["k2"];
	} else {
		$k1 = rand(100000,999999);
		$k2 = rand(100000,999999);
		$k3 = rand(100000,999999);
		$pdo->query("insert into `users` (`id`, `username`, `nickname`, `password`, `avatar`, `url`, `k`, `k2`, `k3`, `d0`, `d2`, `bride`, `xats`, `reserve`, `days`, `email`, `powers`, `enabled`, `dO`, `cloneid`, `desc`, `xatspacebg`, `transferblock`, `connectedlast`) values (NULL, '', '', '', '', '', '{$k1}', '{$k2}', '{$k3}', '', '', '', 0, 0, 0, '', '1', '', '', '', '', '', '', '{$_SERVER['REMOTE_ADDR']}');");
		$userid = $pdo->insert_id();
	}
}
else
{
	$userid = rand(100000,999999);
	$k1 = rand(100000,999999);
	$k2 = rand(100000,999999);
}

print "&UserId={$userid}&k1={$k1}&k2={$k2}";
