<?php

	if(!isset($config->complete))
	{
		return include $pages['home'];
	}

	if(isset($_POST['lang']))
	{
        exit(substr($_POST['lang'], 0, 2));	
	}
?>
<div class="container-fluid">
	<section class="content">
        <div class="row">
            <div class="col-sm-4"></div>
            <div class="col-sm-3">
                <div class="box box-primary box-solid">
                    <div class="box-header with-border">
                        <center>Change language</center>
                    </div>
                    <div class="box-body">	
                        <div class="row">
                            <form method="post">
                                <div class="col-xs-4">
                                    <font color="white">Select language:</font>
                                </div>
                                <div class="col-xs-8">
                                    <select id="Language" name="Language" class="form-control">
                                        <option  value="n0">International / Any</option>
                                        <option  value="aa">Afar / Afaraf</option>
                                        <option  value="ab">Abkhazian / Аҧсуа</option>
                                        <option  value="ae">Avestan / avesta</option>
                                        <option  value="af">Afrikaans / Afrikaans</option>
                                        <option  value="ak">Akan</option>
                                        <option  value="am">Amharic / አማርኛ</option>
                                        <option  value="an">Aragonese / Aragonés</option>
                                        <option  value="ar">Arabic / ‫العربية</option>
                                        <option  value="as">Assamese / অসমীয়া</option>
                                        <option  value="av">Avaric / авар мацӀ; магӀарул мацӀ</option>
                                        <option  value="ay">Aymara / aymar aru</option>
                                        <option  value="az">Azerbaijani / azərbaycan dili</option>
                                        <option  value="ba">Bashkir / башҡорт теле</option>
                                        <option  value="be">Belarusian / Беларуская</option>
                                        <option  value="bg">Bulgarian / български език</option>
                                        <option  value="bh">Bihari / भोजपुरी</option>
                                        <option  value="bi">Bislama</option>
                                        <option  value="bm">Bambara / bamanankan</option>
                                        <option  value="bn">Bengali / বাংলা</option>
                                        <option  value="bo">Tibetan / བོད་ཡིག</option>
                                        <option  value="br">Breton / brezhoneg</option>
                                        <option  value="bs">Bosnian / bosanski jezik</option>
                                        <option  value="ca">Catalan / Català</option>
                                        <option  value="ce">Chechen / нохчийн мотт</option>
                                        <option  value="ch">Chamorro / Chamoru</option>
                                        <option  value="co">Corsican / corsu; lingua corsa</option>
                                        <option  value="cr">Cree / ᓀᐦᐃᔭᐍᐏᐣ</option>
                                        <option  value="cs">Czech / česky; čeština</option>
                                        <option  value="cu">Church Slavic / </option>
                                        <option  value="cv">Chuvash / чӑваш чӗлхи</option>
                                        <option  value="cy">Welsh / Cymraeg</option>
                                        <option  value="da">Danish / dansk</option>
                                        <option  value="de">German / Deutsch</option>
                                        <option  value="dv">Divehi / ‫ދިވެހި</option>
                                        <option  value="dz">Dzongkha / རྫོང་ཁ</option>
                                        <option  value="ee">Ewe / Ɛʋɛgbɛ</option>
                                        <option  value="el">Greek / Ελληνικά</option>
                                        <option selected value="en">English</option>
                                        <option  value="eo">Esperanto / </option>
                                        <option  value="es">Spanish / español</option>
                                        <option  value="et">Estonian / Eesti keel</option>
                                        <option  value="eu">Basque / euskara</option>
                                        <option  value="fa">Persian / ‫فارسی</option>
                                        <option  value="ff">Fulah / Fulfulde</option>
                                        <option  value="fi">Finnish / suomen kieli</option>
                                        <option  value="fl">Filipino</option>
                                        <option  value="fj">Fijian / vosa Vakaviti</option>
                                        <option  value="fo">Faroese / Føroyskt</option>
                                        <option  value="fr">French / français</option>
                                        <option  value="fy">Western Frisian / Frysk</option>
                                        <option  value="ga">Irish / Gaeilge</option>
                                        <option  value="gd">Scottish Gaelic / Gàidhlig</option>
                                        <option  value="gl">Galician / Galego</option>
                                        <option  value="gn">Guaraní / Avañe'ẽ</option>
                                        <option  value="gu">Gujarati / ગુજરાતી</option>
                                        <option  value="gv">Manx / Ghaelg</option>
                                        <option  value="ha">Hausa / ‫هَوُسَ</option>
                                        <option  value="he">Hebrew / ‫עברית</option>
                                        <option  value="hi">Hindi / हिन्दी; हिंदी</option>
                                        <option  value="ho">Hiri Motu / </option>
                                        <option  value="hr">Croatian / Hrvatski</option>
                                        <option  value="ht">Haitian / Kreyòl ayisyen</option>
                                        <option  value="hu">Hungarian / Magyar</option>
                                        <option  value="hy">Armenian / Հայերեն</option>
                                        <option  value="hz">Herero / Otjiherero</option>
                                        <option  value="ia">Interlingua / </option>
                                        <option  value="id">Indonesian / Bahasa Indonesia</option>
                                        <option  value="ie">Interlingue / </option>
                                        <option  value="ig">Igbo / Igbo</option>
                                        <option  value="ii">Sichuan Yi / ꆇꉙ</option>
                                        <option  value="ik">Inupiaq / Iñupiaq; Iñupiatun</option>
                                        <option  value="io">Ido / Ido</option>
                                        <option  value="is">Icelandic / Íslenska</option>
                                        <option  value="it">Italian / Italiano</option>
                                        <option  value="iu">Inuktitut / ᐃᓄᒃᑎᑐᑦ</option>
                                        <option  value="ja">Japanese / 日本語</option>
                                        <option  value="jv">Javanese / basa Jawa</option>
                                        <option  value="ka">Georgian / ქართული</option>
                                        <option  value="kg">Kongo / KiKongo</option>
                                        <option  value="ki">Kikuyu / Gĩkũyũ</option>
                                        <option  value="kj">Kwanyama / Kuanyama</option>
                                        <option  value="kk">Kazakh / Қазақ тілі</option>
                                        <option  value="kl">Kalaallisut / kalaallit oqaasii</option>
                                        <option  value="km">Khmer / ភាសាខ្មែរ</option>
                                        <option  value="kn">Kannada / ಕನ್ನಡ</option>
                                        <option  value="ko">Korean / 한국어; 조선말</option>
                                        <option  value="kr">Kanuri / Kanuri</option>
                                        <option  value="ks">Kashmiri / कश्मीरी; كشميري‎</option>
                                        <option  value="ku">Kurdish / Kurdî; كوردی‎</option>
                                        <option  value="kv">Komi / коми кыв</option>
                                        <option  value="kw">Cornish / Kernewek</option>
                                        <option  value="ky">Kirghiz / кыргыз тили</option>
                                        <option  value="la">Latin / latine; lingua latina</option>
                                        <option  value="lb">Luxembourgish / Lëtzebuergesch</option>
                                        <option  value="lg">Ganda / Luganda</option>
                                        <option  value="li">Limburgish / Limburgs</option>
                                        <option  value="ln">Lingala / Lingála</option>
                                        <option  value="lo">Lao / ພາສາລາວ</option>
                                        <option  value="lt">Lithuanian / lietuvių kalba</option>
                                        <option  value="lu">Luba-Katanga / </option>
                                        <option  value="lv">Latvian / latviešu valoda</option>
                                        <option  value="mg">Malagasy / Malagasy fiteny</option>
                                        <option  value="mh">Marshallese / Kajin M̧ajeļ</option>
                                        <option  value="mi">Māori / te reo Māori</option>
                                        <option  value="mk">Macedonian / македонски јазик</option>
                                        <option  value="ml">Malayalam / മലയാളം</option>
                                        <option  value="mn">Mongolian / Монгол</option>
                                        <option  value="mo">Moldavian / лимба молдовеняскэ</option>
                                        <option  value="mr">Marathi / मराठी</option>
                                        <option  value="ms">Malay / bahasa Melayu; بهاس ملايو‎</option>
                                        <option  value="mt">Maltese / Malti</option>
                                        <option  value="na">Nauru / Ekakairũ Naoero</option>
                                        <option  value="nb">Norwegian Bokmål / Norsk bokmål</option>
                                        <option  value="nd">North Ndebele / isiNdebele</option>
                                        <option  value="ne">Nepali / नेपाली</option>
                                        <option  value="ng">Ndonga / Owambo</option>
                                        <option  value="nl">Dutch / Nederlands</option>
                                        <option  value="nn">Norwegian Nynorsk / Norsk nynorsk</option>
                                        <option  value="no">Norwegian / Norsk</option>
                                        <option  value="nr">South Ndebele / Ndébélé</option>
                                        <option  value="nv">Navajo / Diné bizaad; Dinékʼehǰí</option>
                                        <option  value="ny">Chichewa / chiCheŵa; chinyanja</option>
                                        <option  value="oc">Occitan / Occitan</option>
                                        <option  value="oj">Ojibwa / ᐊᓂᔑᓈᐯᒧᐎᓐ</option>
                                        <option  value="om">Oromo / Afaan Oromoo</option>
                                        <option  value="or">Oriya / ଓଡ଼ିଆ</option>
                                        <option  value="os">Ossetian / Ирон æвзаг</option>
                                        <option  value="pa">Panjabi / ਪੰਜਾਬੀ; پنجابی‎</option>
                                        <option  value="pi">Pāli / पािऴ</option>
                                        <option  value="pl">Polish / polski</option>
                                        <option  value="ps">Pashto / ‫پښتو</option>
                                        <option  value="pt">Portuguese / Português</option>
                                        <option  value="qu">Quechua / Runa Simi; Kichwa</option>
                                        <option  value="rm">Raeto-Romance / rumantsch grischun</option>
                                        <option  value="rn">Kirundi / kiRundi</option>
                                        <option  value="ro">Romanian / română</option>
                                        <option  value="ru">Russian / русский язык</option>
                                        <option  value="rw">Kinyarwanda / Kinyarwanda</option>
                                        <option  value="ry">Rusyn / русинськый язык</option>
                                        <option  value="sa">Sanskrit / संस्कृतम्</option>
                                        <option  value="sc">Sardinian / sardu</option>
                                        <option  value="sd">Sindhi / सिन्धी; ‫سنڌي، سندھی‎</option>
                                        <option  value="se">Northern Sami / Davvisámegiella</option>
                                        <option  value="sg">Sango / yângâ tî sängö</option>
                                        <option  value="sh">Serbo-Croatian / Српскохрватски</option>
                                        <option  value="si">Sinhalese / සිංහල</option>
                                        <option  value="sk">Slovak / slovenčina</option>
                                        <option  value="sl">Slovenian / slovenščina</option>
                                        <option  value="sm">Samoan / gagana fa'a Samoa</option>
                                        <option  value="sn">Shona / chiShona</option>
                                        <option  value="so">Somali / Soomaaliga; af Soomaali</option>
                                        <option  value="sq">Albanian / Shqip</option>
                                        <option  value="sr">Serbian / српски језик</option>
                                        <option  value="ss">Swati / SiSwati</option>
                                        <option  value="st">Sotho / seSotho</option>
                                        <option  value="su">Sundanese / Basa Sunda</option>
                                        <option  value="sv">Swedish / Svenska</option>
                                        <option  value="sw">Swahili / Kiswahili</option>
                                        <option  value="ta">Tamil / தமிழ்</option>
                                        <option  value="te">Telugu / తెలుగు</option>
                                        <option  value="tg">Tajik / тоҷикӣ; toğikī; ‫تاجیکی‎</option>
                                        <option  value="th">Thai / ไทย</option>
                                        <option  value="ti">Tigrinya / ትግርኛ</option>
                                        <option  value="tk">Turkmen / Türkmen; Түркмен</option>
                                        <option  value="tl">Tagalog / Tagalog</option>
                                        <option  value="tn">Tswana / seTswana</option>
                                        <option  value="to">Tonga / faka Tonga</option>
                                        <option  value="tr">Turkish / Türkçe</option>
                                        <option  value="ts">Tsonga / xiTsonga</option>
                                        <option  value="tt">Tatar / татарча; tatarça; ‫تاتارچا‎</option>
                                        <option  value="tw">Twi / Twi</option>
                                        <option  value="ty">Tahitian / Reo Mā`ohi</option>
                                        <option  value="ug">Uighur / Uyƣurqə; ‫ئۇيغۇرچ ‎</option>
                                        <option  value="uk">Ukrainian / Українська</option>
                                        <option  value="ur">Urdu / ‫اردو</option>
                                        <option  value="uz">Uzbek / O'zbek; Ўзбек; أۇزبېك‎</option>
                                        <option  value="ve">Venda / tshiVenḓa</option>
                                        <option  value="vi">Vietnamese / Tiếng Việt</option>
                                        <option  value="vo">Volapük / Volapük</option>
                                        <option  value="wa">Walloon / Walon</option>
                                        <option  value="wo">Wolof / Wollof</option>
                                        <option  value="xh">Xhosa / isiXhosa</option>
                                        <option  value="yi">Yiddish / ‫ייִדיש</option>
                                        <option  value="yo">Yoruba / Yorùbá</option>
                                        <option  value="za">Zhuang / Saɯ cueŋƅ; Saw cuengh</option>
                                        <option  value="zh">Chinese / 中文, 汉语, 漢語</option>
                                        <option  value="zu">Zulu / isiZulu</option>
                                    </select>
                                </div>
                                <br><br><br>
                                <center><button id="changelang" type="button" class="btn btn-primary btn-md"><i class="icon-user"></i>&nbsp;<span>Change language</span></button></center>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</section>
</div>
<script>
$('#changelang').click(function(event) {
	var query = jQuery.param({
		lang: $("#Language").val()
	});
	POST("/changelanguage?ajax", query, setLang);
});


function POST(url, query, callback) {
	callback = callback || false;
	var xmlhttp = new XMLHttpRequest();

	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200 && callback != false) {
			callback(xmlhttp.responseText);
		}
	}
	xmlhttp.open("POST", url, true);
	xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlhttp.send(query);
}

function setLang(lang) {
    if(lang.length != 2 || lang == undefined || lang == null) {
        lang = 'en';
    }
    alert("Language changed to " + lang);
    Cookies.set('lang', lang, { expires: 365*2, path:'/' });
}
</script>
