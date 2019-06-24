<?php
error_reporting(E_ALL ^ E_NOTICE);

function GetWebPageImages($webpage)
{
	global $WebPageUrls, $wa, $ha, $debug;
	$MaxAns = 30;
	
	function bkg_DoCurl($url)
	{
		global $debug;
		if($debug) print "Curl: $url<BR>";
		$content="";
		$ch = curl_init ();
		curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt ($ch, CURLOPT_URL, $url);
		curl_setopt ($ch, CURLOPT_TIMEOUT, 60);
		curl_setopt ($ch, CURLOPT_REFERER, $url);
		$content = curl_exec ($ch);
		curl_close ($ch);
		return $content;
		//CURLOPT_HEADER
	}
	
$url = $webpage;
trim($url);

// strip http://
$pos = strrpos($url, '://');
if ($pos !== false) 
	$url = substr($url, $pos+3);

$pos = strrpos($url, '/');
if ($pos === false) 
	$folder = $url . '/' ;
else
	$folder = substr($url, 0, $pos+1);

$pos = strpos($url, '/');
if ($pos === false) 
	$home = $url . '/' ;
else
	$home = substr($url, 0, $pos+1);

    //print "$url, $folder, $home, $webpage<BR>\n";
	$content = bkg_DoCurl($url);

$i = 0;

// JSON - google api
if($content{0} === '{')
{
	$c = 0;
	//print "$url <BR>\n";
	while($i < $MaxAns && $c < 1)
	{
		$content = json_decode($content, true);
		if($content["responseStatus"] != 200) return 0; // broke
		$t = (array)$content["responseData"];
		$t = (array)$t["results"];
		foreach($t as $v)
		{
			$v = (array)$v;
	//print "{$v['width']} {$v['height']} {$v['unescapedUrl']} <BR>\n";
			if($v['width'] < 30) continue;
			if($v['height'] < 30) continue;
			if($v['width'] > 1024) continue;
			if($v['height'] > 1024) continue;
			//if (!stristr($v['url'], '.jpg')) continue; // ignore if not a JPG
			$u = parse_url($v['url']);
			$u = strtolower($u['host']);
			$u = explode('.', $u);
			$c = count($u)-1;
//			if($u[$c] != 'com') continue;
//			if($u[$c-1] != 'photobucket') continue;
			
			$wa[$i] = $v['width'];
			$ha[$i] = $v['height'];
			$WebPageUrls[$i++] = $v['unescapedUrl'];
			if($i >= $MaxAns) break;
		}
		if($i >= $MaxAns) break;
		$c++;
	//print "$url&start=".($c*8)."<BR>\n";
		$content = bkg_DoCurl("$url&start=".($c*8));		
	}
	return $i;
}

// scrape a web page
$tags = explode('<', $content);

foreach($tags as $el)
{
    if(strcasecmp(substr($el, 0, 3), 'img') == 0) // got an image?
	{
	    preg_match('@width="?(\d*)@is', $el, $m);
    	$width = $m[1];
    	preg_match('@height="?(\d*)@is', $el, $m);
    	$height = $m[1];
    	preg_match('@src="?(.*?)["\s]@is', $el, $m);
    	$adr = $m[1];
	}
	else
	{
    	if(strcasecmp(substr($el, 0, 1), 'a') == 0) // link?
		{
	    	preg_match('@href="?(.*?)["\s]@is', $el, $m);
    		$adr = $m[1];
		}
		else
			continue;
	}
	
	if($width > 0 && $width < 20) continue;
	if($height > 0 && $height < 20) continue;
    if (!stristr($adr, '.jpg')) continue; // ignore if not a JPG
	if(strlen($adr) < 10) continue;
	
    if(strcasecmp(substr($home, 0, 13), 'images.google') == 0) // hack for google
	{
//print "$adr<BR>\n";
		$p = '@.*:(.*)@s' ;
    	preg_match($p, $adr, $m);
		$adr = 'http:' . $m[1];
	}

    if(strcasecmp(substr($adr, 0, 7), 'http://') != 0)
	{ // here if rel url
	    if(strcasecmp(substr($adr, 0, 1), '/') == 0) 
			$adr = 'http://' . $home . $adr;
		else
			$adr = 'http://' . $folder . $adr;
	}
	if($width <= 1024 && $height <= 1024)
	{
		$wa[$i] = $width;
		$ha[$i] = $height;
//print "$width,$height,$adr,".$wa[$i].",".$ha[$i]."<BR>\n";
		$WebPageUrls[$i++] = $adr;
	}
	if($i >= $MaxAns) break;
}
	return $i;
}

