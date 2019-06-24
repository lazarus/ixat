<?php
define("IP", "198.251.80.114");
define("PORT", "337");
if(!isset($config->complete))
{
	return include $pages['setup'];
}
$roomid = intval($_REQUEST['id']);
$pass = intval($_REQUEST['pw']);
if($roomid) {
	$chat = $mysql->fetch_array('select * from `chats` where `id`=:id', array('id' => $roomid));
	if((!empty($chat) && $mysql->validate($pass, $chat[0]['pass'])) || $core->user->isAdmin()) {
		$sock = fsockopen(IP, PORT, $e, $e, 1);
		fwrite($sock, '<us k="K#DF7N57*Y%fS7y%" t="/s' . $core->xatTrim(urldecode($_REQUEST['Message']), 180) . '" c="' . $roomid . '" />');
		fclose($sock);
	}
}
?>
<section class="section bg-gray p-25">
	<div class="container">
		<div class="row gap-y">
			<div class="col-12 col-lg-6">
				<div class="card">
					<div class="card-block">
						<h5 class="card-title">Set chat scroller</h5>
						<form method="post">
							<table class="table">
								<tr> <td> <font color="white">Scroller message:</td> <td><input type="text" name="Message"> </td> </tr>
								<tr> <td> <font color="white">Chat id number:</td> <td><input type="text" name="id"> </td> </tr>
								<tr> <td> <font color="white">Chat password:</font> </td> <td><input type="password" name="pw"> </td> </tr>
							</table>
							<center><button class="btn btn-primary" type="submit"/>Submit</button><center>
						</form>
					</div>
				</div>
			</div>
			<div class="col-sm-4"></div>
		</div>
	</div>
</section>