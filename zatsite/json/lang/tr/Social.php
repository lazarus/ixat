<?php
if($_SERVER["REQUEST_METHOD"] !== "GET") exit;
if(!empty($_GET)) exit;
header("Cache-Control: max-age=604800,public");
?>
{"1":"oyalan\u0131yor %s","2":"\u00fcye","3":"mod","4":"sahip","5":"taraf\u0131ndan yap\u0131ld\u0131 %s da %s","6":"evlendi %s da %s","7":"bo\u015fand\u0131 %s da %s","8":"BFF oldu %s da %s","9":"%s da bana kat\u0131lmak i\u00e7in t\u0131kla"}