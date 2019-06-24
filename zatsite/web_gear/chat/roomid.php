<?php
 /*
 * Creator - Austin
 * Made for ixat.io source
 */
error_reporting(0);

header("Content-Type: text/json");

require str_replace('\\', '\\\\', "../../_class/") . 'pdo.php';

$pdo = new Database();

if(!$pdo->conn) die();

$chat = $pdo->fetch_array("SELECT id, `desc`, name, bg, attached, langdef, radio, button, bot FROM chats WHERE name=:name OR id=:id", ["name" => $_GET["d"], "id" => $_GET["i"]]);

if(count($chat) < 1) die('-10-11{"id":"0","d":"#","g":"#","a":"#"}');

$chat = [
	"id"	=> $chat[0]["id"],
	"d"		=> $chat[0]["desc"],
	"g"		=> $chat[0]["name"],
	"a"		=> $chat[0]["bg"].";=".$chat[0]["attached"].";=;=".$chat[0]["langdef"].";=".$chat[0]["radio"].";=".$chat[0]["button"],
	"bot"	=> empty($chat[0]["bot"]) ? 0 : 854
];
if($chat["bot"] == 0) unset($chat["bot"]);

die(json_encode($chat));
/*
{"id":"181183105","d":"XAT BOTS that come with a FREE 4 day trial FEXBots - Futuristic Entities of Xat","g":"FEXBots","a":"http:\/\/i.imgur.com\/reTvjID.png;=PGO;=164014162;=English;=http:\/\/89.105.32.22:8110\/;;=#000000","bot":23232323}
*/
?>