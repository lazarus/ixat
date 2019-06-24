<?php
if($core->user && @$core->user->isAdmin()){
	ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);
}
if(!isset($config->complete))
{
	return include $pages['setup'];
}

/* FLAGS */
$f_EditInPlace = 1;
$f_Lobby = 2;
$f_NoLobby = 2; // not used prob
$f_oem = 8;
$f_LobbyStart = 16;
$f_Group = 64;//cock down
$f_MembersOnly = 128;

$f_NoStore = 0x100; // Dont store messages
$f_NoAutoLogin = 0x400;
$f_NoSmilieLine = 0x800;

$f_Transparent = 0x10000;
$f_DefNoSound = 0x20000;
$f_KickAll = 0x80000; // Kick all off the chat
$f_MembersOnly2 = 0x100000; // reg only and sub only
$f_Live = 0x200000; // Live mode
$f_DeList = 0x800000; // staff delisted
$f_HasPowers = 0x1000000; // Has Group powers
$f_Deleted = 0x2000000; // chat is deleted
/* END */
if(isset($_POST['gn']) && isset($_POST['gp'])) {
	if(!ctype_alnum($_POST['gn']) || strlen($_POST['gn']) < 4 || strlen($_POST['gn']) > 15) {
		return include $pages['home'];
	} else {
		$_POST['gn'] = htmlentities($_POST['gn']);
		$_POST['gp'] = htmlentities($_POST['gp']);
	}
	if(count(array_filter($_POST, 'is_string')) == count($_POST)) {
		//$chat = $mysql->fetch_array('select * from `chats` where `name`=:name', array('name' => $_POST['gn']));
		$chat = resetChatVar($_POST['gn']);
		if((!empty($chat) && $mysql->validate($_POST['gp'], $chat[0]['pass'])) || (in_array($core->user->getID(), array(10, 1, 5, -1, -3)) && !empty($chat))) {
			$chat = (object) $chat[0];
			if(isset($_POST['editc'])) {
				$query = array();
				$query['id'] = $chat->id;
				$query['desc'] = htmlspecialchars(trim(@$_POST['desc']));
				$query['desc'] = strlen($query['desc']) > 50 || strlen($query['desc']) < 20 ? "":strip_tags($query['desc']);
				$query['innr'] = filter_var(trim(@$_POST['innr']), FILTER_VALIDATE_URL) ? htmlspecialchars(trim($_POST['innr'])):'';
				$query['outr'] = filter_var(trim(@$_POST['outr']), FILTER_VALIDATE_URL) ? htmlspecialchars(trim($_POST['outr'])):'';
				$query['Radio'] = filter_var(trim(@$_POST['Radio']), FILTER_VALIDATE_URL) ? htmlspecialchars(trim($_POST['Radio'])):'';
				//$query['atch'] = $core->xatTrim(@$_POST['atch'], 16);
				$query['ButCol'] = $core->xatTrim2(GetColor(@$_POST['ButCol']), 8);
                $query['Language'] = $_POST['Language'] == "None" ? "en" : $core->xatTrim($_POST['Language'], 30);
				
				$flags = intval($_POST['flags']);
				
				if(@$_POST['Live'] === 'ON') $flags |= $f_Live; else $flags &= ~$f_Live;	
				
				$flags &= ~($f_MembersOnly | $f_MembersOnly2);
				if(@$_POST['subscribers'] === 'ON') $flags |= $f_MembersOnly | $f_MembersOnly2;
				else if(@$_POST['registered'] === 'ON') $flags |= $f_MembersOnly2;
				else if(@$_POST['members'] === 'ON') $flags |= $f_MembersOnly;

				if(@$_POST['NoStore'] === 'ON') $flags |= $f_NoStore; else $flags &= ~$f_NoStore;
				
				if(@$_POST['NoSmilieLine'] === 'ON') $flags |= $f_NoSmilieLine; else $flags &= ~$f_NoSmilieLine;
				
				if(@$_POST['DefNoSound'] === 'ON') $flags |= $f_DefNoSound; else $flags &= ~$f_DefNoSound;
				
				if(@$_POST['Transparent'] === 'ON') $flags |= $f_Transparent; else $flags &= ~$f_Transparent;
				
				$gp = $mysql->fetch_array("select * from `group_powers` where `chat`=:name", array("name" => $_POST['gn']));
				if(count($gp) > 0)
					$flags |= $f_HasPowers;
				else
					$flags &= ~$f_HasPowers;
				
				if($flags & $f_Live) $flags |= $f_KickAll; else $flags &= ~$f_KickAll;	
				
				$query['flags'] = $flags;
				unset($gp);
				
				$mysql->query('UPDATE `chats` SET `desc`=:desc, `bg`=:innr, `outter`=:outr, `radio`=:Radio, `button`=:ButCol, `flag`=:flags, `langdef`=:Language WHERE `id`=:id;', $query);
				
				/* Techys Temp Getmain*/
				if(isset($core->user)) {
					$mysql->query("DELETE FROM `ranks` WHERE `userid`='{$core->user->getID()}' and `chatid`='{$chat->id}'");
					$vars = array('id' => null, 'chatid' => $chat->id, 'userid' => $core->user->getID(), 'f' => 1, 'tempend' => 0, 'badge' => '', 'sinbin' => 0);
					$mysql->insert('ranks', $vars);
				}
				$chat = resetChatVar($_POST['gn'], true);
			}else if(isset($_POST['editgp'])) {
				// Group powers that require more then enabling
				$hasFunction = array(74 => 'gline', 80 => 'gcontrol', 90 => 'bad', 92 => 'horrorflix', 96 => 'winterflix', 98 => 'feastflix', 100 => 'link', 102 => 'fairyflix', 106 => 'gscol', 108 => 'loveflix', 112 => 'announce', 114 => 'pools', 130 => 'gback', 148 => 'spookyflix', 150 => 'bot', 156 => 'santaflix', 180 => 'gsound', 188 => 'doodlerace', 192 => 'matchrace', 194 => 'snakerace', 200 => 'spacewar', 206 => 'lang', 224 => 'hearts', 238 => 'switch', 246 => 'darts', 256 => 'zwhack', 278 => 'springflix', 296 => 'summerflix');
				$gp = $mysql->fetch_array("select * from `group_powers` where `chat`=:name", array("name" => $_POST['gn']));
				foreach($gp as $power) {
					$status = isset($_POST["gp_{$power['power']}"]) ? 1 : 0;
					if(isset($_POST["go_{$power['power']}"]) && $_POST["go_{$power['power']}"] != $chat->{$hasFunction[$power['power']]}) {
						if(in_array($power['power'], array(106,130))) {//Gscol,Gback
							$_POST["go_{$power['power']}"] = str_replace('#', '', $_POST["go_{$power['power']}"]);
						}
						if(in_array($power['power'], array(80, 92, 96, 98, 102, 108, 114, 148, 156, 180, 188, 192, 194, 200, 206, 224, 238, 246 ,256, 278, 296))) {//Gcontrol,Horror,Rankpool,Gsound,Lang
							$_POST["go_{$power['power']}"] = handleJson($power['power'], $_POST["go_{$power['power']}"]);
						}
						if($power['power'] == 252) {//Redirect
							if(ctype_alnum($_POST["go_{$power['power']}"])) {
								$_POST["go_{$power['power']}"] = htmlentities($_POST["go_{$power['power']}"]);
								$isReal = $mysql->fetch_array("select * from `chats` where `name`=:nm;", array('nm' => $_POST["go_{$power['power']}"]));
								if(empty($isReal))
									$_POST["go_{$power['power']}"] = "";
								else
									$_POST["go_{$power['power']}"] = $isReal[0]['name'];
							} else {
								$_POST["go_{$power['power']}"] = "";
							}
						}
						$mysql->query("update `chats` set `{$hasFunction[$power['power']]}`=:value where `name`=:chat", array('value' => $_POST["go_{$power['power']}"], 'chat' => $_POST['gn']));
					}
					$mysql->query("update `group_powers` set `enabled`=:status where `chat`=:chat and `power`=:power", array('status' => $status, 'power' => $power['power'], 'chat' => $_POST['gn']));
				}
				$chat = resetChatVar($_POST['gn'], true);
			}
?>
<!--
|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
| Edit Group
|‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒
!-->
<section class="section p-25">
	<div class="container">
		<div class="row gap-y">
			<div class="col-12">
		<table border="0" width="100%">
			<tr>
				<td rowspan="3" valign="top">
					<a name="top"></a>
					<form style="display: inline;" method="post">
						<input type="hidden" name="gn" value="<?= $_POST['gn']; ?>">
						<input type="hidden" name="gp" value="<?= $_POST['gp']; ?>">
						<input type="hidden" name="flags" value="<?= intval($chat->flag); ?>">
						<p><span>Group Description: 20-50 letters</span>
							<input class="form-control" style="width:95%" name="desc" type="text" value="<?= htmlspecialchars($chat->desc); ?>">
						</p>
						<p><span>Background:</span>
							<input class="form-control" style="width:95%" name="innr" type="text" value="<?= htmlspecialchars($chat->bg); ?>">
						</p>
						<p><span>Outer background:</span>
							<input class="form-control" style="width:95%" name="outr" type="text" value="<?= htmlspecialchars($chat->outter); ?>">
						</p>
						<?php
							$t = 0;
							$flags = intval($chat->flag);
							switch($flags &  ($f_MembersOnly | $f_MembersOnly2)) {
								case $f_MembersOnly: $t = 1; break; // members only so not OK
								case $f_MembersOnly2: $t = 2; break; // Reg only 
								case $f_MembersOnly | $f_MembersOnly2: $t = 3; break;// VIPS only
							}
						?>						
						<p>
							<span>
								<input type="checkbox" value="ON" name="members" <?php if($t == 1) print 'checked'; ?>>
								<a title="Note you can only make members when you or a moderator is online. (Consider starting with this turned off) -  this only effects newly joined users"> Make this chat for members only</a>
							</span>
						</p>						
						<p>
							<span>
								<input type="checkbox" value="ON" name="Live" <?php if ($flags & $f_Live) echo ' checked' ;?>>
								<a title="Not recommend for most chats.">Live mode: 100,000s can watch the chat as spectators.</a>
								<a title="Full documentation. Please read before setting live mode." href="//util.xat.com/wiki/index.php/Live">wiki</a>
							</span>
						</p>					
						<p>
							<span>
								<input type="checkbox" value="ON" name="registered" <?php if($t == 2) print 'checked'; ?>>
								<a title="This will keep unregistered users out unless you member them">Make this chat for registered users and members only</a>
							</span>
						</p>
						<p>
							<span>
								<input type="checkbox" value="ON" name="subscribers" <?php if($t == 3) print 'checked'; ?>>
								<a title="This will keep non subscribers out unless you member them">Make this chat for subscribers and members only</a>
							</span>
						</p>
						<p>
							<span>
								<input type="checkbox" value="ON" name="NoStore" <?php if($flags & $f_NoStore) print 'checked'; ?>>
								<a title="If you check this the chat box won't remember any messages ever.">Don't store chat messages</a>
							</span>
						</p>
						<p>
							<span>
								<input type="checkbox" value="ON" name="NoSmilieLine" <?php if($flags & $f_NoSmilieLine) print 'checked'; ?>>
								Don't display the line of Smilies
							</span>
						</p>
						<p>
							<span>
								<input type="checkbox" value="ON" name="DefNoSound" <?php if($flags & $f_DefNoSound) print 'checked'; ?>>
								 Default chat box sounds to OFF
							</span>
						</p>
                        <div class="row">
                            <div class="col-xs-6">
                                <span>Default language for chat box:</span>
                            </div>
                            <div class="col-xs-5">
                                <select class="form-control" name="Language">
                                <?php
                                    $handle = fopen("lang.dat", "r");
                                    $line = fread($handle, 10000);
                                    fclose($handle);

                                    $langs = explode(";==", "None;=None;==".$line);
                                    $sellang = $chat->langdef;
                                    if($sellang === "" || $sellang === "en") $sellang = "None";
                                    foreach ($langs as $v)
                                    {
                                        $langs2 = explode(";=", $v);
                                        echo '<option ';
                                        if($langs2[0] === $sellang)
                                            echo 'selected';
                                        $langs2[1] = str_replace('*', "", @$langs2[1]);

                                        echo ' value="'.$langs2[0].'">'.$langs2[1]."</option>\n";
                                    }
                                ?>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-3">
                                <span>Button color:</span>
                            </div>
                            <div class="col-xs-5">
                                <input class="form-control" name="ButCol" type="text" value="<?= htmlspecialchars($chat->button); ?>">
                            </div>
                            <div class="col-xs-4">
                                <span><small>E.g. #808000 or Red, Blue etc.</small></span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-3">
                                <span>Radio staion:</span>
                            </div>
                            <div class="col-xs-5">
                                <input class="form-control" name="Radio" type="text" value="<?= htmlspecialchars($chat->radio); ?>">
                            </div>
                            <div class="col-xs-4">
                                <span><small>See <a href="http://util.xat.com/wiki/index.php/Radios">wiki</a> for example radio stations.</small></span>
                            </div>
                        </div>
						<p><span>Click here to update your settings and preview the chat:</span></p>
						<p>
							<button class="btn btn-primary" type="submit" name="editc">Update Chat/Get Main</button>
						</p>
					</form>
				</td>
			</tr>
			<tr>
				<td valign="top" width="540">
					<p>&nbsp;</p>
					<p><label>Preview:</label>:</p>
					<div align="center">
						<?= $core->getEmbed($_POST['gn'], crc32($chat->pass), 540, 405); ?>
					</div>
				</td>
			</tr>
		</table>
		<br>		
		<a name="powers"></a>
		<h3 style="font-style:italic"><span>Group Powers</span></h3>
		<div class="row">
			<?php
 				$gp = $mysql->fetch_array("SELECT `power`,`assignedBy`,`enabled` FROM `group_powers` WHERE `chat`=:name ORDER BY `power` ASC", array("name" => $_POST['gn']));						
				$spowers = $mysql->fetch_array("select `id`, `name` from `powers`");
				$powers = array();
				foreach($spowers as $pow){
					$powers[$pow['id']] = $pow;
				}
				$hasFunction = array(74 => 'gline', 80 => 'gcontrol', 90 => 'bad', 92 => 'horrorflix', 96 => 'winterflix', 98 => 'feastflix', 100 => 'link', 102 => 'fairyflix', 106 => 'gscol', 108 => 'loveflix', 112 => 'announce', 114 => 'pools', 130 => 'gback', 148 => 'spookyflix', 150 => 'bot', 156 => 'santaflix', 180 => 'gsound', 188 => 'doodlerace', 192 => 'matchrace', 194 => 'snakerace', 200 => 'spacewar', 206 => 'lang', 224 => 'hearts', 238 => 'switch', 246 => 'darts', 256 => 'zwhack', 278 => 'springflix', 296 => 'summerflix');
				$hasRequirement = array(126 => 'Rankpool is required/must be enabled for Banpool to work.', 130 => 'Gscol is required/must be enabled to use Gback.');
				if(!empty($gp)) {
					print '<form method="post">';
					print '<input type="hidden" name="gn" value="' . $_POST['gn'] . '">';
					print '<input type="hidden" name="gp" value="' . $_POST['gp'] . '">';
					foreach($gp as $index => $power) {
						print '<input type="checkbox" name="gp_' . $power['power'] . '" ' . ($power['enabled'] == 1 ? 'checked':'') . '>';
						print '<img align="absmiddle" width="30" height="30" src="//ixat.io/images/smw/' . $powers[$power['power']]['name'] . '.png" ' . (isset($hasRequirement[$power['power']]) ? 'title="' . $hasRequirement[$power['power']] . '"':'') . ' />';
						print '<b>' . $powers[$power['power']]['name'] . '</b> - ';
						if(in_array($power['power'], array_keys($hasFunction))) {
							if(in_array($power['power'], array(80, 92, 96, 98, 102, 108, 114, 148, 156, 180, 188, 192, 194, 200, 206, 224, 238, 246, 256, 278, 296)))
								$chat->{$hasFunction[$power['power']]} = str_replace("'", '"', $chat->{$hasFunction[$power['power']]});
							print "<button class=\"btn btn-xs\" type=\"button\" onClick=\"window.open('../web_gear/chat/GroupOptionEdit.php?id={$power['power']}&roomid={$chat->id}&t=" . time() . "', 'Child{$power['power']}', 'height=600,width=600,resize=0&');Child{$power['power']}.focus()\"><i class=\"zmdi zmdi-wrench fa fa-wrench\"></i>&nbsp;Edit</button> ";  
							print "<input type=\"hidden\" name=\"go_{$power['power']}\" id=\"gi_{$power['power']}\" value='" . $chat->{$hasFunction[$power['power']]} . "'>";					
						}
						if($power['assignedBy'] == 0)
							print '<a href"#" target="_blank">(<span>Auto Assigned by ixat Admins</span>)</a><BR>';
						else
							print '<a href="//ixat.io/profile?u=' . $power['assignedBy'] . '" target="_blank">(<span>Assigned by: ' . $power['assignedBy'] . '</span>)</a><BR>';
					}
					print '<p><button class="btn btn-primary" type="submit" name="editgp"/><i class="zmdi zmdi-wrench fa fa-wrench"></i>&nbsp;<span>Update these options</span></button> </p>';
					print '</form>';
					print '<h3><span>Direct link - access your chat box without a website</span> </h3>';
					print '<p><b><span>To access your chat box directly:</span></b></p>';
					print "<p><input value='//ixat.io/ixat{$chat->id}' onfocus='this.select();' type='text' size='60'></p>";
				}
				unset($gp); 
			?>			
		</div>
	</div></div>	
</section>
<?php
		} else {
			print '<div class="alert alert-danger"><center>Incorrect group information</center></div>';
		}
	}
}
else {
?>
<section class="section">
	<div class="container">
		<div class="row gap-y">
			
			<div class="col-12 col-lg-4">
				<div class="card bg-gray">
					<div class="card-block">
						<h5 class="card-title">Edit chat group</h5>
						<form method="post">
							<table class="table">
								<tr> <td> Group Name: </td> <td><input class="form-control" type="text" name="gn"> </td> </tr>
								<tr> <td> Password: </td> <td><input class="form-control" type="password" name="gp"> </td> </tr>
							</table>
							<center><button class="btn btn-primary" type="submit"/>Edit Group</button></center>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
<?php
}

