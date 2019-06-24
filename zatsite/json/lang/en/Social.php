<?php
if($_SERVER["REQUEST_METHOD"] !== "GET") exit;
if(!empty($_GET)) exit;
header("Cache-Control: max-age=604800,public");
?>
{"1":"is hanging out at %s","2":"member","3":"moderator","4":"owner","5":"has been made %s at %s","6":"got marri\u00e9d to %s at %s","7":"got divorced from %s at %s","8":"got BFF to %s at %s","9":"Click to join me at %s","10":"gave %s the xat gift %s","11":"has just created xat group %s","12":"Click to create your own xat group","13":"%s has bought xat shortname %s","14":"Click to buy your own shortname","15":"has promoted xat group %s","16":"%s said %s"}