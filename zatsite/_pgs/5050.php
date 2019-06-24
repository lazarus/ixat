<?php
if (!isset($config->complete)) {
	return require $pages['home'];

}
/* STRUCTURE
id = betid
betby = id of user to made the bet
amount = bet amount
status = status of the bet (0 = removed, 1 = enabled, 2 = taken)
time = timestamp when bet was made
takenby = person who accepted the bet
winner = person who won the bet
*/
if (!isset($core->user)) {
	return require $pages['profile'];

}

if (isset($_GET['ajax'])) {
	switch ($_GET['ajax']) {
		case 'recentBets':
			$json = new stdClass();
			$json->xats = $core->user->getXats();
			$json->id = $core->user->getID();
			$json->bets = [];
			$json->bets = $mysql->fetch_array('select `amount`, `time`, `status`, `winner`, `betby`, `takenby` from `5050` where `status`!=1 and `betby`=' . $core->user->getID() . ' or `takenby`=' . $core->user->getID() . ' order by `id` desc LIMIT 15;');
			foreach($json->bets as $i => $u) {
				$json->bets[$i]['user'] = @$mysql->fetch_array('SELECT `username` FROM `users` WHERE id=:id', [
					'id' => $core->user->getID() == $json->bets[$i]['betby'] ? $json->bets[$i]['takenby'] : $json->bets[$i]['betby']
				])[0]['username'];
				
				unset($json->bets[$i]['takenby'], $json->bets[$i]['betby']);
			}
			
			exit(json_encode($json));
			
		case 'currentBets':
			$json = new stdClass();
			$json->xats = $core->user->getXats();
			$json->id = $core->user->getID();
			$json->bets = [];
			$json->bets = $mysql->fetch_array('select `id`, `status`, `amount`, `betby` from `5050` where status=1 order by `id` desc LIMIT 15;');
			foreach($json->bets as $i => $u) {
				$json->bets[$i]['user'] = $mysql->fetch_array('SELECT `username` FROM `users` WHERE id=:id', ['id'=> $json->bets[$i]['betby']])[0]['username'];
				$json->bets[$i]['self'] = $json->bets[$i]['betby'] == $core->user->getID();
			}

			exit(json_encode($json));
		
		case 'makeBet':
			$result = new stdClass();
			$result->success = true;
			if (isset($_POST['amount'])) {
				$amount = str_replace(',', '', $_POST['amount']);
				if (is_numeric($amount)) {
					$amount = (int) $amount;
					if ($amount >= 1000) {
						if ($core->user->getXats() >= $amount) {
							$lastbet = $mysql->fetch_array('select `time` from `5050` where `status`!=0 and `betby`=' . $core->user->getID() . ' and `time`>' . (time() - 60) .' order by `id` desc LIMIT 1;');
							if (count($lastbet) > 0) {
								$result->success = false;
								$result->reason = 'You need to wait ' . (60 - (time() - $lastbet[0]['time'])) . ' seconds before you bet again.';
							} else {
								$mysql->insert('5050', ['time'=>time(), 'betby' => $core->user->getID(), 'amount' => $amount, 'status' => 1]);
								if (!$mysql->insert_id()) {
									$result->success = false;
									$result->reason = 'Database Error';
								} else {//success
									if ($amount > 99999) {
										$core->send2py($core->user->getUsername() . ' made a bet of ' . number_format($amount) . ' xats | Grab it will you can https://ixat.io/5050');
									}
									$core->user->reduceXats($amount);
									$mysql->query('update `users` set `xats`=:xats where `id`=:id;', ['id' => $core->user->getID(), 'xats' => $core->user->getXats()]);
									$result->xats = $core->user->getXats();
								}
							}
						} else {
							$result->success = false;
							$result->reason = 'Not enough xats';	
						}
					} else {
						$result->success = false;
						$result->reason = 'Amount must be 1000 or more.';	
					}
				} else {
					$result->success = false;
					$result->reason = 'Amount is invalid';
				}
			} else {
				$result->success = false;
				$result->reason = 'Amount not set';
			}
			
			exit(json_encode($result));
		
		case 'takeBet':
			$result = new stdClass();
			$result->success = true;
			$result->outcome = null;
			if (isset($_POST['id']) && is_numeric($_POST['id'])) {
				$test = $mysql->fetch_array('select * from `5050` where `id`=:id;', ['id' => $_POST['id']]);

				if (count($test) > 0 && $test[0]['status'] == 1) {
					if ($core->user->getID() == $test[0]['betby']) {
						$result->success = false;
						$result->reason = 'Cant take your own bet sorry.';
					} else {
						$amount = (int) $test[0]['amount'];
						if ($core->user->getXats() > $amount) {
							
							$core->user->reduceXats($amount);
							$mysql->query('update `users` set `xats`=:xats where `id`=:id;', ['id' => $core->user->getID(), 'xats' => $core->user->getXats()]);// first remove bet money
							
							$arr = [];
							for($i=0; $i < 50; $i++) {
								$arr[] = $test[0]['betby'];	
								$arr[] = $core->user->getID();	
							}
							shuffle($arr);
							$winner = $arr[mt_rand(0, 99)];
							
							$mysql->query('update `5050` set `status`=2, `takenby`=:takenby, `winner`=:winner where `id`=:id', ['id' => $_POST['id'], 'takenby' => $core->user->getID(), 'winner' => $winner]);
							$betby = $mysql->fetch_array('SELECT `username` FROM `users` WHERE id=:id', ['id'=> $test[0]['betby']])[0]['username'];
							if ($winner == $test[0]['betby']) {//you lost
								$xats = $mysql->fetch_array('SELECT `xats` FROM `users` WHERE id=:id', ['id'=> $test[0]['betby']])[0]['xats'] + ($amount * 2);
								$mysql->query('update `users` set `xats`=:xats where `id`=:id;', ['id' => $test[0]['betby'], 'xats' => $xats]);
								$result->outcome = 'Sorry you lost.';
								if ($amount > 99999) {
									$core->send2py("{$core->user->getUsername()} took {$betby}'s bet of {$amount} xats and lost");
								}
							} else { // you won
								$core->user->increaseXats($amount * 2);
								$mysql->query('update `users` set `xats`=:xats where `id`=:id;', ['id' => $core->user->getID(), 'xats' => $core->user->getXats()]);
								$result->outcome = 'You won!';
								if ($amount > 99999) {
									$core->send2py("{$core->user->getUsername()} took {$betby}'s bet of {$amount} xats and won");
								}
							}
							$result->xats = $core->user->getXats();
						} else {
							$result->success = false;
							$result->reason = 'Not enough xats.';
						}
					}
				} else {
					$result->success = false;
					$result->reason = 'That bet doesnt exist or is already taken';
				}
			} else {
				$result->success = false;
				$result->reason = 'Something went wrong';
			}
			
			exit(json_encode($result));
			
		case 'removeBet':
			$result = new stdClass();
			$result->success = true;
			$result->outcome = null;
			if (isset($_POST['id']) && is_numeric($_POST['id'])) {
				$test = $mysql->fetch_array('select * from `5050` where `id`=:id;', ['id' => $_POST['id']]);

				if (count($test) > 0 && $test[0]['status'] == 1) {
					if ($core->user->getID() == $test[0]['betby']) {
						$result->outcome = 'Bet removed successfully';
						$mysql->query('update `5050` set `status`=0 where `id`=:id', ['id' => $_POST['id']]);
						$core->user->increaseXats((int) $test[0]['amount']);
						$mysql->query('update `users` set `xats`=:xats where `id`=:id;', ['id' => $core->user->getID(), 'xats' => $core->user->getXats()]);
						
						$result->xats = $core->user->getXats();
					} else {
						$result->success = false;
						$result->reason = 'Cant remove a bet that isnt yours.';
					}
				} else {
					$result->success = false;
					$result->reason = 'That bet doesnt exist or is already taken';
				}
			} else {
				$result->success = false;
				$result->reason = 'Something went wrong';
			}
			
			exit(json_encode($result));
			
		default:
			$json = [];
			exit(json_encode($json));
	}
}
?>
<style>.small-box .icon {top:0;}</style>
<section class="section">
<div class="container">
<div class="row gap-y">
	<div class="col-2"></div>
	<div class="col-6 col-lg-8">
		<div class="card bg-gray">
			<div class="card-block" align="center">
				<small>
				<h4 class="card-title">50/50 Chance Game For Xats</h4>
				This game is simple. 2 Users bet the same amount of xats, then a winner is randomly picked.<br>Account Balance <span class="btsXats"><?=number_format($core->user->getXats()); ?></span> xats<br>
				<br>
				<div class="btsMakeBetInfo"></div>
				<div class="btsMakeBet"></div>
				</small>
				<hr>
				<div class="btsRecentBets"></div>
				<div class="btsCurrentBets"></div>
				<div class="btsCover"></div>
			</div>
		</div>
	</div>
</div>
</div>
</section>
<style>
.btsCover {
    width: 100%;
    height: 100%;
    position: absolute;
    top: 0px;
    left: 0px;
    background-color: rgba(255, 255, 255, 0.25);
    background-image: url('/cache/cache.php?f=ajax-loader.gif');
    background-position: center center;
    background-repeat: no-repeat;
    transition: opacity 0.25s;
    opacity: 1;
}
</style>
<script data-cfasync="false" type="text/javascript" src="/cache/cache.php?f=5050.js&d=js"></script>