<?php						
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

ob_implicit_flush();
date_default_timezone_set(@date_default_timezone_get());

define('_sep', str_replace('\\', '\\\\', DIRECTORY_SEPARATOR));
define('_root', str_replace('\\', '\\\\', __DIR__) . _sep);
require _root . '_class' . _sep . 'class.php';
$cn = $core->cn;


$maintenance = false;
$soon = false;

if(empty($_GET["soon"]) && (in_array(md5($_SERVER['REMOTE_ADDR']), [])
  || md5(substr($_SERVER["REMOTE_ADDR"], 0, strrpos($_SERVER["REMOTE_ADDR"], "."))) == "")) {
	ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);
	//$core->user->setAdmin(true);
} else if($maintenance){
	header("Location: http://xatech.co/web_gear/maintenance.html");
} else if($soon) {
	return include _root . "coming_soon.php";
}

$fullscreen = in_array(strtolower($core->page), ["login","register","forgot"]);

$title = "ixat";

if($core->page == "chat")
	$title = htmlentities($core->chat[0]["name"]) . " chat group - " . htmlentities($core->chat[0]["desc"]);
else if($core->page != "landing")
	$title .= " - " . implode(" ", array_map("ucfirst", explode("_", htmlentities($core->page))));

ob_start();
?>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta name="description" content="<?= i18n::get('index.title'); ?>">
		<meta name="keywords" content="ixat,xat,zat,xatech,zatech,xats,powers,days,everypower,ruby,textcolor,textglow,sapphire,xat powers,xats trade,xat.me,xatspace,free xats,chat group">
		<title><?= $title; ?></title>
		<!-- Styles -->
		<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0/css/bootstrap.css">
		<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css">
		<link href="/cache/cache.php?d=css&f=core.min.css" rel="stylesheet">
		<link href="/cache/cache.php?d=css&f=ixat.min.css" rel="stylesheet">
		<link href="/cache/cache.php?d=css&f=style.css" rel="stylesheet">
		<link href="/cache/cache.php?d=css&f=notify-metro.css" rel="stylesheet">
		<!-- Favicons -->
		<link rel="apple-touch-icon" href="/cache/cache.php?d=img&f=apple-touch-icon.png">
		<link rel="icon" href="/cache/cache.php?d=img&f=favicon.png">
	</head>
	<body<?= $fullscreen ?' class="mh-fullscreen bg-img center-vh p-20" style="background-image: url(/cache/cache.php?d=img&f=bg-girl.jpg);"':'';?>>
		<canvas id="canvas"></canvas>
<?php
if(!$core->isChat() && !$fullscreen) {
?>
		<!-- Topbar -->
		<nav class="topbar topbar-inverse topbar-expand-sm<?= $core->page == "landing" ? "" : " bg-primary";?>">
			<div class="container">
				<div class="topbar-left">
					<a class="topbar-brand" href="/">
						<img class="logo-default" src="/cache/cache.php?d=img&f=logo.png" alt="logo">
						<img class="logo-inverse" src="/cache/cache.php?d=img&f=logo-light.png" alt="logo">
					</a>
				</div>
<?php
	if(!isset($core->user)) {
?>
				<div class="topbar-right">
					<a class="btn btn-sm btn-white mr-4" href="/login"><?= i18n::get('index.nav.login'); ?></a>
					<a class="btn btn-sm btn-outline btn-white hidden-sm-down" href="/register"><?= i18n::get('index.nav.register'); ?></a>
				</div>
<?php
	} else {
?>
				<div class="topbar-right">
					<ul class="topbar-nav nav">
						<li class="nav-item"><a class="nav-link" href="/home"><?= i18n::get('index.nav.home');?></a></li>
						<li class="nav-item">
							<a class="nav-link" href="#"><?= i18n::get('index.nav.store');?> <i class="fa fa-caret-down"></i></a>
							<div class="nav-submenu">
								<a class="nav-link" href="/powers"><?= i18n::get('index.nav.pow');?></a>
								<a class="nav-link" href="/shortname"><?= i18n::get('index.nav.short');?></a>
								<a class="nav-link" href="/auction"><?= i18n::get('index.nav.auction');?></a>
							</div>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="#"><?= i18n::get('index.nav.group');?> <i class="fa fa-caret-down"></i></a>
							<div class="nav-submenu">
								<a class="nav-link" href="/create"><?= i18n::get('index.nav.create');?></a>
								<a class="nav-link" href="/edit"><?= i18n::get('index.nav.edit');?></a>
							</div>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="#"><?= $core->user->getUsername(); ?> <i class="fa fa-caret-down"></i></a>
							<div class="nav-submenu">
								<a class="nav-link" href="/profile"><?= i18n::get('index.nav.acc');?></a>
								<?php if($core->user->isAdmin()) { ?><a class="nav-link" href="/admin_panel"><?= i18n::get('index.nav.admin'); ?></a><?php } ?>

								<a class="nav-link" href="/login"><?= i18n::get('index.nav.relog');?></a>
								<a class="nav-link" href="/profile?logout"><?= i18n::get('index.nav.logout');?></a>
							</div>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="#"><?= i18n::get('index.nav.get');?> <i class="fa fa-caret-down"></i></a>
							<div class="nav-submenu">
								<a class="nav-link" href="/offers"><?= i18n::get('index.nav.offer');?></a>
								<a class="nav-link" href="/donate"><?= i18n::get('index.nav.donate');?></a>
								<a class="nav-link" href="/5050"><?= i18n::get('index.nav.chance50');?></a>
							</div>
						</li>
						<li class="nav-item"><a class="nav-link" href="/support"><?= i18n::get('index.nav.ticket');?></a></li>
					</ul>
				</div>
<?php
	}
?>
			</div>
		</nav>
		<!-- END Topbar -->
<?php
	if($core->page == "landing") {
?>
		<!-- Header -->
		<header class="header header-inverse h-fullscreen p-0 bg-primary overflow-hidden" style="background-image: linear-gradient(to top, #fad0c4 0%, #fad0c4 1%, #ffd1ff 100%);">
			<div class="container text-center">
				<div class="row h-full">
					<div class="col-12 col-lg-8 offset-lg-2 align-self-center pt-150">
						<h1 class="display-4">ixat.io</h1>
						<br>
						<p class="lead text-white fs-20"><?= i18n::get('index.title'); ?></p>
					</div>
					<div class="col-12 align-self-end text-center">
						<iframe class="shadow-3" data-aos="fade-up" data-aos-offset="0" width="640" height="360" src="http://www.youtube.com/embed/ebguML5GDVw?&autoplay=1&rel=0&fs=0&showinfo=0&disablekb=1&controls=0&hd=1&autohide=1&color=white" frameborder="0" allowfullscreen style="vertical-align: middle;"></iframe>
					</div>
				</div>
			</div>
		</header>
		<!-- END Header -->
<?php
	}
?>
		<!-- Main container -->
		<main class="main-content">
<?php
}

