<?php
	if(!isset($config->complete))
	{
		return include $pages['setup'];
	}
	
	if(isset($_POST['search']) && is_string($_POST['search']))
	{
		$json = new stdClass();
		$json->messages = $mysql->fetch_array('select `message`, `name`, `mid` from `messages` where `message` like :a AND visible=1 order by `id` desc limit 0, 25;', array('a' => '%' . $_POST['search'] . '%'));
		
		print json_encode($json);
		exit;
	}
	
	if(isset($_POST['del']) && is_numeric($_POST['del']) && $_POST['del'] != '' && $core->user->getServerRank() == RANK_ADMIN)
	{
		$json = new stdClass();
		
		$delete = $mysql->query('delete from `messages` where `mid`=:message;', array('message' => $_POST['del']));
		
		$json->status = $delete ? 'SUCCESS' : 'FAILURE';
		
		print(json_encode($json));
		exit;
	}
?>
<section class="section bg-gray p-25">
	<div class="container">
		<div class="row gap-y">
			<div class="col-12 col-lg-6">
				<div class="card">
					<div class="card-block">
						<h5 class="card-title">Search Message</h5>
						<div class="input-group">
							<input type="text" class="form-control msearchinput" placeholder="Search...">
							<span class="input-group-btn">
								<button type="submit" name="search" id="search-btn" class="btn btn-flat msearchsubmit"><i class="zmdi zmdi-search fa fa-search"></i>
								</button>
							</span>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="alert alert-info"><center> Messages </center></div>
		<div class="showmessages">
			
		</div>
	</div>
</section>