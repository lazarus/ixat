<?php
if($_SERVER["REQUEST_METHOD"] !== "GET") exit;
if(!empty($_GET)) exit;
header("Cache-Control: max-age=604800,public");
?>
{"1":"est\u00e1 se divertindo no %s","2":"membro","3":"moderador","4":"propriet\u00e1rio","5":"foi feito %s no %s","6":"casou-se %s no %s","7":"divorciou-se %s no %s","8":"recebeu BFF de %s no %s","9":"Clique para juntar-se a mim no %s"}