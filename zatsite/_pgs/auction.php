<?php

if (!isset($core->user)) // || !$core->user->isAdmin())//(!$core->user->isAdmin() && $core->user->getID() != 777))

{
	return include $pages['home'];

}

// $core->user->isAdmin() = false;

/*
if($core->user->isAdmin())
var_dump($mysql->fetch_array("SELECT * FROM auction;"));
*/

if (isset($_POST["req"]) && isset($core->user) && $core->user->isAdmin() && $core->user->getID() != 3)
{

	// var_dump($_POST);

	$messages = [];
	switch (@(string)((string)strtolower($_POST["req"])))
	{
	case "start_auction":
		$_POST = array_filter($_POST, 'strlen');
		if (!isset($_POST['time'], $_POST['id'], $_POST['bid']))
		{
			$messages[] = "Dude... wtf are you doing... Fill in all the fields or leave them with the default value.";
			break;
		}

		if (isset($_POST['time']) && strtotime("+" . $_POST['time']) <= time())
		{
			$messages[] = "Time must be more than 0 seconds...";
		}

		$user = $mysql->fetch_array("SELECT `id` FROM `users` WHERE `id`=:id;", ["id" => $_POST['id']]);
		if (count($user) > 0)
		{
			$messages[] = "That ID already exists. Either delete the account or choose a new ID.";
		}

		$auction = $mysql->fetch_array("SELECT `uid` FROM `auction` WHERE `uid`=:id;", ["id" => $_POST['id']]);
		if (count($auction) > 0)
		{
			$messages[] = "That ID is already up for auction.";
		}

		if ($_POST['bid'] < 100)
		{
			$messages[] = "Starting bid must be greater than or equal to 100 xats.";
		}

		if (count($messages) > 0) break;

		$mysql->insert("auction", ['id' => null, 'uid' => $_POST['id'], 'bid' => $_POST['bid'], 'bidby' => 0, 'bidbyu' => '', 'prevbid' => 0, 'prevbidby' => 0, 'prevbidbyu' => '', 'timeleft' => strtotime("+" . (isset($_POST['time']) ? $_POST['time'] : "1 day")) ]);
		break;

	case "end_auction":
		if (!isset($_POST['id']) || !(isset($_POST['end']) || isset($_POST['delete'])))
		{
			$messages[] = "How did you even end up here...";
			break;
		}

		if (isset($_POST['delete']))
		{
			$check = $mysql->fetch_array("select * from `auction` where `uid`=:a;", ["a" => $_POST["id"]]);
			if (is_numeric($check[0]["bidby"]) && is_numeric($check[0]["bid"]))
			{
				$mysql->query("update `users` set `xats`=`xats`+:bid where `id`=:bidby;", ["bid" => $check[0]["bid"], "bidby" => $check[0]["bidby"]]);
			}
		}

		$mysql->query("UPDATE `auction` SET `timeleft`=:time WHERE `uid`=:id;", ["id" => $_POST['id'], "time" => isset($_POST['end']) ? time() : -2]);
		break;
	}

	foreach($messages as $message)
	{
		print '<div class="alert alert-daniel"><center>' . $message . '</center></div>';
	}
}
elseif (isset($_POST["id"], $_POST["price"], $_POST["agree"], $_POST["pass"]) && count($_POST) < 6)
{
	try
	{
		if (isset($_POST["claim"]))
		{
			if (is_numeric($_POST["id"]) && strlen($_POST["id"]) < 25 && strlen($_POST["id"]) != 0)
			{
				$check = $mysql->fetch_array("select * from auction where `uid`=:a and `bidby`=:uid and `timeleft`>0;", array(
					"a" => $_POST["id"],
					"uid" => $core->user->getID()
				));
				if (empty($check))
				{
					throw new Exception('<span style="color:#FE2E2E">Invalid ID!</span>');
				}

				if ($check[0]["timeleft"] == - 1)
				{
					throw new Exception('<span style="color:#FE2E2E">This ID has already been claimed!</span>');
				}

				if ($check[0]["timeleft"] <= time())
				{
					if ($check[0]["bidby"] == $core->user->getID())
					{
						$mysql->query('update `users` set `id`=:new_id where `id`=:old_id;', ["new_id" => $check[0]["uid"], "old_id" => $core->user->getID()]);
						$mysql->query('update `ranks` set `userid`=:new_id where `userid`=:old_id;', ["new_id" => $check[0]["uid"], "old_id" => $core->user->getID()]);
						$mysql->query("update `auction` set `timeleft`=CONCAT(\"0\", `timeleft`) where `uid`=:new_id;", ["new_id" => $check[0]["uid"]]);
						print "<script>alert('You have claimed your ID! Login!');</script>";
						print "<script>window.location = '/profile?relogin'; </script>";
					}
				}
				else
				{
					throw new Exception('<span style="color:#FE2E2E">This auction is not over yet!</span>');
				}
			}
			else
			{
				throw new Exception('<span style="color:#FE2E2E">Invalid ID!</span>');
			}

			return;
		}

		if (!isset($_POST['agree']) || (isset($_POST['agree']) && !($_POST['agree'] == 'on')))
		{
			throw new Exception('<span style="color:#FE2E2E">You forgot that you must accept the terms.</span>');
		}

		if (!is_numeric($_POST["id"]) || !is_numeric($_POST["price"]) || strlen($_POST["id"]) > 25 || strlen($_POST["price"]) > 25)
		{
			throw new Exception('<span style="color:#FE2E2E">The following fields must be numeric only: ID, Price.</span>');
		}

		if (strlen($_POST["pass"]) == 0 || strlen($_POST["pass"]) > 100)
		{
			throw new Exception('<span style="color:#FE2E2E">Password should be longer than 0 and less than 100!</span>');
		}

		if (!isset($core->user))
		{
			throw new Exception('<span style="color:#FE2E2E">Please login to use this!</span>');
		}

		// $check = $mysql->fetch_array("select password from `users` where `id`=:a;", ["a" => $core->user->getID()]);
		// if (empty($check)) throw new Exception('<span style="color:#FE2E2E">Your account has been deleted by an administrator.</span>');

		if (empty($core->user)) throw new Exception('<span style="color:#FE2E2E">Your account has been deleted by an administrator.</span>');
		if (!$mysql->validate($_POST["pass"], $core->user->getPassword()))
		{
			throw new Exception('<span style="color:#FE2E2E">Incorrect password!</span>');
		}

		/*if ($check[0] == 1) {
		throw new Exception('<span style="color:#FE2E2E">Your account is held - please open a ticket.</span>');
		}*/

		// unset($check);

		$check = $mysql->fetch_array("select * from `auction` where `uid`=:a;", ["a" => $_POST["id"]]);
		if (empty($check)) throw new Exception('<span style="color:#FE2E2E">That ID is not available for auction.</span>');
		if ($check[0]["bid"] >= $_POST["price"])
		{
			throw new Exception('<span style="color:#FE2E2E">You need to bid <strong>HIGHER</strong> than the current bid</span>');
		}

		if ($check[0]["bid"] > $core->user->getXats() || $_POST["price"] > $core->user->getXats())
		{
			throw new Exception('<span style="color:#FE2E2E"><strong>Excuse me!</strong> You do not have enough xats to make that bid.</span>');
		}

		if ($_POST['price'] - 10 < $check[0]['bid'])
		{
			throw new Exception('<span style="color:#FE2E2E"><strong>Excuse me!</strong> Your bid must be at least 10 more than the previous.</span>');
		}

		if ($_POST['price'] > ($core->user->getXats() - $core->user->getReserve()))
		{
			throw new Exception('<span style="color:#FE2E2E">You cannot cut into your reserved xats. You can bid a maximum of ' . ($core->user->getXats() - $core->user->getReserve()) . " xats.");
		}

		if ($check[0]["timeleft"] <= time())
		{
			throw new Exception('<span style="color:#FE2E2E"><strong>Excuse me!</strong> This auction has already ended.</span>');
		}

		if (is_numeric($check[0]["bidby"]) && is_numeric($check[0]["bid"]))
		{
			$mysql->query("update `users` set `xats`=`xats`+:bid where `id`=:bidby;", ["bid" => $check[0]["bid"], "bidby" => $check[0]["bidby"]]);
		}

		$mysql->query("update `users` set `xats`=`xats`-:price where `id`=:uid;", ["price" => $_POST["price"], "uid" => $core->user->getID()]);
		$mysql->query("update `auction` set `bid`=:bid, `bidby`=:buid, `bidbyu`=:buname, `prevbid`=:pbid, `prevbidby`=:puid, `prevbidbyu`=:puname where `uid`=:uid;", ["bid" => $_POST["price"], "buid" => $core->user->getID(), "buname" => $core->user->getUsername(), "pbid" => $check[0]["bid"], "puid" => $check[0]["bidby"], "puname" => $check[0]["bidbyu"], "uid" => $check[0]["uid"], ]);
		throw new Exception('<span style="color:#01DF74">You have <strong>successfully<strong> placed your bid (your xats will return when you are outbid)!</span>');
	}

	catch(Exception $e)
	{
		print '<div class="alert alert-dismissable alert-info">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
	<center>' . $e->getMessage() . '</center></div>';
	}
}

