<html>
<?php
$gp = array(74,80,90,92,96,98,100,102,106,108,112,114,130,148,150,156,180,188,192,194,200,206,224,238,246,252,256,278,300);
if(isset($_GET['id']) && is_numeric($_GET['id']) && in_array($_GET['id'], $gp))
{
	print '
		<head>
		<title>zat group option edit</title>
		<script language="javaScript">
	';
	print file_get_contents("/usr/share/nginx/html/web_gear/chat/goe/js/{$_GET['id']}.js");//changeme
	print '
		</script>
		</head>
		<body onLoad="window.focus();Load()">
		<center>
		<div id="title">zat group option edit</div>
	';
	print file_get_contents("/usr/share/nginx/html/web_gear/chat/goe/html/{$_GET['id']}.html");//changeme
	print '
		</center>
		</body>
	';
}
else
{			
	print '
		<head>
			<title>zat group option edit</title>
		</head>
	';	
}
?>
<style type="text/css">
	body {
		background-color: #DBE8F9;
		font: 11px/24px "Lucida Grande", "Trebuchet MS", Arial, Helvetica, sans-serif;
		color: #5A698B;
	}
	#title {
		width: 330px;
		height: 26px;
		color: #5A698B;
		font: bold 11px/18px "Lucida Grande", "Trebuchet MS", Arial, Helvetica, sans-serif;
		padding-top: 5px;
		background: transparent;
		text-transform: upper;
		letter-spacing: 2px;
		text-align: center;
	}
	form { width: 335px; }
	.input {
		background-color: #fff;
		font: 11px/14px "Lucida Grande", "Trebuchet MS", Arial, Helvetica, sans-serif;
		color: #5A698B;
		margin: 4px 0 5px 8px;
		padding: 1px;
		border: 1px solid #8595B2;
	}
	.textarea {
		border: 1px solid #8595B2;
		background-color: #fff;
		font: 11px/14px "Lucida Grande", "Trebuchet MS", Arial, Helvetica, sans-serif;
		color: #5A698B;
		margin: 4px 0 5px 8px;
	}
</style>
</html>