<?php
if($_SERVER["REQUEST_METHOD"] !== "GET") exit;
if(!empty($_GET)) exit;
header("Cache-Control: max-age=604800,public");
?>
{"1":"tra\u00eene sur %s","2":"membre","3":"mod\u00e9rateur","4":"propri\u00e9taire","5":"as \u00e9t\u00e9 mis %s sur %s","6":"s'est mari\u00e9 \u00e0 %s sur %s","7":"a divorc\u00e9 de %s sur %s","8":"est devenu BFF avec %s sur %s","9":"Clique pour me rejoindre sur %s","10":"a donn\u00e9 \u00e0 %s le cadeau xat %s","11":"vient juste de cr\u00e9er le groupe xat %s","12":"Clique pour cr\u00e9er ton propre groupe xat","13":"%s a achet\u00e9 le shortname xat %s","14":"Clique pour acheter ton propre shortname","15":"a promu le groupe xat %s","16":"%s a dit %s"}