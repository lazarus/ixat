<?php
$ip3 = getJson('https://xat.com/web_gear/chat/ip2.php?' . time());
print_r($ip3);
	function getJson($url, $true = true) {
		$json = file_get_contents($url);
		return json_decode($json, $true);	
	}	
?>