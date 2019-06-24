<?php

// for release "build" return emtpy string
function Dbg($str) {
    //return "Error in query: $str" ;
    return '';
}

// flag bits
$f_voteoften = 1;
$f_portrait = 2;
$f_fullcode = 4;
$f_advanced = 8; // display advanced options
$f_facebook = 16;

$MaxAns = 12;

$hostname_poll = "localhost";  // host
$database_poll = "web_gear";    //database name
$username_poll = "web_gear";
$password_poll = "aswqkifer";


$xatpoll = mysql_connect($hostname_poll, $username_poll, $password_poll) or trigger_error(mysql_error(),E_USER_ERROR); 
mysql_select_db($database_poll);
?>