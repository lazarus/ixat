<?php
 /*
 * Creator - Techy
 * Made for ixat.io source
 */
error_reporting(0);

header("Content-Type: text/json");

require str_replace('\\', '\\\\', "../../_class/") . 'pdo.php';

$pdo = new Database();

if(!$pdo->conn) die();

$powers = $pdo->fetch_array('SELECT `id`, `name`, `topsh`, `group`, `limited`, `hugs`, `pawn` FROM `powers` WHERE `id` > 201 or `id` < 0 ORDER BY `id` ASC;');// just like xat nothing before 201
$server = $pdo->fetch_array('select `special_pawns`, `staff`, `vols` from `server` limit 0, 1;');

$pow2 = [
    ["last", ["id" => end($powers)['id'], "text" => end($powers)['limited'] == 1 ? '[LIMITED]':'[UNLIMITED]']],
    ["backs", [
        'b87' => 'kmback', 'b88' => 'tv80', 'b89' => 'zombieback', 'b90' => 'kheartb','b91' => 'kmoback', 'b92' => 'eggsleep','b93' => 'kfox','b94' => 'kcow','b95' => 'skback',
        'b96' => 'suback','b97' => 'germ','b98' => 'germ2','b99' => 'germ3','b100' => 'germ4','b101' => 'germ5','b102' => 'germ6','b103' => 'germ7','b104' => 'germ8','b105' => 'germ9','b106' => 'germ10',
        'b107' => 'cacback','b108' => 'cuback','b109' => 'fruties','b110' => 'frapple','b111' => 'frbanana','b112' => 'frgrapes','b113' => 'frkiwi','b114' => 'frlemon','b115' => 'frmelon',
        'b116' => 'frorange','b117' => 'frpear','b118' => 'frpineapple','b119' => 'frstrawberry','b120' => 'eggback','b121' => 'badge','b122' => 'cornback','b123' => 'sheepback','b124' => 'wmback',
        'b125' => 'ccback','b126' => 'springleaf','b127' => 'sunflower2','b128' => 'snailb','b129' => 'eventstats','b130' => 'bfb','b131' => 'sprback','b132' => 'hamsterback','b133' => 'chocolate',
        'b134' => 'kmoonback','b135' => 'ksunback','b136' => 'bonib','b137' => 'retflame','b138' => 'oiback','b139' => 'tvback','b140' => 'beastieb','b141' => 'beastieb3','b142' => 'beastieb5',
        'b143' => 'beastieb7','b144' => 'beastieb9','b145' => 'treeback','b146' => 'globeback','b147' => 'moback','b148' => 'aliback2','b149' => 'redback','b150' => 'cbback','b151' => 'cbfback',
        'b152' => 'vacmelt','b153' => 'microbe','b154' => 'micr1','b155' => 'micr2','b156' => 'micr3','b157' => 'micr4','b158' => 'micr5','b159' => 'micr6','b160' => 'micr7','b161' => 'micr8',
        'b162' => 'micr9','b163' => 'micr10','b164' => 'me','b165' => 'liback','b166' => 'reapback','b167' => 'kandback','b168' => 'roback','b169' => 'pback','b170' => 'kstback','b171' => 'rbback', 
        'b172' => 'colorback', 'b173' => 'pillarback', 'b174' => 'patrick', 'b175' => 'ebback', 'b176' => 'egghat', 'b177' => 'poopback', 'b178' => 'onback', 'b179' => 'gogreen', 'b180' => 'earthback', 
        'b181' => 'jinxback', 'b182' => 'toback', 'b183' => "kwback", 'b184' => 'popback', 'b185' => 'leafback', 'b186' => 'cback', 'b187' => 'boback', 'b188' => 'sparklefx', 'b189' => 'keback', 
        'b190' => 'flback', 'b191' => 'crback', 'b192' => 'bloback', 'b193' => 'bunback', 'b194' => 'rickback', 'b195' => 'kgback', 'b196' => 'mouback', 'b197' => 'rubyb', 'b198' => 'wishb',
        'b199' => 'toadback', 'b200' => 'acback', 'b201' => 'riback', 'b202' => 'hhback', 'b203' => 'kawaii', 'b204' => 'kwbacon', 'b205' => 'kwbowl', 'b206' => 'kwcookie', 'b207' => 'kwcup', 
        'b208' => 'kwcupcake', 'b209' => 'kwegg', 'b210' => 'kwjam', 'b211' => 'kwkettle', 'b212' => 'kwpopsicle', 'b213' => 'kwtoaster', 'b214' => 'egback', 'b215' => 'drback', 'b216' => 'fbback', 
        'b217' => 'gmback1', 'b218' => 'gmback2', 'b219' => 'mmback', 'b220' => 'cutiback', 'b221' => 'kbroccoli', 'b222' => 'kcarrot', 'b223' => 'keggplant', 'b224' => 'kleek', 'b225' => 'kmushroom', 
        'b226' => 'konion', 'b227' => 'kpepper', 'b228' => 'kpotato', 'b229' => 'ktomato', 'b230' => 'kturnip', 'b231' => 'kveggie', 'b232' => 'fireback', 'b233' => 'owlback', 'b234' => 'octoback', 
        'b235' => 'hsglowback', 'b236' => 'plant1', 'b237' => 'plant2', 'b238' => 'plant3', 'b239' => 'plant4', 'b240' => 'plant5', 'b241' => 'plant6', 'b242' => 'plant7', 'b243' => 'kxbaubleback', 
		'b244' => 'kxreindeerback', 'b245' => 'kxtreeback', 'b246' => 'sqback'
    ]],
    ["actions", [22 => 'tipsy,merry,drunk', 23 => 'party,2013,year,newyear']],	
    ["hugs", ['purp' => 35]],
    ["topsh", []],
    ["isgrp", []],
    ["pssa", []],
    ["pawns", json_decode($server[0]['special_pawns'])],
    ["nonmob", [
        0 => 256, 2 => 143165574, 3 => 1347769685, 4 => 290460132, 5 => 269549573, 6 => 1476411653, 7 => 885674017, 8 => 583016485, 
        9 => 1094715648, 10 => 8192, 1 => 402653200, 13 => 128, 12 => 69273, 11 => 2021834752
    ]],
    ["pawns2", [999 => [31, 'p1123']]],
    ["pawnids", ""],
    ["staff", json_decode($server[0]['staff'] == '' ? '[]' : $server[0]['staff'])],
    ["volunteers", array_values(json_decode($server[0]['vols'] == '' ? '[]' : $server[0]['vols'], true))]
];

