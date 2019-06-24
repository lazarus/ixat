<?php
	error_reporting(0);
	if(!strlen($_GET['code']))
	{
		echo 'Bad activation code or your account is already activated.';	
		exit;
	}
	$user = $mysql->fetch_array('select `id` from `users` where `activation_code`=:code and `activated`=0;', array('code' => $_GET['code']));
	if(count($user))
	{
		echo 'Your account has been activated, you may now login.';
		$mysql->query('update `users` set `activated`=1 where `activation_code`=:code;', array('code' => $_GET['code']));
	} 
	else 
	{
		echo 'Bad activation code or your account is already activated.';
	}
?>