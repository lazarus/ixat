		<section class="section" style="background: transparent">
			<div class="container">
<?php

require_once _root . '_class' . _sep . 'recaptcha.php';

//Define the keys for the api, you can get them from https://www.google.com/recaptcha/
$keys = array(
    'site_key' => '',
    'secret_key' => ''
);

//Instantiate the Recaptcha class as $recaptcha
$recaptcha = new Recaptcha($keys);

if($recaptcha->set()) {
	if ($recaptcha->verify($_POST['g-recaptcha-response']) == 1) {
		$captcha = true;
	} else {
		$captcha = false;
	}
} else {
	$captcha = true;
}

$messages = [];
if ($_SERVER["REQUEST_METHOD"] == "POST") {
	do {
		if(!$core->allset($_POST, 'user', 'pass', 'mail', 'confirm_pass', 'confirm_mail'))
		{
			break;
		}
		if(!$captcha)
		{
			$messages[] = 'You need to complete the captcha correctly.';
		}
		if(!isset($_POST["agree"]))
		{
			$messages[] = "You must agree to the terms and conditions before registering.";
		}
		if(strlen($_POST['user']) < 10 || strlen($_POST['user']) > 18 || !ctype_alnum($_POST['user']))
		{
			$messages[] = 'Your username requires 10-18 alpha-numeric characters (a-z/0-9)';
		}
		if(is_numeric(substr($_POST['user'], 0, 1)))
		{
			$messages[] = 'Your username must begin with a letter.';
		}
		if($_POST["pass"] != $_POST["confirm_pass"])
		{ 
			$messages[] = "Passwords do not match, please try again.";
		}
		if($_POST["mail"] != $_POST["confirm_mail"])
		{ 
			$messages[] = "E-Mails do not match, please try again.";
		}
		if(strtolower($_POST['user']) == 'unregistered')
		{
			$messages[] = 'That username is reserved.';
		}
		if(strlen($_POST['pass']) < 6)
		{
			$messages[] = 'You are required to choose a password with at least 6 characters.';
		}
		if(!filter_var($_POST['mail'], FILTER_VALIDATE_EMAIL) || $core->isDisposable($_POST['mail']))
		{
			$messages[] = 'Please enter a valid email address.';
		}
		if(!empty($messages)) break;

		$count = $mysql->fetch_array('select count(*) as `count` from `users` where `username`=:a or `email`=:b or (`connectedlast`=:c and `username`!=:d);', array('a' => $_POST['user'], 'b' => $_POST['mail'], 'c' => $_SERVER['REMOTE_ADDR'], 'd' => ''));
		if($count[0]['count'] > 0)
		{
			$messages[] = 'Someone already registered with that username, or you already have an account.';
			break;
		}
	    if ($_POST['user'][0] == 'l') {
	        $_POST['user'] = 'L' . substr($_POST['user'], 1);
	    }
		/* Insert Pre-Registration-ID Here (Unregistered) */
		$default_powers = [2, 4, 8, 9, 12, 13, 14, 15, 16, 19, 21, 54, 81, 103, 231, 289];

		$code = md5($_POST['mail']);
		$vals = array(
			'id' => 'NULL',
			'username' => $_POST['user'],
			'nickname' => base64_encode($_POST['user']),
			'password' => $mysql->hash($_POST['pass']),
			'avatar' => rand(0, 1759),
			'url' => '',
			'k' => rand(-1000000, 1000000),
			'k2' => rand(-1000000, 1000000),
			'k3' => rand(-1000000, 1000000),
			'xats' => $config->xats,
			'reserve' => 100000,
			'days' => time() + ($config->days * 86400),
			'email' => $_POST['mail'],
			'activation_code' => $code,
			'email_changed' => 1,
			'enabled' => '1',
			'transferblock' => time() + (86400 * 7),
			'connectedlast' => $_SERVER['REMOTE_ADDR'],
			'rank' => 1,
			'powers' => $core->EncodePowers($default_powers)[0],
			'dO' => '',
	        'friends' => '[]'
		);
		$result = $mysql->insert('users', $vals);

	    $message = "Hello {$_POST["user"]}," . "<br />";
	    $message .= "<br />";
		$message .= "Click on this link to activate your registration:" . "<br />";
	    $message .= "<br />";
		$message .= "http://{$config->server_dm}/profile?activation&code={$code} " . "<br />";
	    $message .= "<br />";
		$message .= "(NB until you have clicked on this link {$_POST["user"]} has not been reserved and is not active)" . "<br />";
	    $message .= "<br />";
	    $message .= "<br />";
	    $message .= "For instant help with ixat go here: http://{$config->server_dm}/lobby " . "<br />";
	    $message .= "<br />";
	    $message .= "For other problems, comments or suggestions, please use the support system here: http://{$config->server_dm}/support " . "<br />";
	    $message .= "<br />";
	    $message .= $config->server_dm . "<br />";
	    $message .= "<br />";
	    $message .= "<br />";
	    $message .= "=== THIS IS AN AUTOMATED MESSAGE, PLEASE DO NOT REPLY ===";

		$core->email($_POST['mail'], "ixat chat user: {$_POST["user"]} - Activation required", $message);
		$messages[] = "Registration successful, please check your email for your activation code.";
		break;
	} while(false);

	if(count($messages) > 0) {
?>
				<div class="row gap-y align-items-center text-center">
					<div class="col-12">
						<h4 class="fw-300 mb-10"><?=implode("<br />", $messages);?></h4>
					</div>
				</div>
<?php
	}	
}
?>
				<div class="section-dialog text-center">
					<div class="p-25 w-400 mb-0" style="max-width: 100%">
						<h5 class="text-uppercase text-center">Register</h5>
						<br><br>
						<form method="post">
							<div class="form-group">
								<input type="text" class="form-control" name="user" placeholder="Username">
							</div>
							<div class="form-group">
								<input type="text" class="form-control" name="mail" placeholder="Email address">
							</div>
							<div class="form-group">
								<input type="text" class="form-control" name="confirm_mail" placeholder="Email address (confirm)">
							</div>
							<div class="form-group">
								<input type="password" class="form-control" name="pass" placeholder="Password">
							</div>
							<div class="form-group">
								<input type="password" class="form-control" name="confirm_pass" placeholder="Password (confirm)">
							</div>
							<div class="form-group">
								<label class="custom-control custom-checkbox">
									<input name="agree" type="checkbox" class="custom-control-input">
									<span class="custom-control-indicator"></span>
									<span class="custom-control-description">I agree to all <a class="text-primary" href="#">terms</a></span>
								</label>
							</div>
							<div class="form-group">
								<?php print $recaptcha->render(); ?>
							</div>
							<button class="btn btn-bold btn-block btn-primary" type="submit">Register</button>
						</form>
						<hr class="w-30">
						<p class="text-center text-muted fs-13 mt-20">Already have an account? <a href="/login">Sign in</a></p>
					</div>
				</div>
			</div>
		</section>