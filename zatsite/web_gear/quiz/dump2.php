<?php
error_reporting(E_ALL ^ E_NOTICE);
include('connect.php');

//  $root = 'http://www.xat.com/web_gear' ;


?>
<html>  
<head><title>Chris' wizzo chat dumper ;-)</title></head>  
<body>  
To limit lines: dumpa.php?m1=1&m2=3   (dump 1-3)<BR>
<?php
$m1 = intval($_GET['m1']);
$m2 = intval($_GET['m2']);
if($m2 < 1) $m2 = 9999999;


dump_table("wgquiz WHERE ID BETWEEN $m1 AND $m2 ORDER BY ID");

mysql_close();

function dump_table($table)
{

  global $xatpoll, $img, $width, $height ;

    $query = "SELECT * FROM $table";
    $result = mysql_query($query,$xatpoll) or die (Dbg($query) . mysql_error());

    $num_rows = mysql_num_rows($result);  
    print "<BR>There are $num_rows records in $table.<P>";  
    print "<table  border=1>\n";  
    print "<tr>\n";  
    for($n=0; $n<mysql_num_fields ($result); $n++)
        echo "<td>".mysql_field_name($result, $n) . "</td>\n";
    print "</tr>\n";  

    while ($get_info = mysql_fetch_row($result)){  
        print "<tr>\n";  
        foreach ($get_info as $field)  
		{
			$field = str_replace("<", "(", $field);
			if($img > 0 && substr($field, 0, 4) === "http")
				$field = "<img width=$width height=$height src=\"$field\">" ;
            print "\t<td><font face=arial size=1/>$field</font></td>\n";  
		}
        print "</tr>\n";  
    }  
    print "</table>\n";
}
  
?>  
</body>  
</html> 

