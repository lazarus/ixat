<?php 
/*

echo "<BR>====== d =====<BR>" . $_REQUEST['d'];
echo "<BR>====== i =====<BR>" . $_REQUEST['i'];
echo "<BR>====== g =====<BR>" . $_REQUEST['g'];
echo "<BR>==============<BR>";
     my_Var.d = UnfairMessage;
     my_Var.send("http://web.xat.com/report/data.php?i=" + UnfairFile + "&g=" + UnfairGroupName, "_blank", "POST");
*/


$i = $_REQUEST['i'];

//if(strlen($i) < 10) exit;

$d = fopen("reports/$i.dat", "w");
fwrite($d, $_REQUEST['d']);
fclose($d);
?>
