<?php
if(!isset($core->user) || !$core->user->isAdmin()) // || !in_array($core->user->getID(), array('1', '69', '17')))
{
	return include $pages['home'];
}

DEFINE('POWER_COST_MULTIPLIER', 0.75);

if(isset($_GET['fix'])) {
	$oldId = 316;
	$newId = 213;
	$users = $mysql->fetch_array("SELECT `id`, `powers`, `dO` FROM `users`");
	foreach($users as $user) {
		$userpowers = $core->DecodePowers($user['powers'], $user['dO']);
		$newpowers = [];
		if (is_array($userpowers) && count($userpowers) > 0) {
			foreach($userpowers as $id => $count) {
				if ($oldId == $id) {
					$newpowers[$newId] = $count;   
					//del old power
					//give new
				} else if (!in_array($id, [$oldId, $newId])){
					$newpowers[$id] = $count;
				}
			}

			list($powers, $dO) = $core->EncodePowers($newpowers);

			$mysql->query("UPDATE `users` SET `powers`=:powers,`dO`=:dO WHERE `id`=:uid;", array("uid" => $user['id'], "powers" => $powers, "dO" => $dO)); 
		}
		usleep(25000);
	}
	
}
if(isset($_GET['dfu'])) {
	$users = $mysql->fetch_array("SELECT `id`, `powers`, `dO` FROM `users`");
	foreach($users as $user) {
		$userpowers = $core->DecodePowers($user['powers'], $user['dO']);
		$newpowers = [];
		if (is_array($userpowers) && count($userpowers) > 0) {
			unset($newpowers[$id]);

			list($powers, $dO) = $core->EncodePowers($newpowers);

			$mysql->query("UPDATE `users` SET `powers`=:powers,`dO`=:dO WHERE `id`=:uid;", array("uid" => $user['id'], "powers" => $powers, "dO" => $dO)); 
		}
		usleep(25000);
	}
	
}
if(isset($_GET['p'])) {
	//$mysql->query("update `powers` set `topsh`='mhat,mgrin,mooh,mksad,msmile,mt,we,mwink,mwt,mc,mcry,mg,ml,mmad,mmug' where `id`=310;");
	//$mysql->query("delete from `powers` where `id`=438;");//deleting rick power
	var_dump($mysql->fetch_array('select * from `powers` WHERE `topsh` LIKE "%msad%";', array('id' => $_GET['p'])));
	exit();
}
if(isset($_GET['add_filler'])) {
	$nextid = $mysql->fetch_array("SELECT * FROM `powers` ORDER BY `id` DESC LIMIT 1")[0];
	$id = $nextid['id'] + 1;
	$insert = array(
		'id' => $id, 'name' => $id, 'cost' => 0, 'limited' => 0, 
		'description' => '', 'amount' => 0, 'topsh' => '', 'group' => '',
		'pawn' => 0, 'p' => 0, 'hugs' => ''
	);
	$mysql->insert('powers', $insert); 
}
if(isset($_GET['delpower']) && is_numeric($_GET['delpower'])) {
	//$mysql->query("DELETE FROM `trade` WHERE `powerid`=:id;", array('id' => $_GET['delpower']));
	$mysql->query("DELETE FROM `powers` WHERE `id`=:id;", array('id' => $_GET['delpower']));
	/*$staff = json_decode($config->info['staff'] == '' ? '[]' : $config->info['staff']);
	$staff[] = 854;
	$staff[] = 404;
	foreach($staff as $id) {
		$core->DelUserPower($id, $_GET['delpower']);
	}	*/
}

