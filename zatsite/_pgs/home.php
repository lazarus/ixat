<?php
if(!isset($config->complete))
{
	return include $pages['setup'];
}
$cn = $core->cn;
$release = json_decode($config->info["power_release"]);
$last = $mysql->fetch_array('select `name` from `powers` where `id`=' . $release->id);
$latest = $mysql->fetch_array("SELECT * FROM `powers` WHERE `p`=1 ORDER BY `id` DESC LIMIT 1;");
$status = $latest[0]['limited'] == 1 ? 'Limited':'Unlimited';

if(isset($_GET["gl"]) && isset($_GET["ajax"]))
{
	$json = new StdClass();
	$json->lvn = $last[0]['name'];
	$json->nr = gmdate('Y/m/d h:i:s A T', 3600 + $release->time);
	$json->lpn = ucfirst($latest[0]['name']);
	$json->lps = $status;
	
	exit(json_encode($json));
}
?>
			<!--
			|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
			| Chat Embed
			|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
			!-->
			<section class="section bg-gray">
				<div class="container">
					<div class="row">
						<div class="col-12 col-md-8 offset-md-2">
							<?= $core->getEmbed("Lobby", false, 728, 486); ?>
						</div>
					</div>
				</div>
			</section>
			<!--
			|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
			| Power Release Timer
			|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
			!-->
			<section class="section p-40">
				<div class="container">
					<div class="divider">Time until next power release</div>
					<div class="row">
						<div class="col-12 col-md-6 offset-md-3">
							<div name="power_release" class="countdown countdown-uppercase" data-countdown="<?= gmdate('Y/m/d h:i:s A T', 3600 + $release->time); ?>"></div>
						</div>
					</div>
				</div>
			</section>
			<!--
			|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
			| Latest Power Info
			|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
			!-->
<?php
			$latest = $mysql->fetch_array("SELECT name, limited, cost FROM `powers` WHERE `p`=1 ORDER BY `id` DESC LIMIT 1;");
?>
			<section class="section p-40">
				<div class="container">
					<div class="row gap-y">
						<div class="col-12 col-lg-6">
							<div class="card bg-gray">
								<embed src="/images/sm2/<?= $last[0]["name"]; ?>.swf?r" bgcolor="#ffffff" />
								<div class="card-block">
									<h5 class="card-title fw-600">Last power released</h5>
									<p class="card-text"><?= i18n::get('home.latest.voted', $last[0]['name']); ?></p>
									<a class="fw-600 fs-12" href="/powers">Buy it now <i class="fa fa-chevron-right fs-9 pl-8"></i></a>
								</div>
							</div>
						</div>
						<div class="col-12 col-lg-6">
							<div class="card bg-gray">
								<embed src="/images/sm2/<?= $latest[0]["name"]; ?>.swf?r" bgcolor="#ffffff" />
								<div class="card-block">
									<h5 class="card-title fw-600">Last power added</h5>
									<p class="card-text"><?= i18n::get('home.latest.added', ucfirst($latest[0]['name']), $latest[0]['limited'] == 1 ? 'Limited':'Unlimited', $latest[0]['cost']); ?></p>
									<a class="fw-600 fs-12" href="/powers">Buy it now <i class="fa fa-chevron-right fs-9 pl-8"></i></a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</section>
			<!--
						<button type="button" class="btn btn-custom" onclick="javascript:ClearAll();OpenGame(30004);return false;"> <i class='zmdi zmdi-apps zmdi-hc-lg fa fa-th fa-lg'></i> </button>
						<button type="button" class="btn btn-custom" onclick="javascript:ClearAll();OpenMedia(0);return false;"> <i class='zmdi zmdi-youtube zmdi-hc-lg fa fa-youtube fa-lg'></i> </button>
						<button type="button" class="btn btn-custom" onclick="javascript:ClearAll();OpenDoodle();return false;"> <i class='zmdi zmdi-brush zmdi-hc-lg fa fa-paint-brush fa-lg'></i> </button>
						<button type="button" class="btn btn-custom" onclick="javascript:ClearAll();OpenGame(20034);return false;"> <i class='zmdi zmdi-translate zmdi-hc-lg fa fa-language fa-lg'></i> </button>
						<button type="button" class="btn btn-custom" onclick="javascript:ClearAll();OpenGame(10002);return false;"> <i class='zmdi zmdi-gamepad zmdi-hc-lg fa fa-gamepad fa-lg'></i> </button>
						<button type="button" class="btn btn-custom" onclick="javascript:ClearAll();OpenSmilies();return false;"> <i class='zmdi zmdi-face zmdi-hc-lg fa fa-smile-o fa-lg'></i> </button>
						<button type="button" class="btn btn-custom" onclick="javascript:ClearAll();return false;"> <i class='zmdi zmdi-close zmdi-hc-lg fa fa-times fa-lg'> </i> </button>
			-->
