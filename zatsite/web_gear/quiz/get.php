<?php 
header("Cache-Control: max-age=3600"); // HTTP/1.1
require_once('/home/admin/cgi-bin/xatdata.php');
//include('connect.php'); 

$MaxAns = 10;
// Read xml objects
$fh = fopen("quiz.xml", "r");
$n = 1;
$intro = '';
$question = '';
$end = '';

// Read quiz data

$id = intval($_GET['id']); // remove nasties 

$wgf = xatGet("webgear.quiz.$id.f");
$wgv = xatGet("webgear.quiz.$id.v");

if (is_array($wgf) && is_array($wgv)) 
{ 
	while(!feof($fh))
	{
    	$line = fgets($fh, 1024);
		// change border color
		if(substr($line, 0, 15) === '<m_BorderColor>')
			$line = "<m_BorderColor>". $wgf['height'] ."</m_BorderColor>"; // bung in color
		
		if($n == 1) $intro .= $line . "\n";
		if($n == 2) $question .= $line . "\n";
		if($n >= 3) $end .= $line . "\n";
		if(substr($line, 0, 14) === '</CPageObject>') $n++;
	}
	fclose($fh);

	$data = "<CQuiz>\n"; // add start
	$data .= "<CData>\n";
	limit($wgf['numq'], 2, $MaxAns); // safety
	for($n=0; $n<=$wgf['numq']; $n++)
		$data .= "<d$n>". intval($wgv["count$n"]) . "</d$n>\n" ; // num of right ans

	$data .= "</CData>\n";
	
	$intro = str_replace("<CQuiz>", $data, $intro); // stick at end of xml
	$intro = str_replace("(\\Backgrounds\\xat_beams.jpg", $wgf['background'], $intro);
	$intro = str_replace("Click to Enter Quiz Title", $wgf['descrip'], $intro);
	print $intro;

	$p = 9; // point at question 1 $wgf[""]
	for($n=1; $n<=$wgf['numq']; $n++)
	{
		$q = $question;
		$empty = trim($wgf["ques$n"]); // Save question
		$q = str_replace("Question0", $wgf["ques$n"], $q);
		$q = str_replace("Correct0", $wgf["ans{$n}_1"], $q);
		$q = str_replace("Wrong1", $wgf["ans{$n}_2"], $q);
		$q = str_replace("Wrong2", $wgf["ans{$n}_3"], $q);
		$q = str_replace("Wrong3", $wgf["ans{$n}_4"], $q);
		if($n == 1 || $empty != '')
			print $q; // Don't print blank questions unless first ...
	}
	
	print $end;
}

function limit(&$num, $low, $high)
{
    if ($num < $low) $num = $low;   
    if ($num > $high) $num = $high;   
}

