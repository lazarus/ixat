<?php
	error_reporting(E_ALL ^ (E_NOTICE|E_WARNING));
	header("Cache-Control: no-cache, must-revalidate");	
	
	$t = substr($_SERVER['HTTP_ACCEPT_LANGUAGE'], 0, 2);
	$t = preg_replace('/[^0-9a-z]/i', '', $t);

?>
[
{ "lang":"<?php echo $t; ?>"}
]