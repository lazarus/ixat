<?php
if(!isset($core->user) || !$core->user->isAdmin() || $core->user->getID() == 3)
{
	return include $pages['home'];
}

/*
$mysql->query("UPDATE users SET powers=:powers, xats=:xats WHERE id=150859;", [
	"powers" => '{"2":1,"4":1,"8":1,"9":1,"12":1,"13":1,"14":1,"15":1,"16":1,"19":1,"21":1,"54":1,"81":1,"103":1,"231":1,"289":1}',
	"xats" => $config->xats
]);
*/
/*
$ppl = ["a" => 25, "b" => 1618, "c" => 1]; //0 == marriage, 1 == bff

$mysql->query("UPDATE users SET d0=:c,d2=:a WHERE id=:b;", $ppl);
$mysql->query("UPDATE users SET d0=:c,d2=:b WHERE id=:a;", $ppl);
*/

//$mysql->query("UPDATE users SET xavi=:xavi WHERE id=:id;", ["id" => -3, "xavi" => '{"hair":{"x":0,"r":1,"l":"hair8","y":-33,"sx":50,"c":-1,"sy":50},"browsl":{"x":2,"r":-30,"l":"xbrowdefault","y":-14,"sx":0,"c":-1,"sy":0},"head":{"x":0,"r":0,"l":"xhead3","y":0,"sx":5,"c":-1,"sy":-24},"acc":{"x":-1,"r":-180,"l":"hat11","y":-10,"sx":-7,"c":-1,"sy":19},"browsr":{"x":-2,"r":30,"l":"xbrowdefault","y":-14,"sx":0,"c":-1,"sy":0},"xeyer":{"x":-2,"r":20,"l":"xeyes13","y":-4,"sx":0,"c":-1,"sy":0},"mouth":{"x":0,"r":0,"l":"xmouthdefault","y":9,"sx":0,"c":-1,"sy":0},"xeyel":{"x":2,"r":-20,"l":"xeyes13","y":-4,"sx":0,"c":-1,"sy":0}}']);

/*
$ids = range(-10,1000);
foreach($mysql->fetch_array("SELECT `id` FROM `users` WHERE `id` <= 1000;") as $id) {
	unset($ids[$id['id'] + 10]);
}
print "<pre>";
print_r($ids);
print "</pre>";
return;
*/

