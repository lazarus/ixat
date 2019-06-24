<?php
if($_SERVER["REQUEST_METHOD"] !== "GET") exit;
if(!empty($_GET)) exit;
header("Cache-Control: max-age=604800,public");
?>
{"1":"cat","2":"dog","3":"fish","4":"house","5":"mouse","6":"angry","7":"happy","8":"flower","9":"flag","10":"bone","11":"sun","12":"sea","13":"cliff","14":"mountain","15":"pyramid","16":"waterfall","17":"skyscraper","18":"blue sky","19":"robot","20":"computer","21":"lemonade","22":"fire","23":"moon","24":"universe","25":"tree","26":"ants","27":"bear","28":"rose","29":"belt","30":"road","31":"roof","32":"sealion","33":"ocean","34":"taco","35":"rockband","36":"piano","37":"cookie","38":"cup","39":"keyboard","40":"video game","41":"box","42":"ring","43":"jewelry","44":"laptop","45":"river","46":"ocean","47":"bed","48":"paper","49":"truck"}