function MsnImages($content, $MaxAns)
{
	global $WebPageUrls, $wa, $ha;

//print "<pre>\n$content\n</pre>\n<BR>\n";
//return 0;
/*
imgurl=http%3a%2f%2fwww.vanaqua.org%2faquanews%2fimages%2fSharks_Majuro_MH_sm.jpg&amp;FORM=IGIK" gping="&amp;POS=14&amp;CM=IMG&amp;CE=1&amp;CS=OTH&amp;SR=1&amp;sample=0"><img alt="Sharks_Majuro_MH_sm.jpg" class="thumbnail_img" src="http://ts1.images.live.com/images/thumbnail.aspx?q=1601104513248&id=da90fc6633dc59a1f613d947e532c8dc" title="Sharks_Majuro_MH_sm.jpg" /></a></td></tr></tbody></table></div><div class="image_properties"><div>dimensions: 300x400</div>
*/
$tags = explode('class="md_fd"', $content);

$tags[0] = '';

$i = $z = 0;
foreach($tags as $el)
{
	$img = '';
   	$width = 0;
   	$height = 0;
//class="md_fd">450 x 423
   	preg_match('/>(\d*) x (\d*)/', $el, $m);
   	$width = $m[1];
   	$height = $m[2];
   	preg_match('/class="md_mu">(.*?)</', $el, $m);
   	$img = $m[1];
//print"<PRE>\n$width $height $img\n</PRE>\n";	

	if(strlen($img) > 10)
	{
		//$img = 'http://' . substr($img, 13);
    	$img = str_replace ( '%2f', '/', $img); // ditch any "
    	$img = str_replace ( '%3a', ':', $img); // ditch any "
		if(strpos($img, '%') !== false) continue ; // junk if still has %

//print "<pre>\n".$img."\n</pre>\n<BR>\n";
		if($width <= 1024 && $height <= 1024 && $width > 0 && $height > 0)
		{
			$wa[$i] = $width;
			$ha[$i] = $height;
			$WebPageUrls[$i++] = $img;
		}
		if($i >= $MaxAns) break;
	}
}
return $i;
}