/*
test = "2097151998|1039914739|2127949819|1359526937|2099084161|2011168767|4180|0|0|0|0|0|0".split("|")
powers = [];
for(var i = 0; i < test.length; i++) {
	var p = test[i];
	for(var b = 31; b >= 0; b--) {
    	if((p & (1 << b)) != 0) powers.push((32 * i) + b);
	}
}
powers2 = {};
powers.forEach(function(power) {
    powers2[power] = 1;
}

$mysql->query("UPDATE users SET `powers`=:powers WHERE `id`=-3;", ["powers" => '{"1":1,"2":1,"3":1,"4":1,"5":1,"6":1,"7":1,"8":1,"9":1,"10":1,"11":1,"12":1,"13":1,"14":1,"15":1,"16":1,"17":1,"18":1,"19":1,"20":1,"21":1,"22":1,"23":1,"26":1,"27":1,"28":1,"29":1,"30":1,"32":1,"33":1,"36":1,"37":1,"38":1,"39":1,"41":1,"42":1,"44":1,"46":1,"47":1,"48":1,"49":1,"51":1,"52":1,"53":1,"54":1,"55":1,"56":1,"58":1,"59":1,"60":1,"61":1,"64":1,"65":1,"67":1,"68":1,"69":1,"70":1,"71":1,"72":1,"73":1,"74":1,"75":1,"77":1,"78":1,"79":1,"80":1,"82":1,"84":1,"86":1,"87":1,"89":1,"90":1,"91":1,"92":1,"93":1,"94":1,"96":1,"99":1,"100":1,"106":1,"107":1,"108":1,"109":1,"111":1,"115":1,"120":1,"124":1,"126":1,"128":1,"135":1,"136":1,"137":1,"139":1,"140":1,"141":1,"142":1,"144":1,"146":1,"147":1,"148":1,"152":1,"154":1,"155":1,"156":1,"157":1,"158":1,"160":1,"161":1,"162":1,"163":1,"164":1,"165":1,"166":1,"167":1,"168":1,"169":1,"170":1,"171":1,"172":1,"173":1,"174":1,"175":1,"176":1,"177":1,"178":1,"179":1,"180":1,"182":1,"183":1,"184":1,"185":1,"186":1,"188":1,"189":1,"190":1,"194":1,"196":1,"198":1,"204":1}']);
*/
/*
$pawns = glob(_root."images/sm2/p1*.swf");
sort($pawns);
foreach(array_chunk($pawns, 150)[3] as $pawn) {
	print "<embed src='//ixat.io/web_gear/flash/smiliesshow.swf' flashvars='r=".explode(".",substr($pawn, strlen("/usr/share/nginx/html/images/sm2/")))[0]."' wmode=\"transparent\" style='width: 60px; float: left; height: 60px;'></embed>";
}
return;
*/
/*
$json = json_decode(file_get_contents("https://xat.com/json/powers.php"));
//$p_names = [];
foreach($json as $i => &$power) {
	//$p_names[] = $power->s;
	//continue;
	//if(isset($power->f) && ($power->f & 0x2000) != 0) { unset($json->$i); continue; }
	if(!isset($power->x)) $power->x = (int)($power->d * 13.5);
	$power->x = (int)($power->x * 0.75);
	//continue;
	//$x = $mysql->query("UPDATE `powers` SET cost=:cost, limited=0 WHERE `name`=:name", ["cost" => $power->x, "name" => $power->s]);
}
//$json = $mysql->query("UPDATE powers SET `cost`=`cost`*0.75 WHERE `p`='1' AND `name` NOT IN ('".implode($p_names, "','")."')");
*/
/*
$json = $mysql->fetch_array("SELECT SUM(cost) FROM powers WHERE `p`='1'");
//$json = $mysql->query("UPDATE powers SET cost=22500 WHERE `name` IN ('textcolor', 'textgrad')");

//$mysql->query("UPDATE powers SET amount=0 WHERE name NOT LIKE 'kloud'");
print "<pre>";
var_dump($json);
print "</pre>";
die();

//*/
//$mysql->query("UPDATE users SET d2=1337 WHERE id=-3;");
/*
$users = $mysql->fetch_array("SELECT id FROM users WHERE 1;");
foreach($users as $user) {
	$powers = $core->GetUserPower($user["id"]);
	$dO = [];
	$new_powers = array_fill(0, ceil(max(array_keys($powers)) / 32), 0);

	foreach($powers as $power => $amount) {
		$new_powers[floor($power / 32)] |= pow(2, $power % 32);
		if($amount > 1) {
			$dO[] = $power . "=" . ($amount - 1);
		}
	}
	$mysql->query("UPDATE users SET powers=:powers, dO=:dO WHERE id=:id;", ["powers" => implode("|", $new_powers), "dO" => implode("|", $dO), "id" => $user["id"]]);
}
*/

/*

$gp = $mysql->fetch_array("select id from `powers` where `group`=1");
foreach($gp as $pow)
{
	$groupp = [];
	$groupp['chat'] = "Lobby";
	$groupp['power'] = $pow['id'];
	$groupp['assignedBy'] = 0;
	$groupp['enabled'] = 1;
	$groupp['count'] = 1;
	$mysql->insert('group_powers', $groupp);
}
var_dump($gp);

*/

