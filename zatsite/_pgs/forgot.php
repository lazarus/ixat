		<section class="section" style="background: transparent">
			<div class="container">
<?php

$messages = [];
if ($_SERVER["REQUEST_METHOD"] == "POST") {
	do {
		if (!$core->allset($_POST, 'email')) {
		    break;
		}
		if (strlen($_POST['email']) == 0) {
		    $messages[] = 'Please enter your username';
		}
		if (!empty($messages))
		    break;

		$user = $mysql->fetch_array('select `username`, `email` from `users` where `activated`=1 and `email`=:email', array('email' => $_POST['email']));
		if ($_POST['email'] == "") {
			$message[] = "Please enter a valid email address.";
		} else if (count($user)) {
			$username = $user[0]['username'];

			$code = md5($core->random_letters(32));

			$html = 'Please click <a href="//' . $config->server_dm . '/forgot&code=' . $code . '">here</a> to reset your password.<br /><br />Or go here if the above link does not work: <br />http://' . $config->server_dm . '/forgot&code=' . $code . '';

			$core->email($user[0]['email'], 'Confirm Lost Password At ' . $config->server_dm, $html);

			$mysql->query('update `users` set `new_password`=:code where `email`=:email AND `email`!="";', array('code' => $code, 'email' => $user[0]['email']));

			$messages[] = "You have been emailed confirmation to change your password.";
		} else {
			$messages[] = "Sorry, nobody with that email has registered or you have not activated your account yet.";
		}
		break;
	} while(false);
} else if (!isset($_POST["email"]) && isset($_GET["code"])) {
	do {
		if (!strlen($_GET['code']) || !ctype_alnum($_GET['code'])) {
			$messages[] = 'Bad code.';
			break;
		}
		$user = $mysql->fetch_array('select `username`, `email` from `users` where `new_password`=:code and `activated`=1;', array('code' => $_GET['code']));
		if (count($user)) {
			$username = $user[0]['username'];

			$password = $core->random_letters(10);

			$html = "<h2>Account Information</h2> <br> Username: <b>{$username}</b> <br> Password: <b>{$password}</b>";

			$mysql->query('update `users` set `password`=:password, `new_password`="" where `new_password`=:code;', array('password' => $mysql->hash($password), 'code' => $_GET['code']));

			$core->email($user[0]['email'], 'ixat.io Account Information', $html);

			$messages[] = "You have been emailed your account information.";
		} else {
			$messages[] = 'Bad code or your account is not activated.';
		}
	} while(false);
}

if(count($messages) > 0) {
?>
				<div class="row gap-y align-items-center text-center">
					<div class="col-12">
						<?php foreach($messages as $msg) { ?>
						<div class="alert alert-danger" role="alert">
							<strong>Oh snap!</strong> <?= $msg; ?>
						</div>
						<?php } ?>
						<!--<h4 class="fw-300 mb-10"><?=implode("<br />", $messages);?></h4>-->
					</div>
				</div>
<?php
}

if(!isset($core->user)) {
?>
				<div class="section-dialog text-center">
					<div class="p-50 w-400 mb-0" style="max-width: 100%">
						<h5 class="text-uppercase text-center">Forgot Password</h5>
						<br><br>
						<form method="post">
							<div class="form-group">
								<input type="text" class="form-control" name="email" placeholder="Email">
							</div>
							<div class="form-group">
								<button class="btn btn-bold btn-block btn-primary" type="submit">Submit</button>
							</div>
						</form>
						<hr class="w-30">
						<p class="text-center text-muted fs-13 mt-20">Don't have an account? <a href="/register">Sign up</a></p>
					</div>
				</div>
<?php
} else {
	print '<meta http-equiv="refresh" content="2;url=//' . $config->server_dm . '' . ($_SERVER['REQUEST_URI'] == "/login" ? "/home" : $_SERVER['REQUEST_URI']) . '">';
}
?>
			</div>
		</section>