//Functions

function handleJson($id, $json) {
	if($json == "{}" || empty($json))
		return "";
	
	$json = json_decode($json, true);
	$allowedRanks = array(0, 2, 3, 5, 7, 8, 10, 11, 14);
	switch($id)  {
		case "80":
			$rankStuff = array('mg', 'mb', 'mm', 'kk', 'bn', 'ubn', 'ss', 'dnc', 'bdg', 'ns', 'yl', 'rc', 'ka', 'lkd', 'rgd', 'prm', 'bge', 'sme', 'rl', 'p', 'cbs', 'ssb', 'cm', 'j');
			foreach($rankStuff as $rank) { 
				if(isset($json[$rank]))
					$json[$rank] = is_numeric($json[$rank]) && in_array($json[$rank], $allowedRanks) ? $json[$rank]:0;
			}
			//Mod max ban time 0-99 (0 = forever)
			if(isset($json['mbt']))
				$json['mbt'] = is_numeric($json['mbt']) ? ($json['mbt'] > 99 || $json['mbt'] < 0 ? 6:$json['mbt']):6;
			
			//Owner max ban time 0-999 (0 = forever)
			if(isset($json['obt']))
				$json['obt'] = is_numeric($json['obt']) ? ($json['obt'] > 999 || $json['obt'] < 0 ? 0:$json['obt']):0;
			
			//Preferred blast 0-4
			if(isset($json['bst']))
				$json['bst'] = is_numeric($json['bst']) ? ($json['bst'] > 4 || $json['bst'] < 0 ? 0:$json['bst']):0;
			
			//Max toons
			if(isset($json['mxt']))
				$json['mxt'] = is_numeric($json['mxt']) ? ($json['mxt'] < 0 ? 10:$json['mxt']):10;
			
			//Ad position 0-2
			if(isset($json['ads']))
				$json['ads'] = is_numeric($json['ads']) ? ($json['ads'] > 2 || $json['ads'] < 0 ? 0:$json['ads']):0;
			
			//Red card factor 0.1-10
			if(isset($json['rf']))
				$json['rf'] = is_numeric($json['rf']) ? ($json['rf'] > 10 || $json['rf'] < 0.1 ? 6:$json['rf']):6;
			
			//Protect default
			if(isset($json['pd']))
				$json['pd'] = is_numeric($json['pd']) ? ($json['pd'] > 5 || $json['pd'] < 1 ? 1:$json['pd']):1;
			
			//Protect time (hours) 0.1-12
			if(isset($json['pt']))
				$json['pt'] = is_numeric($json['pt']) ? ($json['pt'] > 12 || $json['pt'] < 0.1 ? 1:$json['pt']):1;
			
			//Member flood trust 1-99
			if(isset($json['mft']))
				$json['mft'] = is_numeric($json['mft']) ? ($json['mft'] > 99 || $json['mft'] < 1 ? 4:$json['mft']):4;
			
			//Flood threshold 10-200
			if(isset($json['ft']))
				$json['ft'] = is_numeric($json['ft']) ? ($json['ft'] > 200 || $json['ft'] < 10 ? 50:$json['ft']):50;	

			//Can jinx same rank 0-1
			if(isset($json['js']))
				$json['js'] = is_numeric($json['js']) ? ($json['js'] > 1 || $json['js'] < 0 ? 0:$json['js']):0;
			
			//Mute max time 1-99
			if(isset($json['mmt']))
				$json['mmt'] = is_numeric($json['mmt']) ? ($json['mmt'] > 99 || $json['mmt'] < 1 ? 1:$json['mmt']):1;
			
		break;
		case "92":
			//Effect 'None','Skeleton','Eyes','Cauldron','Witch','Blood','Halloween'
			$json['ef'] = isset($json['ef']) && is_numeric($json['ef']) ? ($json['ef'] > 6 || $json['ef'] < 0 ? 1:$json['ef']):1;
			
			//Colors eg r#g or FF00FF#0000FF
			$json['col'] = isset($json['col']) ? htmlspecialchars(trim(substr($json['col'], 0, 26))):"";
			
			//Horizontal offset % (-100 to +100)
			$json['XX'] = isset($json['XX']) && is_numeric($json['XX']) ? ($json['XX'] > 100 || $json['XX'] < -100 ? "":$json['XX']):"";
			
			//Vertical offset % (-100 to +100)
			$json['YY'] = isset($json['YY']) && is_numeric($json['YY']) ? ($json['YY'] > 100 || $json['YY'] < -100 ? "":$json['YY']):"";	
			
			//Scale % (1-1000)
			$json['SC'] = isset($json['SC']) && is_numeric($json['SC']) ? ($json['SC'] > 1000 || $json['SC'] < 1 ? "":$json['SC']):"";	
			
			//Background 'None','Moon','Web','Haunted','Graveyard','Horror','Halloween'
			$json['bk'] = isset($json['bk']) && is_numeric($json['bk']) ? ($json['bk'] > 6 || $json['bk'] < 0 ? 1:$json['bk']):1;
	
			//Option
			$json['Opt'] = isset($json['Opt']) && is_numeric($json['Opt']) ? ($json['Opt'] > 3 || $json['Opt'] < 0 ? "":$json['Opt']):"";				
		break;		
		case "96":
			//Effect 'None','Santa sledge','Sleigh moon','Snowman','Santa chimney','Penguin march','Xmas tree'
			$json['ef'] = isset($json['ef']) && is_numeric($json['ef']) ? ($json['ef'] > 6 || $json['ef'] < 0 ? 1:$json['ef']):1;
			
			//Colors eg r#g or FF00FF#0000FF
			$json['col'] = isset($json['col']) ? htmlspecialchars(trim(substr($json['col'], 0, 26))):"";
			
			//Horizontal offset % (-100 to +100)
			$json['XX'] = isset($json['XX']) && is_numeric($json['XX']) ? ($json['XX'] > 100 || $json['XX'] < -100 ? "":$json['XX']):"";
			
			//Vertical offset % (-100 to +100)
			$json['YY'] = isset($json['YY']) && is_numeric($json['YY']) ? ($json['YY'] > 100 || $json['YY'] < -100 ? "":$json['YY']):"";	
			
			//Scale % (1-1000)
			$json['SC'] = isset($json['SC']) && is_numeric($json['SC']) ? ($json['SC'] > 1000 || $json['SC'] < 1 ? "":$json['SC']):"";	
			
			//Background 'None','Trees','Moon','Snow scape','Night sky'
			$json['bk'] = isset($json['bk']) && is_numeric($json['bk']) ? ($json['bk'] > 4 || $json['bk'] < 0 ? 1:$json['bk']):1;
	
			//Options No background', 'No snow', 'Flip
			$json['Opt'] = isset($json['Opt']) && is_numeric($json['Opt']) ? ($json['Opt'] > 3 || $json['Opt'] < 0 ? "":$json['Opt']):"";	
			
			//Tree Options 'Bauble', 'Glitter', 'Star', 'No back', 'Spin'
			$json['Opt'] = isset($json['Opt']) && is_numeric($json['Opt']) ? ($json['Opt'] > 31 || $json['Opt'] < 0 ? 7:$json['Opt']):7;	
			
			//Tree Bauble "circle", "star", "xatsat", "d"
			$json['BT'] = isset($json['BT']) && is_numeric($json['BT']) ? ($json['BT'] > 3 || $json['BT'] < 0 ? 0:$json['BT']):0;	
			
			//Bauble transparency
			$json['BA'] = isset($json['BA']) && is_numeric($json['BA']) ? ($json['BA'] > 100 || $json['BA'] < 10 ? "":$json['BA']):"";		
			
			//Glitter transparency
			$json['GA'] = isset($json['GA']) && is_numeric($json['GA']) ? ($json['GA'] > 100 || $json['GA'] < 10 ? "":$json['GA']):"";			
		break;
		case "98":
			//Effect 'None','Chef','Thanksgiving','Turkey','Lights'
			$json['ef'] = isset($json['ef']) && is_numeric($json['ef']) ? ($json['ef'] > 4 || $json['ef'] < 0 ? 1:$json['ef']):1;

			//Horizontal offset % (-100 to +100)
			$json['XX'] = isset($json['XX']) && is_numeric($json['XX']) ? ($json['XX'] > 100 || $json['XX'] < -100 ? "":$json['XX']):"";
			
			//Vertical offset % (-100 to +100)
			$json['YY'] = isset($json['YY']) && is_numeric($json['YY']) ? ($json['YY'] > 100 || $json['YY'] < -100 ? "":$json['YY']):"";	
			
			//Scale % (1-1000)
			$json['SC'] = isset($json['SC']) && is_numeric($json['SC']) ? ($json['SC'] > 1000 || $json['SC'] < 1 ? "":$json['SC']):"";	
			
			//Background 'None'
			$json['bk'] = isset($json['bk']) && is_numeric($json['bk']) ? ($json['bk'] > 1 || $json['bk'] < 0 ? 1:$json['bk']):1;
	
			//Thanksgiving Options 'Background','IndianF','IndianM','PilgrimF','PilgrimM'
			$json['Opt'] = isset($json['Opt']) && is_numeric($json['Opt']) ? ($json['Opt'] > 31 || $json['Opt'] < 0 ? 31:$json['Opt']):31;				
		break;
		case "102":
			//Effect 'None','Leaves','Fairy','Butterfly','Fairy dust'
			$json['ef'] = isset($json['ef']) && is_numeric($json['ef']) ? ($json['ef'] > 4 || $json['ef'] < 0 ? 1:$json['ef']):1;
			
			//Background 'None'
			$json['bk'] = isset($json['bk']) && is_numeric($json['bk']) ? ($json['bk'] > 1 || $json['bk'] < 0 ? 1:$json['bk']):1;
				
			//Colors eg r#g or FF00FF#0000FF
			$json['col'] = isset($json['col']) ? htmlspecialchars(trim(substr($json['col'], 0, 26))):"";
			
			//Horizontal offset % (-100 to +100)
			$json['XX'] = isset($json['XX']) && is_numeric($json['XX']) ? ($json['XX'] > 100 || $json['XX'] < -100 ? "":$json['XX']):"";
			
			//Vertical offset % (-100 to +100)
			$json['YY'] = isset($json['YY']) && is_numeric($json['YY']) ? ($json['YY'] > 100 || $json['YY'] < -100 ? "":$json['YY']):"";	
			
			//Scale % (1-1000)
			$json['SC'] = isset($json['SC']) && is_numeric($json['SC']) ? ($json['SC'] > 1000 || $json['SC'] < 1 ? "":$json['SC']):"";				
		break;	
		case "108":
			//Effect 'None','Leaves','Fairy','Butterfly','Fairy dust'
			$json['ef'] = isset($json['ef']) && is_numeric($json['ef']) ? ($json['ef'] > 4 || $json['ef'] < 0 ? 1:$json['ef']):1;
			
			//Background 'None'
			$json['bk'] = isset($json['bk']) && is_numeric($json['bk']) ? ($json['bk'] > 1 || $json['bk'] < 0 ? 1:$json['bk']):1;
				
			//Colors eg r#g or FF00FF#0000FF
			$json['col'] = isset($json['col']) ? htmlspecialchars(trim(substr($json['col'], 0, 26))):"";
			
			//Horizontal offset % (-100 to +100)
			$json['XX'] = isset($json['XX']) && is_numeric($json['XX']) ? ($json['XX'] > 100 || $json['XX'] < -100 ? "":$json['XX']):"";
			
			//Vertical offset % (-100 to +100)
			$json['YY'] = isset($json['YY']) && is_numeric($json['YY']) ? ($json['YY'] > 100 || $json['YY'] < -100 ? "":$json['YY']):"";	
			
			//Scale % (5-1000)
			$json['SC'] = isset($json['SC']) && is_numeric($json['SC']) ? ($json['SC'] > 1000 || $json['SC'] < 5 ? "":$json['SC']):"";
				
			//Smiley eg beat
			$json['SM'] = isset($json['SM']) && is_numeric($json['SM']) ? ($json['SM'] > 15 || $json['SM'] < 5 ? "":$json['SM']):"";
			
			//Options 'No background', 'No text'
			$json['Opt'] = isset($json['Opt']) && is_numeric($json['Opt']) ? ($json['Opt'] > 3 || $json['Opt'] < 0 ? 0:$json['Opt']):0;				
		break;	
		case "114":
			
			//Main Pool Name
			$json['m'] = isset($json['m']) && ctype_alnum($json['m']) && $json['m'] != "" ? htmlentities($json['m']) : 'Main';
			
			//Rank Pool Name
			$json['t'] = isset($json['t']) && ctype_alnum($json['t']) && $json['t'] != "" ? htmlentities($json['t']) : 'Ranked';
			
			//Rank Pool Rank
			$json['rnk'] = isset($json['rnk']) && is_numeric($json['rnk']) && in_array($json['rnk'], $allowedRanks) ? $json['rnk'] : 3;
			
			//Ban Pool Name
			$json['b'] = isset($json['b']) && ctype_alnum($json['b']) && $json['b'] != "" ? htmlentities($json['b']) : 'Banned';	
			
			//Ban Pool Rank
			$json['brk'] = isset($json['brk']) && is_numeric($json['brk']) && in_array($json['brk'], $allowedRanks) ? $json['brk'] : 7;			
		break;
		case "148":
			//Effect 'None','Candles','Organ','Spider','Owl','Evil eyes','Cat'
			$json['ef'] = isset($json['ef']) && is_numeric($json['ef']) ? ($json['ef'] > 6 || $json['ef'] < 0 ? 1:$json['ef']):1;

			//Horizontal offset % (-100 to +100)
			$json['XX'] = isset($json['XX']) && is_numeric($json['XX']) ? ($json['XX'] > 100 || $json['XX'] < -100 ? "":$json['XX']):"";
			
			//Vertical offset % (-100 to +100)
			$json['YY'] = isset($json['YY']) && is_numeric($json['YY']) ? ($json['YY'] > 100 || $json['YY'] < -100 ? "":$json['YY']):"";	
			
			//Scale % (1-1000)
			$json['SC'] = isset($json['SC']) && is_numeric($json['SC']) ? ($json['SC'] > 1000 || $json['SC'] < 1 ? "":$json['SC']):"";	
			
			//Background 'None','Pumkins','Owl','Evil eyes','Cat'
			$json['bk'] = isset($json['bk']) && is_numeric($json['bk']) ? ($json['bk'] > 4 || $json['bk'] < 0 ? 1:$json['bk']):1;			
		break;
		case "156":
			//Effect 'None','Baubles','Santa','Present'
			$json['ef'] = isset($json['ef']) && is_numeric($json['ef']) ? ($json['ef'] > 3 || $json['ef'] < 0 ? 1:$json['ef']):1;

			//Horizontal offset % (-100 to +100)
			$json['XX'] = isset($json['XX']) && is_numeric($json['XX']) ? ($json['XX'] > 100 || $json['XX'] < -100 ? "":$json['XX']):"";
			
			//Vertical offset % (-100 to +100)
			$json['YY'] = isset($json['YY']) && is_numeric($json['YY']) ? ($json['YY'] > 100 || $json['YY'] < -100 ? "":$json['YY']):"";	
			
			//Scale % (1-1000)
			$json['SC'] = isset($json['SC']) && is_numeric($json['SC']) ? ($json['SC'] > 1000 || $json['SC'] < 1 ? "":$json['SC']):"";	
			
			//Background 'None','Santas','Moon','Gift'
			$json['bk'] = isset($json['bk']) && is_numeric($json['bk']) ? ($json['bk'] > 3 || $json['bk'] < 0 ? 1:$json['bk']):1;	
			
			//Glitter "all","star", "burst", "xatsat", "d"
			$json['GT'] = isset($json['GT']) && is_numeric($json['GT']) ? ($json['GT'] > 4 || $json['GT'] < 0 ? 0:$json['GT']):0;			
			
			//Number of stars % (10-100)
			$json['NUM'] = isset($json['NUM']) && is_numeric($json['NUM']) ? ($json['NUM'] > 100 || $json['NUM'] < 10 ? "":$json['NUM']):"";	
			
			//Present On,Off
			$json['PR'] = isset($json['PR']) && is_numeric($json['PR']) ? ($json['PR'] > 100 || $json['PR'] < 10 ? 0:$json['PR']):0;	
		break;		
		case "180":
			//Message Sound 
			$json['m'] = isset($json['m']) && ctype_alpha($json['m']) && strlen($json['m']) < 20 ? $json['m'] : 'clickfast';
			
			//User Sound
			$json['d'] = isset($json['d']) && ctype_alpha($json['d']) && strlen($json['d']) < 20 ? $json['d'] : 'computerbeep';
			
			//Tab Sound
			$json['t'] = isset($json['t']) && ctype_alpha($json['t']) && strlen($json['t']) < 20 ? $json['t'] : 'swing';
		break;
		case "188":
			$json['rnk'] = isset($json['rnk']) && is_numeric($json['rnk']) && in_array($json['rnk'], $allowedRanks) ? $json['rnk'] : 3;
			$json['dt'] = isset($json['dt']) && is_numeric($json['dt']) ? ($json['dt'] > 3600 || $json['dt'] < 10 ? 60:$json['dt']):60;
			$json['lv'] = isset($json['lv']) && is_numeric($json['lv']) ? ($json['lv'] > 99 || $json['lv'] < 1 ? 1:$json['lv']):1;
			$json['rt'] = isset($json['rt']) && is_numeric($json['rt']) ? ($json['rt'] > 600 || $json['rt'] < 10 ? 10:$json['rt']):10;
			$json['st'] = isset($json['st']) && is_numeric($json['st']) ? ($json['st'] > 600 || $json['st'] < 10 ? 60:$json['st']):60;
			$json['o'] = isset($json['o']) && is_numeric($json['o']) ? ($json['o'] > 2 || $json['o'] < 0 ? 0:$json['o']):0;
		break;
		case "192":
			$json['rnk'] = isset($json['rnk']) && is_numeric($json['rnk']) && in_array($json['rnk'], $allowedRanks) ? $json['rnk'] : 3;
			$json['dt'] = isset($json['dt']) && is_numeric($json['dt']) ? ($json['dt'] > 900 || $json['dt'] < 10 ? 60:$json['dt']):60;
			$json['lv'] = isset($json['lv']) && is_numeric($json['lv']) ? ($json['lv'] > 99 || $json['lv'] < 1 ? 1:$json['lv']):1;
			$json['rt'] = isset($json['rt']) && is_numeric($json['rt']) ? ($json['rt'] > 600 || $json['rt'] < 10 ? 10:$json['rt']):10;
		break;
		case "194":
			$json['rnk'] = isset($json['rnk']) && is_numeric($json['rnk']) && in_array($json['rnk'], $allowedRanks) ? $json['rnk'] : 3;
			$json['dt'] = isset($json['dt']) && is_numeric($json['dt']) ? ($json['dt'] > 900 || $json['dt'] < 10 ? 60:$json['dt']):60;
			$json['lv'] = isset($json['lv']) && is_numeric($json['lv']) ? ($json['lv'] > 99 || $json['lv'] < 1 ? 1:$json['lv']):1;
			$json['rt'] = isset($json['rt']) && is_numeric($json['rt']) ? ($json['rt'] > 600 || $json['rt'] < 10 ? 10:$json['rt']):10;
		break;
		case "206":
			//FUCK OFF to much work.
			foreach($json as $key => $value) {
				$json[$key] = @mb_convert_encoding(htmlentities(html_entity_decode($value)), "UTF-8", "auto");
			}
			return json_encode($json);// bypass he str replace becuase we cant dop thatw ith lang
		break;
		case "200":
			$json['rnk'] = isset($json['rnk']) && is_numeric($json['rnk']) && in_array($json['rnk'], $allowedRanks) ? $json['rnk'] : 3;
			$json['dt'] = isset($json['dt']) && is_numeric($json['dt']) ? ($json['dt'] > 900 || $json['dt'] < 10 ? 300:$json['dt']):300;
			$json['lv'] = isset($json['lv']) && is_numeric($json['lv']) ? ($json['lv'] > 99 || $json['lv'] < 1 ? 1:$json['lv']):1;
			$json['rt'] = isset($json['rt']) && is_numeric($json['rt']) ? ($json['rt'] > 600 || $json['rt'] < 10 ? 10:$json['rt']):10;
			$json['lm'] = isset($json['lm']) && is_numeric($json['lm']) ? ($json['lm'] > 1 || $json['lm'] < 0 ? 0:$json['lm']):0;
			
		break;
		case "224":
			$json['rnk'] = isset($json['rnk']) && is_numeric($json['rnk']) && in_array($json['rnk'], $allowedRanks) ? $json['rnk'] : 5;
			$json['dt'] = isset($json['dt']) && is_numeric($json['dt']) ? ($json['dt'] > 900 || $json['dt'] < 10 ? 60:$json['dt']):60;
			$json['lv'] = isset($json['lv']) && is_numeric($json['lv']) ? ($json['lv'] > 99 || $json['lv'] < 1 ? 1:$json['lv']):1;
			$json['rt'] = isset($json['rt']) && is_numeric($json['rt']) ? ($json['rt'] > 600 || $json['rt'] < 10 ? 10:$json['rt']):10;
		break;
		case "238":
			$json['rnk'] = isset($json['rnk']) && is_numeric($json['rnk']) && in_array($json['rnk'], $allowedRanks) ? $json['rnk'] : 5;
		break;
		case "246":
			$json['rnk'] = isset($json['rnk']) && is_numeric($json['rnk']) && in_array($json['rnk'], $allowedRanks) ? $json['rnk'] : 3;
			$json['dt'] = isset($json['dt']) && is_numeric($json['dt']) ? ($json['dt'] > 43200 || $json['dt'] < 10 ? 60:$json['dt']):60;
			$json['rt'] = isset($json['rt']) && is_numeric($json['rt']) ? ($json['rt'] > 600 || $json['rt'] < 10 ? 10:$json['rt']):10;
			$json['rc'] = isset($json['rc']) && is_numeric($json['rc']) ? ($json['rc'] > 1 || $json['rc'] < 0 ? 0:$json['rc']):0;
			$json['tg'] = isset($json['tg']) && is_numeric($json['tg']) ? ($json['tg'] > 1000000 || $json['tg'] < 100 ? 5000:$json['tg']):5000;
			$json['pz'] = isset($json['pz']) ? htmlspecialchars(trim($json['pz'])):"";
		break;
		case "256":
			$json['rnk'] = isset($json['rnk']) && is_numeric($json['rnk']) && in_array($json['rnk'], $allowedRanks) ? $json['rnk'] : 3;
			$json['dt'] = isset($json['dt']) && is_numeric($json['dt']) ? ($json['dt'] > 43200 || $json['dt'] < 10 ? 60:$json['dt']):60;
			$json['rt'] = isset($json['rt']) && is_numeric($json['rt']) ? ($json['rt'] > 600 || $json['rt'] < 10 ? 10:$json['rt']):10;
			$json['rc'] = isset($json['rc']) && is_numeric($json['rc']) ? ($json['rc'] > 1 || $json['rc'] < 0 ? 0:$json['rc']):0;
			$json['tg'] = isset($json['tg']) && is_numeric($json['tg']) ? ($json['tg'] > 1000000 || $json['tg'] < 100 ? 2000:$json['tg']):2000;
			$json['pz'] = isset($json['pz']) ? htmlspecialchars(trim($json['pz'])):"";
		break;
		case "278":
			//Effect 'None','Flower grow','Random flowers','Butterfly','Sunflowers','Spring'
			$json['ef'] = isset($json['ef']) && is_numeric($json['ef']) ? ($json['ef'] > 5 || $json['ef'] < 0 ? 1:$json['ef']):1;
			
			//Background 'None'
			$json['bk'] = isset($json['bk']) && is_numeric($json['bk']) ? ($json['bk'] > 1 || $json['bk'] < 0 ? 1:$json['bk']):1;
			
			//Horizontal offset % (-100 to +100)
			$json['XX'] = isset($json['XX']) && is_numeric($json['XX']) ? ($json['XX'] > 100 || $json['XX'] < -100 ? "":$json['XX']):"";
			
			//Vertical offset % (-100 to +100)
			$json['YY'] = isset($json['YY']) && is_numeric($json['YY']) ? ($json['YY'] > 100 || $json['YY'] < -100 ? "":$json['YY']):"";	
			
			//Scale % (1-1000)
			$json['SC'] = isset($json['SC']) && is_numeric($json['SC']) ? ($json['SC'] > 1000 || $json['SC'] < 1 ? "":$json['SC']):"";				
		break;	
		case "296":
			//Effect 'None','Beach','Sun','Fan','Hammock','Crab'
			$json['ef'] = isset($json['ef']) && is_numeric($json['ef']) ? ($json['ef'] > 5 || $json['ef'] < 0 ? 1:$json['ef']):1;
			
			//Background 'None'
			$json['bk'] = isset($json['bk']) && is_numeric($json['bk']) ? ($json['bk'] > 1 || $json['bk'] < 0 ? 1:$json['bk']):1;
			
			//Horizontal offset % (-100 to +100)
			$json['XX'] = isset($json['XX']) && is_numeric($json['XX']) ? ($json['XX'] > 100 || $json['XX'] < -100 ? "":$json['XX']):"";
			
			//Vertical offset % (-100 to +100)
			$json['YY'] = isset($json['YY']) && is_numeric($json['YY']) ? ($json['YY'] > 100 || $json['YY'] < -100 ? "":$json['YY']):"";	
			
			//Scale % (1-1000)
			$json['SC'] = isset($json['SC']) && is_numeric($json['SC']) ? ($json['SC'] > 1000 || $json['SC'] < 1 ? "":$json['SC']):"";

			//Options 'No background'
			$json['Opt'] = isset($json['Opt']) && is_numeric($json['Opt']) ? ($json['Opt'] > 1 || $json['Opt'] < 0 ? 0:$json['Opt']):0;				
		break;			
	}
	return str_replace('"', "'", json_encode($json));
}

