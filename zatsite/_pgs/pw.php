<?php
	if(!isset($config->complete))
	{
		return include $pages['setup'];
	}
	if(!isset($core->user))
	{
		return include $pages['profile'];
	}
	
	define('KEY', 'c1d49a1825b534b410f01398b69c3051');
	print '<div class="container-fluid"><section class="content">';
	print '<div class="row">';
	print outputWidget($core->user->getID(), 'p3_1');
	print outputWidget($core->user->getID(), 's1_1');
	print '</div></section></div>';
	
	function outputWidget($id, $widget)
	{
		$query = array(
			'key' => KEY,
			'uid' => $id,
			'widget' => $widget
		);
		$query = http_build_query($query);
		return "<center><iframe src=\"https://api.paymentwall.com/api/ps/?{$query}\" width=\"750\" height=\"800\" frameborder=\"0\" </iframe></center>";
	}
?>