$pawnids = [29, 30, 35, 64, 67, 144, 153, 172, 209];
foreach($powers as $power) {
	if(is_numeric(strpos(strtolower($power['name']), 'undefined'))) {
		continue;
    }

    if($power["id"] < 0) $power["id"] = 640 + abs($power["id"]);
    
    if (pow(2, ($power['id'] % 32)) > 1073741824) {
        continue;
    }
	
	$id = $power['id'];
	if ($power['topsh'] != '') {
		foreach (explode(',', $power['topsh']) as $top) {
			if ($power['name'] != $top) {
				$pow2[4][1]{$top} = (int) $power['id'];
            }
        }
    }

	if ($power['pawn']) {
        array_push($pawnids, (int)$power['id']);		
    }
	if ($power['group']) {
        $pow2[5][1]{$power['id']} = 1;
    }
	if (!empty($power['hugs'])) {
		$hugs = explode(',', $power['hugs']);
		for ($i=0; $i<count($hugs); $i++) {
			if ((substr($power['name'], -4, 4) == "jinx") && $i == 0) {
				$id += 100000;
            }
				
			$pow2[3][1]{$hugs[$i]} = (int) $i > 0 ? $id += 10000:$id;
		}
	}
	$pow2[6][1]{$power['name']} = (int) $power['id'];
}
$pow2[10][1] = json_decode(json_encode($pawnids == '' ? '[]' : $pawnids));

die(json_encode($pow2, JSON_NUMERIC_CHECK));
