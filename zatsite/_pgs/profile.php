<?php
require_once _root . '_class' . _sep . 'recaptcha.php';

//Define the keys for the api, you can get them from https://www.google.com/recaptcha/
$keys = array(
	'site_key' => '',
	'secret_key' => '',
);

//Instantiate the Recaptcha class as $recaptcha
$recaptcha = new Recaptcha($keys);

if ($recaptcha->set()) {
	if ($recaptcha->verify($_POST['g-recaptcha-response']) == 1) {
		$captcha = true;
	} else {
		$captcha = false;
	}
} else {
	$captcha = true;
}

if (!isset($config->complete)) {
	return include $pages['setup'];
}

$messages = array();
if (isset($_GET['activation']) && !isset($_POST['cmd']) && (!isset($core->user) || empty($core->user))) {
	if (!strlen($_GET['code']) || !ctype_alnum($_GET['code'])) {
		$messages[] = 'Bad activation code or your account is already activated.';
		exit;
	}
	$user = $mysql->fetch_array('select `id` from `users` where `activation_code`=:code and `activated`=0;', array('code' => $_GET['code']));
	if (count($user)) {
		$messages[] = 'Your account has been activated, you may now login.';
		$mysql->query('update `users` set `activated`=1 where `activation_code`=:code;', array('code' => $_GET['code']));
	} else {
		$messages[] = 'Bad activation code or your account is already activated.';
	}
}

