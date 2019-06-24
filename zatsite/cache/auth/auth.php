<?php
if(!isset($cache))
{
	die();
}

class init 
{
	function __construct() 
	{
		$auth = new Auth();
		$auth->printAuth();
	}
}

class Auth 
{
	function __construct()
	{
		$this->createAuth();
	}

	function createAuth() 
	{
		$unpack = unpack('N*', file_get_contents("php://input"));

		list($GLOBALS['k'], $GLOBALS['htype']) = array(
			(isset($unpack[1]) ? $unpack[1] : 0), $this->hashType(0)
		);

		if(isset($unpack) && count($unpack) == 5) 
		{
			$GLOBALS['ma'] = array((int)$unpack[2], (int)$unpack[3], (int)$unpack[4], (int)$unpack[5]);
		} 
		else
		{
			$GLOBALS['ma'] = array(128, 64, 256, 2);
		}
	}

	function printAuth()
	{
		print "t={$this->get()}";
	}

	function get() 
	{
		$h = 0;
		/*
		foreach(str_split(hash($GLOBALS['htype'], (int)$GLOBALS['k'], false)) as $o)
		{
			$h += (((ord($o) * $GLOBALS['ma'][0]) + $GLOBALS['ma'][1]) * $GLOBALS['ma'][2]) * $GLOBALS['ma'][3];
		}
		*/

		foreach(str_split(sha1($GLOBALS['k'])) as $o)
		{
			$h += (((ord($o) * $GLOBALS['ma'][0]) + $GLOBALS['ma'][1]) * $GLOBALS['ma'][2]) * $GLOBALS['ma'][3];
		}

		return $h;
	}

	function Code($code = 100000) 
	{
		$content = file_get_contents("auth.swf");
		$header = substr($content, 0, 8);
		$content = gzuncompress(substr($content, 8));
		$content = $this->rep("xxxxxxxxxxxxxxxxx", $code, $content);
		$content = $header.gzcompress($content);  
		$this->header($content);

		echo $content;
	}  

	function rep($r, $code, $content)
	{
		$ro = $r;

		foreach(str_split($code) as $i=>$o)
		{
			$r[$i] = $o;
		}
		
		return str_replace($ro, $r, $content);
	}

	function header($content)
	{
		header("Content-type: application/x-shockwave-flash");
		header('Content-length: ' . filesize($content));
		header('Content-disposition: inline; filename="' . urlencode("auth.php") . '"');
		// header("Content-Disposition:attachment;filename='" . $_GET['f'] . "'");
		header('ETag: ' . md5($_GET['f']));
		header('Expires: ' . date('r', time() + 864000));
	}

	function hashType($n = 0)
	{
		switch((int)$n)
		{
			case 0:
				return 'sha1';
			break;
			case 1:
				return 'whirlpool';
			break;
			case 2:
				return 'sha512';
			break;
			case 3:
				return 'sha256';
			break;
			case 4:
				return 'gost';
			break;
			case 5:
				return 'snefru';
			break;
		}
		
		return 'whirlpool';
	}
}

$init = new init();
?>