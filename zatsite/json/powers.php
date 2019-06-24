<?php
header('Content-type: text/plain');

$dir = "../_class/";
$dir = str_replace('\\', '\\\\', $dir);
require $dir . 'config.php';
require $dir . 'pdo.php';

$pdo = new Database($config->db[0], $config->db[1], $config->db[2], $config->db[3]);

if(!$pdo->conn)
	die(json_encode(array('e'=>true,'t'=>'Failed to connect.')));

$powers = $pdo->fetch_array('select * from `powers` where `p`="1" order by `id` DESC;');

$json = new stdClass();
$MaxPower = $powers[0]['id'];
foreach($powers as $p) {
	$json->{$p['id']} = new stdClass();
	$json->{$p['id']}->s = $p['name'];
	if(!empty($p['description'])) $json->{$p['id']}->d1 = $p['description'];
	if($p['cost'] > 0) $json->{$p['id']}->x = (string) $p['cost'];
	if($p['limited'] == 1) {
		$json->{$p['id']}->r = $p['amount'] > 0 ? $p['amount']:(string)1;
	}
	$json->{$p['id']}->f = 2;
	
    if($p['group'])
		$json->{$p['id']}->f |= 0x800; // Group
	if($p['id'] > ($MaxPower - 5))
		$json->{$p['id']}->f |= 0x1000; // New
	if(@$json->{$p['id']}->r !== null && @$json->{$p['id']}->r > 0)
		$json->{$p['id']}->f |= 0x2000; // Limited
}

if(isset($_GET['clean']))
	print json_encode($json, JSON_PRETTY_PRINT);
else 
	print json_encode($json);
?>