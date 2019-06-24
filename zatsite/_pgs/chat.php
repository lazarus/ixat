<?php
if(!isset($config->complete))
{
	return include $pages['setup'];
}

$cn = $core->cn;
if(!isset($chat))
{
	if(isset($_GET['id']))
	{
		$chat = $mysql->fetch_array('select * from `chats` where `id`=:chat;', array('chat' => $_GET['id']));
		if(!isset($chat[0]))
		{
			$chat = array();
			$chat[0] = array("name" => "lobby");
		}
	}
}
/* Redirect power test
if(!empty($chat[0]['redirect']))
{
	print '<script type="text/javascript">window.location=\'/'.$chat[0]['redirect'].'\';</script>';
	return;
}
*/
print "
	<style>
	body,td,th {
		font-family: Helvetica, Arial, sans-serif;
		color: #FFFFFF;
		margin-left: 0px;
		margin-top: 0px;
		margin-right: 0px;
		margin-bottom: 0px;
	}
	A:link {text-decoration: none; color:#FFFFFF}
	A:visited {text-decoration: none; color:#FFFFFF}
	A:hover {text-decoration: underline; color:#FFFFFF}
	A:active {text-decoration: none; color:#FFFFFF}
	.foot { FONT-SIZE: 0.9em;}
	H2
	{
		padding:0;
		line-height:14px;
		margin:0;
		font-size:14px;
		text-align:left;
		vertical-align:middle;
		margin-bottom:4px;
		margin-top:-1px;
	}
	H1
	{
		padding:0;
		line-height:51px;
		margin:0;
		text-align:left;
		vertical-align:bottom;
		font-size:40px;
		margin-bottom:-2px;
		font-weight:bold;
	}
";
print 'body {
	background-color = #000000;
';
if(!empty($chat[0]['outter']))
{
	$shutup = parse_url($chat[0]['outter']);
	if(!isset($shutup['scheme']) || $shutup['scheme'] != "http" || strpos($shutup['host'], ".") === false) 
	{
		//Nope fuck you
    }
	else
	{
		print '
			BACKGROUND-POSITION: Center;
			BACKGROUND-ATTACHMENT: fixed;
			BACKGROUND-IMAGE: url(' . htmlspecialchars($chat[0]['outter']) . ');
		';	
		//background:#202020 url(' . htmlspecialchars($chat[0]['outter']) . ') no-repeat top center fixed
	}
}
print '}';
print "</style>";
$debug = isset($_GET['debug']) ? "&debug":"";
//$swf = $debug == "&debug" ? "chat4":"chat2";
$swf = $debug == "&debug" ? "chat4":"chat";
$movie = $core->http . "://ixat.io/cache/cache.php?f={$swf}.swf&v=" . $core->getVersion() . "&d=flash{$debug}";

$chatlang = '';
if (strlen($chat[0]['langdef']) > 2  && $chat[0]['langdef'] !== 'English') $chatlang .= "&rl=" . $chat[0]['langdef'];

$group = $chat[0]["name"] != "" ? "&gn={$chat[0]["name"]}":"";
$flashVars = "id={$chat[0]["id"]}{$debug}{$group}{$chatlang}&xc=2336&cn={$core->cn}&gb=9U6Gr&lg={$core->lang}&v=" . $core->getVersion();
$adPosition = 0;
$gcontrol = $chat[0]['gcontrol'];
if($gcontrol != "{}" || !empty($gcontrol)) {
	$gcontrol = json_decode(str_replace("'", '"', $gcontrol), true);
	$adPosition = $gcontrol['ads'] ?? 0;
}
$adPosition = $adPosition == 0 ? rand(1, 2):$adPosition;
	
?>
<table background="" height="51" width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000" style="filter: alpha (opacity=90)">
	<tr>
		<td width="138" align="center" valign="top" rowspan="2">
			<a href="//ixat.io">
				<IMG border=0 height=49 alt="ixat - Get Connected..." src="//ixat.io/images/zatblk.png?a" width=138 longDesc=//ixat.io>
			</a>
		</td>
		<td height="49" width="2000" rowspan="2" valign="bottom">
			<h1>&nbsp;<?= $chat[0]['name']; ?></h1>
		</td>
	</tr>
</table>
<table width="100%" height="10" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000" style="filter: alpha (opacity=90)">
	<tr>
		<td width="70"></td>
		<td valign="top">
			<h2><?= $chat[0]['desc']; ?><span id="desc">&nbsp;</span></h2>
		</td>
	</tr>
</table>
<div style="height: 16px"></div>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="left" valign="top" width="2%" rowspan="1">
				<a href="//ixat.io/<?= $chat[0]['name']; ?>?p=0&ss=1" onclick="javascript:ClearControl();OpenGame(30004);return false">
					<img src="/images/tgrid.png" border="0" title="Grid of online users pictures"/>
				</a><BR>
				<div style="height:8px"></div>
				<a href="//ixat.io/<?= $chat[0]['name']; ?>?p=0&ss=4" onclick="javascript:ClearControl();OpenMedia(0);return false">
					<img src="/images/tplayer.png" border="0" title="Broadcast YouTube Videos"/>
				</a>
				<div style="height:8px"></div>
				<a href="//ixat.io/<?= $chat[0]['name']; ?>?p=0&ss=2" onclick="javascript:ClearControl();OpenDoodle();return false">
					<img src="/images/tdoodle.png" border="0" title="Draw pictures with your friends!"/>
				</a>
				<div style="height:8px"></div>
				<a href="//ixat.io/<?= $chat[0]['name']; ?>?p=0&ss=20034" onclick="javascript:ClearControl();OpenGame(20034);return false">
					<img src="/images/ttranslate.png" border="0" title="Automatic translation"/>
				</a><BR>
				<div style="height:8px"></div>
				<a href="//ixat.io/<?= $chat[0]['name']; ?>?p=0&ss=10002" onclick="javascript:ClearControl();OpenGame(10002);return false">
					<img src="/images/tgames.png" border="0" title="Play a game!"/>
				</a>
				<div style="height:8px"></div>
				<a href="//ixat.io/<?= $chat[0]['name']; ?>?p=0&ss=5" title="Lots more smilies" onclick="javascript:ClearControl();OpenSmilies();return false">
					<img src="/images/tsupercycle.png" border="0"/>
				</a>
				<div style="height:8px"></div>
				<a href="//ixat.io/<?= $chat[0]['name']; ?>?p=0&ss=0" title="Close..." onclick="javascript:ClearControl();ClearMedia();return false">
					<img src="/images/tclose.png" border="0" />
				</a>
				<div style="height:8px"></div>
			</td>
			<td align="left" valign="top" width="1%" rowspan="1">&nbsp;</td>
			<td align="center">
				<div id="media">

				</div>
				<div id="control">
				</div>
			</td>
			<td align="left" valign="top" width="0%">&nbsp;</td>
			<td align="center">
				<?php
					if($adPosition == 1)
					{
						print '
							<div onmousedown="//ixat.io/powers"><embed wmode="transparent" src="//ixat.io/images/ads/xatAd.swf?b9" quality="high" flashvars="" width="728" height="90" align="middle" allowscriptaccess="sameDomain" type="application/x-shockwave-flash" /></div>
							<div style="padding-top:24px"></div>
						';
					}
				?>
				<?php 
					if(isset($_REQUEST['x'])) {
						$image = @file_get_contents($chat[0]['bg']);
						if($image)
							print '<img src="'.$chat[0]['bg'].'" border="0" width="728" height="486">';
						else 
							print '<div>no image found</div>';
					} else if(isset($_GET['c']) && $core->user->isAdmin()) {
							//$_GET['c'] = "chat622d";
							print '<embed width="728" height="486" src="//ixat.io/testing/austin/' . $_GET['c'] . '.swf?'.time().'https://ixat.io/cache/cache.php" quality="high" wmode="transparent" bgcolor="#000000" FlashVars="'.$flashVars.'" align="middle" type="application/x-shockwave-flash" />';
					} else if(isset($_GET["new"]) && $core->user->isAdmin()) {
							print "<iframe src='" . $core->http . "://ixat.io/embed/chat.php#{$flashVars}' width='728' height='486' frameborder='0' scrolling='no'></iframe>";
					} else {
						/*
						?>
				<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="//fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="728" height="486" id="chat" align="middle">
					<param name="allowScriptAccess" value="sameDomain" />
					<param name="movie" value="<?= $movie; ?>" />
					<param name="quality" value="high" />
					<param name="bgcolor" value="#000000" />
					<param name="FlashVars" value="<?= $flashVars; ?>" />
					<param name="wmode" value="transparent" />
					<embed src="<?= $movie; ?>" quality="high" wmode="transparent" bgcolor="#000000" width="728" height="486" name="chat" FlashVars="<?= $flashVars; ?>" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="//xat.com/update_flash.shtml" />
				</object>
				<?php */
					print $core->getEmbed($chat[0]["name"], false, 728, 486);
					}
				?>
				<?php
					if($adPosition == 2)
					{
						print '
							<div style="padding-top:24px"></div> 
							<div onmousedown="//ixat.io/powers"><embed wmode="transparent" src="//ixat.io/images/ads/xatAd.swf?b9" quality="high" flashvars="" width="728" height="90" align="middle" allowscriptaccess="sameDomain" type="application/x-shockwave-flash" /></div>
						';
					}
				?>
			</td>
			<td width="3.5%">&nbsp;</td>
		</tr>
	</table>
	<br>
	<a class="btn btn-primary" href="/embed<?php print "&id={$chat[0]['id']}&GroupName={$chat[0]['name']}"; ?>" target="_blank"><i class="zmdi zmdi-share fa fa-code"></i> Embed</a>
<script language="JavaScript">
	function jumpScroll() {
		window.scroll(0,566);
	}
	function jsGo(str) {
		window.location.href = '//ixat.io/' + clean(str) +'?p=0&ss=3';
	}
	function ReopenIm()
	{
		ClearMedia();
		divId=document.getElementById('control');
		divId.innerHTML='';
		divId.style.display="none";
	}

	function ClearAll()
	{
		ClearControl();
		ClearMedia();
	}

	function ClearMedia()
	{
		divId=document.getElementById('media');
		divId.innerHTML='';
	}
	function OpenSmilies()
	{
		divId=document.getElementById('media');
		divId.innerHTML='<embed src="/web_gear/flash/smilies.swf" quality="high" wmode="transparent" flashvars="cn=2065999586" width="425" height="600" name=smilies align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" />';
		ClearControl();
		return 1;
	}
	function FlashDbg(s) 
	{
		alert ("FlashDbg:"+s);
		return 1;
	}

	function OpenDoodle()
	{
		divId=document.getElementById('media');
		divId.innerHTML='<embed src="/web_gear/app/doodle.swf?a12" quality="high" bgcolor="#000000" flashvars="cn=<?php echo $cn; ?>" width="425" height="600" name="doodle" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" wmode="transparent" />';
		ClearControl();
		return 1;
	}
	function OpenUniverse()
	{
		divId=document.getElementById('media');
		divId.innerHTML='<embed src="/web_gear/flash/universe.swf?d0" quality="high bgcolor="#000000" flashvars="id=4469749&l=en" width="425" height="540" name="universe" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" /><div style="background-color:#000000; font-size:10px"><table border="0" width="425"><tr><td>The xat universe shows a live view of the public chat groups on xat. To visit a chat group click on its planet, you can navigate around by clicking on empty space and zoom in and out by clicking on the magnifying glass and moving it up and down. Click <a href="/universe.html?id=4469749">here for more</a>.</td></tr></table></div>';
		ClearControl();
		return 1;
	}

	function OpenGame(id)
	{
		if(id == 20034/* || id == 20047*/)
		{
			alert("This app has been temporarily disabled.");
			return 1;
		}
		if(id == 30006)
		{
			OpenSmilies();
			return 1;
		}
		if(id == 30010)
		{
			OpenUniverse();
			return 1;
		}
		divId=document.getElementById('media');
		var w = 425;
		if(id&1) w=600;

		divId.innerHTML='<embed src="//ixat.io/web_gear/flash/'+id+'.swf?9U6Gr" quality="high" wmode="transparent" flashvars="cn=<?php echo $cn; ?>" width="'+w+'" height="600" name="app" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" />';	
		ClearControl();
		return 1;
	}

	function OpenAyah(obj)
	{
		var divId=document.getElementById('media');
		var e = '<iframe width="400" height="600" style="background-color: #ffffff;" src="//ixat.io/web_gear/chat/AreYouaHuman.php?';
		var keys = {type:"type", s:"s", i:"i", k:"k", t:"t", r:"roomid"};
		for (var key in keys) 
			e += key + "=" + parseInt(obj[keys[key]]) + "&";
		e = e.substring(0, e.length - 1)+'"';
		e += "</iframe>";
		divId.innerHTML=e;	
		ClearControl();
		return 1;
	}

	function ClearControl()
	{
		divId=document.getElementById('control');
		divId.innerHTML='';
		divId.style.display="none";
	}
	function SetControl()
	{
		ClearControl();
		divId=document.getElementById('control');
		divId.style.display="inline";
		if(divId.innerHTML.length < 10)
			divId.innerHTML='<embed src="//ixat.io/web_gear/flash/media.swf?b44" quality="high" wmode="transparent" flashvars="cn=<?php echo $cn; ?>&id=1&md=0" width="425" height="131" name="media" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" />';
	}
	function OpenMedia(str, nocook) {
		if(str != 0 && str.substring(0, 5) == "https")
		{
			str = "http" + str.substring(5);
		}
		if(str != 0 && str.indexOf("youtube.com") == -1)
		str = clean(str);
		var divId=document.getElementById('media');
		divId.innerHTML='<table bgcolor="transparent" border="0" width="425" height="355" style="margin: 0 auto;"><tr><td style="padding:30px">When Members put a <a href="//youtube.com" target="_blank">YouTube</a>, <a href="//veoh.com" target="_blank">Veoh</a>, <a href="//photobucket.com" target="_blank">Photobucket</a>, <a href="//vids.myspace.com" target="_blank">MySpace Video</a> or <a href="//live.yahoo.com" target="_blank">Yahoo Live</a> link in the chat box the video thumbnail will appear on everyones player. Each person can click on the thumbnail to start the video.<BR><BR>To watch videos together, Moderators can press the broadcast button and the video will start on everyones player at the same time.<BR><BR>If you are watching a video and do not want to view broadcasts press the lock (key) button.</td></tr></table>';
		divId=document.getElementById('control');
		var la = 10001;
		if(str==0)
			SetControl();
		else if (str.indexOf("clips.twitch.tv/") >= 0) {
			ClearControl();
			divId=document.getElementById('media');
			source = str.split("twitch.tv/")[1];
			source = '//clips.twitch.tv/embed?clip=' + source;
			divId.innerHTML='<iframe src="'+source+'" quality="high" wmode="transparent" width="425" height="486" name="media" align="middle" />';
			divId.style.display="inline";
		} else if (str.indexOf("twitch.tv/") >= 0) {
			ClearControl();
			divId=document.getElementById('media');
			source = str.split("twitch.tv/")[1];
			source = '//player.twitch.tv/?channel=' + source;
			divId.innerHTML='<iframe src="'+source+'" quality="high" wmode="transparent" width="425" height="486" name="media" align="middle" />';
			divId.style.display="inline";
		} else {
			ClearControl();
			divId.innerHTML='<embed src="//ixat.io/web_gear/flash/media.swf?b44" quality="high" wmode="transparent" flashvars="cn=<?php echo $cn; ?>&id=1&md='+str+'" width="425" height="131" name="media" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" />';
			divId.style.display="inline";
		}
		return 1;
	}
	function OpenByN(n) {
		if(n == 10001) OpenMedia(0);
		if(n == 10000) OpenDoodle();
		if(n >= 20000) OpenGame(n);
		if(n.toString().charAt(0) == '{')
		{
			var obj = JSON.parse(n);
			OpenAyah(obj);
		}
		return 1;
	}
	function GetEmbed(vid)
	{
		vid = clean(vid);
		embed = '<embed type="application/x-shockwave-flash" allowFullScreen="true" bgcolor="#000000" ';
		
		if(vid.substr(0,2) == "$U") {
			embed += 'src="//ustream.tv/flash/live/'+ vid.substr(2) +'" flashvars="autoplay=true&brand=embed"';
			w = 416; h = 340;
		} else if(vid.substr(0,2) == "$L") {
			embed += 'src="//cdn.livestream.com/grid/LSPlayer.swf?channel='+ vid.substr(2) +'&amp;color=0xe7e7e7&amp;autoPlay=true&amp;mute=false" width="560" height="340" allowScriptAccess="always" ';
			w = 560; h = 340;
		} else if(vid.substr(0,2) == "$Y") {
			embed += 'src="//live.yahoo.com/swf/player/'+ vid.substr(2) +'"';
			w = 412; h = 363;
		} else if(vid.substr(0,2) == "$G") {
			embed += 'src="//video.google.com/googleplayer.swf?docId='+ vid.substr(2) +'&hl=en-GB&autoplay=true"'; w = 400; h = 326;
		} else if(vid.substr(0,2) == "$O") {
			embed += 'src="//www.mogulus.com/grid/PlayerV2.swf?channel='+ vid.substr(2) +'&externalInterface=false&backgroundColor=0xffffff&color=0x333333&showviewers=false&on=true&initialVolume=10&chatEnabled=false"';
			w = 454; h = 389;
		} else if(vid.substr(0,2) == "$M") {
			embed += 'src="//lads.myspace.com/videos/vplayer.swf" flashvars="m='+ vid.substr(2) +'&v=2&type=video&a=1"';
			w = 430; h = 346;
		} else if(vid.substr(0,2) == "$V") {
			embed += 'src="//www.veoh.com/videodetails2.swf?permalinkId='+ vid.substr(2) +'&id=anonymous&player=videodetailsembedded&videoAutoPlay=1"';
			w = 450; h = 438;
		} else if(vid.substr(0,2) == "$P") {
			vid = vid.substr(2);
			var sp = vid.split(",");
			var w=425, h=355;
			if(sp[2] > 0 && sp[3] > 0) {
				w = sp[2];
				h = sp[3];
			}
			url = '//'+sp[0]+'.photobucket.com/'+sp[1];
			embed ='<a href="'+url+'" target="_blank"><img src="'+url+'" width="'+w+'" height="'+h+'" border="0"></a>';
			return embed;
		} else {
			embed += 'src="//www.youtube.com/v/'+ vid + '&rel=0&color1=0xd6d6d6&color2=0xf0f0f0&border=0&autoplay=1"';
			w=425; h=355;
		}
		embed += ' width="'+w+'" height="'+h+'" />' ;
		
		return embed;
	}

	function StartMedia(arg) {
		if(arg.substring(0,1) == 'L')
			window.location.href = arg.substring(1);
		else {
			if(arg.substring(0,9) == 'xatxatxat') arg = 'L'+arg.substring(9);
			divId=document.getElementById('media');
			divId.innerHTML = GetEmbed(arg);
		}
		return 1;
	}
	function clean(str)
	{
		var bad=/[\?\{\}\"<>\&:]/;

		if (bad.test(str))
			return "";
		return str;
	}
	
	function createCookie(name,value,days) {
		if (days) {
			var date = new Date();
			date.setTime(date.getTime()+(days*24*60*60*1000));
			var expires = "; expires="+date.toGMTString();
		}
		else var expires = "";
		document.cookie = name+"="+value+expires+"; path=/";
	}

	function readCookie(name) {
		var nameEQ = name + "=";
		var ca = document.cookie.split(';');
		for(var i=0;i < ca.length;i++) {
			var c = ca[i];
			while (c.charAt(0)==' ') c = c.substring(1,c.length);
			if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
		}
		return null;
	}
	
	function GoPoll()
	{

		if(readCookie("Poll") != 4)
		{
			createCookie("Poll",4,7)
			OpenGame(30002);
			createCookie("LastApp", 0, 1);
		}
	}
	
	function GoLast()
	{
		var n;
		DoLang();
		if((n = readCookie("LastApp")))
		{
			OpenByN(n);
		}
		else
			GoPoll();
	}

	uname='<?= $chat[0]['name']; ?>';

    function DoReplace(id, from, to)
    {
        var i = document.getElementById(id).innerHTML;
        i = i.replace(from, to);
        i = i.replace(from, to);
        document.getElementById(id).innerHTML = i;
    }
    
    function DoLang()
    {
        var l = readCookie('lang');
        var h = 0;
        var t = 0;
        switch(l)
        {
            case 'es' : h = 'Ayuda'; t = 'Cambio'; break;
            case 'pt' : h = 'Ajuda'; t = 'Troca'; break;
            case 'it' : h = 'Aiuto'; t = 'Baratto'; break;
            case 'tr' : h = 'Yardim'; break;
            case 'fr' : h = 'Aide'; t = 'Commerce'; break;
            case 'sq' : h = 'Ndim'; break;
            case 'ro' : h = 'Ajutor'; t = 'Comert'; break;
            case 'th' : h = 'Chuai'; break;
        }
        if(h !== 0) { DoReplace('help', 'Help', h); } 
        if(t !== 0) { DoReplace('trade', 'Trade', t); }
    }	

	function getXY( id , X)
	{
		var i = 0;
		while( id != null ) {
			if(X)
				i += id.offsetTop;
			else
				i += id.offsetLeft;
			id = id.offsetParent;
		}
		return i;
	}

	function DoGsmilies()
	{
		var	divId=document.getElementById('desc');
		//var y = getXY(divId, 1);
		var x = getXY(divId, 0);
		divId=document.getElementById('gsmiles');
		divId.style.visibility="visible";
		//divId.style.top = y+"px";
		divId.style.left = x+"px";
	}
</script>
