<?php
error_reporting(E_ALL ^ (E_NOTICE|E_WARNING));

if($_SERVER["REQUEST_METHOD"] !== "GET") exit;

$roomid = intval($_GET['r']);

unset($_GET['r']);
unset($_GET['t']);
if(!empty($_GET)) exit;
header("Cache-Control: max-age=60,public");

require_once('/home/admin/cgi-bin/xatdata.php');

$r = array();
if($roomid)
{
	$NoGoogDb = true; // dont read from goog db
	$a = xatGet("chatu.groups.$roomid.l");
	if(is_array($a))
	{
		unset($a['timestamp']);
		$r = &$a;
	}
}

$s = '';
ksort($r);
end($r);         // move the internal pointer to the end of the array
$last = key($r); 

for($n = -1; $n<=($last+1); $n++)
	if(!$r[$n]) $r[$n] = '';

$r[-1] = 1; // add flag that its custom lang to start

ksort($r);
	
echo implode(';=', $r);
?>
