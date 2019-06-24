<?php

$pawnstop = strtotime("16 Dec 2019"); // a bit rdundant ...

$snum = intval(file_get_contents('/home/admin/snum.txt'));

if($snum == 2)
	header("Cache-Control: max-age=60,public"); // devs 5 mins (make a cup of tea)
else
	header("Cache-Control: max-age=3600,public"); // masses

$pow = array(
array("last", array('id'=>226,'text'=>"[LIMITED]")),//'xavi'=>array(804, 42, 225248065, 69211656, 137312609))), // The latest power goes here (ads) 
array("backs", array('b87'=>'kmback', 'b88'=>'tv80', 'b89'=>'zombieback', 'b90'=>'kheartb', 'b91'=>'kmoback', 'b92'=>'eggsleep', 'b93'=>'kfox', 'b94'=>'kcow', 'b95'=>'skback')),

array("actions", array(22 => "tipsy,merry,drunk", 23 => "party,2013,year,newyear")),

array("topsh", array('vbat'=>202, 'vbheart'=>202, 'vblood'=>202, 'vcoffin'=>202, 'vcross'=>202, 'vfangs'=>202, 'vglamour'=>202, 'vrip'=>202, 'vstake'=>202, 'vtongue'=>202,
'clcool'=>204, 'cld'=>204, 'cleek'=>204, 'clgrin'=>204, 'clmad'=>204, 'clsad'=>204, 'clsmile'=>204, 'clsweat'=>204, 'clwink'=>204, 'clx'=>204,
'bearer'=>205, 'disappear'=>205, 'dwarf'=>205, 'goblin2'=>205, 'queenelf'=>205, 'sneak'=>205, 'thering'=>205, 'warrior'=>205, 'wizzard'=>205,
'1066'=>207, 'agreement'=>207, 'arrow'=>207, 'burnt'=>207, 'dwarf2'=>207, 'dwarfz'=>207, 'elve2'=>207, 'goblin3'=>207, 'newton'=>207, 'pile'=>207,
'kmcheer'=>210, 'kmcry'=>210, 'kmeyerub'=>210, 'kmfit'=>210, 'kmfrustrate'=>210, 'kmglare'=>210, 'kmgrouch'=>210, 'kmhide'=>210, 'kmhug'=>210, 'kmlaugh'=>210, 'kmshock'=>210, 'kmshuffle'=>210, 'kmsleepy'=>210, 'kmsmile'=>210, 'kmback'=>210,
'bighair'=>211, 'bigphone'=>211, 'boombox'=>211, 'cassette'=>211, 'dance80'=>211, 'dj80'=>211, 'hoverboard'=>211, 'joystick'=>211, 'skate'=>211, 'slacker1'=>211, 'slacker2'=>211, 'poi'=>211, 'thermochrome'=>211, 'timemachine'=>211,
'zombie1'=>213, 'zombie2'=>213, 'zombie3'=>213, 'zombie4'=>213, 'survivor1'=>213, 'survivor2'=>213, 'survivor3'=>213, 'survivor4'=>213, 'bloodface'=>213, 'deadup'=>213, 'zombieback'=>213,
'blush'=>214, 'comb'=>214, 'eyeliner'=>214, 'lipgloss'=>214, 'lipstick1'=>214, 'lipstick2'=>214, 'makeupface'=>214, 'nailpolish'=>214, 'perfume'=>214, 'purse'=>214,
'kharrow'=>215, 'khbub'=>215, 'khcupid'=>215, 'kheartb'=>215, 'kheyes'=>215, 'khhug'=>215, 'khhurt'=>215, 'khily'=>215, 'khkiss'=>215, 'khlips'=>215, 'khmadly'=>215, 'khring'=>215, 'khroses'=>215,
'kmoback'=>216,  'kmoblow'=>216, 'kmod'=>216, 'kmodance'=>216, 'kmofrus'=>216, 'kmonehneh'=>216, 'kmorage'=>216, 'kmoredface'=>216, 'kmostare'=>216, 'kmoteeth'=>216, 'kmoun'=>216, 'kmowhistle'=>216, 'kmowonder'=>216,
'nuclearb'=>217,
'barber'=>218, 'mirror2'=>218, 'shave'=>218, 'shair1'=>218, 'shair2'=>218, 'shair3'=>218, 'shair4'=>218, 'shair5'=>218, 'shair6'=>218, 'shair7'=>218,
'bees'=>219, 'birdy'=>219, 'butterflys'=>219, 'flohat'=>219, 'flohide'=>219, 'flowerbed'=>219, 'flowers'=>219, 'floshow'=>219, 'flowerbed'=>219, 'inflower'=>219, 'rainbow2'=>219, 'springhat'=>219, 'watercan'=>219, 'watercan2'=>219, 
'bemused'=>220, 'cross'=>220, 'tick'=>220, 'placard'=>220, 'voting'=>220, 'voting2'=>220, 'hands2'=>221,
'pointing'=>221, 'prosper'=>221, 'peace2'=>221, 'notlistening'=>221, 'heehee'=>221, 'hearno'=>221, 'daydreaming'=>221, 'cutthroat'=>221, 'callme'=>221, 'crossed'=>221, 'highfive'=>221
,'chickwalk'=>222, 'eggnod'=>222, 'eggbroke'=>222, 'stripegg'=>222, 'eggwink'=>222, 'eggsleep'=>222, 'bunnyears'=>222, 'eggtongue'=>222, 'basket2'=>222
, 'kfoxbino'=>225, 'kfoxcry'=>225, 'kfoxd'=>225, 'kfoxggl'=>225, 'kfoxinl'=>225, 'kfoxpsy'=>225, 'kfoxshades'=>225, 'kfoxsleep'=>225, 'kfoxtant'=>225, 'kfoxtwag'=>225, 'kfoxwhat'=>225,
'kwangry'=>226, 'kwbell'=>226, 'kwcry'=>226, 'kwd'=>226, 'kwfrus'=>226, 'kwlaugh'=>226, 'kwlove'=>226, 'kwmad'=>226, 'kwnod'=>226, 'kwscratch'=>226, 'kwsleepy'=>226, 'kwswt'=>226, 'kwwhat'=>226, 'kwyay'=>226,
'skannoyed'=>227, 'skd'=>227, 'skdead'=>227, 'skfrus'=>227, 'skgrr'=>227, 'skoo'=>227, 'sksad'=>227, 'sksix'=>227, 'sksmile'=>227, 'skwink'=>227, 'skback'=>227,
)),
//array("Puzzle", array()),//164=>true
//array("NotGroup", array()),//180=>true, 182=>true
array("pssa", array('vampyre'=>202, 'treefx'=>203, 'claus'=>204, 'quest'=>205, 'quest2'=>207, 'glitterfx'=>208, 'xavi'=>209, 'kmouse'=>210, 'eighties'=>211, 
'foe'=>212, 'zombie'=>213, 'makeup'=>214, 'kheart'=>215, 'kmonkey'=>216, 'nuclear'=>217, 'stylist'=>218, 'spring'=>219, 'vote'=>220, 'hands2'=>221, 'eggs'=>222, 'hearts'=>224, 'kfox'=>225, 'kcow'=>226, 'sketch'=>227
)),
array("pawns", array(
	'time' => $pawnstop, 
'R' => array(95, "p1r2"), // RUBY!


'b' => array(226, "p1cowbell"), // 226 kcow
's' => array(226, "p1sketch") // 227 sketch
 ))
);

