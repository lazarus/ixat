<?php
define('APP_SECRET', 'fbd1f09bcadcd35055e38bb1e40403b6'); // App Secret Key. Find it by going to the Apps page, select Edit on the App of your choice, then Integrate.
error_reporting(E_WARNING);
header('Content-Type:text/plain');

$dir = "../_class/"; // change this depending on this files location
$dir = str_replace('\\', '\\\\', $dir);
require $dir . 'config.php';
require $dir . 'pdo.php';

$whitelist = array('54.85.0.76', '54.84.205.80', '54.84.27.163');
$id = $_REQUEST['id']; // ID of this transaction.
$uid = $_REQUEST['uid']; // ID of the user which performed this transaction. 
$oid = $_REQUEST['oid']; // ID of the offer or direct payment method.
$new = $_REQUEST['new']; // Number of in-game currency your user has earned by completing this offer.
$total = $_REQUEST['total']; // Total number of in-game currency your user has earned on this App.
$sig = $_REQUEST['sig']; // Security hash used to verify the authenticity of the postback.

if(!(is_numeric($id) && is_numeric($uid) && is_numeric($oid) && is_numeric($new) && is_numeric($total)))
	exit('0'); // Fail.

$result = 1;
$sig_compare = md5($id.':'.$new.':'.$uid.':'.APP_SECRET);

if($sig == $sig_compare && in_array($_SERVER['REMOTE_ADDR'], $whitelist))
{
	$timestamp = date("Y-m-d H:i:s", time());
	$pdo = new Database($config->db[0], $config->db[1], $config->db[2], $config->db[3]);
	// Add new transaction
	$trans = array('id' => $id, 'uid' => $uid, 'oid' => $oid, 'new' => $new, 'time'=> $timestamp);
	$pdo->query("INSERT INTO `transactions`(id, user, offer, amount, time) VALUES (:id,:uid,:oid,:new,:time) ON DUPLICATE KEY UPDATE id=:id,user=:uid,offer=:oid,amount=:new,time=:time;", $trans);
	if($new < 0) { // chargeback
		$pdo->query("UPDATE `users` SET `xats`=(`xats` - :xats) WHERE `id`=:uid;", array('xats' => abs($new), 'uid' => $uid));
	} else {
		$pdo->query("UPDATE `users` SET `xats`=(`xats` + :xats) WHERE `id`=:uid;", array('xats' => $new, 'uid' => $uid));
	}
	unset($pdo);
}
else
	$result = 0; // Security hash incorrect. Fail.

echo $result;
// This script will output a status code of 1 (Success) or 0 (Try sending again later).
?>