// Convert a color into a html color code
function GetColor($str) {
$ColArray = array(
'aliceblue','#F0F8FF',
'antiquewhite','#FAEBD7',
'aqua','#00FFFF',
'aquamarine','#7FFFD4',
'azure','#F0FFFF',
'beige','#F5F5DC',
'bisque','#FFE4C4',
'black','#000000',
'blanchedalmond','#FFEBCD',
'blue','#0000FF',
'blueviolet','#8A2BE2',
'brown','#A52A2A',
'burlywood','#DEB887',
'cadetblue','#5F9EA0',
'chartreuse','#7FFF00',
'chocolate','#D2691E',
'cornflowerblue','#6495ED',
'cornsilk','#FFF8DC',
'cyan','#00FFFF',
'darkblue','#00008B',
'darkcyan','#008B8B',
'darkgoldenrod','#B8860B',
'darkgray','#A9A9A9',
'darkgreen','#006400',
'darkkhaki','#BDB76B',
'darkmagenta','#8B008B',
'darkolivegreen','#556B2F',
'darkorange','#FF8C00',
'darkorchid','#9932CC',
'darkred','#8B0000',
'darksalmon','#E9967A',
'darkseagreen','#8FBC8F',
'darkslateblue','#483D8B',
'darkslategray','#2F4F4F',
'darkturquoise','#00CED1',
'darkviolet','#9400D3',
'deeppink','#FF1493',
'deepskyblue','#00BFFF',
'dimgray','#696969',
'dodgerblue','#1E90FF',
'feldspar','#D19275',
'firebrick','#B22222',
'floralwhite','#FFFAF0',
'forestgreen','#228B22',
'fuchsia','#FF00FF',
'gainsboro','#DCDCDC',
'ghostwhite','#F8F8FF',
'gold','#FFD700',
'goldenrod','#DAA520',
'gray','#808080',
'green','#008000',
'greenyellow','#ADFF2F',
'honeydew','#F0FFF0',
'hotpink','#FF69B4',
'indianred',' #CD5C5C',
'indigo',' #4B0082',
'khaki','#F0E68C',
'lavender','#E6E6FA',
'lavenderblush','#FFF0F5',
'lawngreen','#7CFC00',
'lemonchiffon','#FFFACD',
'lightblue','#ADD8E6',
'lightcoral','#F08080',
'lightcyan','#E0FFFF',
'lightgoldenrodyellow','#FAFAD2',
'lightgrey','#D3D3D3',
'lightgreen','#90EE90',
'lightpink','#FFB6C1',
'lightsalmon','#FFA07A',
'lightseagreen','#20B2AA',
'lightskyblue','#87CEFA',
'lightslateblue','#8470FF',
'lightslategray','#778899',
'lightsteelblue','#B0C4DE',
'lightyellow','#FFFFE0',
'lime','#00FF00',
'limegreen','#32CD32',
'magenta','#FF00FF',
'maroon','#800000',
'mediumaquamarine','#66CDAA',
'mediumblue','#0000CD',
'mediumorchid','#BA55D3',
'mediumpurple','#9370D8',
'mediumseagreen','#3CB371',
'mediumslateblue','#7B68EE',
'mediumspringgreen','#00FA9A',
'mediumturquoise','#48D1CC',
'mediumvioletred','#C71585',
'midnightblue','#191970',
'mintcream','#F5FFFA',
'mistyrose','#FFE4E1',
'moccasin','#FFE4B5',
'navajowhite','#FFDEAD',
'navy','#000080',
'oldlace','#FDF5E6',
'olivedrab','#6B8E23',
'orange','#FFA500',
'orangered','#FF4500',
'orchid','#DA70D6',
'palegoldenrod','#EEE8AA',
'palegreen','#98FB98',
'paleturquoise','#AFEEEE',
'palevioletred','#D87093',
'papayawhip','#FFEFD5',
'peachpuff','#FFDAB9',
'pink','#FFC0CB',
'plum','#DDA0DD',
'powderblue','#B0E0E6',
'purple','#800080',
'red','#FF0000',
'rosybrown','#BC8F8F',
'royalblue','#4169E1',
'saddlebrown','#8B4513',
'sandybrown','#F4A460',
'seagreen','#2E8B57',
'seashell','#FFF5EE',
'sienna','#A0522D',
'silver','#C0C0C0',
'skyblue','#87CEEB',
'slateblue','#6A5ACD',
'slategray','#708090',
'springgreen','#00FF7F',
'steelblue','#4682B4',
'tan','#D2B48C',
'teal','#008080',
'thistle','#D8BFD8',
'tomato','#FF6347',
'turquoise','#40E0D0',
'violet','#EE82EE',
'violetred','#D02090',
'wheat','#F5DEB3',
'white','#FFFFFF',
'whitesmoke','#F5F5F5',
'yellow','#FFFF00',
'yellowgreen','#9ACD32');

    $s = trim(strtolower($str));

	if(preg_match('/^#[0123456789abcdef]{6}/',$s)) // # + hex 6 times
		return substr($str, 0, 7);
	
    $r = array(" ", "\t");
    $s = str_replace($r, "", $s);
    $n = 0;
    $m = -1;
    $l = 0;
    while(1)
    {
        $pos = strpos($s, $ColArray[$n]);
        $len = strlen($ColArray[$n]);
        if($len == 0) break;

        if ($pos === false) {}
        else // matched
        {
            if($len > $l)
            {
                $l = $len;
                $m = $n;
            }
        }
        $n += 2;
    }
    if($m >= 0) return $ColArray[$m+1];
    return "- Can't find color: $str";
}


function GetBackgrounds()
{
 $arr = array(
'matrix',
'spiderman2',
'supermanreturns',
'spiderman3',
'spiderman3b',
'drops',
'rock1',
'splash',
'light',
'globe',
'circuit',
'lime_splash',
'rock2',
'disco',
'car',
'jigsaw',
'gears',
'fireworks',
'bauble',
'snowman',
'velvet',
'bliss_like',
'drops_of_rain',
'flames',
'green',
'on_the_beach',
'paper',
'pool',
'south_pacific',
'stars',
'winter_holiday',
'metalglass',
'cash',
'jeans',
'hearts',
'balls',
'beams'
);
return $arr;
}

