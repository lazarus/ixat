<?php
	if(!isset($config->complete)) return include $pages['setup'];
	if(!isset($core->user)) return include $pages['landing'];
	if(!empty($_POST = array_filter($_POST, function($k) {
			return $k !== '0';
		})) && $core->user->isAdmin()) {
		ini_set('display_errors', 1);
		ini_set('display_startup_errors', 1);
		error_reporting(E_ALL);
	}
	
	if(isset($_POST['buyPowers'])) {
		$json = new stdClass();
		$json->status = 'ok';
		arsort($_POST, SORT_NUMERIC);
		try {
			unset($_POST['buyPowers'], $_POST['powersTable_length']);
			if(empty($_POST))
				throw new Exception("Please select some powers to buy.");
			$tobuy = [];
			foreach($_POST as $key => $value) {
				if(empty($value) || $value === 0) continue;
				$pid = substr($key, substr($key, 0, 1) == "p" ? 1 : 3);
				if(intval($value) <= 0 && $value != "ON") continue;
				if(!in_array($pid, $tobuy))
				$tobuy[$pid] = $value == "ON" ? 1 : intval($value);
			}
			if(empty($tobuy))
				throw new Exception("Please choose real powers to buy...");
			$powers = $mysql->fetch_array("SELECT `name`, `id`, `cost`, `limited`, `amount` FROM `powers` WHERE `id` in ('" . implode("', '", array_keys($tobuy)) . "');");
			
			if(empty($powers))
				throw new Exception('An error has occured.');
			if($core->user->isHeld())
				throw new Exception('You are blocked from buying powers '.(($user->hold['xats']==-1)?'permanently.':'for '.floor($core->user->getHoldTime()-time()/86400)));
			if($core->user->isTorched())
				throw new Exception('You are torched and cannot buy powers.');
			
			$total = 0;
			foreach($powers as $power) {
				for($i = 0; $i < $tobuy[$power['id']]; $i++) {
					$total += $power['cost'];
					if($core->user->getXats() < $total) {
						throw new Exception('You don\'t have enough xats to buy those powers; you need '. ($total - $core->user->getXats()) .' more.');
					}
				}
			}
			foreach($powers as $power) {
				if($power['limited'] == 1) {
					if($tobuy[$power['id']] > $power['amount'])
						throw new Exception("There aren't that many of that power left.");
					if($power['amount'] == 0)
						throw new Exception('The power you are trying to buy is limited.');
					$mysql->query('update `powers` set `amount`=`amount`-'.$tobuy[$power['id']].' where `id`=' . $power['id'] . ';');
				}
			}
			$userpowers = $mysql->fetch_array("SELECT `powers`,`dO` FROM `users` WHERE `id`=:uid;", array("uid" =>$core->user->getID()));
			$userpowers = $core->DecodePowers($userpowers[0]['powers'], $userpowers[0]['dO']);
			if($core->user->getXats() >= $total) {
				foreach($tobuy as $powerid => $amount) {
					if (array_key_exists($powerid, $userpowers)) {
						$userpowers[$powerid] += $amount;
					} else {
						$userpowers[$powerid] = $amount;
					}
				}

				list($powers, $dO) = $core->EncodePowers($userpowers);

				$mysql->query("UPDATE `users` SET `powers`=:powers, `dO`=:dO, `xats`=`xats`-" . $total . " WHERE `id`=:uid;", array("uid" => $core->user->getID(), "powers" => $powers, "dO" => $dO));
				$core->user->reduceXats((int) $total);
				setCookie('xats', $core->user->getXats());
			
				$json->relogin = $core->refreshLogin(false);
			}
		} catch(Exception $e) {
			$json->status = $e->getMessage();
		}
		print json_encode($json);
		exit;
	}
