<?php
if($_SERVER["REQUEST_METHOD"] !== "GET") exit;
if(!empty($_GET)) exit;
header("Cache-Control: max-age=604800,public");
?>
{"1":"esht lidhur ne %s","2":"member","3":"moderator","4":"owner","5":"u be %s ne %s","6":"u martua me %s ne %s","7":"keni divorcuar nga %s ne %s","8":"u be BFF me %s ne %s","9":"Kliko dhe me kerko ne %s","10":"i dha %s dhuraten e xat %s","11":"ka krijuar chatin %s","12":"Kliko per te krijuar chatin tend personal","13":"%s ka blere emrin e shkurter %s","14":"Kliko per te blere nje emer te shkurter personal","15":"ka vendosur ne promote chatin %s","16":"%s tha %s"}