/*

'h' => array(224, "p1heart"), // ??? heart

'f' => array(225, "p1fox"), // 225 kfox
'w' => array(225, "p1fox2"), // 225 kfox what (crap)

'b' => array(222, "p1eggbroke"), // 222 eggs
'e' => array(222, "p1egg2"), // 222 eggs
'c' => array(68, "p1chick"), // 68 easter
't' => array(68, "p1carrot"), // 68 easter
'y' => array(68, "p1bunny"), // 68 easter
'g' => array(222, "p1egg") // 68 easter

'E' => array(12, "p1earth"), //  earth day
'L' => array(12, "p1lantern"), //  earth day
'l' => array(12, "p1light"), //  earth day
'h' => array(221, "p1hands2"), // 221 hands2

'b' => array(219, "p1bee"), // 219 spring
'u' => array(219, "p1butterfly"), // 219 spring
'f' => array(219, "p1flower"), // 219 spring
'r' => array(219, "p1rainbow2"), // 219 spring

'v' => array(220, "p1vote"), // 220 vote bar
's' => array(218, "p1scissors"), // 218 stylist
'd' => array(218, "p1dryer") // 218 stylist
'n' => array(217, "p1nuclear2"), // 217 nuclear
'e' => array(217, "p1nucleare"), // 217 nuclear explosion

//'g' => array(193, "p1bheart"), // 193 burning pawn
'g' => array(193, "p1burnheart"), // 193 burning heart
'h' => array(215, "p1kheart"), // 215 kheart
'b' => array(215 , "p1vballoon"), // 215 kheart
'B' => array(215 , "p1vballoon2"), // 215 kheart
'c' => array(215 , "p1vchain"), // 215 kheart
'd' => array(65 , "p1vdrink"), // 65 party
'p' => array(166 , "p1vheartbeat"), // 166 heartfx
'l' => array(62 , "p1vinlove"), // 62 valentine extra
'r' => array(62 , "p1vrose"), // 62 valentine extra
's' => array(62, "p1rose"), // 62 valentine 
'C' => array(62, "p1cupid"), // 62 valentine (bear) 
'D' => array(62, "p1card"), // 62 valentine
'H' => array(17, "p1heart"), // 17 Heart

'n' => array(216, "p1banana") // 216 kmonkey

'm' => array(214, "p1make"), // 214 makeup

's' => array(213, "p1zskull"), // 213 zombie skull
'z' => array(213, "p1zhand") // 213 zombie hand

xmas stuff
'x' => array(208, "p1glitterfx"), // glitterfx
's' => array(96, "p1snowman"), // winter/snowy
't' => array(155, "p1xtree"), // xmas
//'K' => array(57, "p1cracker"), //xmas power
//'g' => array(57, "p1gift"), //xmas power
//'n' => array(156, "p1santa"), //
'b' => array(57, "p1bauble"), //
//'k' => array(57, "p1sock"),  //
'a' => array(56, "p1snowball"), //
'm' => array(65, "p1champagne"), //
'3' => array(160, "p12013"), //
'i' => array(167, "p1lights"), //
'w' => array(154, "p1snows"), //
'u' => array(57, "p1bulb"), // pawn as a bulb
'U' => array(203, "p1bulb2"), // pawn with strips of bulbs
'T' => array(203, "p1treefx")          // treefx
'c' => array(204, "p1claus")

'a' => array(212, "p1angel") // angel
't' => array(211, "p1time"), // eighties 211
'k' => array(210, "p1kmouse"), // kmouse 210
'o' => array(85, "p1romania"), // Romainia day

'r' => array(205, "p1quest"), // the ring
'x' => array(207, "p1quest2"), // axe chop

'l' => array(206, "p1bub2"),          // lang
'' => array(, "p1codeban"), 
'' => array(, "p1magicfx"), 

'b' => array(201, "p1spe"),
't' => array(202, "p1bat"),
'c' => array(202, "p1cape"),

'd' => array(52, "p1blood"),            // halloween 
'a' => array(52, "p1cat"),              // halloween 
'g' => array(52, "p1p1gst"),            // halloween 
'j' => array(92, "p1p1scythe"),         // horror 
'l' => array(52, "p1p1tomb"),           // halloween 
'p' => array(52, "p1p1pkn"),            // halloween 
'n' => array(52, "p1p1cdn"),            // halloween 
'k' => array(202, "p1p1frk"),            // halloween 
'o' => array(92, "p1bone"),             // horror 
'y' => array(202, "p1p1candy"),          // halloween 
'm' => array(202, "p1p1mummy"),          // halloween 
's' => array(52, "p1skull"),            // halloween 
'v' => array(202, "p1vamp"),             // halloween 
'z' => array(92, "p1widow"),            // horror 
'w' => array(52, "p1witch"),            // halloween 
'e' => array(52, "p1eye")              // halloween 

'c' => array(198, "p1clock")

aliback

'aliens'=>190, 'alilaugh'=>190, 'alidead'=>190, 'aliclap'=>190, 'alid'=>190, 'alilove'=>190, 'aliscratch'=>190, 'alitalk'=>190, 'alicry'=>190, 'alitongue'=>190, 'aliyay'=>190, 'aliback'=>190,

'a' => array(189, "p1ali"),
'u' => array(189, "p1ufo"),
//'p' => array(197, "p1pony"),

//'d' => array(188, "p1doodlerace"),
//'m' => array(189, "p1medal"),
//'t' => array(189, "p1otorch"),
//'r' => array(189, "p1run"),
//'a' => array(190, "p1ali"),
//'u' => array(190, "p1ufo"),
//'s' => array(192, "p1spin"),
//'a' => array(192, "p1balls"),
//'b' => array(193, "p1bheart")
//'p' => array(195, "p1pnose"),
//'s' => array(194, "p1snakerace"),
*/