function GetRandomBackgrounds()
{
	$arr = GetBackgrounds();
	shuffle ($arr);
	return $arr;
}

// helper function for web gear pages to display thumbnails for clicking
function SampleBackgrounds($NoMore)
{

$arr = GetBackgrounds();

$rand_keys = array_rand($arr, 8);
foreach ($rand_keys as $v) {
$value = $arr[$v];
echo "<input type=image name=newimage_xat_$value src=http://xat.com/web_gear/background/jdothumb/xat_$value.jpg alt=\"Click to use this image ($value)\" WIDTH=75 HEIGHT=61 />\n";
  }
 if(!$NoMore)
echo '
<input type=image name="ChangeBackground" src=http://xat.com/web_gear/background/more.gif 
alt="Click here for more images, To use your own image or To get an image from a web page."  WIDTH=75 HEIGHT=61 >' ."\n";
//'<input type=image name="ChangeBackground" src=http://xat.com/web_gear/background/more_photobucket.gif 
//alt="Click here to use a Photobucket picture."  WIDTH=75 HEIGHT=61 >' ."\n";
}

function GetFromWebAndXat($Exp, $Offsite, $Xat)
{
	global $WebPageUrls, $wa, $ha;
	
	GetWebPageImages($Exp);
	$WebPageUrls = array_slice($WebPageUrls,0,$Offsite);
	$arr = GetBackgrounds();
	$arr = array_slice($arr,0,$Xat);
	$WebPageUrls = array_merge($WebPageUrls, $arr);

	return 	$WebPageUrls;
}

function ImageSearch($Exp, $Offsite, $Xat)
{
	global $WebPageUrls, $wa, $ha;
	
	function bkg_getIp()
	{
		$ip = $_SERVER['HTTP_X_REAL_IP'];
		if(empty($ip) || $ip === '127.0.0.1') $ip = $_SERVER['REMOTE_ADDR'];
		if(empty($ip) || $ip === '127.0.0.1')
		{
			$ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
			if(strpos($ip, ',')) // CSV ?
			{
				$ip = explode(',', $ip);
				$ip = trim(array_pop($ip));
			}
		}	
		return $ip;
	}

	$s = preg_split('/[\\;\\,\\+\\t :\\\\\\/!"£$%\\^&*\\(\\)]/', trim($Exp));
	$n = 0;
	$ss = '';
	foreach($s as $v)
	{
		$l = strlen($v);
		if($l > 1 && $l < 20)
		{
			$ss .= '+'.$v;
			$n++;
			if ($n >= 5) break;
		}
	}	
	//$ss = substr($ss, 1); // get rid of leading +
	$ss = "url:(photobucket.com OR imageshack.us OR tinypic.com) AND ($ss)"; // photobucket only :(
	//$s = preg_replace('/[ :\\\\\\/!"£$%\\^&*\\(\\)]/', '+', $s); // ditch non alpha numeric
//	$s = preg_replace('/ /', '+', $s); // +++ -> +
//	$s = preg_replace('/\+\++/', '+', $s); // +++ -> +
//	$s = preg_replace('/(.*?\\+  /', '+', $s); // limit to 5 terms
	$s = urlencode($ss);
	//$s = 'http://images.google.com/images?imgsz=large&q=' . $s ;
//print "Search:$s<BR>"; exit;
	// defunct $s = 'http://search.msn.com/images/results.aspx?q=' .$s .'&imagesize=medium&mkt=en-US#imagesize=medium' ;
	
	//$s = 'http://www.bing.com/images/search?q=' .$s .'&go=&form=QBIL&qs=n';
	$s = "http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=$s&key=ABQIAAAAQhCric7Q6q397zSMLod6DRQHrXbTvjkCPZMbQ5rpNQiWYBhvghRAu_ZM9kivHflkq7yAuKr-8HyztQ&as_filetype=jpg&imgsz=large&imgtype=photo&rsz=8&userip=".bkg_getIp();
	
	return GetFromWebAndXat($s, $Offsite, $Xat);
}


