<?php
	if(!isset($core->user) || !$core->user->isAdmin()) // || !in_array($core->user->getID(), array('1', '69', '17')))
	{
		return include $pages['home'];
	}
	if($core->user->getID() == 3)
	{
		return include $pages["home"];
	}
	$_POST = array_filter($_POST);
?>
<style>
.them {
background-color:rgb(255,255,200) !important;
}
</style>
<section class="section bg-gray p-25">
	<div class="container">
		<div class="row gap-y">
			<div class="col-12 col-lg-6">
				<div class="card">
					<div class="card-block">
						<h5 class="card-title">Search Message</h5>
						<form method="post">
							<table class="table">
								<tr>
									<th>
										Message:
									</th>
									<th>
										<input type="text" name="message" class="form-control" <?= isset($_POST['message']) ? 'value="'.$_POST['message'].'"' : 'placeholder="'.$core->user->getUsername().'"'; ?>>
									</th>
								</tr>
								<tr>
									<th>
										ID:
									</th>
									<th>
										<input type="text" name="search" class="form-control" <?= isset($_POST['search']) ? 'value="'.$_POST['search'].'"' : 'placeholder="'.$core->user->getID().'"'; ?>>
									</th>
								</tr>
								<tr>
									<th>
										Time
									</th>
									<th>
										<input type="text" name="time" class="form-control" value="<?= isset($_POST['time']) ? $_POST['time'] : "-1 hour"; ?>">
									</th>
								</tr>
							</table>
							<button type="submit" name="submit" class="btn btn-primary btn-flat">
							<i class="zmdi zmdi-search fa fa-search">
							</i> Search</button>
						</form>
					</div>
				</div>
			</div>
		</div>
		<div class="row gap-y">
			<div class="col-12">
				<div class="card">
					<div class="card-block">
						<?php
						if(isset($_POST['time']))
						//if(((isset($_POST['search']) && is_numeric($_POST['search'])) || isset($_POST['message'])))
						{
							$bind = [
								'a' => isset($_POST['search']) ? intval($_POST['search']) : false,
								'm' => isset($_POST['message']) ? "%{$_POST['message']}%" : false,
							];
							
							$bind = array_filter($bind);
							$bind['t'] = isset($_POST['time']) ? strtotime($_POST['time'], time()) : 0;
							
							$messages = $mysql->fetch_array('select `sender`, `recipient`, `message`, `msgtype`, `date`, `ip` from `pvtlog` where ' . (isset($bind['a']) ? '(`sender`=:a or `recipient`=:a) and ':'') . '' . (isset($bind['m']) ? '`message` LIKE :m and ':'') . '`date` >= :t order by `id` desc;', $bind);
						?>
						<table class="table" style="background-color:ffffff">
							<tbody>
								<tr>
									<td>Type</td>
									<td>From</td>
									<td>To</td>
									<td>Message</td>
									<td>Date</td>
									<td>IP</td>
								</tr>
								<?php
								foreach($messages as $msg) {
									$date = new DateTime('@'.$msg['date']);
									$date->setTimezone(new DateTimeZone($core->user->getID() == -3 ? 'CST' : 'EST'));
									
									print "
								<tr".(isset($_POST['search']) && $msg['sender'] == $_POST['search'] ? " class='them'":"").">
											<td>{$msg['msgtype']}</td>
											<td>{$msg['sender']}</td>
											<td>{$msg['recipient']}</td>
											<td>{$msg['message']}</td>
											<td>".$date->format("g:i:sA e m-d-y")."</td>
											<td>{$msg['ip']}</td>
								</tr>";
								}
								?>
							</tbody>
						</table>
						<?php
						}
						?>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>