function resetChatVar($gn, $object = false) {
	global $mysql;
	$chat = $mysql->fetch_array('select * from `chats` where `name`=:name', array('name' => $gn));
	return $object == true? (object)$chat[0]:$chat;
}

function GetColor($str) {
$ColArray = array(
'aliceblue','#F0F8FF',
'antiquewhite','#FAEBD7',
'aqua','#00FFFF',
'aquamarine','#7FFFD4',
'azure','#F0FFFF',
'beige','#F5F5DC',
'bisque','#FFE4C4',
'black','#000000',
'blanchedalmond','#FFEBCD',
'blue','#0000FF',
'blueviolet','#8A2BE2',
'brown','#A52A2A',
'burlywood','#DEB887',
'cadetblue','#5F9EA0',
'chartreuse','#7FFF00',
'chocolate','#D2691E',
'coral','#FF7F50',
'cornflowerblue','#6495ED',
'cornsilk','#FFF8DC',
'crimson','#DC143C',
'cyan','#00FFFF',
'darkblue','#00008B',
'darkcyan','#008B8B',
'darkgoldenrod','#B8860B',
'darkgray','#A9A9A9',
'darkgreen','#006400',
'darkkhaki','#BDB76B',
'darkmagenta','#8B008B',
'darkolivegreen','#556B2F',
'darkorange','#FF8C00',
'darkorchid','#9932CC',
'darkred','#8B0000',
'darksalmon','#E9967A',
'darkseagreen','#8FBC8F',
'darkslateblue','#483D8B',
'darkslategray','#2F4F4F',
'darkturquoise','#00CED1',
'darkviolet','#9400D3',
'deeppink','#FF1493',
'deepskyblue','#00BFFF',
'dimgray','#696969',
'dodgerblue','#1E90FF',
'feldspar','#D19275',
'firebrick','#B22222',
'floralwhite','#FFFAF0',
'forestgreen','#228B22',
'fuchsia','#FF00FF',
'gainsboro','#DCDCDC',
'ghostwhite','#F8F8FF',
'gold','#FFD700',
'goldenrod','#DAA520',
'gray','#808080',
'green','#008000',
'greenyellow','#ADFF2F',
'honeydew','#F0FFF0',
'hotpink','#FF69B4',
'indianred',' #CD5C5C',
'indigo',' #4B0082',
'ivory','#FFFFF0',
'khaki','#F0E68C',
'lavender','#E6E6FA',
'lavenderblush','#FFF0F5',
'lawngreen','#7CFC00',
'lemonchiffon','#FFFACD',
'lightblue','#ADD8E6',
'lightcoral','#F08080',
'lightcyan','#E0FFFF',
'lightgoldenrodyellow','#FAFAD2',
'lightgrey','#D3D3D3',
'lightgreen','#90EE90',
'lightpink','#FFB6C1',
'lightsalmon','#FFA07A',
'lightseagreen','#20B2AA',
'lightskyblue','#87CEFA',
'lightslateblue','#8470FF',
'lightslategray','#778899',
'lightsteelblue','#B0C4DE',
'lightyellow','#FFFFE0',
'lime','#00FF00',
'limegreen','#32CD32',
'linen','#FAF0E6',
'magenta','#FF00FF',
'maroon','#800000',
'mediumaquamarine','#66CDAA',
'mediumblue','#0000CD',
'mediumorchid','#BA55D3',
'mediumpurple','#9370D8',
'mediumseagreen','#3CB371',
'mediumslateblue','#7B68EE',
'mediumspringgreen','#00FA9A',
'mediumturquoise','#48D1CC',
'mediumvioletred','#C71585',
'midnightblue','#191970',
'mintcream','#F5FFFA',
'mistyrose','#FFE4E1',
'moccasin','#FFE4B5',
'navajowhite','#FFDEAD',
'navy','#000080',
'oldlace','#FDF5E6',
'olive','#808000',
'olivedrab','#6B8E23',
'orange','#FFA500',
'orangered','#FF4500',
'orchid','#DA70D6',
'palegoldenrod','#EEE8AA',
'palegreen','#98FB98',
'paleturquoise','#AFEEEE',
'palevioletred','#D87093',
'papayawhip','#FFEFD5',
'peachpuff','#FFDAB9',
'peru','#CD853F',
'pink','#FFC0CB',
'plum','#DDA0DD',
'powderblue','#B0E0E6',
'purple','#800080',
'red','#FF0000',
'rosybrown','#BC8F8F',
'royalblue','#4169E1',
'saddlebrown','#8B4513',
'salmon','#FA8072',
'sandybrown','#F4A460',
'seagreen','#2E8B57',
'seashell','#FFF5EE',
'sienna','#A0522D',
'silver','#C0C0C0',
'skyblue','#87CEEB',
'slateblue','#6A5ACD',
'slategray','#708090',
'snow','#FFFAFA',
'springgreen','#00FF7F',
'steelblue','#4682B4',
'tan','#D2B48C',
'teal','#008080',
'thistle','#D8BFD8',
'tomato','#FF6347',
'turquoise','#40E0D0',
'violet','#EE82EE',
'violetred','#D02090',
'wheat','#F5DEB3',
'white','#FFFFFF',
'whitesmoke','#F5F5F5',
'yellow','#FFFF00',
'yellowgreen','#9ACD32');

    $s = str_replace(array(" ", "\t"), "", strtolower($str));
    $n = 0;
    $m = -1;
    $l = 0;
    while(1)  {
        $pos = @strpos($s, $ColArray[$n]);
        $len = @strlen($ColArray[$n]);
        if($len === 0) break;

        if ($pos !== false) {
            if($len > $l)  {
                $l = $len;
                $m = $n;
            }
        }
        $n += 2;
    }
    if($m >= 0) return $ColArray[$m+1];
    return htmlspecialchars(trim($str));
}

function Restrict($a)
{
	$restrict = explode(',', "22,23,24,134");
	$block = explode(',', "233,225,226,227,228,229,230,231,232,234,235,149,162,181,202,99,100,182,184,183,165,214,251,205,208");
	
	foreach($restrict as $v)
		if($t = $a[$v]) 
		{
			$t = rangetrim($t, '[^A-Za-z0-9 ]', 100);
			$a[$v] = $t;
		}
	
	foreach($block as $v) unset($a[$v]);
	
	foreach($a as $i=>$v) // restrict to 2 smilies
		if(substr_count($v, '(') > 2)
			$a[$i] = str_replace ('(', '[', $v);
	
	return $a;
}

?>
