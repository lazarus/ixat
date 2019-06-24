<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
<div class="row">
	<div class="col-sm-4"></div>
	<div class="col-sm-4">
<?php
	/* Pow2 Indexs
		0 = last
		1 = backs
		2 = actions
		3 = hugs
		4 = topsh
		5 = isGroup
		6 = pssa
		7 = pawns
        8 = nonmob
        9 = pawns2
	*/	
    /* Pow2 Last status
        [Very Limited] = very hard to get
        [Limited] = not in store unless timed release
        Default "" = UNLIMITED
        [Boosted] = old power updated
    */
	$pow2 = getJson('http://xat.com/web_gear/chat/pow2.php?' . time());
	$powers = getJson('http://xat.com/json/powers.php?' . time());
	$id = end($pow2[6][1]) >= $pow2[0][1]['id'] ? end($pow2[6][1]):$pow2[0][1]['id']; //check for highest id
	$id = $id >= key($powers) ? $id:key($powers);//double check
    $id = count(array_keys($pow2[4][1], $id + 1)) > 0 ? $id + 1:$id;//triple check

   //$id = 455; // force get specific power info

	$powername = array_search($id, $pow2[6][1]);
	if(!$powername) $powername = "Unknown";
	$isGroup = $isEpic = $isGame = $isAllP = false;
	$status = getStatus($pow2[0][1], $id);
	$smilies = getSmilies($pow2, $id);
	$pawns = getPawns($pow2, $id);
	$hugs = array();
	foreach($pow2[3][1] as $name => $hid) if($hid % 10000 == $id) $hugs[] = $name;//add hugs
	$price = "Unknown";
	$d1 = isset($powers[$id]) && isset($powers[$id]['d1']) ? $powers[$id]['d1']:"";//short description
	$d2 = isset($powers[$id]) && isset($powers[$id]['d2']) ? $powers[$id]['d2']:"";//long description
	if(isset($powers[$id])) {
		$powername = $powers[$id]['s']; //updates powername
		if((isset($powers[$id]['x']) || isset($powers[$id]['d']))) {
			$price = isset($powers[$id]['x']) ? "{$powers[$id]['x']} xats" : "{$powers[$id]['d']} days";
		}
		
		$status = isset($powers[$id]['r']) && $powers[$id]['r'] > 0 ? "LIMITED":$status; //more then 1 available aka theres a limit to the amount which makes it limited
		$status = isset($powers[$id]['f']) && $powers[$id]['f'] & 0x2000 ? "LIMITED":$status; // checks for limited flag
		$status = isset($powers[$id]['d2']) && strpos($powers[$id]['d2'], "LIMITED") !== false ? "LIMITED":$status; // checks if long description contains "LIMITED"
		$isEpic = isset($powers[$id]['f']) && $powers[$id]['f'] & 0x8 ? true:false; // if power is Epic
		$isGame = isset($powers[$id]['f']) && $powers[$id]['f'] & 0x80 ? true:false; // if power is a Game
		$isGroup = isset($powers[$id]['f']) && $powers[$id]['f'] & 0x800 ? true:false; // if power is a Group power
		$isAllP = isset($powers[$id]['f']) && $powers[$id]['f'] & 0x401 ? true:false; // if power is required for (allpowers)
	}

	echo "<center><b>Name: </b><b><font color='ff0000'>{$powername}</font></b> | <b>ID :</b> {$id} | <b>Status :</b> {$status} | <b>Price :</b> {$price}<br><br>";
	
	echo "<table class=\"table table-bordered\"><tbody>";
	
	echo "<tr><td><center><b>Power</b></center></td>";
	if(count($pawns) > 0)
		echo "<td colspan=\"" . count($pawns) . "\"><center><b>Pawns</b></center></td>";
	echo "</tr>";
	
	echo "<tr><td><center>".getStrip($powername)."</center></td>";
	if(count($pawns) > 0) {
		foreach($pawns as $pn => $pawn)
			echo "<td><center>".getStrip("p1".$pn)."</center></td>";					
	}
	echo "</tr>";
	
	echo "<tr><td><center><b>({$powername})</b></center></td>";
	if(count($pawns) > 0) {
		foreach($pawns as $pn => $pawn)			
			echo "<td><center><b>(hat#h{$pawn})</b></center></td>";		
		echo "</tr>";
	}
	echo "</tbody></table>";
	
	if(count($smilies) > 0) {
		echo "<p><b title=\"There are " . count($smilies) . " smilies\">Smilies:</b></p>";

		echo "<table class=\"table table-bordered\"><tbody><tr>";	
		
		if(count($smilies) > 12)
			echo "<style type=\"text/css\">.max {width: 900px; max-width: 900px; overflow-x:scroll;}</style>";
		echo "<div class=\"max\">";
		
		foreach(array_chunk($smilies, 4) as $i => $s_chunk) {
			foreach($s_chunk as $v)                                                                                            
				echo "<td><center>".getStrip($v)."</center></td>";
			echo "</tr><tr>";
			foreach($s_chunk as $v)                                                                                            
				echo "<td><b><center>(".$v.")</b></center></td>";
			echo "</tr><tr>";
		}
		echo "</div></tr>";

		echo "</tr></tbody></table>";
	}

	echo "</center>";

	function getJson($url, $true = true) {
		$json = file_get_contents($url);
		return json_decode($json, $true);	
	}	
	
	function getStatus($last, $id) {
		if($last['id'] != $id) //if id not in latest then unreleased
			return "UNRELEASED";
		else if(strpos($last['text'], "LIMITED") !== false) // if latested contains limited then its limited
			return "LIMITED";
		return "UNLIMITED"; //else we assume its unlimited
	}
	
	function getPawns($pow2, $id, $true = false) {
		$hats = array();
		foreach($pow2[7][1] as $name => $value) {
			if($name != 'time' && $value[0] == $id) {
				if($true)
					$hats[] = $value[1];
				else
					$hats[substr($value[1],2)] = $name;
			}
		}
		return $hats;		
	}
	
	function getPawns2($pow2, $id) {
		$hats = new StdClass();
		foreach($pow2[7][1] as $name => $value)
			if($name != 'time' && $value[0] == $id)
				$hats->{$name} = $value;
		return json_encode($hats);		
	}
	
	function getSmilies($pow2, $id) {
		$powername = array_search($id, $pow2[6][1]);
		$smilie = array_merge(array($powername), array_keys($pow2[4][1], $id));
		$smilies = array();	
		foreach($smilie as $v)
			array_push($smilies, $v);
			
		return $smilies;
	}

	function getStrip($smilie) {
		$md = 'ani'.md5($smilie);
		$smilie = @explode("#", $smilie)[0];
		$smilie = "https://s1.xat.com/web_gear/chat/GetStrip5.php?c=s_{$smilie}%23_100.png";
		list($width, $height) = @getimagesize($smilie);
		if($width >= ($height * 2)) {
			$height = $height == 0 ? 1:$height;
			$duration = @ceil(ceil($width / $height) / 12);
			$duration = $duration == 0 ? 1:$duration;
			$keyframes = '@-webkit-keyframes '.$md.' {from{background-position:0px;} to{background-position:-'.$width.'px;}}@-moz-keyframes '.$md.' {from{background-position:0px;} to{background-position:-'.$width.'px;}}@-ms-keyframes '.$md.'{from{background-position:0px;} to{background-position:-'.$width.'px;}} @-o-keyframes '.$md.' {from{background-position: 0px;} to{background-position:-'.$width.'px;}} @keyframes '.$md.' {from{background-position: 0px;} to{background-position:-'.$width.'px;}}';
			$steps = @ceil($width / $height);
			$animation = '-webkit-animation: '.$md.' '.$duration.'s steps('.$steps.') infinite;-moz-animation: '.$md.' '.$duration.'s steps('.$steps.') infinite;-ms-animation: '.$md.' '.$duration.'s steps('.$steps.') infinite;-o-animation: '.$md.' '.$duration.'s steps('.$steps.') infinite;animation: '.$md.' '.$duration.'s steps('.$steps.') infinite;';
			return '<style>'.$keyframes.'</style><div style="background-image:url(\''.$smilie.'\');background-size:cover;position:relative;top:10px;height:'.($height / 3).'px;width:'.($height / 3).'px;margin:auto;'.$animation.'"></div>';
		} else return '<div style="background-image:url(\''.$smilie.'\');background-size:cover;position:relative;top:10px;height:50px;width:50px;margin:auto;"></div>';

		return $showavi;
	}
?>
	</div>
</div>