/*
'' => array(, ""),		// 
'' => array(, ""),		// 
'' => array(, ""),		// 
'' => array(, ""),		// 
'' => array(, ""),		// 
'' => array(, ""),		// 
 */

/*
'j' => array(183, "p1jail"),		
'g' => array(183, "p1gavel"),		
'h' => array(183, "p1handsup"),		
'h' => array(196, "p1chip"),
'c' => array(196, "p1playcard")

array(700,300,'Diamond'),//	950 – 1,000
array(700,100,'Summer'),//	500 – 550
array(300,500,'Manga'),//	1,000 – 1,100
array(300,300,'Adventure'),//	700 – 725
array(300,500,'Sins'),//	1,300 – 1,350
array(500,2000,'Angel'),//	8,700 – 8,800
array(100,100,'Wildwest'),//	425 – 475
array(600,500,'Flower'),//	1,300 – 1,400
array(200,3000,'Namecolor'),//	500 – 550

*/

echo json_encode($pow);


/* put old pawns here

//'m' => array(186, "p1moustache"),
//'w' => array(187, "p1whirl")
//'d' => array(185, "p1drip"),
//'z' => array(184, "p1zip2")

'v' => array(182, "p1vortex1"),		
'x' => array(182, "p1vortex2"),		

'a' => array(181, "p1bant"),
'w' => array(181, "p1bwings"),
'b' => array(181, "p1bfull")


'' => array(, "p1bfull"),
'' => array(, "p1catear"); //   // kat
'' => array(, "p1cattail"), //   // kat
'' => array(, "p1kat"), //   // kat
'' => array(, "p1cat"), //  
'' => array(, "p1hsix"), //   // monster
'' => array(, "p1halo"), //   // monster
'' => array(, "p1devil"), //   // monster
'' => array(, "p1feather"), //   // feast/thanks
'' => array(, "p1drumstick"), //   // feast/thanks
'' => array(, "p1radar"), //  
'' => array(, 
'' => array(, 								//case 't' : av1.Pawn = "testpawn"), //   // STEST
'' => array(, "p1crown"), //  
'' => array(, "p1drum"), //  
'' => array(, "p1carnival"), //  

'' => array(, 								
'' => array(, "p1"), //  
'' => array(, "p1military"), //   // 12 Nov 2010 20:00:00 GMT
'' => array(, "p1beer"), //   // lemonade
'' => array(, "p1clover"), //   // clover
'' => array(, "p1ghat"), //   
'' => array(, 								
'' => array(, "p1ups"), //   // 
'' => array(, "p1shake"), //   // 
'' => array(, "p1hole"), //   // 
'' => array(, "p1dogt"), //   // 
'' => array(, "p1bonk"), //   // 
'' => array(, 
'' => array(, "p1carrot"), //   // 
'' => array(, "p1bunny"), //   // 
'' => array(, "p1chick"), //   // 
'' => array(, "p1egg"), //   // 
'' => array(, "p1radiotele"), //   // 
'' => array(, "p1rocket"), //   // 
'' => array(, "p1liberty"), //  
'' => array(, "p1fw"), //  
'' => array(, "p1snake"), //   // 
'' => array(, "p1torch"), //   // 
'' => array(, "p1wheel"), //   // 
'' => array(, "p1dino"), //   // 
'' => array(, "p1bone"), //   // 
'' => array(, "p1moon"), //   // 
'' => array(, "p1space"), //   // 
'' => array(, "p1ss"), //   // 
'' => array(, "p1nerd"), //   // 
'' => array(, "p1bubbles"), //   // allpowers
'' => array(, "p1prop"), //   // 
'' => array(, "p1penguin"), //   // 
'' => array(, "p1lolly"), //   // 
'' => array(, "p1fishy"), //   // 
'' => array(, "p1matchban"), //   // 
'' => array(, "p1pshades"), //   // 
'' => array(, "p1punch"), //   // 
'' => array(, "p1peace"), //   // 
'' => array(, "p1rainbow"), //   // 
'' => array(, "p1dove"), //   // 
'' => array(, "p1apple"), //   // 
'' => array(, "p1p1tort"), //   // 
'' => array(, "p1p1cdn"), //   // 
'' => array(, "p1p1candy"), //   // 
'' => array(, "p1p1frk"), //   // 
'' => array(, "p1p1bat"), //   // 
'' => array(, "p1p1tomb"), //   // 
'' => array(, "p1p1gst"), //   // 
'' => array(, "p1p1pkn"), //   // 
'' => array(, "p1p1mummy"), //   // 
'' => array(, "p1p1scythe"), //   // 
'' => array(, "p1witch"), //  
'' => array(, "p1ghost"), //  
'' => array(, "p1skull"), //  
'' => array(, "p1drop"), //  
'' => array(, "p1vamp"), //  
'' => array(, "p1widow"), //  
*/

?>
