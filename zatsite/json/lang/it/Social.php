<?php
if($_SERVER["REQUEST_METHOD"] !== "GET") exit;
if(!empty($_GET)) exit;
header("Cache-Control: max-age=604800,public");
?>
{"1":"\u00e8 entrato su %s","2":"membro","3":"moderatore","4":"titolare","5":"\u00e8 stato reso %s su %s","6":"si \u00e8 sposato con %s su %s","7":"ha divorziato da %s su %s","8":"si \u00e8 fatto BFF con %s su %s","9":"Clicca e vienimi a trovare su %s","10":"ha dato a %s la gift di xat %s","11":"ha creato la chat %s","12":"Clicca per creare la tua chat personale","13":"%s ha comprato lo shortname %s","14":"Clicca per acquistare uno shortname personale","15":"ha messo in promote la chat %s","16":"%s ha detto %s"}