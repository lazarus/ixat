<?php 

header("Content-Type: text/json");

$allowed = ['a8d77e62ec07c289d9734d810647a441', '9ee1a4d8ae4c2bef23d2e48b4c6bb91a', '71b8e7adca8745a71981c47f5f17d625', '18d4846095eab0e7c075d758aeca5742'];

$domain = 'ixat.io';

$ip = "troll";

if(in_array(md5($_SERVER["REMOTE_ADDR"]), $allowed)) /*$ip = "127.0.0.1:3333:1";//*/$ip = "205.185.125.44:337:1";

$ip2 = new stdClass();
$ip2->S0 = [0, [$domain]];
$ip2->order = [["E0", 60], ["E1", 90], ["E0", 180], ["S0", 240]];
$ip2->xFlag = 2;
$ip2->time = time();
$ip2->T0 = [1, [""]];
$ip2->E0 = [1, [$ip]];
$ip2->E1 = [1, [$ip]];
$ip2->k1n = 0;
$ip2->k1d = 14;
$ip2->pow2 = [];

die(json_encode($ip2, JSON_PRETTY_PRINT));
?>