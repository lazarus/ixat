<?php
	if(!isset($config->complete))
	{
		return include $pages['home'];
	}
	if(!isset($core->user))
	{
		return include $pages['profile'];
	}
	if($core->allset($_POST, 'name', 'pass', 'radio', 'inner'))
	{
		$messages = array();
		
		do
		{
			if(!$core->user->isAdmin())
			{
				if(!ctype_alnum($_POST['name']) || strlen($_POST['name']) < 5 || strlen($_POST['name']) > 15)
				{
					$messages[] = 'Your chats name must consist of 5-15 alphanumeric characters.';
				}
			}
			if(strlen($_POST['pass']) < 6)
			{
				$messages[] = 'Your chat needs a password of at least 6 characters';
			}
			if(!empty($messages)) break;
			
			$test = $mysql->fetch_array('select count(*) as `count` from `chats` where `name`=:a;', array('a' => $_POST['name']));
			if($test[0]['count'] > 0)
			{
				$messages[] = 'That chat name has already been taken';
				break;
			}
			
			$blocked = array('home', 'login','profile','create','edit','register','powers','trade','promote',
			'twitter','donate','youtube','instagram','offers','offer','forum','forums','facebook','zat', 'ixat');
			if(in_array(strtolower(trim($_POST['name'])), $blocked) || substr(strtolower(trim($_POST['name'])), 0, 3) == "zat" || substr(strtolower(trim($_POST['name'])), 0, 4) == "ixat")
			{
				$messages[] = 'That chat name is reserved.';
				break;
				}
			
			$shutup = parse_url($_POST['inner']);
			
			$imgExts = array("gif", "jpg", "jpeg", "png", "tiff", "tif");
			$urlExt = pathinfo($_POST['inner'], PATHINFO_EXTENSION);
			
			if(!in_array($urlExt, $imgExts) || !isset($shutup['scheme']) || $shutup['scheme'] != "http" || strpos($shutup['host'], ".") === false) {
				$messages[] = 'That backgroung is invalid.';
				break;
			}
			
			$mysql->insert('chats',
				array(
					'id' => 'NULL',
					'name' => htmlspecialchars($_POST['name']),
					'bg' => htmlspecialchars($_POST['inner']),
					'outter' => '',
					'sc' => '',
					'ch' => '',
					'email' => $core->user->getEmail(),
					'radio' => htmlspecialchars($_POST['radio']),
					'pass' => $mysql->hash($_POST['pass']),
					'button' => '#000000'
				)
			);
			$mysql->insert('ranks',
				array(
					'userid' => $core->user->getID(),
					'chatid' => $mysql->insert_id(),
					'f' => 1
				)
			);
			
			if($core->user->isAdmin() && isset($_POST['autoassign']))
			{
				$gp = $mysql->fetch_array("select * from `powers` where `group`=1");
				foreach($gp as $pow)
				{
					$groupp['chat'] = htmlspecialchars($_POST['name']);
					$groupp['power'] = $pow['id'];
					$groupp['assignedBy'] = 0;
					$groupp['enabled'] = 0;
					$groupp['count'] = 0;
					$mysql->insert('group_powers', $groupp);
				}
			}
			
			$messages[] = 'Your chat has been created, view it <a href="/' . htmlentities($_POST['name']) . '">HERE</a>';
		} while(false);
		
		foreach($messages as $message)
		{
			print '<div class="alert alert-daniel"><center>' . $message . '</center></div>';
		}
	}
?>
<!--
|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
| Create Group
|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
!-->
<section class="section p-25">
	<div class="container">
		<div class="row gap-y">
			<div class="col-12">
				<div class="card bg-gray">
					<div class="card-block">
						<h5 class="card-title">Create a Group | <small>Fields marked with an (*) are required.</small></h5>
						<form method="post">
							<table class="table">
								<input type="hidden" name="cmd" value="create" />
								<tr> <td>*Name: </td> <td><input name="name" class="form-control" type="text"></td> </tr>
								<tr> <td>*Password: </td> <td><input name="pass" class="form-control" type="password"></td> </tr>
								<tr> <td>Radio: </td> <td><input name="radio" class="form-control" type="text" value="http://relay.181.fm:8128"></td> </tr>
								<tr> <td>Inner BG: </td> <td><input name="inner" class="form-control" type="text" value="<?php print"http://{$config->info["server_domain"]}/web_gear/chat_bgs/" . rand(1, 7) . ".jpg"; ?>"></td> </tr>
								<?php
									if($core->user->isAdmin())
										print '<tr><td colspan="2"><input type="checkbox" name="autoassign">Auto Assign All Group Powers</td></tr>';
								?>
							</table>
							<center><button class="btn btn-primary btn-lg" type="submit"/>Create Group</button></center>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
<section class="section p-25">
	<div class="container">
		<div class="row gap-y">
					<div class="col-12">
			<div class="card bg-gray">
				<div class="card-block">
					<h5 class="card-title">Recent Chats </h5>
						<?php
							$recent = $mysql->fetch_array('select * from `chats` order by `id` desc limit 0, 6;');
							foreach($recent as $chat)
							{
								$imgExts = array("gif", "jpg", "jpeg", "png");
								$urlExt = pathinfo($chat['bg'], PATHINFO_EXTENSION);
								if(!in_array($urlExt, $imgExts))
								$chat['bg'] = '//cdn.ixat.io/image.php?url=http://ixat.io/web_gear/chat_bgs/'.rand(1, 7).'.jpg';
								else
								$chat['bg'] = '//cdn.ixat.io/image.php?url='.htmlentities($chat['bg']);
						
								print '<div class="col-sm-2">
										<div class="box box-primary box-solid">
												<div class="box-header with-border">
														<center>' . htmlentities($chat['name']) . '</center>
												</div>
												<div class="box-body">
														<a target="_blank" href="/' . htmlentities($chat['name']) . '">
																<img src="' . $chat['bg'] . '" width="100%" />
														</a>
												</div>
										</div>
								</div>';
							}
						?>
					</div></div></div></div></div>
				</section>