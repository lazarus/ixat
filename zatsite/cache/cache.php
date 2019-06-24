<?php
set_time_limit(5);
error_reporting(0);
$cache = true;
$mimes = array(
	'css' => 'text/css',
	'js'  => 'text/javascript',
	'html' => 'text/html',
	'png' => 'image/png',
	'jpg' => 'image/jpeg',
	'gif' => 'image/gif',
	'svg'  => 'image/svg+xml',
	'ico'  => 'image/x-icon',
	'swf'  => 'application/x-shockwave-flash',
	'woff' => 'application/font-woff',
	'woff2' => 'application/font-woff2',
	'ttf'  => 'application/font-ttf',
	'eot'  => 'application/vnd.ms-fontobject',
);

try
{
	$cd = getcwd() . '/';

	if(!isset($_GET['f']) || !isset($_SERVER['HTTP_REFERER']) || !isset($_SERVER['HTTP_USER_AGENT']))
	{
		header('HTTP/1.0 404 Not Found');
		throw new Exception('File Not Found');
	}

	$extLocation = strrpos($_GET['f'], '.');
	if($extLocation === false)
	{
		header('HTTP/1.0 404 Not Found');
		throw new Exception('File Not Found');
	}
	
	list($name, $ext) = array(substr($_GET['f'], 0, $extLocation), substr($_GET['f'], $extLocation + 1));
	if(strlen($name) == 0 || strlen($ext) == 0 || !ctype_alnum($ext))
	{
		header('HTTP/1.0 404 Not Found');
		throw new Exception('File Not Found');
	}
	
	$dir = $_GET['d'] ?? $ext;
	
	$dirs = array_filter(glob('*'), 'is_dir');
	if(!in_array($dir, $dirs))
	{
		header('HTTP/1.0 404 Not Found');
		throw new Exception('File Not Found');
	}
	
	chdir($dir);
	
	$files = glob('*');
	if(!in_array($_GET['f'], $files))
	{
		header('HTTP/1.0 404 Not Found');
		throw new Exception('File Not Found');
	}
	$last_modified = filemtime($_GET['f']);

	if(isset($_SERVER['HTTP_IF_MODIFIED_SINCE']) || isset($_SERVER['HTTP_IF_NONE_MATCH']))
	{
		if($_SERVER['HTTP_IF_MODIFIED_SINCE'] == gmdate('D, d M Y H:i:s \G\M\T', $last_modified))
		{
			header('HTTP/1.0 304 Not Modified');
			return;
		}
	}
	if(strrpos($_GET['f'], 'php')) {
		if(strrpos($_SERVER['HTTP_REFERER'], 'http://ixat.io/cache/cache.php') === false && strrpos($_SERVER['HTTP_REFERER'], 'https://ixat.io/cache/cache.php') === false)
		{
			header('HTTP/1.0 404 Not Found');
			throw new Exception('File Not Found');
		}
		include $_GET['f'];
	} 
	else
	{
		$expires = 60 * 60 * 24 * 10;//10 days
		header('Last-Modified: '.gmdate('D, d M Y H:i:s \G\M\T', $last_modified));
		header('Cache-Control: max-age='.$expires.', must-revalidate');
		
		
		header('Content-Type: ' . (isset($mimes[$ext]) ? $mimes[$ext] : 'Application/octet-stream'));
		header('Content-Length: ' . filesize($_GET['f']));
		header('Content-Disposition: inline; filename="' . urlencode($_GET['f']) . '"');
		// header("Content-Disposition:attachment;filename='" . $_GET['f'] . "'");
		header('ETag: ' . md5($_GET['f']));
		//header('Expires: ' . date('r', time() + 864000));
		header('Expires: '.gmdate('D, d M Y H:i:s \G\M\T', $last_modified + $expires));
		readfile($_GET['f']);	
	}
	
}
catch(Exception $e)
{
	print $e->getMessage();
	die();
}

exit;
?>
