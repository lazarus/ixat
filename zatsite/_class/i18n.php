<?php
class i18n
{
	private static $strings = array();
    private static $lang = "en";
	
	public static function setLang($lang)
	{
		self::$lang = $lang;
        self::parseLanguageFile('i18n/' . $lang . '.lng');
	}	
    
	public static function loadStr($index, $content)
	{
		$array = explode('.', $index);
		$merge = $content;
		
		for($i=0; $i<sizeof($array); $i++)
			$merge = array($array[sizeof($array) - 1 - $i] => $merge);
		
		$merge[self::$lang] = $merge;
		
		self::$strings = array_merge_recursive(self::$strings, $merge);
	}
	
	public static function parseLanguageFile($file, $what=null)
	{
        $file = _root . '_class' . _sep . $file;
        if(!file_exists($file)) return "";
		$handler = fopen($file, 'r');

		while(!feof($handler))
		{
			$line = trim(fgets($handler));
			
			// Empty line
			if(empty($line))
				continue;
			
			// Comments
			if($line[0] == '#')
				continue;
			
			// var_dump(trim($line));
			
			$pos = strpos($line, ' ');
			if($pos === false)
				continue;
			
			if(substr($line, 0, strlen($what)) != $what)
				continue;
			
			$var = trim(substr($line, 0, $pos));
			$val = trim(substr($line, $pos + 1));

			self::loadStr($var, $val);			
		}
		fclose($handler);
	}
	/*
	private static function unloadRec($array, $rem)
	{
		if(empty($rem))       return;
		if(!is_array($array)) return;

		$rem   = array_reverse($rem);
		$index = array_pop($rem);
		$rem   = array_reverse($rem);
		
		$ret   = array();
		
		foreach($array as $key => $var)
		{
			if($key != $index)
				$ret[$key] = $var;
			else
				$ret[$key] = self::unloadRec($array[$key], $rem);
			
			if(empty($ret[$key]))
				unset($ret[$key]);
		}
		
		return $ret;
	}
	
	public static function unload($what)
	{
		self::$strings = self::unloadRec(self::$strings, explode('.', $what));
	}
	*/
	public static function get($what)
	{
        $args = func_get_args();
		array_shift($args);
        
		$tmp = self::$strings[self::$lang];
		$what = explode('.', $what);
		$search = array();
		$replace = array();
		
		for($i=0; $i<sizeof($what); $i++)
		{
			if(!isset($tmp[$what[$i]]))
				return null;
			
			$tmp = $tmp[$what[$i]];
		}
		
		foreach($args as $index => $value)
		{
			$search[] = "{" . $index . "}";
			$replace[] = $value;
			unset($args[$index]);
		}
		
		return is_string($tmp) ? str_replace($search, $replace, $tmp) : null;
	}
}