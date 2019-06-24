package {
	import flash.xml.*;
	import flash.events.*;
	import com.adobe.serialization.json.*;
	import flash.display.*;
	import flash.text.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.system.*;
	import flash.external.*;
	import flash.external.ExternalInterface;

	public class network {

		public static var iprules = new Object();
		public static var xNumAttempts = 10;
		public static var xFlag = 0;
		public static var attempt = 0;
		public static var LastBanMsg;
		private static var KillBlast;
		public static var prevrpool = -1;
		public static var NetworkState;
		public static var NetworkTimeout;
		public static var MessageCount;
		public static var LurkerLimit;
		public static var LurkerTimeout;
		public static var socket;
		public static var UnfairFile:String = "";
		public static var UnfairMessage:String = "";
		public static var UnfairGroupName:String = "";
		public static var GotDone:Boolean = false;
		public static var GotFirstDone:Boolean = false;
		public static var w_redirectdom = undefined;
		public static var w_redirectport = undefined;
		public static var QK = false;
		public static var YI = undefined;
		public static var YC:int = undefined;
		public static var YC2:int = undefined;
		public var WV = false;
		public var WC:int = 0;
		public static var FI = undefined;
		public static var LastLocate = 0;
		public static var fs = 0;
		public static var sjt = 0;
		public static var jt1 = 0;
		public static var jt2 = 0;
		public static var UngagTimeout = undefined;
		public static var Bootp = undefined;
		public static var UserId;
		public static var k1;
		public static var k2;
		public static var J2_Order;
		public static var ipLoaded = false;
		static var p_w = 100;
		static var p_h = 100;
		static var p_octaves = 6;
		static var p_seed = 12345;
		static var p_x = 50;
		static var p_y = 50;
		static var codeLoad;
		public var codeLoader:Loader = new Loader();
		public var yo1:String = "auth2,auth,cb,Y,fuckm1,fuckm2,huem3,huem4,q,y,k,k3,d1,z,p,c,b,r,f,e,u";
		public var yo2:String = "dO,sn,dx,dt,N,n,a,h,v,cv";

		//iXat
		var cv:Array = new Array();
		var authKey:int = 0;
		var authMA:Array = new Array();
		static var mcCode:int = 0;

		public static function NetworkInit(){
			NetworkState = 0;
			NetworkTimeout = -1;
			MessageCount = 0;
			LurkerLimit = ((12 * 60) * 5);
			LurkerTimeout = -1;
		}
		public static function NetworkStartChat(){
			ipLoaded = true;
			SetNetworkState(14, 60);
		}
		public static function NetworkStartChat2(){
			var _local1:URLRequest;
			var _local2:URLLoader;
			xmessage.ClearLists(true);
			UngagTimeout = undefined;
			if((todo.w_userrev != undefined) && (!todo.w_k1 || todo.w_k2 == 0)) {
				UserId = undefined;
				_local1 = new URLRequest();
				_local1.url = todo.chatdomain + "auser3.php?" + "u=" + xatlib.xInt(todo.w_userno) + "&k2=" + todo.w_k2 + "&t=" + Math.random();
				_local1.method = URLRequestMethod.GET;
				_local2 = new URLLoader();
				_local2.load(_local1);
				_local2.addEventListener(Event.COMPLETE, ausercompleteHandler);
			} else if(todo.w_userrev == undefined) {
				UserId = 2;
			} else {
				UserId = todo.w_userno;
				k1 = todo.w_k1;
				k2 = todo.w_k2;
			}
			SetNetworkState(1, 120);
			todo.DoBuildUserListScrollUp = true;
		}
		public static function NetworkClose(){
			SetNetworkState(0, -1);
			if (socket){
				if (socket.connected){
					socket.close();
				};
			};
			if (todo.messageecho == "s"){
				if (chat.sending_lc){
					chat.sending_lc.send(chat.fromxat, "onMsg", 4, 0, "o");
				};
			};
		}
		
		public static function SetNetworkState(param1:*, param2:*) : * {
			var _local3:String = null;
			NetworkState = param1;
			NetworkTimeout = param2;
			if(main.ButtonLoginMc != undefined) {
				if(NetworkState == 0) {
					_local3 = xconst.ST(19);
				} else if(NetworkState == 4) {
					_local3 = xconst.ST(31);
				} else {
					_local3 = xconst.ST(32);
				}
				main.ButtonLoginMc.SetText(_local3);
			}
		}

		public static function NetworkTick(){
			var _local2:*;
			var _local3:*;
			var _local4:Number;
			var _local5:*;
			var _local6:*;
			var _local_7:*;
			var _local_8:*;
			var _local_9:int;
			if (NetworkTimeout != -1){
				NetworkTimeout = (NetworkTimeout - 1);
				if (NetworkTimeout < 0){
					NetworkTimeout = 0;
				};
			};
			if (NetworkState == 1){
				auserLoaded();
				if (NetworkTimeout == 0){
					SetNetworkState(0, -1);
					xatlib.GeneralMessage(xconst.ST(100), (xconst.ST(98) + " (AT)"));
				};
			} else if (NetworkState == 3){
					if (NetworkTimeout == 0){
						if (attempt < xNumAttempts){
							attempt++;
							SetNetworkState(0, -1);
							todo.lb = "n";
							todo.DoUpdate = true;
							NetworkClose();
							NetworkStartChat();
						} else {
							SetNetworkState(0, -1);
							xatlib.GeneralMessage(xconst.ST(100), (xconst.ST(98) + " (CT)"));
						};
					};
			} else if (NetworkState == 4){
				if (LurkerTimeout != -1){
					if ((((todo.w_userno < (0x77359400 - 100000))) || ((todo.w_userno >= 0x77359400)))){
						if (LurkerTimeout <= 0){
							NetworkSendMsg(todo.w_userno, "/KEEPALIVE", 0, 0, 1);
						} else {
							LurkerTimeout = (LurkerTimeout - 1);
						};
					};
				};
			} else if (NetworkState == 5){
				if (NetworkTimeout != -1){
					if (NetworkTimeout == 0){
						NetworkStartChat();
					};
				} else {
					NetworkStartChat();
				};
			} else if (NetworkState == 6){
				if (YI != undefined){
					if (todo.w_password != undefined){
						NetworkLogin(todo.w_email, todo.w_password);
						WV = true;
					};
					SetNetworkState(7, 120);
				};
				if (NetworkTimeout == 0){
					SetNetworkState(0, -1);
					xatlib.GeneralMessage(xconst.ST(100), (xconst.ST(98) + " (Y)"));
				};
			} else if (NetworkState == 7){
				if (WC != 1){
					if ((mcCode) && (mcCode != 0)){
						WC = mcCode;
						WV = false;
						mcCode = 0;
					};
				};
				if ((((WV == false)) && ((WC > 0)))){
					myOnJoin();
					WC = 0;
				};
			} else if(NetworkState != 8) {
				if(NetworkState != 9) {
					if(NetworkState != 11) {
						if(NetworkState != 12) {
							if(NetworkState != 13) {
								if(NetworkState == 14) {
									if(ipLoaded || NetworkTimeout == 0) {
										ipLoaded = true;
										NetworkStartChat2();
									}
								}
							}
						}
					}
				}
			}
			MessageCount = (MessageCount - 1);
			if (MessageCount < 0){
				MessageCount = 0;
			};
			if (((((!((todo.MessageToProcess == ""))) && (!((todo.lb == "n"))))) && (GotDone))){
				main.ProcessMessage();
			};
			if (((((((!((todo.MessageToSend == ""))) && ((MessageCount <= 0)))) && (!((todo.lb == "n"))))) && (GotDone))){
				if (((todo.w_k1) && (!((todo.MessageToSend.indexOf(todo.w_k1.toString()) == -1))))){
					todo.MessageToSend = xatlib.Replace(todo.MessageToSend, todo.w_k1.toString(), Math.floor((Math.random() * 0x80000000)).toString());
				};
				if (((todo.w_k3) && (!((todo.MessageToSend.indexOf(todo.w_k3.toString()) == -1))))){
					todo.MessageToSend = xatlib.Replace(todo.MessageToSend, todo.w_k3.toString(), Math.floor((Math.random() * 0x80000000)).toString());
				};
				_local2 = xatlib.CountLinks(todo.MessageToSend);
				if (_local2 <= 2){
					NetworkSendMsg(todo.w_userno, todo.MessageToSend, todo.PrivateChat, todo.PrivateMessage, 0);
					todo.PrivateChat = (todo.PrivateMessage = 0);
					main.lockmc._visible = false;
					if ((((todo.messageecho == "l")) && ((_local2 > 0)))){
						if (chat.sending_lc){
							chat.sending_lc.send(chat.fromxat, "onMsg", 4, todo.w_userno, todo.MessageToSend);
						};
					};
				};
				MessageCount = 25;
				todo.LastMessageToSend = todo.MessageToSend;
				todo.MessageToSend = "";
			};
			if(todo.w_registered != undefined && FI && todo.tick % 12 == 6 && todo.lb == "t" && GotDone && (w_redirectport == undefined || w_redirectport == 80)) {
				_local3 = todo.w_friendlist.length;
				if(fs > 0) {
					xatlib.MainSolWrite("w_friendlist2",todo.w_friendlist2);
				}
				fs = 0;
				_local4 = 0;
				while(_local4 < _local3) {
					_local5 = todo.w_friendlist[_local4];
					_local6 = _local5.u;
					if(_local6 > 6 && todo.w_friendlist2[_local6] == undefined) {
						_local7 = "";
						_local8 = "";
						if(_local5.k && _local5.k.length) {
							_local8 = ";==" + _local5.k;
						}
						if(_local5.u != todo.w_userno) {
							_local7 = "/b " + _local6 + "," + "1" + "," + "" + "," + _local5.n.substr(0,20) + _local8;
						} else {
							if(todo.w_Mask == undefined) {
								todo.w_Mask = todo.NO_POWERS.slice();
							}
							_local7 = "/b " + _local6 + "," + "1" + "," + "" + "," + _local5.n.substr(0,128) + _local8 + "," + todo.w_friendlist[_local4].a.toString().substr(0,128) + "," + todo.w_friendlist[_local4].h.substr(0,128) + "," + todo.w_friendlist[_local4].v.toString();
							_local9 = 0;
							while(_local9 < todo.MAX_PWR_INDEX) {
								_local7 = _local7 + ("," + xatlib.xInt(todo.w_Mask[_local9]));
								_local9++;
							}
						}
						chat.xtrace("network","FRIENDDATABASE=" + _local7);
						NetworkSendMsg(todo.w_userno,_local7,0,0,2);
						todo.w_friendlist2[_local6] = {"flags":1};
						if(++fs >= 5) {
							break;
						}
					}
					_local4++;
				}
				if(fs == 0) {
					FI = false;
				}
			}
			var _local1:* = getTimer();
			if(todo.lb == "t" && _local1 > UngagTimeout) {
				_local4 = xatlib.FindUser(todo.w_userno);
				todo.Users[_local4].gagged = false;
				todo.DoBuildUserList = true;
				UngagTimeout = undefined;
			}
		}
		private static function ipcompleteHandler(_arg1:Event):void{
			if (ipLoaded){
				return;
			};
			var _local2:URLLoader = URLLoader(_arg1.target);
			iprules = xJSON.decode(_local2.data);
			xFlag = iprules["xFlag"];
			xNumAttempts = iprules["order"].length;
			ipLoaded = true;
		}
		static function ipcompleteError(_arg1:ErrorEvent):void{
			ipLoaded = true;
		}
		private static function ausercompleteHandler(_arg1:Event):void{
			var _local2:URLLoader = URLLoader(_arg1.target);
			var _local3:URLVariables = new URLVariables(_local2.data.substr(1));
			UserId = _local3.UserId;
			k1 = _local3.k1;
			k2 = _local3.k2;
		}
		public static function auserLoaded() : * {
			var Port:* = undefined;
			var IsBanned:Boolean = false;
			var vx:* = undefined;
			var ta:* = undefined;
			var ctimeout:* = undefined;
			var so4:* = undefined;
			var rn:* = undefined;
			if(UserId == undefined) {
				chat.xtrace("network","auserLoaded: not yet.");
			} else if(UserId == 0) {
				SetNetworkState(0,-1);
				if(xFlag & 2) {
					xatlib.xLog("A_" + todo.w_useroom + "_" + todo.useport + "_" + todo.sockdomain);
				}
				xatlib.GeneralMessage(xconst.ST(100),xconst.ST(98) + " (A)");
				todo.lb = "n";
				todo.DoUpdate = true;
			} else {
				if(UserId != 2) {
					todo.w_userno = xatlib.xInt(UserId);
					todo.w_k1 = k1;
					todo.w_k2 = xatlib.xInt(k2);
					so4 = xatlib.getLocal("chat","/");
					so4.objectEncoding = ObjectEncoding.AMF0;
					Boolean(1);
					if(so4 != null) {
						so4.data.w_userno = xatlib.xInt(todo.w_userno);
						so4.data.w_userrev = todo.w_userrev;
						if(todo.w_k1 is String && todo.w_k1.length > 16) {
							so4.data.w_k1c = todo.w_k1;
						} else {
							so4.data.w_k1b = todo.w_k1;
						}
						so4.data.w_k2 = todo.w_k2;
						so4.flush();
					}
					if(todo.w_name == "") {
						todo.w_name = xatlib.GetDefaultName(todo.w_userno);
					}
					if(todo.w_avatar == "") {
						todo.w_avatar = xatlib.GetDefaultAvatar(todo.w_userno);
					}
					if(todo.w_homepage == "") {
						todo.w_homepage = "";
					}
				} else {
					rn = xatlib.xInt(Math.random() * 1000000);
					if(todo.w_name == "") {
						todo.w_name = xatlib.GetDefaultName(rn);
					}
					if(todo.w_avatar == "") {
						todo.w_avatar = xatlib.GetDefaultAvatar(rn);
					}
					if(todo.w_homepage == "") {
						todo.w_homepage = "";
					}
				}
				IsBanned = OnGagList(todo.w_useroom);
				vx = todo.Macros;
				xmessage.ClearLists(true);
				todo.Users.push({
					"n":xatlib.NameNoXat(todo.w_name),
					"s":(todo.Macros != undefined?todo.Macros["status"]:undefined),
					"u":todo.w_userno,
					"v":todo.w_userrev,
					"a":todo.w_avatar,
					"h":todo.w_homepage,
					"online":true,
					"banned":IsBanned,
					"owner":false,
					"OnXat":(xatlib.xInt(global.xc) & 32) != 0,
					"registered":todo.w_registered,
					"VIP":todo.w_VIP,
					"Bride":todo.w_d2,
					"aFlags":todo.w_d0,
					"Powers":todo.w_Powers,
					"cb":todo.w_cb
				});
				AddGiftPower(0);
				todo.DoUpdateMessages = true;
				todo.ScrollDown = true;
				todo.LastScrollTime = undefined;
				ctimeout = 20;
				if(todo.sockdomain == "0" || todo.useport == 0) {
					SetNetworkState(0,-1);
					if(xFlag & 2) {
						xatlib.xLog("Z_" + todo.w_useroom + "_" + todo.useport + "_" + todo.sockdomain);
					}
					xatlib.GeneralMessage(xconst.ST(100),xconst.ST(98) + " (Z)");
				} else {
					var catchIOError:Function = function(param1:IOErrorEvent):* {
						chat.xtrace("network","socket error caught=" + param1);
						if(NetworkState == 3) {
							NetworkTimeout = 0;
						}
					};
					var catchSecurityError:Function = function(param1:SecurityErrorEvent):void {
						chat.xtrace("network","socket security error caught=" + param1);
					};
					socket = new XMLSocket();
					socket.addEventListener(Event.CONNECT,myOnConnect);
					socket.addEventListener(DataEvent.DATA,myOnXML);
					socket.addEventListener(Event.CLOSE,socketClose);
					socket.addEventListener(IOErrorEvent.IO_ERROR,catchIOError);
					socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,catchSecurityError);
					chat.xtrace("network","Port=" + todo.useport + " " + todo.sockdomain);
					sjt = getTimer();
					socket.connect(todo.sockdomain,todo.useport);
					SetNetworkState(3,ctimeout);
				}
			}
		}
		
		public static function socketClose(_arg1:Event){
			if (w_redirectport == undefined){
				SetNetworkState(5, Math.floor(((Math.random() * 12) * 4)));
				todo.lb = "n";
				todo.DoUpdate = true;
			};
		}
		
		
		public static function myOnConnect(param1:Event) : * {
			var _local3:* = undefined;
			var _local4:* = undefined;
			var _local5:String = null;
			if(NetworkState == 3) {
				YI = undefined;
				_local3 = new XMLDocument();
				_local4 = _local3.createElement("y");
				if(todo.useport == 80) {
					_local4.attributes.p = GetPort(todo.w_useroom);
					_local4.attributes.s = GetDom(todo.w_useroom);
				}
				if(todo.pass != undefined) {
					_local4.attributes.m = 1;
				}
				_local4.attributes.r = todo.w_useroom;
				_local4.attributes.v = attempt;
				_local4.attributes.u = (((todo.w_userno > 0)) ? todo.w_userno : 2);
				_local3.appendChild(_local4);
				_local5 = xatlib.XMLOrder(_local3,new Array("w","r","m","s","p","v","u"));
				socket.send(_local5);
				chat.xtrace("tx",_local5);
				SetNetworkState(6,120);
			} else {
				chat.xtrace("network","Extra Fail");
			}
		}
		
		public static function myOnJoin(){
			var _local8:*;
			var _local9:*;
			var _local10:*;
			var _local11:*;
			var _local12:*;
			var _local13:*;
			var _local14:int;
			SetNetworkState(4, -1);
			todo.DoUserSnd = true;
			var _local1:String = xatlib.CleanTextNoXat(todo.w_name);
			var _local2:* = xatlib.CleanText(todo.w_avatar);
			var _local3:String = xatlib.CleanText(todo.w_homepage);
			var _version:String = String(chat.cVersion).replace("_", ".");
			if (_local1 == null){
				_local1 = "";
			};
			if (_local2 == null){
				_local2 = "";
			};
			if (_local3 == null){
				_local3 = "";
			};
			if (((todo.HasPowerA(todo.w_Powers, xconst.pssh["pcbr"])) && (todo.HasPowerA(todo.w_Powers, xconst.pssh["pcback"])))){
				_local8 = todo.Macros["pcbr"];
				if (_local8){
					_local8 = _local8.split(",");
					if (_local8.length > 1){
						_local8.sort(xatlib.randomSort);
						_local8.sort(xatlib.randomSort);
						_local13 = 0;
						while (_local13 < _local8.length) {
							_local12 = _local8[_local13];
							if (_local12.charAt(0) == "f"){
								_local11 = true;
								_local12 = _local12.substr(1);
							};
							if (_local12.substr(0, 4) == "http"){
								if (((!(_local9)) && (!(_local11)))){
									_local9 = _local12;
								};
								if (((!(_local10)) && (_local11))){
									_local10 = _local12;
								};
							};
							_local13++;
						};
						if (_local9){
							_local2 = _local2.split("#http");
							_local2 = _local2[0];
							_local2 = (_local2 + ("#" + _local9));
							if (_local10){
								_local2 = (_local_ + ("#" + _local10));
							};
						};
					};
				};
			};
			GotDone = false;
			var _local4:* = new XMLDocument();
			var _local5:* = _local4.createElement("j2");
			_local5.attributes.v = ((todo.w_userrev)==undefined) ? 0 : todo.w_userrev;
			_local5.attributes.h = _local3.substr(0, 128);
			_local5.attributes.a = _local2.substr(0, 128);
			_local5.attributes.n = _local1.substr(0, 256);
			if (todo.Macros != undefined){
				if (todo.Macros["status"] != undefined){
					_local5.attributes.n = (_local5.attributes.n + ("##" + todo.Macros["status"].substr(0, 128)));
				};
			};
			
			if (todo.w_registered != undefined){
				_local5.attributes.N = todo.w_registered;
			};
			if (todo.w_dt){
				_local5.attributes.dt = todo.w_dt;
			};
			if (todo.w_xats){
				_local5.attributes.dx = todo.w_xats;
			};
			if (todo.w_sn){
				_local5.attributes.sn = todo.w_sn;
			};
			if (todo.w_PowerO != undefined){
				_local5.attributes.dO = todo.w_PowerO;
			};
			if (todo.w_Powers != null){
				_local14 = 0;
				while (_local14 < todo.MAX_PWR_INDEX) {
					if (todo.w_Powers[_local14]){
						_local5.attributes[("d" + (_local14 + 4))] = todo.w_Powers[_local14];
					};
					_local14++;
				};
			};
			if (todo.w_d3){
				_local5.attributes.d3 = todo.w_d3;
			};
			if (todo.w_d2){
				_local5.attributes.d2 = todo.w_d2;
			};
			if (todo.w_d0 != undefined){
				_local5.attributes.d0 = todo.w_d0;
			};
			if (todo.w_Mask != null){
				_local14 = 0;
				while (_local14 < todo.MAX_PWR_INDEX) {
					if (todo.w_Mask[_local14]){
						_local5.attributes[("m" + _local14)] = todo.w_Mask[_local14];
					};
					_local14++;
				};
			};
			_local5.attributes.u = ((todo.w_userrev)==undefined) ? 2 : todo.w_userno;
			if (global.rf){
				_local5.attributes.e = "1";
			};
			_local5.attributes.f = (global.um != undefined?0:!!(todo.w_autologin & 1)?0:1) | (!!todo.LoginPressed?2:0) | (global.pass != undefined?4:0);
			todo.w_autologin = (todo.w_autologin | 1);
			if (((todo.pass) || (!((global.pass == undefined))))){
				_local5.attributes.r = ((global.pass)!=undefined) ? global.pass : todo.pass;
			};
			if (OnGagList(todo.w_useroom)){
				_local5.attributes.b = GetGagTime(todo.w_useroom);
			};
			_local5.attributes.c = todo.w_useroom;
			if(chat.stest && xatlib.xInt(todo.Macros["stest"])) {
				_local5.attributes.c = xatlib.xInt(todo.Macros["stest"]);
			}
			if (todo.w_pool != undefined){
				_local5.attributes.p = todo.w_pool;
			};
			if (todo.w_d1){
				_local5.attributes.d1 = todo.w_d1;
			};
			_local5.attributes.k3 = xatlib.xInt(todo.w_k3);
			_local5.attributes.k = todo.w_k1;
			_local5.attributes.y = YI;
			if ((global.xc & 32)){
				_local5.attributes.q = 1;
			};

			_local5.attributes.auth = WC;
			var _local6:BitmapData = new BitmapData(100, 100, false, 13376924);
			_local6.perlinNoise(p_w, p_h, p_octaves, p_seed, false, true, BitmapDataChannel.ALPHA | BitmapDataChannel.RED | BitmapDataChannel.GREEN | BitmapDataChannel.BLUE, false, null);
			_local5.attributes.auth2 = _local6.getPixel32(p_x, p_y);
			_local5.attributes.fuckm1 = Math.floor(2 << (YI % 30)) % YC + YI;
			_local5.attributes.fuckm2 = Math.floor(Math.pow(2, YS % 32));
			_local5.attributes.huem3 = Math.floor(Math.pow(2, (YI % 32))) + 1
			_local5.attributes.huem4 = Math.floor(Math.PI * (YS * YS));
			_local5.attributes.cb = 0;//todo.w_cb;
			_local5.attributes.cv = xJSON.encode(cv);

			//_local6.dispose();

			_local4.appendChild(_local5);
			if (!J2_Order){
			   // J2_Order = "auth2,auth,cb,Y,fuckm1,fuckm2,huem3,huem4,q,y,k,k3,d1,z,p,c,b,r,f,e,u";
				J2_Order = yo1;
				_local14 = 0;
				while (_local14 < todo.MAX_PWR_INDEX) {
					J2_Order = (J2_Order + (",m" + _local14));
					_local14++;
				};
				J2_Order = (J2_Order + ",d0");
				_local14 = 2;
				while (_local14 < (todo.MAX_PWR_INDEX + 4)) {
					J2_Order = (J2_Order + (",d" + _local14));
					_local14++;
				};
				//J2_Order = (J2_Order + ",dO,sn,dx,dt,N,n,a,h,v,cv");
				J2_Order = (J2_Order + "," + yo2);
				J2_Order = J2_Order.split(",");
			};
			var _local7:String = xatlib.XMLOrder(_local4, J2_Order);
			J2_Order = undefined;
			socket.send(_local7);
			todo.lb = "t";
			todo.OnSuper = true;
			todo.DoUpdate = true;
			todo.ResetSmilies = true;
			LurkerTimeout = LurkerLimit;
			if (todo.messageecho == "s"){
				if (chat.sending_lc){
					chat.sending_lc.send(chat.fromxat, "onMsg", 4, 0, "i");
				};
			};
			if (todo.messageecho == "a"){
				if (chat.sending_lc){
					chat.sending_lc.send(chat.fromxat, "onMsg", 4, 0, "d");
				};
			};
			xatlib.MainSolWrite("w_lastroom", todo.w_useroom);
		}
        public static function SetSuperPowers(_arg_1:*){
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            if (!todo.Users[_arg_1].VIP){
                return;
            };
            for (_local_5 in xconst.SuperPowers) {
                _local_6 = true;
                for (_local_4 in xconst.SuperPowers[_local_5]) {
                    if (!todo.HasPower(_arg_1, xconst.SuperPowers[_local_5][_local_4])){
                        _local_6 = false;
                        break;
                    };
                };
                if (_local_6){
                    _local_2 = xatlib.xInt((_local_5 / 32));
                    _local_3 = (1 << (_local_5 % 32));
                    todo.Users[_arg_1].Powers[_local_2] = (xatlib.xInt(todo.Users[_arg_1].Powers[_local_2]) | _local_3);
                    if (todo.Users[_arg_1].UnmaskedPowers !== undefined){
                        todo.Users[_arg_1].UnmaskedPowers[_local_2] = (xatlib.xInt(todo.Users[_arg_1].UnmaskedPowers[_local_2]) | _local_3);
                    };
                };
            };
        }
		public static function myOnXML(_arg1:DataEvent){
			var u:* = undefined;
			var UserIndex:* = undefined;
			var U:* = undefined;
			var n:* = undefined;
			var stra:* = undefined;
			var t:* = 0;
			var uid:* = 0;
			var t55:* = undefined;
			var s:* = undefined;
			var vx:* = undefined;
			var str:* = null;
			var pstr:* = undefined;
			var gpa:* = undefined;
			var ll:* = undefined;
			var j:* = undefined;
			var c:* = undefined;
			var temp_comm:* = undefined;
			var IsPrivateMessage:* = false;
			var IsPrivateChat:* = false;
			var IsNew:* = false;
			var IsDeleteMessage:* = undefined;
			var IsGagUser:* = undefined;
			var IsUnGagUser:* = undefined;
			var IsMakeUser:* = undefined;
			var IsUnMakeUser:* = undefined;
			var IsKickUser:* = undefined;
			var IsUnknown:* = undefined;
			var IsControlMessage:* = undefined;
			var IsLocateUser:* = undefined;
			var IsAtUser:* = undefined;
			var IsScroller:* = undefined;
			var FirstTwo:* = undefined;
			var IsSlash:* = undefined;
			var zz:* = undefined;
			var tgagged:* = undefined;
			var tbanned:* = undefined;
			var tfriend:* = undefined;
			var tmodplus:* = undefined;
			var IsIgnored:* = false;
			var strText:* = null;
			var lc:* = undefined;
			var Links:* = undefined;
			var Payload:* = undefined;
			var TypeOn:* = undefined;
			var TypeOff:* = undefined;
			var farray:* = null;
			var id:* = undefined;
			var f:* = undefined;
			var friobj:* = null;
			var ns:* = undefined;
			var len:* = undefined;
			var i:* = NaN;
			var so93:* = undefined;
			var pci:* = undefined;
			var ptime:* = undefined;
			var tt:* = undefined;
			var TabsLength:* = undefined;
			var Duration:* = undefined;
			var gc:* = undefined;
			var rank:* = undefined;
			var uuid:* = undefined;
			var arg:* = undefined;
			var selfid:* = NaN;
			var Friend:* = 0;
			var loctext:* = undefined;
			var pp:* = undefined;
			var ii:* = undefined;
			var d:* = undefined;
			var g:* = undefined;
			var msgno:* = undefined;
			var v:* = undefined;
			var NoBanMessage:* = undefined;
			var BanTime:* = undefined;
			var my_date:* = null;
			var UnfairTitle:* = null;
			var UnfairReport:* = null;
			var hh:* = undefined;
			var so47:* = undefined;
			var vt:* = undefined;
			var nopc:* = undefined;
			var nom:* = undefined;
			var maxpc:* = undefined;
			var maxm:* = undefined;
			var RemoveMessage:* = undefined;
			var HaveTab:* = undefined;
			var AllowPC:* = undefined;
			var TabNumber:* = NaN;
			var self:* = NaN;
			var IsMainOwner:* = false;
			var IsOwner:* = false;
			var IsModerator:* = false;
			var IsMember:* = false;
			var IsOnline:* = false;
			var IsBanned:* = false;
			var IsForever:* = false;
			var IsGagged:* = false;
			var OnXat:* = false;
			var IsVIP:* = false;
			var Powers:* = undefined;
			var IsStealth:* = false;
			var cc:* = undefined;
			var a:* = undefined;
			var ee:* = undefined;
			var StringIndex:* = 0;
			var type:* = undefined;
			var Text:* = undefined;
			var left:* = NaN;
			var RndOr:* = undefined;
			var Rnd2:* = undefined;
			var q:* = undefined;
			var sarray:* = null;
			var p:* = undefined;
			var doautoredirect:* = false;
			var reason:* = undefined;
			var bootr:* = undefined;
			var errnum:* = 0;
			var event:* = _arg1;
			var doc:* = new XMLDocument(event.data);
			var _version:String = String(chat.cVersion).replace("_",".");
			var yo:* = undefined;
			var e:* = doc.firstChild;
			var DontIgnore:* = false;
			if (e.attributes.n != undefined){
				e.attributes.n.replace(xatlib.r1, "");
				e.attributes.n.replace(xatlib.r2, "");
			};
			if (e.attributes.t != undefined){
				e.attributes.t.replace(xatlib.r1, "");
				e.attributes.t.replace(xatlib.r2, "");
			};
			if (e != null){
				u = xatlib.xInt(e.attributes.u);
				UserIndex = xatlib.FindUser(u);
				if (UserIndex >= 0){
					U = todo.Users[UserIndex];
				};
				if (((e.attributes.t) && ((e.attributes.u > 0)))){
					n = 0;
					while (n < e.attributes.t.length) {
						if (e.attributes.t.charCodeAt(n) < 32){
							return;
						};
						n++;
					};
				};
				if (e.nodeName == "y"){
					WV = true;
					if (e.attributes.o) {
						yo = xatlib.xJSONdecode(e.attributes.o)
						yo1 = yo[0].join(",")
						yo2 = yo[1].join(",")
					};
					if (e.attributes.k != undefined)  {
						todo.WY = {"k": xatlib.xInt(e.attributes.k)};
						WC = 0;
						authKey = xatlib.xInt(e.attributes.k);
						if(e.attributes.a != undefined) {
							authMA = xatlib.xJSONdecode(e.attributes.a);
						} else {
							authMA = new Array(128, 64, 256, 2);
						}
						doCode();
					} else {
						WC = 1;
					}

					YI = xatlib.xInt(e.attributes.i);
					YC = xatlib.xInt(e.attributes.c);
					YS = xatlib.xInt(e.attributes.s);
					jt2 = (getTimer() - sjt);
					YC2 = getTimer();
					cv = new Object();

					if (((e.attributes.cb) && (!((global.sv == e.attributes.cb))))){
						global.sv = e.attributes.cb;
						xatlib.MainSolWrite("w_sv", e.attributes.cb);
					};

					if (e.attributes.p) {
						stra = e.attributes.p.split("_");
						p_w = xatlib.xInt(stra[0]);
						p_h = xatlib.xInt(stra[1]);
						p_octaves = xatlib.xInt(stra[2]);
						p_seed = xatlib.xInt(stra[3]);
						t = (YI % (p_w * p_h));
						p_x = (t % p_w);
						p_y = Math.floor((t / p_w));
					};

					cv["version"] = _version;

					attempt = 0;
					prevrpool = -1;
				} else if (e.nodeName == "x"){
					UpdateChannel(e.attributes.i, e.attributes.u);
					if (((((((((!((e.attributes.i == 10001))) || (!((e.attributes.t.substr(0, 1) == "b"))))) || (todo.Users[UserIndex].mainowner))) || (todo.Users[UserIndex].owner))) || (todo.Users[UserIndex].moderator))){
						if ((((e.attributes.i >= 40000)) && ((e.attributes.i < 50000)))){
							if (chat.sending_lc){
								chat.sending_lc.send(chat.fromxat, "onMsg", e.attributes.i, e.attributes.u, e.toString());
							};
						} else if ((((((e.attributes.i == 10000)) && ((e.attributes.t.substr(0, 1) == "B")))) && ((todo.HasPower(selfid, 44) == false)))){
						} else if (chat.sending_lc){
							chat.sending_lc.send(chat.fromxat, "onMsg", e.attributes.i, e.attributes.u, e.attributes.t);
						};
					};
				} else if (e.nodeName == "a"){
					uid = xatlib.FindUser(e.attributes.u);
					if (e.attributes.h){
						t55 = !(todo.HasPower(uid, (e.attributes.h % 10000)));
					} else {
						t55 = xconst.kssw[e.attributes.k];
						if (t55){
							t55 = !(todo.HasPower(uid, t55));
						};
					};
					if (!t55){
						if ((((((e.attributes.u == todo.w_userno)) || ((uid < 0)))) || (!((todo.Users[uid].ignored == true))))){
							if(e.attributes.k != "T" && todo.HasPower(xatlib.FindUser(todo.w_userno), xconst.pssh["dnd"]) && todo.Macros["dnd"] == "on"){
								//todo.helpstr = "<inf9> " + e.attributes.k + ": (" + e.attributes.k + ") " + e.attributes.t;
								//todo.HelpUpdate = 0;
								todo.Message.push({
									n:0,
									t:"<inf9> " + e.attributes.k + ": (" + e.attributes.k + ") " + e.attributes.t,
									u:e.attributes.u,
									s:0,
									d:0
								});
								todo.DoUpdateMessages = true;
								todo.ScrollDown = true;
							} else {
								xkiss.Kiss({
									t:e.attributes.t,
									u:e.attributes.u,
									k:e.attributes.k,
									h:e.attributes.h,
									b:e.attributes.b,
									f:e.attributes.f,
									x:e.attributes.x,
									s:e.attributes.s,
									e:e.attributes.e,
									j:e.attributes.j
								});
							}
						};
					};
					if (e.attributes.c > 0){
						todo.w_coins = xatlib.xInt(e.attributes.c);
						xatlib.MainSolWrite("w_coins", todo.w_coins);
					};
				} else if (e.nodeName == "bl"){
					if(KillBlast && KillBlast > getTime()) {
						KillBlast = 0;
						return;
					}
					xkiss.LoadWink(e);
				} else if (e.nodeName == "v"){
					if (e.attributes.e != undefined){
						t = xatlib.xInt(e.attributes.t);
						var _local3 = xatlib.xInt(e.attributes.e);
						n = _local3;
						switch (_local3){
							case 6:
								s = xconst.ST(164);
								break;
							case 8:
								s = xconst.ST(165);
								break;
							case 10:
								s = xconst.ST(166);
								break;
							case 11:
								s = xconst.ST(167);
								break;
							case 13:
								s = xconst.ST(25);
								break;
							case 14:
								s = xconst.ST(168);
								break;
							case 15:
								s = xconst.ST(169);
								break;
							case 16:
								s = xconst.ST(170);
								break;
							case 17:
								s = xconst.ST(171);
								break;
							case 18:
								s = xconst.ST(172);
								break;
							case 22:
								s = xconst.ST(173);
								break;
							case 24:
								s = xconst.ST(187, t.toString());
								break;
							case 36:
								s = xconst.ST(215);
								break;
							case 38:
								s = xconst.ST(234);
								if (t){
									s = (s + (" " + xconst.ST(235, t.toString())));
								};
								break;
							case 50:
								s = "Single power prevents this";
								break;
							case 59:
								s = xconst.ST(281);
								break;
							case 60:
								s = xconst.ST(36);
								todo.w_userrev = 0;
								todo.w_k1 = "";
								SaveRegData();
								break;
							default:
								s = ((xconst.ST(174) + " ") + n);
						};
						if (n != 39){
							xatlib.GeneralMessage(xconst.ST(175), s);
						};
						if (e.attributes.m == undefined){
							todo.w_d0 = (todo.w_bride = (todo.w_registered = (todo.w_VIP = (todo.w_Powers = undefined))));
							todo.w_k3 = 0;
							todo.w_PowerO = 0;
							todo.w_sn = 0;
							todo.w_xats = 0;
							todo.w_d2 = (todo.w_d3 = (todo.w_dt = (todo.w_coins = 0)));
							if ((((todo.w_email == 0)) && ((todo.w_password == "$0")))){
								SaveRegData();
								try {
									main.mcLoad.LoggedIn(1);
								} catch(e:Error) {
								};
							} else {
								try {
									main.mcLoad.LoggedIn(0);
								} catch(e:Error) {
								};
							};
						};
					} else {
						todo.w_userno = e.attributes.i;
						todo.w_userrev = 0;
						todo.w_k1 = e.attributes.k1;
						todo.w_d0 = e.attributes.d0;
						todo.w_d1 = e.attributes.d1;
						todo.w_d2 = xatlib.xInt(e.attributes.d2);
						todo.w_d3 = xatlib.xInt(e.attributes.d3);
						todo.w_dt = xatlib.xInt(e.attributes.dt);
						todo.w_Powers = [];
						t = 0;
						while (t < todo.MAX_PWR_INDEX) {
							todo.w_Powers.push(xatlib.xInt(e.attributes[("d" + (t + 4))]));
							t = (t + 1);
						};
						todo.w_PowerO = e.attributes.dO;
						t = xatlib.FindUser(todo.w_d2);
						if (t >= 0){
							todo.w_bride = todo.Users[t].registered;
						};
						todo.w_coins = xatlib.xInt(e.attributes.c);
						todo.w_xats = e.attributes.dx;
						todo.w_sn = e.attributes.sn;
						if (todo.w_xats){
							todo.w_coins = xatlib.xInt(todo.w_xats);
						};
						todo.w_registered = e.attributes.n;
						todo.w_k2 = e.attributes.k2;
						todo.w_k3 = e.attributes.k3;
						todo.w_cb = YC;
						SaveRegData();
						if (((todo.WV2) || (e.attributes.RL))){
							todo.lb = "n";
							todo.DoUpdate = true;
							NetworkClose();
							NetworkStartChat();
							todo.WV2 = false;
						};
						vx = todo.Macros;
						xmessage.ClearLists(true);
						todo.Users.push({
							n:xatlib.NameNoXat(todo.w_name),
							s:((todo.Macros)!=undefined) ? todo.Macros["status"] : undefined,
							u:todo.w_userno,
							v:todo.w_userrev,
							a:todo.w_avatar,
							h:todo.w_homepage,
							online:true,
							banned:IsBanned,
							owner:false,
							OnXat:!(((xatlib.xInt(global.xc) & 32) == 0)),
							registered:todo.w_registered,
							VIP:todo.w_VIP,
							Bride:todo.w_d2,
							aFlags:todo.w_d0,
							Powers:todo.w_Powers
						});
						AddGiftPower(0);
						todo.DoBuildUserList = true;
						todo.DoUpdateMessages = true;
						todo.ScrollDown = true;
						todo.LastScrollTime = undefined;
						try {
							main.mcLoad.LoggedIn(1);
						} catch(e:Error) {
						};
						if (todo.messageecho == "s"){
							if (chat.sending_lc){
								chat.sending_lc.send(chat.fromxat, "onMsg", 4, 0, "l");
							};
						};
					};
					todo.w_password = undefined;
					WV = false;
				} else if (e.nodeName == "ap"){
					str = " ";
					pstr = xconst.pssa[(xatlib.xInt(e.attributes.p) + 1)];
					switch (xatlib.xInt(e.attributes.r)){
						case 0:
							str = xconst.ST(239, pstr);
							break;
						case 1:
							str = xconst.ST(240, pstr);
							break;
						case 2:
							str = xconst.ST(241, pstr);
							break;
						case 3:
							str = xconst.ST(242, pstr);
							break;
						case 4:
							str = (pstr + " already assigned");
							break;
						case 9:
							str = (pstr + " system error (db down)");
							break;
						default:
							str = (pstr + " unknown errorcode");
					};
					xatlib.GeneralMessage(xconst.ST(237), str);
				} else if (e.nodeName == "gp"){
					gpa = e.attributes.p.split("|");
					ll = 0;
					while (ll < gpa.length) {
						todo.w_GroupPowers[ll] = xatlib.xInt(gpa[ll]);
						ll++;
					};
					for (ll in e.attributes) {
						if (ll.charAt(0) == "g"){
							if (todo.HasPowerA(todo.w_GroupPowers, xatlib.xInt(ll.substr(1)))){
								todo.gconfig[ll] = e.attributes[ll];
								if (todo.gconfig[ll].charAt(0) == "{"){
									todo.gconfig[ll] = xatlib.xJSONdecode(todo.gconfig[ll]);
								};
							};
						};
					};
					if (todo.gconfig["g100"]){
						ll = todo.gconfig["g100"].split(",");
						todo.gconfig["g100"] = {};
						j = 0;
						while (j < ll.length) {
							todo.gconfig["g100"][ll[j]] = ll[(j + 1)];
							j = (j + 2);
						};
					};
					if (todo.HasPowerA(todo.w_GroupPowers, 90)){
						xconst.MakeBads(e.attributes.g90);
					};
					if (((todo.HasPowerA(todo.w_GroupPowers, 106)) && (todo.gconfig["g106"]))){
						c = todo.gconfig["g106"].split("#");
						if (todo.HasPowerA(todo.w_GroupPowers, 130)){
							todo.gconfig["g130"] = c.pop();
							if (todo.Macros["gback"] === "off"){
								delete todo.gconfig["g130"];
							};
						};
						t = 0;
						while (t < c.length) {
							c[t] = xatlib.DecodeColor(c[t]);
							t = (t + 1);
						};
						todo.gconfig["g106"] = c.join("#");
						if (!todo.gconfig["g74"]){
							todo.gconfig["g74"] = "smile,biggrin,wink,eek,tongue,cool,mad,confused,redface,frown,crying,look,rolleyes,star,kiss,vampire,pirate2";
							todo.w_GroupPowers[2] = (todo.w_GroupPowers[2] | 0xFFFF);
						};
					};
					if (todo.HasPowerA(todo.w_GroupPowers, xconst.pssh["lang"])){
						temp_comm = (((todo.usedomain + "/json/lang/customlang2.php?t=" + todo.w_room_cb) + "&r=") + todo.w_useroom);
						xatlib.LoadVariables(temp_comm, chat.onLang);
					};
				} else if ((((((((e.nodeName == "m")) || ((e.nodeName == "p")))) || ((e.nodeName == "c")))) || ((e.nodeName == "z")))){
					if (((!(GotDone)) && ((global.xc & 0x8000)))){
						return;
					};
					IsPrivateMessage = false;
					IsPrivateChat = false;
					IsNew = true;
					IsDeleteMessage = false;
					IsGagUser = false;
					IsUnGagUser = false;
					IsMakeUser = false;
					IsUnMakeUser = false;
					IsKickUser = false;
					IsUnknown = false;
					IsControlMessage = false;
					IsLocateUser = false;
					IsAtUser = false;
					IsScroller = false;
					if (!e.attributes.t){
						e.attributes.t = "";
					};
					FirstTwo = e.attributes.t.substr(0, 2);
					IsSlash = (FirstTwo.substr(0, 1) == "/");
					if (e.attributes.u == 0){
						IsScroller = false;
					};
					if ((((e.nodeName == "p")) || ((e.nodeName == "z")))){
						IsPrivateMessage = true;
					};
					if (e.nodeName == "c"){
						IsControlMessage = true;
					};
					if ((e.attributes.s & 1)){
						IsNew = false;
					};
					if (((IsPrivateMessage) && ((e.attributes.s & 2)))){
						IsPrivateChat = true;
					};
					if (((((!(IsSlash)) && ((e.nodeName == "m")))) && ((e.attributes.u == undefined)))){
						return;
					};
					if (e.attributes.t.indexOf("<inf7>") != -1){
						IsSlash = true;
					};
					e.attributes.t = xatlib.Replace(e.attributes.t, ">", "}");
					if (((((e.attributes.T) && (e.attributes.h))) && ((e.nodeName == "z")))){
						//Techy ~shitty temp fix for hugs braking chats (will add better fix server sided)
						e.attributes.t = ((((("<h>;=" + e.attributes.h) + ";=") + e.attributes.t.replace(/;=/gi, "")) + ";=") + e.attributes.d);
						if (e.attributes.j){
							e.attributes.t = (e.attributes.t + (";=" + e.attributes.j));
							uid = xatlib.FindUser(e.attributes.u);
							if (uid >= 0){
								todo.Users[uid].JinxMe = e.attributes.j;
							};
						};
					};

					if (((((IsPrivateMessage) && (!(IsPrivateChat)))) && (!(IsSlash)))) {
						e.attributes.t = ("<priv> " + e.attributes.t);
					};
					if (IsSlash){
						if (FirstTwo == "/d"){
							IsDeleteMessage = true;
						};
						if (FirstTwo == "/s"){
							IsScroller = true;
						};
						if ((((e.nodeName == "c")) && ((FirstTwo == "/g")))){
							IsGagUser = true;
						};
						if ((((e.nodeName == "c")) && ((FirstTwo == "/u")))){
							IsUnGagUser = true;
						};
						if ((((e.nodeName == "c")) || ((e.nodeName == "p")))){
							if (FirstTwo == "/m"){
								IsMakeUser = true;
							};
							if (FirstTwo == "/r"){
								IsUnMakeUser = true;
							};
							if (FirstTwo == "/k"){
								IsKickUser = true;
							};
						};
						if (e.nodeName == "z"){
							if (FirstTwo == "/l"){
								IsLocateUser = true;
							};
							if (FirstTwo == "/a"){
								IsAtUser = true;
							};
						};
						if (FirstTwo == "/R"){
							Payload = e.attributes.t.substr(2);
							TypeOn = (Payload == "TypeOn");
							TypeOff = (Payload == "TypeOff");
							if (((TypeOn) || (TypeOff))){
								if (((((TypeOff) || (IsPrivateMessage))) || (!(main.ctabsmc.TabIsPrivate())))){
									main.SetTyping(u, TypeOn);
								};
							};
							return;
						};
						if (FirstTwo == "/b"){
							if (e.attributes.t == "/bd"){
								todo.w_friendlist.length = 0;
								todo.w_friendlist2 = new Object();
							} else if (e.attributes.t == "/bf") {
									xatlib.MainSolWrite("w_friendlist", todo.w_friendlist);
									xatlib.MainSolWrite("w_friendlist2", todo.w_friendlist2);
							} else {
								farray = e.attributes.t.substr(3).split(",");
								id = xatlib.xInt(farray[0]);
								f = xatlib.xInt(farray[1]);
								if (id == todo.w_userno){
									so93 = xatlib.getLocal("chat", "/");
									so93.objectEncoding = ObjectEncoding.AMF0;
									if (((1) && (!((so93 == null))))){
										todo.w_name = (so93.data.w_name = xatlib.CleanTextNoXat(farray[3]));
										todo.w_avatar = (so93.data.w_avatar = ((farray[4])!=undefined) ? xatlib.CleanAv(farray[4]) : "");
										todo.w_homepage = (so93.data.w_homepage = ((farray[5])!=undefined) ? xatlib.UrlAv(farray[5]) : "");
										todo.w_userrev = (so93.data.w_userrev = ((farray[6])!=undefined) ? farray[6] : 0);
										if (farray[7].indexOf("|") != -1){
											todo.w_Mask = (so93.data.w_Mask = farray[7].split("|"));
										};
										uid = xatlib.FindUser(todo.w_userno);
										if (uid != -1){
											todo.Users[uid].n = todo.w_name;
											todo.DoBuildUserList = true;
											xmessage.DeleteOneUserMc(uid);
										};
										so93.flush();
									};
								};
								len = todo.w_friendlist.length;
								i = 0;
								while (i < len) {
									if (todo.w_friendlist[i].u == id){
										friobj = todo.w_friendlist[i];
										break;
									};
									i = (i + 1);
								};
								if (!friobj){
									friobj = new Object();
									todo.w_friendlist.push(friobj);
								};
								friobj.u = id;
								friobj.v = xatlib.xInt(friobj.v);
								ns = farray[3].split(";==");
								friobj.n = xatlib.CleanTextNoXat(ns[0]);
								if (ns[1]){
									if (ns[1].charAt((ns[1].length - 1)) == "."){
										friobj.n = ns[1].substr(0, (ns[1].length - 1));
									} else {
										friobj.k = ns[1];
									};
								};
								if (!friobj.a){
									friobj.a = "";
								};
								if (!friobj.h){
									friobj.h = "";
								};
								friobj.f = f;
								if (todo.w_friendlist2[id] == undefined){
									todo.w_friendlist2[id] = new Object();
								};
								todo.w_friendlist2[id].flags = (xatlib.xInt(todo.w_friendlist2[id].flags) | 1);
							};
						};
						if(FirstTwo == "/p") {
							pci = xatlib.xInt(e.attributes.t.indexOf(","));
							if(pci != -1) {
								i = xatlib.FindUser(todo.w_userno);
								todo.Users[i].gagged = true;
								todo.DoBuildUserList = true;
								UngagTimeout = getTimer() + xatlib.xInt(e.attributes.t.substr(pci + 1)) * 1000;
							}
							ptime = 0;
							if(pci == -1) {
								ptime = xatlib.xInt(e.attributes.t.substr(2));
							} else {
								ptime = xatlib.xInt(e.attributes.t.substr(2,pci - 1));
							}
							id = " (" + e.attributes.d + ")";
							if(ptime == 0) {
								if(pci == -1) {
									UngagTimeout = 0;
								}
							} else if(ptime == -1) {
								len = todo.Users.length;
								tt = 0;
								while(tt < len) {
									todo.Users[tt].gagged = undefined;
									tt++;
								}
								todo.DoBuildUserList = true;
								todo.helpstr = xconst.ST(192) + id;
								todo.HelpUpdate = 0;
							} else {
								if(!e.attributes.T || e.attributes.T == " ") {
									todo.helpstr = xconst.ST(193,Math.ceil(ptime / 60).toString()) + id;
								} else {
									todo.helpstr = xconst.ST(261) + " /p" + e.attributes.T + id;
								}
								todo.HelpUpdate = 0;
							}
						}
						if (FirstTwo == "/t"){
							TabsLength = main.ctabsmc.tabs.length;
							tt = 0;
							while (tt < TabsLength) {
								if ((((main.ctabsmc.tabs[tt].User == u)) && ((main.ctabsmc.tabs[tt].Flags & 16)))){
									xkiss.Kiss({
										t:e.attributes.t.substr(2),
										u:e.attributes.u,
										k:"Ttth"
									});
									main.Private_onDelete(tt);
									break;
								};
								tt++;
							};
						};
						if (e.nodeName == "m"){
							if ((((FirstTwo == "/k")) && ((e.attributes.t.charAt(2) == "a")))){
								e.attributes.t = ("<i> " + xconst.ST(123, "(kickall#)", e.attributes.t));
								IsSlash = false;
							} else if ((((((((((((FirstTwo == "/g")) || ((FirstTwo == "/u")))) || ((FirstTwo == "/m")))) || ((FirstTwo == "/r")))) || ((FirstTwo == "/k")))) || ((FirstTwo == "/n")))){
								if (e.attributes.p != undefined){
									e.attributes.p = xatlib.Replace(e.attributes.p, ">", " ");
								};
								uid = xatlib.FindUser(e.attributes.d);
								Duration = xatlib.xInt(e.attributes.t.substr(2));
								if (!Duration){
									Duration = xatlib.xInt(e.attributes.t.substr(3));
								};
								if(uid != -1) {
									if(FirstTwo == "/g") {
										if(e.attributes.t.substr(0,3) == "/gg") {
											e.attributes.t = SysMsg(5,undefined,uid,e.attributes.p,Duration);
										} else if(e.attributes.t.substr(0,3) == "/gr" && !e.attributes.w) {
											e.attributes.t = SysMsg(8,undefined,uid,e.attributes.p,Duration);
											DontIgnore = true;
										} else if(e.attributes.t.substr(0,3) == "/gm") {
											e.attributes.t = SysMsg(6,undefined,uid,e.attributes.p,Duration);
											if(todo.HasPower(UserIndex, xconst.pssh["silentban"])) {
												gc = todo.gconfig["g80"];
												if ((gc is Object)){
													while (1) {
														rank = todo.gconfig["g80"]["ssb"];
														if (((!((rank == undefined))) && ((xatlib.GetRank(todo.w_userno) >= rank)))) break;
														rank = todo.gconfig["g80"]["cbs"];
														if (((!((rank == undefined))) && ((xatlib.GetRank(u) >= rank)))) break;
														KillBlast = (getTimer() + 1000);
														return;
													};
												} else {
													KillBlast = (getTimer() + 1000);
													return;
												};
											}
										} else {
											e.attributes.t = SysMsg(2,undefined,uid,e.attributes.p,Duration,e.attributes.w);
										}
										LastBanMsg = 0;
									} else if(FirstTwo == "/u") {
										e.attributes.t = SysMsg(3,undefined,uid,e.attributes.p,Duration);
									} else if(FirstTwo == "/m") {
										e.attributes.t = SysMsg(0,e.attributes.p,uid);
									} else if(FirstTwo == "/r") {
										e.attributes.t = SysMsg(0,"r",uid);
									} else if(FirstTwo == "/k") {
										uuid = xatlib.FindUser(e.attributes.u);
										arg = [];
										if(e.attributes.p) {
											arg = e.attributes.p.split("#");
										}
										if(arg.length == 2 && !todo.HasPower(uuid,25)) {
											e.attributes.p = arg[0];
										}
										if(arg.length == 3 && !todo.HasPower(uuid,121)) {
											e.attributes.p = arg[0];
										}
										e.attributes.t = SysMsg(1,undefined,uid,e.attributes.p);
									} else if(FirstTwo == "/n") {
										e.attributes.t = SysMsg(4,e.attributes.p,uid);
									}
									IsSlash = false;
								}
							}
						}
					}
					if (!IsSlash){
						if (UserIndex >= 0){
						};
						if ((((UserIndex >= 0)) && ((todo.Users[UserIndex].w == 176)))){
							e.attributes.t = xatlib.ReversePower(e.attributes.t);
						};
						e.attributes.t = xatlib.PreProcSmilie(e.attributes.t, !((u == todo.w_userno)));
					};
					if (todo.w_mainowner){
						IsGagUser = false;
					};
					MessageCount = 0;
					if ((((UserIndex == -1)) && (((((!(IsSlash)) || (e.attributes.N))) || (e.attributes.n))))){
						if (u != 0){
							if ((((todo.FlagBits & xconst.f_Live)) && ((e.nodeName == "m")))){
								todo.Users.push({
									n:"",
									u:u,
									v:0,
									a:"",
									h:"",
									online:((e.nodeName)=="z") ? undefined : false,
									onsuper:((e.nodeName)=="z") ? true : undefined,
									owner:false,
									friend:OnFriendList(u)
								});
								UserIndex = xatlib.FindUser(u);
								todo.Users[UserIndex].n = xatlib.StripSmilies(xatlib.NameNoXat(e.attributes.n));
								todo.Users[UserIndex].a = e.attributes.a;
								todo.Users[UserIndex].h = e.attributes.h;
								todo.Users[UserIndex].sn = xatlib.xJSONdecode(e.attributes.sn);
								todo.Users[UserIndex].v = e.attributes.v;
								if (todo.Users[UserIndex].n == ""){
									todo.Users[UserIndex].n = xatlib.GetDefaultName(todo.Users[UserIndex].u);
								};
								if (todo.Users[UserIndex].a == ""){
									todo.Users[UserIndex].a = xatlib.GetDefaultAvatar(todo.Users[UserIndex].u);
								};
								if (todo.Users[UserIndex].h == ""){
									todo.Users[UserIndex].h = "";
								};
								todo.Users[UserIndex].registered = e.attributes.N;
								todo.Users[UserIndex].q = e.attributes.q;
								todo.Users[UserIndex].Bride = xatlib.xInt(e.attributes.d2);
								todo.Users[UserIndex].aFlags = xatlib.xInt(e.attributes.d0);
							} else {
								todo.Users.push({
									n:"",
									u:u,
									v:0,
									a:"",
									h:"",
									online:((e.nodeName)=="z") ? undefined : false,
									onsuper:((e.nodeName)=="z") ? true : undefined,
									owner:false,
									friend:OnFriendList(u)
								});
								UserIndex = xatlib.FindUser(u);
							};
						};
					};
					tgagged = ((UserIndex)!=-1) ? todo.Users[UserIndex].gagged : false;
					tbanned = ((UserIndex)!=-1) ? ((todo.Users[UserIndex].banned) && (!((todo.Users[UserIndex].flag0 & 131072)))) : false;
					tfriend = ((UserIndex)!=-1) ? todo.Users[UserIndex].friend : false;
					if (((((((((IsPrivateMessage) && (((((tgagged) || (tbanned))) || ((e.attributes.b == 1)))))) && (!(tfriend)))) && (!(IsAtUser)))) && (!(IsLocateUser)))){
						return;
					};
					tmodplus = ((UserIndex)!=-1) ? (((((((todo.Users[UserIndex].u < 1000)) || (todo.Users[UserIndex].mainowner))) || (todo.Users[UserIndex].owner))) || (todo.Users[UserIndex].moderator)) : false;
					if (((((((((((((IsPrivateMessage) && (!(IsPrivateChat)))) && (todo.HasPowerA(todo.w_Powers, 69, todo.w_Mask)))) && (!(tfriend)))) && (!(tmodplus)))) && (!(IsAtUser)))) && (!(IsLocateUser)))){
						return;
					};
					if (((IsControlMessage) && (tbanned))){
						return;
					};
					if ((e.attributes.q & 2)){
						todo.Users[UserIndex].VIP = true;
					};
					if(e.nodeName == "z") {
						if(U) {
							if(U.onsuper != true) {
								xmessage.DeleteOneUserMc(UserIndex);
							}
							U.onsuper = true;
							U.available = false;
							U.available = false;
						}
					} else if(e.nodeName == "m" && GotDone) {
						if(UserIndex != -1 && todo.Users[UserIndex].gagged) {
							todo.Users[UserIndex].gagged = false;
							todo.DoBuildUserList = true;
						}
						if(UserIndex != -1 && todo.Users[UserIndex].online != true) {
							xmessage.DeleteOneUserMc(UserIndex);
						}
						/* Causes users to appear online when you switch pools even if they are offline
						if(UserIndex != -1) {
							todo.Users[UserIndex].online = true;
						}
						*/
					}
					if (((!((UserIndex == -1))) && ((todo.Users[UserIndex].online == false)))){
						if (e.attributes.n != undefined){
							if (UserIndex != -1){
								if (e.attributes.n.substr(0, 1) == "$"){
									e.attributes.n = e.attributes.n.substr(1);
								};
								todo.Users[UserIndex].n = xatlib.NameNoXat(e.attributes.n);
								todo.Users[UserIndex].a = e.attributes.a;
								todo.Users[UserIndex].h = e.attributes.h;
								todo.Users[UserIndex].v = e.attributes.v;

								if (todo.Users[UserIndex].n == ""){
									todo.Users[UserIndex].n = xatlib.GetDefaultName(todo.Users[UserIndex].u);
								};
								if (todo.Users[UserIndex].a == ""){
									todo.Users[UserIndex].a = xatlib.GetDefaultAvatar(todo.Users[UserIndex].u);
								};
								if (todo.Users[UserIndex].h == ""){
									todo.Users[UserIndex].h = "";
								};
								todo.Users[UserIndex].registered = e.attributes.N;
								xmessage.DeleteOneUserMc(UserIndex);
								todo.DoUpdateMessages = true;
							};
						};
					};
					if (((((((!((UserIndex == -1))) && (GotDone))) && ((((todo.Users[UserIndex].n == "")) || ((GetRev(e.attributes.u) > todo.Users[UserIndex].v)))))) && (!(IsSlash)))){
						NetworkLocateUser(u);
					};
					if (((!((UserIndex == -1))) && (OnFriendList(todo.Users[UserIndex].u)))){
						len = todo.w_friendlist.length;
						g = 0;
						while (g < len) {
							if (todo.w_friendlist[g].u == todo.Users[UserIndex].u){
								if (((((!((xatlib.StripSpace_(todo.Users[UserIndex].n) == xatlib.StripSpace_(todo.w_friendlist[g].n)))) || (!((todo.Users[UserIndex].a == todo.w_friendlist[g].a))))) || (!((todo.Users[UserIndex].h == todo.w_friendlist[g].h))))){
									UpdateFriendList(todo.Users[UserIndex].u, ((todo.w_friendlist[g].f) ? todo.w_friendlist[g].f : 1));
								};
								break;
							};
							g++;
						};
					};
					IsIgnored = OnIgnoreList(u);
					if (((((((((((todo.w_mainowner) || (todo.w_owner))) || (todo.w_moderator))) || ((IgnoreTime(u) < 0)))) && (!(IsPrivateMessage)))) && (!(IsPrivateChat)))){
						IsIgnored = false;
					};
					if ((((((((((todo.FlagBits & xconst.f_Live)) && (IsPrivateMessage))) && (!(IsPrivateChat)))) && (!(IsSlash)))) && (!(((((((todo.Users[UserIndex].member) || (todo.Users[UserIndex].moderator))) || (todo.Users[UserIndex].owner))) || (todo.Users[UserIndex].mainowner)))))){
						return;
					};
					strText = e.attributes.t;
					strText = xatlib.CleanText(strText, 1).toLowerCase();
					lc = strText.toLowerCase();
					if (((((((((!((strText.indexOf("chat.php?") == -1))) || (!((lc.indexOf("freexat") == -1))))) || (!((lc.indexOf("freesub") == -1))))) || (!((lc.indexOf("listchats") == -1))))) || (!((lc.indexOf("llstchats") == -1))))){
						if (FirstTwo.substr(0, 1) != "/"){
							IsSlash = true;
						};
					};
					Links = xatlib.CountLinks(e.attributes.t);
					if (((((!((UserIndex == -1))) && ((e.nodeName == "m")))) && ((((((((((todo.Users[UserIndex].admin == false)) && (!(todo.Users[UserIndex].member)))) && (!(todo.Users[UserIndex].moderator)))) && (!(todo.Users[UserIndex].owner)))) && (!(todo.Users[UserIndex].mainowner)))))){
						if (Links > 0){
							IsSlash = true;
						};
					};
					if ((((((e.nodeName == "m")) && ((todo.messageecho == "l")))) && ((Links > 0)))){
						if (chat.sending_lc){
							chat.sending_lc.send(chat.fromxat, "onMsg", 4, e.attributes.u, e.attributes.t);
						};
					};
					if (IsLocateUser) {
						selfid = xatlib.FindUser(todo.w_userno);
						uid = xatlib.FindUser(u);
						if ((((todo.Users[uid].admin == false)) && (main.utabsmc.tabs[2]))) {
							if(!(todo.Users[uid].admin))
							{
								if (uid < 0){
									todo.Users.push({
										n:"",
										u:u,
										v:0,
										a:"",
										h:"",
										TickCnt:todo.Tickled++
									});
								} else {
									//todo.Users[uid].TickCnt = todo.Tickled++;
									todo.Users[uid].TickCnt = todo.Users[uid].TickCnt + 1; //Daniel
									if (!todo.Users[uid].ignored){
										main.utabsmc.ColorTab(2, 0x9900);
										main.utabsmc.GlowTab(2);
										main.utabsmc.Notif = true;
										if(todo.Users[uid].TickCnt == 1) //Daniel & Techy
										{
											todo.DoTickleSnd = true; // OFF WITH YOUR HEAD && UH OH
										}
									};
								};
							}
						};
						if(!(todo.Users[selfid].flag0 & 0x0400 && todo.Users[uid].admin == false)) {
							Friend = 1;
							Friend = OnFriendList(u);
							if (Friend == 3){
								Friend = ((todo.foe) ? 0 : 1);
							};
							if (Friend == 5){
								Friend = 1;
							};
							if (OnIgnoreList(u)){
								Friend = 0;
							};
							if ((((Friend == 1)) && (todo.HasPower(selfid, 5)))){
								Friend = 2;
							};
							if (((((!((UserIndex == -1))) && ((todo.Users[UserIndex].online === true)))) && (Friend))){
								Friend = 1;
							};
							if (todo.Users[uid].admin == true){
								Friend = 1;
							};
							switch (Friend){
								case 2:
									str = "_NF";
									break;
								case 1:
									str = xatlib.GroupUrl();
									break;
								default:
									str = ("_" + xconst.ST(126));
							};
							if ((getTimer() - LastLocate) > 1150){
								if ((((todo.w_userno <= 101)) && ((todo.w_name.substr(0, 2) == "$$")))){
								} else {
									NetworkSendMsg(todo.w_userno, ("/a" + str), 0, u, 0);
									LastLocate = getTimer();
								};
							};
						};
					} else if (IsAtUser){
						loctext = "";
						if (e.attributes.t.substr(0, 3) == "/a_"){
							if (e.attributes.t.substr(3, 2) == "NF"){
								loctext = "NoFollow";
							} else {
								loctext = xconst.ST(126);
							};
						} else if (e.attributes.t.substr(2, 4) == "http"){
								loctext = xconst.ST(129, e.attributes.t.substr(2));
						} else {
							loctext = e.attributes.t.substr(2);
						};
						UserIndex = xatlib.FindUser(xatlib.xInt(e.attributes.u));
						if (todo.Users[UserIndex].UnmaskedPowers == undefined){
							todo.Users[UserIndex].UnmaskedPowers = new Array();
						};
						if (todo.Users[UserIndex].Powers == undefined){
							todo.Users[UserIndex].Powers = new Array();
						};
						pp = 0;
						while (pp < todo.MAX_PWR_INDEX) {
							ii = ("p" + pp);
							if (e.attributes[ii] != undefined){
								todo.Users[UserIndex].UnmaskedPowers[pp] = xatlib.xInt(e.attributes[ii]);
								if(todo.Users[UserIndex].Powers[pp] === undefined) {
									todo.Users[UserIndex].Powers[pp] = xatlib.xInt(e.attributes[ii]);
								};
							};
							pp++;
						};
						if (e.attributes.po != undefined){
							todo.Users[UserIndex].PowerO = e.attributes.po;
						};
						todo.Users[UserIndex].n = xatlib.NameNoXat(e.attributes.n);
						todo.Users[UserIndex].s = xatlib.GetStatus(e.attributes.n);
						todo.Users[UserIndex].coins = e.attributes.x;
						todo.Users[UserIndex].days = e.attributes.y;
						todo.Users[UserIndex].debug = e.attributes.g;
						todo.Users[UserIndex].VIP = (todo.Users[UserIndex].days > 0);
						SetSuperPowers(UserIndex);
						i = 0;
						while (i < main.dialog_layer.numChildren) {
							d = main.dialog_layer.getChildAt(i);
							if ((d is DialogActions)){
								d.WriteLocation(loctext, e.attributes.u, e.attributes.N);
							};
							i++;
						};
						if (e.attributes.n != undefined){
							UserIndex = xatlib.FindUser(xatlib.xInt(e.attributes.u));
							if (UserIndex != -1){
								if (e.attributes.n.substr(0, 1) == "$"){
									e.attributes.n = e.attributes.n.substr(1);
								};
								todo.Users[UserIndex].v = e.attributes.v;
								todo.Users[UserIndex].n = xatlib.NameNoXat(e.attributes.n);
								todo.Users[UserIndex].u = xatlib.xInt(e.attributes.u);
								todo.Users[UserIndex].a = e.attributes.a;
								todo.Users[UserIndex].h = e.attributes.h;
								todo.Users[UserIndex].sn = xatlib.xJSONdecode(e.attributes.sn);
								todo.Users[UserIndex].cb = e.attributes.cb;
								todo.Users[UserIndex].Jinx = e.attributes.j;
								todo.Users[UserIndex].registered = e.attributes.N;
								if (todo.Users[UserIndex].n == ""){
									todo.Users[UserIndex].n = xatlib.GetDefaultName(todo.Users[UserIndex].u);
								};
								if (todo.Users[UserIndex].a == ""){
									todo.Users[UserIndex].a = xatlib.GetDefaultAvatar(todo.Users[UserIndex].u);
								};
								if (todo.Users[UserIndex].h == ""){
									todo.Users[UserIndex].h = "";
								};
								xmessage.DeleteOneUserMc(UserIndex);
								xatlib.PurgeMessageFromUser(todo.Users[UserIndex].u);
								todo.DoUpdateMessages = true;
								todo.DoBuildUserList = true;
								if (todo.Users[UserIndex].tUpd != undefined){
									main.ctabsmc.tabs[todo.Users[UserIndex].tUpd].t = (main.ctabsmc.tabs[todo.Users[UserIndex].tUpd].h = todo.Users[UserIndex].n);
									main.ctabsmc.UpdateTabs();
									todo.Users[UserIndex].tUpd = undefined;
								};
								if (OnFriendList(todo.Users[UserIndex].u)){
									len = todo.w_friendlist.length;
									g = 0;
									while (g < len) {
										if (todo.w_friendlist[g].u == todo.Users[UserIndex].u){
											if (((((!((xatlib.StripSpace_(todo.Users[UserIndex].n) == xatlib.StripSpace_(todo.w_friendlist[g].n)))) || (!((todo.Users[UserIndex].a == todo.w_friendlist[g].a))))) || (!((todo.Users[UserIndex].h == todo.w_friendlist[g].h))))){
												UpdateFriendList(todo.Users[UserIndex].u, ((todo.w_friendlist[g].f) ? todo.w_friendlist[g].f : 1));
											};
											break;
										};
										g++;
									};
								};
							};
						}
					} else if (IsKickUser){
						uuid = xatlib.FindUser(e.attributes.u);
						arg = [];
						if (e.attributes.p){
							arg = e.attributes.p.split("#");
						};
						if ((((arg.length == 3)) && (todo.HasPower(uuid, 121)))){
							todo.BumpSound = (todo.CustomSound = arg[1]);
							todo.DoAudieSnd = true;
						};
						NetworkClose();
						SetNetworkState(0, -1);
						todo.lb = "n";
						todo.DoUpdate = true;
					} else if (IsDeleteMessage){
						msgno = xatlib.xInt(e.attributes.t.substr(2));
						if (msgno != 0){
							len = todo.Message.length;
							v = 0;
							while (v < len) {
								if (todo.Message[v].n == msgno){
									todo.Message[v].ignored = true;
								};
								v++;
							};
							todo.DoUpdateMessages = true;
						};
					} else if (((IsGagUser) || (IsUnGagUser))){
						UpdateGagList(todo.w_useroom, xatlib.xInt(e.attributes.t.substr(2)), IsGagUser);
						i = xatlib.FindUser(todo.w_userno);
						if (i > -1){
							todo.Users[i].banned = ((IsGagUser) ? true : false);
							xmessage.DeleteOneUserMc(i);
							xkiss.ClosePuzzle();
						};
						if (((GotDone) && (IsGagUser))){
							UnfairGroupName = ((todo.w_room)==todo.w_useroom) ? ((global.gn)!=undefined) ? xatlib.CleanCommas(global.gn) : xconst.ST(0) : ((todo.BackVars[1])!=undefined) ? xatlib.CleanCommas(todo.BackVars[1]) : xconst.ST(0);
							if ((((i >= 0)) && (todo.Users[i].w))){
								BanTime = GetGagTime(todo.w_useroom);
								if (BanTime){
									BanTime = (BanTime - xatlib.SockTime());
									if (BanTime <= (10 * 3600)){
										NoBanMessage = true;
									};
								};
							};
							if (((!(NoBanMessage)) && (!((UnfairGroupName == xconst.ST(0)))))){
								my_date = new Date();
								t = Number(my_date.getTime());
								UnfairFile = (String(xatlib.xInt((Math.random() * 999999))) + t);
								UnfairMessage = (((((((((((todo.w_useroom + ",") + UnfairGroupName) + ",") + todo.w_userno) + ",") + xatlib.CleanTextNoXat(todo.w_name).substr(0, 128)) + ",") + u) + ",") + xatlib.CleanCommas(xatlib.GetUsername(u))) + ",,");
								UnfairTitle = xconst.ST(125);
								UnfairReport = UnfairTitle;
								len = todo.Message.length;
								hh = 0;
								while (hh < len) {
									if (((!((todo.Message[hh].s & 2))) && ((((todo.Message[hh].n == 0)) ? true : (todo.Message[hh].d == 0))))){
										UnfairMessage = (UnfairMessage + (((((todo.Message[hh].u + ",") + xatlib.CleanCommas(xatlib.GetUsername(todo.Message[hh].u))) + ",") + xatlib.CleanCommas(todo.Message[hh].t)) + ",,"));
									};
									if (todo.Message[hh].u == u){
										if (todo.Message[hh].t.substr(0, 20) == ("<i> " + xconst.ST(119))){
											UnfairTitle = ((xatlib.GetUsername(todo.Message[hh].u) + " ") + xconst.ST(127));
											UnfairReport = todo.Message[hh].t.substr(7);
										};
									};
									hh++;
								};
								xatlib.UnfairPopup(UnfairTitle, UnfairReport);
							};
						};
					} else if (((IsMakeUser) || (IsUnMakeUser))){
						if (((IsMakeUser) && ((todo.FlagBits & xconst.f_Live)))){
							w_redirectport = undefined;
						};
						so47 = xatlib.getLocal(("chat" + String(todo.w_useroom)), "/");
						so47.objectEncoding = ObjectEncoding.AMF0;
						if (IsMakeUser){
							todo.w_userrev = xatlib.xInt(todo.w_userrev);
							so47.data.pass = xatlib.xInt(e.attributes.t.substr(2));
						} else {
							delete so47.data.pass;
						};
						so47.flush();
						i = xatlib.FindUser(todo.w_userno);
						if (i > -1){
							if (todo.Users[i].gagged == true){
								todo.Users[i].gagged = false;
								todo.DoBuildUserList = true;
							};
						};
					} else if (IsScroller){
						todo.scrollText = e.attributes.t.substr(2, 510);
						main.SetScroller(todo.scrollText);
					} else if (((!(IsUnknown)) && (!(IsSlash)))){
						todo.mi++;
						n = todo.Message.push({
							i:(todo.mi * 2),
							n:e.attributes.i,
							t:e.attributes.t,
							u:u,
							ignored:IsIgnored,
							s:e.attributes.s,
							d:((IsPrivateChat) ? u : 0),
							p:IsPrivateMessage,
							pb:e.attributes.pb
						});
						if (DontIgnore){
							todo.Message[(n - 1)]["DontIgnore"] = true;
						};
						if (LastBanMsg === 0){
							LastBanMsg = todo.Message[(n - 1)];
						} else {
							LastBanMsg = undefined;
						};
						if (todo.messageecho == "m"){
							if (network.YC){
								vt = (xatlib.xInt(todo.w_d1) - network.YC);
								if (vt < 0){
									vt = 0;
								};
								vt = xatlib.xInt(((vt / (24 * 3600)) + 0.3));
								if (vt > 0){
									if (chat.sending_lc){
										chat.sending_lc.send(chat.fromxat, "onMsg", 4, (todo.mi * 2), e.attributes.t);
									};
								};
							};
						};
						if (((((!(todo.bMobile)) && (!((main.mscrollmc.Scrolling == true))))) || (((todo.bMobile) && (!((main.mbs.Scrolling == true))))))){
							nopc = 0;
							nom = 0;
							len = todo.Message.length;
							tt = 0;
							while (tt < len) {
								if (todo.Message[tt].s == 2){
									nopc++;
								} else {
									nom++;
								};
								tt++;
							};
							maxpc = 100;
							maxm = 150;
							while ((((nopc > maxpc)) || ((nom > maxm)))) {
								len = todo.Message.length;
								RemoveMessage = undefined;
								tt = 0;
								while (tt < len) {
									if (nopc > maxpc){
										if (todo.Message[tt].s == 2){
											xmessage.DeleteOneMessageMc(tt);
											RemoveMessage = todo.Message.splice(tt, 1);
											nopc--;
											break;
										};
									} else if (nom > maxm){
										if (todo.Message[tt].s != 2){
											xmessage.DeleteOneMessageMc(tt);
											RemoveMessage = todo.Message.splice(tt, 1);
											nom--;
											break;
										};
									};
									tt++;
								};
								if(!UserGotMessage(RemoveMessage[0].u)) {
									len = todo.Users.length;
									tt = 0;
									while(tt < len) {
										if(todo.Users[tt].u == RemoveMessage[0].u) {
											if(todo.Users[tt].online) {
												break;
											}
											if(todo.Users[tt].u != todo.w_userno) {
												if(todo.Users[tt].friend) {
													if(todo.Users[tt].online != undefined) {
														xmessage.DeleteOneUserMc(tt);
													}
													todo.Users[tt].online = undefined;
												} else {
													xmessage.DeleteOneUserMc(tt);
													todo.Users.splice(tt,1);
												}
												todo.DoBuildUserList = true;
												break;
											}
											break;
										}
										tt++;
									}
									continue;
								}
							};
						};
						if (((((!(IsUnknown)) && (IsNew))) && (!(IsIgnored)))){
							if(!(main.ctabsmc.TabIsPrivate() && main.ctabsmc.TabUser() != u)) {
								selfid = xatlib.FindUser(todo.w_userno);
								main.ProcessSounds(e.attributes.t, ((selfid)!=-1) ? !(todo.HasPower(selfid, 8)) : 0, selfid, UserIndex);
							};
						};
						if (((((!(IsUnknown)) && (IsNew))) && (!(IsPrivateChat)))){
							GlowUser(u);
							if (main.ctabsmc.TabIsPrivate()){
								if (todo.w_useroom == todo.w_room){
									main.ctabsmc.ColorTab(0, 0x9900);
									main.ctabsmc.GlowTab(0);
								} else if (todo.w_useroom == todo.group){
									main.ctabsmc.ColorTab(1, 0x9900);
									main.ctabsmc.GlowTab(1);
								};
							};
						};
						if (((((!(IsUnknown)) && (IsPrivateChat))) && (!(IsIgnored)))){
							selfid = xatlib.FindUser(todo.w_userno);
							HaveTab = -1;
							AllowPC = true;
							if (e.attributes.u != undefined){
								if (((((!(todo.Users[UserIndex].mainowner)) && (!(todo.Users[UserIndex].owner)))) && (!(todo.Users[UserIndex].moderator)))){
									if (((todo.HasPowerA(todo.w_Powers, 10, todo.w_Mask)) || ((((todo.FlagBits & xconst.f_Live)) && (!(todo.HasPowerA(todo.w_Powers, 10))))))){
										f = OnFriendList(todo.Users[UserIndex].u);
										if (f == 5){
											f = 1;
										};
										if (f != 1){
											if (todo.Users[UserIndex].u > 101){
												AllowPC = false;
												tt = 0;
												while (tt < main.ctabsmc.tabs.length) {
													if (main.ctabsmc.tabs[tt].User == todo.Users[UserIndex].u){
														AllowPC = true;
														HaveTab = tt;
														break;
													};
													tt++;
												};
											};
										};
									};
								};
								if (AllowPC){
									TabNumber = ((HaveTab)!=-1) ? HaveTab : main.ctabsmc.TabAdd(u, 0xFFFFFF, 1, main.Private_onRelease, main.Private_onDelete);
									main.ctabsmc.UpdateTabs();
									if (main.ctabsmc.TabSelected() != TabNumber){
										main.ctabsmc.GlowTab(TabNumber);
										main.ctabsmc.ColorTab(TabNumber, 0x9900);
									};
									todo.DoBuildUserList = true;
								};
								if (AllowPC){
									if (todo.HasPower(UserIndex, 75)){
										if (e.attributes.t.indexOf("(bump") != -1){
											var Superior:* = function (_arg1, _arg2){
												if (todo.Users[_arg1].mainowner){
													return (false);
												};
												if (todo.Users[_arg1].owner){
													return (((todo.Users[_arg2].mainowner) ? true : false));
												};
												if (todo.Users[_arg1].moderator){
													return (((((todo.Users[_arg2].mainowner) || (todo.Users[_arg2].owner))) ? true : false));
												};
												if (((((todo.Users[_arg2].mainowner) || (todo.Users[_arg2].owner))) || (todo.Users[_arg2].moderator))){
													return (true);
												};
												return (false);
											};
											if(todo.HasPower(xatlib.FindUser(todo.w_userno), xconst.pssh["dnd"]) && todo.Macros["dnd"] == "on"){
												return;
											}
											self = xatlib.FindUser(todo.w_userno);
											if (((((OnFriendList(todo.Users[UserIndex].u)) || ((todo.Users[UserIndex].u < 101)))) || (Superior(self, UserIndex)))){
												main.ctabsmc.ColorTab(TabNumber, 0xFF0000);
												t = getTimer();
												if ((((todo.LastBump == -1)) || (((t - todo.LastBump) > 20000)))){
													todo.CustomSound = (todo.BumpSound = "laserfire3");
													todo.DoAudieSnd = true;
													todo.LastBump = t;
												};
											};
										};
									};
								};
							};
						};
						todo.DoUpdateMessages = true;
						todo.ScrollDown = true;
					};
				} else if (e.nodeName == "g"){
					if (UserIndex >= 0){
						todo.Users[UserIndex].xNum = e.attributes.x;
						xmessage.DeleteOneUserMc(UserIndex);
					};
				} else if ((((e.nodeName == "u")) || ((e.nodeName == "o")))){
					if ((((e.attributes.n == null)) || ((e.attributes.n == undefined)))){
						e.attributes.n = "";
					};
					if ((((e.attributes.a == null)) || ((e.attributes.a == undefined)))){
						e.attributes.a = "";
					};
					if ((((e.attributes.h == null)) || ((e.attributes.h == undefined)))){
						e.attributes.h = "";
					};
					IsMainOwner = false;
					IsOwner = false;
					IsModerator = false;
					IsMember = false;
					IsOnline = false;
					IsBanned = false;
					IsForever = false;
					IsGagged = false;
					IsNew = (e.nodeName == "u");
					OnXat = !(((xatlib.xInt(e.attributes.q) & 1) == 0));
					IsVIP = ((!(((xatlib.xInt(e.attributes.f) & 32) == 0))) || (!(((xatlib.xInt(e.attributes.q) & 2) == 0))));
					Powers = [];
					if (IsVIP){
						t = 0;
						while (t < todo.MAX_PWR_INDEX) {
							Powers.push(xatlib.xInt(e.attributes[("p" + t)]));
							t++;
						};
					};
					if ((e.attributes.f & 7) == 1){
						IsMainOwner = true;
					};
					if ((e.attributes.f & 7) == 2){
						IsModerator = true;
					};
					if ((e.attributes.f & 7) == 3){
						IsMember = true;
					};
					if ((e.attributes.f & 7) == 4){
						IsOwner = true;
					};
					if (e.nodeName == "u"){
						IsOnline = true;
					};
					if ((((e.attributes.s & 1)) || ((e.attributes.f & 8)))){
						IsNew = false;
					};
					if ((e.attributes.f & 16)){
						IsBanned = true;
					};
					if ((e.attributes.f & 64)){
						IsForever = true;
					};
					if ((e.attributes.f & 256)){
						IsGagged = true;
					};
					if (((((((IsNew) && ((todo.w_sound & 1)))) && (!(IsBanned)))) && ((((u < (0x77359400 - 100000))) || ((u >= 0x77359400)))))){
						if(!(main.ctabsmc.TabIsPrivate() && main.ctabsmc.TabUser() != u)) {
							todo.DoUserSnd = true;
						}
					};
					//if (u != todo.w_userno){
					if (u == todo.w_userno){
						UserIndex = xatlib.FindUser(u);
						if (UserIndex >= 0){
							todo.Users[UserIndex].n = xatlib.NameNoXat(e.attributes.n);
							todo.Users[UserIndex].s = xatlib.GetStatus(e.attributes.n);
							todo.Users[UserIndex].a = e.attributes.a;
							todo.Users[UserIndex].h = e.attributes.h;
							xmessage.DeleteOneUserMc(UserIndex);
							todo.DoBuildUserList = true;
						};
					} else {
						UserIndex = xatlib.FindUser(u);
						IsStealth = false;
						if (((!((e.attributes.n == undefined))) && ((e.attributes.n.substr(0, 1) == "$")))){
							IsStealth = ((IsOwner) || (IsMainOwner));
							e.attributes.n = e.attributes.n.substr(1);
						};
						if (UserIndex == -1){
							if (e.attributes.n == ""){
								e.attributes.n = xatlib.GetDefaultName(u);
							};
							if (e.attributes.a == ""){
								e.attributes.a = xatlib.GetDefaultAvatar(u);
							};
							if (e.attributes.h == ""){
								e.attributes.h = "";
							};
							UserIndex = (todo.Users.push({}) - 1);
						} else {
							xmessage.DeleteOneUserMc(UserIndex);
						};
						if(e.attributes.pawn != undefined) {
							todo.Users[UserIndex].custom_pawn = e.attributes.pawn;
							todo.Users[UserIndex].ZatVIP = true;
						} else {
							todo.Users[UserIndex].custom_pawn = undefined;
							todo.Users[UserIndex].ZatVIP = false;
						}

						if(e.attributes.cyclepawn != undefined) {
							todo.Users[UserIndex].cyclepawn = e.attributes.cyclepawn;
						}

						todo.Users[UserIndex].n = xatlib.NameNoXat(e.attributes.n);
						todo.Users[UserIndex].s = xatlib.GetStatus(e.attributes.n);
						todo.Users[UserIndex].v = xatlib.xInt(e.attributes.v);
						todo.Users[UserIndex].u = u;
						todo.Users[UserIndex].a = e.attributes.a;
						todo.Users[UserIndex].h = e.attributes.h;
						todo.Users[UserIndex].cb = e.attributes.cb;
						todo.Users[UserIndex].Jinx = e.attributes.j;
						todo.Users[UserIndex].online = IsOnline;
						todo.Users[UserIndex].mainowner = IsMainOwner;
						todo.Users[UserIndex].owner = IsOwner;
						todo.Users[UserIndex].moderator = IsModerator;
						todo.Users[UserIndex].member = IsMember;
						todo.Users[UserIndex].onsuper = undefined;
						todo.Users[UserIndex].available = undefined;
						todo.Users[UserIndex].OnXat = OnXat;
						todo.Users[UserIndex].Stealth = IsStealth;
						todo.Users[UserIndex].friend = OnFriendList(u);
						todo.Users[UserIndex].registered = e.attributes.N;
						todo.Users[UserIndex].sn = xatlib.xJSONdecode(e.attributes.sn);
						todo.Users[UserIndex].VIP = IsVIP;
						todo.Users[UserIndex].Powers = Powers;
						todo.Users[UserIndex].Bride = xatlib.xInt(e.attributes.d2);
						todo.Users[UserIndex].aFlags = xatlib.xInt(e.attributes.d0);
						todo.Users[UserIndex].flag0 = xatlib.xInt(e.attributes.f);
						todo.Users[UserIndex].w = xatlib.xInt(e.attributes.w);
						todo.Users[UserIndex].TickCnt = (todo.Users[UserIndex].TickCnt == undefined) ? 0 : todo.Users[UserIndex].TickCnt;
						todo.Users[UserIndex].admin = (todo.ixatStaff.indexOf(u) != -1) ? true : false;
						todo.Users[UserIndex].volunteer = (todo.ixatVolunteer.indexOf(u) != -1) ? true : false;

						AddGiftPower(UserIndex);
						SetSuperPowers(UserIndex);
						todo.Users[UserIndex].xNum = e.attributes.x;
						if (todo.Users[UserIndex].u == 4294967295){
							todo.Users[UserIndex].n = (todo.Users[UserIndex].n + " Spectators");
						};
						if (((IsNew) && (main.ctabsmc.TabIsPrivate()))){
							if (todo.w_useroom == todo.w_room){
								main.ctabsmc.ColorTab(0, 0x9900);
							} else if (todo.w_useroom == todo.group){
								main.ctabsmc.ColorTab(1, 0x9900);
							};
						};
						todo.DoBuildUserList = true;
						if (UserIndex > -1){
							todo.Users[UserIndex].banned = IsBanned;
							todo.Users[UserIndex].forever = IsForever;
							todo.Users[UserIndex].gagged = IsGagged;
							len = todo.Message.length;
							cc = 0;
							while (cc < len) {
								if (xatlib.xInt(todo.Message[cc].u) == xatlib.xInt(todo.Users[UserIndex].u)){
									if (((IsBanned) && (!(todo.Message[cc].DontIgnore)))){
										todo.Message[cc].ignored = true;
									};
								};
								cc++;
							};
							todo.DoBuildUserList = true;
							todo.DoUpdateMessages = true;
						};
						if (todo.Users[UserIndex].friend){
							len = todo.w_friendlist.length;
							g = 0;
							while (g < len) {
								if (todo.w_friendlist[g].u == u){
									if (((((!((xatlib.StripSpace_(todo.Users[UserIndex].n) == xatlib.StripSpace_(todo.w_friendlist[g].n)))) || (!((todo.Users[UserIndex].a == todo.w_friendlist[g].a))))) || (!((todo.Users[UserIndex].h == todo.w_friendlist[g].h))))){
										UpdateFriendList(u, ((todo.w_friendlist[g].f) ? todo.w_friendlist[g].f : 1));
										break;
									};
									break;
								};
								g++;
							};
						};
						if (todo.messageecho == "a"){
							if ((((todo.Users[UserIndex].banned == true)) || (OnIgnoreList(u)))){
								if (chat.sending_lc){
									chat.sending_lc.send(chat.fromxat, "onMsg", 4, u, "l");
								};
							} else if (chat.sending_lc){
								chat.sending_lc.send(chat.fromxat, "onMsg", 4, u, ("u" + e.attributes.a));
							};
						};
					};
				} else if (e.nodeName == "l"){
					UserIndex = xatlib.FindUser(u);
					xmessage.DeleteOneUserMc(UserIndex);
					if (((!((UserIndex == -1))) && (!((u == todo.w_userno))))){
						if (((!((todo.Users[UserIndex].online == false))) || (!((todo.Users[UserIndex].onsuper == false))))){
							xmessage.DeleteOneUserMc(UserIndex);
						};
						todo.Users[UserIndex].onsuper = (todo.Users[UserIndex].available = (todo.Users[UserIndex].online = false));
						todo.Users[UserIndex].xNum = undefined;
					};
					if (((!((UserIndex == -1))) && (!(UserGotMessage(todo.Users[UserIndex].u))))){
						len = todo.Users.length;
						tt = 0;
						while (tt < len) {
							if ((((todo.Users[tt].u == todo.Users[UserIndex].u)) && (!((todo.Users[tt].u == todo.w_userno))))){
								todo.Users.splice(tt, 1);
								todo.DoBuildUserList = true;
								break;
							};
							tt++;
						};
					};
					todo.DoBuildUserList = true;
					if (todo.messageecho == "a"){
						if (chat.sending_lc){
							chat.sending_lc.send(chat.fromxat, "onMsg", 4, u, "l");
						};
					};
				} else if (e.nodeName == "i"){
					todo.gconfig = new Object();
					todo.w_room_cb = xatlib.xInt(e.attributes.cb);
					xconst.MakeBads();
					if (todo.w_useroom == todo.w_room){
						xatlib.SplitBackground(e.attributes.b);
						a = todo.BackVars;
					} else {
						a = e.attributes.b.split(";=");
					};
																// chatback
					todo.usebackground = todo.cdndomain + "/image.php?url=" + a[0];
					todo.useRadio = a[4];
					if (((!((todo.useRadio == undefined))) && ((((global.xc & 0x1000)) || ((todo.useRadio.length < 10)))))){
						todo.useRadio = undefined;
					};
					if (todo.config["noradio"]){
						todo.useRadio = undefined;
					};
					todo.ButCol = a[5];
					if(todo.HasPower(xatlib.FindUser(todo.w_userno), 346) && todo.Macros["chatback"] != undefined) {
						if(todo.Macros["chatback"].substr(0, 4) == "http") {
							chatback = todo.Macros["chatback"].split("#");
							todo.usebackground = chatback[0];
							if(chatback.length == 2) {
								todo.ButCol = "#" + chatback[1];
							}
						}
					}

					if ((((todo.ButCol == undefined)) || ((todo.ButCol.length == 0)))){
						todo.ButCol = 0xC8C8C8;
					} else if (todo.ButCol.charAt(0) == "#"){
						todo.ButCol = parseInt(todo.ButCol.substr(1), 16);
					};
					todo.ButCol = (xatlib.xInt(todo.ButCol) & 0xFFFFFF);
					todo.ButColW2 = (((todo.ButCol & 0xFF) + ((todo.ButCol >> 8) & 0xFF)) + ((todo.ButCol >> 16) & 0xFF));
					if (todo.ButColW2 > 384){
						todo.ButColW = 0;
					} else {
						todo.ButColW = 0xFFFFFF;
					};
					main.mcgetachat.RefreshColor();
					main.ButtonLoginMc.RefreshColor();
					main.retmc.RefreshColor();
					if (todo.bThin){
						main.retmcBut.Col = todo.ButColW;
					} else {
						xatlib.McSetRGB(main.retmcBut.xitem.back, todo.ButColW);
					};
					if (!todo.bMobile){
						main.mscrollmc.RefreshColor();
						main.uscrollmc.RefreshColor();
					};
					todo.FlagBits = xatlib.xInt(e.attributes.f);
					if ((todo.FlagBits & xconst.f_Deleted)){
						chat.mainDlg.visible = false;
						xatlib.getURL(todo.usedomain, "_self");
						if (todo.lb != "n"){
							main.logoutbutonPress();
						};
						return;
					};
					main.logo.visible = true;
					chat.mainDlg.MkGpBut();
					if (todo.MainFlagBits == undefined){
						todo.MainFlagBits = todo.FlagBits;
					};
					if (todo.w_sound == undefined){
						if ((todo.FlagBits & xconst.f_DefNoSound)){
							todo.w_sound = 4;
						} else {
							todo.w_sound = 253;
						};
					};
					if ((todo.w_sound & 4) == 0){
						todo.w_sound = (todo.w_sound | 254);
					};
					if ((global.xc & 0x2000)){
						todo.w_sound = (todo.w_sound & ~(2));
					};
					if (global.xt == undefined){
						main.ctabsmc.tabs[1].t = todo.BackVars[1];
						main.ctabsmc.tabs[1].h = (main.ctabsmc.tabs[1].t + " ");
					};
					if (global.xl == undefined){
						todo.group = todo.BackVars[2];
					};
					if ((xconst.f_Lobby & todo.MainFlagBits)){
						main.ctabsmc.tabs[0].Skip = undefined;
						main.ctabsmc.tabs[1].Skip = undefined;
					} else {
						main.ctabsmc.tabs[0].Skip = true;
						main.ctabsmc.tabs[1].Skip = true;
					};
					main.ctabsmc.UpdateTabs();
					if ((e.attributes.v & 1)){
					} else {
						todo.w_registered = undefined;
					};
					todo.w_VIP = ((e.attributes.v & 3) == 3);
					todo.w_ALLP = (e.attributes.v & 4);
					todo.w_mainowner = false;
					todo.w_owner = false;
					todo.w_moderator = false;
					todo.w_member = false;
					if (xatlib.xInt(e.attributes.r) == 1){
						todo.w_mainowner = true;
						todo.w_owner = true;
					} else if (xatlib.xInt(e.attributes.r) == 2){
						todo.w_moderator = true;
					} else if (xatlib.xInt(e.attributes.r) == 3){
						todo.w_member = true;
					} else if (xatlib.xInt(e.attributes.r) == 4){
						todo.w_owner = true;
					} else {
						todo.pass = undefined;
					};
					if (todo.w_mainowner){
						if (OnGagList(todo.w_useroom)){
							UpdateGagList(todo.w_useroom, 0, false);
						};
						i = xatlib.FindUser(todo.w_userno);
						if (i > -1){
							todo.Users[i].banned = false;
							xmessage.DeleteOneUserMc(i);
						};
					};
					len = todo.Users.length;
					ee = 0;
					while (ee < len) {
						if (todo.Users[ee].u == todo.w_userno) {
							if(e.attributes.pawn != undefined) {
								todo.Users[ee].custom_pawn = e.attributes.pawn;
								todo.Users[ee].ZatVIP = true;
							} else {
								todo.Users[ee].custom_pawn = undefined;
								todo.Users[ee].ZatVIP = false;
							}

							if(e.attributes.cyclepawn != undefined) {
								todo.Users[ee].cyclepawn = e.attributes.cyclepawn;
							}

							todo.Users[ee].mainowner = (todo.Users[ee].owner = (todo.Users[ee].moderator = (todo.Users[ee].member = false)));
							IsBanned = OnGagList(todo.w_useroom);
							todo.Users[ee].banned = IsBanned;
							if (todo.w_mainowner){
								todo.Users[ee].mainowner = true;
							};
							if (todo.w_owner){
								todo.Users[ee].owner = true;
							};
							if (((((todo.w_owner) || (todo.w_mainowner))) && ((todo.w_name.substr(0, 1) == "$")))){
								todo.Users[ee].Stealth = true;
							};
							if (todo.w_moderator){
								todo.Users[ee].moderator = true;
							};
							if (todo.w_member){
								todo.Users[ee].member = true;
							};
							todo.Users[ee].VIP = todo.w_VIP;
							if (!todo.w_VIP){
								todo.w_Powers = undefined;
							};
							todo.Users[ee].Powers = ((todo.w_Powers)!=undefined) ? todo.w_Powers.slice() : todo.NO_POWERS.slice();
							if (todo.w_ALLP){
								todo.Users[ee].Powers[0] = (todo.Users[ee].Powers[0] | 1);
							};
							AddGiftPower(ee);
							SetSuperPowers(ee);
							if(todo.ixatStaff.indexOf(todo.Users[ee].u) != -1) {
								todo.Users[ee].admin = true;
							}
							if(todo.ixatVolunteer.indexOf(todo.Users[ee].u) != -1) {
								todo.Users[ee].volunteer = true;
							}
							t = 0;
							while (t < todo.MAX_PWR_INDEX) {
								todo.Users[ee].Powers[t] = (todo.Users[ee].Powers[t] & ~(xatlib.xInt(((todo.w_Mask)!=undefined) ? todo.w_Mask[t] : 0)));
								t++;
							};
							todo.Users[ee].Bride = todo.w_d2;
							todo.Users[ee].aFlags = todo.w_d0;
							todo.Users[ee].flag0 = xatlib.xInt(e.attributes.f2);
							todo.w_r = xatlib.xInt(e.attributes.r);
							todo.Users[ee].w = xatlib.xInt(e.attributes.w);
							todo.Users[ee].sn = xatlib.xJSONdecode(todo.w_sn);
							todo.foe = todo.HasPower(ee, xconst.pssh["foe"]);
							todo.goodfriend = todo.HasPower(ee, xconst.pssh["goodfriend"]);
							todo.Users[ee].Jinx = e.attributes.j;
							xmessage.DeleteOneUserMc(ee);
							todo.DoBuildUserList = true;
							break;
						};
						ee++;
					};
					StringIndex = ((todo.config["uselogindialog"]) ? 0 : ((((todo.w_mainowner) && (!(global.xb)))) ? 34 : 5));
					main.mcgetachat.SetText(((StringIndex) ? xconst.ST(StringIndex) : "Login"));
					main.mcgetachat.lc = StringIndex;
					if (((((xconst.f_MembersOnly | xconst.f_MembersOnly2) & todo.FlagBits)) && (!(((((todo.w_owner) || (todo.w_moderator))) || (todo.w_member)))))){
						type = undefined;
						switch (((xconst.f_MembersOnly | xconst.f_MembersOnly2) & todo.FlagBits)){
							case (xconst.f_MembersOnly | xconst.f_MembersOnly2):
								if (!todo.w_VIP){
									type = xconst.ST(176);
								};
								break;
							case xconst.f_MembersOnly2:
								if (todo.w_registered == undefined){
									type = xconst.ST(177);
								};
								break;
							default:
								type = xconst.ST(178);
						};
						if (type != undefined){
							todo.helpstr = xconst.ST(37, type);
							todo.HelpUpdate = 0;
						};
					};
					if (todo.messageecho == "a"){
						if (chat.sending_lc){
							chat.sending_lc.send(chat.fromxat, "onMsg", 4, 0, "d");
						};
					};
					main.SetScroller((((todo.FlagBits & xconst.f_Live)) ? xconst.ST(217) : ((todo.scrollText) ? todo.scrollText : main.mcscrollertext.text)));
					UserIndex = xatlib.FindUser(todo.w_userno);
					if ((((((UserIndex >= 0)) && (todo.Users[UserIndex].banned))) && (todo.Users[UserIndex].w))){
						xkiss.LoadPuzzle(todo.Users[UserIndex].w);
					} else {
						xkiss.ClosePuzzle();
					};
				} else if (e.nodeName == "w"){
					while (todo.Pools.length) {
						todo.Pools.shift();
					};
					Text = e.attributes.v;
					left = 0;
					RndOr = (todo.w_userno ^ 0xAAAAAAAA);
					Rnd2 = RndOr;
					len = Text.length;
					q = 0;
					while (q < len) {
						if ((((Text.substr(q, 1) == " ")) || ((q == (Text.length - 1))))){
							todo.pool = xatlib.xInt(Text.substr(left, ((q)==(Text.length - 1)) ? ((q - left) + 1) : (q - left)));
							if (left == 0){
								todo.newpool = todo.pool;
							} else if ((Rnd2 & 1)){
									todo.Pools.push(todo.pool);
							} else {
								todo.Pools.unshift(todo.pool);
							};
							Rnd2 = (Rnd2 >>> 1);
							if (Rnd2 == 0){
								Rnd2 = RndOr;
							};
							left = (q + 1);
						};
						q++;
					};
					if (todo.newpool != todo.w_pool){
						main.ctabsmc.UpdateTabs();
						todo.w_pool = todo.newpool;
						xmessage.ClearLists(false);
						todo.DoBuildUserListScrollUp = true;
						todo.DoUpdateMessages = true;
					} else {
						todo.DoBuildUserListScrollUp = true;
					};
					if (todo.messageecho == "a"){
						if (chat.sending_lc){
							chat.sending_lc.send(chat.fromxat, "onMsg", 4, 0, "d");
						};
					};
				} else if (e.nodeName == "f"){
					str = e.attributes.v;
					if (!str){
						return;
					};
					sarray = str.split(",");
					len = sarray.length;
					p = 0;
					while (p < len) {
						UserIndex = xatlib.FindUser(sarray[p]);
						if (UserIndex != -1){
							todo.Users[UserIndex].onsuper = true;
							todo.Users[UserIndex].available = (sarray[p].charAt(0) === "0");
							xmessage.DeleteOneUserMc(UserIndex);
						};
						p++;
					};
					todo.DoBuildUserListScrollUp = true;
				} else if (e.nodeName == "k"){
					todo.OnSuper = false;
				} else if (e.nodeName == "dup"){
					todo.helpstr = xconst.ST(36);
					todo.HelpUpdate = 0;
					SetNetworkState(0, -1);
					todo.lb = "n";
					todo.DoUpdate = true;
					NetworkClose();
				} else if (e.nodeName == "q"){
					if (e.attributes.k != undefined){
						SetNetworkState(0, -1);
						todo.lb = "n";
						todo.DoUpdate = true;
						NetworkClose();
						if (QK != true){
							QK = true;
							todo.w_userno = 0;
							todo.w_userrev = 0;
							todo.w_k1 = 0;
							todo.w_k2 = 0;
							NetworkStartChat();
						};
					} else {
						doautoredirect = (w_redirectport == undefined);
						SetNetworkState(0, -1);
						if (e.attributes.r != undefined){
							todo.w_room = (todo.w_useroom = xatlib.xInt(e.attributes.r));
							main.ctabsmc.UpdateTabs(0);
						} else {
							w_redirectport = xatlib.xInt(e.attributes.p);
							w_redirectdom = e.attributes.d;
							if (w_redirectdom.substr(0, 1) == "e"){
								w_redirectdom = (w_redirectdom + ".xatech.com");
							};
						};
						if (((!((e.attributes.p2 == undefined))) && (!((e.attributes.d2 == undefined))))){
							uid = xatlib.FindUser(e.attributes.d2);
							if (((!((e.attributes.p2.indexOf("#") == -1))) && (!((uid == -1))))){
								reason = e.attributes.p2.substr(0, e.attributes.p2.indexOf("#"));
								bootr = e.attributes.p2.substr((e.attributes.p2.indexOf("#") + 1));
								Bootp = (((((todo.Users[uid].n + " (") + todo.Users[uid].u) + ") booted you to ") + bootr) + ((reason)!="") ? (". Reason:" + reason) : ".");
							};
						};
						todo.lb = "n";
						todo.DoUpdate = true;
						NetworkClose();
						if (doautoredirect){
							NetworkStartChat();
						};
					};
				} else if (e.nodeName == "logout"){
					if ((((e.attributes.e == "F016")) || ((e.attributes.e == "F021")))){
						if (attempt < xNumAttempts){
							attempt++;
							SetNetworkState(0, -1);
							todo.lb = "n";
							todo.DoUpdate = true;
							NetworkClose();
							NetworkStartChat();
							return;
						};
					};
					todo.helpstr = xconst.ST(35);
					todo.HelpUpdate = 0;
					errnum = xatlib.xInt(e.attributes.e.substr(1));
					switch (errnum){
						case 36:
						case 37:
						case 38:
							todo.helpstr = xconst.ST(260);
					};
					SetNetworkState(0, -1);
					todo.lb = "n";
					todo.DoUpdate = true;
					NetworkClose();
					uid = xatlib.FindUser(todo.w_userno);
					todo.Users[uid].online = false;
					xmessage.DeleteOneUserMc(uid);
					RemoveMessagesWithNoUser();
				} else if (e.nodeName == "idle"){
					todo.helpstr = xconst.ST(33);
					todo.HelpUpdate = 0;
					SetNetworkState(0, -1);
					todo.lb = "n";
					todo.DoUpdate = true;
					NetworkClose();
					RemoveMessagesWithNoUser();
				} else if (e.nodeName == "abort"){
					todo.lb = "n";
					todo.DoUpdate = true;
					NetworkClose();
					SetNetworkState(5, (12 * 6));
				} else if (e.nodeName == "BB"){
					if (YI != xatlib.xInt(e.attributes.y)){
						return;
					};
					tickcode.BB = e.attributes.t.split(",");
				} else if (e.nodeName == "done"){
					chat.mainDlg.UpdateBackground(todo.usebackground);
					chat.mainDlg.UpdateEmotes();
					xmessage.OpenGifts(todo.w_userno, 0);
					if (global.um != undefined){
						xatlib.GeneralMessage("", ((xconst.ST(135) + ":\n\n") + global.um));
						main.box_layer.GeneralMessageH.Dia.Ok.But.PressFunc = function (_arg1){
							NetworkMakeUser(global.um, "r");
							SetNetworkState(0, -1);
							todo.lb = "n";
							todo.DoUpdate = true;
							NetworkClose();
							main.box_layer.GeneralMessageH.Delete();
							global.um = undefined;
						};
					};
					RemoveMessagesWithNoUser();
					RemoveUsersWithNoMessages();
					if (((xatlib.IsDefaultName(todo.w_name)) && ((todo.helpstr == "")))){
						todo.helpstr = xconst.ST(12, (" <o> <l>" + todo.w_name));
						todo.HelpUpdate = 0;
					};
					todo.FV = xatlib.xInt(Capabilities.version.split(" ")[1]);
					if (todo.FV < 10){
						todo.helpstr = "Please update your Flash player for best performance, click here: http://www.adobe.com/go/getflashplayer";
						todo.helpupdate = 0;
					};
					if (Bootp != undefined){
						todo.helpstr = Bootp;
						todo.HelpUpdate = 0;
						Bootp = undefined;
					};
					xmessage.UpdateMessages(true, false);
					todo.DoBuildUserList = true;
					GotDone = true;
					FI = true;
					if (todo.connectchannel != undefined){
						if (chat.sending_lc){
							chat.sending_lc.send(chat.fromxat, "onMsg", chat.connectchannel, chat.connectuser, chat.connectmsg);
						};
						todo.connectchannel = undefined;
					};
					if (todo.RefreshLogin){
						NetworkLogin(todo.w_userno, 0);
						todo.WV2 = true;
						todo.RefreshLogin = false;
					};
					if (todo.gconfig["g112"]){
						todo.Message.push({
							n:0,
							t:("<inf8> " + todo.gconfig["g112"]),
							u:0,
							s:0,
							d:0
						});
						todo.DoUpdateMessages = true;
						todo.ScrollDown = true;
						delete todo.gconfig["g112"];
					};
					uid = xatlib.FindUser(todo.w_userno);
					todo.Away = ((todo.HasPower(uid, 144)) ? 1 : 0);
					todo.Typing = ((todo.HasPower(uid, 172)) ? 1 : 0);
					if (LastBanMsg){
						todo.Message.push(LastBanMsg);
					};
					LastBanMsg = undefined;
				} else if(e.nodeName == "n") {
					xatlib.GeneralMessage("Notice", e.attributes.t);
				} else if (e.nodeName == "mt") {
					if (e.attributes.t.substr(-2, 2) == "-f") {
						e.attributes.t = e.attributes.t.substr(0, e.attributes.t.length - 2);
						main.textfield2.appendText(e.attributes.t);
						main.textfield2.setSelection(main.textfield2.text.length, main.textfield2.text.length);
						var i4:* = 0;
						while (i4 < main.textfield2.length) {
							if (main.textfield2.text.charAt(i4) == ">"){
								main.textfield2.text = ((main.textfield2.text..substr(0, i4) + "˃") + main.textfield2.text.substr((i4 + 1)));
							};
							i4++;
						};

						todo.ResetSmilies = true;
						todo.MessageToProcess = main.textfield2.text;
						main.textfield2.text = "";
					} else {
						var forceEnter = false;
						if (e.attributes.t.substr(-2, 2) == "-e") {
							forceEnter = true;
							e.attributes.t = e.attributes.t.substr(0, e.attributes.t.length - 2);
						}
						var textarray:Array = e.attributes.t.split("");
						if (textarray.length > 0) {
							var timer:Timer = new Timer(50);
							var i2:int = 0;
							timer.start();
							timer.addEventListener(TimerEvent.TIMER, update);
							function update(TimerEvent) {
								main.textfield2.appendText(textarray[i2]);
								
								if ((((todo.Typing > 0)) && ((todo.Away <= 1)))){
									if (todo.Typing == 1){
										todo.TypingID = ((ctabsmc.TabIsPrivate()) ? ctabsmc.TabUser() : 0);
										if (!todo.TypingID){
											todo.TypingID = todo.PrivateMessage;
										};
										network.NetworkSendMsg(todo.w_userno, "/RTypeOn", 0, todo.TypingID);
										main.SetTyping(todo.w_userno, true);
									};
									todo.Typing = 10;
								};
								if (todo.Away){
									chat.NotAway();
								};
								
								i2++;
								if(i2 == textarray.length) {
									main.textfield2.setSelection(main.textfield2.text.length, main.textfield2.text.length);
									if (forceEnter) {
										var i3:* = 0;
										while (i3 < main.textfield2.length) {
											if (main.textfield2.text.charAt(i3) == ">"){
												main.textfield2.text = ((main.textfield2.text..substr(0, i3) + "˃") + main.textfield2.text.substr((i3 + 1)));
											};
											i3++;
										};

										todo.ResetSmilies = true;
										todo.MessageToProcess = main.textfield2.text;
										if (todo.Typing > 1){
											todo.Typing = 2;
										};
										main.textfield2.text = "";
									}
									timer.stop();
								}
							};
						};
					};
				} else if (e.nodeName == "rl") {
					var timer2:Timer = new Timer(5000, 1);
					xatlib.GeneralMessage("Update", "You will be automatically refreshed in 5 seconds due to a client update.");
					timer2.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
					timer2.start();
					function onComplete(e:TimerEvent):void {
						ExternalInterface.call("document.location.reload", true);
					}
				}
			}
		}
		
		public static function NetworkSendMsg(_arg1, _arg2, _arg3=undefined, _arg4=undefined, _arg5=undefined, _arg6=undefined, _arg7=undefined){
			var _local9:*;
			if (todo.lb == "n"){
				return;
			};
			if (_arg3 == undefined){
				_arg3 = 0;
			};
			if (_arg4 == undefined){
				_arg4 = 0;
			};
			if (_arg5 == undefined){
				_arg5 = 0;
			};
			var _local8:* = new XMLDocument();
			var _local10:* = true;
			var _local11 = "";
			if (_arg5 != 0){
				_local9 = _local8.createElement("c");
				if (_arg3 != 0){
					_local9.attributes.d = todo.w_userno;
					_local9.attributes.s = 2;
				};
				_local9.attributes.t = _arg2;
				_local9.attributes.u = _arg5;
				if (_arg6 != undefined){
					_local9.attributes.p = _arg6;
				};
				if (_arg7 != undefined){
					_local9.attributes.w = _arg7;
				};
				_local8.appendChild(_local9);
				_local11 = xatlib.XMLOrder(_local8, new Array("w", "p", "u", "t", "s", "d"));
				socket.send(_local11);
			} else if (_arg4 != 0){
				if (((((((OnUserList(_arg4)) && (!((_arg2.substr(0, 2) == "/a"))))) && (!((_arg2.substr(0, 2) == "/l"))))) && (!((_arg2.substr(0, 2) == "/t"))))){
					_local9 = _local8.createElement("p");
					if (_arg3 != 0){
						_local9.attributes.d = todo.w_userno;
						_local9.attributes.s = 2;
					};
					_local9.attributes.t = _arg2;
					_local9.attributes.u = _arg4;
					_local8.appendChild(_local9);
					_local11 = xatlib.XMLOrder(_local8, new Array("u", "t", "s", "d"));
					socket.send(_local11);
				} else {
					_local9 = _local8.createElement("z");
					if (_arg3 != 0){
						_local9.attributes.s = 2;
					};
					_local9.attributes.t = _arg2;
					_local9.attributes.u = ((todo.w_userno + "_") + todo.w_userrev);
					_local9.attributes.d = _arg4;
					_local10 = false;
					_local8.appendChild(_local9);
					_local11 = xatlib.XMLOrder(_local8, new Array("d", "u", "t", "s"));
					socket.send(_local11);
				};
			} else if (_arg3 != 0){
				if (OnUserList(_arg3)){
					_local9 = _local8.createElement("p");
					_local9.attributes.d = todo.w_userno;
					_local9.attributes.s = 2;
					_local9.attributes.t = _arg2;
					_local9.attributes.u = _arg3;
					_local8.appendChild(_local9);
					_local11 = xatlib.XMLOrder(_local8, new Array("u", "t", "s", "d"));
					socket.send(_local11);
				} else {
					_local9 = _local8.createElement("z");
					_local9.attributes.s = 2;
					_local9.attributes.t = _arg2;
					_local9.attributes.u = ((todo.w_userno + "_") + todo.w_userrev);
					_local9.attributes.d = _arg3;
					_local10 = false;
					_local8.appendChild(_local9);
					_local11 = xatlib.XMLOrder(_local8, new Array("d", "u", "t", "s"));
					socket.send(_local11);
				};
			} else {
				_local9 = _local8.createElement("m");
				_local9.attributes.u = ((todo.w_userrev)<=0) ? _arg1 : ((_arg1 + "_") + todo.w_userrev);
				_local9.attributes.t = _arg2;
				if (xatlib.CountLinks(_arg2) > 0){
					_local9.attributes.l = 1;
				};
				_local8.appendChild(_local9);
				_local11 = xatlib.XMLOrder(_local8, new Array("t", "u", "l"));
				socket.send(_local11);
			};
			if (_arg2.substr(0, 1) != "/"){
				GlowUser(todo.w_userno);
			};
			if (_arg2.substr(0, 3) == "/KD"){
				_local10 = false;
			};
			if (_local10){
				LurkerTimeout = LurkerLimit;
			};
		}
		public static function UpdateChannel(_arg1, _arg2){
			var _local3:Number = xatlib.FindUser(_arg2);
			if (_local3 < 0){
				return;
			};
			if (((((todo.Users[_local3].banned) && (todo.Users[_local3].w))) && (!((todo.Users[_local3].flag0 & 131072))))){
				_arg1 = (50000 + todo.Users[_local3].w);
			};
			if (_arg1 < 10000){
				_arg1 = 0;
			};
			if (todo.Users[_local3].xNum != _arg1){
				todo.Users[_local3].xNum = _arg1;
				xmessage.DeleteOneUserMc(_local3);
			};
		}
		public static function NetworkSendExtMessage(_arg1, _arg2=undefined, _arg3=undefined){
			var _local5:*;
			LurkerTimeout = LurkerLimit;
			var _local4:* = new XMLDocument();
			_local5 = _local4.createElement("x");
			_local5.attributes.t = (((_arg3 == undefined)) ? "undefined" : _arg3);
			if (_arg2 != 0){
				_local5.attributes.d = (((_arg2 == undefined)) ? "undefined" : _arg2);
			};
			_local5.attributes.u = todo.w_userno;
			_local5.attributes.i = _arg1;
			UpdateChannel(_arg1, todo.w_userno);
			_local4.appendChild(_local5);
			var _local6:String = xatlib.XMLOrder(_local4, new Array("i", "u", "d", "t"));
			socket.send(_local6);
		}
		public static function NetworkSendxmlExtMessage(_arg1){
			LurkerTimeout = LurkerLimit;
			var _local2:* = new XMLDocument(_arg1);
			UpdateChannel(_local2.firstChild.attributes.i, todo.w_userno);
			var _local3:* = "";
			if (((!((_local2.toString().indexOf("t=\"/m") == -1))) || (!((_local2.toString().indexOf("t=\"/g") == -1))))){
				_local3 = xatlib.XMLOrder(_local2, new Array("j", "i", "u", "t", "p"));
			} else {
				_local3 = xatlib.XMLOrder(_local2, new Array("H", "j", "i", "t", "u", "d0", "d2", "q", "N", "n", "a", "h", "v"));
			};
			socket.send(_local3);
		}
		public static function NetworkLogin(_arg1, _arg2){
			var _local3:* = new XMLDocument();
			var _local4:*;
			_local4 = _local3.createElement("v");
			_local4.attributes.n = _arg1;
			_local4.attributes.p = _arg2;
			_local3.appendChild(_local4);
			socket.send(_local3);
		}
		public static function NetworkDeleteMessage(_arg1){
			NetworkSendMsg(todo.w_userno, ("/d" + _arg1));
		}
		public static function NetworkGagUser(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*, _arg_5:*=undefined, _arg_6:*=undefined){
			if (todo.Macros != undefined && _arg_5 != undefined){
				for (var macro in todo.Macros) {
					_arg_5 = xatlib.Replace(_arg_5, ("$" + macro), todo.Macros[macro]);
				};
			};
			NetworkSendMsg(todo.w_userno, ((_arg_3) ? (("/" + _arg_1) + _arg_4) : "/u"), 0, 0, _arg_2, _arg_5, _arg_6);
		}
		public static function NetworkKickUser(_arg_1:*, _arg_2:*){
			if (todo.Macros != undefined){
				for (var macro in todo.Macros) {
					_arg_2 = xatlib.Replace(_arg_2, ("$" + macro), todo.Macros[macro]);
				};
			};
			NetworkSendMsg(todo.w_userno, "/k", 0, 0, _arg_1, _arg_2);
		}
		public static function NetworkMakeUser(_arg1, _arg2){
			NetworkSendMsg(todo.w_userno, ("/" + _arg2), 0, 0, _arg1);
		}
		public static function SysMsg(param1:*, param2:*, param3:* = undefined, param4:* = undefined, param5:* = undefined, param6:int = 0) : String {
			var _local7:String = null;
			var _local8:* = undefined;
			var _local9:* = undefined;
			var _local10:* = undefined;
			var _local11:* = undefined;
			var _local12:* = undefined;
			_local7 = "";
			_local9 = todo.Users[param3].n.substr(0,128);
			if(param4 == undefined) {
				param4 = "";
			}
			_local10 = param4.split("#");
			_local11 = xatlib.xInt(param5 / 3.6 + 0.5) / 1000;
			if(xatlib.CountLinks(_local9) > 0) {
				_local9 = todo.Users[param3].registered;
				if(!_local9) {
					_local9 = todo.Users[param3].u;
				}
			}
			if(param1 == 0) {
				if(param2 == "M") {
					_local7 = _local7 + xconst.ST(137,_local9);
				} else if(param2.charAt(0) == "m") {
					_local7 = _local7 + xconst.ST(128,_local9);
				} else if(param2.charAt(0) == "e") {
					_local7 = _local7 + xconst.ST(132,_local9);
				} else if(param2.charAt(0) == "o") {
					_local7 = _local7 + xconst.ST(137,_local9);
				} else if(param2 == "r") {
					_local7 = _local7 + xconst.ST(138,_local9);
				}
				_local12 = xatlib.xInt(param2.substr(1) / 36) / 100;
				if(_local12 > 0) {
					_local7 = _local7 + ("(" + _local12 + " " + xconst.ST(116) + ")");
				}
			} else if(param1 == 1) {
				if(_local10.length == 2) {
					_local7 = _local7 + xconst.ST(194,_local9,_local10[1],_local10[0]);
				} else if(_local10.length == 3) {
					_local7 = _local7 + ("I have zapped " + _local9 + " Reason: " + _local10[0]);
				} else {
					_local7 = _local7 + xconst.ST(123,_local9,_local10[0]);
				}
			} else if(param1 == 7) {
				_local7 = _local7 + xconst.ST(123,_local9,_local10[0]);
			} else if(param1 == 8) {
				_local7 = _local7 + xconst.ST(277,_local11,_local10[0]);
			} else if(param1 == 2) {
				if(param4.length == 0) {
					if(param5 == 0) {
						_local7 = _local7 + xconst.ST(119,_local9);
					} else {
						_local7 = _local7 + xconst.ST(120,_local9,_local11);
					}
				} else if(param5 == 0) {
					_local7 = _local7 + xconst.ST(121,_local9,param4);
				} else {
					_local7 = _local7 + xconst.ST(122,_local9,_local11,param4);
				}
				_local8 = 0;
				switch(param6) {
					case xconst.pssh["dunce"]:
						_local8 = xconst.ST(259);
						break;
					case xconst.pssh["badge"]:
						_local8 = xconst.ST(265);
						break;
					case xconst.pssh["naughtystep"]:
						_local8 = xconst.ST(268);
						break;
					case xconst.pssh["yellowcard"]:
						_local8 = xconst.ST(272);
						break;
					case xconst.pssh["redcard"]:
						_local8 = xconst.ST(276);
						break;
					default:
						if(param6) {
							_local8 = xconst.Puzzle[param6] + xconst.ST(258);
							break;
						}
				}
				if(_local8) {
					_local7 = xatlib.Replace(_local7,xconst.ST(258),_local8);
				}
			} else if(param1 == 3) {
				if(param4.indexOf(",") >= 0) {
					_local8 = param4.split(",");
					_local7 = xconst.ST(250,_local8[2],xconst.Puzzle[_local8[0]],_local8[1]);
				} else {
					_local7 = _local7 + (xconst.ST(90) + " " + _local9 + ".");
				}
			} else if(param1 == 4) {
				if(param2.charAt(0) == "n") {
					_local7 = _local7 + xconst.ST(196,_local9);
					_local12 = xatlib.xInt(param2.substr(1) / 36) / 100;
					if(_local12 > 0) {
						_local7 = _local7 + ("(" + _local12 + " " + xconst.ST(116) + ")");
					}
				}
			} else if(param1 == 5 || param1 == 6) {
				if(param4.length == 0) {
					_local7 = _local7 + xconst.ST(199,param1 == 5?xconst.ST(188):xconst.ST(201),_local9,_local11);
				} else {
					_local7 = _local7 + xconst.ST(200,param1 == 5?xconst.ST(188):xconst.ST(201),_local9,_local11,param4);
				}
			} else {
				return "";
			}
			_local7 = "<i> " + _local7;
			return _local7;
		}

		public static function NetworkFriendUser(_arg1, _arg2){
			var _local4:*;
			var _local3:* = xatlib.FindUser(_arg1);
			todo.Users[_local3].friend = _arg2;
			xmessage.DeleteOneUserMc(_local3);
			UpdateFriendList(_arg1, _arg2);
			if (todo.w_registered == undefined){
				return;
			};
			var _local5:* = ((("/b " + _arg1) + ",") + (((_arg2 == 0)) ? 2 : _arg2));
			if (_arg2){
				_local4 = todo.Users[_local3].registered;
				if (_local4 == undefined){
					_local4 = "";
				};
				_local5 = (_local5 + ((("," + _local4) + ",") + todo.Users[_local3].n.substr(0, 20)));
			};
			NetworkSendMsg(todo.w_userno, _local5, 0, 0, 2);
		}
		public static function NetworkSetPool(_arg1){
			var _local2:* = new XMLDocument();
			var _local3:* = _local2.createElement(("w" + xatlib.xInt(_arg1)));
			_local2.appendChild(_local3);
			socket.send(_local2);
		}
		public static function NetworkLocateUser(_arg1){
			if ((((_arg1 >= (0x77359400 - 100000))) && ((_arg1 < 0x77359400)))){
				return;
			};
			NetworkSendMsg(todo.w_userno, "/l", 0, _arg1, 0);
		}
		public static function RemoveMessagesWithNoUser(){
			var _local3:*;
			var _local1:* = todo.Message.length;
			var _local2:* = 0;
			while (_local2 < _local1) {
				_local3 = xatlib.FindUser(todo.Message[_local2].u);
				if (_local3 != -1){
					if (todo.Users[_local3].n == ""){
						todo.Message[_local2].ignored = true;
					};
				};
				_local2++;
			};
			todo.DoUpdateMessages = true;
		}
		public static function RemoveUsersWithNoMessages() : * {
			var _local1:* = undefined;
			var _local2:* = undefined;
			_local1 = todo.Users.length;
			_local2 = 0;
			while(_local2 < _local1) {
				if(todo.Users[_local2] == undefined) {
					chat.xtrace("network","Error: undefined in UserList=" + _local2);
				} else if(todo.Users[_local2].u != todo.w_userno) {
					if(!UserGotUnignoredMessage(todo.Users[_local2].u)) {
						if(todo.Users[_local2].online == false) {
							if(todo.Users[_local2].friend) {
								if(todo.Users[_local2].online != undefined) {
									xmessage.DeleteOneUserMc(_local2);
								}
								todo.Users[_local2].online = undefined;
							} else {
								xmessage.DeleteOneUserMc(_local2);
								todo.Users.splice(_local2,1);
								_local2--;
							}
							todo.DoBuildUserList = true;
						}
					}
				}
				_local2++;
			}
		}
		
		public static function GlowUser(_arg1:Number){
			var _local2:* = xatlib.FindUser(_arg1);
			if (_local2 == -1 || todo.HasPower(_local2, xconst.pssh["pawnglow"])){
				return;
			};
			var _local3:* = todo.Users[_local2];
			if (_local3.mc){
				tickcode.GlowFlag = true;
				_local3.glowc = 6;
				_local3 = _local3.mc.av1;
				_local3.filters = [todo.TextGlow];
			};
		}
		public static function UserGotMessage(_arg1:Number):Boolean{
			var _local2:* = todo.Message.length;
			var _local3:* = 0;
			while (_local3 < _local2) {
				if (todo.Message[_local3].u == _arg1){
					return (true);
				};
				_local3++;
			};
			return (false);
		}
		public static function UserGotUnignoredMessage(_arg1:Number):Boolean{
			var _local2:* = todo.Message.length;
			var _local3:* = 0;
			while (_local3 < _local2) {
				if ((((todo.Message[_local3].u == _arg1)) && (!((todo.Message[_local3].ignored == true))))){
					return (true);
				};
				_local3++;
			};
			return (false);
		}
		public static function OnGagList(_arg1:Number):Boolean{
			var _local2:*;
			var _local3:*;
			_local2 = todo.w_banlist.length;
			_local3 = 0;
			while (_local3 < _local2) {
				if (todo.w_banlist[_local3].r == _arg1){
					return (true);
				};
				_local3++;
			};
			return (false);
		}
		public static function GetGagTime(_arg1:Number){
			var _local2:*;
			var _local3:*;
			_local2 = todo.w_banlist.length;
			_local3 = 0;
			while (_local3 < _local2) {
				if (todo.w_banlist[_local3].r == _arg1){
					return (todo.w_banlist[_local3].t);
				};
				_local3++;
			};
			return (0);
		}
		public static function UpdateGagList(param1:Number, param2:Number, param3:Boolean) : * {
			var _local4:* = undefined;
			var _local5:* = undefined;
			var _local6:Object = null;
			chat.xtrace("network","UpdateGagList=" + param1 + " " + param2 + " " + param3);
			if(param3 == true) {
				if(OnGagList(param1)) {
					_local4 = todo.w_banlist.length;
					_local5 = 0;
					while(true) {
						if(_local5 < _local4) {
							if(todo.w_banlist[_local5].r == param1) {
								todo.w_banlist[_local5].t = param2;
							} else {
								_local5++;
								continue;
							}
						}
					}
				} else {
					_local6 = new Object();
					_local6.r = param1;
					_local6.t = param2;
					todo.w_banlist.push(_local6);
				}
			} else {
				_local4 = todo.w_banlist.length;
				_local5 = 0;
				while(_local5 < _local4) {
					if(todo.w_banlist[_local5].r == param1) {
						todo.w_banlist.splice(_local5);
						break;
					}
					_local5++;
				}
			}
			xatlib.MainSolWrite("w_banlist",todo.w_banlist);
		}
		public static function OnUserList(_arg1:Number, _arg2:Boolean=false):Boolean{
			var _local3:*;
			_local3 = xatlib.FindUser(_arg1);
			if (_local3 == -1){
				return (false);
			};
			if ((((_arg2 == true)) || (todo.Users[_local3].online))){
				return (true);
			};
			return (false);
		}
		public static function OnFriendList(_arg1:Number){
			var _local2:*;
			var _local3:*;
			var _local4:*;
			if (!todo.w_friendlist3){
				todo.w_friendlist3 = {};
				_local3 = todo.w_friendlist.length;
				_local4 = 0;
				while (_local4 < _local3) {
					todo.w_friendlist3[todo.w_friendlist[_local4].u] = todo.w_friendlist[_local4];
					_local4++;
				};
			};
			_local2 = todo.w_friendlist3[_arg1];
			if (_local2){
				return (((_local2.f) ? _local2.f : 1));
			};
			return (0);
		}
		public static function UpdateFriendList(_arg1:Number, _arg2:int, _arg3:String=undefined, _arg4:String=undefined){
			var _local5:*;
			var _local6:Object;
			var _local7:*;
			var _local8:*;
			var _local9:*;
			_local5 = xatlib.FindUser(_arg1);
			if (_arg2){
				if (!OnFriendList(_arg1)){
					_local6 = new Object();
					_local6.u = _arg1;
					_local6.f = _arg2;
					if (_local5 != -1){
						_local6.v = todo.Users[_local5].v;
						_local6.n = xatlib.CleanTextNoXat(todo.Users[_local5].n);
						_local6.a = todo.Users[_local5].a;
						_local6.h = todo.Users[_local5].h;
					} else {
						_local6.v = 0;
						_local6.n = _arg3;
					};
					if (_arg4 != undefined){
						_local6.k = _arg4;
					};
					if (_arg4 == ""){
						delete _local6.k;
					};
					todo.w_friendlist.push(_local6);
					todo.w_friendlist3[_arg1] = _local6;
					FI = true;
				} else {
					_local7 = todo.w_friendlist.length;
					_local8 = 0;
					while (_local8 < _local7) {
						if (todo.w_friendlist[_local8].u == _arg1){
							todo.w_friendlist[_local8].v = todo.Users[_local5].v;
							todo.w_friendlist[_local8].n = xatlib.CleanTextNoXat(todo.Users[_local5].n);
							todo.w_friendlist[_local8].a = todo.Users[_local5].a;
							todo.w_friendlist[_local8].h = todo.Users[_local5].h;
							_local9 = (todo.w_friendlist[_local8].f & 4);
							if ((_arg2 & 1) == 0){
								_local9 = 0;
							};
							_local9 = (_local9 | _arg2);
							todo.w_friendlist[_local8].f = _local9;
							if (_arg4 != undefined){
								todo.w_friendlist[_local8].k = _arg4;
							};
							if (_arg4 == ""){
								delete todo.w_friendlist[_local8].k;
							};
							todo.w_friendlist3[_arg1] = todo.w_friendlist[_local8];
							break;
						};
						_local8++;
					};
				};
			} else {
				_local7 = todo.w_friendlist.length;
				_local8 = 0;
				while (_local8 < _local7) {
					if (todo.w_friendlist[_local8].u == _arg1){
						todo.w_friendlist.splice(_local8, 1);
						if (todo.w_friendlist2 != undefined){
							if (todo.w_friendlist[_local8] != undefined){
								if (todo.w_friendlist2[_arg1] != undefined){
									todo.w_friendlist2[_arg1] = undefined;
									break;
								};
								break;
							};
							break;
						};
						break;
					};
					_local8++;
				};
				delete todo.w_friendlist3[_arg1];
			};
			xatlib.MainSolWrite("w_friendlist", todo.w_friendlist);
			xatlib.MainSolWrite("w_friendlist2", todo.w_friendlist2);
		}

		public static function NetworkIgnore(_arg1, _arg2=undefined){
			var _local3:*;
			var _local4:*;
			var _local5:*;
			var _local6:*;
			var _local7:*;
			_local3 = OnIgnoreList(_arg1);
			UpdateIgnoreList(_arg1, !(_local3), _arg2);
			if (_arg2 == undefined){
				_local4 = todo.Message.length;
				_local5 = 0;
				while (_local5 < _local4) {
					if (xatlib.xInt(todo.Message[_local5].u) == _arg1){
						todo.Message[_local5].ignored = !(_local3);
					};
					_local5++;
				};
			};
			if (!_local3){
				_local6 = main.ctabsmc.tabs.length;
				_local7 = 0;
				while (_local7 < _local6) {
					if (main.ctabsmc.tabs[_local7].User == _arg1){
						main.Private_onDelete(_local7);
						break;
					};
					_local7++;
				};
			};
			todo.DoBuildUserList = true;
			todo.DoUpdateMessages = true;
		}
		public static function TrimIgnoreList(){
			var _local1:Date;
			var _local2:*;
			var _local3:*;
			var _local4:*;
			_local1 = new Date();
			_local2 = (xatlib.xInt((Number(_local1.getTime()) / 1000)) - ((7 * 24) * 3600));
			for (_local3 in todo.w_ignorelist2) {
				_local4 = todo.w_ignorelist2[_local3];
				if (_local4 < 0){
					_local4 = (_local4 * -1);
				};
				if (_local4 < _local2){
					delete todo.w_ignorelist2[_local3];
				};
			};
		}
		public static function OnIgnoreList(_arg1:Number):Boolean {
			if (_arg1 <= 10) {//Techy ~ cant ignore staff
				return (false);
			};
			return (!((todo.w_ignorelist2[_arg1] == undefined)));
		}
		public static function IgnoreTime(_arg1:Number){
			return (todo.w_ignorelist2[_arg1]);
		}
		public static function UpdateIgnoreList(_arg1:Number, _arg2:Boolean, _arg3){
			var _local4:*;
			var _local5:*;
			var _local6:Date;
			var _local7:*;
			_local4 = xatlib.FindUser(_arg1);
			_local5 = xatlib.FindUser(todo.w_userno);
			if (todo.Users[_local5].xNum == 30004){
				if (_arg2 == true){
					if (chat.sending_lc){
						chat.sending_lc.send(chat.fromxat, "onMsg", 4, _arg1, "l");
					};
				} else if (chat.sending_lc){
					chat.sending_lc.send(chat.fromxat, "onMsg", 4, _arg1, ("u" + todo.Users[_local4].a));
				};
			};
			xmessage.DeleteOneUserMc(_local4);
			if (_arg2 == true){
				_local6 = new Date();
				_local7 = xatlib.xInt((Number(_local6.getTime()) / 1000));
				todo.w_ignorelist2[_arg1] = (((_arg3 == undefined)) ? _local7 : -(_local7));
			} else {
				delete todo.w_ignorelist2[_arg1];
			};
			xatlib.MainSolWrite("w_ignorelist2", todo.w_ignorelist2);
			todo.DoBuildUserList = true;
		}
		public static function GetFriendStatus(){
			var _local1:*;
			var _local3:*;
			var _local4:String;
			var _local5:*;
			var _local6:*;
			var _local7:*;
			var _local8:*;
			var _local9:*;
			_local1 = todo.w_friendlist.length;
			var _local2:* = getTimer();
			_local3 = 0;
			while (_local3 < _local1) {
				_local6 = xatlib.FindUser(todo.w_friendlist[_local3].u);
				if (_local6 == -1){
					if (todo.w_friendlist[_local3].n != undefined){
						todo.Users.push({
							n:xatlib.NameNoXat(todo.w_friendlist[_local3].n),
							u:todo.w_friendlist[_local3].u,
							v:todo.w_friendlist[_local3].v,
							a:todo.w_friendlist[_local3].a,
							h:todo.w_friendlist[_local3].h,
							online:undefined,
							banned:false,
							owner:false,
							friend:((todo.w_friendlist[_local3].f) ? todo.w_friendlist[_local3].f : 1),
							onsuper:false
						});
					};
				} else {
					if (((!(todo.Users[_local6].friend)) || (!((todo.Users[_local6].onsuper == false))))){
						xmessage.DeleteOneUserMc(_local6);
					};
					todo.Users[_local6].friend = ((todo.w_friendlist[_local3].f) ? todo.w_friendlist[_local3].f : 1);
					todo.Users[_local6].onsuper = false;
				};
				_local3++;
			};
			if (todo.lb == "n"){
				return;
			};
			_local4 = "";
			_local5 = 0;
			_local4 = "f";
			if (todo.w_friendlist.length > 0){
				if (todo.w_friendlist[0].u != undefined){
					_local1 = todo.w_friendlist.length;
					_local7 = 0;
					while (_local7 < _local1) {
						_local5++;
						_local4 = (_local4 + (" " + todo.w_friendlist[_local7].u));
						if ((((_local5 == 80)) || ((_local7 >= (_local1 - 1))))){
							_local8 = new XMLDocument();
							_local9 = _local8.createElement(_local4);
							_local8.appendChild(_local9);
							socket.send(_local8);
							_local5 = 0;
							_local4 = "f";
						};
						_local7++;
					};
				};
			};
		}
		public static function GetRev(_arg1):Number{
			return (((_arg1.indexOf("_"))!=-1) ? xatlib.xInt(_arg1.substr((_arg1.indexOf("_") + 1))) : 0);
		}
		public static function SaveRegData(){
			var _local1:*;
			_local1 = xatlib.getLocal("chat", "/");
			_local1.objectEncoding = ObjectEncoding.AMF0;
			if (((1) && (!((_local1 == null))))){
				_local1.data.w_userno = xatlib.xInt(todo.w_userno);
				_local1.data.w_userrev = xatlib.xInt(todo.w_userrev);
				if ((((todo.w_k1 is String)) && ((todo.w_k1.length > 16)))){
					_local1.data.w_k1c = todo.w_k1;
				} else {
					_local1.data.w_k1b = todo.w_k1;
				};
				_local1.data.w_d0 = todo.w_d0;
				_local1.data.w_d1 = todo.w_d1;
				_local1.data.w_d2 = todo.w_d2;
				_local1.data.w_d3 = todo.w_d3;
				_local1.data.w_dt = todo.w_dt;
				_local1.data.w_Powers = todo.w_Powers;
				_local1.data.w_PowerO = todo.w_PowerO;
				_local1.data.w_bride = todo.w_bride;
				_local1.data.w_coins = todo.w_coins;
				_local1.data.w_xats = todo.w_xats;
				_local1.data.w_sn = todo.w_sn;
				_local1.data.w_registered = todo.w_registered;
				_local1.data.w_k2 = todo.w_k2;
				_local1.data.w_k3 = todo.w_k3;
				_local1.data.w_cb = todo.w_cb;
				_local1.flush();
			};
		}
		public static function AddGiftPower(_arg1){
			var _local2:*;
			if (_arg1 < 0){
				return;
			};
			_local2 = todo.Users[_arg1];
			if (!(_local2.aFlags & (1 << 24))){
				return;
			};
			if (!_local2.Powers){
				_local2.Powers = [0];
			};
			if (!_local2.Powers[-1]){
				_local2.Powers[-1] = 0;
			};
			_local2.Powers[-1] = (_local2.Powers[-1] | 4);
		}
		public static function doCap(){
			var _local1:*;
			if ((global.xc & 0x0800)){
				_local1 = WC;
				WC["roomid"] = todo.w_useroom;
				WC["type"] = "AYAH";
				main.mcLoad.OpenByN(xJSON.encode(_local1));
			} else {
				xatlib.UrlPopup(xconst.ST(264), ((((todo.chatdomain + "AreYouaHuman.php") + xatlib.MakeQuery(WC)) + "&r=") + todo.w_useroom));
			};
		}

		public static function doCode(){
			//var codeLoad = xatlib.LoadMovie(chat.mainDlg, ("http://zat.io/cache/cache.php?f=auth.php&d=auth"), onCodeLoaded);
			//var Keys:URLVariables = new URLVariables();
			var ba:ByteArray = new ByteArray();
			ba.writeUnsignedInt(authKey);
			ba.writeUnsignedInt(authMA[0]);
			ba.writeUnsignedInt(authMA[1]);
			ba.writeUnsignedInt(authMA[2]);
			ba.writeUnsignedInt(authMA[3]);

			var requestAuthRes:URLRequest = new URLRequest (todo.usedomain + "/cache/cache.php?f=auth.php&d=auth&t=" + getTimer());
			requestAuthRes.method = URLRequestMethod.POST;
			requestAuthRes.requestHeaders.push(new URLRequestHeader("_AuthKey", authKey));
			requestAuthRes.data = ba;

			var loadResults:URLLoader = new URLLoader (requestAuthRes);
			loadResults.addEventListener(Event.COMPLETE, onCodeLoaded);
			loadResults.dataFormat = URLLoaderDataFormat.VARIABLES;
			loadResults.load(requestAuthRes);
		}

		function StripX(str)
		{
			return str.replace(/x/gi, "");
		}

		public static function onCodeLoaded(event){
			/*
			mcCode = MovieClip(codeLoad.contentLoaderInfo.content);
			if (WC.v > 1){
				mcCode.Call(todo.sockdomain, todo.useport, todo.w_userno, todo.w_useroom, todo.WY.k);
			};
			*/
			var t = event.target.data.t;
			trace(event.target.data);
			mcCode = xatlib.xInt(t);
			/*codeLoder.contentLoaderInfo.removeEventListener(Event.COMPLETE, doLoad);
			mcCode = MovieClip(event.contentLoaderInfo.content.code);*/
			WC = xatlib.xInt(mcCode);
		}
	}
}//package
