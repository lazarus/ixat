<?php
$gifts = [
["@Christmas", "gift,100,Bonbons,Cupcake,Decoration,GiftBow,GiftBow2,GiftTags,GingerbreadHouse", "card,50,PenguinIce,SantaCard,Sleighcard,Snowman,Stocking,Snowman2,GingerbreadMan"],
["@Christmas2", "gift,100,PineCone,SantaClaus,SledgeSack,SmallBells,StarAnise,TeddySanta,TreeGinger", "gift,100,WinterHat,xmasCandles,xmasCandy,xmasStar,xmasTree,xmasTurkey,xmasWreath"],
["@Categories","category,0,@Christmas,@Christmas2,@Christmas3,@Cards,@Butterfly,@MakeUp,@Romance","category,0,@Plush,@Flowers,@Zodiac,@Valentine,@xat,@Gifts,@Competition"],
["@Troll","card,50,FailFish,Kappa,Biblethump,Trump","gift,100,pepe,Kreygasm,Penis"],
["Christmas","gift,100,Bonbons,Cupcake,Decoration,GiftBow,GiftBow2,GiftTags,GingerbreadHouse","card,50,PenguinIce,SantaCard,Sleighcard,Snowman,Stocking,Snowman2,GingerbreadMan"],
["Christmas2","gift,100,PineCone,SantaClaus,SledgeSack,SmallBells,StarAnise,TeddySanta,TreeGinger","gift,100,WinterHat,xmasCandles,xmasCandy,xmasStar,xmasTree,xmasTurkey,xmasWreath"],
["Christmas3","gift,100,Bauble,Angel,SantaHat,SnowFlake,xmasBells,xmasCandle,xmasCake","gift,100,GoldBell,GoldCandle,Holly,IceHouse,Lamb,Mittens,MobileHoHoHo"],
["Butterfly","gift,100,butterfly1,butterfly2,butterfly3,butterfly4,butterfly5,butterfly6,butterfly7","gift,100,butterfly8,butterfly9"],
["MakeUp","gift,100,eyeshadows,faceballs,foundation,lipstick,mascara,nailpolish,powderpuff","gift,100"],
["Valentine","card,50,valc7,valc8,valc9,valc10,valc11,valc12,valc1","card,50,valc2,valc3,valc4,valc5,valc6,comp5,comp6"],
["Romance","gift,100,HeartRing,Chocs1,romance1,romance2,romance3,romance4,romance5","gift,100,romance6,romance7,romance8,romance9,romance10,romance11"],
["Plush","gift,100,PlushBear,PlushCat,PlushDeer,PlushDog,PlushElephant,PlushFrog,PlushKoala","gift,100,PlushLion,PlushMonkey,PlushPanda,PlushPig,PlushRabbit"],
["Flowers","flower,100,Rose,Daffodil,CherryBlossom,Viola,Daisy,Hydrangea,Poppy","flower,100,"],
["Zodiac","gift,100,Aries,Taurus,Gemini,Cancer,Leo,Virgo","gift,100,Libra,Scorpio,Sagittarius,Capricorn,Aquarius,Pisces"],
["Cards","card,50,Dog,Heart,Cakeballoons,Cake1,Together,PartyCat","card,50"],
["xat","card,50,D,Member,Moderator,Owner,Rocket1","gift,100,xat,Trade,Help,PurplePawn"],
["Gifts","gift,100,Football2,Guitar,Mp3","gift,100"],
["Competition","comp,50,comp7,comp8,comp9,comp10,comp11","comp,50,comp1,comp2,comp3,comp4,comp5,comp6"]];