/*
if(isset($user->powers)) {
	$powers = [];
	foreach(explode("|", $user->powers) as $d => $z) {
		$p = decbin($z);
		foreach(str_split(strrev($p)) as $i => $c) {
		    if($c == "1") $powers[$i + ($d * 32)] = 1;
		}
	}
	$user->powers = $powers;
	ksort($user->powers);
	$user->powers = json_encode($user->powers);
}
*/
/*
$xat_pow = ["silentban"=>455,"nightmare"=>454,"cuticorn"=>453,"sline"=>452,"kloud"=>451,"fiesta"=>450,"minimon"=>449,"broadcaster"=>448,"ghostmon"=>446,"splashfx"=>445,"fishbowl"=>444,"drawn"=>443,"neon"=>442,"rapidreason"=>441,"eggie"=>440,"kawaii"=>439,"hedgehog"=>438,"earth"=>437,"ribunny"=>436,"anichick"=>435,"foolsday"=>434,"toad"=>433,"spacefx"=>432,"wish"=>431,"ruby"=>430,"mousie"=>429,"kgiraffe"=>428,"lovetest"=>427,"lovefx"=>426,"lovemix2"=>425,"mountain"=>424,"x2d"=>423,"kaoears"=>422,"fireworksfx"=>421,"battle"=>420,"sparklefx"=>419,"christmix"=>418,"tropicalxmas"=>417,"gobble"=>416,"cadet"=>414,"funfair"=>413,"graveyard"=>412,"boo"=>411,"classic"=>410,"fall"=>409,"meow"=>408,"spacejinx"=>407,"ten"=>406,"elephant"=>405,"popcorns"=>404,"comics"=>403,"kwolf"=>402,"summerhug"=>401,"eggjinx"=>400,"aprincess"=>399,"summerland"=>398,"nameflag"=>397,"worm"=>396,"tooth"=>395,"hangjinx"=>394,"diva"=>393,"animegirl"=>392,"chores"=>391,"namewave"=>390,"koala"=>389,"mom"=>388,"jumblejinx"=>387,"earthday"=>386,"onion"=>385,"songkran"=>384,"fools"=>382,"easterland"=>381,"ebunny"=>380,"patrick"=>379,"namegrad"=>378,"caterpillar"=>377,"mining"=>376,"lovehug"=>375,"lovemix"=>374,"paints"=>373,"ricebowl"=>372,"electricity"=>371,"masks"=>370,"fireworkshug"=>369,"ornaments"=>368,"sleighhug"=>367,"choirhug"=>366,"beautifly"=>365,"tigers"=>364,"witch"=>363,"allhallows"=>362,"kstar"=>361,"ranklock"=>360,"roosters"=>359,"kandle"=>358,"glob"=>357,"precious"=>356,"big"=>355,"reaper"=>354,"planets"=>353,"lions"=>352,"transport"=>350,"me"=>349,"poke"=>348,"balloonfx"=>347,"microbe"=>346,"shells"=>345,"nick"=>344,"vacation"=>343,"aquatic"=>342,"ceebear"=>341,"pets"=>340,"redcard"=>339,"gothic"=>338,"aliblue"=>337,"shinobi"=>336,"floral"=>335,"eco"=>334,"mobilebeta"=>333,"easterlove"=>332,"beastie"=>331,"clouds"=>330,"tv"=>329,"supercycle"=>328,"birthday"=>327,"oids"=>326,"valfx"=>325,"amore"=>324,"offset"=>323,"jewelry"=>322,"retro"=>321,"egyptian"=>320,"backup"=>318,"lunar"=>317,"size"=>316,"holidays"=>315,"reveal"=>314,"gamefx2"=>313,"icebucket"=>312,"blueoni"=>311,"manage"=>310,"creepy"=>309,"trickortreat"=>308,"jump"=>307,"ksun"=>306,"kmoon"=>305,"chocolate"=>304,"bird"=>303,"pcback"=>302,"instruments"=>301,"blubunni"=>300,"magic"=>299,"coolz"=>298,"statuscolor"=>297,"summerflix"=>296,"cutie"=>295,"winner"=>294,"ballfx"=>293,"yellowcard"=>292,"rocks"=>291,"worldcup"=>290,"gamefx"=>289,"dreams"=>288,"hamster"=>286,"coffee"=>285,"naughtystep"=>284,"springy"=>283,"butterflies"=>282,"easteregg"=>281,"eventstats"=>280,"snail"=>279,"springflix"=>278,"tongues"=>277,"luck"=>276,"bitefx"=>275,"cupcake"=>274,"ladybug"=>273,"random"=>272,"sweetheart"=>271,"arachnid"=>270,"divorce"=>269,"farm"=>268,"cooking"=>267,"hogmanay"=>266,"celebrate"=>265,"badge"=>264,"toys"=>263,"noel"=>262,"winterland"=>261,"blackfriday"=>260,"froggy"=>259,"piracy"=>258,"halloween2"=>257,"zwhack"=>256,"scary"=>254,"ani1"=>253,"redirect"=>252,"eggy"=>251,"autumn"=>250,"kdemon"=>249,"kangel"=>248,"weather"=>247,"darts"=>246,"fruities"=>245,"kickall"=>244,"sticky"=>243,"romance"=>242,"marriage"=>241,"phasefx"=>240,"cuboid"=>239,"switch"=>238,"fourth"=>237,"slotban"=>236,"cactus"=>235,"germ"=>234,"wedding"=>233,"super"=>232,"statusglow"=>231,"hair2f"=>230,"seaside"=>229,"led"=>228,"sketch"=>227,"kcow"=>226,"kfox"=>225,"hearts"=>224,"eggs"=>222,"hands2"=>221,"vote"=>220,"spring"=>219,"stylist"=>218,"nuclear"=>217,"kmonkey"=>216,"kheart"=>215,"makeup"=>214,"zombie"=>213,"foe"=>212,"eighties"=>211,"kmouse"=>210,"xavi"=>209,"glitterfx"=>208,"quest2"=>207,"lang"=>206,"quest"=>205,"claus"=>204,"treefx"=>203,"vampyre"=>202,"speech"=>201,"spacewar"=>200,"drop"=>199,"clockfx"=>198,"pony"=>197,"poker"=>196,"kpig"=>195,"snakerace"=>194,"burningheart"=>193,"matchrace"=>192,"aliens"=>190,"olympic"=>189,"doodlerace"=>188,"whirlfx"=>187,"moustache"=>186,"drip"=>185,"zip"=>184,"jail"=>183,"vortexfx"=>182,"kbee"=>181,"gsound"=>180,"nursing"=>179,"spiralfx"=>178,"fuzzy"=>177,"reverse"=>176,"blobby"=>175,"pulsefx"=>174,"ksheep"=>173,"typing"=>172,"kat"=>171,"monster"=>170,"movie"=>169,"topspin"=>168,"carnival"=>167,"heartfx"=>166,"kduck"=>165,"spy"=>164,"magicfx"=>163,"codeban"=>162,"can"=>161,"newyear"=>160,"dunce"=>158,"sparta"=>157,"santa"=>156,"reindeer"=>155,"snowman"=>154,"gold"=>153,"mazeban"=>152,"manga"=>151,"bot"=>150,"kdog"=>149,"spooky"=>148,"carve"=>147,"kchick"=>146,"peace"=>145,"away"=>144,"punch"=>143,"silentm"=>142,"school"=>141,"matchban"=>140,"nerd"=>139,"kpeng"=>138,"dance"=>137,"spaceban"=>136,"stoneage"=>135,"snakeban"=>134,"space"=>133,"flower"=>132,"zodiac"=>131,"gback"=>130,"candy"=>129,"beach"=>128,"banpool"=>126,"work"=>125,"wildwest"=>124,"outfit"=>123,"sins"=>122,"zap"=>121,"events"=>120,"unwell"=>119,"gkpanda"=>118,"music"=>117,"animal"=>116,"spin"=>115,"rankpool"=>114,"hero"=>113,"announce"=>112,"fantasy"=>111,"gkkitty"=>110,"barge"=>109,"love"=>108,"ugly"=>107,"gscol"=>106,"angry"=>105,"gkbear"=>104,"namecolor"=>103,"fairy"=>102,"shocker"=>101,"link"=>100,"single"=>99,"feast"=>98,"adventure"=>97,"winter"=>96,"everypower"=>95,"blastkick"=>94,"mint"=>93,"horror"=>92,"rapid"=>91,"bad"=>90,"summer"=>89,"blastde"=>88,"independence"=>87,"blastban"=>86,"flag"=>85,"blastpro"=>84,"silly"=>83,"sea"=>82,"tickle"=>81,"gcontrol"=>80,"tempown"=>79,"supporter"=>78,"scifi"=>77,"gkaliens"=>76,"bump"=>75,"gline"=>74,"military"=>73,"gkaoani"=>72,"circus"=>71,"banish"=>70,"nopm"=>69,"easter"=>68,"flashrank"=>67,"irish"=>66,"party"=>65,"blueman"=>64,"valentine"=>62,"tempmem"=>61,"dx"=>60,"stick"=>59,"count"=>58,"christmas"=>57,"snowy"=>56,"thanksgiving"=>55,"status"=>54,"anime"=>53,"halloween"=>52,"hush"=>51,"num"=>50,"sport"=>49,"fruit"=>48,"radio"=>47,"mute"=>46,"angel"=>45,"dood"=>44,"six"=>43,"costumes"=>42,"gag"=>41,"fade"=>40,"hairf"=>39,"hairm"=>38,"hands"=>37,"ttth"=>36,"purple"=>35,"diamond"=>34,"sinbin"=>33,"guestself"=>32,"pink"=>30,"invisible"=>29,"superkick"=>28,"show"=>27,"octogram"=>26,"boot"=>25,"clear"=>24,"hexagon"=>23,"cycle"=>22,"nameglow"=>21,"square"=>20,"animate"=>19,"shuffle"=>18,"heart"=>17,"light"=>16,"blue"=>15,"green"=>14,"red"=>13,"hat"=>12,"tempmod"=>11,"nopc"=>10,"reghide"=>9,"noaudies"=>8,"mirror"=>7,"invert"=>6,"nofollow"=>5,"zoom"=>4,"mod8"=>3,"subhide"=>2,"topman"=>1,"allpowers"=>0];

$powers = $mysql->fetch_array("select id, name from powers order by id asc;");
$new_powers = ["allpowers"];
$custom_powers = [];
$ci=1;
foreach($powers as $power) {
	if(array_key_exists($power["name"], $xat_pow)) {
		$new_powers[$xat_pow[$power["name"]]] = $power["name"];
	} else {
		if($ci % 32 == 31) $ci++;
		$custom_powers[$ci++] = $power["name"];
	}
}
foreach($custom_powers as $id => $name) {
	$new_powers[-$id] = $name;
}
ksort($new_powers);

//$mysql->query("delete from powers where id like name or name like '%undefined%';");

print "<pre>";
var_dump($new_powers);
print "</pre>";
/*
$mysql->query("DELETE FROM powers WHERE id < 3000;");
$mysql->query("UPDATE powers SET name=95 WHERE id=95;");
*/
/*for($i = 400; $i < 500; $i++) {
	if(empty($new_powers[$i])) continue;
	$name = $new_powers[$i];
	$id = $i;
//*\/

foreach($new_powers as $id => $name) {
	print "UPDATE powers SET id=$id WHERE name='$name';\n";
}

return;
*/