if (isset($_GET['forgotpassword']) && !isset($_POST['cmd'])) {
	if (!strlen($_GET['code']) || !ctype_alnum($_GET['code'])) {
		$messages[] = 'Bad code.';
		exit;
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
}

if (isset($_GET['logout'])) {
	if (isset($core->user)) {
		unset($core->user);
		print $core->logout();
		print '<meta http-equiv="refresh" content="2;url=//' . $config->server_dm . '/">';
		return;
	}
}

if (isset($_GET['relogin'])) {
	if (isset($core->user)) {
		$relog =  $core->refreshLogin(false, true);
        print $relog['flash'];
        if (!$core->user->isAdmin()) {
		if (isset($_SERVER['HTTP_REFERER']) && !empty($_SERVER['HTTP_REFERER'])) {
			print '<meta http-equiv="refresh" content="0;url=' . $_SERVER['HTTP_REFERER'] . '">';
		} else {
			print '<meta http-equiv="refresh" content="0;url=//' . $config->server_dm . '/">';
		}
        }
	}
}

if (isset($_POST['cmd'])) {
	switch ($_POST['cmd']) {
	case 'forgot-password':
		$user = $mysql->fetch_array('select `username`, `email` from `users` where `activated`=1 and `email`=:email', array('email' => $_POST['email']));
		if ($_POST['email'] == "") {
			$message[] = "Please enter a valid email address.";
		} else if (count($user)) {
			$username = $user[0]['username'];
			$code = md5($core->random_letters(32));
			$html = 'Please click <a href="//' . $config->server_dm . '/profile?forgotpassword&code=' . $code . '">here</a> to reset your password.<br /><br />Or go here if the above link does not work: <br />http://' . $config->server_dm . '/profile?forgotpassword&code=' . $code . '';
			$core->email($user[0]['email'], 'Confirm Lost Password At ' . $config->server_dm, $html);
			$mysql->query('update `users` set `new_password`=:code where `email`=:email AND `email`!="";', array('code' => $code, 'email' => $user[0]['email']));
			$messages[] = "You have been emailed confirmation to change your password.";
		} else {
			$messages[] = "Sorry, nobody with that email has registered or you have not activated your account yet.";
		}
		break;
	case 'update_pawn':
		if (isset($core->user)) {
			if ($core->user->isAdmin() || @$core->user->hasCustomPawn()) {
				if (substr($_POST['update_pawn'], 0, 1) == '#') {
					$_POST['update_pawn'] = @substr($_POST['update_pawn'], 1);
				}

				if (!isset($_POST['update_pawn']) || (!$core->user->isAdmin() && (strlen($_POST['update_pawn']) != 6 || !ctype_xdigit($_POST['update_pawn'])))) {
					$_POST['update_pawn'] = 'off';
				}

				$mysql->query('update `users` set `custpawn`=:pawn where `id`=' . $core->user->getID() . ';', array('pawn' => $_POST['update_pawn']));
			}
		}
		break;
	case 'update_cpawn':
		if (isset($core->user)) {
			if (@$core->user->hasCustomCyclePawn()) {
				if (substr($_POST['update_cpawn'], 0, 1) != 'y') {
					$_POST['update_cpawn'] = 'off';
				}

				if (!isset($_POST['update_cpawn']) || strlen($_POST['update_cpawn']) < 16) {
					$_POST['update_cpawn'] = 'off';
				}

				$mysql->query('update `users` set `custcyclepawn`=:pawn where `id`=' . $core->user->getID() . ';', array('pawn' => $_POST['update_cpawn']));
			}
		}
		break;
	case 'change_pass':
		if (isset($core->user)) {
			if (empty($_POST['new']) || empty($_POST['confirm']) || empty($_POST['old'])) {
				$messages[] = "Please fill out all of the fields.";
				break;
			}
			if ($_POST['new'] != $_POST['confirm']) {
				$messages[] = "Please make sure both passwords match.";
				break;
			}
			$user = $mysql->fetch_array('select `password` from `users` where `id`=:a;', array('a' => $core->user->getID()));
			if (!$mysql->validate($_POST['old'], $user[0]['password'])) {
				$messages[] = "Incorrect password.";
				break;
			}
			if ($mysql->validate($_POST['old'], $user[0]['password'])) {
				$mysql->query('update `users` set `password`=:h where `id`=:u;', array('h' => $mysql->hash($_POST['new']), 'u' => $core->user->getID()));
				$messages[] = "Your password has been changed successfully.";
				break;
			}
		}
		break;
	case 'change_email':
		if (isset($core->user)) {
			if (empty($_POST['new']) || empty($_POST['confirm'])) {
				$messages[] = "Please fill out all of the fields.";
				break;
			}
			if ($_POST['new'] != $_POST['confirm']) {
				$messages[] = "Please make sure both emails match.";
				break;
			}
			if (!filter_var($_POST['new'], FILTER_VALIDATE_EMAIL)) {
				$messages[] = 'Please enter a valid email address.';
				break;
			}
			$user = $mysql->fetch_array('select `id`, `email`, `activated`, `email_changed` from `users` where `email`=:a and `id`!=' . $core->user->getID(), array('a' => $_POST['new']));
			if (count($user)) {
				if ($user[0]['id'] != $core->user->getID() && $user[0]['email'] == $_POST['new']) {
					$messages[] = 'Someone already has that email.';
					break;
				}
			}
			$user = $mysql->fetch_array('select * from `users` where `id`=:a and `email_changed`=0 and `activated`=0;', array('a' => $core->user->getID()));
			if ($user[0]['id'] == $core->user->getID() && !$user[0]['activated'] && !$user[0]['email_changed']) {
				$email = $_POST['new'];
				$code = md5($email . time());
				$mysql->query('update `users` set `activation_code`=:a, `email`=:e, `email_changed`=1 where `id`=:u;', array('a' => $code, 'u' => $core->user->getID(), 'e' => $email));
				$core->email($email, 'Activating Your Account At ' . $config->server_dm, 'Please click <a href="//' . $config->server_dm . '/profile?activation&code=' . $code . '">here</a> to activate your account');
				$messages[] = "Email changed and activation code has been sent to your email.";
				break;
			} else {
				$messages[] = "Must I ask?";
				break;
			}
		}
		break;
	}
}

if (count($messages) > 0) {
	print '<div class="alert alert-dismissable alert-info">
	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
	<center>' . implode('<br />', $messages) . '</center></div>';
}

if (isset($core->user) && $core->user->getUsername()) {
	$user = $mysql->fetch_array('select * from `users` where `username`=:uname;', array('uname' => $core->user->getUsername()));
	if (count($user) == 1) {
		$user = (object) $user[0];
		if (@$user->torched != 0) {
			print '<div class="alert alert-danger"><center>This user is torched.</center></div>';
			if (!@$core->user->isAdmin()) {
				die();
			}

		}
		$user->nickname = base64_decode($user->nickname);
		$nickname = @mb_convert_encoding(htmlentities(html_entity_decode(substr($user->nickname, 0, strpos($user->nickname . '##', '##')))), "UTF-8", "auto");
		$nickname = preg_replace('/\([^)]*\)+/', '', $nickname);
		$pcount = count($core->GetUserPower($user->id));
		?>
<section class="section">
	<div class="container">
		<div class="row gap-y">
			<div class="col-12 col-lg-4">
				<div class="card bg-gray">
					<div class="card-block">
						<h5 class="card-title"><?php print substr($nickname, 0, 50) == "" ? $user->username : trim(substr($nickname, 0, 50));?></h5>
							<?php print setupAvy($user->avatar);?>
					<table class="table">
						<tr>
							<td>ID:</td>
							<td><?php print $user->id;?></td>
						</tr>
						<tr>
							<td>Powers:</td>
							<td><?php print count_format($pcount);?></td>
						</tr>
						<tr>
							<td>xats:</td>
							<td><?php print count_format($user->xats);?></td>
						</tr>
						<tr>
							<td>Days:</td>
							<td><?php print count_format(floor($user->days / 86400));?></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="col-12 col-lg-8">
				<?php
		$custpawn = !empty($user->custpawn) ? $user->custpawn : (@$core->user->isAdmin() ? 'off' : false);
		$custcyclepawn = !empty($user->custcyclepawn) ? @$user->custcyclepawn : (@$core->user->isAdmin() ? 'off' : false);
		$activated = $user->activated == 1 && $user->email_changed == 1 ? true : false;
		print '
		<div class="row gap-y"><div class="col-12 col-lg-6">
				<div class="card bg-gray">
					<div class="card-block">';
		print '
						<h5 class="card-title">Manage</h5>';
		print "<center><a class=\"btn\" target=\"_blank\" href=\"/profile?relogin\" style=\"width:30%;\">Relog</a>&nbsp;&nbsp;";
		print "<a class=\"btn\" target=\"_blank\" href=\"/profile?logout\" style=\"width:30%;\">Logout</a><br /><br />";
		print "<a class=\"btn\" target=\"_blank\" href=\"/editprofile\" style=\"width:178px;\">&nbsp;Edit iXatSpace&nbsp;</a></center>";
		print '</div></div></div>';
		if ($custpawn || $custcyclepawn) {
			print '<div class="col-12 col-lg-6">
				<div class="card bg-gray">
					<div class="card-block">
						<h5 class="card-title">Custom Pawns</h5>';
			if ($custpawn) {
				print "<form method=\"post\">
								<label>Color pawn:</label>
								<div class=\"input-group input-group-sm\">
									<input type=\"text\" class=\"form-control\" name=\"update_pawn\" placeholder=\"{$user->custpawn}\">
									<span class=\"input-group-btn\">
										<button class=\"btn\" type=\"submit\" name=\"cmd\" value=\"update_pawn\">Update</button>
									</span>
								</div>
							</form>";
			}
			if ($custcyclepawn) {
				print "<form method=\"post\">
								<label>Cycle pawn:</label>
								<div class=\"input-group input-group-sm\">
									<input type=\"text\" class=\"form-control\" name=\"update_cpawn\" placeholder=\"{$user->custcyclepawn}\">
									<span class=\"input-group-btn\">
										<button class=\"btn\" type=\"submit\" name=\"cmd\" value=\"update_cpawn\">Update</button>
									</span>
								</div>
							</form>";
			}
			print '</div></div></div></div>';
		}
		print '
		<div class="row gap-y">';
		if (!$activated) {
			print '<div class="col-12 col-lg-6">
				<div class="card bg-gray">
					<div class="card-block">
						<h5 class="card-title">Change Email</h5>';
			print "<form method=\"post\">
							<div class=\"input-group input-group-sm\">
								<label>New email:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
								<input type=\"email\" class=\"form-control\" name=\"new\">
							</div>
							<div class=\"input-group input-group-sm\">
								<label>Confirm email:</label>
								<input type=\"email\" class=\"form-control\" name=\"confirm\">
							</div>
								<center><button class=\"btn\" type=\"submit\" name=\"cmd\" value=\"change_email\">Change</button><center>
						</form>";
			print '</div></div></div>';
		}
?>
		<div class="col-12 col-lg-6">
				<div class="card bg-gray">
					<div class="card-block">
						<h5 class="card-title">Change Password</h5>
		<form method="post">
				<table>
					<tr>
						<td>Old password:&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td><input type="password" class="form-control" name="old"></td>
					</tr>
					<tr>
						<td>New password:&nbsp;&nbsp;&nbsp;&nbsp;</label>
						<td><input type="password" class="form-control" name="new"></td>
					</tr>
					<tr>
						<td>Confirm password:</label>
						<td><input type="password" class="form-control" name="confirm"></td>
					</tr>
					<tr>
						<td colspan="2"><button class="btn" type="submit" name="cmd" value="change_pass">Change</button></td>
					</tr>
				</table>
				</form>
		</div></div></div>
		<div class="col-12 col-lg-6">
				<div class="card bg-gray">
					<div class="card-block">
						<h5 class="card-title">Current group power assignments:</h5>
					<div class="row">
					<?php
		$gp = $mysql->fetch_array("SELECT * FROM `group_powers` where `assignedBy`=:uid;", ["uid" => $user->id]);
		foreach ($gp as $pow) {
			$pname = ucfirst($mysql->fetch_array("SELECT name FROM `powers` where `id`=:id;", ["id" => $pow['power']])[0]['name']);
			print "<div class=\"col-xs-6\">{$pname}: <a href=\"http://{$config->server_dm}/{$pow['chat']}\">{$pow['chat']}</a></div>";
		}
		?>
					</div>
				</div>
			</div></div></div>
			</div></div></div>
        </section>
    </div>
	<?php
} else {
		die('<div class="alert alert-danger"><center>This user doesn\'t exist.</center></div>');
	}
}

function setupAvy($avatar) {
	global $config;
	if (empty($avatar)) {
		return '<img class="img-rounded img-responsive" src="//www.wallpaper-network.com/wp-content/uploads/2011/09/skull-and-bones-wallpaper-250x250.jpg" />';
	}
	if ($avatar{0} == "(") {
		return '<embed src="//' . $config->server_dm . '/web_gear/flash/smiliesshow.swf" flashvars="r=' . str_replace(array('(', ')'), '', $avatar) . '" wmode="transparent" quality="high" type="application/x-shockwave-flash" align="middle" width="94%">';
	} else if (is_numeric($avatar)) {
		return '<img class="img-rounded img-responsive" src="//' . $config->server_dm . '/web_gear/chat/av/' . $avatar . '.png" style="background-color: transparent;width: 100%;border: 1px rgba(204, 204, 204, 1) solid;margin-top: 10px;">';
	} else {
		list($width, $height) = @getimagesize($avatar);
		$avatar = @explode("#", $avatar)[0];
		if ($width >= ($height * 2)) {
			$height = $height == 0 ? 1 : $height;
			$duration = @round(floor($width / $height) / 15);
			$duration = $duration == 0 ? 1 : $duration;
			$keyframes = '@-webkit-keyframes AviAnimation {from{background-position:0px;} to{background-position:-' . $width . 'px;}}@-moz-keyframes AviAnimation {from{background-position:0px;} to{background-position:-' . $width . 'px;}}@-ms-keyframes AviAnimation{from{background-position:0px;} to{background-position:-' . $width . 'px;}} @-o-keyframes AviAnimation {from{background-position: 0px;} to{background-position:-' . $width . 'px;}} @keyframes AviAnimation {from{background-position: 0px;} to{background-position:-' . $width . 'px;}}';
			$steps = @floor($width / $height);
			$animation = '-webkit-animation: AviAnimation ' . $duration . 's steps(' . $steps . ') infinite;-moz-animation: AviAnimation ' . $duration . 's steps(' . $steps . ') infinite;-ms-animation: AviAnimation ' . $duration . 's steps(' . $steps . ') infinite;-o-animation: AviAnimation ' . $duration . 's steps(' . $steps . ') infinite;animation: AviAnimation ' . $duration . 's steps(' . $steps . ') infinite;';
			return '<style>' . $keyframes . '</style><div style="background-image:url(\'' . $avatar . '\');background-size:cover;position:relative;top:10px;height:' . $height . ';width:' . $height . ';margin:auto;' . $animation . ';"></div>';
		} else {
			return '<img class="img-rounded img-responsive" src="' . $avatar . '" style="background-color: transparent;width: 100%;border: 1px rgba(204, 204, 204, 1) solid;margin-top: 10px;">';
		}
	}
	return $showavi;
}

function count_format($n, $point = '.', $sep = ',') {
	if ($n < 0) {
		return 0;
	}

	if ($n < 10000) {
		return number_format($n, 0, $point, $sep);
	}

	$d = $n < 1000000000 ? ($n < 1000000 ? 1000 : 1000000) : 1000000000;
	$f = round($n / $d, 1);
	$l = $d == 1000 ? 'k' : ($d == 1000000 ? 'M' : 'B');
	return number_format($f, $f - intval($f) ? 1 : 0, $point, $sep) . $l;
}
?>