/*
array("@Featured", "card,50,valc7,valc8,valc9,valc10,valc11,valc12,valc1", "card,50,valc2,valc3,valc4,valc5,valc6,comp5,comp10"),
array("@Plush", "gift,100,PlushBear,PlushCat,PlushDeer,PlushDog,PlushElephant,PlushFrog,PlushKoala", "gift,100,PlushLion,PlushMonkey,PlushPanda,PlushPig,PlushRabbit"),
array("@Romance", "gift,100,HeartRing,Chocs1,romance1,romance2,romance3,romance4,romance5", "gift,100,romance6,romance7,romance8,romance9,romance10,romance11,@Romance2"),

array("@Christmas", "gift,100,PineCone,SantaClaus,SledgeSack,SmallBells,StarAnise,TeddySanta,TreeGinger", "gift,100,WinterHat,xmasCandles,xmasCandy,xmasStar,xmasTree,xmasTurkey,xmasWreath"),
array("@Christmas2", "gift,100,Bonbons,Cupcake,Decoration,GiftBow,GiftBow2,GiftTags,GingerbreadHouse", "card,50,PenguinIce,SantaCard,Sleighcard,Snowman,Stocking,Snowman2,GingerbreadMan"),
array("@Christmas3", "gift,100,Bauble,Angel,SantaHat,SnowFlake,xmasBells,xmasCandle,xmasCake", "gift,100,GoldBell,GoldCandle,Holly,IceHouse,Lamb,Mittens,MobileHoHoHo"),

/"card,50,EmoLove,PartyMouse,TurkeyCard,Pilgrims,TurkeyDinner,Baseball"
//array("@Featured", "gift,100,PlushBear,PlushCat,PlushDeer,PlushDog,PlushElephant,PlushFrog,PlushKoala", "flower,100,Rose,Daffodil,CherryBlossom,Viola,Daisy,Hydrangea,Poppy"),
//array("@Popular", "gift,100,Gift1,HeartRing,Chocs1,PlushPanda,PlushCat,IceCream,Mp3","card,50,Heart,Dog,Rocket1,EmoLove,CakeBalloons,Owner,PartyMouse"),
//array("@Plush", "gift,100,PlushBear,PlushCat,PlushDeer,PlushDog,PlushElephant,PlushFrog,PlushKoala", "gift,100,PlushLion,PlushMonkey,PlushPanda,PlushPig,PlushRabbit"),

array("Christmas", "gift,100,Bonbons,Cupcake,Decoration,GiftBow,GiftBow2,GiftTags,GingerbreadHouse", "card,50,PenguinIce,SantaCard,Sleighcard,Snowman,Stocking,Snowman2,GingerbreadMan"),
array("Christmas2", "gift,100,PineCone,SantaClaus,SledgeSack,SmallBells,StarAnise,TeddySanta,TreeGinger", "gift,100,WinterHat,xmasCandles,xmasCandy,xmasStar,xmasTree,xmasTurkey,xmasWreath"),
array("Christmas3", "gift,100,Bauble,Angel,SantaHat,SnowFlake,xmasBells,xmasCandle,xmasCake", "gift,100,GoldBell,GoldCandle,Holly,IceHouse,Lamb,Mittens,MobileHoHoHo"),

array("@Featured", "gift,100,romance1,romance2,romance3,romance4,Rose,CherryBlossom,Daisy", "card,50,ValC1,ValC2,ValC3,ValC4,ValC5,ValC6"),
//pulled
array("Zodiac2", "card,50,Aries2,Taurus2,Gemini2,Cancer2,Leo2,Virgo2", "card,50,Libra2,Scorpio2,Sagittarius2,Capricorn2,Aquarius2,Pisces2"),
array("ThanksGiving", "gift,100,WheelBarrow,Turkey,TastyTurkey,SunFlower,RipePumpkin,Basket,Bell", "gift,100,PumpkinPie,PilgrimHat,MapleLeaf,Cranberry,AshBerry,Cornucopia,Candle"),
array("Christmas", "gift,100,Bonbons,Cupcake,Decoration,GiftBow,GiftBow2,GiftTags,GingerbreadHouse", "card,50,PenguinIce,SantaCard,Sleighcard,Snowman,Stocking,Snowman2,GingerbreadMan"),
array("Christmas2", "gift,100,PineCone,SantaClaus,SledgeSack,SmallBells,StarAnise,TeddySanta,TreeGinger", "gift,100,WinterHat,xmasCandles,xmasCandy,xmasStar,xmasTree,xmasTurkey,xmasWreath"),
array("Christmas3", "gift,100,Bauble,Angel,SantaHat,SnowFlake,xmasBells,xmasCandle,xmasCake", "gift,100,GoldBell,GoldCandle,Holly,IceHouse,Lamb,Mittens,MobileHoHoHo"),

//Animal
  array("Butterfly", "gift,100,butterfly1,butterfly2,butterfly3,butterfly4,butterfly5,butterfly6,butterfly7", "gift,100,butterfly8,butterfly9"),
  array("Fauna", "gift,100,bluefish,crab,dolphin,orangeshell,pinkshell,seahorse,starfish", "gift,100,turtle,yellowfish"),
  array("Insects", "gift,100,bee,beetle,dragonfly,grasshopper,ladybird,milkweed,mourningclock", "gift,100,peacock,spider"),
//Beauty
  array("Spa", "gift,100,aromacandle,bambooleaf,bubblebath,greentea,hairbrush,massageoil,rosepetals", "gift,100,rubberduck,seasalt,shampoo,soap,sponges,stonestower,towels"),
  array("MakeUp", "gift,100,eyeshadows,faceballs,foundation,lipstick,mascara,nailpolish,powderpuff", "gift,100"),
array("Birthday", "card,50,PartyCat,PartyDog,PartyMonkey,PartyMouse,PartyPig", "gift,100"),
array("Drinks", "gift,100,beer,champagne,cocktail,coffee,juice,martini,redwine", "gift,100,shake,tea"),
array("Easter", "egg,50,eegg1,eegg2,eegg3,eegg4,eegg5,eegg6,eegg7", "gift,100,easter1,easter2,easter3,easter4,easter5,easter6,easter7"),
array("Flowers", "flower,100,Rose,Daffodil,CherryBlossom,Viola,Daisy,Hydrangea,Poppy", "gift,100,Calla,CornFlower,Gladiolus,Lilly,Liverleaf,PinkRose,YellowIris"),
//Food
  array("FastFood", "gift,100,StrawberryIceCream,FizzyDrink,Fries,MintIceCream,Burger,HotDog,Doughnut", "gift,100,PopCorn,Pizza"),
  array("IceCream", "gift,100,IceCream,IceCream1,IceCream2,IceCream3,IceCream4,IceCream5,IceCream6", "gift,100,IceCream7,IceCream8,IceCream9"),
  array("Fruit", "gift,100,Apple,BlackGrape,Cherry,Lemon,Orange,Peach,Pear", "gift,100,Plum,Strawberry"),
  array("Vegetables", "gift,100,Carrot,Corn,Cauliflower,Radish,Eggplant,Onion,GreenPepper", "gift,100,Tomato,Pumpkin"),
array("Leisure", "gift,100,Football2,Guitar,Mp3", "gift,100,misc2"),
array("Plush", "gift,100,PlushBear,PlushCat,PlushDeer,PlushDog,PlushElephant,PlushFrog,PlushKoala", "gift,100,PlushLion,PlushMonkey,PlushPanda,PlushPig,PlushRabbit"),
array("Romance", "gift,100,HeartRing,Chocs1,romance1,romance2,romance3,romance4,romance5", "gift,100,romance6,romance7,romance8,romance9,romance10,romance11,@Romance2"),
array("Romance2", "gift,100,romance12,romance13", "gift,100,"),
array("StPatricks", "gift,100,Celtic,GreenBeer,Horseshoe,PatBalloons,PatHat,PatRainbow,PatRosette", "gift,100,PotOfGold,Shamrock"),
array("Vacation", "gift,100,Bonnet,BucketAndSpade,FlipFlops,Island,LimeJuice,Mask,Suitcase", "gift,100,SunCream,SunGlasses"),
array("xat", "card,50,D,Member,Moderator,Owner,Rocket1", "gift,100,xat,Trade,Help,PurplePawn"),
array("Zodiac", "gift,100,Aries,Taurus,Gemini,Cancer,Leo,Virgo", "gift,100,Libra,Scorpio,Sagittarius,Capricorn,Aquarius,Pisces"),
array("Competition", "card,50,D,comp1,comp2,comp3,comp4,comp5,comp6", "card,50,comp7,comp8,comp9,comp10"),
array("xGifts", "gift,100,Gift1","gift,100,"),
array("xCards", "card,50,Dog,Football,Heart,Cakeballoons,Cake1,Together,","card,50,EmoLove,Aries2")
array("Easter", "egg,50,eegg1,eegg2,eegg3,eegg4,eegg5,eegg6,eegg7", "gift,100,easter1,easter2,easter3,easter4,easter5,easter6,easter7"),

array("Halloween", "gift,100,Ghost,BlackCat,BlackSpider,Cauldron,MoonBats,RIP,Skull", "gift,100,ToffeeApple,WitchHat"),
array("Pumpkin", "gift,100,pumpkin1,pumpkin2,pumpkin3,pumpkin4,pumpkin5,pumpkin6,pumpkin7", "gift,100,pumpkin8,pumpkin9,pumpkin10,pumpkin11,pumpkin12"),
*/

if(!isset($NoOut)) 
{
	header("Cache-Control: max-age=60,public"); // HTTP/1.1
	echo json_encode($gifts);
}
?>
