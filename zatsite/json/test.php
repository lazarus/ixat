<?php
$ip3 = getJson('https://xat.com/web_gear/chat/ip3.php?' . time(), false);
print_r($ip3->pow2);
	function getJson($url, $true = true) {
		$json = file_get_contents($url);
		return json_decode($json, $true);	
	}	
?>