//$mysql->query("UPDATE users SET id=-3 WHERE id=1999;");
//var_dump($mysql->fetch_array("SELECT * FROM users WHERE `connected_last`='';"));

//$mysql->query("DELETE from ranks where userid=7;");
//$mysql->query("delete from powers where id=527;");

//$mysql->query("UPDATE users SET email=:new, nickname=:nick WHERE username=:old;", ["nick"=>base64_encode("sam"), "new" => "supsamantha16+ixat@gmail.com", "old"=>"samantha"]);

$user = isset($_GET['id']) ? json_decode(json_encode(@$mysql->fetch_array("SELECT * FROM `users` WHERE `id`=:id;", array("id" => $_GET["id"]))[0])) : (object)$core->user;
print "<pre>";
var_dump(base64_decode($user->nickname), $user);
print "</pre>";

function setupAvy($avatar) {
	$avatar = @explode("#", $avatar)[0];
	if(empty($avatar)) return '<img class="img-circle" src="http://www.wallpaper-network.com/wp-content/uploads/2011/09/skull-and-bones-wallpaper-250x250.jpg" />';
	if($avatar{0} == "(") return '<embed src="http://ixat.io/web_gear/flash/smiliesshow.swf" flashvars="r='.str_replace(array('(',')'), '', $avatar).'" wmode="transparent" quality="high" type="application/x-shockwave-flash" align="middle">';
	else if(is_numeric($avatar)) return '<img class="img-circle" src="http://ixat.io/web_gear/chat/av/'.$avatar.'.png">';
	else {
		list($width, $height) = @getimagesize($avatar);
		if($width >= ($height * 2)) {
			$height = $height == 0 ? 1:$height;
			$duration = @round(floor($width / $height) / 15);
			$duration = $duration == 0 ? 1:$duration;
			$keyframes = '@-webkit-keyframes AviAnimation {from{background-position:0px;} to{background-position:-'.$width.'px;}}@-moz-keyframes AviAnimation {from{background-position:0px;} to{background-position:-'.$width.'px;}}@-ms-keyframes AviAnimation{from{background-position:0px;} to{background-position:-'.$width.'px;}} @-o-keyframes AviAnimation {from{background-position: 0px;} to{background-position:-'.$width.'px;}} @keyframes AviAnimation {from{background-position: 0px;} to{background-position:-'.$width.'px;}}';
			$steps = @floor($width / $height);
			$animation = '-webkit-animation: AviAnimation '.$duration.'s steps('.$steps.') infinite;-moz-animation: AviAnimation '.$duration.'s steps('.$steps.') infinite;-ms-animation: AviAnimation '.$duration.'s steps('.$steps.') infinite;-o-animation: AviAnimation '.$duration.'s steps('.$steps.') infinite;animation: AviAnimation '.$duration.'s steps('.$steps.') infinite;';
			return '<style>'.$keyframes.'</style><div style="background-image:url(\''.$avatar.'\');background-size:cover;position:relative;top:10px;height:'.$height.';width:'.$height.';margin:auto;'.$animation.';max-height: 250px; max-width: 250px;"></div>';
		} else return '<img class="img-circle" src="'.$avatar.'">';
	}
	return $showavi;
}

