<?php

header("Content-Type: text/json");


$seconds_to_cache = 3600;
$ts = gmdate("D, d M Y H:i:s", time() + $seconds_to_cache) . " GMT";
 /*
 * Creator - Austin
 * Made for ixat.io source
 * Gifts or 20044
 */
if(isset($_GET['id'])) {
	require str_replace('\\', '\\\\', "../../_class/") . 'pdo.php';

	$pdo = new Database();
	if(!$pdo->conn) die("Nope!");
	
	$array = explode(",", $_GET['id']);
	$count = count($array);
	if($count < 1) die("No gifts.");
	$id = $count >= 1 ? intval($array[0]):null;
	$k = $count >= 3 ? intval($array[2]):null;
	$time = time();
	$isuser = false;
	if($k != null) {
		$user = $pdo->fetch_array("select `k`,`d0` from `users` where `id`=:uid;", array("uid" => $id));
		if($user[0]['k'] == $k)
			$isuser = true;
	}
	$update = ($isuser && isset($_REQUEST['old']) && isset($_REQUEST['k'])) ? true:false;
	$fqqq = array('reg'=>$id);
	if($update)
		$fqqq['time'] = intval($_REQUEST['k']);
	$gifts = $pdo->fetch_array("select * from `gifts` where ".($update ? "`time`=:time and ":"")."`b`=:reg order by `time` desc".($update? " limit 0,1;":";"), $fqqq);
	
	$del = intval($_REQUEST['del'] ?? 0);
	$flags = $_REQUEST['flags'] ?? false;
	$old = $_REQUEST['old'] ?? false;
	$k = intval($_REQUEST['k'] ?? 0);
	if($isuser) {
		if($del) { // delete mode
			$read = $pdo->query('delete from `gifts` where `time`=:time and `b`=:uid;', array('time' => $del, 'uid' => $id));
			if(count($gifts) <= 1) 
			{
				$d0 = $user[0]['d0'];
				$d0 &= ~1 << 24;
				if($user[0]['d0'] & 1 << 21)
					$d0 |= 1 << 21;
				$pdo->query('update `users` set `d0`=:d0 where `id`=:uid;', array('d0' => $d0, 'uid' => $id));
			}
			exit("deleted");	
		}

		if($flags) { // set flags mode
			$read = $pdo->query('update `gifts` set `f`=:new where `time`=:time and `b`=:uid;', array('new' => intval($flags), 'time' => $k, 'uid' => $id)); //update flag to read
			exit("updated");	
		}

		if($old) { // set old
			$read = $pdo->query('update `gifts` set `f`=:new where `time`=:time and `b`=:uid;', array('new' => $gifts[0]['f'] &= ~2, 'time' => $k, 'uid' => $id)); //update flag to read
			exit("updated");	
		}
	}
	
	if(empty($gifts)) exit("No gifts.");
	$json = array('timestamp' => intval(end($gifts)['time']));
	foreach($gifts as $gift) {
		$time = $gift['time'];
		$gift['f'] = intval($gift['f']);
		if(($gift['f'] & 1) == 0 && !$isuser && !isset($_GET['potato']))
			unset($gift['m']);
		$gift['id'] = intval($gift['id']);
		unset($gift['time'], $gift['b'], $gift['gid']);
		$json[$time] = $gift;
	}
	exit(json_encode($json));
}
exit("No gifts.");
?>