<script type="text/javascript">
var hours;
var minutes;
var seconds;
var timer;
var updated = false;

function jumpScroll() {
    window.scroll(0, 566);
}

function jsGo(str) {
    window.location.href = '//ixat.io/' + clean(str) + '?p=0&ss=3';
}

function ReopenIm() {
    ClearMedia();
    divId = document.getElementById('control');
    divId.innerHTML = '';
    divId.style.display = "none";
}

function ClearAll() {
    ClearControl();
    ClearMedia();
}

function ClearMedia() {
    divId = document.getElementById('media');
    divId.innerHTML = '';
}

function OpenSmilies() {
    divId = document.getElementById('media');
    divId.innerHTML = '<embed src="/web_gear/flash/smilies.swf" quality="high" wmode="transparent" flashvars="cn=<?php echo $cn; ?>" width="425" height="600" name=smilies align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" />';
    ClearControl();
    return 1;
}

function FlashDbg(s) {
    alert("FlashDbg:" + s);
    return 1;
}

function OpenDoodle() {
    divId = document.getElementById('media');
    divId.innerHTML = '<embed src="/web_gear/app/doodle.swf?a12" quality="high" bgcolor="#000000" flashvars="cn=<?php echo $cn; ?>" width="425" height="600" name="doodle" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" wmode="transparent" />';
    ClearControl();
    return 1;
}

function OpenUniverse() {
    divId = document.getElementById('media');
    divId.innerHTML = '<embed src="/web_gear/flash/universe.swf?d0" quality="high bgcolor="#000000" flashvars="id=4469749&l=en" width="425" height="540" name="universe" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" /><div style="background-color:#000000; font-size:10px"><table border="0" width="425"><tr><td>The xat universe shows a live view of the public chat groups on xat. To visit a chat group click on its planet, you can navigate around by clicking on empty space and zoom in and out by clicking on the magnifying glass and moving it up and down. Click <a href="/universe.html?id=4469749">here for more</a>.</td></tr></table></div>';
    ClearControl();
    return 1;
}

function OpenGame(id) {
    if (id == 20034 /* || id == 20047*/ ) {
        //alert("This app has been temporarily disabled.");
        //return 1;
    }
    if (id == 30006) {
        OpenSmilies();
        return 1;
    }
    if (id == 30010) {
        OpenUniverse();
        return 1;
    }
    divId = document.getElementById('media');
    var w = 425;
    if (id & 1) w = 600;

    divId.innerHTML = '<embed src="//ixat.io/web_gear/flash/' + id + '.swf?9U6Gr" quality="high" wmode="transparent" flashvars="cn=<?php echo $cn; ?>" width="' + w + '" height="600" name="app" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" />';
    ClearControl();
    return 1;
}

function OpenAyah(obj) {
    var divId = document.getElementById('media');
    var e = '<iframe width="400" height="600" style="background-color: #ffffff;" src="//ixat.io/web_gear/chat/AreYouaHuman.php?';
    var keys = {
        type: "type",
        s: "s",
        i: "i",
        k: "k",
        t: "t",
        r: "roomid"
    };
    for (var key in keys)
        e += key + "=" + parseInt(obj[keys[key]]) + "&";
    e = e.substring(0, e.length - 1) + '"';
    e += "</iframe>";
    divId.innerHTML = e;
    ClearControl();
    return 1;
}

function ClearControl() {
    divId = document.getElementById('control');
    divId.innerHTML = '';
    divId.style.display = "none";
}

function SetControl() {
    ClearControl();
    divId = document.getElementById('control');
    divId.style.display = "inline";
    if (divId.innerHTML.length < 10)
        divId.innerHTML = '<embed src="//ixat.io/web_gear/flash/media.swf?b44" quality="high" wmode="transparent" flashvars="cn=<?php echo $cn; ?>&id=1&md=0" width="425" height="131" name="media" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" />';
}

