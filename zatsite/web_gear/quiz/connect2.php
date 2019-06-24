<?php

// for release "build" return emtpy string
function Dbg($str) {
    return "Error in query: $str" ;
    return '';
}

// flag bits
//$f_voteoften = 1;
//$f_portrait = 2;
$f_fullcode = 4;

$MaxAns = 10;

$hostname_poll = "www1.ixat.io";  // host
$database_poll = "web_gear";    //database name
$username_poll = "rem";
$password_poll = "remuser101";

$xatpoll = mysql_connect($hostname_poll, $username_poll, $password_poll); 
if(!$xatpoll)
{
	header("Location: http://www.ixat.io/web_gear/maintenance.html");
	exit(0);
	//trigger_error(mysql_error(),E_USER_ERROR); 
};

mysql_select_db($database_poll);
?>