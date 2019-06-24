<?php
if(!isset($config->complete))
{
	return include $pages['setup'];
}
if(!isset($core->user))
{
	return include $pages['profile'];
}
$isBlackFriday = false;//set to true on BF
$hasBlackFriday = true;
$DesiredName = $core->xatTrim(@$_POST['dname'], 128);
$Quote = array_key_exists('Quote',$_POST);
$Submit = array_key_exists('Submit',$_REQUEST);
$Submit_BF = array_key_exists('SubmitBF',$_REQUEST);
$Err = false;
if(!$core->user->isAdmin() && $Err === false && ($Quote || $Submit || $Submit_BF)) {
	if($DesiredName !== @$_REQUEST['dname']) $Err = "<span>Name contains bad letters</span>";
	if(strlen($DesiredName) < 3) $Err = "<span>Name is too short</span>";
	if(strlen($DesiredName) > 9) $Err = "<span>Name is too long</span>";
	if(BadName($DesiredName)) $Err = "<span>Name is not allowed. Please try another.</span>";
	$t = str_replace('0', 'o', $DesiredName);
	$t = str_replace('1', 'l', $t);
	if(BadName($t)) $Err = "<span>Name is not allowed. Please try another.</span>";
	$f = ord($DesiredName{0});
		if($f >= ord('0') && $f <= ord('9')) $Err = "<span>First letter must not be a number.</span>";
}
if($Err === false)
	if(@$_POST['agree'] !== 'ON')
		$Err = "<span>You must agree to the terms</span>";
