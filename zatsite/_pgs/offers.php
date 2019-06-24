<?php
	if(!isset($config->complete))
	{
		return include $pages['setup'];
	}
	if(!isset($core->user))
	{
		return include $pages['profile'];
	}
	
	define('KEY', 'sirrmzpntgg.762691817551');
	print '<section class="section">
	<div class="container">
		<div class="row gap-y">
			<div class="col-12 col-lg-12">';
	print outputWidget($core->user->getID(), 'p3_1');
	print outputWidget($core->user->getID(), 's1_1');
	print '</div></div></div></section>';
	
	function outputWidget($id, $widget)
	{
		$query = array(
			'h' => KEY,
			'uid' => $id,
			'widget' => $widget
		);
		$query = http_build_query($query);
		return "<center><iframe src=\"https://wall.superrewards.com/super/offers?{$query}\" width=\"750\" height=\"800\" frameborder=\"0\" </iframe></center>";
	}
?>
