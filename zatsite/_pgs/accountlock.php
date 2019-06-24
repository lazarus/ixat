<?php
	error_reporting(0);
	if(!strlen($_GET['code']))
	{
		echo 'Bad code.';	
		exit;
	}
	$user = $mysql->fetch_array('select `locked_whitelist` from `users` where `locked_whitelist_code`=:code', array('code' => $_GET['code']));
	if(count($user))
	{
		$ip = $_SERVER['REMOTE_ADDR'];
		$whitelist = $user[0]['locked_whitelist'];

		if(strlen($whitelist) > 0)
		{
			$whitelist = json_decode($whitelist);
		}
		else
		{
			$whitelist = array();
		}

		if(!in_array($ip, $whitelist))
		{
			$whitelist[] = $ip;
		}

		$mysql->query('update `users` set `locked_whitelist`=:whitelist, `locked_whitelist_code`="" where `locked_whitelist_code`=:code;', array('code' => $_GET['code'], 'whitelist' => json_encode($whitelist)));
		echo 'Your IP has been whitelisted for your account. You may now try to relogin.';
	} 
	else 
	{
		echo 'Bad code.';
	}
?>