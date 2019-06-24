<?php
	$pow2 = getJson('http://ixat.io/web_gear/chat/pow2.php');
	$id = end($pow2[6][1]);
	$name = array_search($id, $pow2[6][1]);
	$smilies = getSmilies($pow2);
	$pawns = getPawns($pow2);
	
	if(isset($_GET['json']))
	{
		$json = new stdClass();
		
		$powers = getJson('http://xat.com/json/powers.php');
		if(isset($powers[$id]))
		{
			if(isset($powers[$id]['x']) or isset($powers[$id]['d']))
			{
				$json->price = $powers[$id]['x'] ?? round($powers[$id]['d'] * 13.5);
			}
		}
		
		$json->id = $id;
		$json->name = $powername;
		$json->status = $status;
		$json->smilies = $smilies;
		$json->pawns = $pawns;
		die(json_encode($json));
	}
	else
	{	
		echo('<link rel="stylesheet" type="text/css" href="custom.css">');
		
		echo "<center><b>Name: </b><b><font color='ff0000'>".$name."</font></b> | <b>ID :</b> ".$id."<br><br>";
		
		echo "<table class=\"table table-striped table-bordered table-hover table-condensed\"><tbody>";
		//Power
		echo "<tr>
				<td><center><b>Power</b></center></td>
				<td colspan=\"" . count($pawns) . "\"><center><b>Pawns</b></center></td>
			</tr>";
			
		echo "<tr><td><center><embed src='//ixat.io/web_gear/flash/smiliesshow.swf' flashvars='r=".$name."' wmode=\"transparent\" style='width: 60px; height: 60px;'></center></td>";
		foreach($pawns as $pn => $pawn)
			echo "<td><center><embed src='//ixat.io/web_gear/flash/smiliesshow.swf' flashvars='r=p1".$pn."' wmode=\"transparent\" style='width: 60px; height: 60px;'></center></td>";					
		echo "</tr>";
		
		echo "<tr><td><center><b>(".$name.")</b></center></td>";
		foreach($pawns as $pn => $pawn)			
			echo "<td><center><b>(hat#h".$pawn.")</b></center></td>";		
		echo "</tr>";
		
		echo "</tbody></table>";
		
		//Smilies
		echo "<p><b title=\"There is " . count($smilies) . " smilies\">Smilies:</b></p>";
		
		if(count($smilies) > 12)
			echo "<style type=\"text/css\">.max {width: 900px; max-width: 900px; overflow-x:scroll;}</style><div class=\"max\">";
		
		echo "<table class=\"table table-striped table-bordered table-hover table-condensed\"><tbody>";
		echo "<tr>";
		foreach($smilies as $v)                                                                                            
			echo "<td><center><embed src='//ixat.io/web_gear/flash/smiliesshow.swf' flashvars='r=".$v."' wmode=\"transparent\" style='width: 60px; height: 60px;'></center></td>";
			
		echo "</tr><tr>";
		
		foreach($smilies as $v)                                                                 
			echo "<td><b><center><a href='//ixat.io/web_gear/flash/smiliesshow.swf?r=".$v."'>(".$v.")</a></b></center></td>";
			
		echo "</tr></tbody></table></div>";
		
		echo "<br/><br/><br/>";

	}
	function getJson($url, $true = true)
	{
		$json = file_get_contents($url);
		return json_decode($json, $true);	
	}	
	
	function getPawns($pow2)
	{
		$hats = array();
		foreach($pow2[7][1] as $code => $value)
			if($code != 'time' && $value[0] == end($pow2[6][1]))
				$hats[substr($value[1],2)] = $code;

		return $hats;		
	}
	
	function getSmilies($pow2)
	{
		$name = array_search(end($pow2[6][1]), $pow2[4][1]);
		$list = array_keys($pow2[4][1], end($pow2[6][1]));
		$list = in_array($name, $list) ? $list:array_merge(array($name), $list);
		$smilies = array();	
		foreach($list as $v)
			array_push($smilies, $v);
			
		return $smilies;
	}	
?>