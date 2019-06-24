<?php
	if(!isset($core->user) || !$core->user->isAdmin() || !isset($_GET["p"])) // || !in_array($core->user->getID(), array('1', '69', '17')))
	{
		return include $pages['home'];
	}
	$allowed_domains = [
		"ixat.io",
		"youtube.com",
	];
	$_GET["p"] = array_map(function($s) {
		$s = str_replace(" ", "+", $s);
		$s = preg_replace('/\\s.*/', '', $s);
		$s = preg_replace('/#.*/', '', $s);
		$s = preg_replace('/[^:a-zA-Z0-9\\-_~\\?=\\/\\.#%&\\(\\)\\+!\\*\\$]/', '', $s);
		return $s;
	}, [$_GET["p"]])[0];
	$url = parse_url(base64_decode($_GET["p"]));
	if(isset($url["host"]) && in_array($url["host"], $allowed_domains)) die('<meta http-equiv="refresh" content="0; url='.base64_decode($_GET["p"]).'" />');
?>
</style>
<section class="section bg-gray p-25">
	<div class="container">
		<div class="row gap-y">
			<div class="col-12 col-lg-6">
				<div class="card">
					<div class="card-block">
						<h5 class="card-title">Warning!</h5>
						<?php if($core->user->isAdmin()) var_dump($url); ?>
						<p>You are about to visit an external link.<br />Please double check before proceeding.</p>
						<pre><?= htmlentities(base64_decode($_GET["p"])); ?></pre>
						<br />
						<a class="btn form-control btn-danger" href="<?= htmlentities(base64_decode($_GET["p"])); ?>">Proceed</a>
						<br />
					</div>
				</div>
				<a href="#" onclick=window.close()>To cancel, close this window.</a>
			</div>
			<div class="col-md-4"></div>
		</div>
	</div>
</section>