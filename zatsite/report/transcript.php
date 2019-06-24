<?php
//header("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1
//header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); // Date in the past
//include('../web_gear/chat/connect.php');

require_once('/var/www/html/web_gear/chat/htmlhead.php');
$xp=array('ad'=>'top', 'title'=>'Chat transcript', 'cache'=>3600,  'forcedom'=>'web.xat.com', 'meta'=>array('xt'=>'chat')); // 

HtmlHead2();
?>
<h3><span data-localize=chat.transcript>Chat transcript</span></h3>
<div style="display:none">
<span data-localize=chat.youneed><p>You need to make sure that your moderators are doing a good job and are being fair 
		to your visitors. It only takes one bad mod to ruin a chat box. If your mods are good 
		your chat box will become more and more popular.</p>
		<p>Please review this unfair ban complaint and if you are not happy with it talk to 
		the moderator about your concerns or un-moderate them.</p></span>
<span data-localize=chat.banby>was banned by</span>
<span data-localize=chat.clkunmod>Click to Un-Moderate</span>
<span data-localize=chat.unfriendly><p>Note: Your group may be de-listed if you or your mods are unfriendly. 
		i.e. it won't appear on the group list or the popular list on xat or in the chat box.</p></span>
<span data-localize=chat.transno>Transcript does not exisit. It may have been deleted. They are kept for one week</span>
</div>
<?php
	$f = 'reports/' . $_REQUEST['i'].'.dat';
	$file = fopen($f, "r");
	if(!$file)
	{
		echo '<p>'."<span data-localize=chat.transno>Transcript does not exisit. It may have been deleted. They are kept for one week</span>".'.</p>';
	}
	else
	{
        $buffer = fgets($file);
    	fclose($file);
		$lines = explode(',,', $buffer);
		$args = explode(',', $lines[0]);
		$GroupId = intval($args[0]);
		$GroupName = $args[1];
		$UserId = intval($args[2]);
		$UserName = $args[3];
		$BannerId = intval($args[4]);
		$BannerName = $args[5];

		echo "<span data-localize=chat.youneed><p>You need to make sure that your moderators are doing a good job and are being fair 
		to your visitors. It only takes one bad mod to ruin a chat box. If your mods are good 
		your chat box will become more and more popular.</p>
		<p>Please review this unfair ban complaint and if you are not happy with it talk to 
		the moderator about your concerns or un-moderate them.</p></span>";
		echo "<p><b>$UserName</b> "."<span data-localize=chat.banby>was banned by</span>".": <b>$BannerName</b></p>".
			"<p>Below is a transcript  of messages leading up to the ban:</p>".
				'<table border="1">';
		echo "<tr><td><p>Name</p></td><td><p>Message</p></td></tr>\n" ;
		
		//echo "<tr><td colspan=2>$UserId $UserName</td></tr>\n";

		for($n=1; $n < sizeof($lines); $n++)
		{
			$args = explode(',', $lines[$n]);
			echo '<tr><td>';
			
			if(strlen($args[1]) > 32)
			{
				$args[1] = substr($args[1], 0, 32)." ".substr($args[1], 32, 32);
			}
			$Name = $args[1];
			
			$args[2] = str_replace("<inf7> ", "", $args[2]);
//echo $args[0]."#". $BannerId;
			$id = intval($args[0]);
			if($id == intval($BannerId))
			{ 
				$Name = '<a href="http://web.xat.com/report/unmod.php?u='.
					$args[0].'&n='.urlencode($args[1]).'&g='.$GroupId.'" title="<span data-localize=chat.clkunmod>Click to Un-Moderate</span>">'.
					$args[1].'</a>' ;
			}
			if($id == $UserId || $id == $BannerId)
			{
				$Name = "<b>$Name</b>" ;
				$args[2] = '<b>'.$args[2].'</b>' ;
			}

			echo $Name.'</td><td>'.$args[2]."</td></tr>\n" ;
	    }
		echo "<tr><td>Click link above to Un-Mod</td><td></td></tr>\n" ;
		echo "</table>\n";
		
		echo "<span data-localize=chat.unfriendly><p>Note: Your group may be de-listed if you or your mods are unfriendly. 
		i.e. it won't appear on the group list or the popular list on xat or in the chat box.</p></span>";
	}

EndHtml2();

function mytrim($s)
{
	$s = str_replace('<', ' ', $s);
	$s = str_replace('>', ' ', $s);
	return str_replace('"', '', trim($s));
}

function ErrHtml($s)
{
	return '<p style="color:#FF0000"><strong>**'. "$s**</strong></p> \n" ;
}

?>