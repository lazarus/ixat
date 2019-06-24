<?php
if(!isset($config->complete) || !isset($_GET['ajax']) || empty($_POST))
{
	return require $pages['home'];
}

try
{
	$sandbox = false;
	$ppdb = new Database('205.185.112.51', 'ztsqlser_lc', 'Lcpzg0Fzc4fELgA3kR', 'ztsqlser_ipn');
	$ppdm = $sandbox ? 'https://www.sandbox.paypal.com/cgi-bin/webscr' : 'https://www.paypal.com/cgi-bin/webscr';
	$request = 'cmd=_notify-validate';
	foreach($_POST as $i => $u)
	{
		$request .= '&' . urlencode($i) . '=' . urlencode(stripslashes($u));
	}
	
	$ch = curl_init($ppdm);
	curl_setopt($ch, CURLOPT_POST, true);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $request);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	$response = curl_exec($ch);
	curl_close($ch);
	
	if(strcmp($response, 'VERIFIED') === 0)
	{
		$ppdb->insert(
			'ibn_table',
			array(
				'username' => $_POST['option_selection1'],
				'itransaction_id' => $_POST['txn_id'],
				'amount' => $_POST['mc_gross'],
				'type' => $_POST['payment_type'],
				'ipayerid' => $_POST['payer_id'],
				'iname' => $_POST['first_name'] . ' ' . $_POST['last_name'],
				'iemail' => $_POST['payer_email'],
				'itransaction_date' => date('Y-m-d h:i:s', strtotime($_POST['payment_date'])),
				'ipaymentstatus' => $_POST['payment_status'],
				'mcfee' => $_POST['mc_fee'],
				'ieverything_else' => json_encode($_POST)
			)
		);
		
		//$ppdb->query('update `users` set `xats`=`xats`+' . floor($_POST['mc_gross'] * 2500) . ', `days`=`days`+' . floor(($_POST['mc_gross'] * 100) * 86400) . ' where `username`=:user;', array('user' => $_POST['option_selection1']));
	}
	else
	{
		throw new Exception();
	}
}
catch(Exception $e)
{
	return require $pages['home'];
}