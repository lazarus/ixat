<?php
define('RANK_GUEST', 0);
define('RANK_MEMBER', 1);
define('RANK_ADMIN', 2);
define('HTTPS_PORT', 443);
require _root . '_class' . _sep . 'mailer' . _sep . 'PHPMailerAutoload.php';
require _root . '_class' . _sep . 'i18n.php';
require _root . '_class' . _sep . 'WebUser.php';

class core
{
	public  $page = 'landing';
	private $pages = [];
	public  $chat = false;
	public  $user;
	public  $cn   = 0;
	public 	$http = "http";
    public  $lang = "en";
    public  $html5 = true;
	public  const version = '042718.1'; // mmddyy.v
	
	public function getVersion() {
		global $core;
		
		return core::version;
	}

	public function __construct()
	{
		global $core, $mysql, $config;

		$this->cn = time() . rand(1, 10000);

		if(isset($_SERVER['HTTP_CF_CONNECTING_IP']))
		{
			$_SERVER['REMOTE_ADDR'] = $_SERVER['HTTP_CF_CONNECTING_IP'];
		}
		$this->getLang();
		if((!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') || $_SERVER['SERVER_PORT'] == 443 || $_SERVER['HTTP_X_FORWARDED_PROTO'] == "https")
			$this->http = "https";
		if(!class_exists('Database'))
		{
			require _root . '_class' . _sep . 'pdo.php';

			if(file_exists(_root . '_class' . _sep . 'config.php'))
			{
				@include _root . '_class' . _sep . 'config.php';
				if(isset($config))
				{
					$mysql = new Database($config->db[0], $config->db[1], $config->db[2], $config->db[3]);
					if(!isset($mysql->conn) || !$mysql->conn)
					{
						$config = $mysql = false;
						include _root . "/web_gear/maintenance.html";
						die();
					}
					else
					{
						$server = $mysql->fetch_array('select * from `server` limit 0, 1;');
						if(count($server) > 0)
						{
							$config->bind_ip = $server[0]['server_ip'];
							$config->server_ip = $server[0]['connect_ip'];
							$config->server_pt = $server[0]['server_pt'];
							$config->debug_pt = $server[0]['backup_pt'];
							$config->server_dm = $server[0]['server_domain'];
							$config->xats = $server[0]['starting_xats'];
							$config->days = $server[0]['starting_days'];
							$config->info = $server[0];
							$admin = $mysql->fetch_array('select count(*) from `users` where `username`!=\'Unregistered\';');
							if($admin[0]['count(*)'] > 0)
							{
								$config->complete = true;
								try
								{
									if(isset($_COOKIE['loginKey']) && strlen($_COOKIE['loginKey']) == 32)
									{
										$user = $mysql->fetch_array('select * from `users` where `loginKey`=:key;', array('key' => $_COOKIE['loginKey']));
										if(empty($user))
										{
											throw new Exception;
										}
										if(!isset($_COOKIE['xats']) || $_COOKIE['xats'] != $user[0]['xats'])
										{
											setCookie('xats', $user[0]['xats'], strtotime('+ 1 year'));
										}
										if(!isset($_COOKIE['days']) || $_COOKIE['days'] != floor($user[0]['days'] / 86400))
										{
											setCookie('days', floor($user[0]['days'] / 86400), strtotime('+ 1 year'));
										}
										if(!isset($_COOKIE['rank']) || $_COOKIE['rank'] != $user[0]['rank'])
										{
											setCookie('rank', $user[0]['rank'], strtotime('+ 1 year'));
										}
										setCookie('hold', @$user[0]['hold'], strtotime('+ 1 year'));

										$this->user = new WebUser($user[0], $config);

										//if($this->admin) {
										if (!$this->user->isEncoded()) {
											$this->user->setNickname(base64_encode($this->user->getNickname()));
											$mysql->query("UPDATE users SET nickname=:name WHERE id=:id;", ["name" => $this->user->getNickname(), "id" => $this->user->getID()]);
										}
										//}
									}
								}
								catch(Exception $e)
								{
									/* Do Nothing */
									// old loginkey
								}
							}
						}
					}
				}
			}
		}
		$this->page = isset($this->user) ? "home" : "landing";
		$this->pages = [];
		foreach(glob(_root . '_pgs' . _sep . '*.php') as $i => $u)
		{
			$this->pages[substr(basename($u), 0, -4)] = $u;
		}

		if(isset($_GET['page']) && array_key_exists($_GET['page'], $this->pages))
		{
			$this->page = $_GET['page'];
		}
		elseif(isset($_GET['page']))
		{
			if(is_string($_GET['page']))
			{
				if(strlen($_GET['page']) > 4 && substr(strtolower($_GET['page']), 0, 4) == "ixat")
					$_GET['page'] = is_numeric(substr($_GET['page'], 4)) ? substr($_GET['page'], 4):$_GET['page'];

				$this->chat = $mysql->fetch_array('select * from `chats` where `name`=:chat or `id`=:chat;', array('chat' => $_GET['page']));
				if(!empty($this->chat)) {
					$this->page = 'chat';
				} else {
					$this->chat = false;
				}
			}
		}

		//if(!isset($core->user) && !in_array(strtolower($this->page), ["login","register","landing"])) $this->page = "landing";
	}
    
	public function send2py($msg) {
		$sock = fsockopen('198.251.80.169', '337', $e, $e, 1);
		fwrite($sock, '<globalmessage t="' . $msg . '" />'. chr(0));
		fclose($sock);
	}
	
    public function getLang(){
        $this->lang = @$_COOKIE['lang'];
        if (!$this->lang || strlen($this->lang) != 2 || $this->lang == null) {
            $this->lang = "en";
        }
        
    }
		
	public function count_format($n, $point = '.', $sep = ',')
	{
		if ($n < 0) return 0;
		if ($n < 10000) return number_format($n, 0, $point, $sep);
		$d = $n < 1000000000 ? ($n < 1000000 ? 1000:1000000):1000000000;
		$f = round($n / $d, 1);
		$l = $d == 1000 ? 'k':($d == 1000000 ? 'M':'B');
		return number_format($f, $f - intval($f) ? 1 : 0, $point, $sep) . $l;
	}

	public function DecodePowers($p, $dO = "") {
		$powers = [];
		if(!empty($p))
		foreach(explode("|", $p) as $d => $z) {
			if(empty($z)) continue;
			$p = decbin($z);
			foreach(str_split(strrev($p)) as $i => $c) {
			    if($c == "1") {
			    	$id = $i + ($d * 32);
			    	//if($id > 640) $id = 640 - $id;
			    	$powers[$id] = 1;
			    }
			}
		}
		if(!empty($dO))
		foreach(explode("|", $dO) as $p) {
			if(empty($p)) continue;
			list($id, $count) = explode("=", $p);
			//if($id > 640) $id = 640 - $id;
			$powers[$id] += $count;
		}
		return $powers;
	}

	public function EncodePowers($powers) {
		$dO = [];
		if(count($powers) == 0) return ["", ""];
		if(!(array_keys($powers) !== range(0, count($powers) - 1))) {
			$temp = [];
			foreach($powers as $power) {
				$temp[$power] = 1;
			}
			$powers = $temp;
		}

		$min_ = min(array_keys($powers));
		if($min_ < 0) {
			for($x = 1; $x <= abs($min_); $x++) {
				if(array_key_exists(-$x, $powers)) {
					$powers[$x + 640] = $powers[-$x];
					unset($powers[-$x]);
				}
			}
		}


		$new_powers = array_fill(0, ceil(max(array_keys($powers)) / 32), 0);

		foreach($powers as $power => $amount) {
			if($power < 0) $power = 640 + abs($power);
			$new_powers[floor($power / 32)] |= pow(2, $power % 32);
			if($amount > 1) {
				$dO[] = $power . "=" . ($amount - 1);
			}
		}

		return [implode("|", $new_powers), implode("|", $dO)];
	}

	public function AddUserPower($uid, $pid, $count = 1) {
		global $mysql;
		$userpowers = $mysql->fetch_array("SELECT `powers`,`dO` FROM `users` WHERE `id`=:uid;", array("uid" =>$uid));
		if(empty($userpowers)) $userpowers = ["powers" => "", "dO" => ""];
		$userpowers = $this->DecodePowers($userpowers[0]["powers"], $userpowers[0]["dO"]);
        if (is_array($pid)) {
            foreach($pid as $p) {
            	if($p < 0) $p = abs($p) + 640;
                if (array_key_exists($p, $userpowers)) {
                    $userpowers[$p] += $count;
                } else {
                    $userpowers[$p] = $count;
                }
            }
        } else {
        	if($pid < 0) $pid = abs($pid) + 640;
            if (array_key_exists($pid, $userpowers)) {
                $userpowers[$pid] += $count;
            } else {
                $userpowers[$pid] = $count;
            }
        }

		list($powers, $dO) = $this->EncodePowers($userpowers);

		$mysql->query("UPDATE `users` SET `powers`=:powers, `dO`=:dO WHERE `id`=:uid;", array("uid" => $uid, "powers" => $powers, "dO" => $dO));
	}
	
	public function RemUserPower($uid, $pid, $count = 1) {
		global $mysql;
		$userpowers = $mysql->fetch_array("SELECT `powers`,`dO` FROM `users` WHERE `id`=:uid;", array("uid" =>$uid));
		$powers = $this->DecodePowers($userpowers[0]["powers"],$userpowers[0]["dO"]);
		if(is_array($pid)) {
			foreach($pid as $zz) {
            	if($zz < 0) $zz = abs($zz) + 640;
				$powers[$zz] -= $count;
				if($powers[$zz] <= 0)
					unset($powers[$zz]);
			}
		} else {
        	if($pid < 0) $pid = abs($pid) + 640;
			$powers[$pid] -= $count;
			if($powers[$pid] <= 0)
				unset($powers[$pid]);
		}

		list($powers, $dO) = $this->EncodePowers($powers);

		$mysql->query("UPDATE `users` SET `powers`=:powers, `dO`=:dO WHERE `id`=:uid;", array("uid" => $uid, "powers" => $powers, "dO" => $dO));
	}
	
	public function DelUserPower($uid, $pid) {
		global $mysql;
		$userpowers = $mysql->fetch_array("SELECT `powers`,`dO` FROM `users` WHERE `id`=:uid;", array("uid" =>$uid));
		$powers = $this->DecodePowers($userpowers[0]["powers"],$userpowers[0]["dO"]);
		if(is_array($pid)) {
			foreach($pid as $zz) {
            	if($zz < 0) $zz = abs($zz) + 640;
				unset($powers[$zz]);
			}
		} else {
        	if($pid < 0) $pid = abs($pid) + 640;
			unset($powers[$pid]);
		}

		list($powers, $dO) = $this->EncodePowers($powers);

		$mysql->query("UPDATE `users` SET `powers`=:powers, `dO`=:dO WHERE `id`=:uid;", array("uid" => $uid, "powers" => $powers, "dO" => $dO));
	}
	
	public function ClearUserPower($uid) {
		$mysql->query("UPDATE `users` SET `powers`=:powers, `dO`=:dO WHERE `id`=:uid;", array("uid" => $uid, "powers" => "", "dO" => ""));
	}
	
	public function GetUserPower($uid, $pid = false) {
		global $mysql;
		$userpowers = $mysql->fetch_array("SELECT `powers`,`dO` FROM `users` WHERE `id`=:uid;", array("uid" =>$uid));
		$powers = $this->DecodePowers($userpowers[0]["powers"], $userpowers[0]["dO"]);
        if($pid < 0) $pid = abs($pid) + 640;
		return !!$pid ? $powers[$pid] : $powers;
	}	
	public function HasPower($uid, $pid) {
		global $mysql;
		$userpowers = $mysql->fetch_array("SELECT `powers` FROM `users` WHERE `id`=:uid;", array("uid" =>$uid));
		$powers = $this->DecodePowers($userpowers[0]["powers"]);
        if($pid < 0) $pid = abs($pid) + 640;
		return array_key_exists($pid, $powers);
	}
	
	public function cookiesEnabled()
	{
		if(count($_COOKIE) > 0)
			return true;
		else
			return false;
	}

	public function xatTrim($s, $len)
	{
		$s = preg_replace('/[^0-9A-Za-z]/', '', $s);

		if(strlen($s) > ($len-1))
			$s = substr ($s, 0, $len-1);
		return $s;
	}
	
	public function xatTrim2($s, $len)
	{
		$s = str_replace('<', ' ', $s);
		$s = str_replace('>', ' ', $s);
		$s = str_replace(';=', '', $s);
		$s = str_replace(';', '', $s);
		$s = str_replace('&', '', $s);
		$s = str_replace("'", '', $s);
		$s = str_replace('"', '', trim($s));
		if(strlen($s) > ($len-1))
			$s = substr ($s, 0, $len-1);
		return $s;
	}
	
	public function rangetrim($s, $ok, $maxlen)
	{
		$s = trim($s);
		$s = preg_replace("/$ok/i", '', $s);
		$s = preg_replace('/[\x00-\x1F\x7F]/', '', $s); // junk control chars
		if(strlen($s) > ($maxlen))
			$s = substr ($s, 0, $maxlen);
		return $s;
	}

	public function email($email, $subject, $message)
	{
		$mail = new PHPMailer;
		$mail->IsSMTP();
		$mail->Host = 'email-smtp.us-west-2.amazonaws.com';
		$mail->Port = 587;
		$mail->SMTPAuth = true;
		$mail->Username = 'AKIAIIVJH3Z2AZGU3FCA';
		$mail->Password = 'ApbbShLqpRRYNFD2UUKPpU/S6JOzrjedr6GySRjs3uAo';
		$mail->SMTPSecure = 'tls';
		$mail->From = 'noreply@ixat.io';
		$mail->FromName = 'ixat.io';
		$mail->AddAddress($email);
		$mail->IsHTML(true);
		$mail->Subject = $subject;
		$mail->Body    = '<html><body style="background-color: #FFF; color: #000; font-family: Arial;">' . $message . '</body></html>';
		$mail->AltBody = $message;
		if(!$mail->Send())
		{
		   //echo 'Message could not be sent.';
		   //echo 'Mailer Error: ' . $mail->ErrorInfo;
		   return false;
		}
		return true;
	}

	public function isDisposable($email)
	{
		$disposable = array('mt2015.com', 'maildrop.cc', 'throwam.com' ,'yhg.biz', 'mailsac.com','mailzi.ru','olypmail.ru','vkcode.ru','eyepaste.com','0815.ru0clickemail.com', '0wnd.net', '0wnd.org', '10minutemail.com', '20minutemail.com', '2prong.com', '3d-painting.com', '4warding.com', '4warding.net', '4warding.org', '9ox.net', 'a-bc.net', 'amilegit.com', 'anonbox.net', 'anonymbox.com', 'antichef.com', 'antichef.net', 'antispam.de', 'baxomale.ht.cx', 'beefmilk.com', 'binkmail.com', 'bio-muesli.net', 'bobmail.info', 'bodhi.lawlita.com', 'bofthew.com', 'brefmail.com', 'bsnow.net', 'bugmenot.com', 'bumpymail.com', 'casualdx.com', 'chogmail.com', 'cool.fr.nf', 'correo.blogos.net', 'cosmorph.com', 'courriel.fr.nf', 'courrieltemporaire.com', 'curryworld.de', 'cust.in', 'dacoolest.com', 'dandikmail.com', 'deadaddress.com', 'despam.it', 'devnullmail.com', 'dfgh.net', 'digitalsanctuary.com', 'discardmail.com', 'discardmail.de', 'disposableaddress.com', 'disposemail.com', 'dispostable.com', 'dm.w3internet.co.uk example.com', 'dodgeit.com', 'dodgit.com', 'dodgit.org', 'dontreg.com', 'dontsendmespam.de', 'dump-email.info', 'dumpyemail.com', 'e4ward.com', 'email60.com', 'emailias.com', 'emailinfive.com', 'emailmiser.com', 'emailtemporario.com.br', 'emailwarden.com', 'ephemail.net', 'explodemail.com', 'fakeinbox.com', 'fakeinformation.com', 'fastacura.com', 'filzmail.com', 'fizmail.com', 'frapmail.com', 'garliclife.com', 'get1mail.com', 'getonemail.com', 'getonemail.net', 'girlsundertheinfluence.com', 'gishpuppy.com', 'great-host.in', 'gsrv.co.uk', 'guerillamail.biz', 'guerillamail.com', 'guerillamail.net', 'guerillamail.org', 'guerrillamail.com', 'guerrillamailblock.com', 'haltospam.com', 'hotpop.com', 'ieatspam.eu', 'ieatspam.info', 'ihateyoualot.info', 'imails.info', 'inboxclean.com', 'inboxclean.org', 'incognitomail.com', 'incognitomail.net', 'ipoo.org', 'irish2me.com', 'jetable.com', 'jetable.fr.nf', 'jetable.net', 'jetable.org', 'junk1e.com', 'kaspop.com', 'kulturbetrieb.info', 'kurzepost.de', 'lifebyfood.com', 'link2mail.net', 'litedrop.com', 'lookugly.com', 'lopl.co.cc', 'lr78.com', 'maboard.com', 'mail.by', 'mail.mezimages.net', 'mail4trash.com', 'mailbidon.com', 'mailcatch.com', 'maileater.com', 'mailexpire.com', 'mailin8r.com', 'mailinator.com', 'mailinator.net', 'mailinator2.com', 'mailincubator.com', 'mailme.lv', 'mailnator.com', 'mailnull.com', 'mailzilla.org', 'mbx.cc', 'mega.zik.dj', 'meltmail.com', 'mierdamail.com', 'mintemail.com', 'moncourrier.fr.nf', 'monemail.fr.nf', 'monmail.fr.nf', 'mt2009.com', 'mx0.wwwnew.eu', 'mycleaninbox.net', 'mytrashmail.com', 'neverbox.com', 'nobulk.com', 'noclickemail.com', 'nogmailspam.info', 'nomail.xl.cx', 'nomail2me.com', 'no-spam.ws', 'nospam.ze.tc', 'nospam4.us', 'nospamfor.us', 'nowmymail.com', 'objectmail.com', 'obobbo.com', 'onewaymail.com', 'ordinaryamerican.net', 'owlpic.com', 'pookmail.com', 'proxymail.eu', 'punkass.com', 'putthisinyourspamdatabase.com', 'quickinbox.com', 'rcpt.at', 'recode.me', 'recursor.net', 'regbypass.comsafe-mail.net', 'safetymail.info', 'sandelf.de', 'saynotospams.com', 'selfdestructingmail.com', 'sendspamhere.com', 'shiftmail.com', '****mail.me', 'skeefmail.com', 'slopsbox.com', 'smellfear.com', 'snakemail.com', 'sneakemail.com', 'sofort-mail.de', 'sogetthis.com', 'soodonims.com', 'spam.la', 'spamavert.com', 'spambob.net', 'spambob.org', 'spambog.com', 'spambog.de', 'spambog.ru', 'spambox.info', 'spambox.us', 'spamcannon.com', 'spamcannon.net', 'spamcero.com', 'spamcorptastic.com', 'spamcowboy.com', 'spamcowboy.net', 'spamcowboy.org', 'spamday.com', 'spamex.com', 'spamfree24.com', 'spamfree24.de', 'spamfree24.eu', 'spamfree24.info', 'spamfree24.net', 'spamfree24.org', 'spamgourmet.com', 'spamgourmet.net', 'spamgourmet.org', 'spamherelots.com', 'spamhereplease.com', 'spamhole.com', 'spamify.com', 'spaminator.de', 'spamkill.info', 'spaml.com', 'spaml.de', 'spammotel.com', 'spamobox.com', 'spamspot.com', 'spamthis.co.uk', 'spamthisplease.com', 'speed.1s.fr', 'suremail.info', 'tempalias.com', 'tempemail.biz', 'tempemail.com', 'tempe-mail.com', 'tempemail.net', 'tempinbox.co.uk', 'tempinbox.com', 'tempomail.fr', 'temporaryemail.net', 'temporaryinbox.com', 'thankyou2010.com', 'thisisnotmyrealemail.com', 'throwawayemailaddress.com', 'tilien.com', 'tmailinator.com', 'tradermail.info', 'trash2009.com', 'trash-amil.com', 'trashmail.at', 'trash-mail.at', 'trashmail.com', 'trash-mail.com', 'trash-mail.de', 'trashmail.me', 'trashmail.net', 'trashymail.com', 'trashymail.net', 'tyldd.com', 'uggsrock.com', 'wegwerfmail.de', 'wegwerfmail.net', 'wegwerfmail.org', 'wh4f.org', 'whyspam.me', 'willselfdestruct.com', 'winemaven.info', 'wronghead.com', 'wuzupmail.net', 'xoxy.net', 'yogamaven.com', 'yopmail.com', 'yopmail.fr', 'yopmail.net', 'yuurok.com', 'zippymail.info', 'jnxjn.com', 'trashmailer.com', 'klzlk.com', 'nospamforus','kurzepost.de', 'objectmail.com', 'proxymail.eu', 'rcpt.at', 'trash-mail.at', 'trashmail.at', 'trashmail.me', 'trashmail.net', 'wegwerfmail.de', 'wegwerfmail.net', 'wegwerfmail.org', 'jetable', 'link2mail', 'meltmail', 'anonymbox', 'courrieltemporaire', 'sofimail', '0-mail.com', 'moburl.com', 'get2mail', 'yopmail', '10minutemail', 'mailinator', 'dispostable', 'spambog', 'mail-temporaire','filzmail','sharklasers.com', 'guerrillamailblock.com', 'guerrillamail.com', 'guerrillamail.net', 'guerrillamail.biz', 'guerrillamail.org', 'guerrillamail.de','mailmetrash.com', 'thankyou2010.com', 'trash2009.com', 'mt2009.com', 'trashymail.com', 'mytrashmail.com','mailcatch.com','trillianpro.com','junk.','joliekemulder','lifebeginsatconception','beerolympics','smaakt.naar.gravel','q00.','dispostable','spamavert','mintemail','tempemail','spamfree24','spammotel','spam','mailnull','e4ward','spamgourmet','mytempemail','incognitomail','spamobox','mailinator.com', 'trashymail.com', 'mailexpire.com', 'temporaryinbox.com', 'MailEater.com', 'spambox.us', 'spamhole.com', 'spamhole.com', 'jetable.org', 'guerrillamail.com', 'uggsrock.com', '10minutemail.com', 'dontreg.com', 'tempomail.fr', 'TempEMail.net', 'spamfree24.org', 'spamfree24.de', 'spamfree24.info', 'spamfree24.com', 'spamfree.eu', 'kasmail.com', 'spammotel.com', 'greensloth.com', 'spamspot.com', 'spam.la', 'mjukglass.nu', 'slushmail.com', 'trash2009.com', 'mytrashmail.com', 'mailnull.com', 'jetable.org','10minutemail.com', '20minutemail.com', 'anonymbox.com', 'beefmilk.com', 'bsnow.net', 'bugmenot.com', 'deadaddress.com', 'despam.it', 'disposeamail.com', 'dodgeit.com', 'dodgit.com', 'dontreg.com', 'e4ward.com', 'emailias.com', 'emailwarden.com', 'enterto.com', 'gishpuppy.com', 'goemailgo.com', 'greensloth.com', 'guerrillamail.com', 'guerrillamailblock.com', 'hidzz.com', 'incognitomail.net ', 'jetable.org', 'kasmail.com', 'lifebyfood.com', 'lookugly.com', 'mailcatch.com', 'maileater.com', 'mailexpire.com', 'mailin8r.com', 'mailinator.com', 'mailinator.net', 'mailinator2.com', 'mailmoat.com', 'mailnull.com', 'meltmail.com', 'mintemail.com', 'mt2009.com', 'myspamless.com', 'mytempemail.com', 'mytrashmail.com', 'netmails.net', 'odaymail.com', 'pookmail.com', 'shieldedmail.com', 'smellfear.com', 'sneakemail.com', 'sogetthis.com', 'soodonims.com', 'spam.la', 'spamavert.com', 'spambox.us', 'spamcero.com', 'spamex.com', 'spamfree24.com', 'spamfree24.de', 'spamfree24.eu', 'spamfree24.info', 'spamfree24.net', 'spamfree24.org', 'spamgourmet.com', 'spamherelots.com', 'spamhole.com', 'spaml.com', 'spammotel.com', 'spamobox.com', 'spamspot.com', 'tempemail.net', 'tempinbox.com', 'tempomail.fr', 'temporaryinbox.com', 'tempymail.com', 'thisisnotmyrealemail.com', 'trash2009.com', 'trashmail.net', 'trashymail.com', 'tyldd.com', 'yopmail.com', 'zoemail.com','deadaddress','soodo','tempmail','uroid','spamevader','gishpuppy','privymail.de','trashmailer.com','fansworldwide.de','onewaymail.com', 'mobi.web.id', 'ag.us.to', 'gelitik.in', 'fixmail.tk', 'trbvm.com', 'thrma.com', 'armyspy.com', 'dayrep.com', 'teleworm.us', 'cuvox.de', 'gustr.com', 'superrito.com');
		foreach($disposable as $fake)
		{
			$info = explode('@', $email);
			if(strcasecmp($info[1], $fake) == 0)
				return true;
		}
		return false;
	}
	public function random_letters($size=10)
	{
		$ret = ""; $l = str_split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890");
		for($i = 0; $i < $size; $i++) {
			$ret .= $l[array_rand($l)];
		}
		return $ret;
	}

	public function geo($ip="")
	{
		$geo = json_decode(file_get_contents("http://ipinfo.io/{$ip}/json"), true);
		$geo_info = array(
			"isp"    => $geo['org'],
			"region" => $geo['region'],
			"country"=> $geo['country']
		);
		return $geo_info;
	}
#logout

    public function logout($redirect = true)
    {
    	global $mysql, $config;
    	if(!isset($_COOKIE['loginKey']) || strlen($_COOKIE['loginKey']) != 32)
		{
			return false;
		}
		/*
		todo.w_d0 = (todo.w_bride = (todo.w_registered = (todo.w_VIP = (todo.w_Powers = undefined))));
		todo.w_k3 = 0;
		todo.w_PowerO = 0;
		todo.w_sn = 0;
		todo.w_xats = 0;
		todo.w_d2 = (todo.w_d3 = (todo.w_dt = (todo.w_coins = 0)));
		*/
		$query = array(
			"w_d0" => "",
			"w_bride" => "",
			"w_registered" => "",
			"w_VIP" => "",
			"w_Powers" => "",
			"w_k3" => 0,
			"w_PowerO" => 0,
			"w_sn" => 0,
			"w_xats" => 0,
			"w_d2" => 0,
			"w_d3" => 0,
			"w_dt" => 0,
			"w_coins" => 0,
		);
		$query = http_build_query($query);
    	return '<script>document.cookie = "loginKey=\'loggedoutffs\'";</script>'."<embed height=\"200\" width=\"200\" type=\"application/x-shockwave-flash\" flashvars=\"{$query}" . ($redirect ? '&redirect=1' : '') . "\" src=\"//{$config->info['server_domain']}/cache/cache.php?f=login2.swf&d=flash\" style=\"opacity:0;position:fixed;\">";
    }
	
	public function isChat()
	{
		global $mysql, $config, $core;

		return $this->page == "chat" && $this->chat !== false;
	}

	public function doPage()
	{
		global $core, $mysql, $config;

		$pages = $this->pages;
		$chat = $this->chat;
		require $this->pages[$this->page];
	}

	public function allset()
	{ /* So I can cheat */
		$args  = func_get_args();
		$array = array_shift($args);
		foreach($args as $index)
		{
			if(!isset($array[$index]) || !is_string($array[$index]))
			{
				return false;
			}
		}
		return true;
	}

	public function getEmbed($chat, $pass = false, $w = 728, $h = 486)
	{
		global $mysql, $config;
		$chat = $mysql->fetch_array('select * from `chats` where `name`=:a or `id`=:b;', array('a' => $chat, 'b' => $chat));
		$FlashVars = [];
		$FlashVars['id'] = $chat[0]["id"];
		if($pass !== false) {
			$FlashVars['pass'] = $pass;
		}
		if($chat[0]["attached"] != ''){
			//$FlashVars['xt'] = $chat[0]["attached"];
		}
		if($chat[0]["name"]!=''){
			$FlashVars['gn'] = $chat[0]["name"];
		}
		if (isset($_GET['debug'])) {
			$FlashVars['debug'] = '';
		}
		$FlashVars['xc'] = 2336;
		$FlashVars['cn'] = $this->cn;
		$FlashVars['gb'] = '9U6Gr';
		$FlashVars['lg'] = $this->lang;
		$FlashVars['v'] = core::version;
		//$uChat = (strlen($debug) > 0 ? 'chat2.swf' : 'chat2.swf') . '&v=' . core::version;
		$uChat = (isset($_GET['debug']) ? 'chat2d.swf' : 'chat.swf') . '&v=' . core::version . '' . time();
		$src = $this->http . "://ixat.io/cache/cache.php?f={$uChat}&d=flash" . (isset($_GET['debug']) ? '&debug' : '');
		$embed = '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="'.$w.'" height="'.$h.'" id="XenoBox">';
		$embed .= '<embed id="XenoBox" width="'.$w.'" height="'.$h.'" src="'.$src.'" quality="high" wmode="transparent" bgcolor="#000000" FlashVars="'.http_build_query($FlashVars).'" align="middle" type="application/x-shockwave-flash" /></object>';
		if(isset($_GET["new"]) && ($this->html5 || $this->admin))
			$embed = "<iframe src='" . $this->http . "://ixat.io/web/chat.php#" . http_build_query($FlashVars) . "' width='{$w}' height='{$h}' frameborder='0' scrolling='no'></iframe>";
		return empty($chat) ? false : $embed;
	}

	public function getPcalc($id) {
        list($subid, $section) = array(
            pow(2, $id % 32),
            $id >> 5
        );
        return array('subid'=>$subid,'section'=>$section);
    }

	//EDITED just a test
	public function refreshLogin($redirect = true, $html5 = false)
	{
		global $mysql, $config;
		if(!isset($_COOKIE['loginKey']) || strlen($_COOKIE['loginKey']) != 32)
		{
			return false;
		}

		$user = $mysql->fetch_array('select * from `users` where `loginKey`=:key;', ['key' => $_COOKIE['loginKey']]);
		if(empty($user))
		{
			return false;
		}
		$user = (object) $user[0];

		$upowers = $this->GetUserPower($user->id);
		unset($upowers[0]);
		unset($upowers[95]);

		$spowers = $mysql->fetch_array("select * from `powers` where `name` not like '%(Undefined)%';");
		list($vals, $p, $dO, $powerO, $pp, $allArray, $epArray, $myArray) = [[], [], '', '', '', [], [], []];
		foreach($spowers as $i => $u)
		{
			if($u["id"] < 0) $u["id"] = abs($u["id"]) + 640;
            $section = 'p' . ($u['id'] >> 5);
            $subid = (int)pow(2, $u["id"] % 32);
			$vals[$u["id"]] = array($section, $subid);
			if(!isset($p[$section]))
			{
				$p[$section] = 0;
			}
			if($u['p'] == 1){
				if($u['limited'] == 0){
					array_push($allArray, $u['id']);
				}
				array_push($epArray, $u['id']);
			}
		}

		foreach($upowers as $i => $u)
		{
			if($u >= 1 && isset($vals[$i]) && isset($p[$vals[$i][0]]))
			{
				$str = $i . '=' . ($u > 1 ? ($u -1) : 1) . '|';
				$dO .= $str;
				if($u > 1)
				{
					$powerO .= $str;
				}
				$p[$vals[$i][0]] += $vals[$i][1];
				array_push($myArray, $i);
			}
		}

		$GiveEp = true;
		$GiveAll = true;

		foreach($epArray as $v){
			$GiveEp = in_array($v, $myArray) && $GiveEp != false ? true:false;
			if(in_array($v, $allArray)){
				$GiveAll = in_array($v, $myArray) && $GiveAll != false ? true:false;
				if($GiveAll == false) break;
			}
		}

        $parray = [];
		if($GiveEp == true) {
			$p["p2"] |= 2147483648;
            $parray[] = 95;
		}

		if($GiveAll == true) {
			$p["p0"] |= 1;
            $parray[] = 0;
		}
        
        if (count($parray) > 0) {
            $this->AddUserPower($user->id, $parray);
        }

	/* Nickname / Status */
		$nickname = explode('##', base64_decode($user->nickname), 2);
		if(count($nickname) != 2)
		{
			$nickname[1] = "";
		}
        /*
        if ($html5) {
            $query['DeviceId']     = md5($user->connectedlast);
            $query['LastGroup']    = 1;
            $query['LastName']     = 'Lobby';
            $query['MobNo']        = 0;
            $query['PassHash']     = $user->password;
            $query['PhoneNumHash'] = 0;
            $query['Token']        = '';
            $query['w_ALLP']       = 0;
            $query['w_VIP']        = 0;
            $query['w_cb']         = time();
            $query['w_coins']      = $user->xats;
            $query['w_dt']         = time();
            $query['w_email']      = '';
            $query['w_userrev']    = 0;
        }*/
        
		$query['w_userno'] = $user->id;
		$query['w_avatar'] = $user->avatar;
		$query['w_k1'] = $user->k;
		$query['w_d0'] = $user->d0;
		$query['w_d1'] = $user->days;
		$query['w_d2'] = $user->d2;
		$query['w_d3'] = '';

		foreach($p as $i => $u)
		{
			$query["w_d" . (substr($i, 1) + 4)] = $u;
		}

		$query['w_dt'] = '0';
		$query['w_homepage'] = $user->url;
		$query['w_Powers'] = implode(',', $p);
		$query['w_PowerO'] = $powerO;
		$query['w_status'] = $nickname[1];
		$query['w_dO'] = $dO;
		$query['w_dx'] = $user->xats;
		$query['w_registered'] = $user->username;
		$query['w_k2'] = $user->k2;
		$query['w_k3'] = $user->k3;
		$query['w_name'] = $nickname[0];
		$vars = http_build_query($query);
        /*
        $storage = [
            'Favorites'     => ['Lobby' => ['a' => 'http://i.imgur.com//n98NdYk.png', 'd' => '', 'g' => 'Lobby', 'id' => '1']], // only used for fullscreen web version not classic
            'Settings'      => ['font' => 'medium', 'indicate' => '', 'language' => '', 'notifications' => '', 'tortoise' => ''], // sets itself
            'halloween'     => [], // dont know what this is used for
            'stash'         => [], // not clue wtf this is
            'todo'          => [], // userinfo
            'w_Mask'        => [], // sets itself
            'w_Powers'      => [], // sets itself
            'w_contactlist' => [], // sets itself
            'w_friendlist3' => [ // friendlist from db example
                '3' => [
                    'N'    => '1', 
                    'New'  => '1', 
                    'S'    => '1', 
                    'a'    => 'http://i67.tinypic.com/w6993.jpg', 
                    'f'    => '1', 
                    'h'    => 'https://i.imgur.com/Z8KHYQc.png_http://i63.tinypic.com/1ih005.png|_1263', 
                    'last' => '1509409368',
                    'n'    => 'Daniel', 
                    'v'    => '2'
                ]
            ],
            'w_ignorelist2' => [] // sets itself
        ];*/
	/* Finish Login */
		$logArr = [
            'flash' => "<embed height=\"200\" width=\"200\" type=\"application/x-shockwave-flash\" flashvars=\"{$vars}" . ($redirect ? '&redirect=1' : '') . "\" src=\"//{$config->info['server_domain']}/cache/cache.php?f=login2.swf&d=flash\" style=\"opacity:0;position:fixed;\">",
            'html5' => json_encode(['DeviceId' => md5($user->connectedlast), 'PassHash' => $user->password, 'w_userno' => $user->id, 'w_registered' => $user->username])
        ];
        return $html5 ? $logArr : $logArr['flash'];
	}
	
	public function refreshLogin_Test($redirect = false)
	{
		global $mysql, $config;
		$user = $mysql->fetch_array('select `id` from `users` where `loginKey`=:key;', array('key' => $_COOKIE['loginKey']));
		if(empty($user))
		{
			return false;
		}
		$user = (object) $user[0];

		$this->DelUserPower($user->id, 95);
		$this->DelUserPower($user->id, 0);

		$upowers = $this->GetUserPower($user->id);
		print_r($upowers);
		$spowers = $mysql->fetch_array("select * from `powers` where `name` not like '%(Undefined)%';");
		list($vals, $p, $dO, $powerO, $pp, $allArray, $epArray, $myArray) = array(array(), array(), '', '', '', array(), array(), array());
		foreach($spowers as $i => $u)
		{
			if($u["id"] < 0) $u["id"] = abs($u["id"]) + 640;
			//if($u['subid'] >= 2147483647) continue;
            $section = 'p' . ($u['id'] >> 5);
            $subid = (int)pow(2, $u["id"] % 32);
			$vals[$u["id"]] = array($section, $subid);
			if(!isset($p[$section]))
				$p[$section] = 0;

			if($u['p'] == 1){
				if($u['limited'] == 0) 
					array_push($allArray, $u['id']);
				array_push($epArray, $u['id']);
			}
		}

		foreach($upowers as $i => $u)
		{
			if($u >= 1 && isset($vals[$i]) && isset($p[$vals[$i][0]]))
			{
				$str = $i . '=' . ($u > 1 ? ($u -1) : 1) . '|';
				$dO .= $str;
				if($u > 1) 
					$powerO .= $str;
				$p[$vals[$i][0]] |= $vals[$i][1];
				array_push($myArray, $i);
			}
		}

		$GiveEp = true;
		$GiveAll = true;

		foreach($epArray as $v){
			if(in_array($v, $myArray) && $GiveEp != false){
				$GiveEp = true;
			} else {
				$GiveEp = false;
			}
			if(in_array($v, $allArray)){
				if(in_array($v, $myArray) && $GiveAll != false){
					$GiveAll = true;
				} else {
					$GiveAll = false;
				}
			}
		}


		if($GiveEp == true) {
			//$ep = $this->getPcalc(95);
			//$p["p".$ep['section']] |= $ep['subid'];
			$p["p2"] = 2147483647;
			$this->AddUserPower($user->id, 95);
		}

		if($GiveAll == true) {
			//$all = $this->getPcalc(0);
			//$p["p".$all['section']] |= $all['subid'];
			$p["p0"] |= 1;
			$this->AddUserPower($user->id, 0);
		}

	/* Nickname / Status */
		$nickname = explode('##', base64_decode($user->nickname), 2);
		if(count($nickname) != 2)
		{
			$nickname[1] = "";
		}

		$query['w_userno'] = $user->id;
		$query['w_avatar'] = $user->avatar;
		$query['w_k1'] = $user->k;
		$query['w_d0'] = $user->d0;
		$query['w_d1'] = $user->days;
		$query['w_d2'] = $user->d2;
		$query['w_d3'] = '';

		foreach($p as $i => $u)
		{
			$query["w_d" . (substr($i, 1) + 4)] = $u;
		}

		$query['w_dt'] = '0';
		$query['w_homepage'] = $user->url;
		$query['w_Powers'] = implode(',', $p);
		$query['w_PowerO'] = $powerO;
		$query['w_status'] = $nickname[1];
		$query['w_dO'] = $dO;
		$query['w_dx'] = $user->xats;
		$query['w_registered'] = $user->username;
		$query['w_k2'] = $user->k2;
		$query['w_k3'] = $user->k3;
		$query['w_name'] = $nickname[0];
		print_r($query);
		$vars = http_build_query($query);
	/* Finish Login */
		return "<embed height=\"1\" width=\"1\" type=\"application/x-shockwave-flash\" flashvars=\"{$vars}" . ($redirect ? '&redirect=1' : '') . "\" src=\"//{$config->info['server_domain']}/cache/cache.php?f=login.swf&d=flash\">";
	}

}

$core = new core();
i18n::setLang('en');

if(isset($_GET['ajax'])/* || isset($_GET['page']) && ($_GET['page'] == 'config' || $_GET['page'] == 'mobile')*/)
{
	if(isset($_GET['ajax']))
	{
		header('Content-Type: text/plain');
	}
	$core->doPage();
	exit;
}