if(isset($_POST["req"]) && isset($core->user) && $core->user->isAdmin())
{
	switch(@(string) ((string) strtolower($_POST["req"])))
	{
		case 'lookup':
			if(!$core->allset($_POST, 'ip') && !$core->allset($_POST, 'email')) exit('User was not found');
			if(isset($_POST['ip']) && !empty($_POST['ip']) && $_POST['ip'] != "0.0.0.0") {
				$use = "WHERE `connectedlast`=:ip;";
				$arr = array("ip" => $_POST['ip']);
			} else if (isset($_POST['email']) && !empty($_POST['email']) && $_POST['email'] != "user@example.com") {
				$use = "WHERE `email`=:ip;";
				$arr = array("ip" => $_POST['email']);
			}
			if(!isset($use)) exit("Not set");
			if(!isset($arr)) exit("Not set 2");
			$urs = $mysql->fetch_array('select `id`,`username`,`activation_code`,`enabled`,`email`,`connectedlast` from `users` '.$use, $arr);
			if(empty($urs))  exit('User was not found using '. $arr['ip']);
			$return = array();
			foreach($urs as $u) {
				$u = (object)$u;
				$return[] = "ID: {$u->id}";
				$return[] = "Username: {$u->username}";
				$return[] = "IP: {$u->connectedlast}";
				$return[] = "Activation Code: {$u->activation_code}";
				$return[] = "Enabled: " . ($u->enabled == 0 ? "No":"Yes");
				$return[] = "Email: " . ($u->email);
				$return[] = " ";
			}
			exit(implode("\n", $return));
		break;
		case 'search_power':
			if(!$core->allset($_POST, 'search')) break;
			
			$query = 'select * from `powers` WHERE ';
			$query .= is_numeric($_POST['search']) ? '`id`=:search;':'`name`=:search;';
			
			$power = $mysql->fetch_array($query, array('search' => $_POST['search']));
			if(empty($power)) exit("Power doesnt exist.");
			exit(json_encode($power[0]));
			break;
		case "update_power":
			if(!$core->allset($_POST, 'id', 'name', 'topsh', 'hugs', 'description', 'pawn', 'group', 'cost', 'status', 'amount')) break;
			$power = $mysql->fetch_array('select * from `powers` WHERE `id`=:id ;', array('id' => $_POST['id']));
			if(empty($power)) exit("Power doesnt exist.");

			$update['id'] = $_POST['id'];
			$update['name'] = strtolower($_POST['name']);
			$update['cost'] = $_POST['cost'];
			$update['limited'] = $_POST['status'] == 0 ? 1:($_POST['status'] == 2 ? 1:0);
			$update['description'] = $_POST['description'];
			$update['amount'] = $insert['limited'] == 1 ? $_POST['amount']:0;
			$update['topsh'] = $_POST['topsh'];
			$update['group'] = $_POST['group'] == 'true' ? 1:"";
			$update['pawn'] = $_POST['pawn'] == 'true' ? 1:0;
			$update['p'] = $_POST['status'] == 0 ? 0:1;
			$update['hugs'] = $_POST['hugs'];
			$mysql->query('UPDATE `powers` SET `name`=:name, `cost`=:cost, `limited`=:limited, `description`=:description, `amount`=:amount, `topsh`=:topsh, `group`=:group, `pawn`=:pawn, `p`=:p, `hugs`=:hugs WHERE `id`=:id;', $update);
			//$mysql->insert('powers', $insert);
			exit("Power updated!");
		break;			
		case "add_power":
			if(!$core->allset($_POST, 'id', 'name')) break;
			$power = $mysql->fetch_array('select * from `powers` WHERE `id`=:id or `name`=:name;', array('id' => $_POST['id'], 'name' => $_POST['name']));
			if(!empty($power)) exit("There already is a power with that Id/Name.");
			
			$randAmount = array(5, 15, 25, 50, 100);
			$insert['id'] = $_POST['id'];
			$insert['name'] = strtolower($_POST['name']);
			$insert['cost'] = (int)((empty($_POST['price']) ? 200:$_POST['price']) * POWER_COST_MULTIPLIER);
			$insert['limited'] = $_POST['status'] == 0 ? 1:($_POST['status'] == 2 ? 1:0);
			$insert['description'] = empty($_POST['d1']) ? "{$_POST['name']} smilies":$_POST['d1'];
			//$insert['description2'] = empty($_POST['d2']) ? "":$_POST['d2']; // for d2
			$insert['amount'] = $insert['limited'] == 1 ? $randAmount[mt_rand(0, count($randAmount) - 1)]:0;
			$insert['topsh'] = empty($_POST['topsh']) ? "{$_POST['name']}":$_POST['topsh'];
			$insert['group'] = $_POST['grp'] == 'true' ? 1:"";
			$insert['pawn'] = $_POST['pwnp'] == 'true' ? 1:0;
			$insert['p'] = $_POST['status'] == 0 ? 0:1;
			$insert['hugs'] = empty($_POST['hugs']) ? "":$_POST['hugs'];
			$mysql->insert('powers', $insert);
			$staff = json_decode($config->info['staff'] == '' ? '[]' : $config->info['staff']);
			$staff[] = 854;
			$staff[] = 404;
			foreach($staff as $id) {
				$core->AddUserPower($id, $_POST['id']);
			}

			if(isset($_POST['pwns'])) {
				$pwns = @json_decode(@$_POST['pwns']);
				if($pwns && is_array($pwns) && count($pwns) > 0) {
					$spawns = json_decode($config->info['special_pawns']);
					
					$pawns = new StdClass();
					$pawns->time = 1576454400;
					
					foreach($spawns as $key => $value)
						if($key != 'time' && $key != '!')
							$pawns->{$key} = $value;

					foreach($pwns as $key => $value)
						$pawns->{$key} = array(0 => (int)$_POST['id'], 1 => $value[1]);
					
					$pawns->{'!'} = array(0 => 999, 1 => '');
					$mysql->query("UPDATE `server` SET `special_pawns`=:pwns;", array('pwns' => json_encode($pawns)));
				}
			}
			exit(ucfirst($insert['name']) . "[{$insert['id']}] was added successfully!");
			
			/* 
				$pawns = new StdClass();
				$pawns->time = 1576454400;
				$pawns->t = array(0 => 396, 1 => 'p1tigers');
				$pawns->b = array(0 => 397, 1 => 'p1bea1');
				$pawns->f = array(0 => 397, 1 => 'p1bea2');
				$pawns->B = array(0 => 397, 1 => 'p1bea3');
				$pawns->n = array(0 => 397, 1 => 'p1bea4');
				$pawns->{'!'} = array(0 => 999, 1 => '');
				$pawns = json_encode($pawns);
				$mysql->query('UPDATE `server` SET `special_pawns`=:pwns;', array('pwns' => $pawns));
			*/
		break;	
		case 'edit_pawn':
			if(!$core->allset($_POST, 'id', 'name', 'code')) break;
			if(!is_numeric($_POST['id'])) exit("Invalid powerid.");
			
			$power = $mysql->fetch_array('select * from `powers` WHERE `id`=:power;', array('power' => intval($_POST['id'])));
			if(empty($power)) exit('Powerid doesn\'t exist');
			
			if(!ctype_alnum($_POST['code'])) exit("invalid pawn code");
			
			$name = explode('.', $_POST['name'])[0];
			$id = intval($_POST['id']);
			$code = $_POST['code'];
			
			$spawns = json_decode($config->info['special_pawns']);
					
			$pawns = new StdClass();
			$pawns->time = 1576454400;
					
			foreach($spawns as $key => $value)
				if($key != 'time' && $key != '!')
					$pawns->{$key} = $value;

			$pawns->{$code} = array(0 => (int)$id, 1 => $name);
					
			$pawns->{'!'} = array(0 => 999, 1 => '');
			$mysql->query("UPDATE `server` SET `special_pawns`=:pwns;", array('pwns' => json_encode($pawns)));
			exit(ucfirst($name) . " pawn as '{$code}' added requiring id {$id}.");
		break;	
		case 'rem_pawn':
			if(!$core->allset($_POST, 'code')) break;
			
			if(!ctype_alnum($_POST['code'])) exit("invalid pawn code");

			$code = $_POST['code'];
			
			$spawns = json_decode($config->info['special_pawns']);
					
			$pawns = new StdClass();
			$pawns->time = 1576454400;
					
			foreach($spawns as $key => $value)
				if($key != 'time' && $key != '!' && $key != $code)
					$pawns->{$key} = $value;
					
			$pawns->{'!'} = array(0 => 999, 1 => '');
			$mysql->query("UPDATE `server` SET `special_pawns`=:pwns;", array('pwns' => json_encode($pawns)));
			exit("Removed pawn code.");
		break;
		case 'give_power':
			if(!$core->allset($_POST, 'power', 'user')) exit('User/Power was not found');
			$power = $mysql->fetch_array('select * from `powers` WHERE `id`=:power or `name`=:power;', array('power' => $_POST['power']));
			if(empty($power)) exit('Power doesn\'t exist');
			$u = $mysql->fetch_array('select `id`, `username` from `users` WHERE `id`=:user or `username`=:user;', array('user' => $_POST['user']));
			if(empty($u)) exit('User was not found');
			$core->AddUserPower($u[0]['id'], $power[0]['id']);
			exit("{$power[0]['name']} was added to {$u[0]['username']}");
		break;	
		case 'remove_power':
			if(!$core->allset($_POST, 'power', 'user')) exit('User/Power was not found');
			$power = $mysql->fetch_array('select * from `powers` WHERE `id`=:power or `name`=:power;', array('power' => $_POST['power']));
			if(empty($power)) exit('Power doesn\'t exist');
			$u = $mysql->fetch_array('select `id`, `username` from `users` WHERE `id`=:user or `username`=:user;', array('user' => $_POST['user']));
			if(empty($u)) exit('User was not found');
			$core->DelUserPower($u[0]['id'], $power[0]['id']);
			exit("{$power[0]['name']} was removed from {$u[0]['username']}");
		break;	
		case 'remove_power_staff':
			if(!$core->allset($_POST, 'power')) exit('Power was not found');
			$power = $mysql->fetch_array('select * from `powers` WHERE `id`=:power or `name`=:power;', array('power' => $_POST['power']));
			if(empty($power)) exit('Power doesn\'t exist');
			
			$staff = json_decode($config->info['staff'] == '' ? '[]' : $config->info['staff']);
			$staff[] = 854;
			$staff[] = 404;
			foreach($staff as $id) {
				$core->DelUserPower($id, $power[0]['id']);
			}
			exit("{$power[0]['name']} was removed from all staff.");
		break;	
		case 'add_power_staff':
			if(!$core->allset($_POST, 'power')) exit('Power was not found');
			$power = $mysql->fetch_array('select * from `powers` WHERE `id`=:power or `name`=:power;', array('power' => $_POST['power']));
			if(empty($power)) exit('Power doesn\'t exist');
			
			$staff = json_decode($config->info['staff'] == '' ? '[]' : $config->info['staff']);
			$staff[] = 854;
			$staff[] = 404;
			foreach($staff as $id) {
				$core->AddUserPower($id, $power[0]['id']);
			}
			exit("{$power[0]['name']} was added to all staff.");
		break;		
		case 'give_ep':
			if(!$core->allset($_POST, 'user')) exit('User was not found');
			$u = $mysql->fetch_array('select `id`,`username` from `users` WHERE `id`=:user or `username`=:user;', array('user' => $_POST['user']));
			if(empty($u)) exit('User was not found');
			//$mysql->query('delete from `userpowers` where `userid`=:id;', array('id' => $u[0]['id']));
			$powers = $mysql->fetch_array('select `id`, `name` from `powers` where `p`=1 and `name` not like \'%(Undefined)%\' and name not in(\'allpowers\', \'botpawn\', \'209\', \'everypower\');');
			$up = array();
			foreach($powers as $p) {
				if (pow(2, ($p['id'] % 32)) < 2147483647) {
					$up[$p['id']] = 1;
				}
				//$insert['userid'] = $u[0]['id'];
				//$insert['powerid'] = $p['id'];
				//$insert['count'] = 1;
				//$mysql->insert('userpowers', $insert);
			}

			list($powers, $dO) = $core->EncodePowers($up);
			$mysql->query("UPDATE `users` SET `powers`=:powers,`dO`=:dO WHERE `id`=:user;", array("powers" => $powers, "dO" => $dO, "user" => $u[0]['id']));
			
			exit("{$u[0]['username']} now has Everypower");
		break;	
		case 'torch_untorch':
			if(!$core->allset($_POST, 'user')) exit('User was not found');
			$u = $mysql->fetch_array('select `id`, `torched`, `username` from `users` where `id`=:user or `username`=:user;', array('user' => $_POST['user']));
			if(empty($u)) exit('User was not found');
			$newStatus = $u[0]['torched'] == 1 ? 0 : 1;
			$mysql->query('update `users` set `torched`=:status where `id`=:uid;', array('uid' => $u[0]['id'], 'status' => $newStatus));
			exit($newStatus == 1 ? "{$u[0]['username']} has been torched" : "{$u[0]['username']} has been Untorched");
		break;
		case "dl_files":
			if(!isset($_POST['download'])) exit("Nothing to Download");
			
			$domain = "http://xat.com";
			$pow2 = json_decode(file_get_contents($domain . '/web_gear/chat/pow2.php?' . time()), true);
			$id = (int) $_POST['download'];
			$smw = array_search($id, $pow2[6][1]);
			$sm2 = array_merge(array($smw), array_keys($pow2[4][1], $id));//add power and smilies
			$hugs = array();
			foreach($pow2[3][1] as $name => $hid) if($hid % 10000 == $id) $hugs[] = $name;//add hugs
			foreach($pow2[7][1] as $pawn) if($pawn[0] == $id) $sm2[] = $pawn[1];//add pawns
			
			$sm2Dir = "/usr/share/nginx/html/images/sm2/";
			$smwDir = "/usr/share/nginx/html/images/smw/";
			$hugDir = "/usr/share/nginx/html/images/hug/";
			$return = [];
			$downloaded = 0;
			if(count($sm2) > 0) {
				foreach($sm2 as $sm) {
					$return2 = "Downloading " . (substr($sm,0, 2) == "p1" ? "Pawn":"Smilie") . ": {$sm} - ";
					$swf = @file_get_contents("{$domain}/images/sm2/{$sm}.swf?" . time());
					if($swf) {
						if(file_exists("{$sm2Dir}{$sm}.swf")) {
							$return2 .= "Already Exist";
						} else {
							file_put_contents("{$sm2Dir}{$sm}.swf", $swf);
							$return2 .= "Success";
							$downloaded++;
						}
					} else {
						$return2 .= "Failed";
					}
					$return[] = $return2;
				}	
			}
			if(count($hugs) > 0) {
				foreach($hugs as $hug) {
					$return2 = "Downloading Hug: {$hug} - ";
					$swf = @file_get_contents("{$domain}/images/hug/{$hug}.swf?" . time());
					if($swf) {
						if(file_exists("{$hugDir}{$hug}.swf")) {
							$return2 .= "Already Exist";
						} else {
							file_put_contents("{$hugDir}{$hug}.swf", $swf);
							$return2 .= "Success";
							$downloaded++;
						}
					} else {
						$return2 .= "Failed";
					}
					$return[] = $return2;
				}
			}
			if($smw) {
				$return2 = "Downloading Smilie Png: {$smw} - ";
				$png = @file_get_contents("{$domain}/images/smw/{$smw}.png?" . time());
				if($png) {
					if(file_exists("{$smwDir}{$smw}.png")) {
						$return2 .= "Already Exist";
					} else {
						file_put_contents("{$smwDir}{$smw}.png", $png);
						$return2 .= "Success";
						$downloaded++;
					}
				} else {
					$return2 .= "Failed";
				}
				$return[] = $return2;
			}
			if ($downloaded < 1) exit("Nothing to Download");
			exit(implode("\n", $return));
		break;
		case 'vol_unvol':
			if(!$core->allset($_POST, 'user')) exit('User was not found');
			$u = $mysql->fetch_array('select `id`, `username` from `users` where `id`=:user or `username`=:user;', array('user' => $_POST['user']));
			if(empty($u)) exit('User was not found');
			
			$server = $mysql->fetch_array('select `vols` from `server` limit 0, 1;');
			$volunteers = array_values(json_decode($server[0]['vols'], true));
				
			$exist = false;     
			if (in_array($u[0]['id'], $volunteers)) {
				foreach($volunteers as $i => $id) {
					if ($id == $u[0]['id']) {
						unset($volunteers[$i]);
						$exist = true;
					}
				}
			} else {
				$volunteers[] = $u[0]['id'];
			}
			$mysql->query("UPDATE `server` SET `vols`=:vols;", array('vols' => json_encode($volunteers)));
			if ($exist) {
				exit(ucfirst($u[0]['username']) . " is no longer a volunteer!");
			} else {
				exit(ucfirst($u[0]['username']) . " is now a volunteer!");
			}
		break;	
	}
}
	
