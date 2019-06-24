<?php
if(!isset($_GET['id']) || !isset($_GET['GroupName']))
{
	return include $pages['home'];
}
if(!ctype_alnum($_GET['GroupName']) || strlen($_GET['GroupName']) < 5 || strlen($_GET['GroupName']) > 15)
{
	return include $pages['home'];
}
else
{
	$_GET['GroupName'] = htmlentities($_GET['GroupName']);
}
if(isset($_POST['width']) && is_numeric($_POST['width']) && isset($_POST['height']) && is_numeric($_POST['height']))
{
	list($width, $height) = array($_POST['width'], $_POST['height']);
}
else
{
	list($width, $height) = array(728, 468);
}
?>
<section class="section bg-gray p-25">
	<div class="container">
		<div class="row gap-y">
			<div class="col-12 col-lg-10 offset-lg-1">
				<div class="card">
					<div class="card-block">
						<h5 class="card-title"><?= $_GET['GroupName']; ?>: Put ixat chat group on your page</h5>
						<form method="post">
							<input type="hidden" name="GroupName" value="<?= $_GET['GroupName']; ?>">
							<input type="hidden" name="id" value="<?= $_GET['id']; ?>">
							<span>Width</span>: <input name="width" value="<?= $width;?>">
							<span>Height</span>: <input name="height" value="<?= $height;?>">
							&nbsp;&nbsp;
							<button type="submit" class="btn" name="submit">Change Size</button>
						</form>
						<p>Preview of how the chat group will look on your page:</p>
						<?= getEmbedText($width, $height); ?>
						<p>
							<div class="col-xs-4"></div>
							<div class="col-xs-4"><textarea class="form-control" rows="4" onClick="this.focus();this.select();"><?= getEmbedText($width, $height); ?></textarea></div>
							<div class="col-xs-4"></div>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
<?php
function getEmbedText($w, $h)
{
	global $mysql, $core;
	$chat = $mysql->fetch_array('select * from `chats` where `name`=:a or `id`=:b;', array('a' => $_GET['GroupName'], 'b' => $_GET['id']));
	
	if(empty($chat))
			return;
	
	$chat = (object) $chat[0];
	$attached = '';
	if($chat->attached!=''){
		$attached = $chat->attached;
	}
	if($chat->name!=''){
		$Group = "&gn=".$chat->name;
	} else {
			$Group = '';
	}
	$uChat = 'chat.swf&v=' . core::version;
	$flashVars = "id={$chat->id}{$Group}&xc=2336&cn={$core->cn}&gb=9U6Gr&v=" .core::version;
		$src = "http://ixat.io/cache/cache.php?f={$uChat}&d=flash";
	$embed = '<embed src="' . $src . '" quality="high" wmode="transparent" bgcolor="#000000" width="' . $w . '" height="' . $h . '" name="chat" FlashVars="' . $flashVars . '" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash"/>';
	return $embed . '<br><small><a target="_BLANK" href="http://ixat.io/embed?id=' . $chat->id . '&GroupName=' . $chat->name . '">Get ' . $chat->name . ' chat group</a> | <a target="_BLANK" href="http://ixat.io/' . $chat->name . '"> Goto ' . $chat->name . ' website</a></small><br><p>&nbsp;</p>';
}
?>