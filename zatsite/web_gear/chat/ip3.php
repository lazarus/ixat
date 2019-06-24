<?php
 /*
 * Creator - Austin / Techy
 * Made for ixat.io source
 */
error_reporting(0);

header("Content-Type: text/json");

$allowed = ['a8d77e62ec07c289d9734d810647a441', '9ee1a4d8ae4c2bef23d2e48b4c6bb91a', '40aabcdace21e0903349191df31eb3c2', "3137f3185cd9e700d3ccf3edc9635816"];

$ip = !in_array(md5($_SERVER["REMOTE_ADDR"]), $allowed) ? "troll" : "198.251.80.169:337";
$domain = 'ixat.io';

$ip3 = new stdClass();
$ip3->S0 = [ 0, [$domain] ];
$ip3->order = [ ["E0", 60], ["E1", 90], ["E0", 180], ["E1", 240], ["S0", 240] ];
$ip3->xFlag = 2;
$ip3->time = time();
$ip3->T0 = [ 1, [""] ];
$ip3->E0 = [ 1, [$ip, $ip, $ip, $ip] ];
$ip3->E1 = [ 1, [$ip, $ip, $ip, $ip] ];
$ip3->k1n = 2000000000; // 0;
$ip3->k1d = 14;
/**
 * Start pow2
 **/
require str_replace('\\', '\\\\', "../../_class/") . 'pdo.php';

$pdo = new Database();

if(!$pdo->conn) die();

$powers = $pdo->fetch_array('SELECT `id`, `name`, `topsh`, `group`, `limited`, `hugs`, `pawn` FROM `powers` WHERE `id` > 201 or `id` < 0 ORDER BY `id` ASC;');// just like xat nothing before 201
$server = $pdo->fetch_array('select `special_pawns`, `staff`, `vols` from `server` limit 0, 1;');

$pow2 = [
    "last" => ["id" => end($powers)['id'], "text" => end($powers)['limited'] == 1 ? '[LIMITED]':'[UNLIMITED]'],
    "backs" => [
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
        'b190' => 'flback', 'b191' => 'crback', 'b192' => 'bloback', 'b193' => 'bunback', 'b194' => 'rickback', 'b195' => 'kgback', 'b196' => 'mouback', 'b197' => 'rubyb', 'b198' => 'wishb'
    ],
    "actions" => [22 => 'tipsy,merry,drunk', 23 => 'party,2013,year,newyear'],	
    "hugs" => ["purp" => 35],
    "topsh" => [],
    "isgrp" => [],
    "pssa" => [],
    "pawns" => json_decode($server[0]['special_pawns']),
    "pawns2" => "",
    "staff" => json_decode($server[0]['staff'] == '' ? '[]' : $server[0]['staff']),
    "volunteers" => json_decode($server[0]['vols'] == '' ? '[]' : $server[0]['vols'])
];

$pawns2 = [29, 30, 35, 64, 67, 144, 153, 172, 209];
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
				$pow2["topsh"][$top] = (int) $power['id'];
            }
        }
    }

	if ($power['pawn']) {
        array_push($pawns2, (int)$power['id']);		
    }
	if ($power['group']) {
        $pow2["isgrp"]{$power['id']} = 1;
    }
	if (!empty($power['hugs'])) {
		$hugs = explode(',', $power['hugs']);
		for ($i=0; $i<count($hugs); $i++) {
			if ((substr($power['name'], -4, 4) == "jinx") && $i == 0) {
				$id += 100000;
            }
				
			$pow2["hugs"]{$hugs[$i]} = (int) $i > 0 ? $id += 10000:$id;
		}
	}
	$pow2["pssa"]{$power['name']} = (int) $power['id'];
}
$pow2["pawns2"] = json_decode(json_encode($pawns2 == '' ? '[]' : $pawns2));

$ip3->pow2 = (object)$pow2;
/**
 * End pow2
 **/
/*
$ip3->pow2 = new stdClass();

$ip3->pow2->last = new stdClass();
$ip3->pow2->last->id = 0;
$ip3->pow2->last->text = "";

$ip3->pow2->backs = new stdClass();
$ip3->pow2->backs->b215 = "mmback";

$ip3->pow2->actions = new stdClass();
$ip3->pow2->actions->{'22'} = "tipsy,merry,drunk";
$ip3->pow2->actions->{'23'} = "party,2013,year,newyear";

$ip3->pow2->hugs = new stdClass();
$ip3->pow2->hugs->choir = 366;


$ip3->pow2->topsh = new stdClass();
$ip3->pow2->topsh->vbat = 202;

$ip3->pow2->isgrp = new stdClass();
$ip3->pow2->isgrp->{'252'} = 1;

$ip3->pow2->pssa = new stdClass();
$ip3->pow2->pssa->vampyre = 202;

$ip3->pow2->pawns = new stdClass();
$ip3->pow2->pawns->time = time();

$ip3->pow2->nonmob = new stdClass();
$ip3->pow2->pawns2 = new stdClass();
*/

die(json_encode($ip3/*, JSON_PRETTY_PRINT*/));

?>