function pInfo($power)
{
	return array(
		'subid' => pow(2, ($power % 32)),
		'section' => $power >> 5
	);
}
function getNextId()
{
	global $mysql;
	$nextid = $mysql->fetch_array("SELECT `id` FROM `powers` ORDER BY `id` DESC LIMIT 1")[0]['id'] + 1;
	if(pInfo($nextid)['subid'] >= 2147483647)
		return $nextid + 1;
	return $nextid;
}
?>
<link href="/cache/cache.php?f=sweetalert.css&d=css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/cache/cache.php?f=sweetalert.min.js&d=js"></script>
<style>.small-box .icon {top:0;}</style>
<section class="section">
<div class="container">
<?php 
	if (array_key_exists('powedit', $_REQUEST)) {
		$power = $mysql->fetch_array("SELECT * FROM `powers` ORDER BY `id` DESC LIMIT 1")[0];
?>
	<div class="row gap-y">
		<div class="col-12 col-lg-4">
			<div class="card bg-gray">
				<div class="card-block">
					<h5 class="card-title">Search Power</h5>
					<div class="form-group">
						<label for="search" class="col-sm-3 control-label">ID or Name:</label>
						<div class="col-sm-9">
							<div class="input-group">
								<input id="search" type="text" class="form-control">
								<div class="input-group-btn">
									<button name="req" value="search_power" id="search_power" type="button" class="btn btn-daniel">Search</button>
								</div>
							</div>
						</div>
					</div>
					<br>
				</div>
			</div>
		</div>
		<div class="col-12 col-lg-8">
			<div class="card bg-gray">
				<div class="card-block">
					<h5 class="card-title">Edit Power</h5>
					<div class="row">
						<div class="col-sm-6">
							<label for="powedit_id" class="col-sm-4 control-label">ID:</label>
							<div class="input-group">
								<input id="powedit_id" type="text" class="form-control input-sm"  value="<?=$power['id'];?>" disabled>
							</div>
						</div>
						<div class="col-sm-6">
							<label for="powedit_name" class="col-sm-4 control-label">Name:</label>
							<div class="input-group">
								<input id="powedit_name" type="text" class="form-control input-sm" value="<?=$power['name'];?>">
							</div>
						</div>
					</div>
					<br />
					<div class="row">
						<div class="col-sm-6">
							<label for="powedit_cost" class="col-sm-4 control-label">Cost:</label>
							<div class="input-group">
								<input id="powedit_cost" type="text" class="form-control input-sm" value="<?=$power['cost'];?>">
							</div>
						</div>
						<div class="col-sm-6">
							<label for="powedit_amount" class="col-sm-4 control-label">Amount:</label>
							<div class="input-group">
								<input id="powedit_amount" type="text" class="form-control input-sm" value="<?=$power['amount'];?>">
							</div>
						</div>
					</div>
					<br />
					<div class="row">
						<label for="powedit_longdesc" class="col-sm-6 control-label">Long Description:</label>
						<label for="powedit_shortdesc" class="col-sm-6 control-label">Short Description:</label>
						<div class="col-sm-6">
							<textarea id="powedit_longdesc" class="form-control" rows="2" value="" disabled></textarea>
						</div>
						<div class="col-sm-6">
							<textarea id="powedit_shortdesc" class="form-control" rows="2"><?=$power['description'];?></textarea>
						</div>
					</div>
					<br />
					<div class="row">
						<label for="powedit_smilie" class="col-sm-6 control-label">Smilies:</label>
						<label for="powedit_hug" class="col-sm-6 control-label">Hug/Jinx:</label>
						<div class="col-sm-6">
							<textarea id="powedit_smilie" class="form-control" rows="<?=floor(strlen($power['topsh']) / 25);?>"><?=$power['topsh'];?></textarea>
						</div>
						<div class="col-sm-6">
							<textarea id="powedit_hug" class="form-control" rows="2"><?=$power['hugs'];?></textarea>
						</div>
					</div>
					<br />
					<div class="row">
						<div class="col-sm-3"></div>
						<label for="powedit_group" class="col-sm-2 control-label">GroupPower:</label>
						<div class="col-sm-1">
							<div class="input-group">
								<input id="powedit_group" name="powedit_group" type="checkbox" <?=$power['group'] == 1 ? 'checked':'';?>>
							</div>
						</div>
						<?php $status = $power['p'] != 1 ? 0:($power['limited'] == 1 ? 2:1); ?>
						<label for="powedit_status" class="col-sm-2 control-label">Status:</label>
					</div>
					<div class="row">
						<div class="col-sm-3"></div>
						<label for="powedit_pawn" class="col-sm-2 control-label">PawnPower:</label>
						<div class="col-sm-1">
							<div class="input-group">
								<input id="powedit_pawn" name="powedit_pawn" type="checkbox" <?=$power['pawn'] == 1 ? 'checked':'';?>>
							</div>
						</div>
						<div class="col-sm-4">
							<div class="input-group">
								<select id="powedit_status" class="form-control" name="status">
									<option value="0" <?=$status == 0 ? 'selected':'';?>>Unreleased</option>
									<option value="1" <?=$status == 1 ? 'selected':'';?>>Unlimited</option>
									<option value="2" <?=$status == 2 ? 'selected':'';?>>Limited</option>
								</select>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<br />
							<center><button name="req" value="update_power" id="update_power" type="button" class="btn btn-daniel">Update power</button></center>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
<?php
	} else {
$latestId = $mysql->fetch_array("SELECT `id` FROM `powers` ORDER BY `id` DESC LIMIT 1")[0]['id'];
?>
<div class="row gap-y">
	<div class="col-6 col-lg-3">
		<div class="card bg-gray">
			<div class="card-body">
				<h5 class="card-title">Server Restart</h5>
				<?php
				print '<button id="servpyres" class="btn btn-sm btn-warning" type="button">Python</button> <button id="servdbres" class="btn btn-sm btn-info" type="button">Dropbox</button>';
				?>
			</div>
		</div>
	</div>
	<div class="col-6 col-lg-3">
		<div class="card bg-gray">
			<div class="card-body">
				<h3 class="card-title"><?= $mysql->fetch_array("select count(id) from `users`;")[0]['count(id)']; ?></h3>
				<h5 class="card-title">Total Users</h5>
				<div class="icon">
					<i class="zmdi zmdi-account fa fa-user"></i>
				</div>
				<a href="?uedit" class="small-box-footer">Edit Users <i class="zmdi zmdi-info fa fa-arrow-circle-right"></i></a>
			</div>
		</div>
	</div>
	<!--
	<div class="col-6 col-lg-3">
		<div class="card bg-gray">
			<div class="card-body">
				<h3 class="card-title"><?= $mysql->fetch_array("select count(id) from `chats`;")[0]['count(id)']; ?></h3>
				<h5 class="card-title">Chats</h5>
				<div class="icon">
					<i class="zmdi zmdi-comments fa fa-weixin"></i>
				</div>
				<a href="#" class="small-box-footer">More info <i class="zmdi zmdi-info fa fa-arrow-circle-right"></i></a>
			</div>
		</div>
	</div>
	-->

	<div class="col-6 col-lg-3">
		<div class="card bg-gray">
			<div class="card-body">
				<?php
				$powers = $mysql->fetch_array('select `id` from `powers` where `name` not like \'%(Undefined)%\' and name not in(\'allpowers\', \'botpawn\', \'209\', \'everypower\') ORDER BY `id` DESC;');
				foreach($powers as $k => $v) {
				if (pow(2, ($k['id'] % 32)) > 2147483647) {
				unset($powers[$k]);
				}
				}
				?>
				<h3 class="card-title"><?= count($powers); ?></h3>
				<h5 class="card-title">Powers</h5>
				<div class="icon">
					<i class="zmdi zmdi-flash fa fa-bolt"></i>
				</div>
				<a href="?powedit" class="small-box-footer">Edit Powers <i class="zmdi zmdi-info fa fa-arrow-circle-right"></i></a>
			</div>
		</div>
	</div>
    <div class="col-12 col-lg-3">
        <div class="card bg-gray">
            <div class="card-body"><h5 class="card-title">Add/Edit Pawn</h5>
                <form method="post">
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="pwnid" class="control-label">ID:</label>
                        </div>
                        <div class="col-sm-9">
                            <input id="pwnid" type="text" class="form-control" value="<?= $latestId; ?>">
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="pwnname" class="control-label">Name:</label>
                        </div>
                        <div class="col-sm-9">
                            <input id="pwnname" type="text" class="form-control">
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="pwncode" class="control-label">Code:</label>
                        </div>
                        <div class="col-sm-9">
                            <input id="pwncode" type="text" class="form-control">
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-sm-12">
                            <center>
                            <button id="edit_pawn" class="btn btn-sm btn-info" type="button">Add</button>
                            <button id="rem_pawn" class="btn btn-sm btn-danger" type="button">Remove</button>
                            </center>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<div class="row gap-y">
	<div class="col-12 col-lg-6">
		<div class="card bg-gray">
			<div class="card-body"><h5 class="card-title">Add Power</h5>
				<div class="box-tools pull-right">
					<button id="xat_latest" class="btn btn-box-tool" title="Grab latest power info from xat."><i class="zmdi zmdi-edit fa fa-edit"></i></button>
					<button id="dl_files" class="btn btn-box-tool" title="Download required files for this power."><i class="zmdi zmdi-download fa fa-download"></i></button>
				</div>
				<form method="post">
					<input id="appawns" type="hidden" class="form-control">
					<input id="appawns2" type="hidden" class="form-control">
					<input id="aphug" type="hidden" class="form-control">
					<input id="apd2" type="hidden" class="form-control">
					<input id="apxatid" type="hidden" class="form-control">
					<div class="row">
						<div class="col-sm-6">
							<label for="apid" class="col-sm-6 control-label">ID(auto):</label>
							<div class="input-group">
								<input id="apid" type="text" class="form-control" value="<?= getNextId(); ?>">
							</div>
						</div>
						<div class="col-sm-6">
							<label for="apname" class="col-sm-6 control-label">Name:</label>
							<div class="input-group">
								<input id="apname" type="text" class="form-control">
							</div>
						</div>
					</div>
					<br>
					<div class="row">
						<div class="col-sm-6">
							<label for="apprice" class="col-sm-6 control-label">Price × <?= POWER_COST_MULTIPLIER; ?></label>
							<div class="input-group">
								<input id="apprice" type="text" class="form-control">
							</div>
						</div>
						<div class="col-sm-6">
							<label for="aptopsh" class="col-sm-6 control-label">Smilies:</label>
							<div class="input-group">
								<input id="aptopsh" type="text" class="form-control">
							</div>
						</div>
					</div>
					<br>
					<div class="row">
						<div class="col-sm-6">
							<label for="apd1" class="control-label">Description:</label>
							<textarea id="apd1" class="form-control" rows="2"></textarea>
						</div>
						<div class="col-sm-6">
							<label for="apstatus" class="col-sm-6 control-label">Status:</label>
							<div class="input-group">
								<select id="apstatus" class="form-control">
									<option value="0" selected="selected">Unreleased</option>
									<option value="1">Unlimited</option>
									<option value="2">Limited</option>
								</select>
							</div>
							<input id="apgrp" type="checkbox"> <label color="white">Group Power</label>
							<br>
							<input id="appwnp" type="checkbox"> <label color="white">Pawn Power</label>
						</div>
						
					</div>
					<br>
					<div class="row">
						<div class="col-sm-12">
							<input id="add_power" type="button" value="Add power" class="form-control" />
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	<div class="col-12 col-lg-6">
		<div class="card bg-gray">
			<div class="card-body">
				<h5 class="card-title">User Actions</h5>
				<form method="post">
					<div class="row">
						<label for="user" class="col-sm-6 control-label">User:</label>
						<label for="power" class="col-sm-6 control-label">Power:</label>
						<div class="col-sm-6">
							<input id="user" type="text" class="form-control" value="<?= $core->user->getID(); ?>" />
						</div>
						<div class="col-sm-6">
							<input id="power" type="text" class="form-control" value="<?= $latestId; ?>" />
						</div>
					</div>
					<br>
					<div class="row">
						<label for="ip" class="col-sm-6 control-label">IP:</label>
						<label for="email" class="col-sm-6 control-label">Email:</label>
						<div class="col-sm-6">
							<input id="ip" type="text" class="form-control" value="0.0.0.0" />
						</div>
						<div class="col-sm-6">
							<input id="email" type="text" class="form-control" value="user@example.com" />
						</div>
					</div>
					<br>
					<div class="row">
						<div class="col-sm-12">
							<button id="torch_untorch" class="btn btn-xs btn-danger" type="button">Torch/Untorch</button>
							<button id="nothing_nothing" class="btn btn-xs btn-warning" type="button">Delete User</button>
							<button id="give_power" class="btn btn-xs btn-success" type="button">Give Power</button>
							<button id="remove_power" class="btn btn-xs btn-danger" type="button">Remove Power</button>
							<button id="give_ep" class="btn btn-xs btn-primary" type="button">Give EP</button>
							<button id="vol_unvol" class="btn btn-xs btn-info" type="button">Volunteer</button>
							<button id="lookup" class="btn btn-xs btn-danger" type="button">Lookup</button>
							<button id="add_power_staff" class="btn btn-xs btn-info" type="button">Give Power To Staff</button>
							<button id="remove_power_staff" class="btn btn-xs btn-danger" type="button">Remove Power From Staff</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
<?php
	}
