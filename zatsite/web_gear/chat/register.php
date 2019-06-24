<?php

$mode = intval($_REQUEST['mode']);
if($mode > 4 || $mode == 2) $mode = 0;//Only allow user to set 0 - 4, 5+ is for response messages
if($mode == 4 || $mode == 1) {
	require str_replace('\\', '\\\\', "../../_class/") . 'recaptcha.php';

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
	}
	$captcha = true;
}
$return = "";

if(array_key_exists('ForgotPassword',$_POST)) {
	if(empty($return))
		$mode = 6;//if success
}

if(array_key_exists('Login',$_POST)) {
	$id = 0;
	$username = "USERNAME";
	$password = "PASSWORD";
	$h = "{$username} ({$id})";
	$embed = Embed($username, $password);
	
	if(empty($return))
		$mode = 5;//if success
}

if(array_key_exists('Register',$_POST)) {
	$return = "";
	$return = "Something went wrong";
	if(empty($return))
		$mode = 7;//if success
}

if(!empty($return)) $return = '<center><p style="color:#FF0000"><strong>**' . $return . '**</strong></p></center>';
//require str_replace('\\', '\\\\', "../../_class/") . 'pdo.php';
//$pdo = new Database();
//if(!$pdo->conn) die();
	
?>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Register or Login</title>
	<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
	<link rel="stylesheet" href="//ixat.io/cache/cache.php?f=bootstrap.css&d=css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
	<link rel="stylesheet" href="//ixat.io/cache/cache.php?f=main.min.css&d=css">
	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
	<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->
</head>
<body class="hold-transition login-page">
	<div class="login-box">
		<div class="login-logo">
			<a href="../../"><b>ixat.io</b></a>
		</div>
		<?php
			if($mode == 1) {
		?>
			<div class="login-box-body">
				<?php print $return; ?>
				<p class="login-box-msg">Register a new account</p>
				<form method="post">
					<div class="form-group has-feedback">
						<input type="text" class="form-control" placeholder="Username">
						<span class="glyphicon glyphicon-user form-control-feedback"></span>
					</div>
					<div class="form-group has-feedback">
						<input type="email" class="form-control" placeholder="Email">
						<span class="glyphicon glyphicon-envelope form-control-feedback"></span>
					</div>
					<div class="form-group has-feedback">
						<input type="password" class="form-control" placeholder="Password">
						<span class="glyphicon glyphicon-lock form-control-feedback"></span>
					</div>
					(Warning: Legit email is required for activation, stop losing your passwords, eh?)
					<center><?php print $recaptcha->render(); ?></center>
					<div class="row">
						<div class="col-md-4"></div>
						<div class="col-md-4">
							<button type="submit" name="Register" class="btn btn-primary btn-block btn-flat">Register</button>
						</div>
						<div class="col-md-4"></div>
					</div>
				</form>
				<br />
				<a href="register.php?mode=0" class="text-center">I already have an account</a>
			</div>	
		<?php
			} else if($mode == 4) {
		?>
			<div class="login-box-body">
				<?php print $return; ?>
				<form method="post">
					<div class="form-group has-feedback">
						<input type="email" class="form-control" placeholder="Email">
						<span class="glyphicon glyphicon-envolope form-control-feedback"></span>
					</div>
					<center><?php print $recaptcha->render(); ?></center>
					<br>
					<div class="row">
						<div class="col-md-3"></div>
						<div class="col-md-6">
							<button type="submit" name="ForgotPassword" class="btn btn-primary btn-block btn-flat">Forgot My Password</button>
						</div>
						<div class="col-md-3"></div>
					</div>
				</form>
			</div>
		<?php
			} else if($mode == 5) {
		?>
			<script>
				function LoggedIn(ok) 
				{
					var s = "<H3>Login as <?php print $h; ?>  successful.<BR>Please close all chat windows. </H3><P><LARGE> DO NOT SHARE YOUR LOGIN DETAILS OR YOU WILL LOCK YOURSELF OUT OF THE CHAT</LARGE></P>";
					if(!ok) 
						s = "<H3>Login failed..</H3>";
					var divId=document.getElementById("LoginResult");
					if(divId) 
						divId.innerHTML = s;
				}
			</script>
			<div class="login-box-body">
				<?php print $embed; ?>
			</div>
		<?php
			} else if($mode == 6) {
		?>
			
			<div class="login-box-body">
				You have been emailed your account information.
			</div>
		<?php
			} else if($mode == 7) {
		?>
			
			<div class="login-box-body">
				Registration successful, please check your email for your activation code.
			</div>
		<?php
			} else {
		?>
			<div class="login-box-body">
				<p class="login-box-msg">Sign in</p>
				<?php print $return; ?>
				<form method="post">
					<div class="form-group has-feedback">
						<input type="text" class="form-control" placeholder="Username">
						<span class="glyphicon glyphicon-user form-control-feedback"></span>
					</div>
					<div class="form-group has-feedback">
						<input type="password" class="form-control" placeholder="Password">
						<span class="glyphicon glyphicon-lock form-control-feedback"></span>
					</div>
					<div class="row">
						<div class="col-md-4"></div>
						<div class="col-md-4">
							<button type="submit" name="Login" class="btn btn-primary btn-block btn-flat">Login</button>
						</div>
						<div class="col-md-4"></div>
					</div>
				</form>
				<br />
				<a href="register.php?mode=4">I forgot my password</a><br>
				<a href="register.php?mode=1" class="text-center">Register an account</a>
			</div>
		<?php
			}
		?>
	</div>
	
	<script src="//ixat.io/cache/cache.php?f=query.js&d=js" type="text/javascript"></script>
	<script src="//ixat.io/cache/cache.php?f=bootstrap.min.js&d=js" type="text/javascript"></script>
</body>
</html>
<?php

function Embed($name, $pass)
{
	//xc=512&
	$fv = "id=8&em={$name}&pw=$".$pass;
	$embed = '<div id="LoginResult"><h3><span data-localize=buy.pleasewait>Please wait</span>..<br>&nbsp;</h3><p><large>&nbsp;</large></p></div>
<BR> <embed src="//ixat.io/cache/cache.php?f=chat.swf&d=flash" quality="high" width="220" height="140" name="chat" FlashVars="'.$fv.'" align="middle" allowtAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://xat.com/update_flash.php" /><br>
<p>IMPORTANT: If you see a box like this please press \'Allow\'. If you do not you will not be able to store friends or use the chat. If you see this box you will need to log in again.</p> <br> <img border="0" src="http://xat.com/images/FlashSettings1.gif" />';

	return $embed;	
}
?>