?>
	<script type="text/javascript">
	</script>
	<!--
	|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
	| Auction
	|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
	!-->
	<section class="section">
		<div class="container">
			<div class="row gap-y">
				<div class="col-12">
					<div class="card bg-gray">
						<div class="card-block">
							<h5 class="card-title">Current Bids</h5>
							<table class="table table-bordered">
								<thead>
									<tr align="center">
										<td><span>ID for sale</span></td>
										<td><span>Bid</span> (xats)</td>
										<td>Highest bidder</td>
										<td>Time left</td>
										<td>Previous bid</td>
										<?php if($core->user->isAdmin()) { ?><td>Cancel</td><?php } ?>
									</tr>
								</thead>
								<tbody align="center"><?php
									$auction = $mysql->fetch_array("SELECT * FROM auction WHERE CAST(timeleft AS SIGNED) > :time ORDER BY timeleft DESC;", ["time" => ($core->user->isAdmin() && isset($_REQUEST['old']) ? -10 : strtotime("-1 week", time()))]);
									if(count($auction) > 0)
									foreach($auction as $id)
									{
										if(!$core->user->isAdmin() && $id['timeleft'] < -1) continue;
										$datetime1 = new DateTime();
										$datetime2 = new DateTime('@' . $id["timeleft"]);
										$interval = $datetime1->diff($datetime2);
										$time = $interval->format('%a days %h hours %i minutes %S seconds');
										$time = str_replace('0 days', '', $time);
										print "
										<tr>
												<td><a href=\"?id={$id["uid"]}&price=".($id["bid"] + 10)."\">{$id["uid"]}</a></td>
												<td>{$id["bid"]}</td>
												<td>".($id["bidbyu"] == "" ? "" : ("{$id["bidbyu"]} ({$id["bidby"]})"))."</td>
												<td>" . (time() > $id["timeleft"] ? ($id["timeleft"][0] === '0' ? 'Claimed' : ($core->user->isAdmin() && $id["timeleft"] < 0 ? 'Auction Deleted' : 'Ended')) : $time) . "</td>
												<td>".($id["prevbidbyu"] == "" ? "" : ("{$id["prevbidbyu"]} {$id["prevbid"]}"))."</td>
												" . ($id["timeleft"] >= -1 && $core->user->isAdmin() ? '<td><form action="" method="post">
														<input type="hidden" name="req" value="end_auction" />
														<input type="hidden" name="id" value="'.$id["uid"].'" />
														<button style="width:40%;float:left;" type="submit" class="form-control" name="end" value="End">End</button>
														<button style="width:59.6%;float:left;" type="submit" class="form-control" name="delete" value="Delete">Delete</button>
													</form></td>' : ($core->user->isAdmin() ? "<td></td>" : "")) . "
											</tr>";
										}
										else
										print "
											<tr>
													<td colspan=\"5\">There are no auctions currently running.</td>" . ($core->user->isAdmin() ? '
													<td><a href="?old"><button type="submit" class="form-control">View Old</button></a>' : '')."
											</tr>";
										?>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
				<div class="row gap-y">
					<div class="col-12 col-lg-6">
						<?php
						if($core->user->isAdmin() && $core->user->getID() != 3) {
						?>
						<div class="card bg-gray">
							<div class="card-block">
								<h5 class="card-title">Start Auction</h5>
								<form method="post" action="">
									<input type="hidden" name="req" value="start_auction" />
									<table class="table">
										<tr><th><label>ID:</label></th><th><input id="auction_id" name="id" type="text" class="form-control" required/></th></tr>
										<tr><th><label>Starting Bid:</label></th><th><input id="starting_bid" name="bid" type="text" class="form-control" value="100" required></th></tr>
										<tr><th><label>Run Time:</label></th><th><input id="run_time" name="time" type="text" class="form-control" value="1 day" required></th></tr>
									</table>
									&nbsp;&nbsp;
									<button id="start_auction" type="submit" value="Start Auction" class="form-control" />Start Auction</button>
								</form>
							</div>
						</div>
						<?php
						}
					?></div>
					<div class="col-12 col-lg-6">
						<div class="card bg-gray">
							<div class="card-block">
								<h5 class="card-title">The minimum bid for this auction is: 10 xats</h5>
								<form method="post">
									<div class="form-group">
										<table>
											<tr>
												<td><p>Username:&nbsp;</p></td>
												<td><p><input class="form-control" style="width: 178px" input type="text" readonly="readonly" autocomplete="off" value="<?php echo $core->user->getUsername(); ?>" placeholder="Username" /></p></td>
												<td><p><span>&nbsp;(<a href="/profile">login</a> to change this)</span></p></td>
											</tr>
											<tr>
												<td><p>Password:&nbsp;</p></td>
												<td><p><input required class="form-control" style="width: 178px" type="password" name="pass" <?php print isset($_POST["pass"]) ? 'value="' . htmlentities($_POST["pass"]) . '"' : '' ?> placeholder="Password" /></p></td>
												<td></td>
											</tr>
											<tr>
												<td><p>Desired ID:&nbsp;</p></td>
												<td><p><input required class="form-control" style="width: 178px" type="text" name="id" <?php print isset($_GET["id"]) ? 'value="' . htmlentities($_GET["id"]) . '"' : '' ?> placeholder="Enter ID" /></p></td>
												<td><p><span>&nbsp;# digits</span></p></td>
											</tr>
											<tr>
												<td><p>Bid:&nbsp;</p></td>
												<td><p><input required class="form-control" style="width:178px" type="text" name="price" value="<?php print isset($_GET["price"]) ? htmlentities(intval($_GET["price"])) : 0 ?>" /></p></td>
												<td><p><span>&nbsp;xats <font color="red">(CHECK CAREFULLY)</font></span></p></td>
											</tr>
										</table>
										<label><input required type="checkbox" name="agree"> I have read and agree to the rules and <a href="/terms">terms</a></label>
									</div>
									<button style="width: 49.6%" class="btn btn-primary form-control" type="submit" name="btn" value="Bid"/><i class="zmdi zmdi-shopping-basket fa fa-gavel"></i> Submit Bid</button>
									<button style="width: 49.6%" class="btn btn-primary form-control" type="submit" name="claim" value="Claim" /><i class="zmdi zmdi-swap fa fa-exchange"></i> Claim ID</button>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>