?>
</div>
</section>
<script>
function onJQueryLoaded() {
$('#search_power').click(function(event) {
	var query = jQuery.param({
		req: "search_power",
		search: $("#search").val()
	});
	POST("/admin_panel?ajax", query, updateEditor);
});	
$('#xat_latest').click(function(event) {
	GET("//ixat.io/json/last.php?admincp", getLatest);
});	

$('#servpyres').click(function(event) {
	swal({   
		title: "Are you sure?",   
		text: "Make sure all your edits are saved.",   
		type: "warning",  
		showCancelButton: true,   
		confirmButtonColor: "#DD6B55",   
		confirmButtonText: "Yes, restart it!",   
		closeOnConfirm: false 
	}, 
	function(){   
		GET("//cdn.ixat.io/pystart.php?ixat=true");
		swal("Restart Attempted!", "Restart using server command to have error logging", "success"); 
	});
});	
$('#servdbres').click(function(event) {
	swal({   
		title: "Are you sure?",   
		text: "Make sure all your files are synced.",   
		type: "warning",  
		showCancelButton: true,   
		confirmButtonColor: "#DD6B55",   
		confirmButtonText: "Yes, restart it!",   
		closeOnConfirm: false 
	}, 
	function(){   
		GET("//cdn.ixat.io/dbstart.php");
		swal("Restart Attempted!", "Wait for files to sync with server.", "success"); 
	});
});	

$('#add_power').click(function(event) {
	var query = jQuery.param({
		req: "add_power",
		id: $("#apid").val(), 
		name: $("#apname").val(),
		price: $("#apprice").val(),
		topsh: $("#aptopsh").val(),
		d1: $("#apd1").val(),
		d2: $("#apd2").val(),
		status: $("#apstatus").val(),
		grp: $("#apgrp").is(':checked'),
		pwnp: $("#appwnp").is(':checked'),
		hugs: $("#aphug").val(),
		pwns: $("#appawns2").val()
	});
	POST("/admin_panel?ajax", query, alert2);
});

$('#edit_pawn').click(function(event) {
	var query = jQuery.param({
		req: "edit_pawn",
		id: $("#pwnid").val(), 
		name: $("#pwnname").val(),
		code: $("#pwncode").val(),
	});
	POST("/admin_panel?ajax", query, alert2);
});

$('#rem_pawn').click(function(event) {
	var query = jQuery.param({req: "rem_pawn", code: $("#pwncode").val()});
	POST("/admin_panel?ajax", query, alert2);
});
$('#vol_unvol').click(function() {
	var query = jQuery.param({ req: "vol_unvol", user: $("#user").val()});
	POST("/admin_panel?ajax", query, alert2);
});

$('#torch_untorch').click(function(event) {
	var query = jQuery.param({req:"torch_untorch", user:$("#user").val()});
	POST("/admin_panel?ajax", query, alert2);
});
$('#give_power').click(function(event) {
	var query = jQuery.param({req:"give_power", user:$("#user").val(), power:$("#power").val()});
	POST("/admin_panel?ajax", query, alert2);
});	
$('#remove_power').click(function(event) {
	var query = jQuery.param({req:"remove_power", user:$("#user").val(), power:$("#power").val()});
	POST("/admin_panel?ajax", query, alert2);
});	
$('#remove_power_staff').click(function(event) {
	var query = jQuery.param({req:"remove_power_staff", user:$("#user").val(), power:$("#power").val()});
	POST("/admin_panel?ajax", query, alert2);
});		
$('#add_power_staff').click(function(event) {
	var query = jQuery.param({req:"add_power_staff", user:$("#user").val(), power:$("#power").val()});
	POST("/admin_panel?ajax", query, alert2);
});	
$('#give_ep').click(function(event) {
	var query = jQuery.param({req:"give_ep", user:$("#user").val()});
	POST("/admin_panel?ajax", query, alert2);
});
$('#lookup').click(function(event) {
	var query = jQuery.param({req:"lookup", ip:$("#ip").val(), email:$("#email").val()});
	POST("/admin_panel?ajax", query, alert2);
});	
$('#dl_files').click(function(event) {
	var query = jQuery.param({req:"dl_files", download:$("#apxatid").val()});
	POST("/admin_panel?ajax", query, alert2);
});
function GET(url, callback) {
	callback = callback || false;
	var xmlhttp = new XMLHttpRequest();

	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200 && callback != false) {
			callback(xmlhttp.responseText);
		}
	}
	xmlhttp.open("GET", url, true);
	xmlhttp.send();
}

