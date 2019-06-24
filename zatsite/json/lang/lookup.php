<?php
error_reporting(E_ALL ^ (E_NOTICE|E_WARNING));

if($_SERVER["REQUEST_METHOD"] !== "GET") exit;

$lang = $_GET['l']; // French
$file = rangetrim($_GET['p'],'^a-zA-Z0-9',40); // Game1

unset($_GET['l']);
unset($_GET['p']);
if(!empty($_GET)) exit;
header("Cache-Control: max-age=60,public");

require_once('WikiLang.php');

$lang = $Lang_names[strtolower($lang)];
if(empty($lang)) $lang = 'en';
$Lang_def_file = $page;

LangFetch('en', $file);
if($lang && $lang !== 'en')
{
	LangFetch($lang, $file);
	if(!empty($Langs_strings[$lang][$file]))
		foreach($Langs_strings[$lang][$file] as $k => $v)
			if($v)
				$Langs_strings['en'][$file][$k] = $v;	
}
echo json_encode($Langs_strings['en'][$file]);

function rangetrim($s, $nok, $maxlen)
{
	$s = trim($s);
	$s = preg_replace("/[$nok]/i", '', $s); 
	if(strlen($s) > ($maxlen))
		$s = substr ($s, 0, $maxlen);
	return $s;
}
?>
