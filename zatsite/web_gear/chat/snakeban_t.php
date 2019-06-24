<?php
define("IP", "205.185.125.44");
define("PORT", "337");
header("Cache-Control: max-age=1,public");

$HeadWords = 8;
$RawPostData = file_get_contents("php://input");

if(!isset($RawPostData)) { return; }

$t = explode("ZZZZ", $RawPostData);

$len = strlen($RawPostData) >> 1;
$head = unpack("N{$HeadWords}", $RawPostData);
$data = unpack("n{$len}", $RawPostData);

$len = strlen($t[0]) >> 1;
$head = unpack("N{$HeadWords}", $t[0]);
$data = unpack("n{$len}", $t[0]);

list( , $version, $id, $roomid, $BanTime, $Power, $apples, $calories, $StartTime) = $head;

$Scramble = ($id ^ $BanTime ^ $StartTime) & 0xFFFF;

if($BanTime == 0) { exit("Invalid ban time"); }
if($StartTime > time()) { exit("invalid start time"); }

Verify($data, $HeadWords * 2 + 1);

exit("sorry");

function UnBanThem() {
	global $id, $roomid, $BanTime, $Power, $apples, $calories, $StartTime, $gx, $gy;

	if($BanTime == 0) { $TimeLeft = 100 * 3600; }
	elseif($BanTime == 1) { $TimeLeft = 1; }
	else { $TimeLeft = $BanTime - $StartTime; }

	$hours = max($TimeLeft/3600, 0.1);
	$hours = min($hours, 100);
	$calories2 = 6 - floor(6 * ($hours-1) / 100);
	$apples2 = floor(((0.05 * ($hours < 1.0 ? $hours : 1.0) + (0.002 * $hours)) * ($gx * $gy)) / $calories2);
	$apples2 = max($apples2, 1);
	$calories2 = min($calories2, 6);

	if($apples != $apples2 || $calories != $calories2) { return; }

	$ip = "205.185.125.44";
	$port = 337;

	$fp = @fsockopen(IP, PORT, $errno, $errstr, 3);
	if($fp){
		fwrite($fp, "<hu u=\"{$id}\" c=\"{$roomid}\" t=\"{$BanTime}\" s=\"{$StartTime}\" w=\"{$Power}\" />" . chr(0));
		fclose($fp);
		exit("unbanned_t");
	} else {
		exit("ERROR");
	}
}

class Point {
	public $x = 0, $y = 0;

	public function __construct() {
		$a = func_get_args();
		$i = func_num_args();
		if($i > 1) { $this->y = intval($a[1]); }
		if($i > 0) { $this->x = intval($a[0]); }
	}
}

function Verify($moves, $skip) {
	global $s, $dir, $foodc, $food, $calories, $apples, $gx, $gy;
	global $lfsr, $Scramble;

	$gx = 32;
	$gy = 24;
	$gs = 20;

	$State = 0;
	$s = array();
	$dir = 3;
	$odir = -1;
	$food = new Point();
	$foodc = 0;
	$movep = $skip;

	$tc = 0;
	$lfsr = $Scramble;

	$s[0] = new Point(intval($gx/2)-1, intval($gy/2)-1);
	$s[1] = new Point($s[0]->x+1, $s[0]->y);

	addfood();

	while(1) {
		if(($moves[$movep] >> 2) == $tc) {
			$dir = $moves[$movep] & 3;
			$movep++;
		}

		$res = calc();
		switch($res) {
			case 1: UnBanThem(); exit();
			case 2: UnBanThem(); exit();
			case 3: UnBanThem(); exit();
			default: break;
		}
		if($res==0) { $tc++; }
	}
}

function calc() {
	global $s, $dir, $foodc, $food, $calories, $apples, $gx, $gy;

	$v = new Point();

	switch($dir) {
		case 0: $v->x = 0; $v->y = -1; break;
		case 1: $v->x = 0; $v->y = 1; break;
		case 2: $v->x = -1; $v->y = 0; break;
		case 3: $v->x = 1; $v->y = 0; break;
	}

	if($foodc==0) { array_shift($s); }
	if($foodc>0) { $foodc--; }
	$l = count($s)-1;

	array_push($s, new Point($s[$l]->x + $v->x, $s[$l]->y + $v->y));
	$l = count($s)-1;

	if($food->x==$s[$l]->x && $food->y==$s[$l]->y) {
		$foodc += $calories;
		$food->x = $food->y = -1;
	}

	if($food->x == -1) { addfood(); }

	for($i = 0; $i < $l; $i++) { if($s[$i]->x == $s[$l]->x && $s[$i]->y == $s[$l]->y) { return 1; } }
	if($s[$l]->x < 0 || $s[$l]->x >= $gx || $s[$l]->y < 0 || $s[$l]->y >= $gy) { return 2; }
	if((count($s)-2) >= ($apples * $calories)) { return 3; }

	return 0;
}

function addfood() {
	global $food, $s, $gx, $gy;

	$food->x = prand($gx);
	$food->y = prand($gy);

	for($i = 0; $i < count($s)-1; $i++) { if($food->x == $s[$i]->x && $food->y == $s[$i]->y) { $food->x = $food->y = -1; } }
}

function prand($max) {
	global $lfsr;
	return intval((scramble($lfsr) * $max) / 65535);
}

function scramble($prev) {
	$sr = $prev & 0xFFFF;
	$bit = ((($sr >> 0) ^ ($sr >> 2) ^ ($sr >> 3) ^ ($sr >> 5) ) & 1) ^ 1;
	$sr = ($sr >> 1) | ($bit << 15);
	return ($sr & 0xFFFF) | ($prev & ~0xFFFF);
}
