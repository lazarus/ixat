<?php
 /*
 * Creator - Techy
 * Made for ixat.io source
 * Spaceban or 50136
 */
$array = unpack('N*', file_get_contents("php://input")); //input is packed
$time = $_SERVER['REQUEST_TIME'] ?? time();
define("IP", "205.185.125.44");
define("PORT", "337");

if(count($array) >= 7) //if theres no moves they didnt play #cheat
{
	if($array[6] > time()) die("Nope!");
	if($array[4] == 0) die("Forever snaked ;)");
	$dir = "../../_class/";
	$dir = str_replace('\\', '\\\\', $dir);
	require $dir . 'config.php';
	require $dir . 'pdo.php';

	$pdo = new Database($config->db[0], $config->db[1], $config->db[2], $config->db[3]);
	if(!$pdo->conn) die("Nope!");

	$ban = $pdo->fetch_array("select * from `bans` where `userid`=:uid and `chatid`=:rid and `special`=:gbid order by `unbandate` desc limit 0,1;", array('uid'=>$array[2], 'rid'=>$array[3], 'gbid'=>$array[5]));
	if(!empty($ban))
	{
		$duration = $time - $array[6];
		$key = sha1(base64_encode("{$array[5]}{$duration}{$ban[0]['hours']}"));
		$sock = fsockopen(IP, PORT, $e, $e, 1);
		fwrite($sock, "<gb w=\"{$array[5]}\" d=\"{$duration}\" h=\"{$ban[0]['hours']}\" u=\"{$array[2]}\" k=\"{$key}\" r=\"{$array[3]}\"/>" . chr(0));
		fclose($sock);
		die("Unbanned");
	}
}
die("Nope!");
?>