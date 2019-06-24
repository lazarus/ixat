<?php
	if(!isset($_GET['a'])) exit;
	
	$actions = array();
	//$dirh = opendir('./actions/');
	$dirh = "./actions/";
	
	$dh = opendir($dirh);
	while(false !== ($file = readdir($dh))) {
		if(substr($file, -3, 3) == 'txt')
		{
			$pages[substr($file, 0, -4)] = './actions/' . $file;
		}
	}
	
	/*for($dirh = opendir('./actions/'); $file !== false; $file = readdir($dirh))
	{
		if(substr($file, -3, 3) == 'txt')
		{
			$pages[substr($file, 0, -4)] = './actions/' . $file;
		}
	}*/
	
	closedir($dh);
	
	if(isset($pages[$_GET['a']])) require $pages[$_GET['a']];