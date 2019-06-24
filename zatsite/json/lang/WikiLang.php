<?php
// helper routines for Wiki lang system

$Langs_supported = array('ro'=>1, 'es'=>1, 'pt'=>1, 'fr'=>1, 'it'=>1, 'tr'=>1, 'th'=>1, 'fl'=>1, 'al'=>1, 'de'=>1);
$Lang_names = array('romainian'=>'ro', 'spanish'=>'es', 'portugese'=>'pt', 'french'=>'fr', 'italian'=>'it', 'turkish'=>'tr', 'thai'=>'th', 'filipino'=>'fl', 'albanian'=>'al', 'german'=>'de'); // , ''=>''


function Lang($n, $file='')
{
	// translate string
	global $lang, $Langs_done, $Langs_strings, $Strings, $Langs_supported, $Lang_def_file;
 
	$use_lang = $lang;
	if(!$file) $file = $Lang_def_file; // eg Social
 
	if(!$Langs_supported[$use_lang]) $use_lang = 'en';
 
	if(!is_array($Langs_strings[$use_lang][$file])) // grab this lang into memory
		LangFetch($use_lang, $file);
 
	$t = $Langs_strings[$use_lang][$file][$n]; 
	if(!$t && $use_lang !== 'en')
	{
		if(!is_array($Langs_strings['en'][$file])) // grab this lang into memory
		LangFetch('en', $file);
  
		$t = $Langs_strings['en'][$file][$n]; 
	}
	return $t;
}

function LangFetch($l, $file) // eg es, Social 
{
	global $Langs_strings;
 
	if(!is_array($Langs_strings)) $Langs_strings = array();
	if(!is_array($Langs_strings[$l])) $Langs_strings[$l] = array();
 
	$Langs_strings[$l][$file] = array();
	$t = file_get_contents("$l/$file.php");
	$t = explode('?>', $t);
	$t = json_decode($t[1], true);
	foreach($t as $k => $v)
		$Langs_strings[$l][$file][$k] = $v;
}

?>