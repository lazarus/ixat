<?php
/*
for($i = 0; $i < 1024; $i++)
{
$mysql->insert('spt_tickets',
array(
'ticketmaster' => 42,
'ticketmaster_un' => 'Sky',
'dept' => 'Normal',
'title' => str_repeat('a', rand(0, 20480)),
'status' => true,
'created' => rand(1, time()),
'last_response_time' => time(),
'last_response_name' => str_repeat('a', rand(5, 32)),
'content' => str_repeat('a ', rand(128, 1024))
)
);
}

*/

if (!isset($config->complete)) {
	return require $pages['home'];

}

if (!isset($core->user)) {
	return require $pages['profile'];

}

if (isset($_GET['ajax'])) {
	switch ($_GET['ajax']) {
	case 'ticket':
		$result = new stdClass();
		$result->status = false;
		if (isset($_GET['id']) && is_numeric($_GET['id'])) {
			$ticket = $mysql->fetch_array('select * from `spt_tickets` where `tid`=:tid;', array(
				'tid' => $_GET['id']
			));
			if (count($ticket) > 0) {
				if ($ticket[0]['ticketmaster'] == $core->user->getID() || $core->user->isAdmin() || $core->user->isVolunteer()) { // Don't remove limit on the SQL query, that tells it to stop searching once it's got all of the results.

					// That is done as MySQL optimisation (rather than searching the entire table)

					$result->status = true;
					$result->ticket = $ticket[0];
					$result->helper = $core->user->isVolunteer();
					$result->admin = $core->user->isAdmin();
					$result->ticket['subject'] = htmlspecialchars($ticket[0]['title']);
					$result->ticket['content'] = nl2br(htmlspecialchars($ticket[0]['content']));
					$result->comments = $mysql->fetch_array('select * from `spt_comments` where `tid`=' . $result->ticket['tid'] . ' order by `cid` desc limit ' . ($result->ticket['comment_count'] > 15 ? 15 : $result->ticket['comment_count']) . ';');
					foreach($result->comments as $i => $u) { // Sanatize the posts data
						$result->comments[$i]['content'] = nl2br(htmlspecialchars($u['content']));
					}
				}
				else {
					$result->reason = "You don't have permission to view that ticket";
				}
			}
			else {
				$result->reason = "Ticket Not Found";
			}
		}
		else {
			$result->reason = 'Bad Ticket ID';
		}

		exit(json_encode($result));
	case 'tickets.staff':
		$json = new stdClass();
		$json->tickets = array();
		if ($core->user->isAdmin() || $core->user->isVolunteer() && isset($_GET['pn']) && is_numeric($_GET['pn']) && $_GET['pn'] >= 1) {
			$json->ticketCount = $mysql->fetch_array('select count(*) from `spt_tickets` WHERE status>0;') [0]['count(*)'];
			$limit = ($_GET['pn'] - 1 < $json->ticketCount / 15) ? ceil(($_GET['pn'] - 1) * 15) : $json->ticketCount - 15;
			$json->currentPage = ($_GET['pn'] - 1 < $json->ticketCount / 15) ? $_GET['pn'] : ceil($json->ticketCount / 15);
			$json->tickets = $mysql->fetch_array('select `tid`, `last_response_time`, `title`, `dept`, `ticketmaster` from `spt_tickets` where status>0 order by `tid` desc limit ' . $limit . ', 15;');
		}

		foreach($json->tickets as $i => $u) { // Sanatize user generated content
			$json->tickets[$i]['subject'] = htmlspecialchars($u['title']);
		}

		exit(json_encode($json));
	case 'tickets':
		$json = new stdClass();
		$json->tickets = array();
		if (isset($_GET['archived'])) {
			if ($core->user->isAdmin() || $core->user->isVolunteer()) {
				$json->tickets = $mysql->fetch_array('select `tid`, `last_response_time`, `title`, `dept`, `ticketmaster` from `spt_tickets` where status=0 order by `tid` desc limit 15;', array(
					'uid' => $core->user->getID()
				));
			}
			else {
				$json->tickets = $mysql->fetch_array('select `tid`, `last_response_time`, `title`, `dept`, `ticketmaster` from `spt_tickets` where `ticketmaster`=:uid and status=0 order by `tid` desc limit 15;', array(
					'uid' => $core->user->getID()
				));
			}
		}
		else {
			$json->tickets = $mysql->fetch_array('select `tid`, `last_response_time`, `title`, `dept`, `ticketmaster` from `spt_tickets` where `ticketmaster`=:uid and status>0 order by `tid` desc limit 15;', array(
				'uid' => $core->user->getID()
			));
		}

		foreach($json->tickets as $i => $u) { // Sanatize user generated content
			$json->tickets[$i]['subject'] = htmlspecialchars($u['title']);
		}

		exit(json_encode($json));
	case 'archive':
		if (isset($_GET['tid']) && is_numeric($_GET['tid'])) {
			if ($core->user->isAdmin() || $core->user->isVolunteer()) {
				$test = $mysql->fetch_array('select `status` from `spt_tickets` where `tid`=:tid;', array(
					'tid' => $_GET['tid']
				));
			}
			else {
				$test = $mysql->fetch_array('select `status` from `spt_tickets` where `tid`=:tid and `ticketmaster`=:tm;', array(
					'tid' => $_GET['tid'],
					'tm' => $core->user->getID()
				));
			}

			if (count($test) > 0 && $test[0]['status'] > 0) {
				$mysql->query('update `spt_tickets` set `status`=0 where `tid`=:topicId and `status`!=0;', array(
					'topicId' => $_GET['tid']
				));
				exit('1');
			}
		}

		exit('0');
	case 'newticket':
		$result = new stdClass();
		$result->success = true;
		if (isset($_POST['ticketSubject']) && is_string($_POST['ticketSubject']) && strlen($_POST['ticketSubject']) >= 8 && strlen($_POST['ticketSubject']) <= 64) {
			if (isset($_POST['ticketContent']) && is_string($_POST['ticketContent']) && strlen($_POST['ticketContent']) >= 20 && strlen($_POST['ticketContent']) <= 4096) {
				$ticketCount = $mysql->fetch_array('select count(*) from `spt_tickets` where `ticketmaster`=:uid and `status`=1;', array(
					'uid' => $core->user->getID()
				));
				if ($ticketCount[0]['count(*)'] < 15) {
					$mysql->insert('spt_tickets', array(
						'title' => $_POST['ticketSubject'],
						'ticketmaster' => $core->user->getID(),
						'ticketmaster_un' => $core->user->getUsername(),
						'dept' => 'users',
						'created' => time() ,
						'last_response_time' => time() ,
						'last_response_name' => '',
						'content' => $_POST['ticketContent']
					));
					if (!$mysql->insert_id()) {
						$result->success = false;
						$result->reason = 'Database Error';
					}
				}
				else {
					$result->success = false;
					$result->reason = 'You have too many tickets open.';
				}
			}
			else {
				$result->success = false;
				$result->reason = 'Description too large/small';
			}
		}
		else {
			$result->success = false;
			$result->reason = 'Subject too small/large';
		}

		exit(json_encode($result));
	case 'ticketreplysubmit':
		$json = new stdClass();
		$json->success = false;
		if (isset($_POST['tid']) && is_numeric($_POST['tid']) && isset($_POST['post']) && is_string($_POST['post']) && strlen($_POST['post']) > 0 && strlen($_POST['post']) < 4096) {
			$ticket = $mysql->fetch_array('select `ticketmaster` from `spt_tickets` where `tid`=:tid;', array(
				'tid' => $_POST['tid']
			));
			if (count($ticket) > 0 && ($ticket[0]['ticketmaster'] == $core->user->getID() || $core->user->isAdmin() || $core->user->isVolunteer())) {
				$mysql->insert('spt_comments', array(
					'tid' => $_POST['tid'],
					'pid' => $core->user->getID(),
					'pun' => $core->user->getUsername(),
					'timestamp' => time() ,
					'content' => $_POST['post']
				));
				if (!$mysql->insert_id()) {
					$json->reason = 'Database Error';
				}
				else {
					$mysql->query('update `spt_tickets` set `comment_count`=`comment_count`+1 where `tid`=:tid;', array(
						'tid' => $_POST['tid']
					));
					$json->success = true;
				}

				$json->tid = $_POST['tid'];
			}
		}

		exit(json_encode($json));
	case 'buttonaction':
		$json = new stdClass();
		if (isset($_POST['button']) && isset($_POST['uid']) && count(array_filter($_POST,
		function ($x)
		{
			return !is_string($x);
		})) == 0 && is_numeric($_POST['uid']) && ($core->user->isAdmin() || $core->user->isVolunteer())) {
			switch ($_POST['button']) {
			case 'Torch/Untorch':
				$user = $mysql->fetch_array('select `id`, `torched` from `users` where `id`=:uid;', array(
					'uid' => $_POST['uid']
				));
				if (count($user) == 0) {
					$json->showMessage = 'User with the ID ' . htmlspecialchars($_POST['uid']) . ' was not found.';
				}
				else { // 1: on; 0: off
					$newStatus = $user[0]['torched'] == 1 ? 0 : 1;
					$json->showMessage = $newStatus == 1 ? 'User has been torched' : 'User has been UNtorched';
					$mysql->query('update `users` set `torched`=' . $newStatus . ' where `id`=:uid;', array(
						'uid' => $user[0]['id']
					));
				}

				break;

			case 'Transfer logs':
				$user = $mysql->fetch_array('select `id`, `username` from `users` where `id`=:uid;', array(
					'uid' => $_POST['uid']
				));
				if (count($user) > 0) {
					$logs = $mysql->fetch_array('select `to`, `from`, `xats`, `days`, `date` from `transfers` where `from`=:from order by `timestamp` desc limit 15;', array(
						'from' => $user[0]['username'] . '(' . $user[0]['id'] . ')'
					));
					$json->logs = $logs;
				}
				else {
					$json->showMessage = "That user doesn't exist (or may have changed their username)";
				}

				break;

			case 'IPBan':
				$user = $mysql->fetch_array('select `connectedlast` from `users` where `id`=:uid;', array(
					'uid' => $_POST['uid']
				));
				if (count($user) > 0) {
					$ipBans = $mysql->fetch_array('select `ipbans` from `server`;') [0]['ipbans'];
					if (strpos($ipBans, $user[0]['connectedlast']) !== false) {
						$json->showMessage = 'That user has already been IP banned.';
					}
					else {
						$ipBans = json_decode($ipBans, false);
						array_push($ipBans, $user[0]['connectedlast']);
						$mysql->query('update `server` set `ipbans`=:ipb;', array(
							'ipb' => json_encode($ipBans)
						));
						$json->showMessage = $user[0]['connectedlast'] . ' is now IP banned.';
					}
				}
				else {
					$json->showMessage = "That user doesn't exist.";
				}

				break;

			case 'Close Ticket':
				if (isset($_POST['tid']) && is_numeric($_POST['tid'])) {
					$test = $mysql->fetch_array('select `status` from `spt_tickets` where `tid`=:tid;', array(
						'tid' => $_POST['tid']
					));
					if (count($test) > 0 && $test[0]['status'] > 0) {
						$mysql->query('update `spt_tickets` set `status`=0 where `tid`=:topicId and `status`!=0;', array(
							'topicId' => $_POST['tid']
						));
						$json->showMessage = 'Ticket has been archived; you will be redirected in a few seconds.';
						$json->redirect = true;
					}
					else {
						$json->showMessage = 'That ticket was already archived';
					}
				}
				else {
					$json->showMessage = 'Nigga please.';
				}

				break;

			case 'Elevate to admin dept':
				if (isset($_POST['tid']) && is_numeric($_POST['tid'])) {
					$where = $core->user->isAdmin() || $core->user->isVolunteer() ? ';' : ' and `ticketmaster`=' . $core->user->getID() . ';';
					$mysql->query('update `spt_tickets` set `dept`=\'admin\' where `tid`=:tid' . $where, array(
						'tid' => $_POST['tid']
					));
					$json->showMessage = 'Done!';
				}

				break;
			}
		}
		else {
			$json->status = "FAIL";
		}

		$json->request = array_merge($_POST, $_GET);
		exit(json_encode($json));
	}
}