if(isset($_GET['p']))
{
	if(!is_object($user)) $user = json_decode('{"id":"0","username":"Null","nickname":"User does not exist","avatar":"1","xats":"0","days":"0","powers":""}');
	//$mysql->query("DELETE FROM `pvtlog` WHERE (`sender`=:a and `recipient`=:b) or (`sender`=:b and `recipient`=:a);", array("a" => -3, "b" => 22653));
	//$mysql->query("UPDATE `gifts` SET `b`=:a WHERE `b`=:b;", array("a" => 66, "b" => 22653));
	$nickname = @mb_convert_encoding(htmlentities(html_entity_decode(substr(base64_decode($user->nickname), 0, strpos($user->nickname . '##', '##')))), "UTF-8", "auto");
	$nickname = preg_replace('/\([^)]*\)+/', '', $nickname);
	$name = substr($nickname, 0, 50) == "" ? $user->username : trim(substr($nickname, 0, 50));
	$avatar = setupAvy($user->avatar);
	$pcount = count($core->DecodePowers($user->powers)[0]);
?>
<style>
.box-widget {
	border: none;
	position: relative;
	color: initial;
}
.widget-user .widget-user-header {
	padding: 20px;
	height: 120px;
	border-top-right-radius: 3px;
	border-top-left-radius: 3px;
}
.widget-user .widget-user-username {
	margin-top: 0;
	margin-bottom: 5px;
	font-size: 25px;
	font-weight: 300;
	text-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
}
.widget-user .widget-user-desc {
	margin-top: 0;
}
.widget-user .widget-user-image {
	position: absolute;
	top: 65px;
	left: 50%;
	margin-left: -45px;
}
.widget-user .widget-user-image > img {
	width: 90px;
	height: auto;
	border: 3px solid #fff;
}
.widget-user .box-footer {
	padding-top: 30px;
}
.widget-user-2 .widget-user-header {
	padding: 20px;
	border-top-right-radius: 3px;
	border-top-left-radius: 3px;
}
.widget-user-2 .widget-user-username {
	margin-top: 5px;
	margin-bottom: 5px;
	font-size: 25px;
	font-weight: 300;
}
.widget-user-2 .widget-user-desc {
	margin-top: 0;
}
.widget-user-2 .widget-user-username,
.widget-user-2 .widget-user-desc {
	margin-left: 75px;
}
.widget-user-2 .widget-user-image > img {
	width: 65px;
	height: auto;
	float: left;
}
.img-circle {
	background-color: white;
}
.description-text {
	text-transform: uppercase;
}
</style>
<div class="container-fluid">
	<section class="content">
		<div class="row">
			<div class="col-md-4">
				<!-- Widget: user widget style 1 -->
				<div class="box box-widget widget-user-2">
					<!-- Add the bg color to the header using any of the bg-* classes -->
					<div class="widget-user-header bg-red-active">
						<div class="widget-user-image">
							<?php print $avatar; ?>
						</div>
						<!-- /.widget-user-image -->
						<h3 class="widget-user-username"><?php print $name; ?></h3>
						<h5 class="widget-user-desc">Some user label</h5>
					</div>
					<div class="box-footer no-padding">
						<ul class="nav nav-stacked">
							<li><a href="#">ID <span class="pull-right badge bg-blue"><?= $user->id ?></span></a></li>
							<li><a href="#">zats <span class="pull-right badge bg-green"><?= $user->xats ?></span></a></li>
							<li><a href="#">Days <span class="pull-right badge bg-yellow"><?= $user->days ?></span></a></li>
							<li><a href="#">Powers <span class="pull-right badge bg-red"><?= $pcount ?></span></a></li>
						</ul>
					</div>
				</div>
				<!-- /.widget-user -->
			</div>

        	<div class="col-md-4">
        		<!-- Widget: user widget style 1 -->
        		<div class="box box-widget widget-user">
					<!-- Add the bg color to the header using any of the bg-* classes -->
					<div class="widget-user-header bg-aqua-active">
					<!-- Custom header -->
					<!-- <div class="widget-user-header bg-black" style="background: url('../dist/img/photo1.png') center center;"> -->
						<h3 class="widget-user-username"><?php print $name; ?></h3>
						<h5 class="widget-user-desc">Some user label</h5>
					</div>
					<div class="widget-user-image">
						<?php print $avatar; ?>
					</div>
					<div class="box-footer">
						<div class="row">
							<div class="col-sm-4 border-right">
								<div class="description-block">
									<h5 class="description-header"><?= $user->xats ?></h5>
									<span class="description-text">XATS</span>
								</div>
								<!-- /.description-block -->
							</div>
							<!-- /.col -->
							<div class="col-sm-4 border-right">
								<div class="description-block">
									<h5 class="description-header"><?= $user->id ?></h5>
									<span class="description-text">ID</span>
								</div>
								<!-- /.description-block -->
							</div>
							<!-- /.col -->
							<div class="col-sm-4">
								<div class="description-block">
									<h5 class="description-header"><?= $pcount ?></h5>
									<span class="description-text">POWERS</span>
								</div>
								<!-- /.description-block -->
							</div>
							<!-- /.col -->
						</div>
						<!-- /.row -->
					</div>
        		</div>
        		<!-- /.widget-user -->
        	</div>

        	<div class="col-md-4">
        		<!-- Widget: user widget style 1 -->
        		<div class="box box-widget widget-user">
					<!-- Add the bg color to the header using any of the bg-* classes -->
					<div class="widget-user-header bg-aqua-active" style="background: url('/web_gear/background/xat_winter_holiday.jpg') center center; background-size: cover;">
						<h3 class="widget-user-username"><?php print $name; ?></h3>
						<h5 class="widget-user-desc">Some user label</h5>
					</div>
					<div class="widget-user-image">
						<?php print $avatar; ?>
					</div>
					<div class="box-footer">
						<div class="row">
							<div class="col-sm-4 border-right">
								<div class="description-block">
									<h5 class="description-header"><?= $user->xats ?></h5>
									<span class="description-text">XATS</span>
								</div>
								<!-- /.description-block -->
							</div>
							<!-- /.col -->
							<div class="col-sm-4 border-right">
								<div class="description-block">
									<h5 class="description-header"><?= $user->id ?></h5>
									<span class="description-text">ID</span>
								</div>
								<!-- /.description-block -->
							</div>
							<!-- /.col -->
							<div class="col-sm-4">
								<div class="description-block">
									<h5 class="description-header"><?= $pcount ?></h5>
									<span class="description-text">POWERS</span>
								</div>
								<!-- /.description-block -->
							</div>
							<!-- /.col -->
						</div>
						<!-- /.row -->
					</div>
        		</div>
        		<!-- /.widget-user -->
        	</div>
        </div>
		<!-- /.row -->
    </section>
	<!-- /.content -->
</div>
<?php
}
?>
