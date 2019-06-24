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
		10 = SuperP
	*/	
    /* Pow2 Last status
        [Very Limited] = very hard to get
        [Limited] = not in store unless timed release
        Default "" = UNLIMITED
        [Boosted] = old power updated
		[COLLECTION] = Super power
    */
	$pow2 = getJson('http://xat.com/web_gear/chat/pow2.php?' . time());
	$powers = getJson('http://xat.com/json/powers.php?' . time());
	$id = end($pow2[6][1]) >= $pow2[0][1]['id'] ? end($pow2[6][1]):$pow2[0][1]['id']; //check for highest id
	$isGroup = $isEpic = $isGame = $isAllP = $isSuperP = false;
	$required = [];
	
	if (isset($pow2[11][$id]))
	{
		$smilies = explode(',', $pow2[11][$id]['s']);
		$powername = $smilies[0];
		unset($smilies[0]);
		$isSuperP = ['required' => explode(',', $pow2[11][$id]['n']), 'pawns' => explode(',', $pow2[11][$id]['p'])];
		$pawns = [];
	}
	else
	{
		$id = $id >= key($powers) ? $id:key($powers);//double check
		$id = count(array_keys($pow2[4][1], $id + 1)) > 0 ? $id + 1:$id;//triple check
		//$id = 485; // force get specific power info
		$powername = array_search($id, $pow2[6][1]);
		if(!$powername) $powername = "Unknown";
		$smilies = getSmilies($pow2, $id);
		$pawns = getPawns($pow2, $id);
	}
	
	$status = getStatus($pow2[0][1], $id);
	$hugs = [];
	foreach($pow2[3][1] as $name => $hid) if($hid % 10000 == $id) $hugs[] = $name;//add hugs
	$price = "Unknown";
	$d1 = isset($powers[$id]) && isset($powers[$id]['d1']) ? $powers[$id]['d1']:"";//short description
	$d2 = isset($powers[$id]) && isset($powers[$id]['d2']) ? $powers[$id]['d2']:"";//long description
	if(isset($powers[$id])) {
		$powername = $powers[$id]['s']; //updates powername
		if((isset($powers[$id]['x']) || isset($powers[$id]['d']))) {
			if(isset($_GET['admincp'])) {
				$price = $powers[$id]['x'] ?? floor(13 * $powers[$id]['d']);
			} else {
				$price = isset($powers[$id]['x']) ? "{$powers[$id]['x']} xats" : "{$powers[$id]['d']} days";
			}
		}
		
		$status = isset($powers[$id]['r']) && $powers[$id]['r'] > 0 ? "LIMITED":$status; //more then 1 available aka theres a limit to the amount which makes it limited
		$status = isset($powers[$id]['f']) && $powers[$id]['f'] & 0x2000 ? "LIMITED":$status; // checks for limited flag
		$status = isset($powers[$id]['d2']) && strpos($powers[$id]['d2'], "LIMITED") !== false ? "LIMITED":$status; // checks if long description contains "LIMITED"
		$isEpic = isset($powers[$id]['f']) && $powers[$id]['f'] & 0x8 ? true:false; // if power is Epic
		$isGame = isset($powers[$id]['f']) && $powers[$id]['f'] & 0x80 ? true:false; // if power is a Game
		$isGroup = isset($powers[$id]['f']) && $powers[$id]['f'] & 0x800 ? true:false; // if power is a Group power
		$isAllP = isset($powers[$id]['f']) && $powers[$id]['f'] & 0x401 ? true:false; // if power is required for (allpowers)
	}
	
	if(isset($_GET['json'])) {
		$json = new stdClass();
		$json->price = $price;
		$json->id = $id;
		$json->name = $powername;
		$json->status = $status;
		$json->smilies = $smilies;
		$json->pawns = $pawns;
		$json->d1 = $d1;
		$json->d2 = $d2;
		die(json_encode($json));
	} else if (isset($_GET['admincp'])) {
		$json = new stdClass();
        $json->id = $id;
		$json->price = $price;
		$json->name = $powername;
		$json->status = $status;
		$json->smilies = implode(',', $smilies);
		$json->pawns = implode(',', getPawns($pow2, $id, true));
		$json->pawns2 = getPawns2($pow2, $id);
		$json->d1 = $d1;
		$json->d2 = $d2;
		$json->isgrp = $isGroup;
		$json->isepic = $isEpic;
		$json->isgame = $isGame;
		$json->isallp = $isAllP;
		$json->issuperp = $isSuperP;
		$json->hugs = implode(',', $hugs);
		die(json_encode($json, JSON_PRETTY_PRINT));
	} else {	
		echo '<link rel="stylesheet" type="text/css" href="custom.css">';
		echo "<center><b>Name: </b><b><font color='ff0000'>{$powername}</font></b> | <b>ID :</b> {$id} | <b>Status :</b> {$status} | <b>Price :</b> {$price}<br><br>";
		
		echo "<table class=\"table table-striped table-bordered table-hover table-condensed\"><tbody>";
		
		echo "<tr><td><center><b>Power</b></center></td>";
		if(count($pawns > 0))
			echo "<td colspan=\"" . count($pawns) . "\"><center><b>Pawns</b></center></td>";
		echo "</tr>";
		
		echo "<tr><td><center><embed src='http://xat.com/images/sm2/{$powername}.swf?r=2&".time()."' wmode=\"transparent\" style='width: 60px; height: 60px;'></center></td>";
		if(count($pawns) > 0) {
			foreach($pawns as $pn => $pawn)
				echo "<td><center><embed src='http://xat.com/images/sm2/p1{$pn}.swf?r=2&".time()."' wmode=\"transparent\" style='width: 60px; height: 60px;'></center></td>";					
			echo "</tr>";
		}
		
		echo "<tr><td><center><b>({$powername})</b></center></td>";
		if(count($pawns) > 0) {
			foreach($pawns as $pn => $pawn)			
				echo "<td><center><b>(hat#h{$pawn})</b></center></td>";		
			echo "</tr>";
		}
		echo "</tbody></table>";
		
		if(count($smilies) > 0) {
			echo "<table class=\"table table-striped table-bordered table-hover table-condensed\"><tbody>";
				
			echo "<p><b title=\"There are " . count($smilies) . " smilies\">Smilies:</b></p>";
			
			if(count($smilies) > 12)
				echo "<style type=\"text/css\">.max {width: 900px; max-width: 900px; overflow-x:scroll;}</style><div class=\"max\">";
			
			foreach($smilies as $v)                                                                                            
				echo "<td><center><embed src='http://xat.com/images/sm2/".$v.".swf?r=2&".time()."' wmode=\"transparent\" style='width: 60px; height: 60px;'></center></td>";
				
			echo "</tr><tr>";
			
			foreach($smilies as $v)                                                                 
				echo "<td><b><center><a href='http://xat.com/images/sm2/".$v.".swf?r=2&".time()."'>(".$v.")</a></b></center></td>";
				
			echo "</tr></tbody></table></div>";
		}

		echo "</div>";
	}
	function getJson($url, $true = true) {
		$json = file_get_contents($url);
		return json_decode($json, $true);	
	}	
	
	function getStatus($last, $id) {
		if($last['id'] != $id) 
		{ //if id not in latest then unreleased
			return "UNRELEASED";
		}
		
		if($last['text'] == '[LIMITED]' || $last['text'] == '[COLLECTION]') 
		{// if latested contains limited then its limited
				return str_replace(['[', ']'], '', $last['text']);
		}

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
?>