if($Err === false) {
	$query = $mysql->fetch_array("SELECT `username` FROM `users` WHERE `username`=:u;", array('u' => $DesiredName));
	
	if(count($query) > 0 && strtolower($DesiredName) != strtolower($core->user->getUsername()))
		$Err = "<span>Sorry, name already taken</span>";
	
	$upowers = $core->GetUserPower($core->user->getID(), 260);
	if(empty($upowers)) {
		$isBlackFriday = false;
		$hasBlackFriday = false;
	} else {
		$hasBlackFriday = true;
	}
}
$Xats = 0;
$Xats_BF = 0;
if($Err === false) {
	$Xats = CalcXats($DesiredName);
	if($Xats == -1)
	{
		$Err = "<span>Sorry, we cant do that</span>";
	}
	if($isBlackFriday && $hasBlackFriday)
	{
		$Xats_BF = CalcXats($DesiredName, 2);
	}
	if($Xats_BF == -1)
	{
		$isBlackFriday = false;
		$hasBlackFriday = false;
		$Err = "<span>Sorry, we cant do that</span>";
	}
	if(strtolower($DesiredName) == strtolower($core->user->getUsername()))
	{
		$Xats = 2500;
		if($Xats_BF != 0) $Xats_BF = 2500;
	}
}
if($Submit && $Xats != intval($_REQUEST['Xats'])) {
	$Submit = false;
		$Err = "<span>Cost changed</span>";
}
if($Submit_BF && $Xats_BF != intval($_REQUEST['Xats_BF'])) {
	$Submit_BF = false;
		$Err = "<span>Cost changed</span>";
}
if(($Submit && $Xats > 0) || ($Submit_BF && $Xats_BF > 0)) {
	if($Err === false) {
		$cost = (int) $Xats > 0 ? $Xats:$Xat_BF;
		if($core->user->getXats() < $cost) {
			$Err = "<span>Not enough zats</span>";
		} else {
			$u = $mysql->fetch_array("SELECT `snLastBuy`,`torched` FROM `users` WHERE `username`=:u;", array('u' => $core->user->getUsername()));
			if($u[0]['torched'] > 0) {
				$Err = "<span>Sorry, torched users cant purchase a shortname</span>";
			} else{
				$lastBuy = empty($u) ? time():$u[0]['snLastBuy'];
				$buyTime = time();
				if(($buyTime - $lastBuy >= 86400) || $core->user->isAdmin()) {
					if(!$core->user->isAdmin()) {
						$core->user->reduceXats($cost);
						setCookie('xats', $core->user->getXats());
					}
					$query = $mysql->query("UPDATE `users` SET `username`=:u, `xats`=:x, `snLastBuy`=:lb WHERE `id`=:id;", array('u' => $DesiredName, 'x' => $core->user->getXats(), 'id' => $core->user->getID(), 'lb' => $buyTime));
					$mysql->insert('shortname', array('time' => $buyTime, 'id' => $core->user->getID(), 'original' => $core->user->getUsername(), 'new' => $DesiredName, 'cost' => $cost));
					if($Submit_BF && !$Submit && $hasBlackFriday)
					{
						$core->RemUserPower($core->user->getID(), 260);
					}
					$Err = "<span>Name changed</span>.";
					sleep(1);
					print $core->refreshLogin();
				} else {
					$Err = "<span>You can only name change once per day</span>.";
				}
			}
		}
	}
}
?>
<!--
|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
| Powers
|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
!-->
<section class="section">
	<div class="container">
		<div class="row gap-y">
			
			<div class="col-12 col-lg-4">
				<div class="card bg-gray">
					<div class="card-block">
						<h5 class="card-title">Rules:</h5>
						<p>
							1. If your short name is unused for 90 days it may be sold again.</br>
							2. Your current name will be replaced and lost.</br>
							3. If you choose a short name that is offensive (in any language) it may be deleted without refund.</br>
							4. You can only name change once per day.</br>
							5. No REFUNDS are issued at all for any shortname purchases, except in extreme circumstances!
						</p>
					</div>
				</div></div>
				
				<div class="col-12 col-lg-4">
					<div class="card bg-gray">
						<div class="card-block">
							<h5 class="card-title">Buy a short user name</h5>
							<form method="post">
								<?php if($Err !== false) print "<p style=\"color:#FF0000\"><strong>**{$Err}**</strong></p>\n"; ?>
								<div class="form-group">
									<label>Desired Name:</label>
									<input class="form-control" type="text" name="dname" value="<?php print ($DesiredName); ?>"/>
								</div>
								<input type="checkbox" name="agree" value="ON" <?php if(isset($_POST['agree']) && $_POST['agree'] === 'ON') print 'checked'; ?>/> I have read and agree to the rules and terms.
								<br>
								<p>
									<button name="Quote" type="submit" class="btn btn-primary btn-sm">
									<i class="zmdi zmdi-help fa fa-question-circle"></i>&nbsp;<span>Get cost</span>
									</button>
									<?php
										if($Err == false && (@$Xats || @$Xats_BF) && $_POST['dname']) {
											print ' <input type="hidden" name="Xats" value="'.$Xats.'">'.
											"<span>Cost</span>: {$Xats} xats".
											'<br><button name="Submit" type="submit" class="btn btn-primary btn-sm"><i class="zmdi zmdi-shopping-cart fa fa-shopping-cart"></i>&nbsp;<span>Buy</span> '.$DesiredName.'</button> ('."<span>Only click once!</span>".')';
											if($isBlackFriday && $hasBlackFriday)
											{
												print "<input type=\"hidden\" name=\"Xats_BF\" value=\"{$Xats_BF}\"><br><br>";
												print "<center>There is currently a BlackFriday Sale, you can give up one of your blackfriday powers for a 33% discount.</center>";
												print '<br><center><span>Cost</span>:'.$Xats_BF.' xats</center><br><center><button name="SubmitBF" type="submit" class="btn btn-primary btn-sm"><i class="zmdi zmdi-shopping-cart fa fa-shopping-cart"></i>&nbsp;<span>Buy</span> '.$DesiredName.' Using 1 BlackFriday</button></center>';
											}
										}
										else if($Err === "temp")
											print "<span>Cost</span>: {$Xats} xats";
									?>
								</p>
							</form>
						</div>
					</div>
				</div>
				<div class="col-12 col-lg-4">
					<?php
						if($core->user->isAdmin())
						{
							print '
					<div class="card bg-gray">
						<div class="card-block">
							<h5 class="card-title">Admins Only:</h5>
										<p>
												1. You can purchase any length name.</br>
												2. You can use numbers as the first character.</br>
												3. You will not be charged.</br>
												4. You can change name whenever you want.
										</p>
									</div></div>
								';
							}
						?>
					</div>
				</div>
			</div>
		</section>
		<?php
		function CalcXats($DesiredName, $inflation = 4) {
			$body = file_get_contents('https://www.googleapis.com/customsearch/v1?q=' . strtolower($DesiredName) . '&key=AIzaSyCmNUYPrd_BIAofpZCsLay-DumVOJU8QT0&cx=010012013479808163352:mvu-ewtvhnq&filter=1');
			if(!$body) return -1;//cant reach google sorry
			
			$json = json_decode($body); //decode json response
			if(isset($json->error)) return -1; //google suspectes spaming
				
			$erc = intval($json->searchInformation->totalResults);
			if($erc < 1) return -1;//erc is not legit
			if(ord($erc) > ord('9') || ord($erc) < ord('0')) return -1;
			
			$x = intval(224.08 / 6 * pow($erc, 0.26));
			$n = 0;
			while($x > 99) {
				$n++;
				$x = intval($x / 10);
			}
			while($n) {
				$n--;
				$x *= 10;
			}
			$x *= 4; // Google factor was 2.3
			$x += 600 * pow(1.7, 9 - strlen($DesiredName)); // 500, 1.7 length factors
			$x *= $inflation; // inflation 1.5
			if($x < 5000) $x = 2000 * $inflation;
			return intval($x);
		}
		function BadName($s) {
			$badwords = array('zat','admin','staff','xat','andy','techy');
			$copycat = array('tech','austin','andy','techy');
			
			$s = strtolower ($s);
			$s = str_replace('3', 'e', $s);
			$s = str_replace('0', 'o', $s);
			$s4 = $s3 = $s2 = $s;
			$s = str_replace('1', 'l', $s);
			$s2 = str_replace('1', 'i', $s2);
			$s3 = str_replace('l', 'i', $s3);
			$s4 = str_replace('i', 'l', $s4);
			
			if(in_array($s, $copycat))
				return true;
			
			$s = "$s $s2 $s3 $s4";
				
			foreach ($badwords as $v)
				if(strpos($s, $v) !== false) return true;
				
				return false;
		}
		?>