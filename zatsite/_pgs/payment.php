<?php
define('SECRET', 'b5a556a214c177100bb81ea25034b875'); // secret key of your application
define('IP_WHITELIST_CHECK_ACTIVE', true);
define('CREDIT_TYPE_CHARGEBACK', 2);

$dir = "../_class/"; // change this depending on this files location
$dir = str_replace('\\', '\\\\', $dir);
require $dir . 'config.php';
require $dir . 'pdo.php';

$ipsWhitelist = array(
    '174.36.92.186',
    '174.36.96.66',
    '174.36.92.187',
    '174.36.92.192',
    '174.37.14.28'
);

$userId = $_GET['uid'] ?? null;
$credits = $_GET['currency'] ?? null;
$type = $_GET['type'] ?? null;
$refId = $_GET['ref'] ?? null;
$signature = $_GET['sig'] ?? null;
$sign_version = $_GET['sign_version'] ?? null;

$result = false;

$errors = array();

if (!empty($userId) && !empty($credits) && isset($type) && !empty($refId) && !empty($signature)) {
    $signatureParams = array();

	if (empty($sign_version) || $sign_version <= 1) {//v1
		$signatureParams = array(
			'uid' => $userId,
			'currency' => $credits,
			'type' => $type,
			'ref' => $refId
		);
    } else {//v2
		$signatureParams = array();
		foreach ($_GET as $param => $value) {    
			$signatureParams[$param] = $value;
		}
		unset($signatureParams['sig']);
    }
    $signatureCalculated = calculatePingbackSignature($signatureParams, SECRET, $sign_version);
    if (!IP_WHITELIST_CHECK_ACTIVE || in_array($_SERVER['REMOTE_ADDR'], $ipsWhitelist)) {
		if ($signature == $signatureCalculated) {
			//only connect to db after its legit
			$pdo = new Database($config->db[0], $config->db[1], $config->db[2], $config->db[3]);
			$result = true;
			$user = $pdo->fetch_array("SELECT `id` FROM `users` WHERE `id`=:uid;", array('uid' => $userId));
			if(count($user) == 1) {
				if ($type == CREDIT_TYPE_CHARGEBACK) {
					$chrgbk = abs($credits);//chargeback is negative
					$pdo->query("UPDATE `users` SET `xats`=(`xats` - :xats) WHERE `id`=:uid;", array('xats' => $chrgbk, 'uid' => $userId));
				} else {
					$pdo->query("UPDATE `users` SET `xats`=(`xats` + :xats) WHERE `id`=:uid;", array('xats' => $credits, 'uid' => $userId));
					//Credit user
				}
			} else {
				$errors['params'] = 'Non-Existent uid!';
			}
			unset($pdo);
		} else {
			$errors['signature'] = 'Signature is not valid!';    
		}
    } else {
		$errors['whitelist'] = 'IP not in whitelist!';
    }
} else {
    $errors['params'] = 'Missing parameters!';
}

if ($result) {
    echo 'OK';
} else {
	echo implode(' ', $errors);
}

function calculatePingbackSignature($params, $secret, $version) {
    $str = '';
    if ($version == 2) {
		ksort($params);
    }
    foreach ($params as $k=>$v) {
		$str .= "{$k}={$v}";
    }
    $str .= $secret;
    return md5($str);
}
?>