?>
<style>
th, td { vertical-align: inherit !important; }
.table > tbody > tr:first-child > td {
	border-top: none;
}
.noresize {
	max-width: initial;
}
</style>
	<!--
	|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
	| Powers
	|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
	!-->
	<section class="section">
		<div class="container">
			<div class="row">
				<div class="col-12">
					<h3 class="box-title">Buy Powers</h3>
					<form id="buyPowersForm" method="post">
						<div class="box-body">
							<table id="powersTable" class="table table-bordered table-hover table-striped">
								<thead>
									<tr>
										<th>ID</th>
										<th>Power</th>
										<th></th>
										<th>Smilie</th>
										<th></th>
										<th>Cost</th>
										<th>Quantity</th>
										<th>or check</th>
										<th><span>Description <font color="#FF0000">(Please read carefully!)</font></span></th>
									</tr>
								</thead>
								<tbody id="powerBlock">
								<?php
									$powers = $mysql->fetch_array('select `id`, `name`, `cost`, `limited`, `description`, `amount` from `powers` where `p`=1 and `name` not like \'%(Undefined)%\' and name not in(\'allpowers\', \'botpawn\', \'209\', \'everypower\') ORDER BY `id` DESC;');
									ob_start();
									foreach($powers as $pwrIndex => $power) {
										if (pow(2, ($power['id'] % 32)) < 2147483647) {
											$html = '<tr class="' . ($pwrIndex % 2 == 0 ? 'odd':'even') . '">';
												$html .= "<td>{$power['id']}</td>";
												$html .= "<td>(".$power['name'] .")<br />". ($power['limited'] == 1 ? $power['amount'] > 0 ? '<b><a title="'.ucfirst($power['name']) .' will be temporarily unavailable when sold out.">'.$power['amount'].'</a> <font color="#ff0000"> remaining!</font></b>' : "<i>Unavailable, try <a href='//ixat.io/trade'>trading</a></i>":"") . "</td>";
												$html .= '<td style="text-align: center;">' . ($pwrIndex == 0 ? '<img class="noresize" alt="new" width="40" height="40" src="//ixat.io/images/NewIcon.gif" border="0">':'') . '</td>';
												$html .= '<td style="text-align: center;"><img width="30" height="30" alt="' . $power['name'] . '" src="//ixat.io/images/smw/' . $power['name'] . '.png"></td>';
												$html .= '<td style="text-align: center;">' . ($power['limited'] == 0 ? '<img src="//ixat.io/images/apicon.png" border="0">':'') .'</td>';
												$html .= '<td>' . $power["cost"] . ' xats</td>';
												$html .= '<td style="text-align: center;">' . ($power['limited'] == 0 || $power['amount'] > 0 ? '<input name="num' . $power['id'] .'" class="form-control" value="0" type="text" size="3">':'') . '</td>';
												$html .= '<td style="text-align: center;">' . ($power['limited'] == 0 || $power['amount'] > 0 ? '<input type="checkbox" value="ON" name="p' . $power['id'] .'">':'') . '</td>';
												$html .= '<td>' . str_replace('$WIKI', 'See <a target="_blank" href="//util.xat.com/wiki/index.php/'.ucfirst($power['name']) .'">wiki for details</a>.', $power["description"]) . '</td>';
											$html .= '</tr>'."\n";
											print $html;
										}
									}
									ob_end_flush();
								?>
								</tbody>
							</table>
						</div>
						<div class="box-footer">
							<button type="submit" name="buyPowers" class="btn btn-primary">Buy powers</button>
							<button type="button" name="checkUnowned" class="btn btn-primary">Check Unowned</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>	
<script type="text/javascript">
	<?php
        $userpowers = $core->GetUserPower($core->user->getID());
        print "var userpowers = " . json_encode($userpowers) . ";\n";
	?>

	var table;

	function onJQueryLoaded() {	
		jQuery.fn.dataTableExt.oSort['num-html-asc'] = function(a,b) {
			var x = a.replace(/[^0-9]/g, "");
			var y = b.replace(/[^0-9]/g, "");
			x = parseFloat( x );
			y = parseFloat( y );
			return ((x < y || isNaN(y) ) ? -1 : ((x > y || isNaN(x)) ? 1 : 0));
		};

		jQuery.fn.dataTableExt.oSort['num-html-desc'] = function(a,b) {
			var x = a.replace(/[^0-9]/g, "");
			var y = b.replace(/[^0-9]/g, "");
			x = parseFloat( x );
			y = parseFloat( y );
			return ((x < y || isNaN(x)) ? 1 : ((x > y || isNaN(y) ) ? -1 : 0));
		};		
	
		table = $("#powersTable").DataTable({
			"dom": "<'row'<'col-sm-6'li><'col-sm-6'fp>><'row'<'col-sm-12'tr>><'row'<'col-sm-5'i><'col-sm-7'p>>",
			"order": [[0, "desc"]],
			"columnDefs": [
				{
					"orderData": [0],
					"targets": [1]
				},
				{
					"targets": [2, 3, 4, 6, 7, 8],
					"orderable": false
				},
				{
					"targets": [0],
					"visible": false
				}
			],
			"aoColumns": [
				null,
				null,
				null,
				null,
				null,
				{ "sType": "num-html" },
				{ "sType": "num-html" },
				null,
				null,
			],
			"lengthMenu": [
				[10, 25, 50, 100, -1],
				[10, 25, 50, 100, "All"]
			],
		});
		var form = $("#buyPowersForm")
		$(form).submit(function(event) {
			event.preventDefault();
			
			var formData = $(form).serialize();
			
			$.ajax({
				type: "POST",
				url: "/powers?ajax",
				data: formData + "&buyPowers=",
				success: function(json)
				{
					json = jQuery.parseJSON(json);
					if(json.status != 'ok') {
						$.notify(json.status, 'error');
					} else {
						$('html').append(json.relogin);
						$.notify("Powers were bought successfully. Please enjoy.", 'success');
					}
				}
			});
		});
		$("[name=checkUnowned]").click(function() {
			table.page.len(-1).draw();
			var inputs = $("input[name*=p]");
			for(var i = 0; i < inputs.length; i++) {
				var input = inputs[i];
				if(!userpowers.hasOwnProperty($(input).prop("name").substr(1)) || userpowers[$(input).prop("name").substr(1)] < 1)
				$(input).prop("checked", true).val("ON");
			}
			window.scrollTo(0, document.body.scrollHeight);
		});
	}
</script>