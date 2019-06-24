<?php
if($_SERVER["REQUEST_METHOD"] !== "GET") exit;
if(!empty($_GET)) exit;
header("Cache-Control: max-age=604800,public");
?>
{"1":"est\u00e1 pasando el rato en %s","2":"miembro","3":"moderador","4":"due\u00f1o","5":"ha sido hecho %s en %s","6":"se cas\u00f3 con %s en %s","7":"s\u00e9 divorcio de %s en %s","8":"s\u00e9 hizo BFF con %s en %s","9":"Haga click para unirse a %s","10":"Le obsequio a %s el regalo de xat %s","11":"a creado un Grupo xat %s","12":"Click para crear tu propio grupo Xat","13":"%s a comprado el nombre corto xat %s","14":"Click para comprar tu propio nombre corto","15":"a promocionado el grupo de xat %s"}