?>
<link href="//ixat.io/cache/cache.php?f=support.css&d=css" rel="stylesheet" type="text/css" />
<script data-cfasync="false" type="text/javascript">
var supportAdmin  = <?php print $core->user->isAdmin()  ? 'true' : 'false' ?>;
var supportHelper = <?php print $core->user->isVolunteer() ? 'true' : 'false' ?>;
</script>
<section class="section bg-gray p-25">
	<div class="container">
		<div class="row justify-content-end">
			<div class="col-5">
				<div class="btn-group btn-group-toggle" data-toggle="buttons">
					<label class="btn btn-secondary active" id="sptOpen">
						<input type="radio" name="options" autocomplete="off" checked> Tickets
					</label>
					<label class="btn btn-secondary" id="sptNew">
						<input type="radio" name="options" autocomplete="off"> New
					</label>
					<label class="btn btn-secondary" id="sptArchived">
						<input type="radio" name="options" autocomplete="off"> Archived
					</label>
				</div>
			</div>
		</div>
		<br>
		<div class="row justify-content-center">	
			<div class="col-10">
				<div class="sptContent"></div>
				<div class="sptCover"></div>
			</div>
		</div>
	</div>
</section>
<script data-cfasync="false" type="text/javascript" src="/cache/cache.php?f=support.js&d=js"></script>