function OpenMedia(str, nocook) {
    if (str != 0 && str.substring(0, 5) == "https") {
        str = "http" + str.substring(5);
    }
    if (str != 0 && str.indexOf("youtube.com") == -1)
        str = clean(str);
    var divId = document.getElementById('media');
    divId.innerHTML = '<table bgcolor="#000000" border="0" width="425" height="355"><tr><td style="padding:30px">When Members put a <a href="//youtube.com" target="_blank">YouTube</a>, <a href="//veoh.com" target="_blank">Veoh</a>, <a href="//photobucket.com" target="_blank">Photobucket</a>, <a href="//vids.myspace.com" target="_blank">MySpace Video</a> or <a href="//live.yahoo.com" target="_blank">Yahoo Live</a> link in the chat box the video thumbnail will appear on everyones player. Each person can click on the thumbnail to start the video.<BR><BR>To watch videos together, Moderators can press the broadcast button and the video will start on everyones player at the same time.<BR><BR>If you are watching a video and do not want to view broadcasts press the lock (key) button.</td></tr></table>';
    divId = document.getElementById('control');
    var la = 10001;
    if (str == 0)
        SetControl();
    else if (str.indexOf("clips.twitch.tv/") >= 0) {
        ClearControl();
        divId = document.getElementById('media');
        source = str.split("twitch.tv/")[1];
        source = '//clips.twitch.tv/embed?clip=' + source;
        divId.innerHTML = '<iframe src="' + source + '" quality="high" wmode="transparent" width="425" height="486" name="media" align="middle" />';
        divId.style.display = "inline";
    } else if (str.indexOf("twitch.tv/") >= 0) {
        ClearControl();
        divId = document.getElementById('media');
        source = str.split("twitch.tv/")[1];
        source = '//player.twitch.tv/?channel=' + source;
        divId.innerHTML = '<iframe src="' + source + '" quality="high" wmode="transparent" width="425" height="486" name="media" align="middle" />';
        divId.style.display = "inline";
    } else {
        ClearControl();
        divId.innerHTML = '<embed src="//ixat.io/web_gear/flash/media.swf?b44" quality="high" wmode="transparent" flashvars="cn=<?php echo $cn; ?>&id=1&md=' + str + '" width="425" height="131" name="media" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" />';
        divId.style.display = "inline";
    }
    return 1;
}

function OpenByN(n) {
    if (n == 10001) OpenMedia(0);
    if (n == 10000) OpenDoodle();
    if (n >= 20000) OpenGame(n);
    if (n == 30008) return;
    if (n.toString().charAt(0) == '{') {
        var obj = JSON.parse(n);
        OpenAyah(obj);
    }
    return 1;
}
window.GetEmbed = function(a) {
    var b = 425,
        c = 355;
    a = clean(a);
    embed = '<embed wmode="transparent" bgcolor="#000000" ';
    if ("$U" == a.substr(0, 2)) embed += 'src="//ustream.tv/flash/live/' + a.substr(2) + '" flashvars="autoplay=true&brand=embed"', b = 416, c = 340;
    else if ("$L" == a.substr(0, 2)) embed += 'src="//cdn.livestream.com/grid/LSPlayer.swf?channel=' + a.substr(2) + '&color=0xe7e7e7&autoPlay=true&mute=false" width="560" height="340" allowScriptAccess="always" ', b = 560, c = 340;
    else if ("$Y" == a.substr(0, 2)) embed += 'src="//live.yahoo.com/swf/player/' + a.substr(2) + '"', b = 412, c = 363;
    else if ("$G" == a.substr(0, 2)) embed += 'src="//video.google.com/googleplayer.swf?docId=' + a.substr(2) + '&hl=en-GB&autoplay=true"', b = 400, c = 326;
    else if ("$O" == a.substr(0, 2)) embed += 'src="//www.mogulus.com/grid/PlayerV2.swf?channel=' + a.substr(2) + '&externalInterface=false&backgroundColor=0xffffff&color=0x333333&showviewers=false&on=true&initialVolume=10&chatEnabled=false"', b = 454, c = 389;
    else if ("$M" == a.substr(0, 2)) embed += 'src="//lads.myspace.com/videos/vplayer.swf" flashvars="m=' + a.substr(2) + '&v=2&type=video&a=1"', b = 430, c = 346;
    else if ("$V" == a.substr(0, 2)) embed += 'src="//www.veoh.com/videodetails2.swf?permalinkId=' + a.substr(2) + '&id=anonymous&player=videodetailsembedded&videoAutoPlay=1"', b = 450, c = 438;
    else if ("$T" == a.substr(0, 2)) embed += 'src="//clips.twitch.tv/embed?clip=' + a.substr(2) + '"';
    else {
        if ("$P" == a.substr(0, 2)) return a = a.substr(2), a = a.split(","), url = "http://" + a[0] + ".photobucket.com/" + a[1], embed = '<a href="' + url + '" target="_blank"><img src="' + url + '" width="' + b + '" height="' + c + '" border="0"></a>';
        embed += 'src="//www.youtube.com/embed/' + a + '?controls=1&autohide=1&fs=1&modestbranding=1&iv_load_policy=3&rel=0&autoplay=1"';
        embed = embed.replace('wmode="transparent"', 'frameborder="0"').replace("<embed", "<iframe");
        b = 425;
        c = 355;
    }
    return embed += ' width="' + b + '" height="' + c + '" allowfullscreen="allowfullscreen" allowscriptaccess="always" style="display:block" />';
};

