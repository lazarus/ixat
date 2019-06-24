<?php
header('Content-type: text/json');
if(!isset($_GET['u']) || !is_numeric($_GET['u'])) exit;

require "../../_class/config.php";
require "../../_class/pdo.php";

$pdo = new Database($config->db[0], $config->db[1], $config->db[2], $config->db[3]);
if(!$pdo->conn) exit;


$xavi = $pdo->fetch_array('select `xavi` from `users` where `id`=:uid;', array('uid' => $_GET['u']));
if(count($xavi) > 0 && strlen($xavi[0]['xavi']) > 0 && ($xavi[0]['xavi'] = json_encode(json_decode($xavi[0]['xavi']))) != "null")
{
	if(isset($_GET['all']) && $_GET['all'] == 1)
	print '{"xavi":['.$xavi[0]['xavi'].'], "timestamp":'.time().'}';
	else
	print $xavi[0]['xavi'];
}
else
{
	if(isset($_GET['all']) && $_GET['all'] == 1)
	print '{"items":[],"xavi":[{"acc":{"y":0,"sy":0,"c":0,"l":"none","r":0,"sx":0,"x":0},"browsr":{"y":-11,"sy":0,"c":0,"l":"xbrowdefault","r":0,"sx":0,"x":-2},"xeyel":{"y":0,"sy":0,"c":0,"l":"xeyesdefault","r":0,"sx":0,"x":2},"mouth":{"y":15,"sy":0,"c":0,"l":"xmouthdefault","r":0,"sx":0,"x":0},"hair":{"y":-25,"sy":0,"c":0,"l":"hair0","r":0,"sx":0,"x":0},"xeyer":{"y":0,"sy":0,"c":0,"l":"xeyesdefault","r":0,"sx":0,"x":-2},"head":{"y":0,"sy":0,"c":0,"l":"xhead1","r":0,"sx":0,"x":0},"browsl":{"y":-11,"sy":0,"c":0,"l":"xbrowdefault","r":0,"sx":0,"x":2}}]}';
	else
	print '{"acc":{"y":0,"sy":0,"c":0,"l":"none","r":0,"sx":0,"x":0},"browsr":{"y":-11,"sy":0,"c":0,"l":"xbrowdefault","r":0,"sx":0,"x":-2},"xeyel":{"y":0,"sy":0,"c":0,"l":"xeyesdefault","r":0,"sx":0,"x":2},"mouth":{"y":15,"sy":0,"c":0,"l":"xmouthdefault","r":0,"sx":0,"x":0},"hair":{"y":-25,"sy":0,"c":0,"l":"hair0","r":0,"sx":0,"x":0},"xeyer":{"y":0,"sy":0,"c":0,"l":"xeyesdefault","r":0,"sx":0,"x":-2},"head":{"y":0,"sy":0,"c":0,"l":"xhead1","r":0,"sx":0,"x":0},"browsl":{"y":-11,"sy":0,"c":0,"l":"xbrowdefault","r":0,"sx":0,"x":2}}';
}