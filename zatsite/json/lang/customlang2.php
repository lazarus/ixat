<?php
header('Content-type: text/json');

$default = '{"0":"Main","1":"Delete message","2":"Visitors","3":"Friends","4":"Send message","5":"Get a Chat Box","6":"Chat Groups","7":"View help","8":"Web Link","9":"More smilies","10":"Turn sound on","11":"Turn sound off","12":"Click on $1 to change your name","13":"Go to $1 Group","14":"Help","15":"Change your picture","16":"Interact with $1","17":"If not auto linked copy this to your browser:","18":"Change your name, picture and home page","19":"Sign In","20":"Private message","21":"Go to home page:","22":"Member","23":"Moderator","24":"Owner","25":"Banned","26":"Click to start chat","27":"Click to stop chat","28":"Change background, Add or change group. Add extra features.","29":"Put a Chat Box on your website","30":"To change your name or picture click on this: $1","31":"Sign Out","32":"Connecting...","33":"You haven\'t said anything for a while. Press Sign In to rejoin the chat.","34":"Edit Your Chat","35":"Press Sign In to start chatting. To be signed in automatically go to the profile page and select [Sign me in automatically].","36":"You have started the chat in another window. Press Sign In to restart in this window again.","37":"This is a $1 only chat, you can private chat an owner or moderator and ask to join.","38":"Enter a link, web page or search term","39":"Get Images","40":"Background:","41":"Enter Group name here - or select below:","42":"Chat Groups are shared chat rooms, like the lobby, but for a specific purpose. You can put them as a group tab on your chat box","43":"Create New Group","44":"Edit xat.com Chat Box","45":"OK","46":"Change Background","47":"Change Group","48":"Set any width and height. Promote your chat box. Get a Poll, Quiz and Slide Show","49":"Extra Features...","50":"Edit Your Chat Box","51":"Get Your Own Chat Box","52":"Loading images, please wait","53":"Preview Group","54":"Failed to find any images, please try again.","55":"Sorry, chat edit is closed for maintenance. Please try later","56":"Preview","57":"Click to use this image","58":"Profile","59":"New User...","60":"Name","61":"Picture","62":"Home Page","63":"Choose from 100s of Pictures on the web","64":"Use Your Own","65":"Sign me in automatically","66":"Cancel","67":"Go to home page:","68":"No home page","69":"Private Chat","70":"Start a private chat","71":"Private Message","72":"Send a private message","73":"Un-Friend","74":"Add as Friend","75":"Add\/Remove as Friend","76":"Ignore","77":"Un-Ignore","78":"Ignore\/Un-Ignore this user","79":"Kick","80":"Kick this user off as a warning.","81":"Ban","82":"Un-Ban","83":"Prevent this user from posting messages","84":"Make Member","88":"Make Moderator","90":"I have un-banned","91":"Go to friend\'s location:","92":"Get a Chat Box","98":"Connection Problem. You could try to start the chat again, Sorry.","99":"Please do not share your password with anyone. xat will never ask for your password.","100":"Network Problem!","101":"Report Unfair Ban","102":"Return to Chat Box","103":"Find Another Group","104":"Copy Link","105":"Link Copied to Clipboard","106":"Please go to your browser and press Ctrl-V in the address box.","107":"You are","108":"On xat","109":"Online","110":"Offline","111":"Friend","112":"Ignored","113":"Reason for Ban:","114":"Reason for Kick:","115":"Duration:","116":"Hours","117":"(0 = forever)","118":"(maximum 6)","119":"I have banned $1 forever for no reason","120":"I have banned $1 for $2 hours for no reason","121":"I have banned $1 forever. Reason: $2","122":"I have banned $1 for $2 hours. Reason: $3","123":"I have kicked $1 Reason: $2","124":"You can\'t kick someone without a reason.","125":"You have been Banned","126":"not added you as a friend","127":"$1 has Banned you","128":"I have made $1 a moderator","129":"on $1","130":"I have un-moderated $1","131":"Get","132":"I have made $1 a member","133":"I have un-membered $1","134":"Main Owner","135":"Make Guest","136":"Make Owner","137":"I have made $1 an owner","138":"I have made $1 a guest","139":"Get Stuff","140":"View xatspace","141":"Invite all your IM friends to this chat!","142":"Add IM friends. Start IM version of the chat.","143":"On App","144":"Start IM","145":"Start IM version of the chat","146":"Please sign into IM first","147":"$1 friends invited to chat","148":"Marry\/Best Friend","149":"Transfer","150":"Divorce","151":"Give away xats and days","152":"Married to","153":"Best friends with","154":"Register...","155":"Register, Login, Logout etc.","156":"On MSN","157":"On AIM","158":"subscriber","159":"registered","160":"BFF","161":"married","162":"Transfer of $1 xats and $2 days from $3 to $4 complete","164":"User not found","165":"Bad password","166":"User not confirmed registration email","167":"Not enough xats","168":"You have to have a partner to get divorced!","169":"You are already have a partner!","170":"Partner not registered","171":"Partner already has a partner!","172":"Not enough days!","173":"Sorry: Can\'t transfer to free xats user","174":"System problem. Please try later.","175":"Error","176":"subscribers","177":"registered users","178":"members","179":"Turn radio off","180":"Turn radio on","181":"Enter message, your password and enter the amount to transfer.","182":"Enter message, your password and click your choice.","183":"Message","184":"Password","185":"Kiss","186":"Marry\/BFF","187":"xats phishing protection: Transfer held for $1 days","188":"Gagged","189":"Powers","190":"Add Effects","191":"Add Special Effects to your Avatar (days required)","192":"Protect Deactivated!","193":"Protect Activated! - for the next $1 minutes new users will need to solve a captcha.","194":"I have booted $1 to $2. Reason: $3","195":"sinbin","196":"I have sinbinned $1","197":"Gag","198":"Mute","199":"I have $1 $2 for $3 hours for no reason","200":"I have $1 $2 for $3 hours. Reason: $4","201":"Muted","202":"Transfer to: $1","203":"Subscriber for:","204":"$1 days","205":"xats","206":"Get xats","207":"Click to buy","208":"days","209":"Marry:","210":"Best Friends Forever:","211":"Please wait...","212":"Get $1","213":"Make a Group","214":"WARNING! Do not share this link!","215":"You have been automatically logged out. Please login again at xat.com\/login","216":"Open Live Panel","217":"Live Mode: Send questions and comments by typing here","218":"Invite all MSN\/AIM friends","219":"Add MSN\/AIM friends","220":"Hide inappropriate words","221":"Get Married","222":"Get Divorced","223":"Give to $1","224":"Send a kiss","225":"Updated","226":"Safe Trade","227":"Offer","228":"Done","229":"Accept trade","230":"Trade complete","231":"Failed","232":"Confirm trade","233":"WARNING: Trade may be unfair! Continue?","234":"xats reserve limit exceeded.","235":"(Reduce trade value by $1 xats)","236":"Banished","237":"Group Power","238":"Assign or Unassign $1 to this chat group.","239":"$1 unassigned ok","240":"$1 assigned ok","241":"$1 unassigned fail (you hadnt assigned one)","242":"$1 assigned fail (you dont have any free ones)","243":"Groups Powers that are assigned to groups cannot be traded","244":"Close","245":"Dunce","246":"Undunce","247":"Please check your email.","248":"Group To Boot to:","249":"Set Picture: ","250":"I have finished a $1 hour $2 ban in $3 seconds","251":"celebrity","252":"Sorry. You don\'t have the power","253":"Sorry. Group power is not assigned","254":"$1 has bought $2  a $3","255":"Notifications","256":"Give a friend a gift","257":"Gifts","258":"banned","259":"dunced","260":"Chat is in protect mode. Try later.","261":"Protect Activated!","262":"Foe","263":"Un-Foe","264":"Are you a human?","265":"awarded a badge to","266":"Naughty","267":"UnNaughty","268":"naughty stepped","269":"Put this chat group on your page"}';
$defaultCustom = '{"0":"Staff","1":"Purge","2":"Visitors","3":"Friends","4":"Send Msg","5":"zat Chat","14":"Notice","19":"Enter","20":"Bother [PM]","25":"Banned","31":"Exit","32":"Loading...","34":"zat Chat","35":"Press Enter","36":"zat kicked you out, press Enter","69":"Annoy [PC]","71":"Bother [PM]","74":"Add Friend","79":"Kick","80":"Kick user via Warning","81":"Ban","82":"Unban","83":"Gag","92":"zat Chat","102":"Return to Chat","107":"You are","108":"on zat","109":"active","110":"resting","111":"Friend","112":"ignored","126":"not added you","150":"Break Up","161":"dating","179":"Radio off","180":"Radio on","188":"Gagged","197":"Gag","198":"Mute","201":"Muted","222":"Break Up","246":"Un-Dunce","255":"Tickles","258":"banned"}';

$dir = "../../_class/";
$dir = str_replace('\\', '\\\\', $dir);
require $dir . 'config.php';
require $dir . 'pdo.php';

$pdo = new Database($config->db[0], $config->db[1], $config->db[2], $config->db[3]);

if(!$pdo->conn)
	die('[]');

if(isset($_GET['r']) && is_numeric($_GET['r']))
{
	$chat = $pdo->fetch_array('SELECT `lang` FROM `chats` WHERE `id`=:id;', array('id'=>$_GET['r']));
	
	if(empty($chat))
	{
		die('[]');
	}
	
	if($chat[0]['lang'] != NULL or !empty($chat[0]['lang']))
		die($chat[0]['lang'] == "{}" ? $default:$chat[0]['lang']);
	else
		die($default);
}
else
{
	die('[]');
}
?>