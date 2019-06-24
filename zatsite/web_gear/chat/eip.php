<?php
 /*
 * Creator - Techy
 * Made for ixat.io source
 * In Chat Edit
 */
 
header('Content-type: text/html');

require str_replace('\\', '\\\\', "../../_class/") . 'pdo.php';

$pdo = new Database();

if(!$pdo->conn || !allset($_GET,'id','pw','md','back','fg','t'))
	die();

$id = intval($_GET['id']);
$background = $_GET['back'];
$password = intval($_GET['pw']);
$mode = intval($_GET['md']);

$chat = $pdo->fetch_array('SELECT * FROM `chats` WHERE `id`=:id', array('id' => $id));

if(empty($chat) || $password != crc32($chat[0]['pass']))
	die();

print "<chat>\n";
print isset($mode) && $mode == 2 ? "<back v=\"{$background}\" />\n":"";
print "<pw v=\"{$password}\" />\n";
print "<id v=\"{$id}\" />\n";
print "<oldback v=\"0\" />\n";
$backVars = explode(';=', $background);
if(isset($mode) && is_numeric($mode))
{
	switch($mode)
	{
		case 2:// Display Background
			print "<i0 v=\"{$backVars[0]}\" />\n";
			print "<w0 v=\"\" />\n";
			print "<h0 v=\"\" />\n";
			$bgArr = array(
				"balls","winter_holiday","stars","snowman","light","bauble","disco","flames","car",
				"hearts","fireworks","on_the_beach","matrix","lime_splash","spiderman2","rock1",
				"velvet","splash","drops_of_rain","rock2","pool","globe","circuit","cash",
				"gears","south_pacific","paper","metalglass","bliss_like","jigsaw"
			);
			for($i=0;$i<count($bgArr);$i++)
			{
				print "<i".($i+1)." v=\"{$bgArr[$i]}\" />\n";
			}
		break;
		case 4:// Change Background
			$pdo->query("UPDATE `chats` SET `bg`=:bg WHERE `id`=:id;", array('bg' => $backVars[0], 'id' => $id));
		break;
		case 8:// Display Groups
			$groups = $pdo->fetch_array("SELECT `id`,`name`,`desc` FROM `chats` WHERE `id`!={$id} ORDER BY `id` ASC LIMIT 33");
			print "<group>\n";
			for($i=0;$i<count($groups);$i++)
			{
				print "<g" . ($i + 1) . " n=\"{$groups[$i]['name']}\" r=\"{$groups[$i]['id']}\" d=\"{$groups[$i]['desc']}\" />\n";
			}
			print "</group>\n";
		break;
		case 16: //Change Attached Group
			$pdo->query("UPDATE `chats` SET `attached`=:attch WHERE `id`=:id;", array('attch' => $backVars[1], 'id' => $id));
		break;
		case 40:
			if(isset($_GET['s']))
			{
				$_GET['s'] = htmlentities($_GET['s']);
				print "<group>\n";
				$search = $pdo->fetch_array("SELECT `id`,`name`,`desc` FROM `chats` WHERE `id`!={$id} and `name` LIKE '%{$_GET['s']}%' LIMIT 33;");
				$groups = array();
				$left = 34 - count($search);
				if($left > 0)
				{
					$groups = $pdo->fetch_array("SELECT `id`,`name`,`desc` FROM `chats` WHERE `id`!={$id} ORDER BY `id` ASC LIMIT {$left}");
				}
				$list = array_merge($search,$groups);
				for($i=0;$i<count($list);$i++)
				{
					print "<g" . ($i) . " n=\"{$list[$i]['name']}\" r=\"{$list[$i]['id']}\" d=\"{$list[$i]['desc']}\" />\n";
				}
				print "</group>\n";				
			}
		break;
		default:
		break;
	}
}
print "</chat>\n";

function allset()
{ /* So I can cheat */
	$args  = func_get_args();
	$array = array_shift($args);
	foreach($args as $index)
	{
		if(!isset($array[$index]) || !is_string($array[$index]))
		{
			return false;
		}
	}
	return true;
}
?>