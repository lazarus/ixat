package {
	import flash.external.ExternalInterface;
	import flash.events.*;
	import com.adobe.serialization.json.*;
	import flash.display.*;
	import flash.media.*;
	import flash.text.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.system.*;
	import flash.geom.*;
	import flash.ui.*;
	import flash.xml.*;
	import fl.events.SliderEvent;

	public class main extends Sprite {

		static const un = undefined;
		public static const flixs = [92, 96, 98, 102, 108, 148, 156, 278, 300];

		public static var GrpIc:MovieClip;
		private static var GrpIcscale;
		public static var em:Array = new Array();
		public static var textfield2:TextField;
		public static var mcgetachat;
		public static var ButtonLoginMc;
		public static var lockmc;
		public static var retmc;
		public static var retmcBut;
		public static var nudge;
		public static var upw;
		public static var uph;
		public static var upx;
		public static var upy;
		public static var fmt;
		public static var hint:hints;
		public static var ctabsmc;
		public static var mctextbackgroundmask;
		public static var mctextbackground;
		public static var mcuserbackground;
		public static var mcuserbackgroundmask;
		public static var utabsmc;
		public static var mscrollmc;
		public static var uscrollmc;
		public static var textPaneWidth;
		public static var uMessLst:Array = new Array();
		static var mcxLoad;
		public static var mcLoad:MovieClip = null;
		static var mcxMusicPlayer = null;
		static var musiccode = null;
		public static var mcMusicPlayer:MovieClip = null;
		public static var mcscroller;
		public static var mcscrollertext;
		public static var mcscrollermask;
		public static var fmts = new TextFormat();
		public static var back_layer;
		public static var backs = new Array();
		public static var back_no = 0;

		public static var pc_layer:*;

		public static var pc_pic:*;
		public static var flix_layer;
		public static var wink_layer;
		public static var chat_layer;
		public static var dialog_layer;
		public static var touchtimeout = 0;
		public static var dialogs;
		public static var box_layer;
		public static var eip_layer;
		public static var puzzle_layer;
		public static var kiss_layer;
		public static var moveable;
		static var RadioSound = new Array();
		static var SndIcnX = 0;
		static var Dragee;
		public static var mcsnd;
		public static var equ:Sprite = new Sprite();
		public static var debugtext:TextField = new TextField();
		public static var dbgstr = "";
		private static var receiving_profile:LocalConnection = null;
		private static var sending_profile:LocalConnection = null;
		private static var ProfileUserNo = 0;
		private static var flix_opts:Object;
		private static var flix_mc;
		public static var mbs;
		public static var ubs;
		public static var logo;
		public static var soundSliders:Array = new Array();

		public static const OkPic = { xat:1, xatech:1 };

		var textfield2background;
		var cmessmc;
		var emotes;

		public function main(){
			this.emotes = new Sprite();
			super();
		}
		static function SetTyping(_arg1:int, _arg2:Boolean){
			if (!_arg1){
				return;
			};
			var _local3:int = xatlib.FindUser(_arg1);
			if (_local3 < 0){
				return;
			};
			if (!todo.HasPower(_local3, 172)){
				return;
			};
			if (_arg2){
				todo.Users[_local3].flag0 = (todo.Users[_local3].flag0 | 65536);
			} else {
				todo.Users[_local3].flag0 = (todo.Users[_local3].flag0 & ~(65536));
			};
			xmessage.DeleteOneUserMc(_local3);
		}
		public static function ProcessMessage(){
			var _local_2:*;
			var _local_3:*;
			var _local_4:*;
			var _local_5:*;
			var _local_6:*;
			var _local_7:*;
			var _local_8:*;
			var _local_9:*;
			var _local_10:*;
			var _local_11:*;
			var _local_12:*;
			var _local_13:int;
			var _local_14:*;
			var _local_15:*;
			var _local_16:*;
			var _local_17:*;
			var _local_18:*;
			var _local_19:*;
			var _local_20:*;
			var _local_21:*;
			var _local_22:*;
			var _local_23:*;
			var _local_24:Boolean;
			var _local_25:*;
			var _local_26:*;
			var _local_1:Number = xatlib.FindUser(todo.w_userno);
			_local_2 = todo.MessageToProcess;
			todo.MessageToProcess = "";
			if ((((_local_2.charAt(0) == "$")) && (!((_local_2.indexOf("=") == -1))))){
				if (_local_2 == "$="){
					if (todo.Macros != undefined){
						todo.helpstr = "";
						for (_local_5 in todo.Macros) {
							todo.helpstr = (todo.helpstr + (((("$" + _local_5) + "=") + todo.Macros[_local_5]) + " "));
						};
						todo.helpupdate = 0;
					};
					return;
				};
				_local_4 = _local_2.substr(1).split("=");
				if (_local_4[0].indexOf(" ") == -1){
					if (todo.Macros == undefined){
						todo.Macros = new Object();
					};
					if ((((_local_4[1] == undefined)) || ((_local_4[1].length == 0)))){
						delete todo.Macros[_local_4[0]];
					} else {
						todo.Macros[_local_4[0]] = _local_4[1];
					};
					if (_local_4[0] == "status"){
						xatlib.ReLogin();
					};
					if (_local_4[0] == "sline"){
						chat.mainDlg.UpdateEmotes();
					};
					if (_local_4[0] == "mark"){
						xconst.MakeBads();
					};
					todo.helpstr = ((("$" + _local_4[0]) + "=") + (((_local_4[1] == undefined)) ? "" : _local_4[1]));
					todo.helpupdate = 0;
					xatlib.MainSolWrite("Macros", todo.Macros);
					return;
				};
			};
			if (!(((todo.PrivateChat == 0)) && (((((!((_local_1 == -1))) && (((todo.Users[_local_1].banned) && (!((todo.Users[_local_1].flag0 & 131072))))))) || (((!((_local_1 == -1))) && (todo.Users[_local_1].gagged))))))){
				if (_local_2.charAt(0) == "/"){
					_local_6 = _local_2.substr(1, 1);
					switch (_local_6){
						case "c":
							if (_local2.substr(0, 6) == "/close")
							{
								ExternalInterface.call("ClearControl");
								ExternalInterface.call("ClearMedia");
							};
						break;
						case 'v':
							if (todo.Users[_local_1].volunteer) {
								todo.helpstr = "VOL";
							} else if(todo.Users[_local_1].admin) {
								todo.helpstr = "STAFF";
							} else {
								todo.helpstr = "NOTHING";
							}
							todo.helpupdate = 0;
						break;
						case "s":
							SetScroller(_local_2.substr(2, 510));
							network.NetworkSendMsg(todo.w_userno, _local_2.substr(0, 0x0200));
							break;
						case "x":
						case "m":
						case "n":
							network.NetworkSendMsg(todo.w_userno, _local_2, ctabsmc.TabUser());
							break;
						case "o":
							todo.w_Options = _local_2.substr(2, 0x0100);
							if (todo.w_Options.length == 0){
								todo.w_Options = undefined;
							};
							xatlib.MainSolWrite("w_Options", todo.w_Options);
							break;
						case "S":
						case "F":
							if (!todo.HasPowerA(todo.w_Powers, xconst.pssh["goodfriend"], todo.w_Mask)){
								return;
							};
						case "f":
							_local_7 = _local_2.substr(2, (64 + 16)).split(" ");
							_local_8 = 0;
							_local_11 = xatlib.xInt(_local_7[0]);
							_local_12 = ctabsmc.TabUser();
							if ((((_local_11 == 0)) && (_local_7[0]))){
								_local_8 = _local_7[0];
								_local_7.shift();
							};
							if (((!(_local_7[0])) && (_local_12))){
								_local_7[0] = _local_12;
							};
							_local_11 = xatlib.xInt(_local_7[0]);
							if (_local_11 >= 3){
								_local_15 = (((_local_6 == "F")) ? (8 + 1) : 1);
								if (_local_6 == "S"){
									_local_15 = 25;
								};
								_local_10 = ((_local_7[1]) ? _local_7[1] : _local_7[0]);
								network.UpdateFriendList(_local_11, _local_15, _local_10, _local_8);
								network.NetworkFriendUser(_local_11, _local_15);
							};
							_local_13 = xatlib.FindUser(_local_11);
							xmessage.DeleteOneUserMc(_local_13);
							break;
						case "d":
							if (_local_2.substr(0, 6) == "/debug"){
								chat.debug_cmd(_local_2);
							};
							break;
						case "t":
							if (ctabsmc.TabUser()){
								network.NetworkSendMsg(todo.w_userno, _local_2, 0, ctabsmc.TabUser(), 0);
								network.NetworkIgnore(ctabsmc.TabUser());
							} else {
								xkiss.Kiss({
									"t":_local_2.substr(2),
									"u":todo.w_userno,
									"k":"Ttth"
								});
							};
							break;
						case "+":
						case "-":
							/* Xats Og code
							_local_14 = xconst.pssh[_local_2.substr(2).toLowerCase()];
							if (_local_14){
								DialogPowers.PowOnOff(_local_14, (_local_6 == "+"));
								xatlib.ReLogin();
							};
							*/
							//Techy ~ disable/enable multiple powers in 1 go /-xavi gold purple etc
							var powers:Array = _local_2.substr(2).toLowerCase().split(" ");
							if (powers[0] == "all") {
								todo.w_Mask = (_local_6 == "+" ? todo.NO_POWERS : todo.ALL_POWERS).slice();
								xatlib.MainSolWrite("w_Mask", todo.w_Mask);
								xatlib.ReLogin();
								break;
							};
							var changed:Boolean = false;
							var i:Number = 0;
							while(i < powers.length) {
								_local_14 = xconst.pssh[powers[i]];
								if (_local_14) {
									DialogPowers.PowOnOff(_local_14, (_local_6 == "+"));
									changed = true;
								};
								i++;
							}
							if (changed) {
								xatlib.ReLogin();
							}
							break;
						case "j":
						case "h":
							_local_3 = _local_2.substr(1, 2);
							if ((((_local_3 == "hu")) || ((_local_17 = (_local_3 == "ji"))))){
								_local_2 = _local_2.replace(";=", ";-");//Techy ~ Temp hug glitch fix
								_local_4 = _local_2.split(" ");
								_local_4[1] = _local_4[1].toLowerCase();
								_local_21 = _local_4[1].replace(/[0-9]/g, "");
								_local_18 = _local_21.length;
								_local_17 = 1;
								while (_local_17 <= _local_18) {
									_local_3 = _local_21.substr(0, _local_17);
									if (xconst.hugs[_local_3]){
										_local_19 = xconst.hugs[_local_3];
										_local_20 = _local_4[1];
										break;
									};
									_local_17++;
								};
								if (!_local_19){
									_local_16 = xconst.ST(280);
								} else {
									if (!todo.HasPowerA(todo.w_Powers, (_local_19 % 10000), todo.w_Mask)){
										_local_16 = xconst.ST(252);
									};
								};
								if (_local_16){
									todo.helpstr = _local_16;
									todo.helpupdate = 0;
								} else {
									_local_22 = new XMLDocument();
									_local_24 = (_local_4[0].substr((_local_4[0].length - 3), 3) == "all");
									_local_23 = _local_22.createElement("a");
									_local_4.splice(0, 2);
									_local_4 = _local_4.join(" ");
									if (!_local_4){
										_local_4 = "";
									};
									_local_23.attributes.m = _local_4.replace(/;=/gi, "");
									_local_23.attributes.h = _local_19;
									if (_local_20){
										_local_23.attributes.j = _local_20;
									};
									if (ctabsmc.TabIsPrivate()){
										_local_23.attributes.b = ctabsmc.TabUser();
										if (_local_24){
											main.ctabsmc.UpdateTabs(0);
										} else {
											_local_23.attributes.e = 1;
										};
									};
									_local_22.appendChild(_local_23);
									network.socket.send(_local_22);
									chat.xtrace("tx", _local_23);
								};
								break;
							};
						default:
							network.NetworkSendMsg(todo.w_userno, _local_2);
					};
				} else {
					if (_local_2.indexOf("k2=") != -1){
						todo.helpstr = xconst.ST(214);
						todo.helpupdate = 0;
					} else {
						if (todo.Macros != undefined){
							for (_local_5 in todo.Macros) {
								_local_2 = xatlib.Replace(_local_2, ("$" + _local_5), todo.Macros[_local_5]);
							};
						};
						ProcessHelp(_local_2);
						ProcessSounds(_local_2, ((((!((todo.w_Powers == undefined))) && (!((todo.w_Mask == undefined))))) ? !(((todo.w_Powers[0] & (1 << 8)) & ~(todo.w_Mask[0]))) : 1), _local_1);
						_local_2 = xatlib.PreProcSmilie(_local_2, undefined, todo.w_Options);
						_local_25 = _local_2;
						if (todo.PrivateMessage != 0){
							_local_25 = ("<priv> " + _local_2);
						};
						todo.mi++;
						if (!(((((((((((xconst.f_Live & todo.FlagBits)) && (!(todo.w_mainowner)))) && (!(todo.w_owner)))) && (!(todo.w_moderator)))) && (!(todo.w_member)))) && (!(ctabsmc.TabIsPrivate())))){
							todo.Message.push({
								"i":((todo.mi * 2) + 1),
								"n":0,
								"t":_local_25,
								"u":todo.w_userno,
								"s":((ctabsmc.TabIsPrivate()) ? 2 : 0),
								"d":ctabsmc.TabUser()
							});
						};
						if (todo.messageecho == "m"){
							if (network.YC){
								_local_26 = (xatlib.xInt(todo.w_d1) - network.YC);
								if (_local_26 < 0){
									_local_26 = 0;
								};
								_local_26 = xatlib.xInt(((_local_26 / (24 * 3600)) + 0.3));
								if (_local_26 > 0){
									chat.sending_lc.send(chat.fromxat, "onMsg", 4, ((todo.mi * 2) + 1), _local_25);
								};
							};
						} else {
							todo.DoUpdateMessages = true;
							todo.ScrollDown = true;
							todo.LastScrollTime = undefined;
							if (todo.MessageCount > 0){
								todo.MessageCount = 25;
							};
							if (_local_2 != todo.LastMessageToSend){
								if (todo.MessageToSend.length == 0){
									todo.MessageToSend = _local_2;
								} else {
									todo.MessageToSend = (todo.MessageToSend + " ");
									todo.MessageToSend = (todo.MessageToSend + _local_2);
								};
								todo.MessageToSend = todo.MessageToSend.substr(0, 0x0100);
							} else {
								todo.MessageCount = 25;
								todo.MessageToSend = _local_2;
							};
							if ((((todo.MessageToSend == "!bot")) && (!((todo.w_lang == undefined))))){
								todo.MessageToSend = ((todo.MessageToSend + " ") + todo.w_lang);
							};
						};
					};
				};
			};
		}
		/*
		public static function ProcessMessage(){
			var _local2:*;
			var _local3:*;
			var _local4:*;
			var _local5:*;
			var _local6:*;
			var _local7:*;
			var _local8:*;
			var _local9:*;
			var _local10:*;
			var _local11:*;
			var _local12:*;
			var _local1:Number = xatlib.FindUser(todo.w_userno);
			_local2 = todo.MessageToProcess;
			todo.MessageToProcess = "";
			if ((((_local2.charAt(0) == "$")) && (!((_local2.indexOf("=") == -1))))){
				if (_local2 == "$="){
					if (todo.Macros != undefined){
						todo.helpstr = "";
						for (_local4 in todo.Macros) {
							todo.helpstr = (todo.helpstr + (((("$" + _local4) + "=") + todo.Macros[_local4]) + " "));
						};
						todo.helpupdate = 0;
					};
					return;
				};
				_local3 = _local2.substr(1).split("=");
				if (_local3[0].indexOf(" ") == -1){
					if (todo.Macros == undefined){
						todo.Macros = new Object();
					};
					if ((((_local3[1] == undefined)) || ((_local3[1].length == 0)))){
						delete todo.Macros[_local3[0]];
					} else {
						todo.Macros[_local3[0]] = _local3[1];
					};
					if (_local3[0] == "status" || _local3[0] == "chatback"){
						xatlib.ReLogin();
					};
					todo.helpstr = ((("$" + _local3[0]) + "=") + (((_local3[1] == undefined)) ? "" : _local3[1]));
					todo.helpupdate = 0;
					xatlib.MainSolWrite("Macros", todo.Macros);
					return;
				};
			};
			if ((((todo.PrivateChat == 0)) && (((((!((_local1 == -1))) && (((todo.Users[_local1].banned) && (!((todo.Users[_local1].flag0 & 131072))))))) || (((!((_local1 == -1))) && (todo.Users[_local1].gagged))))))){
			} else {
				if (_local2.charAt(0) == "/"){
					_local5 = _local2.substr(1, 1);
					switch (_local5){
						case "c":
							if (_local2.substr(0, 6) == "/close")
							{
								ExternalInterface.call("ClearControl");
								ExternalInterface.call("ClearMedia");
							 };
						break;
						case "s":
							SetScroller(_local2.substr(2, 510));
							network.NetworkSendMsg(todo.w_userno, _local2.substr(0, 0x0200));
							break;
						case "x":
						case "m":
						case "n":
							network.NetworkSendMsg(todo.w_userno, _local2, ctabsmc.TabUser());
							break;
						case "o":
							todo.w_Options = _local2.substr(2, 0x0100);
							if (todo.w_Options.length == 0){
								todo.w_Options = undefined;
							};
							xatlib.MainSolWrite("w_Options", todo.w_Options);
							break;
						case "f":
							_local6 = _local2.substr(2, 64).split(" ");
							if (xatlib.xInt(_local6[0]) > 128){
								network.UpdateFriendList(xatlib.xInt(_local6[0]), 1, ((_local6[1]) ? _local6[1] : _local6[0]));
							};
							break;
						case "d":
							if (_local2.substr(0, 6) == "/debug"){
							};
							break;
						case "t":
							if (ctabsmc.TabUser()){
								network.NetworkSendMsg(todo.w_userno, _local2, 0, ctabsmc.TabUser(), 0);
								network.NetworkIgnore(ctabsmc.TabUser());
							} else {
								xkiss.Kiss({
									t:_local2.substr(2),
									u:todo.w_userno,
									k:"Ttth"
								});
							};
							break;
						case "+":
						case "-":
							_local7 = xconst.pssh[_local2.substr(2).toLowerCase()];
							if (_local7){
								DialogPowers.PowOnOff(_local7, (_local5 == "+"));
								xatlib.ReLogin();
							};
							break;
						default:
							network.NetworkSendMsg(todo.w_userno, _local2);
					};
				} else {
					if (_local2.indexOf("k2=") != -1){
						todo.helpstr = xconst.ST(214);
						todo.helpupdate = 0;
					} else {
						if (todo.Macros != undefined){
							for (_local4 in todo.Macros) {
								_local2 = xatlib.Replace(_local2, ("$" + _local4), todo.Macros[_local4]);
							};
						};
						ProcessHelp(_local2);
						ProcessSounds(_local2, ((((!((todo.w_Powers == undefined))) && (!((todo.w_Mask == undefined))))) ? !(((todo.w_Powers[0] & (1 << 8)) & ~(todo.w_Mask[0]))) : 1), _local1);
						_local2 = xatlib.PreProcSmilie(_local2, undefined, todo.w_Options);
						_local8 = _local2;
						if (todo.PrivateMessage != 0){
							_local8 = ("<priv> " + _local2);
						};
						todo.mi++;
						if ((((((((((((xconst.f_Live & todo.FlagBits)) && (!(todo.w_mainowner)))) && (!(todo.w_owner)))) && (!(todo.w_moderator)))) && (!(todo.w_member)))) && (!(ctabsmc.TabIsPrivate())))){
						} else {
							todo.Message.push({
								i:((todo.mi * 2) + 1),
								n:0,
								t:_local8,
								u:todo.w_userno,
								s:((ctabsmc.TabIsPrivate()) ? 2 : 0),
								d:ctabsmc.TabUser()
							});
						};
						if (todo.messageecho == "m"){
							if (network.YC){
								_local9 = (xatlib.xInt(todo.w_d1) - network.YC);
								if (_local9 < 0){
									_local9 = 0;
								};
								_local9 = xatlib.xInt(((_local9 / (24 * 3600)) + 0.3));
								if (_local9 > 0){
									chat.sending_lc.send(chat.fromxat, "onMsg", 4, ((todo.mi * 2) + 1), _local8);
								};
							};
						} else {
							todo.DoUpdateMessages = true;
							todo.ScrollDown = true;
							todo.LastScrollTime = undefined;
							if (todo.MessageCount > 0){
								todo.MessageCount = 25;
							};
							if (_local2 != todo.LastMessageToSend){
								if (todo.MessageToSend.length == 0){
									todo.MessageToSend = _local2;
								} else {
									todo.MessageToSend = (todo.MessageToSend + " ");
									todo.MessageToSend = (todo.MessageToSend + _local2);
								};
								todo.MessageToSend = todo.MessageToSend.substr(0, 0x0100);
							} else {
								todo.MessageCount = 25;
							};
							if ((((todo.MessageToSend == "!bot")) && (!((todo.w_lang == undefined))))){
								todo.MessageToSend = ((todo.MessageToSend + " ") + todo.w_lang);
							};
						};
					};
				};
			};
		}
		*/
		public static function ProcessHelp(_arg1:String){
			_arg1.toLowerCase();
			if (_arg1.indexOf("change") != -1){
				if (((((((!((_arg1.indexOf("name") == -1))) || (!((_arg1.indexOf("picture") == -1))))) || (!((_arg1.indexOf("pic") == -1))))) || (!((_arg1.indexOf("avatar") == -1))))){
					todo.helpstr = xconst.ST(30, (" <o> <l>" + todo.w_name));
					todo.HelpUpdate = (300 + (todo.helpstr.length * 8));
				};
			};
		}
		public static function PlayMusic(_arg1){
			var _local2:*;
			var _local3:URLRequest;
			if (todo.config["WEB"]){
				if ((todo.w_sound & 1)){
					_local2 = _arg1.split("piano#");
					musiccode = _local2[1];
					if (mcxMusicPlayer == null){
						Security.allowDomain("*");
						Security.allowDomain("*");
						mcxMusicPlayer = new Loader();
						_local3 = new URLRequest(todo.flashdomain + "musicplayer.swf?a7");
						mcxMusicPlayer.load(_local3);
						mcxMusicPlayer.contentLoaderInfo.addEventListener(Event.COMPLETE, chat.mainDlg.onMusicPlayerLoaded);
						mcxMusicPlayer.visible = false;
						chat.mainDlg.addChild(mcxMusicPlayer);
					} else {
						if (musiccode != null){
							mcMusicPlayer.playmusic(musiccode, todo.w_Vol[1]);
						};
					};
				};
			};
		}

        public static function ProcessSounds(_arg_1:String, _arg_2:Boolean, _arg_3:*=-1, _arg_4:*=-1){
            var _local_6:Number;
            var _local_7:String;
            var _local_8:Array;
            var _local_9:*;
            var _local_5:Boolean;
            if ((todo.w_sound & 1)){
                _arg_1.toLowerCase();
                if (((!((_arg_3 == -1))) && (todo.HasPower(_arg_3, 117)))){
                    _local_6 = _arg_1.indexOf("piano#");
                    if (_local_6 != -1){
                        PlayMusic(_arg_1);
                        return;
                    };
                };
                _local_6 = _arg_1.indexOf("#");
                if (((!((_local_6 == -1))) && (_arg_2))){
                    if (!(((_local_6 > 0)) && (!((_arg_1.charAt((_local_6 - 1)) == " "))))){
                        _local_7 = _arg_1.substr((_local_6 + 1));
                        _local_7 = xatlib.CleanText(_local_7);
                        _local_8 = new Array();
                        _local_8 = _local_7.split("_");
                        _local_9 = _local_8[0];
                        if (_local_9.length > 0){
                            if (_local_9 != "laserfire3"){
                                todo.CustomSound = _local_9;
                                todo.DoAudieSnd = true;
                                _local_5 = true;
                            };
                        };
                    };
                };
                if (!_local_5){
                    todo.DoMessageSnd = true;
                };
            };
            if (((((((!(_local_5)) && (todo.goodfriend))) && ((_arg_4 >= 0)))) && ((todo.Users[_arg_4].friend & 16)))){
                todo.DoMessageSnd2 = todo.Users[_arg_4].u;
            };
        }
		
		public static function logoutbutonPress(){
			var _local1:*;
			main.closeDialog();
			xmessage.mspos = undefined;
			while (todo.Pools.length > 0) {
				todo.Pools.splice(0);
			};
			todo.PrivateMessage = 0;
			lockmc.visible = false;
			if (todo.lb == "n"){
				_local1 = xatlib.getLocal(("chat" + String(todo.w_useroom)), "/");
				_local1.objectEncoding = ObjectEncoding.AMF0;
				todo.pass = _local1.data.pass;
				if (todo.pass != undefined){
					todo.pass = xatlib.xInt(todo.pass);
				};
				network.attempt = 0;
				network.prevrpool = -1;
				network.NetworkStartChat();
			} else {
				todo.lb = "n";
				todo.DoUpdate = true;
				network.NetworkClose();
			};
		}
		private static function flix_Loaded(_arg1){
			var _local2:* = _arg1.currentTarget.loader.contentLoaderInfo.content;
			_local2.Go(flix_opts);
		}
		public static function Private_onRelease(_arg1:Number){
			main.hint.HintOff();
			main.utabsmc.SetVisitorsTab();
			todo.DoUpdateMessages = true;
			todo.DoBuildUserListScrollUp = true;
			todo.ScrollDown = true;
			todo.LastScrollTime = undefined;
			main.ctabsmc.UpdateTabs(_arg1);
			main.ctabsmc.ColorTab(_arg1, 0xFFFFFF);
			xmessage.OpenGifts(main.ctabsmc.tabs[_arg1].User, 2);
		}
		public static function Private_onDelete(_arg1:Number){
			main.hint.HintOff();
			main.utabsmc.SetVisitorsTab();
			var _local2:* = main.ctabsmc.tabs[_arg1].ImIndex;
			main.ctabsmc.tabs.splice(_arg1, 1);
			if (todo.w_useroom == todo.w_room){
				main.ctabsmc.UpdateTabs(0);
				main.ctabsmc.ColorTab(0, 0xFFFFFF);
			} else {
				main.ctabsmc.UpdateTabs(1);
				main.ctabsmc.ColorTab(1, 0xFFFFFF);
			};
			chat.mainDlg.UpdateBackground(0, 0);
			todo.DoUpdateMessages = true;
			todo.DoBuildUserList = true;
			todo.ScrollDown = true;
		}
		public static function onUserScrollChange(){
			var _local1:* = ((xmessage.useryc3 - uph) + 4);
			var _local2:* = 0;
			if (_local1 > 0){
				uscrollmc.Scr_size = _local1;
				_local2 = uscrollmc.Scr_position;
			} else {
				uscrollmc.Scr_position = 0;
			};
			mcuserbackground.y = -(_local2);
			tickcode.UserScroll = true;
		}
		public static function LookupPool(_arg1){
			var _local2:int = todo.Pools.length;
			var _local3:* = 0;
			while (_local3 < _local2) {
				if (_arg1 == todo.Pools[_local3]){
					return (_local3);
				};
				_local3++;
			};
			return (0);
		}
		public static function SetScroller(_arg1){
			fmts.color = 0;
			var _local2:* = _arg1.indexOf("#");
			if (_local2 != -1){
				fmts.color = parseInt(_arg1.substr((_local2 + 1), 6), 16);
				_arg1 = _arg1.substr(0, _local2);
			};
			mcscrollertext.text = _arg1;
			mcscrollertext.x = xatlib.NX(435);
			mcscrollertext.y = (xatlib.NY(469) - 12);
			mcscrollertext.setTextFormat(fmts);
			mcscrollertext.selectable = false;
			mcscrollertext.cacheAsBitmap = true;
		}
		public static function openDialog(_arg1, _arg2=undefined){
			closeDialog();
			var _local3:* = null;
			switch (_arg1){
				case 1:
					_local3 = new DialogProfile(_arg2);
					break;
				case 2:
					_local3 = new DialogActions(_arg2);
					break;
				case 3:
					_local3 = new DialogKiss(_arg2);
					break;
				case 4:
					_local3 = new DialogEdit(_arg2);
					break;
				case 5:
					_local3 = new DialogHelp(_arg2);
					break;
				case 7:
					_local3 = new DialogPowers(_arg2);
					break;
				case 11:
					_local3 = new DialogReason(_arg2);
					break;
				case 12:
					_local3 = new DialogMacros();
					break;
			   // case 13:
					//_local3 = new DialogPawns();
					//break;
			};
			if (_local3 != null){
				dialog_layer.addChild(_local3);
			};
		}
		public static function closeDialog(){
			while (dialog_layer.numChildren) {
				dialog_layer.removeChildAt(0);
			};
			while (dialogs.numChildren) {
				dialogs.removeChildAt(0);
			};
		}

		function onLoadLoaded(_arg1:Event){
			mcLoad = MovieClip(mcxLoad.contentLoaderInfo.content);
			mcLoad.ping();
		}
		function StartChat(){
			var t:* = undefined;
			var t2:* = undefined;
			var mRequest:* = null;
			fmts.color = 0;
			fmts.align = "left";
			fmts.font = "_sans";
			fmts.size = 10;
			fmts.bold = true;
			back_layer = new xSprite();
			addChild(back_layer);
			flix_layer = new xSprite();
			addChild(flix_layer);
			pc_layer = new xSprite();
			addChild(pc_layer);
			wink_layer = new xSprite();
			addChild(wink_layer);
			hint = new hints();
			addChild(equ);
			todo.tpw = xatlib.NX(460);
			todo.tph = xatlib.NY(320);
			todo.tpx = xatlib.NX(10);
			todo.tpy = xatlib.NY(10);
			textPaneWidth = ((todo.tpw - 15) - 45);
			if (todo.config["WEB"]){
				if (!todo.bThin){
					Security.allowDomain("*");
					Security.allowDomain("*");
					mcxLoad = new Loader();
					mRequest = new URLRequest(todo.flashdomain + "load2.swf?a3");
					mcxLoad.load(mRequest);
					mcxLoad.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoadLoaded);
					mcxLoad.visible = false;
					addChild(mcxLoad);
				};
			};
			this.cmessmc = new xmessage();
			xmessage.AddGames();
			addChild(this.cmessmc);
			ctabsmc = new ctabs();
			addChild(ctabsmc);
			if (!todo.bMobile){
				mctextbackgroundmask = xatlib.AddBackground(this, (todo.tpx + 1), (todo.tpy + 1), ((todo.tpw - 2) - xatlib.NX(16)), (todo.tph - 2), ((xatlib.c_bl | xatlib.c_Mask) | xatlib.c_Clip));
				mctextbackground = new Sprite();
				mctextbackground.x = todo.tpx;
				mctextbackground.y = todo.tpy;
				mctextbackground.mask = mctextbackgroundmask;
				addChild(mctextbackground);
			};
			utabsmc = new ctabs();
			addChild(utabsmc);
			upw = xatlib.NX(150);
			uph = xatlib.NY(320);
			upx = xatlib.NX(480);
			upy = xatlib.NY(10);
			if (!todo.bMobile){
				mcuserbackgroundmask = xatlib.AddBackground(this, (main.upx + 1), (main.upy + 1), ((main.upw - 2) - xatlib.NX(16)), (main.uph - 2), (xatlib.c_Mask | xatlib.c_Clip));
				mcuserbackground = new Sprite();
				mcuserbackground.x = main.upx;
				mcuserbackground.y = main.upy;
				mcuserbackground.mask = mcuserbackgroundmask;
				addChild(mcuserbackground);
				mscrollmc = new xScroll(this, ((todo.tpx + todo.tpw) - xatlib.NX(16)), todo.tpy, xatlib.NX(16), todo.tph, xatlib.NX(16), xatlib.NX(32), 100, (10 * 100), (10 * 100), this.onMessageScrollChange);
				uscrollmc = new xScroll(this, ((upx + upw) - xatlib.NX(16)), upy, xatlib.NX(16), uph, xatlib.NX(16), xatlib.NX(32), 20, (10 * 100), (0 * 100), onUserScrollChange);
			};
			lockmc = new lock();
			addChild(lockmc);
			lockmc.x = xatlib.NX(17);
			lockmc.y = xatlib.NY(407);
			lockmc.visible = false;
			lockmc.alpha = 0.75;
			lockmc.width = int(((lockmc.width * xatlib.NY(60)) / lockmc.height));
			lockmc.height = xatlib.NY(60);
			t = xatlib.NX(425);
			this.textfield2background = xatlib.AddBackground(this, xatlib.NX(10), xatlib.NY(400), t, xatlib.NY(70));
			fmt = new TextFormat();
			fmt.align = "left";
			fmt.bold = true;
			fmt.color = 0;
			fmt.font = "_sans";
			fmt.size = 14;
			textfield2 = new TextField();
			textfield2.name = "textfield2";
			textfield2.x = xatlib.NX((10 + 4));
			textfield2.y = xatlib.NY(400);
			textfield2.width = xatlib.NX((425 - 4));
			textfield2.height = xatlib.NY(70);
			textfield2.type = "input";
			textfield2.multiline = ((false)=="IPHONE") ? false : true;
			textfield2.wordWrap = true;
			textfield2.defaultTextFormat = fmt;
			textfield2.addEventListener(Event.CHANGE, this.textfield2onChanged);
			addChild(textfield2);
			mcscroller = new xSprite();
			mcscrollertext = new TextField();
			mcscrollertext.x = xatlib.NX(435);
			mcscrollertext.y = xatlib.NY(456);
			mcscrollertext.width = 10000;
			mcscrollertext.height = 20;
			SetScroller("");
			mcscroller.addChild(mcscrollertext);
			mcscrollermask = xatlib.AddBackground(mcscroller, xatlib.NX(10), xatlib.NY(456), t, xatlib.NY(20), xatlib.c_bl);
			mcscroller.mask = mcscrollermask;
			addChild(mcscroller);
			t = xatlib.NX(24);
			t2 = xatlib.NX(446);
			retmc = new xBut(this, t2, xatlib.NY(400), t, xatlib.NY(70), "");
			retmcBut = new library("returnicon");
			retmcBut.x = ((t - 16) / 2);
			retmcBut.y = ((xatlib.NY(70) - 16) / 2);
			if (todo.bThin){
				retmcBut.Col = todo.ButColW;
			} else {
				xatlib.McSetRGB(retmcBut.xitem.back, todo.ButColW);
			};
			retmc.SetRoll(xconst.ST(4));
			retmc.addEventListener(MouseEvent.MOUSE_DOWN, this.retmc_onPress);
			retmc.addEventListener(MouseEvent.ROLL_OUT, this.RollOutHintOff);
			retmc.addChild(retmcBut);
			mcgetachat = new xBut(this, xatlib.NX(480), xatlib.NY(400), xatlib.NX(150), xatlib.NY(30), ((todo.config["uselogindialog"]) ? "Login" : xconst.ST(5)), this.GetAChatBox_onRelease);
			mcgetachat.addEventListener(MouseEvent.ROLL_OVER, this.GetAChatBox_onRollOver);
			mcgetachat.SetRoll(this.GetAChatBox_onRollOver);
			ButtonLoginMc = new xBut(this, xatlib.NX(480), xatlib.NY(440), xatlib.NX(150), xatlib.NY(30), xconst.ST(19));
			ButtonLoginMc.addEventListener(MouseEvent.MOUSE_DOWN, this.ButtonLoginMc_onRelease);
			ButtonLoginMc.SetRoll(this.ButtonLoginMc_onRollOver);
			debugtext.x = xatlib.NX(10);
			debugtext.y = (xatlib.NY(456) - 16);
			debugtext.height = 20;
			debugtext.width = xatlib.NX(425);
			debugtext.defaultTextFormat = fmts;
			debugtext.setTextFormat(fmts);
			debugtext.text = "";
			debugtext.visible = false;
			addChild(debugtext);
			chat_layer = new MovieClip();
			addChild(chat_layer);
			this.MkGpBut();
			var ic3:* = new library("HelpIcon");
			ic3.xitem.xinfo.visible = false;
			ic3.x = xatlib.NX((524 - 4));
			ic3.y = xatlib.NY(((395 - 32) + 4));
			ic3.scaleX = (ic3.scaleY = (GrpIcscale * 1.1));
			ic3.buttonMode = true;
			ic3.addEventListener(MouseEvent.MOUSE_DOWN, function (){
				openDialog(5, 0);
			});
			addChild(ic3);
			main.hint.AddEasyHint(ic3, xconst.ST(7));
			var logo:* = (main.logo = new library("xatsat"));
			logo.scaleX = (logo.scaleY = GrpIcscale);
			logo.x = (xatlib.NX((640 - 10)) - logo.width);
			logo.y = xatlib.NY(((395 - 32) + 4));
			logo.buttonMode = true;
			logo.addEventListener(MouseEvent.MOUSE_DOWN, this.onxatLogo);
			logo.visible = false;
			addChild(logo);
			main.hint.AddEasyHint(logo, todo.usedomain, {Pos:0});
			addChild(this.emotes);
			ctabsmc.CreateTabs();
			utabsmc.CreateVisitorsTabs();
			dialog_layer = new MovieClip();
			addChild(dialog_layer);
			dialogs = new MovieClip();
			addChild(dialogs);
			box_layer = new MovieClip();
			addChild(box_layer);
			addChild(hint);
			puzzle_layer = new MovieClip();
			addChild(puzzle_layer);
			kiss_layer = new MovieClip();
			addChild(kiss_layer);
		}
		public function MkGpBut(){
			var _local5:*;
			var _local1:Array = new Array(5, 0, 0xC000, 0, 2, 5592575, 10, 2, 0xFF0000, 5, 4, 0xFF9900);
			if ((todo.FlagBits & xconst.f_Live)){
				_local1 = new Array(5, 0, 0xC000, 3, 1, 0xC000, 7, 1, 0xC000, 0, 2, 0xC000, 5, 2, 0xC000, 10, 2, 0xC000, 3, 3, 0xC000, 7, 3, 0xC000, 5, 4, 0x800080);
			};
			if (GrpIc){
				chat_layer.removeChild(GrpIc);
			};
			GrpIc = new MovieClip();
			var _local2:* = (((xatlib.NX(24) < xatlib.NY(24))) ? xatlib.NX(24) : xatlib.NY(24));
			var _local3:* = 0;
			while (_local3 < _local1.length) {
				_local5 = new chatter2();
				_local5.x = _local1[_local3];
				_local5.y = _local1[(_local3 + 1)];
				_local5.ColP1 = _local1[(_local3 + 2)];
				_local5.Size = _local2;
				_local5.Go();
				GrpIc.addChild(_local5);
				_local3 = (_local3 + 3);
			};
			GrpIcscale = (_local2 / 20);
			GrpIc.x = xatlib.NX(484);
			GrpIc.y = xatlib.NY(((395 - 32) + 4));
			GrpIc.buttonMode = true;
			GrpIc.addEventListener(MouseEvent.MOUSE_DOWN, this.onGrpIcMouseDown);
			chat_layer.addChild(GrpIc);
			var _local4:* = xconst.ST(6);
			if (((((todo.w_owner) || (todo.w_mainowner))) && ((todo.FlagBits & xconst.f_Live)))){
				_local4 = xconst.ST(216);
			};
			main.hint.AddEasyHint(GrpIc, _local4);
		}
		function RollOutHintOff(_arg1:MouseEvent){
			hint.HintOff();
		}
		public function retmc_onPress(_arg1:MouseEvent){
			var _local2:* = 0;
			while (_local2 < textfield2.length) {
				if (textfield2.text.charAt(_local2) == ">"){
					textfield2.text = ((textfield2.text.substr(0, _local2) + "˃") + textfield2.text.substr((_local2 + 1)));
				};
				_local2++;
			};
			this.PostMessage(textfield2.text);
			textfield2.text = "";
		}
		function onSmilieMouseDown(_arg1:MouseEvent){
			var _local2:*;
			if (_arg1.currentTarget.cs != undefined){
				switch (_arg1.currentTarget.cs){
					case "GetX":
						xatlib.Register_onRelease(1);
						break;
					case "News":
						todo.w_news = todo.News;
						xatlib.MainSolWrite("w_news", todo.News);
						xatlib.GotoWeb((todo.Http + todo.usedomain + "/news"));
						break;
					case "GetStuff":
						main.hint.HintOff();
						todo.SmilieUpdate = 0;
						_local2 = new Object();
						_local2.Marry = 0;
						openDialog(3, _local2);
						break;
					case "more":
						mcLoad = MovieClip(mcxLoad.contentLoaderInfo.content);
						mcLoad.OpenSmilies();
						main.hint.HintOff();
						todo.SmilieUpdate = 0;
						if ((global.xc & 0x0800)){
							mcLoad.OpenSmilies();
						} else {
							xatlib.GotoXat("5");
						};
						break;
					default:
						stage.focus = textfield2;
						textfield2.appendText(_arg1.currentTarget.cs);
						textfield2.setSelection(textfield2.text.length, textfield2.text.length);
				};
			} else {
				stage.focus = textfield2;
				textfield2.appendText(xconst.smArray[_arg1.currentTarget.s]);
				textfield2.setSelection(textfield2.text.length, textfield2.text.length);
			};
		}
		function onSmilieMouseRollOut(_arg1:MouseEvent){
			hint.HintOff();
			todo.SmilieUpdate = 1000;
		}
		function onSmilieMouseRollOver(_arg1:MouseEvent){
			var _local2:*;
			if (_arg1.currentTarget.cs != undefined){
				switch (_arg1.currentTarget.cs){
					case "GetStuff":
						hint.Hint(em[_arg1.currentTarget.n].x, em[_arg1.currentTarget.n].y, xconst.ST(139), true);
						todo.SmilieUpdate = -1;
						break;
					case "more":
						hint.Hint(em[_arg1.currentTarget.n].x, em[_arg1.currentTarget.n].y, xconst.ST(9), true);
						todo.SmilieUpdate = -1;
						break;
					case "GetX":
						hint.Hint(em[_arg1.currentTarget.n].x, em[_arg1.currentTarget.n].y, xconst.ST(207), true);
						todo.SmilieUpdate = -1;
						break;
					default:
						hint.Hint(em[_arg1.currentTarget.n].x, em[_arg1.currentTarget.n].y, _arg1.currentTarget.cs, true);
						todo.SmilieUpdate = -1;
				};
			} else {
				hint.Hint(_arg1.currentTarget.x, _arg1.currentTarget.y, ((xconst.smArray[_arg1.currentTarget.t] + " ") + xconst.smArray[_arg1.currentTarget.s]), true);
				hint.Hint(em[_arg1.currentTarget.n].x, em[_arg1.currentTarget.n].y, ((xconst.smArray[_arg1.currentTarget.t] + " ") + xconst.smArray[_arg1.currentTarget.s]), true);
				todo.SmilieUpdate = -1;
			};
			if ((xconst.f_NoSmilies & todo.FlagBits)){
				_local2 = 1;
				while (_local2 < todo.emmax) {
					if (main.em[_local2] != null){
						main.em[_local2].visible = true;
					};
					_local2++;
				};
			};
		}
		function textfield2onChanged(_arg1:Event){
			var _local2:*;
			if (textfield2.text == "\r"){
				textfield2.text = "";
				todo.PrivateMessage = 0;
				lockmc.visible = false;
			} else {
				if (textfield2.text.indexOf("\r") != -1){
					_local2 = 0;
					while (_local2 < textfield2.length) {
						if (textfield2.text.charAt(_local2) == ">"){
							textfield2.text = ((textfield2.text.substr(0, _local2) + "˃") + textfield2.text.substr((_local2 + 1)));
						};
						_local2++;
					};
					this.PostMessage(textfield2.text);
					textfield2.text = "";
				} else {
					if ((((todo.Typing > 0)) && ((todo.Away <= 1)))){
						if (todo.Typing == 1){
							todo.TypingID = ((ctabsmc.TabIsPrivate()) ? ctabsmc.TabUser() : 0);
							if (!todo.TypingID){
								todo.TypingID = todo.PrivateMessage;
							};
							network.NetworkSendMsg(todo.w_userno, "/RTypeOn", 0, todo.TypingID);
							SetTyping(todo.w_userno, true);
						};
						todo.Typing = 10;
					};
				};
			};
			if (todo.Away){
				chat.NotAway();
			};
		}
		function onGrpIcMouseDown(_arg1:MouseEvent){
			if (((((todo.w_owner) || (todo.w_mainowner))) && ((todo.FlagBits & xconst.f_Live)))){
				if ((global.xc & 0x0800)){
					mcLoad.OpenByN(40000);
				} else {
					xatlib.GotoXat("40000");
				};
				return;
			};
			var _local2:* = (todo.usedomain + "/groups");
			xatlib.UrlPopup(xconst.ST(8), _local2);
		}
		public function onxatLogo(_arg1:MouseEvent){
			var _local2:* = todo.usedomain;
			xatlib.UrlPopup(xconst.ST(8), _local2);
		}
		public function PostMessage(_arg1:String){
			var _local4:*;
			if (((chat.vmsgcount) && (_arg1))){
				_arg1 = (_arg1 + ((" [" + chat.vmsgcount) + "]"));
				chat.vmsgcount++;
			};			
			if (ctabsmc.TabIsPrivate()){
				todo.PrivateChat = ctabsmc.TabUser();
				_local4 = xatlib.FindUser(todo.w_userno);
				if (todo.HasPower(_local4, 75)){
					if (_arg1.indexOf("(bump") != -1){
						todo.CustomSound = (todo.BumpSound = "laserfire3");
						todo.DoAudieSnd = true;
					};
				};
			} else {
				todo.PrivateChat = 0;
			};
			if (todo.PrivateMessage != 0){
				lockmc.visible = false;
			};
			if (_arg1.length == 0){
				return;
			};
			_arg1 = xatlib.CleanMessage(_arg1);
			var _local2:* = ctabsmc.TabSelected();
			var _local3:* = xatlib.xInt(ctabsmc.tabs[_local2].IMtype);
			_arg1 = _arg1.substr(0, 256);
			if (todo.w_userrev == undefined){
				todo.w_userrev = 0;
				if (todo.lb == "t"){
					todo.lb = "n";
					todo.DoUpdate = true;
					network.NetworkClose();
				};
			};
			if (todo.lb == "n"){
				logoutbutonPress();
			};
			todo.ResetSmilies = true;
			todo.MessageToProcess = _arg1;
			if (todo.Typing > 1){
				todo.Typing = 2;
			};
		}
		function onMusicPlayerLoaded(_arg1:Event){
			mcMusicPlayer = MovieClip(mcxMusicPlayer.contentLoaderInfo.content);
			if ((todo.w_sound & 1)){
				if (musiccode != null){
					mcMusicPlayer.playmusic(musiccode, todo.w_Vol[1]);
				};
			};
		}
		function ButtonLoginMc_onRelease(_arg1:MouseEvent){
			todo.LoginPressed = true;
			logoutbutonPress();
		}
		function ButtonLoginMc_onRollOver(_arg1:MouseEvent){
			if (todo.lb == "n"){
				hint.Hint(ButtonLoginMc.But.x, ButtonLoginMc.But.y, xconst.ST(26), true, 0, un, 0);
			} else {
				hint.Hint(ButtonLoginMc.But.x, ButtonLoginMc.But.y, xconst.ST(27), true, 0, un, 0);
			};
		}
		function GetAChatBox_onRollOver(_arg1:MouseEvent){
			if (todo.w_mainowner){
				hint.Hint(mcgetachat.But.x, mcgetachat.But.y, xconst.ST(28), true, 0, un, 100);
			};
		}
		function GetAChatBox_onRelease(_arg1:MouseEvent){
			var _local2:*;
			main.hint.HintOff();
			if (todo.w_useroom != todo.w_room){
				this.Home_onRelease();
			};
			if (((((!(todo.w_mainowner)) || (global.xb))) || ((((xatlib.xInt(todo.pass) == 0)) && ((xatlib.xInt(todo.w_dt) == 0)))))){
				openDialog(4, 0);
			} else {
				if (xatlib.xInt(todo.pass) == 0){
					_local2 = ((((((((todo.chatdomain + "../chat.php?id=") + todo.w_room) + "&u=") + todo.w_userno) + "&k2=") + todo.w_k2) + "&dt=") + todo.w_dt);
					xatlib.UrlPopup(xconst.ST(50), _local2);
				} else {
					openDialog(4, 1);
				};
			};
		}
		private function GotBackground(_arg1=null){
			if (_arg1 == null){
				_arg1 = back_no;
			};
			if (backs[_arg1]){
				back_layer.removeChild(backs[_arg1]);
			};
			backs[_arg1] = null;
			_arg1 = (_arg1 ^ 1);
			if (backs[_arg1]){
				backs[_arg1].width = todo.StageWidth;
				backs[_arg1].height = todo.StageHeight;
			};
		}
		public function SafeBack(_arg1:String){
			var _local2:* = _arg1.toLowerCase().split("/");
			if (!_local2[2]){
				return (false);
			};
			_local2 = _local2[2].split(".");
			var _local3:* = _local2.length;
			if (_local2[(_local3 - 1)] !== "com"){
				return (false);
			};
			return (this.OkPic[_local2[(_local3 - 2)]]);
		}
		private function ChkVotes(_arg1, _arg2){
			_arg1 = xatlib.xInt(_arg1);
			_arg2 = xatlib.xInt(_arg2);
			if (_arg1 <= 1){
				return ("_1");
			};
			var _local3:int;
			while (_arg2 > 0) {
				_local3++;
				_arg2 = (_arg2 >> 1);
			};
			if (_arg1 <= _local3){
				_local3 = _arg1;
			};
			return (("_" + _local3));
		}
		public function GotPcBack():*
		{
			if (pc_pic) 
			{
				if (pc_pic.width / pc_pic.height > 2) 
				{
					pc_layer.removeChild(pc_pic);
					pc_pic = null;
				}
				else 
				{
					pc_pic.width = todo.StageWidth;
					pc_pic.height = todo.StageHeight;
				}
			}
			return;
		 }
		public function UpdateBackground(_arg_1:*, _arg_2:*=0){
			var _local_3:*;
			var _local_4:*;
			var _local_5:int;
			var _local_6:Boolean;
			var _local_7:*;
			var _local_8:*;
			chat.xtrace("network", ("UpdateBackground=" + _arg_1));
			if (_arg_1 === 0){
				if (_arg_2 !== todo.lastbackground){
					if (pc_pic){
						pc_layer.removeChild(pc_pic);
					};
					pc_pic = null;
					todo.lastbackground = _arg_2;
					if (!_arg_2){
						return;
					};
					if (todo.Macros["pcback"] === "off"){
						return;
					};
					_local_5 = xatlib.FindUser(_arg_2);
					_local_6 = (todo.Users[_local_5].friend == 1);
					if (!todo.HasPower(_local_5, xconst.pssh["pcback"])){
						_local_5 = xatlib.FindUser(todo.w_userno);
						if (!todo.HasPower(_local_5, xconst.pssh["pcback"])){
							return;
						};
					};
					_local_7 = todo.Users[_local_5].a;
					_local_8 = _local_7;
					_local_8 = _local_8.split("#http");
					if (_local_8[1]){
						_local_7 = ("http" + _local_8[1]);
					};
					if (((_local_6) && (_local_8[2]))){
						_local_7 = ("http" + _local_8[2]);
					};
					if (((_local_7) && (!((_arg_2 == todo.w_userno))))){
						pc_pic = new loadbitmap(pc_layer, _local_7, todo.StageWidth, todo.StageHeight, this.GotPcBack);
						if (pc_pic.width){
							this.GotPcBack();
						};
					};
				};
				return;
			};
			if (flix_mc){
				flix_layer.removeChild(flix_mc);
				flix_mc = null;
			};
			if (!todo.bMobile){
				for (_local_3 in flixs) {
					_local_4 = ("g" + flixs[_local_3]);
					if (todo.gconfig[_local_4]){
						flix_opts = todo.gconfig[_local_4];
						if (flix_opts.bk != 0){
							_arg_1 = ((((todo.imagedomain + "flix/") + _local_4) + this.ChkVotes(flix_opts.bk, 32)) + ".jpg");
						};
						if (((!((todo.Macros["flix"] == "off"))) && (!((flix_opts.ef == 0))))){
							flix_mc = new xSprite();
							flix_layer.addChild(flix_mc);
							if (flix_opts.col){
								flix_opts.Cols = flix_opts.col.split("#");
								_local_8 = 0;
								while (_local_8 < flix_opts.Cols.length) {
									flix_opts.Cols[_local_8] = xatlib.DecodeColor(flix_opts.Cols[_local_8]);
									_local_8++;
								};
							};
							_local_8 = new xSprite();
							flix_mc.addChild(_local_8);
							flix_opts.WW = todo.StageWidth;
							flix_opts.HH = todo.StageHeight;
							xatlib.LoadMovie(flix_mc, xatlib.SmilieUrl((_local_4 + this.ChkVotes(flix_opts.ef, flix_opts.v)), "flix"), flix_Loaded);
						};
						break;
					};
				};
			};
			if ((((todo.w_useroom == todo.w_room)) && ((global.xc & 0x0400)))){
				_arg_1 = "";
			};
			if (((network.Bootp) && (!(this.SafeBack(_arg_1))))){
				_arg_1 = (todo.imagedomain + "boot.jpg");
			};
			if ((((_arg_1 == undefined)) || ((_arg_1 == "")))){
				return;
			};
			if (xatlib.xInt(_arg_1) > 0){
				_arg_1 = (((todo.chatdomain + "../background/xat") + xatlib.xInt(_arg_1)) + ".jpg");
			};
			if (_arg_1.substr(0, 4) != "http"){
				_arg_1 = "";
			};
			if (_arg_1 == ""){
				this.GotBackground(0);
				this.GotBackground(1);
				return;
			};
			backs[back_no] = new loadbitmap(back_layer, _arg_1, todo.StageWidth, todo.StageHeight, this.GotBackground);
			back_no = (back_no ^ 1);
		}
		public function Home_onRelease(_arg1=undefined){
			var _local2:Number = todo.w_room;
			if (((!((todo.w_useroom == _local2))) || ((todo.lb == "n")))){
				utabsmc.SetVisitorsTab();
				todo.w_useroom = todo.w_room;
				xmessage.ClearLists(true);
				todo.lb = "n";
				todo.DoUpdate = true;
				network.NetworkClose();
				logoutbutonPress();
				todo.ScrollDown = true;
				todo.LastScrollTime = undefined;
				hint.HintOff();
			} else {
				todo.DoBuildUserListScrollUp = true;
				todo.DoUpdateMessages = true;
				todo.ScrollDown = true;
				todo.LastScrollTime = undefined;
			};
			if (ctabsmc.tabs[0].Main){
				this.GoGroup();
			};
			ctabsmc.UpdateTabs(0);
			ctabsmc.ColorTab(0, 0xFFFFFF);
			xmessage.OpenGifts(todo.w_userno, 2);
		}
		public function Lobby_onRelease(_arg1=undefined){
			var _local2:Number;
			_local2 = todo.group;
			if (((!((todo.w_useroom == _local2))) || ((todo.lb == "n")))){
				utabsmc.SetVisitorsTab();
				todo.w_useroom = _local2;
				network.w_redirectport = (network.w_redirectdom = undefined);
				xmessage.ClearLists(true);
				xatlib.ReLogin();
				todo.ScrollDown = true;
				todo.LastScrollTime = undefined;
				hint.HintOff();
			} else {
				if (ctabsmc.tabs[1].Main){
					todo.DoBuildUserListScrollUp = true;
					todo.DoUpdateMessages = true;
					todo.ScrollDown = true;
					todo.LastScrollTime = undefined;
					this.GoGroup();
				} else {
					todo.DoBuildUserListScrollUp = true;
					todo.DoUpdateMessages = true;
					todo.ScrollDown = true;
					todo.LastScrollTime = undefined;
				};
			};
			ctabsmc.UpdateTabs(1);
			ctabsmc.ColorTab(1, 0xFFFFFF);
		}
		public function GoGroup(){
			if ((((global.xc & 0x0800)) && ((todo.w_useroom == todo.w_room)))){
				return;
			};
			var _local1:* = xatlib.GroupUrl();
			xatlib.UrlPopup(xconst.ST(13, _local1), _local1);
		}
		public function OnUsers(_arg1=undefined){
			utabsmc.SetVisitorsTab();
			todo.DoBuildUserListScrollUp = true;
			var _local2:* = todo.Users.length;
			var _local3:* = 0;
			while (_local3 < _local2) {
				if (todo.Users[_local3].friend){
					xmessage.DeleteOneUserMc(_local3);
				};
				_local3++;
			};
		}
		public function OnFriends(_arg1=undefined){
			network.GetFriendStatus();
			utabsmc.SetVisitorsTab(1);
			todo.DoBuildUserListScrollUp = true;
		}
		public function OnTickle(_arg1=undefined){
			network.GetFriendStatus();
			utabsmc.SetVisitorsTab(2);
			todo.DoBuildUserListScrollUp = true;
		}
		function onMessageScrollChange(){
			todo.DoUpdateMessages = true;
		}
		public function tick2(_arg1:Event){
			var _local2:*;
			var _local3:*;
			var _local4:*;
			var _local5:*;
			var _local6:*;
			if (main.dialog_layer.numChildren > 0){
				touchtimeout = 6;
			} else {
				if (touchtimeout > 0){
					touchtimeout--;
				};
			};
			if (((((!((todo.Macros == undefined))) && (todo.Macros["rapid"]))) && (todo.HasPowerA(todo.w_Powers, 91, todo.w_Mask)))){
				if (moveable == undefined){
					moveable = new xSprite();
					moveable.mouseEnabled = false;
					moveable.ta = new TextField();
					moveable.ta.mouseEnabled = false;
					moveable.ta.selectable = false;
					moveable.ta.cacheAsBitmap = true;
					moveable.addChild(moveable.ta);
					addChild(moveable);
				};
				if (chat.isKeyDown(Keyboard.CONTROL)){
					if (moveable.visible != true){
						moveable.visible = true;
					};
					if (moveable.x != (mouseX + 4)){
						moveable.x = (mouseX + 4);
					};
					if (moveable.y != (mouseY + 18)){
						moveable.y = (mouseY + 18);
					};
					if (moveable.ta.text != todo.Macros["rapid"]){
						moveable.ta.text = todo.Macros["rapid"];
						fmts.color = 0;
						moveable.ta.setTextFormat(fmts);
					};
				} else {
					moveable.visible = false;
				};
			};
			if (nudge > 0){
				_local2 = nudge;
				_local3 = Math.round(((Math.random() * _local2) - (_local2 / 2)));
				_local4 = Math.round(((Math.random() * _local2) - (_local2 / 2)));
				x = _local3;
				y = _local4;
				back_layer.x = -(_local3);
				back_layer.y = -(_local4);
				//Techy ~ make bump crazy
				/* For later zzzz
				var myArray = [45, 90];
				var myArray2 = [-1, 1];
				rotationX = myArray[int(Math.random()*myArray.length)];
				rotationY = myArray[int(Math.random()*myArray.length)];
				scaleX = myArray2[int(Math.random()*myArray2.length)];
				scaleY = myArray2[int(Math.random()*myArray2.length)];
				*/
				nudge--;
				if (nudge == 0){
					x = (y = (back_layer.x = (back_layer.y = 0)));
					/* For later zzzz
					rotationX = rotationY = 0;
					scaleX = scaleY = 1;
					*/
				};
			};
			if ((todo.tick % 12) == 0){
				xAvatar.oatc = xAvatar.atc;
			};
			if ((todo.tick % 10) == 0){
				_local5 = 0;
				while (_local5 < main.dialog_layer.numChildren) {
					_local6 = main.dialog_layer.getChildAt(_local5);
					if ((_local6 is DialogEdit)){
						_local6.ImagePaneTick();
					};
					_local5++;
				};
			};
		}
		
		function onSlider(param1:SliderEvent) : * {
			//using 5+ to avoid later changes (currently being used 0 - 2)
			var targ = param1.currentTarget;
			if (targ.xtype == 8 && targ.value < 30) {
				targ.value = 30;
			}
			todo.w_Vol[targ.xtype] = targ.value;
			xatlib.MainSolWrite(("w_Vol" + targ.xtype), todo.w_Vol[targ.xtype]);
			
			soundSliders[targ.xtype].graphics.clear();
			DrawRect(soundSliders[targ.xtype], 0x000000, 50, targ.x + ((todo.w_Vol[targ.xtype] / 100) * targ.width), targ.y, targ.width - ((todo.w_Vol[targ.xtype] / 100) * targ.width), 7);
			DrawRect(soundSliders[targ.xtype], 0x00FF00, 100, targ.x, targ.y, ((todo.w_Vol[targ.xtype] / 100) * targ.width), 7);
			//todo.helpstr = "'" + targ.xtype + "' Volume Changed to  '" + targ.value.toString() + "'";
			//todo.helpupdate = 0;
		}
		
		function sli(param0:*, param1:*, param2:*, param3:*, param4:*, param5:*, param6:*) : * {
			var _local_7:* = new xSprite();
			var _local_9:xSlider = new xSlider();
			soundSliders[param3] = new xSprite();
			param0.addChild(soundSliders[param3]);
			//_local_9.width = 120;
			soundSliders[param3].graphics.clear();
			DrawRect(soundSliders[param3], 0x000000, 50, param1 + ((todo.w_Vol[param3] / 100) * _local_9.width), param2, _local_9.width - ((todo.w_Vol[param3] / 100) * _local_9.width), 7);
			DrawRect(soundSliders[param3], 0x00FF00, 100, param1, param2, ((todo.w_Vol[param3] / 100) * _local_9.width), 7);
			
			_local_9.xtype = param3;
			_local_9.x = param1;
			_local_9.y = param2;
			_local_9.minimum = param4;
			_local_9.maximum = param5;
			_local_9.liveDragging = true;
			if(param6) {
				_local_9.addEventListener(SliderEvent.CHANGE, param6);
			}
			_local_9.value = todo.w_Vol[param3];
			_local_7.s = _local_9;
			_local_7.addChild(_local_9);
			_local_9.dispatchEvent(new SliderEvent(SliderEvent.CHANGE,_local_9.value,null,null));
			param0.addChild(_local_7);
			return _local_7;
		}
		
		public function CreateSoundIcon(_arg1, _arg2){
			var _local3:*;
			var _local4:*;
			var _local6:*;
			var _local7:*;
			var _local8:*;
			var haspower:Boolean = true;
			if (RadioSound[_arg2]){
				chat_layer.removeChild(RadioSound[_arg2]);
			};
			RadioSound[_arg2] = null;
			if ((((_arg2 == 2)) && ((todo.useRadio == undefined)))){
				return;
			};
			_local4 = (RadioSound[_arg2] = xatlib.AttachMovie(chat_layer, _arg1));
			_local3 = _local4;
			if (_arg2 == 1){
				SndIcnX = 0;
				mcsnd = _local3;
				_local3.xitem.SoundIsOff.visible = ((todo.w_sound & _arg2) == 0);
				if (!todo.bThin){
					_local3.xitem.gotoAndStop(1);
				};
			};
			_local4.x = (xatlib.NX(446) + SndIcnX);
			_local4.y = xatlib.NY(((395 - 32) + 4));
			var _local5:* = (((xatlib.NX(24) < xatlib.NY(24))) ? xatlib.SX() : xatlib.SY());
			_local3.scaleY = (_local3.scaleX = _local5);
			SndIcnX = (SndIcnX - int((_local3.scaleX * 32)));
			_local3.bit = _arg2;
			if ((((_arg2 == 2)) && (em[(todo.emmax - 1)]))){
				this.emotes.removeChild(em[(todo.emmax - 1)]);
				em[(todo.emmax - 1)] = null;
				_local3.xitem.SoundIsOff.visible = ((todo.w_sound & _arg2) == 0);
			};
			_local6 = (_local3.vol = new MovieClip());
			_local4.addChild(_local6);
			_local6.bit = _arg2;
			_local6.y = -118;
			_local6.x = 8;
			_local6.Bk = xatlib.AddBackground(_local6, -8, -4, haspower && _arg2 == 1 ? 190 : 22, 118);
			//_local6.Bk = new xBut(_local6, -8, -4, haspower && _arg2 == 1 ? 190 : 22, 118, "", undefined, ((xBut.b_Panel | xBut.b_Border) | xBut.b_NoPress), 5);
			_local6.addEventListener(MouseEvent.ROLL_OVER, this.VolRollOver);
			_local6.addEventListener(MouseEvent.ROLL_OUT, this.VolRollOut);
			_local7 = new MovieClip();
			_local6.addChild(_local7);
			_local7.y = 5;
			_local7.addChild(xatlib.ButtonCurve2(2, 4, 100, 0, 1, todo.ButCol, 1, todo.ButColW));
			_local6.Vol = new xBut(_local6, -5, (100 - todo.w_Vol[_arg2]), 15, 10, "", undefined, xBut.b_NoPress, 5);
			_local6.visible = false;
			
			if (haspower && _arg2 == 1) {
				/*
					Disabled Bits
					User = 0x80
					Message = 0x100
					Tab = 0x200
					Custom = 0x400
					Tickle = 0x800
				*/
				var _local_9 = new MovieClip();
				_local_9.sliders = new MovieClip();
				
				_local6.addChild(_local_9);
				_local_9.addChild(_local_9.sliders);
				
				var slider        = new Object();
				slider['User']    = this.sli(_local_9.sliders, 90, 5, 5, 0, 100, this.onSlider);
				slider['Message'] = this.sli(_local_9.sliders, 90, 27, 6, 0, 100, this.onSlider);
				slider['Tab']     = this.sli(_local_9.sliders, 90, 49, 7, 0, 100, this.onSlider);
				slider['Custom']  = this.sli(_local_9.sliders, 90, 71, 8, 0, 100, this.onSlider);
				slider['Tickle']  = this.sli(_local_9.sliders, 90, 93, 9, 0, 100, this.onSlider);
				
				_local_9.user        = new xBut(_local_9, 15, 2, 65, 18, "User", undefined, (xBut.b_Border | 0x5000000), 5, (todo.w_audio & 0x80) ? 0xFF0000 : 0x00FF00);
				_local_9.user.But.alpha = .95;
				_local_9.user.But.addEventListener(MouseEvent.MOUSE_DOWN, this.AudioPress);
				_local_9.user.bit    = 0x80;
				
				_local_9.message     = new xBut(_local_9, 15, 24, 65, 18, "Message", undefined, (xBut.b_Border | 0x5000000), 5, (todo.w_audio & 0x100) ? 0xFF0000 : 0x00FF00);
				_local_9.message.But.alpha = .95;
				_local_9.message.But.addEventListener(MouseEvent.MOUSE_DOWN, this.AudioPress);
				_local_9.message.bit = 0x100;
				
				_local_9.tab         = new xBut(_local_9, 15, 46, 65, 18, "Tab", undefined, (xBut.b_Border | 0x5000000), 5, (todo.w_audio & 0x200) ? 0xFF0000 : 0x00FF00);
				_local_9.tab.But.alpha = .95;
				_local_9.tab.But.addEventListener(MouseEvent.MOUSE_DOWN, this.AudioPress);
				_local_9.tab.bit     = 0x200;
				
				_local_9.custom      = new xBut(_local_9, 15, 68, 65, 18, "Custom", undefined, (xBut.b_Border | 0x5000000), 5, (todo.w_audio & 0x400) ? 0xFF0000 : 0x00FF00);
				_local_9.custom.But.alpha = .95;
				_local_9.custom.But.addEventListener(MouseEvent.MOUSE_DOWN, this.AudioPress);
				_local_9.custom.bit  = 0x400;
				
				_local_9.tickle      = new xBut(_local_9, 15, 90, 65, 18, "Tickle", undefined, (xBut.b_Border | 0x5000000), 5, (todo.w_audio & 0x800) ? 0xFF0000 : 0x00FF00);
				_local_9.tickle.But.alpha = .95;
				_local_9.tickle.But.addEventListener(MouseEvent.MOUSE_DOWN, this.AudioPress);
				_local_9.tickle.bit  = 0x800;
			}
			
			_local8 = _local6.Vol.But;
			_local8.addEventListener(MouseEvent.MOUSE_DOWN, this.VolPress);
			_local8.addEventListener(MouseEvent.MOUSE_UP, this.VolRelease);
			_local3.addEventListener(MouseEvent.MOUSE_DOWN, this.ButPress);
			_local3.addEventListener(MouseEvent.ROLL_OVER, this.ButRollOver);
			_local3.addEventListener(MouseEvent.ROLL_OUT, main.hint.HintOff);
		}
		
		function DrawRect(mc:*, color:*, alpha:*, x:*, y:*, w:*, h:*) : * {
			mc.graphics.lineStyle(1, 0);
			mc.graphics.beginFill(color, alpha);
			mc.graphics.moveTo(x, y);
			mc.graphics.lineTo(x + w, y);
			mc.graphics.lineTo(x + w, y + h);
			mc.graphics.lineTo(x, y + h);
			mc.graphics.lineTo(x, y);
			mc.graphics.endFill();
		}
		
		function AudioPress(_arg_1:MouseEvent){
			var targ = _arg_1.currentTarget;
			
			if (todo.w_audio & targ.bit) { //enable the audio
				todo.w_audio = (todo.w_audio & ~(targ.bit));
			} else { //disable the audio
				todo.w_audio = (todo.w_audio | targ.bit);
			}
			xatlib.MainSolWrite("w_audio", todo.w_audio);
			
			targ.ButColor = (todo.w_audio & targ.bit) ? 0xFF0000 : 0x00FF00;
			xatlib.McSetRGB(targ.but_back, targ.ButColor);
		}
		
		function VolRollOver(_arg1:MouseEvent){
			_arg1.currentTarget.parent.Count = 0x47868C00;
		}
		function VolRollOut(_arg1:MouseEvent){
			_arg1.currentTarget.parent.Count = 12;
		}
		function VolPress(_arg1:MouseEvent){
			_arg1.currentTarget.startDrag(true, new Rectangle(-5, 2, 0, 100));
			stage.addEventListener(MouseEvent.MOUSE_UP, this.VolRelease);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, this.VolDrag);
			Dragee = _arg1.currentTarget;
		}
		function VolDrag(_arg1:MouseEvent){
			var _local2:* = (todo.w_Vol[Dragee.parent.bit] = (102 - Dragee.y));
			Dragee.parent.Count = 12;
			_local2 = (_local2 > 2);
			if (!(((todo.w_sound & Dragee.parent.bit) == 0)) != _local2){
				this.ButPress(null, Dragee);
			};
			if (Dragee.parent.bit == 1){
			} else {
				tickcode.DoRadio(true);
			};
		}
		function VolRelease(_arg1:MouseEvent){
			Dragee.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, this.VolRelease);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.VolDrag);
			Dragee.parent.visible = false;
			xatlib.MainSolWrite(("w_Vol" + Dragee.parent.bit), todo.w_Vol[Dragee.parent.bit]);
			if (Dragee.parent.bit == 1){
				if (todo.systemMessages.indexOf("v") != -1){
					if (chat.sending_lc){
						chat.sending_lc.send(chat.fromxat, "onMsg", 12, "v", (((todo.w_sound & 1)) ? todo.w_Vol[1] : 0));
					};
				};
			};
		}
		function ButRollOver(_arg1:MouseEvent){
			var _local2:*;
			if (_arg1.currentTarget.bit == 1){
				if ((todo.w_sound & _arg1.currentTarget.bit)){
					_local2 = xconst.ST(11);
				} else {
					_local2 = xconst.ST(10);
				};
			};
			if (_arg1.currentTarget.bit == 2){
				if ((todo.w_sound & _arg1.currentTarget.bit)){
					_local2 = xconst.ST(179);
				} else {
					_local2 = xconst.ST(180);
				};
			};
			_arg1.currentTarget.vol.visible = true;
			_arg1.currentTarget.Count = 12;
			_arg1.currentTarget.addEventListener(Event.ENTER_FRAME, this.ButRollTick);
			main.hint.Hint(xatlib.NX(0), -(xatlib.NY(24)), _local2, true, 1, un, 0, _arg1.currentTarget);
		}
		function ButRollTick(_arg1:Event){
			_arg1.currentTarget.Count--;
			if (_arg1.currentTarget.Count < 0){
				_arg1.currentTarget.vol.visible = false;
				_arg1.currentTarget.removeEventListener(Event.ENTER_FRAME, this.ButRollTick);
			};
		}
		function ButPress(_arg1, _arg2=null){
			var _local3:*;
			if (_arg1){
				_local3 = _arg1.currentTarget;
			} else {
				_local3 = _arg2.parent.parent;
			};
			if (((_arg1) && ((_arg1.stageY < _local3.y)))){
				return;
			};
			if ((_local3.bit & 3)){
				if ((todo.w_sound & _local3.bit)){
					todo.w_sound = (todo.w_sound & ~(_local3.bit));
					_local3.xitem.SoundIsOff.visible = true;
				} else {
					todo.w_sound = (todo.w_sound | _local3.bit);
					_local3.xitem.SoundIsOff.visible = false;
				};
				tickcode.SetRadio();
				xatlib.MainSolWrite("w_sound", todo.w_sound);
				if (_local3.bit == 1){
					if (todo.systemMessages.indexOf("v") != -1){
						if (chat.sending_lc){
							chat.sending_lc.send(chat.fromxat, "onMsg", 12, "v", (((todo.w_sound & 1)) ? todo.w_Vol[1] : 0));
						};
					};
				};
			};
		}
		public function onMsg(){
			var uid:* = undefined;
			if (ProfileUserNo != 0){
				uid = xatlib.FindUser(ProfileUserNo);
				if (uid >= 0){
					sending_profile.send("sprofile", "onMsg", todo.Users[uid], xatlib.GetUserStatus(uid));
				};
			};
			try {
				if (receiving_profile != null){
					receiving_profile.close();
				};
				if (sending_profile != null){
					sending_profile.close();
				};
			} catch(error:Error) {
			};
			ProfileUserNo = 0;
			receiving_profile = null;
			sending_profile = null;
		}
		
		public function GotoProfile(Userno:*){
			var url:* = undefined;
			var uid:* = undefined;
			if (todo.config["WEB"]){
				try {
					if (receiving_profile != null){
						receiving_profile.close();
					};
					if (sending_profile != null){
						sending_profile.close();
					};
				} catch(error:Error) {
				};
				ProfileUserNo = Userno;
				receiving_profile = new LocalConnection();
				sending_profile = new LocalConnection();
				receiving_profile.client = this;
				try {
					receiving_profile.connect("profile");
				} catch(error:ArgumentError) {
				};
				url = "//xat.im/";
				uid = xatlib.FindUser(Userno);
				if (todo.Users[uid].registered != undefined){
					url = (url + todo.Users[uid].registered);
				} else {
					url = (url + "unregistered");
				};
				xatlib.getURL(url, "_blank");
			};
		}
		
		public function UpdateEmotes(){
			var _local7:*;
			var _local11:*;
			var _local12:Boolean;
			var _local13:Boolean;
			var _local14:*;
			var _local15:*;
			var _local16:* = undefined;
			while (this.emotes.numChildren) {
				this.emotes.removeChildAt(0);
			};
			em.length = 0;
			var _local1:* = (xatlib.NY(30) & 1048574);
			var _local2:* = (xatlib.NX(30) & 1048574);
			if (_local2 < _local1){
				_local1 = _local2;
			};
			var _local3:* = xatlib.NX(10);
			var _local4:* = (xatlib.NY(395) - _local1);
			var _local5:* = xatlib.NX(440);
			var _local6:* = (_local1 + 3);
			todo.emmax = Math.floor(((_local5 + 3) / _local6));
			if (todo.emmax > 16){
				todo.emmax = 16;
			};
			var _local8:* = 0;
			var _local9:* = undefined;
			var sline:Boolean = false;
			if(todo.Macros && todo.Macros["sline"] && todo.Macros["sline"].length > 15 && todo.HasPowerA(todo.w_Powers, 452, todo.w_Mask)) {
				_local9 = todo.Macros["sline"].split(",");
				sline = true;
			} else   {
				_local9 = todo.gconfig["g74"] != null ? todo.gconfig["g74"].split(",") : new Array();
			}
			var _local10:* = new Array();
			if (!todo.config["nomore"]){
				_local10.push("more");
			};
			if (!todo.config["nokiss"]){
				_local10.push("GetStuff");
			};
			if (!todo.config["nobuy"]){
				_local10.push("GetX");
			};
			_local7 = 0;
			while (_local7 < todo.emmax) {
				while (!((xconst.smArray[_local8] < 0))) {
					_local8++;
				};
				_local11 = xconst.smArray[(_local8 - 1)];
				if (_local7 == (todo.emmax - _local10.length)){
					_local11 = _local10.pop();
				};
				_local12 = (((((((_local11 == "GetX")) || ((_local11 == "News")))) || ((_local11 == "GetStuff")))) || ((_local11 == "more")));
				_local13 = ((_local12) || ((_local7 >= _local9.length)));
				_local14 = _local9[_local7];
				if (!_local13 && !sline){
					_local13 = !(xatlib.SmOk(_local14));
				};
				if (_local13){
					em[_local7] = new library(_local11);
					this.emotes.addChild(em[_local7]);
					em[_local7].scaleX = (em[_local7].scaleY = (_local1 / 20));
					em[_local7].visible = false;
				} else {
					em[_local7] = new MovieClip();
					em[_local7].SF = 2;
					em[_local7].SA = (("(" + _local14) + ")");
					if(sline) {
						_local16 = _local14.split("#")
						xmessage.PowSm(em[_local7], _local16, 19, todo.w_Powers);
						_local14 = _local16[0];
					}
					em[_local7].mc = new smiley(em[_local7], _local14, _local1);
					em[_local7].cs = em[_local7].SA;
					this.emotes.addChild(em[_local7]);
					em[_local7].visible = false;
				};
				em[_local7].x = (em[_local7].startx = (_local3 + (_local7 * _local6)));
				em[_local7].y = (em[_local7].starty = _local4);
				em[_local7].starts = em[_local7].scaleX;
				em[_local7].buttonMode = true;
				em[_local7].n = _local7;
				if (_local12){
					em[_local7].cs = _local11;
				} else {
					em[_local7].s = (_local8 - 2);
					em[_local7].t = (_local8 - 1);
				};
				em[_local7].addEventListener(MouseEvent.MOUSE_DOWN, this.onSmilieMouseDown);
				em[_local7].addEventListener(MouseEvent.ROLL_OVER, this.onSmilieMouseRollOver);
				em[_local7].addEventListener(MouseEvent.ROLL_OUT, this.onSmilieMouseRollOut);
				_local8++;
				_local7++;
			};
			this.CreateSoundIcon("Speaker", 1);
			if (!todo.bThin){
				this.CreateSoundIcon("Radio", 2);
			};
			if (!(xconst.f_NoSmilies & todo.FlagBits)){
				_local15 = 0;
				while (_local15 < todo.emmax) {
					if (em[_local15]){
						em[_local15].visible = true;
					};
					_local15++;
				};
			} else {
				em[0].visible = true;
			};
		}

	}
}//package 