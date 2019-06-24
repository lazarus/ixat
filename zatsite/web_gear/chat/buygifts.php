<?php
define("IP", "205.185.125.44");
define("PORT", "337");
//testing
//b=5&p=&s=Test&t=0&w=Techy%20%2810%29%20has%20bought%20Austin%20%285%29%20%20a%20gift&m=Test2&u=10&f=1&c=100&g=Trade&r=1
/********************
<a
k="giftName"
u="from"
if(the user you are sending the packet at == $to)
	c="updated xats"
b="to"
/>
********************/
/*
b=6 //receiving id (in this case Lawliet)
p=pass (password)
s=front (front message)
t=0 (dont know) _local_6.t = todo.w_dt; (austin thinks it is login time)
w=Austin (5) has bought LawLiet (6)  a gift (message that sends to chat)
m=message (gift inside message)
u=5 (sender id)
f=1 (dont know)
_local_6.f = 1;
if (Private.xitem.tick.visible){
     _local_6.f = (_local_6.f & ~(1));
};
c=100 (cost)
g=easter6 (gift name)
r=1 (room id)
http://ixat.io/web_gear/chat/buygifts.php + url encode those
*/
if(count(array_filter($_REQUEST, 'is_string')) == count($_REQUEST) && count($_REQUEST) == 11) {
	require str_replace('\\', '\\\\', "../../_class/") . 'pdo.php';

	$pdo = new Database();
	if(!$pdo->conn) die("System problem(1). Please try later.");
	
	//define shit
	$to = intval($_REQUEST['b']);
	$pass = $_REQUEST['p'];
	$front = $_REQUEST['s'];
	$logintime = intval($_REQUEST['t']); //don't need this i assume
	$chatmsg = $_REQUEST['w'];
	$message = $_REQUEST['m'];
	$from = $_REQUEST['u'];
	$flags = intval($_REQUEST['f']);
	$cost = intval($_REQUEST['c']);
	$giftName = $_REQUEST['g'];
	$roomId = intval($_REQUEST['r']);
	
	if($to == 0 || $from == 0) die("Invalid ID."); 
	if($to == $from) die("No friends?.");
	if($cost/50 < 1) die("Invalid cost.");
	if(empty($giftName)) die("Invalid gift.");
	
	$user = $pdo->fetch_array("select `password`,`xats`,`username` from `users` where `id`=:uid;", array("uid" => $from));
	if(empty($user) || !$pdo->validate($pass, $user[0]['password'])) die("Invalid password.");//check if it is indeed the sender
	if($user[0]['xats'] < $cost) die("Not enough xats");
	$receiver = $pdo->fetch_array("select `id`, `d0` from `users` where `id`=:uid;", array("uid" => $to));
	if(empty($receiver)) die("Cannot send gift to a non-existant user, idiot.");
	if($to == $from) die("No friends?.");
	if($cost/50 < 1) die("Invalid cost.");
	if(empty($giftName)) die("Invalid gift.");
	if($cost > 50) $flags |= 4;
	
	if(in_array($from, array(-3,1,4,5,10)) && $giftName === "PurplePawn") $giftName = "BlackPawn";	
	
	$gift = $pdo->insert("gifts",
		array(
			'gid' => null,
			'id' => $from,
			'b' => $to,
			'n' => $user[0]['username'],
			'g' => $giftName,
			'm' => $message,
			's' => $front,
			'f' => $flags,
			'time' => time(),
		)
	);
	//update users xats
	$pdo->query('update `users` set `xat`=:new where `id`=:uid;', array('new' => intval($user[0]['xats']) - $cost, 'uid' => $from));
	
	///Update receivers d0
	$d0 = $receiver[0]['d0'];
	$d0 |= 1 << 24;
	if($receiver[0]['d0'] & 1 << 21)
		$d0 |= 1 << 21;
	$pdo->query('update `users` set `d0`=:d0 where `id`=:uid;', array('d0' => $d0, 'uid' => $receiver[0]['id']));
	
	//Send to server
	$sock = fsockopen(IP, PORT, $e, $e, 1);
	$key = sha1(base64_encode("Gifts{$to}{$from}{$chatmsg}"));
    fwrite($sock, "<h d=\"{$to}\" u=\"{$from}\" c=\"{$roomId}\" f=\"{$flags}\" key=\"{$key}\" k=\"Gifts\" w=\"{$chatmsg}\" />" . chr(0));
	fclose($sock);
	die("OK");//send back to client
}
die("Nope2!");
?>
