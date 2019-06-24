<?php
function Code() 
{
	$src = "auth.swf";
	$content = file_get_contents($src);
	$header = substr($content, 0, 8);
	$content = gzuncompress(substr($content, 8));
	$content = rep("xxxxxxxxxxxxxxxxx", 363563456,$content);
	$content = $header.gzcompress($content);  
	$fp=fopen("auth2.swf","wb");
	$result=fwrite($fp,$content);
	fclose($fp);
	return $content;
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

echo Code();
?>