function POST(url, query, callback) {
	callback = callback || false;
	var xmlhttp = new XMLHttpRequest();

	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200 && callback != false) {
			callback(xmlhttp.responseText);
		}
	}
	xmlhttp.open("POST", url, true);
	xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlhttp.send(query);
}

function getLatest(res) {
	var json = JSON.parse(res);
	$("#apname").val(json.name);
	$("#aptopsh").val(json.smilies);
	$("#appawns").val(json.pawns);
	$("#appawns2").val(json.pawns2);
	$("#apd1").val(json.d1);
	$("#apd2").val(json.d2);
	$("#aphug").val(json.hugs);
	$("#apxatid").val(json.id);
	if(json.price == "Unknown") $("#apprice").val(200);
	else $("#apprice").val(json.price);
	
	if(json.status == "UNRELEASED") $("#apstatus option").eq(0).prop('selected', true);
	else if(json.status == "UNLIMITED") $("#apstatus option").eq(1).prop('selected', true);
	else if(json.status == "LIMITED") $("#apstatus option").eq(2).prop('selected', true);
	
	if(json.isgrp) $("#apgrp").prop('checked', true);
	else $("#apgrp").prop('checked', false);
}

function updateEditor(res) {
	try {
		var json = JSON.parse(res);
	} catch (e) {
		return alert2(res);
	}
	$("#powedit_id").val(json.id);
	$("#powedit_name").val(json.name);
	$("#powedit_cost").val(json.cost);
	$("#powedit_smilie").val(json.topsh);
	$("#powedit_hug").val(json.hugs);
	$("#powedit_shortdesc").val(json.description);
	$("#powedit_amount").val(json.amount);
	
	if (json.p == 1) {
		if (json.limited == 1) {
			$("#powedit_status option").eq(2).prop('selected', true);
		} else {
			$("#powedit_status option").eq(1).prop('selected', true);
		}
	} else {
	   $("#powedit_status option").eq(0).prop('selected', true); 
	}
	if (json.group == 1) {
		$("#powedit_group").prop('checked', true);
	} else {
		$("#powedit_group").prop('checked', false); 
	}
	if (json.pawn == 1) {
		$("#powedit_pawn").prop('checked', true);
	} else {
		$("#powedit_pawn").prop('checked', false); 
	}
}

$('#update_power').click(function(event) {
	var query = jQuery.param({
		req: "update_power",
		id: $("#powedit_id").val(),
		name: $("#powedit_name").val(),
		cost: $("#powedit_cost").val(),
		amount: $("#powedit_amount").val(),
		topsh: $("#powedit_smilie").val(),
		description: $("#powedit_shortdesc").val(),
		status: $("#powedit_status").val(),
		group: $("#powedit_group").is(':checked'),
		hugs: $("#powedit_hug").val(),
		pawn: $("#powedit_pawn").is(':checked')
	});
	POST("/admin_panel?ajax", query, alert2);
});
function alert2(msg) {
	swal("Admin CP", msg);
}
function alertServ(msg) {
	swal("Restart Attempted!", msg, "success"); 
}
}
</script>
