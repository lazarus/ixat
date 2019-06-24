<?php
$gifts = [["Gifts","gift,100,HeartRing,Chocs1,Football2,Guitar,Mp3,Aries,IceCream","plush,100,PlushPanda,PlushFrog,PlushCat,PlushDeer,Gift1"],
["Cards","card,50,Dog,Football,Heart,Cakeballoons,Cake1,Together,PartyCat","card,50,EmoLove,PartyMouse,Aries2"],
["Flowers/Comp","flower,100,Rose,Daffodil,CherryBlossom,Viola,Daisy,Hydrangea,Poppy","comp,50,comp1,comp2,comp3,comp4,comp5,comp6"],
["xat","card,50,D,Member,Moderator,Owner,Rocket1","gift,100,xat,Trade,Help,PurplePawn"]];


//array("Zodiac1", "gift,100,Aries,Taurus,Gemini,Cancer,Leo,Virgo", "gift,100,Libra,Scorpio,Sagittarius,Capricorn,Aquarius,Pisces"),
//array("Zodiac2", "card,50,Aries2,Taurus2,Gemini2,Cancer2,Leo2,Virgo2", "card,50,Libra2,Scorpio2,Sagittarius2,Capricorn2,Aquarius2,Pisces2"),
//array("Plush", "gift,100,PlushBear,PlushCat,PlushDeer,PlushDog,PlushElephant,PlushFrog,PlushKoala", "gift,100,PlushLion,PlushMonkey,PlushPanda,PlushPig,PlushRabbit"),

if(!isset($NoOut)) 
{
	header("Cache-Control: max-age=60,public"); // HTTP/1.1
	echo json_encode($gifts);
}
?>