function StartMedia(arg) {
    if (arg.substring(0, 1) == 'L')
        window.location.href = arg.substring(1);
    else {
        if (arg.substring(0, 9) == 'xatxatxat') arg = 'L' + arg.substring(9);
        divId = document.getElementById('media');
        divId.innerHTML = GetEmbed(arg);
    }
    return 1;
}

function clean(str) {
    var bad = /[\?\{\}\"<>\&:]/;

    if (bad.test(str))
        return "";
    return str;
}

function createCookie(name, value, days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        var expires = "; expires=" + date.toGMTString();
    } else var expires = "";
    document.cookie = name + "=" + value + expires + "; path=/";
}

function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
}

function GoPoll() {

    if (readCookie("Poll") != 4) {
        createCookie("Poll", 4, 7)
        OpenGame(30002);
        createCookie("LastApp", 0, 1);
    }
}

function GoLast() {
    var n;
    DoLang();
    if ((n = readCookie("LastApp"))) {
        OpenByN(n);
    } else
        GoPoll();
}

uname = 'Lobby';

function DoReplace(id, from, to) {
    var i = document.getElementById(id).innerHTML;
    i = i.replace(from, to);
    i = i.replace(from, to);
    document.getElementById(id).innerHTML = i;
}

function DoLang() {
    var l = readCookie('lang');
    var h = 0;
    var t = 0;
    switch (l) {
        case 'es':
            h = 'Ayuda';
            t = 'Cambio';
            break;
        case 'pt':
            h = 'Ajuda';
            t = 'Troca';
            break;
        case 'it':
            h = 'Aiuto';
            t = 'Baratto';
            break;
        case 'tr':
            h = 'Yardim';
            break;
        case 'fr':
            h = 'Aide';
            t = 'Commerce';
            break;
        case 'sq':
            h = 'Ndim';
            break;
        case 'ro':
            h = 'Ajutor';
            t = 'Comert';
            break;
        case 'th':
            h = 'Chuai';
            break;
    }
    if (h !== 0) {
        DoReplace('help', 'Help', h);
    }
    if (t !== 0) {
        DoReplace('trade', 'Trade', t);
    }
}

function getXY(id, X) {
    var i = 0;
    while (id != null) {
        if (X)
            i += id.offsetTop;
        else
            i += id.offsetLeft;
        id = id.offsetParent;
    }
    return i;
}

function DoGsmilies() {
    var divId = document.getElementById('desc');
    var x = getXY(divId, 0);
    divId = document.getElementById('gsmiles');
    divId.style.visibility = "visible";
    divId.style.left = x + "px";
}

function finishCountdown(event) {
    GET("/?ajax&gl", getLatest);
}

function GET(url, callback) {
    var xmlhttp = new XMLHttpRequest();

    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            callback(xmlhttp.responseText);
        }
    }
    xmlhttp.open("GET", url, true);
    xmlhttp.send();
}

function getLatest(res) {
    var json = JSON.parse(res);
    $("[name=power_release]").countdown(json.nr);
    $("#lvn").html(json.lvn);
    $("#lp").html(json.lpn + " [" + json.lps + "]");
}
</script>
