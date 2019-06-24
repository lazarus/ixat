<?php
if(!isset($config->complete)) return include $pages['setup'];
if(!isset($core->user)) return include $pages['profile'];

if (isset($_POST['storebuy']) && ctype_alnum($_POST['storebuy'])) {
    $status = 'ok';
    
    try {
        $power = $mysql->fetch_array('select id, cost, amount, limited from `powers` where `p`=1 AND `name`=:power;', array('power' => $_POST['storebuy']));
        
        if (empty($power)) {
            throw new Exception('An error has occured.');
        }
        if ($core->user->isHeld()) {
            throw new Exception('You are blocked from buying powers '.(($user->hold['xats']==-1)?'permanently.':'for '.floor($core->user->getHoldTime()-time()/86400)));
        }
        if ($core->user->isTorched()) {
            throw new Exception('You are torched and cannot buy powers.');
        }
        if ($core->user->getXats() < $power[0]['cost']) {
            throw new Exception('You don\'t have enough xats to buy that power.');
        }
        if($power[0]['limited'] == 1) {
            if ($power[0]['amount'] == 0) {
                throw new Exception('The power you are trying to buy is limited.');
            }
            $mysql->query('update `powers` set `amount`=`amount`-1 where `id`=' . $power[0]['id'] . ';');
        }
        
        $mysql->query('update `users` set `xats`=`xats`-' . $power[0]['cost'] . ' where `id`=' . $core->user->getID() . ';');
        $core->user->reduceXats((int) $power[0]['cost']);
        
        $core->AddUserPower($core->user->getID(), $power[0]['id'], 1);
    }
    catch(Exception $e) { $json->status = $e->getMessage(); }
?>
<div class="container-fluid">
	<section class="content-header">
    <center><font color="white">
        <h1><span data-localize=buy.buypow>Buy powers</span></h1>
<?php
    if ($status != 'ok') {
        print $status;
    } else {
        print '<span data-localize=buy.completeta>Purchase completed. Thank you.</span><div id="LoginResult"><h3><span data-localize=buy.pleasewait>Please wait</span>..<br>&nbsp;</h3><p><large>&nbsp;</large></p></div><BR> <embed src="//ixat.io/cache/cache.php?f=chat.swf&d=flash" quality="high" width="0.5" height="0.5" name="chat" FlashVars="id=9&pw=##" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="//xat.com/update_flash.php" /><br>';
    }
?>
    </font></center>
    </section>
</div>
<script>
    function LoggedIn(ok) {
        var s = "<span data-localize=buy.refreshok>Refresh sucessful.<BR>Please close all chat windows.</span>";
        if(!ok) s = "<span data-localize=buy.refreshfail>Refresh failed.. Please <a href=\"http://ixat.io/login\">login</a> again.</span>";
                    
        var divId=document.getElementById("LoginResult");
        if(divId) divId.innerHTML=s;
        
        divId=document.getElementById("ChangeStatus");
        if(divId) divId.style.visibility = "visible";
    }
</script>
<?php
} else {
?>  
<link href="//ixat.io/cache/cache.php?f=slider.css&d=css" rel="stylesheet" type="text/css" />
<div class="container-fluid">
	<section class="content-header">
		<div class="row">
			<div class="col-sm-4" align="center">
				<div class="box box-primary box-solid">
					<div class="box-header with-border">
						<h3 class="box-title">Search by name</h3>
					</div>
					<div class="box-body">
						<label>Powers will update as you type.</label>
						<input class="form-control input-sm" id="psearchname" type="text">
					</div>
				</div>	
			</div>	
			<div class="col-sm-4" align="center">
				<!--<font color="white">Hover over the power NAME for any smilies associated with the power (if there are any)</font><br>-->
				<font color="white">Hover over the power NAME for a brief description of it</font><br>
				<input type="checkbox" id="psearchown" value="hideowned"> <font color="white">Hide powers that I already own</font><br>
				-->
			</div>							
			<div class="col-sm-4" align="center">
				<div class="box box-primary box-solid">
					<div class="box-header with-border">
						<h3 class="box-title">Search by price</h3>
					</div>
					<div class="box-body">
						<!--
						<center>Powers will update as you type.</center>
						<input class="form-control input-sm" id="psearchprice" type="text">
						-->
						<input type="text" value="" class="slider form-control">
					</div>
				</div>	
			</div>
		</div>
		<div id="pages"></div>
		<div class="row" id="powerBlock"></div>		
	</section>	
</div>
<script type="text/javascript">
	<?php
		$powers = $mysql->fetch_array('select `id`, `name`, `cost`, `limited`, `description`, `amount` from `powers` where `p`=1 and `name` not like \'%(Undefined)%\' and name not in(\'allpowers\', \'botpawn\', \'209\', \'everypower\') and `subid`<2147483647 ORDER BY `id` DESC;');
		foreach($powers as $k => $v) {
            if (pow(2, $k['id'] % 32) > 2147483647) {
                unset($powers[$k]);
            }
        }
        $upowers = $core->GetUserPower($core->user->getID());
		$userpowers = array();
		foreach($upowers as $id=> $count)
			$userpowers[$id] = $count;
		print "var powers = JSON.parse(\"" . addslashes(json_encode($powers)) . "\");\n";
		print "var userpowers = JSON.parse(\"" . addslashes(json_encode($userpowers)) . "\");\n";
		print "var usepowers = [];\n";
	?>
	window.onload = function() {
		usepowers = powers;
		setPages();
		loadPage(1);
		//$.getScript("//ixat.io/cache/cache.php?f=bootstrap-slider.js&d=js", function(){
			var highest = 0;
			powers.map(function(item) {
				 if(parseInt(item.cost) > highest) highest = parseInt(item.cost);
			});
			$(".slider").bootstrapSlider({
				min: 0,
				max: highest,
				step: 100,
				value: [0, highest],
				orientation: "horizontal",
				selection: "before",
				tooltip: "always"
			}).on('slide', function(ev) {
				var values = ev.value;
				usepowers = [];
	
				for(var i in powers)
				{
					power = powers[i];
					if(power['cost'] == null) return;
					if(values[0] <= power["cost"] && power["cost"] <= values[1]) {
						usepowers.push(power);
					}
				}
				setPages();
				loadPage(1);
			});
		//});
	}
	
	function setPages() {
		var pwr_max = usepowers.length;
		var pwr_pages = pwr_max / 18 + (pwr_max % 18 == 0 ? 0 : 1);
		var pages = document.getElementById('pages');
		
		pages.innerHTML = '<div class="btn btn-group btn-small btn-daniel btn-flat disabled"/>Pages:</div>';
		
		for(var i = 1; i <= pwr_pages; i++)
			pages.innerHTML += '<div class="btn btn-group btn-small btn-daniel btn-flat" onclick="loadPage(' + i + ')">' + i.toString() + '</div>';

		pages.innerHTML = '<center>' + pages.innerHTML + '</center><br />';
	}
	
	function loadPage(page) {
		$("#pages span").removeClass("active");
		$($("#pages span")[page - 1]).addClass("active");
		var index = (page - 1) * 18;
		var on_page = usepowers.slice(index, index + 18);
		var power = null;
		var element = null;
		var html = null;
		var powerBlock = document.getElementById('powerBlock');
		powerBlock.innerHTML = "";
		
		if(on_page.length > 0) {
			for(var pwrIndex in on_page) {
				power = on_page[pwrIndex];
				html = '<div class="col-sm-2">';
				html += '<div class="box box-primary box-solid">';
				html + "<center>";
				html += '<div class="box-header with-border" title="' + power["description"] + '">';
				html += '<h3 class="box-title">' + power['name'] + '</h3>';
				if(userpowers[power['id']])
					html += '<div class="box-tools pull-right" title="You have ' + userpowers[power['id']] + '"><i class="zmdi zmdi-check fa fa-check"></i></div>';
				html += '</div>';
						
				html += "</center>";
				html += '<div class="box-body">';
                html += '<p>Price <span class="badge bg-light-blue pull-right">' + power["cost"] + ' xats</span></p>';
				html += '<input type="hidden" id="xats" value="' + power["cost"] + '" />';
				status = "unlimited";
				if(parseInt(power['limited']) == 1) {
                    if(parseInt(power['amount']) > 0)
                        status = power['amount'] + " available";
                    else
                        status = "Limited";
				}
				html += '<p>Status <span class="badge bg-light-blue pull-right">' + status + '</span></p>';
				html += '<center><table><tr><td align="center">';
				html += '<a class="btn" data-toggle="collapse" data-target="#p' + power['id'] +'"><span class="badge">Click to Preview</span></a>';
				html += '</td></tr><tr><td align="center">';
				html += '<embed class="collapse" id="p' + power['id'] + '" height="60%" width="60%" type="application/x-shockwave-flash" quality="high" src="/images/sm2/' + power['name'] + '.swf?r=2" wmode="transparent" />';
				html += '</td></tr></table></center>';	
                html += '<form method="post"><input type="hidden" name="storebuy" value="' + power['name'] + '" />';
				html += '<button class="btn btn-daniel" type="submit" style="width: 100%" />Purchase</button></form>';
				html += '</div></div></div>';
				
				powerBlock.innerHTML += html;
			}
		} else {
			powerBlock.innerHTML = '<div class="alert alert-dismissable alert-daniel"><center>No powers were found</center></div>';
		}
		
		function htmlescape(text) {
			return text
			  .replace(/&/g, "&amp;")
			  .replace(/</g, "&lt;")
			  .replace(/>/g, "&gt;")
			  .replace(/"/g, "&quot;")
			  .replace(/'/g, "&#039;");
		}
	}

</script>
<?php
}
?>