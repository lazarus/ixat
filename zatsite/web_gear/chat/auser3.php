<?php

$seconds_to_cache = 60 * 60 * 24 * 30;
$ts = gmdate("D, d M Y H:i:s", time() + $seconds_to_cache) . " GMT";
header("Expires: $ts");
header("Pragma: cache");
header("Cache-Control: public, max-age=$seconds_to_cache");

$dir = "../../_class/";

$dir = str_replace('\\', '\\\\', $dir);
require $dir . 'config.php';
require $dir . 'pdo.php';

$pdo = new Database($config->db[0], $config->db[1], $config->db[2], $config->db[3]);
if(!$pdo->conn) exit;

$addr = $_SERVER["REMOTE_ADDR"];
$forward = $_SERVER['HTTP_X_FORWARDED_FOR'];

if(!empty($forward))
{
	$addr = array_shift(explode(',', $forward));
}

if(isset($_SERVER['HTTP_REFERER']) && stripos($_SERVER['HTTP_REFERER'], 'ixat.io') !== false)
{
	if(!empty($_GET["u"]) && !empty($_GET["k2"])) {
		$user = $pdo->fetch_array('select `id`, `k`, `k2` from `users` where `id`=:a and `k2`=:b;', array('a' => $_GET["u"], "b" => $_GET["k2"]));
	}
	if(empty($user)) {
		$user = $pdo->fetch_array('select `id`, `k`, `k2` from `users` where `connectedlast`=:a;', array('a' => $addr));
	}
	// and `username`=\'\'
	
	if(!empty($user))
	{
	
		if(!empty($_GET["u"])) {
			foreach($user as $u) {
				if($u["id"] == $_GET["u"]) {
					$user[0] = $u;
					break;
				}
			}
		}
		$userid = $user[0]["id"];
		$k1     = $user[0]["k"];
		$k2     = $user[0]["k2"];
	}
	else
	{
		$k1 = rand(100000,999999);
		$k2 = rand(100000,999999);
		$k3 = rand(100000,999999);
		$pdo->query("insert into `users` (`id`, `username`, `nickname`, `password`, `avatar`, `url`, `k`, `k2`, `k3`, `d0`, `d2`, `bride`, `xats`, `reserve`, `days`, `email`, `powers`, `enabled`, `dO`, `cloneid`, `desc`, `xatspacebg`, `transferblock`, `connectedlast`) values (NULL, '', '', '', '', '', '{$k1}', '{$k2}', '{$k3}', '', '', '', 0, 0, 0, '', '1', '', '', '', '', '', '', '{$addr}');");
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