$core->doPage();

if(!$core->isChat() && !$fullscreen) {
?>
		</main>
		<!-- END Main container -->
		<!-- Footer -->
		<footer class="site-footer">
			<div class="container">
				<div class="row gap-y align-items-center">
					<div class="col-12 col-lg-3">
						<p class="text-center text-lg-left">
							<a href="/"><img src="/cache/cache.php?d=img&f=logo.png" alt="logo"></a>
						</p>
					</div>
					<div class="col-12 col-lg-6">
						<ul class="nav nav-primary nav-hero">
							<li class="nav-item">
								<a class="nav-link" href="/home">Home</a>
							</li>
							<!--
							<li class="nav-item">
								<a class="nav-link" href="/lobby">Lobby</a>
							</li>
							-->
							<li class="nav-item">
								<a class="nav-link" href="/offers">Offers</a>
							</li>
							<li class="nav-item hidden-sm-down">
								<a class="nav-link" href="/donate">Donate</a>
							</li>
							<li class="nav-item hidden-sm-down">
								<a class="nav-link" href="/support">Support</a>
							</li>
						</ul>
					</div>
					<div class="col-12 col-lg-3">
						<div class="social text-center text-lg-right">
							<!--
								<a class="social-facebook" href="#https://www.facebook.com/"><i class="fa fa-facebook"></i></a>
								<a class="social-twitter" href="#https://twitter.com/"><i class="fa fa-twitter"></i></a>
								<a class="social-instagram" href="#https://www.instagram.com//"><i class="fa fa-instagram"></i></a>
								<a class="social-dribbble" href="#https://dribbble.com/"><i class="fa fa-dribbble"></i></a>
							-->
						</div>
					</div>
				</div>
			</div>
		</footer>
		<!-- END Footer -->
<?php
}

if(!$core->isChat() && !$fullscreen && isset($core->user) && $core->page != "landing") {
?>
		<div class="dark-mode bg-primary" style="position: absolute;top: 95px;right: -1px;width: 30px;text-align: center;height: 30px;border: 1px solid;"><i class="fa fa-moon-o"></i></div>
		<!--<div onclick="Snow.toggle();" class="bg-primary" style="position: absolute;top: 140px;right: -1px;width: 30px;text-align: center;height: 30px;border: 1px solid;"><i class="fa fa-snowflake-o"></i></div>-->
<?php
}
?>
		<!-- Scripts -->
		<script src="/cache/cache.php?d=js&f=core.min.js"></script>
		<script src="/cache/cache.php?d=js&f=ixat.min.js"></script>
		<script src="/cache/cache.php?d=js&f=js.cookie.js"></script>
		<script src="/cache/cache.php?d=js&f=script.js"></script>
		<script src="/cache/cache.php?d=js&f=notify.js"></script>
		<script src="/cache/cache.php?d=js&f=notify-metro.js"></script>
		<!-- <script src="/cache/cache.php?d=js&f=snow.js"></script> -->
		<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
		<script type="text/javascript" language="javascript" src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0/js/bootstrap.min.js"></script>
		<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
	</body>
</html>
<?php

ob_end_flush();

?>