<?php
require_once('/var/www/html/web_gear/chat/htmlhead.php');
$xp=array('ad'=>'top', 'title'=>'Unmoderate moderator', 'cache'=>3600, 'forcedom'=>'web.xat.com','meta'=>array('xt'=>'chat')); // 

HtmlHead2();
?>
<h3><span data-localize=chat.unmod>Unmoderate moderator</span></h3>
<div style="display:none">
<span data-localize=chat.yesunmod>Yes - UnModerate</span>
<span data-localize=chat.sureunmod>Are you sure you want to Un-moderate</span>
<span data-localize=chat.chatconf>Please confirm make guest in chat box</span>
</div>
<?php
if($_REQUEST['Submit'])
{
$fv = "id=".intval($_REQUEST['g'])."&um=".intval($_REQUEST['u']) ;

echo '
<p><span data-localize=chat.chatconf>Please confirm make guest in chat box</span>:</p>
<embed src=http://www.ixat.io/web_gear/chat/chat.swf quality=high bgcolor=#000000 width=600 height=400 name=chat FlashVars="'.$fv.'" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.ixat.io/update_flash.shtml" />
';
}
else
{
echo '
<p><span data-localize=chat.sureunmod>Are you sure you want to Un-moderate</span>: '.mytrim($_REQUEST['n']).'?</p>

<form method="POST">
  <button name="Submit" type="submit" id="submit" value="Send" class="btn"><i class="icon-thumbs-down"></i>&nbsp;<span data-localize=chat.yesunmod>Yes - UnModerate</span></button> 
  
  <input type="hidden" name="u" value="'.intval($_REQUEST['u']).'">
  <input type="hidden" name="g" value="'.intval($_REQUEST['g']).'">
  <input type="hidden" name="n" value="'.mytrim($_REQUEST['n']).'">
</form>

';
}

EndHtml2();

function mytrim($s)
{
	$s = str_replace('<', ' ', $s);
	$s = str_replace('>', ' ', $s);
	$s = str_replace(';', '', $s);
	$s = str_replace('#', '', $s);
	$s = str_replace('%', '', $s);
	$s = str_replace('&', '', $s);
	$s = str_replace('fromCharCode', 'nope', $s);
	return str_replace('"', '', trim($s));
}

function ErrHtml($s)
{
	return '<p style="color:#FF0000"><strong>**'. "$s**</strong></p> \n" ;
}

?>