<?php
if(!isset($_POST) || count($_POST) == 0) die("no u");

if(!isset($_POST['u']) || !is_numeric($_POST['u'])) die("no u");

if(!isset($_POST['xavi'])) die("no u");

require "../../_class/config.php";
require "../../_class/pdo.php";

$pdo = new Database($config->db[0], $config->db[1], $config->db[2], $config->db[3]);
if(!$pdo->conn) die("no u");

$_POST["xavi"] = json_decode($_POST["xavi"]);

if(json_last_error() !== JSON_ERROR_NONE || $_POST["xavi"] == null) die("no u");

$base = [
	"browsl"=>[],
	"head"=>[],
	"acc"=>[],
	"browsr"=>[],
	"xeyer"=>[],
	"xeyel"=>[],
	"mouth"=>[],
	"hair"=>[]
];
$base2 = [
	"x"=>0,
	"y"=>0,
	"r"=>0,
	"l"=>"",
	"c"=>0,
	"sx"=>0,
	"sy"=>0
]

$_POST["xavi"] = array_intersect_key($_POST["xavi"], $base);
foreach($_POST["xavi"] as $k => $i) {
	$_POST["xavi"][$k] = array_intersect_key($_POST["xavi"][$k], $base2);
}

$_POST["xavi"] = json_encode($_POST["xavi"]);

if(json_last_error() !== JSON_ERROR_NONE || $_POST["xavi"] == null) die("no u");

$pdo->query('update `users` set `xavi`=:xavi where `id`=:uid;', array('xavi' => $_POST['xavi'], 'uid' => $_POST['u']));
echo "OK";