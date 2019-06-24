<?php
	if(!isset($core->user) || !$core->user->isAdmin() || isset($core->user) && $core->user->getID() == 3) // || !in_array($core->user->getID(), array('1', '69', '17')))
	{
		return include $pages['home'];
	}
?>
<section class="section p-25">
	<div class="container">
		<div class="row gap-y">
			<div class="col-12 col-lg-6">
				<div class="card">
					<div class="card-block">
						<h5 class="card-title">Search Message</h5>
						<form method="post">
							<table class="table">
								<tr><th>Chat:</th><th><input type="text" name="search" class="form-control" value="<?= isset($_POST['search']) ? $_POST['search'] : 1; ?>"></th></tr>
								<tr><th>Time:</th><th><input type="text" name="time" class="form-control" value="<?= isset($_POST['time']) ? $_POST['time'] : "-1 hour"; ?>"></th></tr>
							</table>
							<button type="submit" name="submit" class="btn btn-primary btn-flat"><i class="zmdi zmdi-search fa fa-search"></i> Search</button>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
<section class="section p-25 bg-gray">
	<div class="container">
		<div class="row gap-y">
			<?php
			if(isset($_POST['search']))
			{
				$chat = $mysql->fetch_array('select `id` from `chats` where `name`=:chat or `id`=:chat;', array('chat' => $_POST['search']));
				if(count($chat) > 0) {
					$messages = $mysql->fetch_array('select `uid`, `message`, `registered`, `time`, `ip` from `messages` where (`id`=:a) and `time` >= :t and `message` not like :m order by `time` desc;', array('a' => $chat[0]['id'], 'm' => "%http://ixat.io/giveaway%", 't' => strtotime($_POST['time'], time())));
			?>
			<table class="table table-bordered table-hover" style="background-color:ffffff"><tbody>
				<tr>
					<td>ID</td>
					<td>Regname</td>
					<td>Message</td>
					<td>Date</td>
					<td>IP</td>
				</tr>
				<?php
				foreach($messages as $msg) {
					print "
				<tr>
					<td>{$msg['uid']}</td>
					<td>{$msg['registered']}</td>
					<td>{$msg['message']}</td>
					<td>".date("g:i:sA e m-d-y", $msg['time'])."</td>
					<td>{$msg['ip']}</td>
				</tr>";
				}
				?>
			</tbody></table>
			<?php
			}
			}
			?>
		</div>
	</div>
</section>