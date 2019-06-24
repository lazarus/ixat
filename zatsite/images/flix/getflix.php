<?php
error_reporting(0);
for($x = 0; $x <= 310; $x++)
{
	for($y = 1; $y <= 100; $y++)
	{
		$file = file_get_contents("http://www.xatech.com/images/flix/g{$x}_{$y}.swf?v=56");
		if($file == '') break;
		$output = fopen("g{$x}_{$y}.swf", "w") or die("Can't create file.");
		fwrite($output, $file);
		echo "Downloaded Flix: g{$x}_{$y}\n";
	}
}