// Attempt to figure out what has been passed in and turn it into an array of images
function SmartBackground($In, $Offsite, $Xat)
// web page url, color, image url or search term
// No of offsite images
// No of xat images

{
	global $debug;

	$Exp = strtolower(trim($In)); // tidy
	if(strlen($Exp) < 2 || preg_match ( '/[<>;]/' , $Exp)) // Nothing supplied or crap found so just return xat images
	{
			$arr = GetRandomBackgrounds();
			$arr = array_slice($arr,0,$Xat);
			return $arr;		
	}

	if(strpos($Exp, '.') === false) // no dots cant be a url or image
	{
		//$Color = GetColor($Exp);
		if(substr($Color, 0, 1) === '#') // it as a color
		{
			$arr = GetRandomBackgrounds();
			$arr = array_slice($arr,0,$Xat+1);
			$arr[0] = $Color;
			return $arr;
		}
if($debug) print "Seaching for: $Exp<BR>";	
		return (ImageSearch($Exp, $Offsite, $Xat/2));
	}
	// See if we can extract an image
	if(preg_match('/(http:\\/\\/.*?\\.(jpg|gif|png))/i',  $In, $m))
	{
		$In = $m[0];
		$Exp = strtolower($In); // tidy
	}
if($debug) print "Not a color or simple serch<BR>";	
// ok so its not a color or simple search
	$ext = substr($Exp, -4, 4);
	$s = strpos($Exp, '/');
	$j = $ext === '.jpg';
	$g = $ext === '.gif';
	$p = $ext === '.png';
	if(($j || $g || $p) && (strlen($Exp) > 20) && ($s !== false)) // probably an image
	{
			$arr = GetRandomBackgrounds();
			$arr = array_slice($arr,0,$Xat+1);
			
			if(substr($Exp, 0, 7) !== 'http://') // deal with wrong case of http
				$Exp = 'http://' . trim($In);			
			else
				$Exp = 'http://' . substr(trim($In), 7);			
			
			$arr[0] = $Exp;
			return $arr;		
	}
// so not an image, maybe a web page
if($debug) print "so not an image, maybe a web page<BR>";	

	$h = (substr($Exp, 0, 7) === 'http://');
	$w = (substr($Exp, 0, 4) === 'www.');
	$a = preg_match('/^[\\w\\-\\.\\/]*$/',$Exp) ;
	
	if($h !== false || $w !== false || $a == 1)
	{
		if($h === false) $Exp = 'http://' . $Exp;
		return GetFromWebAndXat($Exp, $Offsite, $Xat); // Get images from a web page
	}
	
// so just do a search with what's left ...
if($debug) print "so just do a search with what's left<BR>";	
		return ImageSearch($Exp, $Offsite, $Xat/2);
}

if(false) // test code
{

/*
   $curl = curl_init();
   curl_setopt($curl, CURLOPT_URL, "http://www.linuxformat.co.uk");
   curl_setopt($curl, CURLOPT_VERBOSE, 1);
   curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
   $return = curl_exec($curl);
   curl_close($curl);
   print $return;
   exit;
   $curl = curl_init();
   curl_setopt($curl, CURLOPT_URL, "http://www.3dize.com/");
//   curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
   $return = curl_exec($curl);
   curl_close($curl);
//   print $return;
exit;
*/

	//$debug = true;

	print '
<form id=form1 name=form1 method=post action=background.php>
  <input type=text name=in value="'.htmlspecialchars($_REQUEST['in']).'" />
  <input type=submit name=GO value=Submit />
</form>
';
	$arr = SmartBackground($_REQUEST['in'], 7, 7);
	foreach ($arr as $v)
	{
	print "$v<BR>";
	/*
		if(substr($v, 0, 1) === '#') // it as a color
			echo "<table border=0><tr><td width=150 height=120 style=\"background-color:$v;\" >&nbsp;</td>
					</tr></table>" ;
		else
		if(strlen($v) > 20)
			echo "<img src=$v alt=$v WIDTH=150 HEIGHT=120 >\n";
		else
			echo "<img src=http://xat.com/web_gear/background/jdothumb/xat_$v.jpg alt=$v 
					WIDTH=150 HEIGHT=120 >\n";
		*/
	}
}
?>
