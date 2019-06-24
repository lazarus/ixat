<?php
if(!isset($_POST) || count($_POST) == 0) die("no u");

if(!isset($_POST['u']) || !is_numeric($_POST['u'])) die("no u");

if(!isset($_POST['xavi'])) die("no u");

require "../../_class/config.php";
require "../../_class/pdo.php";

$pdo = new Database($config->db[0], $config->db[1], $config->db[2], $config->db[3]);
if(!$pdo->conn) die("no u");

$_POST['xavi'] = json_encode(json_decode($_POST['xavi']));

//$xavi = $pdo->fetch_array('select `xavi` from `users` where `id`=:uid;', array('uid' => $_GET['u']));
$pdo->query('update `users` set `xavi`=:xavi where `id`=:uid;', array('xavi' => $_POST['xavi'], 'uid' => $_POST['u']));
echo "OK";