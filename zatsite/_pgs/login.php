		<section class="section" style="background: transparent">
			<div class="container">
<?php

$messages = [];
if ($_SERVER["REQUEST_METHOD"] == "POST") {
	do {
		if (!$core->allset($_POST, 'user', 'pass')) {
		    break;
		}
		if (strlen($_POST['user']) == 0) {
		    $messages[] = 'Please enter your username';
		}
		if (strlen($_POST['pass']) == 0) {
		    $messages[] = 'Please enter your password';
		}
		if (!empty($messages))
		    break;

		$user = $mysql->fetch_array('select `password`, `locked`, `lockedinfo`, `username` from `users` where `username`=:a and activated=1 or `username`=:a and email_changed=0;', array(
		    'a' => $_POST['user']
		));
		if (empty($user) || !$mysql->validate($_POST['pass'], $user[0]['password'])) {
		    $messages[] = 'Bad username / password or account is not activated.';
		    break;
		}

		if ($user[0]['locked']) {
		    $user_lock_info = json_decode($user[0]['lockedinfo'], true);
		    $geo_info       = $core->geo($_SERVER['REMOTE_ADDR']);
		    if ($user_lock_info != $geo_info) {
		        $messages[] = 'Account is locked and you appear to be in a different location or have a different ISP than what is in our records.';
		        break;
		    }
		}
		$lock     = isset($_POST['lock']) ? ($_POST['lock'] == "on" ? true : false) : false;
		$loginKey = md5(time() . json_encode($_POST));
		setCookie('loginKey', $loginKey, strtotime('+ 10 year'));

		$_COOKIE['loginKey'] = $loginKey;
		$mysql->query('update `users` set `loginKey`=:a, `locked`=:lock where `username`=:b;', array(
		    'a' => $loginKey,
		    'b' => $user[0]['username'],
		    'lock' => $lock
		));
		if ($lock) {
		    $geo_info = $core->geo($_SERVER['REMOTE_ADDR']);
		    $mysql->query('update `users` set `lockedinfo`=:lockedinfo where `username`=:b;', array(
		        'b' => $user[0]['username'],
		        'lockedinfo' => json_encode($geo_info, true)
		    ));
		} else {
		    $mysql->query('update `users` set `lockedinfo`="" where `username`=:b;', array(
		        'b' => $user[0]['username']
		    ));
		}
		//$core->user->setAuthorized(true);
		break;
	} while(false);
}

/*if(isset($core->user)) {
	$messages[] = 'You will be redirected momentarily';
    $relog =  $core->refreshLogin(false, true);
    if ($core->html5) {
        $messages[] = $relog['html5'];
    }
    $messages[] = $relog['flash'];
    
	//$messages[] = $core->refreshLogin(false);
}*/

if(isset($core->user)) {
	$messages[] = 'You will be redirected momentarily';
    $relog =  $core->refreshLogin(false, true);
    $messages[] = $relog['flash']; 
    if ($core->html5) {
?>
<script>
{
	var todo = JSON.parse(localStorage.getItem('todo'));
	if(!todo || (typeof todo !== 'object')) todo = {};
	var todoj = JSON.parse('<?=$relog['html5'];?>');
	todo['DeviceId'] = todoj['DeviceId'];
	todo['PassHash'] = todoj['PassHash'];
	todo['MobNo'] = '';
	todo['w_userno'] = todoj['w_userno'];
	todo['w_registered'] = todoj['w_registered'];
	localStorage.setItem('todo', JSON.stringify(todo));
}
</script>
<?php
    }
}

if(count($messages) > 0) {
?>
				<div class="row gap-y align-items-center text-center">
					<div class="col-12">
						<h4 class="fw-300 mb-10"><?=implode("<br />", $messages);?></h4>
					</div>
				</div>
<?php
}

if(!isset($core->user)) {
?>
				<div class="section-dialog text-center">
					<div class="p-50 w-400 mb-0" style="max-width: 100%">
						<h5 class="text-uppercase text-center">Login</h5>
						<br><br>
						<form method="post">
							<div class="form-group">
								<input type="text" class="form-control" name="user" placeholder="Username">
							</div>
							<div class="form-group">
								<input type="password" class="form-control" name="pass" placeholder="Password">
							</div>
							<div class="form-group flexbox py-10">
								<label class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" checked>
									<span class="custom-control-indicator"></span>
									<span class="custom-control-description">Remember me</span>
								</label>
								<a class="text-muted hover-primary fs-13" href="/forgot">Forgot password?</a>
							</div>
							<div class="form-group">
								<button class="btn btn-bold btn-block btn-primary" type="submit">Login</button>
							</div>
						</form>
						<div class="divider">Or Sign In With</div>
						<div class="text-center">
							<a class="btn btn-circular btn-sm btn-facebook mr-4" href="#"><i class="fa fa-facebook"></i></a>
							<a class="btn btn-circular btn-sm btn-google mr-4" href="#"><i class="fa fa-google"></i></a>
							<a class="btn btn-circular btn-sm btn-twitter" href="#"><i class="fa fa-twitter"></i></a>
						</div>
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