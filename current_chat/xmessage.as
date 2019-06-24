// Decompiled by AS3 Sorcerer 3.32
// http://www.as3sorcerer.com/

//xmessage

package {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.xml.XMLDocument;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.xml.*;
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.ui.*;
	import flash.external.ExternalInterface;
	import fl.motion.Color;

	public class xmessage extends MovieClip {

		public var OnDialog = false;
		static var mspos = undefined;
		static var SkipSmilies;
		static var yc2;
		public static var xPos;
		public static var ImInit;
		public static var SmB;
		static var Ronce;
		static var useryc: Number = 0;
		static var DeleteNumber: Number;
		public static var useryc2 = 0;
		public static var useryc3 = 0;
		public static var poin = new Array();
		public static var McCnt = 0;
		public static var McTot = 0;
		public static var p;
		public static var NoOfM: int;
		private static var LastUserTab: int;
		public static var Social = {
			tc: 0
		};
		private static var keywords = {
			wiki: "wiki",
			twitter: "twitter",
			facebook:"facebook",
			search: "search",
			power: "powers",
			powers: "powers",
			register: "profile",
			login: "profile",
			relogin: "profile",
			donate: "offers",
			profile: "profile",
			buy: "offers",
			coin: "offers",
			coins: "offers",
			coins: "offers",
			ixats: "offers",
			offers: "offers",
			donate: "donate",
			trade: 2,
			subscriber: "donate",
			support: "support",
			gift: 8,
			xavi: 9,
			doodle: 1,
			supercycle: 10,
			pawns: "pawns",
			hats: "pawns",
			translate: 20034
		};
		private static var FirstC;

		public static function AddGames() {
			var _local1: * ;
			for (_local1 in xconst.Game) {
				keywords[xconst.Game[_local1]] = (60001 + _local1);
			};
		}
		public static function UpdateMessages(All: Boolean, Scrolling: Boolean) {
			var Avatar: * = undefined;
			var UserName: String;
			var DeleteOk: Number;
			var MessageLength: * = undefined;
			var TabIsPrivate: * = undefined;
			var TabUser: * = undefined;
			var HasNick: Boolean;
			var MaxInView: * = undefined;
			var t: * = undefined;
			var Bot: * = undefined;
			var BotMargF: * = undefined;
			var Bot2: * = undefined;
			var v: * = undefined;
			var Cnt: * = undefined;
			var HitTop: * = undefined;
			var n: * = undefined;
			var M: * = undefined;
			var V: * = undefined;
			var v2: * = undefined;
			var userid: * = undefined;
			var yinc: * = undefined;
			var s: * = undefined;
			var yc3: * = undefined;
			try {
				if (Scrolling == undefined) {
					Scrolling = false;
				};
				MessageLength = todo.Message.length;
				TabIsPrivate = main.ctabsmc.TabIsPrivate();
				TabUser = main.ctabsmc.TabUser();
				HasNick = todo.HasPowerA(todo.w_Powers, xconst.pssh["nick"], todo.w_Mask);
				if (((!(Scrolling)) || (!(p)))) {
					p = new Array();
					NoOfM = 0;
					v = 0;
					while (v < MessageLength) {
						M = todo.Message[v];
						if (Scrolling == false) {
							M.New = false;
						};
						if ((((M.New == false)) && (!((M.ignored == true))))) {
							if (TabIsPrivate) {
								if ((((((TabUser == M.u)) || ((todo.w_userno == M.u)))) && ((M.d == TabUser)))) {
									NoOfM++;
									p.push(v);
								};
							} else {
								if ((M.s & 2) == 0) {
									NoOfM++;
									p.push(v);
								};
							};
						};
						if (M.mc) {
							M.mc.visible = false;
						};
						v++;
					};
				} else {
					t = p.length;
					v = 0;
					while (v < t) {
						if (todo.Message[p[v]].mc) {
							todo.Message[p[v]].mc.visible = false;
						};
						v++;
					};
				};
				MaxInView = (Math.round((todo.tph / 35)) - 2);
				if (MaxInView < 0) {
					MaxInView = 0;
				};
				t = ((NoOfM - MaxInView) * 100);
				if (t <= 0) {
					t = 100;
				};
				main.mscrollmc.Scr_size = t;
				if (((todo.ScrollDown) && ((Scrolling == false)))) {
					main.mscrollmc.position = main.mscrollmc.Scr_size;
					todo.ScrollDown = false;
				};
				if ((((mspos == undefined)) || (!(Scrolling)))) {
					mspos = main.mscrollmc.Scr_position;
					todo.DoUpdateMessages = false;
				} else {
					mspos = ((mspos + main.mscrollmc.Scr_position) / 2);
					V = Math.abs((mspos - main.mscrollmc.Scr_position));
					if (V < 10) {
						mspos = main.mscrollmc.Scr_position;
						todo.DoUpdateMessages = false;
					};
					SkipSmilies = Scrolling;
				};
				Bot = ((MaxInView - 0.001) + ((NoOfM - MaxInView) * (mspos / main.mscrollmc.Scr_size)));
				if (Bot < 0) {
					Bot = 0;
				};
				if (Bot >= (NoOfM - 0.001)) {
					Bot = (NoOfM - 0.001);
				};
				BotMargF = (Bot - int(Bot));
				Bot2 = int(Bot);
				v = Bot2;
				yc2 = 0;
				Cnt = NoOfM;
				HitTop = 99;
				while (Cnt > 0) {
					Cnt--;
					v2 = v;
					v--;
					if (v2 < 0) {
						v2 = (int(Bot) - v2);
					};
					if (p[v2] != undefined) {
						M = todo.Message[p[v2]];
						if (M) {
							userid = xatlib.FindUser(M.u);
							if ((((userid == -1)) && (!((M.u == 0))))) {
								DeleteOneMessageMc(p[v2]);
								p[v2] = undefined;
							} else {
								DeleteNumber = xatlib.xInt(M.n);
								if (v < -1) {
									Bot2++;
								};
								if (M.mc != undefined) {
									yinc = M.mc.mch;
									yc2 = (yc2 + yinc);
								} else {
									if (M.u == 0) {
										Avatar = -1;
										UserName = xconst.ST(14);
										DeleteOk = 0;
									} else {
										Avatar = xatlib.CleanAv(todo.Users[userid].a);
										UserName = todo.Users[userid].n;
										if (UserName.substr(0, 1) == "$") {
											UserName = UserName.substr(1);
										};
										if (HasNick) {
											UserName = xatlib.GetNick(UserName, M.u);
										};
										s = "";
										if (todo.Users[userid].u != 0) {
											s = "<l>";
										};
										UserName = s + "<c> " + s + UserName;
										if (((todo.Users[userid].h) && ((todo.Users[userid].h.length > 6)))) {
											UserName = (UserName + " <ho>");
										};
										if (((((((((todo.w_owner) || (todo.w_moderator))) && (!((M.n == 0))))) && (!((M.n == 1))))) && (!(M.p)))) {
											UserName = (UserName + " <del>");
										};
										DeleteOk = 0;
									};
									AddMessageToList(Avatar, UserName, DeleteOk, p[v2], userid);
									M.mc.visible = false;
								};
								if (((todo.Message[p[Bot2]].mc) && (((yc2 - (todo.Message[p[Bot2]].mc.mch * (1 - BotMargF))) > todo.tph)))) {
									HitTop = 0;
									break;
								};
							};
						};
					};
				};
				if (yc2 >= todo.tph) {
					yc3 = (todo.tph - ((BotMargF - 1) * todo.Message[p[int(Bot)]].mc.mch));
					yc3 = (yc3 - 4);
					n = int(Bot);
					while (n >= 0) {
						if (p[n] != undefined) {
							M = todo.Message[p[n]];
							if (M.mc) {
								if (M.mc.mch != undefined) {
									yc3 = (yc3 - M.mc.mch);
								};
								if (!(M.mc.mch == undefined || yc3 < -M.mc.mch)) {
									M.mc.y = yc3;
									M.mc.visible = true;
								}
							};
						};
						n--;
					};
				} else {
					yc3 = 0;
					n = 0;
					while (n < NoOfM) {
						if (p[n] != undefined) {
							M = todo.Message[p[n]].mc;
							if ((((((yc3 > todo.tph)) || ((yc3 == undefined)))) || (!(M)))) break;
							M.y = yc3;
							M.visible = true;
							yc3 = (yc3 + M.mch);
						};
						n++;
					};
				};
				n = 0;
				while (n < MessageLength) {
					if (((!((todo.Message[n].mc == undefined))) && ((todo.Message[n].mc.visible == false)))) {
						DeleteOneMessageMc(n);
					};
					n++;
				};
				SkipSmilies = false;
			} catch (e: Error) {};
		}
		public static function DeleteOneMessageMc(_arg1) {
			var _local2: * = todo.Message[_arg1].mc;
			if (!_local2) {
				return;
			};
			McCnt--;
			if (((_local2.avc) && (_local2.avc.parent))) {
				_local2.avc.parent.removeChild(_local2.avc);
				_local2.avc = undefined;
			};
			if (_local2.parent) {
				_local2.parent.removeChild(_local2);
			};
			todo.Message[_arg1].mc = undefined;
		}
		public static function NameCol(_arg1: int, _arg2: *= 103) {
			var _local3: * ;
			var _local4: * ;
			var _local5: * ;
			if (_arg1 == -1) {
				return ([undefined, undefined]);
			};
			if (_arg2 == 103) {
				_local3 = todo.Users[_arg1].n.split("(glow");
				_local3 = _local3[1];
				if (_local3) {
					_local3 = _local3.split(")");
					_local3 = _local3[0].split("#");
				} else {
					_local3 = [];
				};
			} else {
				_local3 = todo.Users[_arg1].s.split("#");
				_local3.length = 3;
			};
			_local3.shift();
			var _local6: int = ((todo.Users[_arg1].Powers) ? todo.Users[_arg1].Powers[0] : 0);
			if (_local3[0] == "0") {
				_local3[0] = 0;
			};
			if (_local3[1] == "0") {
				_local3[1] = 0;
			};
			if (_local3[0] === "") {
				_local3[0] = 0xFF00;
			} else {
				if (_local3[0]) {
					_local3[0] = xatlib.DecodeColor(_local3[0], (((_local6 & (1 << 13))) ? true : false), (((_local6 & (1 << 14))) ? true : false), (((_local6 & (1 << 15))) ? true : false), (((_local6 & (1 << 16))) ? true : false));
					if (!_local3[0]) {
						_local3[0] = 0xFF00;
					};
				};
			};
			if (((todo.HasPower(_arg1, _arg2)) && (_local3[1]))) {
				_local3[1] = xatlib.DecodeColor(_local3[1], "v");
			} else {
				_local3[1] = 0;
			};
			if ((((_local3[1] === "grad")) && (todo.HasPower(_arg1, xconst.pssh["namegrad"])))) {
				_local4 = 2;
				while (_local4 < _local3.length) {
					_local3[_local4] = xatlib.DecodeColor(_local3[_local4], "v");
					_local4++;
				};
			} else {
				if (!(((_local3[1] === "jewel")) && (todo.HasPower(_arg1, xconst.pssh["ruby"])))) {
					if (!(((_local3[1] === "flag")) && (todo.HasPower(_arg1, xconst.pssh["nameflag"])))) {
						if (isNaN(Number(_local3[1]))) {
							_local3[1] = 128;
						};
						_local3.length = 2;
					};
				};
			};
			return (_local3);
		}

		public static function TextCol(_arg1: int, _arg2: *= 344) {//345
			var _local3: * ;
			var _local4: * ;
			var _local5: * ;
			if (_arg1 == -1) {
				return ([undefined, undefined]);
			};
			if (_arg2 == 344) {//345
				_local3 = todo.Users[_arg1].n.split("(text");
				_local3 = _local3[1];
				if (_local3) {
					_local3 = _local3.split(")");
					_local3 = _local3[0].split("#");
				} else {
					_local3 = [];
				};
			} else {
				_local3 = todo.Users[_arg1].s.split("#");
				_local3.length = 3;
			};
			_local3.shift();
			var _local6: int = ((todo.Users[_arg1].Powers) ? todo.Users[_arg1].Powers[0] : 0);
			if (_local3[0] == "0") {
				_local3[0] = 0;
			};
			if (_local3[1] == "0") {
				_local3[1] = 0;
			};
			if (_local3[0] === "") {
				_local3[0] = 0xFF00;
			} else {
				if (_local3[0]) {
					_local3[0] = xatlib.DecodeColor(_local3[0], (((_local6 & (1 << 13))) ? true : false), (((_local6 & (1 << 14))) ? true : false), (((_local6 & (1 << 15))) ? true : false), (((_local6 & (1 << 16))) ? true : false));
					if (!_local3[0]) {
						_local3[0] = 0xFF00;
					};
				};
			};
			if (((todo.HasPower(_arg1, _arg2)) && (_local3[1]))) {
				_local3[1] = xatlib.DecodeColor(_local3[1], "v");
			} else {
				_local3[1] = 0;
			};
			if ((((_local3[1] === "grad")) && (todo.HasPower(_arg1, xconst.pssh["textgrad"])))) {
				_local4 = 2;
				while (_local4 < _local3.length) {
					_local3[_local4] = xatlib.DecodeColor(_local3[_local4], "v");
					_local4++;
				};
			} else {
				if (!(((_local3[1] === "jewel")) && (todo.HasPower(_arg1, xconst.pssh["ruby"])))) {
					if (!(((_local3[1] === "flag")) && (todo.HasPower(_arg1, xconst.pssh["textflag"])))) {
						if (isNaN(Number(_local3[1]))) {
							_local3[1] = 128;
						};
						_local3.length = 2;
					};
				};
			};
			return (_local3);
		}
		public static function StatusCol(_arg1: int, _arg2: *= 289) {
			var _local3: * ;
			var _local4: * ;
			var _local5: * ;
			if (_arg1 == -1) {
				return ([undefined, undefined]);
			};
			if (_arg2 == 289) {
				_local3 = todo.Users[_arg1].s.split("#");
			};
			_local3.shift();
			var _local6: int = ((todo.Users[_arg1].Powers) ? todo.Users[_arg1].Powers[0] : 0);
			if (_local3[0] == "0") {
				_local3[0] = 0;
			};
			if (_local3[1] == "0") {
				_local3[1] = 0;
			};
			if (_local3[0]) {
				_local3[0] = xatlib.DecodeColor(_local3[0], (((_local6 & (1 << 13))) ? true : false), (((_local6 & (1 << 14))) ? true : false), (((_local6 & (1 << 15))) ? true : false), (((_local6 & (1 << 16))) ? true : false));
				if (!_local3[0]) {
					_local3[0] = 0xFF00;
				};
			};
			if (((todo.HasPower(_arg1, _arg2)) && (_local3[1]))) {
				_local3[1] = xatlib.DecodeColor(_local3[1], "v");
			} else {
				_local3[1] = 0;
			};
			if ((((_local3[1] === "grad")) && (todo.HasPower(_arg1, xconst.pssh["statusgrad"])))) {
				_local4 = 2;
				while (_local4 < _local3.length) {
					_local3[_local4] = xatlib.DecodeColor(_local3[_local4], "v");
					_local4++;
				};
			} else {
				if (!(((_local3[1] === "jewel")) && (todo.HasPower(_arg1, xconst.pssh["ruby"])))) {
					if (!(((_local3[1] === "flag")) && (todo.HasPower(_arg1, xconst.pssh["statusflag"])))) {
						if (isNaN(Number(_local3[1]))) {
							_local3[1] = 128;
						};
						_local3.length = 2;
					};
				};
			};
			return (_local3);
		}

		private static function HugName(_arg1: * ) {
			_arg1 = _arg1.toString();
			if (_arg1.substr(0, 1) == "$") {
				_arg1 = _arg1.substr(1);
			};
			return (("<c> " + _arg1));
		}

		private static function HugAv(_arg1: * , _arg2: * , _arg3: * ) {
			var _local6: * ;
			if (!_arg1) {
				return;
			};
			if (_arg2 < 0) {
				return;
			};
			var _local4: * = todo.Users[_arg2].a;
			var _local5: * = new xAvatar(_arg1, _local4, "", undefined, _arg2);
			if (((_arg3) && ((_local4.charAt(0) == "h")))) {
				_local6 = new Sprite();
				_local6.graphics.beginFill(0xFF);
				_local6.graphics.drawCircle(15, 15, 15);
				_local6.graphics.endFill();
				_arg1.addChild(_local6);
				_arg1.mask = _local6;
			};
		}

		private static function HugLoaded(_arg1: * ) {
			var _local2: * ;
			var _local9: * ;
			var _local10: * ;
			var _local3: * = _arg1.currentTarget.loader.contentLoaderInfo.content;
			_local3.visible = true;
			var _local4: * = ((todo.tpw - xatlib.NX(16)) / 2);
			_local3.x = -(((750 / 2) - _local4));
			_local3.y = 2;
			var _local5: * = _arg1.currentTarget.loader.parent;
			var _local6: * = _local5.opts;
			_local6.XO = _local3.x;
			if ((todo.w_sound & 1)) {
				_local6.Vol = todo.w_Vol[1];
			};
			_local3.Go(_local6);
			var _local7: * = todo.Message[_local6.v].u;
			var _local8: * = xatlib.FindUser(_local7);
			AddMessageToMc(_local3, 0, HugName(todo.Users[_local8].n), -(_local3.Info.namex), 999, _local3.Info.namey, _local7);
			HugAv(_local3.Info.av, _local8, _local3.Info.RoundAvs);
			if (((_local3.Info.namex2) && (_local6.b))) {
				_local8 = xatlib.FindUser(_local6.b);
				if (_local8 >= 0) {
					_local9 = new MovieClip();
					_local3.addChild(_local9);
					AddMessageToMc(_local9, 0, HugName(todo.Users[_local8].n), 0, 999, _local3.Info.namey2, _local6.b);
					_local10 = _local9.width;
					if (_local10 > _local4) {
						_local10 = _local4;
					};
					_local9.x = (_local3.Info.namex2 - _local10);
					HugAv(_local3.Info.av2, _local8, _local3.Info.RoundAvs);
				};
			};
		}

        public static function AddHug(_arg_1:*, _arg_2:*) {
            var _local_8:*;
            var _local_3:* = todo.Message[_arg_2].t;
            var _local_4:* = todo.Message[_arg_2].u;
            var _local_5:* = _local_3.split(";=");
            var _local_6:* = xconst.hugsR[_local_5[1]];
            if (!_local_6) {
                return;
            };
            _arg_1.opts = {};
            _arg_1.opts.Message = _local_5[2];
            _arg_1.opts.v = _arg_2;
            _arg_1.opts.b = xatlib.xInt(_local_5[3]);
            _arg_1.opts.u = _local_4;
            var _local_7:* = xatlib.FindUser(_local_4);
            if (_local_7 >= 0) {
                _arg_1.opts.un = todo.Users[_local_7].n;
            };
            _local_7 = xatlib.FindUser(_arg_1.opts.b);
            if (_local_7 >= 0) {
                _arg_1.opts.bn = todo.Users[_local_7].n;
            };
            if (xatlib.xInt(_local_5[4])) {
                _local_8 = _local_5[4].split(/([a-z]+)/);
                _arg_1.opts.Time = (xatlib.xInt((((_local_8[0] - xatlib.SockTime()) + 30) / 60)) + " mins");
                if (!_local_8[2]) {
                    _local_8[2] = 25;
                };
                _arg_1.opts.Percent = (_local_8[2] + "%");
                _arg_1.opts.Jinx = _local_6;
                _local_6 = Jinx.EffectToJinx(_local_6);
            };
            xatlib.LoadMovie(_arg_1, xatlib.SmilieUrl(_local_6, "hug"), HugLoaded);
        }
		
		public static function AddMessageToList(Avatar: * , UserName: String, DeleteOk: Number, v: Number, userid: Number) {
			var u: * = undefined;
			var h: * = null;
			var Press: * = undefined;
			var t: * = undefined;
			var z: * = undefined;
			var t2: * = undefined;
			var jinx: * = undefined;
			var jinxstr: * = undefined;
			var Users_uid:* = undefined;
			var themuid:* = undefined;
			var w: * = undefined;
			var m: * = undefined;
			var WordsLength: * = undefined;
			var M: * = todo.Message[v].t;
			u = todo.Message[v].u;
			var yinc: * = 0;
			var Avw: * = new MovieClip();
			todo.Message[v].mc = Avw;
			main.mctextbackground.addChild(Avw);
			while (M.charAt((M.length - 1)) == " ") {
				M = M.slice(0, -1);
			};
			if ((((((M.charAt(0) == "<")) && ((M.charAt(1) == "h")))) && ((M.charAt(2) == ">")))) {
				AddHug(Avw, v);
				Avw.mch = 74;
				yc2 = (yc2 + Avw.mch);
				return;
			};
			Avw.x = 5;
			if (todo.w_userno == u) {
				h = xconst.ST(140);
				Press = function () {
					main.hint.HintOff();
					chat.mainDlg.GotoProfile(todo.w_userno);
				};
			} else {
				if (u == 0) {
					h = xconst.ST(14);
					Press = function () {
						main.hint.HintOff();
						main.openDialog(5, 0);
					};
				} else {
					h = xconst.ST(140);
					Press = function () {
						if (chat.isKeyDown(Keyboard.SHIFT)) {
							PressUserName(u);
						} else {
							chat.mainDlg.GotoProfile(u);
						};
					};
				};
			};
			var uid: * = xatlib.FindUser(u);
			var myuid: * = xatlib.FindUser(todo.w_userno);
			var a: * = Avw;
			a.x = 40;
			var namec: * = [];
			var textc: * = []; //Techy
			if (uid >= 0) {
				Users_uid = todo.Users[uid];
				if (todo.HasPower(uid, xconst.pssh["nameglow"])) {
					namec = NameCol(uid);
				};
				if (todo.HasPower(uid, xconst.pssh["textglow"])) {
					textc = TextCol(uid);
				};
				if ((((todo.w_userno == u)) && ((Users_uid.w == 176)))) {
					M = xatlib.ReversePower(M);
				} else {
					if (main.ctabsmc.TabIsPrivate()) {
						if (uid != myuid) {
							if (Users_uid.JinxPc) {
								jinxstr = Users_uid.JinxPc;
							};
						} else {
							themuid = xatlib.FindUser(main.ctabsmc.TabUser());
							if ((((themuid >= 0)) && (todo.Users[themuid].JinxMe))) {
								jinxstr = todo.Users[themuid].JinxMe;
							};
						};
					} else {
						if (Users_uid.Jinx) {
							jinxstr = Users_uid.Jinx;
						};
					};
					if (((((!(jinxstr)) && (Users_uid.VIP))) && ((M.charAt((M.length - 1)) == ")")))) {
						t = M.split(" ");
						t = t[(t.length - 1)];
						if (t.charAt(0) == "(") {
							t = t.substr(1, t.length - 2).toLowerCase();
							t = t.split("#");
							if (((t[1]) && ((t[1].charAt(0) == "w")))) {
								t[0] = t[1].substr(1);
							};
							t = t[0].replace("jinx", "");
							var _local_7 = xconst.hugs[t];
							t2 = _local_7;
							if ((((_local_7 >= 100000)) && (todo.HasPower(uid, (t2 % 10000))))) {
								jinxstr = (("2147483647" + t) + "100");
							};
						};
					};
				};
			};
			if (jinxstr) {
				jinx = new Jinx();
				M = jinx.DoJinx(M, jinxstr, u);
			};
			todo.Random = (((u + todo.w_useroom) & 0xFFFF) + xatlib.ChkSum(M));
			yinc = AddMessageToMc(a, 0, UserName, 0, main.textPaneWidth, 0, u, userid, namec, 0, todo.Message[v].pb);
			todo.Random = (todo.Random ^ 0x5555);
			if (jinx) {
				a.jinx = jinx.JinxType;
			};
			yinc = (yinc + AddMessageToMc(a, 1, M, 0, main.textPaneWidth, yinc, u, undefined, textc, 0)); //Techy
			if (yinc < 35) {
				yinc = 35;
			};
			if (((todo.HasPower(uid, xconst.pssh["xavi"])) && (!(todo.Message[v].action)))) {
				M = M.toLowerCase();
				M = M.split(" ");
				WordsLength = M.length;
				m = 0;
				while (m < WordsLength) {
					w = M[m];
					if (w.charAt(0) == "(") {
						w = w.substr(1)
							.split(")");
						w = w[0];
						w = w.split("#");
						w = w[0];
					};
					if (xconst.ActionTable[w]) {
						todo.Message[v].action = xconst.ActionNames[xconst.ActionTable[w]];
						break;
					};
					m++;
				};
			};
			if (uid >= 0) {
				Avw.avc = new xAvatar(Avw, Avatar, h, Press, uid, todo.Message[v].action);
			} else {
				Avw.avc = new xAvatar(Avw, Avatar, h, Press);
			};
			Avw.avc.Av.x = -35;
			Avw.avc.Av.y = 5;
			Avw.avc.Av.h = h;
			Avw.avc.Av.Zm = ((((todo.HasPower(uid, xconst.pssh["zoom"])) || (todo.HasPowerA(todo.w_Powers, xconst.pssh["zoom"])))) && (!(todo.bThin)));
			Avw.avc.Av.addEventListener(MouseEvent.ROLL_OVER, Av_onRollOver);
			Avw.avc.Av.addEventListener(MouseEvent.ROLL_OUT, Av_onRollOut);
			Avw.avc.Av.addEventListener(MouseEvent.MOUSE_UP, Av_onRollOut);
			todo.Message[v].mc.mch = (yinc + 4);
			yc2 = (yc2 + (yinc + 4));
		}
		static function Av_onRollOver(_arg1: MouseEvent) {
			var _local2: * = _arg1.currentTarget;
			main.hint.Hint(0, 0, _local2.h, true, 0, undefined, 0, _local2);
			if (!_local2.Zm) {
				return;
			};
			_local2.scaleX = 2.67;
			_local2.scaleY = 2.67;
			_local2.y = -20;
			_local2.parent.parent.setChildIndex(_local2.parent, (_local2.parent.parent.numChildren - 1));
			if (_local2.g) {
				_local2.g.visible = false;
			};
			_local2.addEventListener(MouseEvent.MOUSE_MOVE, Av_tick);
		}
		static function Av_onRollOut(_arg1) {
			var _local2: * = _arg1.currentTarget;
			_local2.scaleX = 1;
			_local2.scaleY = 1;
			_local2.y = 5;
			if (_local2.g) {
				_local2.g.visible = true;
			};
			main.hint.HintOff();
			_local2.removeEventListener(MouseEvent.MOUSE_MOVE, Av_tick);
		}
		static function Av_tick(_arg1) {
			if ((((_arg1.stageX > 99)) || ((_arg1.stageX < 6)))) {
				Av_onRollOut(_arg1);
			};
		}
		static function DoRandom(_arg1, _arg2) {
			var _local5: * ;
			var _local6: * ;
			var _local7: * ;
			var _local8: * ;
			var _local9: * ;
			var _local10: int;
			var _local11: * ;
			var _local12: * ;
			var _local13: * ;
			var _local14: * ;
			if (_arg1.charAt((_arg1.length - 1)) !== ")") {
				return (_arg1);
			};
			var _local3: * = _arg1.split("random");
			var _local4: * = _local3[0];
			if (!todo.Users[_arg2].RandomA) {
				_local14 = (todo.Users[_arg2].RandomA = new Object());
				_local6 = (_local14[1] = new Array());
				_local5 = todo.Users[_arg2].Powers;
				_local10 = xconst.smia.length;
				_local8 = 0;
				while (_local8 < _local10) {
					_local7 = xconst.smia[_local8];
					if (!xatlib.SmOk(_local7, _local5)) {} else {
						if (_local7 === "127") {} else {
							_local6.push(_local7);
						};
					};
					_local8++;
				};
				_local14[1].sort();
			};
			_local14 = todo.Users[_arg2].RandomA;
			_local9 = 1;
			while (_local9 < _local3.length) {
				_local11 = 0;
				_local7 = _local3[_local9].charAt(0);
				if (((!((_local7 === ")"))) && (!((_local7 === "#"))))) {
					_local7 = _local3[_local9].split("#", 2);
					if (_local7[1] == undefined) {
						_local7 = _local3[_local9].split(")", 2);
						_local8 = _local7[0];
						_local3[_local9] = ")";
					} else {
						_local8 = _local7[0];
						_local3[_local9] = ("#" + _local7[1]);
					};
					_local13 = xconst.pssh[_local8];
					if (((_local13) && (xatlib.SmOk(_local8, todo.Users[_arg2].Powers)))) {
						_local12 = _local14[_local8];
						if (!_local12) {
							_local12 = new Array();
							_local10 = _local14[1].length;
							_local7 = 0;
							while (_local7 < _local10) {
								if (xconst.topsh[_local14[1][_local7]] == _local13) {
									_local12.push(_local14[1][_local7]);
								};
								_local7++;
							};
							_local14[_local8] = _local12;
						};
						_local11 = _local12[(todo.Random % _local12.length)];
					};
				};
				_local8 = _local14[1].length;
				if (!_local11) {
					_local11 = _local14[1][(todo.Random % _local8)];
				};
				_local4 = (_local4 + (_local11 + _local3[_local9]));
				todo.Random = (todo.Random + ((_local4.length % 10) + (_local8 >> 1)));
				_local9++;
			};
			return (_local4);
		}
		public static function AddMessageToMc(mcin: * , id: Number, str: String, Left: Number, Right: Number, yOfst: Number, UserNo: Number = NaN, userid: *= undefined, colarray: *= undefined, spare: *= undefined, NameHint: *= undefined): Number {
			var FancyTextType: * = undefined;
			var mcColText: * = undefined;
			var mcGlowText: * = undefined;
			var SwearWord: * = undefined;
			var HasRandom: * = undefined;
			var BigSmiley: Boolean;
			var mcFmt: TextFormat;
			var SmilieBan: * = undefined;
			var mc: * = undefined;
			var Chatter: MovieClip;
			var LocData: * = undefined;
			var LocFunc: * = undefined;
			var HotLink: * = undefined;
			var HotLink2: * = undefined;
			var HotLink3: * = undefined;
            var ProfileLinkId:* = undefined;
            var ProfileLink:* = undefined;
			var s: String;
			var c0: String;
			var Sm: * = undefined;
			var ts: * = undefined;
			var key: * = undefined;
			var mc3: * = undefined;
			var mcTxt: TextField = undefined;
			var t: * = undefined;
			var WordWidth: * = undefined;
			var c3: * = undefined;
			var col:* = undefined;
			var m:* = undefined;
			var mcTxt2: * = undefined;
			var f: Number;
			var mc2: * = undefined;
			var schrs: * = undefined;
			var n2: * = undefined;
			var m2: * = undefined;
			var gradient: BackFx;
			var gh: int;
			var glowc: * = undefined;
			var color: * = 0;
			if (colarray == undefined) {
				color = 0;
			} else {
				if (colarray[0]) {
					glowc = colarray[0];
				};

				if (colarray[1]) {
					color = colarray[1];
				};
				switch (colarray[1]) {
					case "grad":
					case "flag":
					case "jewel":
						FancyTextType = true;
				};
			};
			var TextLeft: * = 9999;
			var TextRight: * = -9999;
			var mcMainText: * = new MovieClip();
			mcColText = new MovieClip();
			mcin.addChild(mcMainText);
			var Width: Number = (Right - Left);
			xPos = Left;
			var yPos: Number = 0;
			var LineH: Number = 16;
			var LinkNextWord: * = false;
			var sLinkNextWord: * = false;
			mcFmt = new TextFormat();
			mcFmt.align = "left";
			mcFmt.bold = !(((id & 1) == 0));
			if (id == 4) {
				id = 1;
			};
			if ((((id == 1)) && ((UserNo == 0)))) {
				mcFmt.italic = true;
			};
			var uid: * = xatlib.FindUser(UserNo);
			if (uid >= 0) {
				HasRandom = todo.HasPower(uid, xconst.pssh["random"]);
			};
			if ((((((id == 1)) && ((uid >= 0)))) && ((todo.Users[uid].w == 184)))) {
				SmilieBan = true;
			};
			mcFmt.font = "_sans";
			var mcFmtSize: * = 14;
			mcFmt.size = mcFmtSize;
			var Space: Number = int((mcFmtSize * 0.4));
			var SCnt: * = 0;
			var HomeX: int;



			if (todo.HasPower(uid, xconst.pssh["textstyle"]) && str.length > 2 && id & 1) {
				//textstyle
				var textPattern:RegExp = /(^|\s)(\\|\*|~)(.+?)\2(?=$|\s)/gs;
				var textMatches:Array = (" " + str + " ").match(textPattern);

				if (textMatches) {
					for(var i:String in textMatches) {
						s = textMatches[i];
						s = s.replace(/^\s+|\s+$/gs, '');
						var char = s.charAt(0);
						switch(char) {
							case "\\":
								str = str.replace(s, "<TS_I>" + s.substr(1, s.length - 2) + "</TS_I>");
								break;
							case "*":
								str = str.replace(s, "<TS_B>" + s.substr(1, s.length - 2) + "</TS_B>");
								break;
							case "~":
								str = str.replace(s, "<TS_S>" + s.substr(1, s.length - 2) + "</TS_S>");
								break;
						}
					}
				}
				//
			}

			var Words: Array = new Array();
			Words = str.split(" ");
			while (Words[0] == "") {
				Words.shift();
			};
			var WordsLen: int = Words.length;
			while (Words[(WordsLen - 1)] == "") {
				Words.pop();
				WordsLen = (WordsLen - 1);
			};
			if (xconst.ST(85) == "RTL") {
				Words.reverse();
			};
			mcin.mouseEnabled = false;
			mcin.t = "";
			mcin.u = UserNo;
			if (glowc) {
				mcGlowText = new MovieClip();
				mcMainText.addChild(mcGlowText);
				if (todo.bThin) {
					mcGlowText.Glow = glowc;
				} else {
					mcGlowText.glowa = new Array();
					mcGlowText.glowf = new GlowFilter(glowc, 0.7, 3, 3, 3, 3, false, true);
					mcGlowText.glowa.push(mcGlowText.glowf);
					mcGlowText.filters = mcGlowText.glowa;
				};
			};

			var n: * = 0;
			function testCopy(mcFmt: TextFormat) {
				return new TextFormat(mcFmt.font, mcFmt.size, mcFmt.color, mcFmt.bold, mcFmt.italic, mcFmt.underline, mcFmt.url, mcFmt.target, mcFmt.align, mcFmt.leftMargin, mcFmt.rightMargin, mcFmt.indent, mcFmt.leading);
			}
			var originalFmt: TextFormat = testCopy(mcFmt);
			//var originalFmt:TextFormat = mcFmt;
			var textStyle: Object = {
				bold: false,
				italic: false,
				underline: false
			};

			for (; n < WordsLen; n++) {
				if ((((Right == 1999)) && ((xPos > (main.upw - 20))))) break;
				LocData = undefined;
				LocFunc = undefined;
				HotLink = undefined;
				HotLink2 = undefined;
				HotLink3 = undefined;
				ProfileLinkId = undefined;
				ProfileLink = undefined;
				mcFmt.color = color;
				s = Words[n].toLowerCase();
				c0 = s.charAt(0);
				Sm = undefined;
				mc = mcin;
				mcFmt.url = "";
				if (!(id & 2)) {
					mcFmt.underline = false;
				};
				SwearWord = 0;
				if (c0 == "<") {
					c3 = s.charAt(1);
					if (c3 == "l" && s.charAt(2) == ">") { //Austin+Techy
						sLinkNextWord = true;
						Words[n] = Words[n].substr(3);
						s = Words[n].toLowerCase();
						c0 = s.charAt(0);
					};
					if (c3 == "s" && s.charAt(3) == ">") { //Austin+Techy

						SwearWord = s.charAt(2);
						Words[n] = Words[n].substr(4);
						s = Words[n].toLowerCase();
						c0 = s.charAt(0);
					};
					if ((((s == "<b>")) || ((s == "</b>")))) {
						mcFmt.bold = true;
						continue;
					};
				};
				if (todo.HasPower(uid, xconst.pssh["textstyle"]) && (s.length > 5 || textStyle.bold || textStyle.italic || textStyle.underline) && id & 1) {
					var word = Words[n];

					var END_TAG: String = word.substr(s.length - 7);
					var START_TAG: String = word.substr(0, 6);

					//todo.helpstr = "["+START_TAG+","+word.substr(6, word.length - 13)+"," + END_TAG + "]";
					//todo.HelpUpdate = 0;

					var change1: Boolean = true;

					if (START_TAG == "<TS_B>" && !textStyle.bold) textStyle.bold = true;
					else if (START_TAG == "<TS_I>" && !textStyle.italic) textStyle.italic = true;
					else if (START_TAG == "<TS_S>" && !textStyle.underline) textStyle.underline = true;
					else change1 = false;

					mcFmt.bold = !textStyle.bold;
					mcFmt.italic = textStyle.italic;
					mcFmt.underline = textStyle.underline;

					if (textStyle.bold || textStyle.italic || textStyle.underline) {

						var change2: Boolean = true;

						if (END_TAG == "</TS_B>" && textStyle.bold) textStyle.bold = false;
						else if (END_TAG == "</TS_I>" && textStyle.italic) textStyle.italic = false;
						else if (END_TAG == "</TS_S>" && textStyle.underline) textStyle.underline = false;
						else change2 = false;

						if (change1) {
							Words[n] = (Words[n] as String).substr(6);
						}
						if (change2) {
							Words[n] = (Words[n] as String).substr(0, -7);
						}
					}
				}
				LinkNextWord = sLinkNextWord;
				if (((!(Sm)) && ((((xPos < Right)) || (!((c0 == "("))))))) {
					if (((HasRandom) && (s.indexOf("random")))) {
						Words[n] = DoRandom(Words[n], uid);
						s = Words[n].toLowerCase();
					};
					if ((((((WordsLen == 1)) && (todo.HasPower(uid, xconst.pssh["big"])))) && (!((s.charAt(0) == "#"))))) {
						BigSmiley = true;
						mc.size = 40;
						mc.SF = smiley.f_NoCache;
					};
					Sm = Smilie(mc, s, UserNo, userid, id, Words[n]);
					if (((((!(Sm)) && ((c0 == "(")))) && (mc.jinx))) continue;
				};
				if (c0 == "_") {
					Words[n] = Words[n].substr(1);
				};
				if (Sm) {
					if (BigSmiley) {
						LineH = 40;
						yPos = (yPos + 3);
					};
					SCnt++;
					Chatter = undefined;
					if (((((!((Sm.Flags == 1))) && ((SCnt > 10)))) && ((UserNo > 101)))) {
						mc.removeChild(Sm);
						continue;
					};
					Sm.x = (xPos + xatlib.xInt(Sm.x));
					Sm.y = (Sm.y + ((yPos + yOfst) + 3));
					xPos = (xPos + 20);
					if (Sm.Flags == 1) {
						xPos = (xPos - 5);
						if (xPos > (Right - 10)) {
							if (HomeX) {
								HomeX = (HomeX - 14);
								Sm.x = HomeX;
							} else {
								Sm.x = (Sm.x - (xPos - Right));
								Sm.x = (Sm.x - 14);
								HomeX = Sm.x;
							};
						} else {
							if (HomeX == 0) {
								HomeX = xPos;
							};
						};
					};
					if (Sm.Flags == 2) {
						Chatter = Sm;
						xPos = (xPos - 8);
					};
					if (Sm.Flags == 4) {
						xPos = (xPos - 10);
						Sm.y = (Sm.y + 3);
					};
					if ((((((((n == 0)) && ((uid >= 0)))) && ((Words[n].charAt(1) == ">")))) && (todo.Users[uid].s))) {
						Sm.y = (Sm.y + 4);
					};
				} else {
					if (!(((c0 == "<")) && ((s == "<c>")))) {
						if (!SmilieBan) {

							mcin.t = (mcin.t + (" " + Words[n]));
							ts = undefined;
							if (Words[n].indexOf(".") >= 0) {
								ts = xatlib.WordIsLink(Words[n]);
							};
							if (ts) {
								if (s.indexOf("twitch.tv") >= 0 || s.indexOf("youtube.com") >= 0 || s.indexOf("photobucket.com") >= 0 || s.indexOf("veoh.com") >= 0 || s.indexOf("vids.myspace.com") >= 0 || s.indexOf("mogulus.com") >= 0 || s.indexOf("video.google.") >= 0 || s.indexOf("live.yahoo.com") >= 0) {
									LocData = xatlib.urlencode(ts.substr(7));
									HotLink = ((xatlib.PageUrl(4) + "&m=") + LocData);
									LocFunc = function (_arg1) {
										return (main.mcLoad.OpenMedia(_arg1.currentTarget.LocData));
									};
									HotLink2 = ts;
								} else {
									s = ts;
									HotLink = 1;
								};
							};
							//Techy ~ type @USERNAME or @id and it will link ot there profile dialog or shift click for xatspace
							if (c0 == "@" && s.substr(1).length < 19) { //if < max reg length skip
								var profile:Number = xatlib.FindUserByReg(s.substr(1));
								
								if (profile >= 0) {
									ProfileLinkId = todo.Users[profile].u;
									ProfileLink = true;
								}
							};
							//Techy ~ clicking &chatname in chat will take you there
							if (!ts && c0 == "&" && s.match(/&/g).length == 1 && s.length >= 4 && s.substr(1).replace(/^[_a-zA-Z0-9_]+$/g, '').length == 0) {
								HotLink = "//ixat.io/" + s.substr(1);
								LocData = s.substr(1);
								LocFunc = function (_arg_1:*) {
									
									return network.NetworkSendMsg(todo.w_userno, "/go " + _arg_1.currentTarget.LocData.toString());
								};
								// later on ... would be nice to have a popup window to confirm if you wanna join that chat
							}
							key = keywords[s];
							if (key) {
								switch (key) {
									case 1:
										HotLink = xatlib.PageUrl(2);
										LocFunc = function (_arg1) {
											return (main.mcLoad.OpenDoodle());
										};
										break;
									case 2:
										HotLink = xatlib.PageUrl(30008);
										LocFunc = function (_arg1) {
											return (main.mcLoad.OpenByN(30008));
										};
										break;
									case 3:
										HotLink = xatlib.PageUrl(5);
										LocFunc = function (_arg1) {
											return (main.mcLoad.OpenSmilies());
										};
										break;
									case 4:
										if (!ImInit) {
											HotLink = xatlib.PageUrl(6);
										};
										break;
									case 5:
										HotLink = xatlib.Register_Link(1);
										LocFunc = 2;
										break;
									case 6:
										HotLink = xatlib.Register_Link(0);
										LocFunc = 2;
										break;
									case 7:
										HotLink = (xatlib.Register_Link(0) + "&b=1");
										break;
									case 8:
										HotLink = xatlib.PageUrl(20044);
										LocFunc = function (_arg1) {
											return (main.mcLoad.OpenByN(20044));
										};
										break;
									case 9:
										HotLink = xatlib.PageUrl(20047);
										LocFunc = function (_arg1) {
											return (main.mcLoad.OpenByN(20047));
										};
										break;
									case 10:
										HotLink = xatlib.PageUrl(60350);
										LocFunc = function (_arg1) {
											return (main.mcLoad.OpenByN(60350));
										};
										break;
									default:
										if (key >= 10000) {
											HotLink = xatlib.PageUrl(key);
											LocFunc = function (_arg1) {
												return (main.mcLoad.OpenByN(key));
											};
										} else {
											HotLink = ("//ixat.io/" + key);

										};
								};
							};
							if (LocFunc == 2) {
								LocFunc = function (_arg1) {
									return (main.mcLoad.StartMedia(("L" + this.Url)));
								};
							};
							if (!HotLink) {
								key = todo.gconfig["g100"];
								if (key) {
									if (key = key[s]) {
										HotLink = HotLink3 = "//bit.ly/" + key;
									}
								}
							};
							mc3 = mcColText;
							mcTxt = new TextField();
							if (((HotLink) && ((id & 1)))) {
								if (HotLink == 1) {
									HotLink = s;
								};
								mcFmt.underline = true;
								if (!FancyTextType && HotLink3) {
									//mcFmt.color = 80;
								};
								mc3 = new xSprite();
								//^ that breaks links and shit
								//(when commented out i mean)
								mcColText.addChild(mc3);
								//mcin.addChild(mc3);
								mc3.Url = HotLink;
								mc3.Url2 = HotLink2;
								mc3.LocFunc = LocFunc;
								mc3.LocData = LocData;
								mc3.useHandCursor = true;
								mc3.buttonMode = true;
								mc3.mouseChildren = false;
								mc3.addEventListener(MouseEvent.MOUSE_DOWN, DoHotLink);
							} else {
								if (SwearWord == 3) {
									for (m in xconst.highwords) {
										if (s.indexOf(m) != -1) {
											col = xatlib.DecodeColor(xconst.highwords[m]);
											break;
										};
									};
									col = xatlib.xInt(col);
									if (!col) {
										col = 0xEEFF00;
									};
									mc3 = new xSprite();
									mcTxt.background = true;
									mcTxt.backgroundColor = col;
									mcin.addChild(mc3);
								};
							};
							
							mcTxt.antiAliasType = AntiAliasType.ADVANCED;
							mcTxt.x = xPos;
							mcTxt.y = ((yPos + yOfst) + 3);
							mcTxt.width = Width;
							mcTxt.height = (LineH * 1.3);
							mcTxt.selectable = true;
							mcTxt.defaultTextFormat = mcFmt;
							mcTxt.text = Words[n];
							t = mc3.addChild(mcTxt);
							if (((mcGlowText))) { // && ((mc3 == mcColText)))) {
								mcTxt2 = new TextField();
								mcTxt2.x = xPos;
								mcTxt2.y = ((yPos + yOfst) + 3);
								mcTxt2.width = Width;
								mcTxt2.height = (LineH * 1.3);
								mcTxt2.selectable = true;
								mcTxt2.defaultTextFormat = mcFmt;
								mcTxt2.text = Words[n];
								mcGlowText.addChild(mcTxt2);
							};

							WordWidth = mcTxt.textWidth;
							mcTxt.width = (WordWidth + 5);
							if (Words[n]) {
								if (TextLeft > xPos) {
									TextLeft = xPos;
								};

								if (TextRight < (xPos + WordWidth)) {
									TextRight = (xPos + WordWidth);
								};
							};

							if ((((((((xPos > 0)) && ((WordWidth > (Width - xPos))))) && ((userid == undefined)))) && (!(((id & 2) == 2))))) {
								f = 0;
								if (Chatter != undefined) {
									Chatter.x = Left;
									Chatter.y = (Chatter.y + LineH);
									f = 12;
								};
								mcTxt.x = (Left + f);
								mcTxt.y = (mcTxt.y + LineH);
								if (mcTxt2) {
									mcTxt2.x = mcTxt.x;
									mcTxt2.y = mcTxt.y;
								}
								yPos = (yPos + LineH);
								xPos = (((Left + Space) + WordWidth) + f);
							} else {
								Chatter = undefined;
								xPos = (xPos + (Space + WordWidth));
							};
							if (((ProfileLink) && ((id & 1)))) {//new
								mcFmt.color = 0xFFFFFF;

								mc2 = new xSprite();
								mcin.addChild(mc2);
									
								mcTxt2 = new TextField();
								mcTxt2.x = mcTxt.x;
								mcTxt2.y = mcTxt.y;
								mcTxt2.width = (WordWidth + 5);
								mcTxt2.height = (LineH * 1.3);
									
								t = mc2.addChild(mcTxt2);
									
								mcTxt2.defaultTextFormat = mcFmt;
								mcTxt2.text = s;
								mcTxt2.backgroundColor = 0x000080;
								mcTxt2.background = true;
								mc2.useHandCursor = true;
								mc2.buttonMode = true;
								mc2.mouseChildren = false;
								mc2.UserNo = xatlib.xInt(ProfileLinkId);
								mc2.addEventListener(MouseEvent.MOUSE_DOWN, PressProfileEvent);
							};

							switch (xatlib.xInt(SwearWord)) {
                                case 1:
                                case 2:
                                    mc2 = new xSprite();
                                    mcin.addChild(mc2);
                                    mcTxt2 = new TextField();
                                    mcTxt2.x = mcTxt.x;
                                    mcTxt2.y = mcTxt.y;
                                    mcTxt2.width = Width;
                                    mcTxt2.height = (LineH * 1.3);
                                    t = mc2.addChild(mcTxt2);
                                    schrs = "!#%£!@?*";
                                    m2 = 0;
                                    mcTxt2.defaultTextFormat = mcFmt;
                                    mcTxt2.text = "";
                                    n2 = 0;
                                    while (n2 < s.length) {
                                        mcTxt2.text = (mcTxt2.text + schrs.charAt(m2++));
                                        if (m2 >= schrs.length) {
                                            m2 = 0;
                                        };
                                        n2++;
                                    };
                                    mcTxt2.width = (WordWidth + 5);
                                    mcTxt2.backgroundColor = 0x909090;
                                    if (SwearWord == "2") {
                                        mcTxt2.backgroundColor = 9474303;
                                    };
                                    mcTxt2.background = true;
                                    mc2.addEventListener(MouseEvent.MOUSE_DOWN, RemoveMe);
                            };
						};
					};
				};
			};

			mcMainText.addChild(mcColText);
			if (id == 1 && todo.Macros["textgrad"] === "off" && todo.HasPower(uid, xconst.pssh["textgrad"])) {
				FancyTextType = false;
			}

			if (mcGlowText) {
				mcGlowText.cacheAsBitmap = true;
			};
			mcColText.cacheAsBitmap = true;
			var gw: int = ((TextRight - TextLeft) + 4);
			if (((FancyTextType) && ((gw > 0)))) {
				gradient = new BackFx();
				gradient.ep = todo.HasPower(uid, xconst.pssh["everypower"]);
				gh = (LineH - 2);
				gh += yPos;
				gradient.Make(colarray, gh, gw, uid, id == 1 ? 427 : 426);
				gradient.x = TextLeft;
				gradient.y = (yOfst + 7);
				gradient.cacheAsBitmap = true;
				mcMainText.addChild(gradient);
				gradient.mask = mcColText;
			};
			if (LinkNextWord) {
				mcMainText.UserNo = xatlib.xInt(UserNo);
				if (UserNo == 0) {
					mcMainText.UserNo = todo.w_userno;
				};
				mcMainText.addEventListener(MouseEvent.MOUSE_DOWN, PressUserNameEvent);
				mcMainText.nh = NameHint;
				mcMainText.id = id;
				mcMainText.addEventListener(MouseEvent.ROLL_OVER, HintUserName);
				mcMainText.addEventListener(MouseEvent.ROLL_OUT, main.hint.HintOff);
				mcMainText.buttonMode = true;
				mcMainText.mouseChildren = false;
			};
			return ((yPos + LineH));
		}

		public static function RemoveMe(_arg1: MouseEvent) {
			_arg1.currentTarget.parent.removeChild(_arg1.currentTarget);
		}
		public static function DoHotLink(_arg1: MouseEvent) {
			var _local3: * ;
			var _local2: * = ((chat.isKeyDown(Keyboard.SHIFT)) || (((!(((todo.FlagBits & xconst.f_NoList) == 0))) && (!((global.xc & 0x0800))))));
			if (((!(_local2)) && (_arg1.currentTarget.LocFunc))) {
				_arg1.currentTarget.LocFunc(_arg1);
			};
			if (((((_local2) || (!(_arg1.currentTarget.LocFunc)))) || (!((global.xc & 0x0800))))) {
				_local3 = _arg1.currentTarget.Url;
				if (((_local2) && (_arg1.currentTarget.Url2))) {
					_local3 = _arg1.currentTarget.Url2;
				};
				_local3 = xatlib.xatlinks(_local3);
				if (chat.isKeyDown(Keyboard.SHIFT)) {
					_local3 = (_local3 + "");
				};
				xatlib.UrlPopup(xconst.ST(8), _local3, xconst.ST(17));
			};
		}
		public static function PressUserNameEvent(_arg1: MouseEvent) {
			PressUserName(_arg1.currentTarget.UserNo, _arg1.ctrlKey);
		}
        public static function PressProfileEvent(_arg_1:MouseEvent) {
			if (chat.isKeyDown(Keyboard.SHIFT)) {
				chat.mainDlg.GotoProfile(_arg_1.currentTarget.UserNo);
			} else {
				PressUserName(_arg_1.currentTarget.UserNo);
			};
        }
		public static function PressUserName(_arg1, _arg2 = false) {
			if (_arg1 == undefined) {
				return;
			};
			main.hint.HintOff();
			//if (_arg1 == 3) {
			//   return;
			//};
			if (_arg1 == todo.w_userno) {
				main.openDialog(1);
			} else if (_arg1 != 0xFFFFFFFF) {
				if (((((((_arg2) && (todo.Macros))) && (todo.Macros["rapid"]))) && (todo.HasPowerA(todo.w_Powers, xconst.pssh["rapid"], todo.w_Mask)))) {
					DoRapid(_arg1);
				} else {
					main.openDialog(2, _arg1);
				};
			};
		}
		public static function HintUserName(_arg1: MouseEvent) {
			var _local4: * ;
			var _local2: * = 0;
			var _local3: * = 8;
			if (_arg1.currentTarget.id == 2) {
				_local2 = 1;
				_local3 = 3;
			};
			if (todo.w_userno == _arg1.currentTarget.UserNo) {
				_local4 = xconst.ST(18);
			} else {
				/*if (_arg1.currentTarget.UserNo == 3) {
                    if (ImInit) {
                        _local4 = xconst.ST(141);
                    } else {
                        _local4 = xconst.ST(142);
                    };
                } else {*/
				_local4 = xconst.ST(16, xatlib.FixLI(xatlib.GetUsername(_arg1.currentTarget.UserNo, 1, 1, _arg1.currentTarget.nh)));
				//};
			};
			if (_local4) {
				main.hint.Hint(0, _local3, _local4, true, _local2, 0, 0, _arg1.currentTarget);
			};
		}
		public static function GotPower(_arg1, _arg2) {
			return (xatlib.SmOk(_arg1, _arg2, true));
		}

		public static function PowSm(_arg1, _arg2, _arg3, _arg4) {
			var _local7: * ;
			var _local8: * ;
			var _local10: * ;
			var _local12: * ;
			var _local14: * ;
			var _local16: * ;
			var _local19: * ;
			var _local20: * ;
			var _local21: * ;
			var _local22: * ;
			var _local23: * ;
			if (_arg2[1] == undefined) {
				return (true);
			};
			if (!(_arg1.SF & 2)) {
				return (false);
			};
			if (((_arg4) && ((_arg4[0] & 1)))) {
				_arg1.SF = (_arg1.SF | smiley.f_AllPowers);
			};
			var _local5: * = _arg2.length;
			var _local6: * = true;
			var _local9: * = new Object();
			var _local11: * = "";
			var _local13: * = "";
			var _local15: * = 0;
			var _local17: * = true;
			var _local18: Boolean;
			_local16 = 1;
			for (; _local16 <= _local5; _local16++) {
				_local19 = undefined;
				if (_arg2[_local16] != undefined) {
					if (_arg2[_local16].indexOf("F") == -1){
						_local19 = _arg2[_local16].toLowerCase();
					} else {
						_local19 = _arg2[_local16];
					};
				};
				if (_arg2[(_local16 - 1)] === "piano") {
					_arg1.SF = (_arg1.SF | 128);
				};
				if (((((_local19) && ((_local19.charAt(0) == "y")))) && ((_local19.length > 14)))) {
					if (todo.HasPowerA(_arg4, xconst.pssh["supercycle"])) {
						_arg1.SCC = _local19;
					};
					_local19 = "y";
				};
				_local7 = xconst.effectsR[_local19];
				if (_local7 != undefined) {
					_local9[_local7] = true;
				} else {
					_local7 = xconst.effects[_local19];
					if (_local7 != undefined) {
						_local9[_local19] = true;
						if (((_local6) || (!((_local19 == "y"))))) {
							continue;
						};
					};
					_local7 = xconst.backsR[_local19];
					if (_local7 != undefined) {
						_local10 = _local7;
					} else {
						if (((!((_local19 == undefined))) && ((_local19.length == 1)))) {
							_local7 = xconst.backs[_local19];
						};
						if (_local7 != undefined) {
							_local10 = _local19;
						} else {
							if (((((((xconst.smih[_local19]) && (!((_local19.length == 1))))) || ((_local19 == undefined)))) || ((_local19 == "6")))) {
								if (_local18) {
									break;
								};
								if (_local19 == "hole") {
									_local18 = true;
								};
								for (_local21 in _local9) {
									_local7 = xconst.effects[_local21];
									if (!GotPower(_local7, _arg4)) {
										_local9[_local21] = false;
										_local17 = false;
									};
								};
								if (_local6) {
									_local14 = _local9;
									if (GotPower(xconst.backs[_local10], _arg4)) {
										_arg1.ST = xconst.backs[_local10];
									} else {
										_local17 = false;
									};
									_arg1.SC = _local13;
									if (_local14["f"]) {
										_arg1.SP = 4;
									};
									if (_local14["y"]) {
										_arg1.SC = "y";
									};
								} else {
									_local11 = (_local11 + ",");
									_local7 = 1;
									if (_local9["f"]) {
										_local7 = (_local7 | 4);
									};
									_local11 = (_local11 + _local7);
								};
								if ((((_local19 == "6")) && ((_arg1.SC == undefined)))) {
									_arg1.SC = 0xF00000;
								};
								_local13 = undefined;
								_local9 = new Object();
								_local12 = false;
								++_local15;
								if (_local15 >= 6) {
									break;
								};
								if (((!(todo.HasPowerA(_arg4, xconst.pssh["allpowers"]))) || (!((_local19 == "allpowers"))))) {
									if (!xatlib.SmOk(_local19, _arg4, true)) {
										if (_local19) {
											_arg2[_local16] = "none";
											_local17 = false;
										};
										break;
									};
								};
								if (!_local6) {
									_local11 = (_local11 + ",");
								};
								_local11 = (_local11 + (_local19 + ","));
								_local6 = false;
							} else {
								_local20 = false;
								if (_local19.length == 6) {
									_local7 = parseInt(_local19, 16);
									_local7 = _local7.toString(16);
									_local7 = ("000000" + _local7);
									_local7 = _local7.substr(-6, 6);
								} else {
									_local7 = "";
								};
								if (_local19 == "y") {
									if (!todo.HasPowerA(_arg4, xconst.pssh["cycle"])) {
										_local7 = _local19 = "";
									};
									_local20 = true;
								};
								if (_local7 != _local19) {
									_local22 = _local19.length;
									_local23 = 0;
									while (_local23 < _local22) {
										_local7 = _local19.charAt(_local23);
										if ((((xconst.effects[_local7] == undefined)) && (!(xconst.colorc[_local7])))) {
											_local20 = true;
											break;
										};
										_local23++;
									};
									if (!_local20) {
										_local23 = 0;
										while (_local23 < _local22) {
											_local7 = _local19.charAt(_local23);
											_local9[_local7] = true;
											_local23++;
										};
									};
								};
								if (!_local20) {
									_local7 = xatlib.DecodeColor(_local19, todo.HasPowerA(_arg4, xconst.pssh["red"]), todo.HasPowerA(_arg4, xconst.pssh["green"]), todo.HasPowerA(_arg4, xconst.pssh["blue"]), todo.HasPowerA(_arg4, xconst.pssh["light"]));
									if (_local7 != undefined) {
										if (!_local6) {
											if (_local12) {
												_local11 = (_local11 + "#");
											};
											_local12 = true;
											_local11 = (_local11 + _local7);
										} else {
											_local13 = (_local13 + (_local7 + "#"));
										};
									};
								};
								if (((_local20) && (!(_local6)))) {
									if (_local12) {
										_local11 = (_local11 + "#");
									};
									_local12 = true;
									_local11 = (_local11 + _local19);
								};
							};
						};
					};
				};
			};
			if (_local11 != "") {
				_arg1.SE = _local11;
			};
			if (((_local14["i"]) && ((_arg4[0] & (1 << 6))))) {
				_arg1.scaleY = -1;
				_arg1.y = (_arg1.y + _arg3);
			};
			if (((_local14["m"]) && ((_arg4[0] & (1 << 7))))) {
				_arg1.scaleX = -1;
				_arg1.xx = _arg3;
			};
			_arg1.SA = (("(" + _arg2.join("#")) + ")");
			return (_local17);
		}

		public static function Smilie(_arg1, _arg2: String, _arg3: Number, _arg4: Number, _arg5, _arg6: String) {
			var smc: * = undefined;
			var HTxt: * = undefined;
			var t: * = undefined;
			var key: * = undefined;
			var smc2: * = undefined;
			var m: * = undefined;
			var classRef: * = null;
			var Args: * = undefined;
			var G: * = undefined;
			var e: * = undefined;
			var t2: * = undefined;
			var Col: * = undefined;
			var s2: * = undefined;
			var mc: * = _arg1;
			var s: * = _arg2;
			var u: * = _arg3;
			var userid: * = _arg4;
			var Pos: * = _arg5;
			var Code: * = _arg6;
			if (!userid) {
				userid = xatlib.FindUser(u);
			};
			if (userid == -1) {
				userid = 0;
			};
			var uid: * = userid;
			var c0: * = s.charAt(0)
				.toLowerCase();
			if (!FirstC) {
				t = "#,:,;,<,8,(,|,p";
				t = t.split(",");
				FirstC = {};
				for (key in t) {
					FirstC[t[key]] = true;
				};
			};
			if (FirstC[c0]) {
				if (c0 == "#") {
					var _local8 = new library("Speaker");
					smc = _local8;
					smc2 = _local8;
					smc2.scaleX = (smc2.scaleY = (19 / 23));
					if (!todo.bThin) {
						smc2.xitem.gotoAndStop(1);
					};
					smc2.xitem.SoundIsOff.visible = false;
					HTxt = s;
					if (!todo.bMobile) {
						smc.addEventListener(MouseEvent.MOUSE_DOWN, DoSound);
					};
					smc.Snd = s;
				};
				if (c0 == ":" || c0 == ";" || c0 == "8" || c0 == "|" || c0 == "p") {
					m = 0;
					while (m < xconst.smArray.length) {
						if (xconst.smArray[m] == s) {
							while (!((xconst.smArray[m] < 0))) {
								m = (m + 1);
								if (m >= xconst.smArray.length) {
									break;
								};
							};
							HTxt = s.toUpperCase();
							if (((todo.bThin) || ((xconst.smArray[m] < -1)))) {
								_local8 = (("(" + xconst.smArray[(m - 1)]) + ")");
								s = _local8;
								Code = _local8;
								break;
							};
							classRef = (getDefinitionByName(xconst.smArray[(m - 1)]) as Class);
							smc = new(classRef)();
							if (mc.size) {
								smc.scaleX = (smc.scaleY = (mc.size / 19));
							};
							smc.UserNo = u;
							break;
						};
						while (!((xconst.smArray[m] < 0))) {
							m = (m + 1);
							if (m >= xconst.smArray.length) {
								break;
							};
						};
						m = (m + 1);
					};
				};
				if ((((((smc == undefined)) && ((c0 == "(")))) && ((s.charAt((s.length - 1)) == ")")))) { // || (((((smc == undefined)) && ((c0 == ":")))) && ((s.charAt((s.length - 1)) == ":")))) {//Techy
					Args = new Array();
					t = s.substr(1, (s.length - 2));
					G = (t.charAt(0) == ">");
					if (G) {
						t = xatlib.xInt(t.substr(1));
					} else {
						if (xatlib.xInt(t) >= 10000) {
							t = "";
						};
						Args = t.split("#");
						t = Args[0];
						if ((((SmB == undefined)) && (!(xatlib.SmOk(t, todo.Users[uid].Powers))))) {
							t = -1;
						};
						if (((mc.jinx) && ((mc.jinx == Args[0].toLowerCase())))) {
							t = Args[0];
						};
					};
					if ((((((Args[0] == "hat" || Args[0] == "text")) && (!((Args[1] == undefined))))) || ((Args[0] == "glow" || Args[0] == "pglow")))) {
						_local8 = "none";
						t = _local8;
						Args[0] = _local8;
					};
					if (((!((t == -1))) || (G))) {
						smc = new MovieClip();
						e = "";
						if (todo.Users[uid].registered != undefined) {
							smc.SF = 1;

						};
						if (todo.Users[uid].VIP) {
							e = "&r=2";
							smc.SF = 2;
						};
						smc.UserNo = u;
						if (xconst.topsh[t] == -3) {
							smc.Gifts = u;
						};
						if ((((t >= 10128)) && ((t < 20000)))) {
							classRef = (getDefinitionByName(t) as Class);
							t2 = new(classRef)();
							smc.addChild(t2);
						} else {
							if (t > 50000) {
								if (todo.bMobile) {
									return (false);
								};
								Args = new Array();
								if (t >= 60000) {
									t2 = ((t - 60000) & ~(1));
									if (!xconst.Game[t2]) {
										return;
									};
									Args.push(xconst.Game[t2]);
								} else {
									Args.push((xconst.Puzzle[(t - 50000)] + "ban"));
								};
								Args.push("wb1");
								if (todo.Users[userid].w) {
									Args.push("964B00");
								};
								smc.SF = 2;
								PowSm(smc, Args, 19, todo.ALL_POWERS);
								smc.ns = new smiley(smc, Args[0]);
							} else {
								if (!PowSm(smc, Args, 19, todo.Users[uid].Powers)) {
									smc.u = u;
									if (todo.bMobile) {
										return (false);
									};
								};
                                if ((((Code.match(/#wc/g).length > 0)) && (!(todo.HasPowerA(todo.Users[uid].Powers, xconst.pssh["classic"]))))) {
                                    Code = Code.replace(/#wc/g, "#WC");
                                    smc.u = ("C" + xatlib.xInt(smc.u));
                                };								
								smc.SA = Code;
								if (!SmB) {
									smc.SP = (smc.SP | smiley.b_glow);
								};
								if (!todo.bMobile) {
									smc.ns = new smiley(smc, t, ((mc.size) ? mc.size : 20));
								};
								if (todo.bMobile) {
									smc = Code;
								};
							};
							if (!(smc is String)) {
								smc.x = (smc.x + xatlib.xInt(smc.xx));
							};
						};
						if (!HTxt) {
							HTxt = s.toUpperCase();
						};
						if (G) {
							HTxt = 0;
							if (t == 10200) {
								HTxt = " ";
							} else {
								HTxt = xconst.ST(143);
								if ((((((t > 50000)) && ((t < 60000)))) && (!(todo.HasPowerA(todo.w_GroupPowers, (t % 50000)))))) {
									t = undefined;
								};
								smc.xNum = t;
							};
						};
						if (((!(todo.bMobile)) && ((smc.SF & 128)))) {
							smc.addEventListener(MouseEvent.MOUSE_DOWN, DoSound);
						}
					};
				};
				if (c0 == "<") {
					if (s == "<del>") {
						smc = new library("xdelete");
						smc.y = 6;
						smc.DeleteNumber = DeleteNumber;
						if (!todo.bMobile) {
							smc.addEventListener(MouseEvent.MOUSE_DOWN, DeleteMess);
						};
						smc.Flags = 1;
						HTxt = xconst.ST(1);
					};
					if (s == "<o>") {
						smc = new chatter2();
						smc.Go();
						if (!todo.bMobile) {
							smc.addEventListener(MouseEvent.MOUSE_DOWN, function () {
								main.openDialog(1);
							});
						};
						smc.Flags = 2;
					};
					if (s == "<priv>") {
						smc = new lock();
						smc.hint = {
							Hint: xconst.ST(20),
							mc: smc
						};
						if (!todo.bMobile) {
							smc.addEventListener(MouseEvent.ROLL_OVER, main.hint.EasyHint);
						};
						smc.Flags = 4;
					};
					if (s == "<i>") {
						smc = new library("HelpIcon");
						smc.xitem.ques.visible = false;
					};
					if (s == "<inf8>") {
						smc = new library("HelpIcon");
						smc.xitem.ques.visible = false;
						xatlib.McSetRGB(smc.xitem.infob, 0x9900);
					};
					if (s == "<inf9>") {
						smc = new library("HelpIcon");
						smc.xitem.ques.visible = false;
						xatlib.McSetRGB(smc.xitem.infob, 0xFF0000);
					};
					if (s == "<ho>") {
						if (todo.Users[uid].h.length > 0) {
							smc = new library("ho");
							smc.scaleX = (smc.scaleY = 0.4);
							smc.y = 5;
							HTxt = (smc.HomePage = todo.Users[uid].h);
							if (!todo.bMobile) {
								smc.addEventListener(MouseEvent.MOUSE_DOWN, OnHomePage);
							};
							smc.Flags = 1;
						};
					};
					if (s == "<c>") {
						Col = -1;
						var special = false;
						if (todo.Users[userid].member) {
							//pink
							Col = 0x6565FF;
							HTxt = xconst.ST(22);
							if (todo.HasPower(userid, xconst.pssh["pink"])) {
								Col = 16716947;
							};
							if (todo.HasPower(userid, xconst.pssh["blueman"])) {
								Col = 128;
							};
						};
						if (todo.Users[userid].moderator) {
							Col = 0xFFFFFF;
							HTxt = xconst.ST(23);
						};
						if (todo.Users[userid].owner) {
							Col = 0xFF9900;
							HTxt = xconst.ST(24);
						};
						if (todo.Users[userid].mainowner) {
							Col = 0xFF9900;
							HTxt = xconst.ST(134);
						};

						if (!todo.Users[userid].Stealth && (todo.Users[userid].aFlags & (1 << 21))) {
							Col = 1304549;
							HTxt = xconst.ST(251);
						} else {
							if (todo.Users[userid].admin) {
								HTxt = "iXat Staff";
							} else if (todo.Users[userid].volunteer) {
								HTxt = "iXat Volunteer";
							}

							if (todo.Users[userid].custom_pawn != undefined) {
								Col = xatlib.DecodeColor(todo.Users[userid].custom_pawn);
								if (todo.HasPower(userid, xconst.pssh["everypower"])) { // everypower
									special = 'p1emerald';
								} else if (todo.HasPower(userid, xconst.pssh["sapphire"]) || todo.HasPower(userid, xconst.pssh["ruby"])) { // sapphire
									special = 'p1ruby';
								}
							} else {

								// ep ruby gold awepawn rainbowpawn purple yellow sapphire tempawn tecno cyclepawn 

								if (todo.Users[userid].volunteer) {
									Col = 0xC1E0FF;
								} else if (todo.HasPower(userid, xconst.pssh["everypower"])) { // everypower
									Col = 1089554;
									special = 'p1emerald';
								} else if (todo.HasPower(userid, xconst.pssh["ruby"])) {
									Col = 14423100;
									special = 'p1ruby';
								} else if (todo.HasPower(userid, xconst.pssh["gold"])) { // gold
									Col = 16041823;
									special = 'p1gold';
								} else if (todo.HasPower(userid, xconst.pssh["awepawn"])) { // awesomepawn
									Col = 0xffffff;
									special = 'p1awesome';
								} else if (todo.HasPower(userid, xconst.pssh["rainbowpawn"])) { // awesomepawn
									Col = 0xffffff;
									special = 'p1rainbow';
								} else if (todo.HasPower(userid, xconst.pssh["purple"])) { // purple
									Col = 0x800080;
								} else if (todo.HasPower(userid, xconst.pssh["yellow"])) { // yellow
									Col = 16776960;
								} else if (todo.HasPower(userid, xconst.pssh["sapphire"])) { // sapphire
									Col = 0xff;
									special = 'p1ruby';
								} else if (todo.HasPower(userid, xconst.pssh["tempawn"])) { // awesomepawn
									Col = 0xffffff;
									special = 'p1tempawn';
								} else if (todo.HasPower(userid, xconst.pssh["tecno"])) { // awesomepawn
									Col = 0xffffff;
									special = 'p1tecno';
								} else if (todo.HasPower(userid, xconst.pssh["cyclepawn"])) { // cyclepawn
									Col = 0x6424eb;
									special = 'p1cyclepawn';
								} else if (todo.Users[userid].Stealth) {
									Col |= -1;
									HTxt = "";
								}								
							};
						};
						if (todo.Users[userid].ignored) {
							Col = 0x606060;
						};
						if (Col >= 0) {
							smc = new chatter2();
							smc.ColP1 = Col;
							smc.Size = 16;

							if (special != false) {
								smc.Pawn = special;
							}

							if (special == 'p1cyclepawn') {
								if (todo.Users[userid].cyclepawn != undefined) {
									smc.cyclepawn = todo.Users[userid].cyclepawn;
								}
							}
							
							if (((todo.Users[userid].epcode) && (!(todo.Users[userid].ignored)))){
								smc.ColP1 = todo.Users[userid].epcode;
							};
							
							if (todo.Users[userid].friend == 3) {
								smc.Pawn = "p1foe";
							};
							smc.Go();
							smc.y = 4;
							smc.Flags = 2;
						};
					};
				};
			};
			if (((mc) && (smc))) {
				mc.addChild(smc);
			};
			var Clicker: * = smc;
			if (((((!(todo.bMobile)) && (HTxt))) && (smc))) {
				smc.Hint = HTxt;
				if (((smc.ns) && (smc.ns.Clicker))) {
					smc.mouseEnabled = false;
					Clicker = smc.ns.Clicker;
					Clicker.Par = smc;
				};
				Clicker.addEventListener(MouseEvent.ROLL_OVER, smc_onRollOver);
				Clicker.addEventListener(MouseEvent.ROLL_OUT, smc_onRollOut);
				if (((!(todo.bThin)) && ((HTxt.substr(0, 14) == "(RADIO#HTTP://")))) {
					s2 = HTxt.split("#");
					s2 = s2[1].split(")");
					smc.Radio = s2[0];
					if (((((!(Ronce)) && ((Pos == 2)))) && ((u == todo.w_userno)))) {
						Ronce = 1;
						if (todo.useRadio == undefined) {
							todo.useRadio = smc.Radio;
							chat.mainDlg.CreateSoundIcon("Radio", 2);
						};
						todo.useRadio = smc.Radio;
					};
				};
				smc.ClickCode = s;
				if (smc.ClickCode == "<c>")
					smc.ClickCode = "";
				t = HTxt.substr(1);
				t = t.split(")");
				t = t[0].split("#");
				t = t[0].toLowerCase();
				t = xconst.pssh[t];
				if (xconst.IsGroup[t]) {
					smc.Power = t;
				};
				Clicker.addEventListener(MouseEvent.MOUSE_DOWN, smc_onPress);
			};
			if ((((Pos & 1)) && (!((smc == undefined))))) {
				smc.UserNo = undefined;
			};
			if (((!(todo.bMobile)) && (Clicker))) {
				Clicker.buttonMode = true;
			};
			return (smc);
		}
		static function smc_onRollOver(_arg1: MouseEvent) {
			var _local2: * = _arg1.currentTarget;
			if (_local2.Par) {
				_local2 = _local2.Par;
			};
			main.hint.Hint(0, 0, _local2.Hint, true, 0, undefined, 0, _local2);
		}
		static function smc_onRollOut(_arg1: MouseEvent) {
			main.hint.HintOff();
		}
		public static function OnHomePage(_arg1: MouseEvent) {
			var _local2: String = _arg1.currentTarget.HomePage;
			if (!_local2) {
				return;
			};
			//Techy ~ homepage that contains media will load in media sideapp
			var ts = undefined;
			if (_local2.indexOf(".") >= 0) {
				ts = xatlib.WordIsLink(_local2);
			};
			if (ts) {
				if (_local2.indexOf("twitch.tv") >= 0 || _local2.indexOf("youtube.com") >= 0 || _local2.indexOf("photobucket.com") >= 0 || _local2.indexOf("veoh.com") >= 0 || _local2.indexOf("vids.myspace.com") >= 0 || _local2.indexOf("mogulus.com") >= 0 || _local2.indexOf("video.google.") >= 0 || _local2.indexOf("live.yahoo.com") >= 0) {
					return (main.mcLoad.OpenMedia(xatlib.urlencode(ts.substr(7))));
				}
			}
			if (_local2.substr(0, 4)
				.toLowerCase() != "http") {
				_local2 = ("//" + _local2);
			};
			_local2 = xatlib.xatlinks(_local2);
			xatlib.UrlPopup(xconst.ST(21), _local2);
		}
		public static function DeleteMess(_arg1: MouseEvent) {
			main.hint.HintOff();
			var _local2: * = todo.Message.length;
			var _local3: * = 0;
			while (_local3 < _local2) {
				if (todo.Message[_local3].n == _arg1.currentTarget.DeleteNumber) {
					todo.Message[_local3].ignored = true;
				};
				_local3++;
			};
			network.RemoveUsersWithNoMessages();
			network.NetworkDeleteMessage(_arg1.currentTarget.DeleteNumber);
			todo.DoUpdateMessages = true;
			todo.DoBuildUserList = true;
		}
		public static function smc_onPress(_arg1: MouseEvent) {
			var t: * = undefined;
			var self: * = undefined;
			var Dia: * = undefined;
			var w: * = undefined;
			var h: * = undefined;
			var x: * = undefined;
			var y: * = undefined;
			var f: * = undefined;
			var d: * = undefined;
			var w1: * = undefined;
			var w2: * = undefined;
			var buth: * = undefined;
			var e: * = _arg1;
			t = e.currentTarget;
			if (t.Par) {
				t = t.Par;
			};
			main.hint.HintOff();
			if (t.t) {
				t.t.Press();
			};
			if (t.Radio != undefined) {
				if (todo.useRadio == undefined) {
					todo.useRadio = t.Radio;
					chat.mainDlg.CreateSoundIcon("Radio", 2);
				};
				todo.useRadio = t.Radio;
				return;
			};
			if (t.Gifts) {
				OpenGifts(t.Gifts);
			} else {
				if (t.xNum) {
					if ((global.xc & 0x0800)) {
						global.gUserNo = t.UserNo;
						main.mcLoad.OpenByN(t.xNum);
					} else {
						xatlib.GotoXat(t.xNum);
					};
				} else {
					if (t.UserNo) {
						PressUserName(t.UserNo, e.ctrlKey);
					} else {
						if (t.Power != undefined) {
							self = xatlib.FindUser(todo.w_userno);
							if (todo.HasPower(self, t.Power)) {
								xatlib.GeneralMessage(xconst.ST(237), xconst.ST(238, xconst.pssa[(t.Power + 1)]), 0);
								Dia = main.box_layer.GeneralMessageH.Dia;
								w = Dia.DiaBack.width;
								h = Dia.DiaBack.height;
								x = Dia.DiaBack.x;
								y = Dia.DiaBack.y;
								f = 8;
								d = int((w / ((f * 2) + 3)));
								w1 = int(((w * f) / ((f * 2) + 3)));
								w2 = w1;
								buth = 22;
								new xBut(Dia, (((x + w) - d) - w1), (((y + h) - buth) - 20), w1, buth, "UnAssign", function (_arg1) {
									AssignRel(0, t);
								});
								new xBut(Dia, (x + d), (((y + h) - buth) - 20), w2, buth, "Assign", function (_arg1) {
									AssignRel(1, t);
								});
								return
							};
						} else {
							self = xatlib.FindUser(todo.w_userno);
							if (t.SF & 1 || t.SF & 2) {
								if (t.Radio == undefined) {
									if (todo.HasPower(self, xconst.pssh["click"])) {
										main.textfield2.appendText(t.ClickCode);
										main.textfield2.setSelection(main.textfield2.text.length, main.textfield2.text.length);
									}
								}
							}
						};
					};
				};
			};
		}
		public static function OpenGifts(param1:*, param2:int = 1):* {
			var _loc3_:* = xatlib.FindUser(param1);
			if (_loc3_ < 0) {
				return;
			}
			
			chat.mainDlg.UpdateBackground(0, param1);

			todo.config["giftid"] = param1 + "," + (!!todo.Users[_loc3_].registered?todo.Users[_loc3_].registered:"") + (param1 == todo.w_userno?"," + todo.w_d3 + "," + todo.w_dt:"");
			if (param2 == 0) {
				return;
			}
			if (param2 == 2) {
				if (chat.sending_lc) {
					chat.sending_lc.send(chat.fromxat,"onMsg",9,"config",todo.config);
				}
				return;
			}
			if (global.xc & 2048) {
				main.mcLoad.OpenByN(20044);
			}
		}
			
		private static function AssignRel(_arg1, _arg2) {
			main.box_layer.GeneralMessageH.Delete();
			var _local3: * = new XMLDocument();
			var _local4: * = _local3.createElement("ap");
			_local4.attributes.p = xatlib.xInt(_arg2.Power)
				.toString();
			_local4.attributes.a = _arg1;
			_local3.appendChild(_local4);
			var _local5: String = xatlib.XMLOrder(_local3, new Array("p", "a"));
			network.socket.send(_local5);
		}
		public static function SmilieLoad(_arg1: Event) {
			_arg1.currentTarget.del--;
			if (_arg1.currentTarget.del < 0) {
				_arg1.currentTarget.ns = new smiley(_arg1.currentTarget, _arg1.currentTarget.t);
				_arg1.currentTarget.removeEventListener(Event.ENTER_FRAME, SmilieLoad);
			};
		}
		public static function DoSound(_arg1: MouseEvent) {
			if (_arg1.currentTarget.SF) {
				main.PlayMusic(_arg1.currentTarget.SA);
				return;
			};
			main.ProcessSounds(_arg1.currentTarget.Snd, true);
		}
		
        public static function BuildUserList(){
            var _local_26:*;
            var _local_27:*;
            var _local_28:*;
            var _local_29:*;
            var _local_33:*;
            var _local_34:*;
            var _local_35:*;
            var _local_36:*;
            var _local_37:*;
            var _local_38:*;
            var _local_39:Boolean;
            var _local_40:*;
            var _local_41:*;
            var _local_42:*;
            var _local_1:* = (1 << 19);
            var _local_2:* = (1 << 17);
            var _local_3:* = (1 << 16);
            var _local_4:* = (5 << 13);
            var _local_5:* = (4 << 13);
            var _local_6:* = (3 << 13);
            var _local_7:* = (2 << 13);
            var _local_8:* = (1 << 13);
            var _local_9:* = (3 << 11);
            var _local_10:* = (2 << 11);
            var _local_11:* = (1 << 11);
            var _local_12:* = (5 << 8);
            var _local_13:* = (4 << 8);
            var _local_14:* = (3 << 8);
            var _local_15:* = (2 << 8);
            var _local_16:* = (1 << 8);
            var _local_17:* = (1 << 7);
            var _local_18:* = (1 << 6);
            var _local_19:* = (1 << 5);
            var _local_20:* = getTimer();
            var _local_21:* = -1;
            var _local_22:Boolean = ((((!(main.ctabsmc.TabIsPrivate())) && ((todo.Pools.length > 1)))) && (main.utabsmc.tabs[0].Main));
            DeleteUserList();
            var _local_23:* = getTimer();
            var _local_24:* = new Object();
            var _local_25:* = todo.Users.length;
            poin = new Array();
            if (((main.utabsmc.tabs[0].Main) || (main.utabsmc.tabs[1].Main))){
                _local_26 = 0;
                while (_local_26 < _local_25) {
                    _local_28 = todo.Users[_local_26];
                    _local_33 = 0;
                    if (_local_28.u == todo.w_userno){
                        _local_33 = _local_1;
                    };
                    _local_29 = false;
                    if (_local_28.online == true){
                        _local_29 = true;
                    } else {
                        if ((((main.utabsmc.tabs[1].Main == true)) && ((_local_28.onsuper == true)))){
                            _local_29 = true;
                        };
                    };
                    if (_local_29){
                        _local_33 = (_local_33 + _local_2);
                    };
                    if (main.utabsmc.tabs[1].Main){
                        if (((!(_local_29)) && (_local_28.available))){
                            _local_33 = (_local_33 + _local_8);
                        };
                    } else {
                        if (!((_local_28.banned) && (!((_local_28.flag0 & 131072))))){
                            _local_33 = (_local_33 + _local_3);
                        };
                        if (!_local_28.Stealth){
                            if (_local_28.mainowner){
                                _local_33 = (_local_33 + _local_4);
                            };
                            if (_local_28.owner){
                                _local_33 = (_local_33 + _local_5);
                            };
                            if (_local_28.moderator){
                                _local_33 = (_local_33 + _local_6);
                            };
                            if (_local_28.member){
                                _local_33 = (_local_33 + _local_7);
                            };
                        };
                    };
                    if (((todo.w_d2) && ((todo.w_d2 == _local_28.u)))){
                        _local_33 = (_local_33 + _local_9);
                    } else {
                        switch ((_local_28.friend & 11)){
                            case 9:
                                if (todo.goodfriend){
                                    _local_33 = (_local_33 + _local_9);
                                    break;
                                };
                            case 1:
                                _local_33 = (_local_33 + _local_11);
                                break;
                        };
                    };

					if (todo.HasPower(_local_26, xconst.pssh["everypower"])) {
						_local_33 = _local_33 + _local_12;
					} else if (todo.HasPower(_local_26, xconst.pssh["ruby"])) {
						_local_33 = _local_33 + _local_13;
					} else if (todo.HasPower(_local_26, xconst.pssh["gold"])) {
						_local_33 = _local_33 + _local_14;
					} else if (todo.HasPower(_local_26, xconst.pssh["purple"])) {
						_local_33 = _local_33 + _local_15;
					} else if (todo.HasPower(_local_26, xconst.pssh["yellow"])) {
						_local_33 = _local_33 + _local_15;
					} /*else if (todo.HasPower(_local_26, xconst.pssh["pink"])) {
						_local_33 = _local_33 + _local_15;
					}*/ else if (todo.HasPower(_local_26, xconst.pssh["topman"])) {
						_local_33 = _local_33 + _local_16;
					}
					
                    if (_local_28.registered != undefined){
                        _local_35 = _local_28.registered.length;
                        if (_local_35 <= 9){
                            _local_33 = (_local_33 + (_local_17 - _local_35));
                        };
                    };
                    if (_local_28.OnXat){
                        _local_33 = (_local_33 + _local_18);
                    };
                    _local_34 = todo.HasPower(_local_26, xconst.pssh["reghide"]);
                    if (!_local_34){
                        if (_local_28.registered){
                            _local_33 = (_local_33 + _local_19);
                        };
                    };
                    _local_33 = (_local_33 + 16);
                    _local_33 = (_local_33 * 50000000000);
                    _local_33 = (_local_33 - (_local_28.u * 2));
                    _local_33 = (_local_33 * 2);
                    poin.push({
                        "points":_local_33,
                        "index":_local_26
                    });
                    if (_local_28.Bride){
                        _local_24[_local_28.u] = {
                            "b":_local_28.Bride,
                            "index":(poin.length - 1)
                        };
                    };
                    _local_26++;
                };
                for (_local_26 in _local_24) {
                    _local_27 = _local_24[_local_26].b;
                    if (((_local_24[_local_27]) && ((_local_26 == _local_24[_local_27].b)))){
                        _local_36 = poin[_local_24[_local_26].index].points;
                        _local_37 = poin[_local_24[_local_27].index].points;
                        if (_local_36 > _local_37){
                            poin[_local_24[_local_27].index].points = (_local_36 * 0.99999999999);
                        } else {
                            poin[_local_24[_local_26].index].points = (_local_37 * 0.99999999999);
                        };
                    };
                };
            } else {
                _local_26 = 0;
                while (_local_26 < _local_25) {
                    poin.push({
                        "points":todo.Users[_local_26].TickCnt,
                        "index":_local_26
                    });
                    _local_26++;
                };
            };
            poin.sortOn("points", (Array.DESCENDING | Array.NUMERIC));
            if (todo.DoBuildUserListScrollUp){
                if (((!(todo.bMobile)) && (!((main.uscrollmc.Scrolling == true))))){
                    main.uscrollmc.position = 0;
                    main.onUserScrollChange();
                };
            };
            var _local_30:* = 0;
            if (_local_22){
                _local_30 = main.LookupPool(todo.w_pool);
                AddPoolToList(_local_30);
            };
            useryc2 = useryc;
            var _local_31:* = todo.Users.length;
            var _local_32:* = 0;
            while (_local_32 < _local_31) {
                _local_38 = poin[_local_32].index;
                todo.Users[_local_38].Vis = false;
                todo.Users[_local_38].ignored = network.OnIgnoreList(todo.Users[_local_38].u);
                if (todo.Users[_local_38].u != -1){
                    _local_39 = false;
                    if (main.utabsmc.tabs[1].Main){
                        _local_39 = ((todo.Users[_local_38].friend) || ((xatlib.xInt(todo.Users[_local_38].Location) >= 128)));
                        if (todo.Users[_local_38].u == todo.w_userno){
                            _local_39 = false;
                        };
                    } else {
                        if (main.utabsmc.tabs[0].Main){
                            if (main.ctabsmc.TabIsPrivate()){
                                if (main.ctabsmc.TabUser() == todo.Users[_local_38].u){
                                    _local_39 = true;
                                };
                            } else {
                                _local_39 = !((todo.Users[_local_38].online == undefined));
                                _local_40 = todo.Message.length;
                                if ((((todo.Users[_local_38].online == false)) && ((_local_40 < 40)))){
                                    _local_39 = false;
                                    _local_41 = 0;
                                    while (_local_41 < _local_40) {
                                        if ((todo.Message[_local_41].u == todo.Users[_local_38].u)){
                                            _local_39 = true;
                                            break;
                                        };
                                        _local_41++;
                                    };
                                };
                            };
                            if (todo.w_userno == todo.Users[_local_38].u){
                                _local_39 = true;
                            };
                        } else {
                            _local_39 = todo.Users[_local_38].TickCnt;
                        };
                    };
                    if (_local_39){
                        todo.Users[_local_38].Vis = true;
                        DoBride(_local_38);
                        if ((((((_local_21 >= 0)) && ((todo.Users[_local_38].Bride == todo.Users[_local_21].u)))) && ((todo.Users[_local_21].Bride == todo.Users[_local_38].u)))){
                            DoBride(_local_38, 1);
                            DoBride(_local_21, 1);
                            if ((todo.Users[_local_38].aFlags & 1)){
                                todo.Users[_local_21].M_St = (todo.Users[_local_21].M_St | 16);
                            } else {
                                todo.Users[_local_21].M_St = (todo.Users[_local_21].M_St | 32);
                            };
                        };
                        AddUserToList(_local_21);
                        _local_21 = _local_38;
                    };
                };
                _local_32++;
            };
            AddUserToList(_local_21);
            if (_local_22){
                _local_42 = 0;
                while (_local_42 < todo.Pools.length) {
                    if (_local_42 != _local_30){
                        AddPoolToList(_local_42);
                    };
                    _local_42++;
                };
            };
            useryc3 = useryc;
        }
		
		/*
		public static function BuildUserList():*
		{
			var _local_7:*;
			var _local_8:*;
			var _local_12:*;
			var _local_13:*;
			var _local_14:*;
			var _local_15:*;
			var _local_16:*;
			var _local_17:*;
			var _local_18:Boolean;
			var _local_19:*;
			var _local_20:*;
			var _local_21:*;
			var _local_1:* = getTimer();
			var _local_2:* = -1;
			var _local_3:Boolean = (((!(main.ctabsmc.TabIsPrivate())) && (todo.Pools.length > 1)) && (main.utabsmc.tabs[0].Main));
			DeleteUserList();
			var _local_4:* = getTimer();
			var _local_5:* = new Object();
			var _local_6:* = todo.Users.length;
			poin = new Array();
			if (((main.utabsmc.tabs[0].Main) || (main.utabsmc.tabs[1].Main)))
			{
				_local_7 = 0;
				while (_local_7 < _local_6)
				{
					_local_12 = 0;
					if (todo.Users[_local_7].u == todo.w_userno)
					{
						_local_12 = 40000;
					};
					if (todo.Users[_local_7].online == true)
					{
						_local_12 = (_local_12 + 20000);
					}
					else
					{
						if (((main.utabsmc.tabs[1].Main == true) && (todo.Users[_local_7].onsuper == true)))
						{
							_local_12 = (_local_12 + todo.Users[_local_7].available == true ? 19999 : 20000);
						};
					};
					if (!((todo.Users[_local_7].banned) && (!(todo.Users[_local_7].flag0 & 0x020000))))
					{
						_local_12 = (_local_12 + 10000);
					};
					if (!todo.Users[_local_7].Stealth)
					{
						if (todo.Users[_local_7].mainowner)
						{
							_local_12 = (_local_12 + 4800);
						};
						if (todo.Users[_local_7].owner)
						{
							_local_12 = (_local_12 + 3600);
						};
						if (todo.Users[_local_7].moderator)
						{
							_local_12 = (_local_12 + 2400);
						};
						if (todo.Users[_local_7].member)
						{
							_local_12 = (_local_12 + 1200);
						};
					};
					if (todo.Users[_local_7].friend)
					{
						_local_12 = (_local_12 + 600);
					};

					if (todo.HasPower(_local_7, xconst.pssh["everypower"])) {
						_local_12 = _local_12 + 550;
					} else if (todo.HasPower(_local_7, xconst.pssh["ruby"])) {
						_local_12 = _local_12 + 500;
					} else if (todo.HasPower(_local_7, xconst.pssh["gold"])) {
						_local_12 = _local_12 + 450;
					} else if (todo.HasPower(_local_7, xconst.pssh["purple"])) {
						_local_12 = _local_12 + 400;
					} else if (todo.HasPower(_local_7, xconst.pssh["yellow"])) {
						_local_12 = _local_12 + 350;
					} else if (todo.HasPower(_local_7, xconst.pssh["pink"])) {
						_local_12 = _local_12 + 350;
					} else if (todo.HasPower(_local_7, xconst.pssh["topman"])) {
						_local_12 = _local_12 + 300;
					}

					if (todo.Users[_local_7].registered != undefined)
					{
						_local_14 = todo.Users[_local_7].registered.length;
						if (_local_14 <= 9)
						{
							_local_12 = (_local_12 + (150 - _local_14));
						};
					};
					if (todo.Users[_local_7].OnXat)
					{
						_local_12 = (_local_12 + 75);
					};
					_local_13 = todo.HasPower(_local_7, 9);
					if (!_local_13)
					{
						if (todo.Users[_local_7].registered)
						{
							_local_12 = (_local_12 + 38);
						};
					};
					_local_12 = (_local_12 + 16);
					_local_12 = (_local_12 * 50000000000);
					_local_12 = (_local_12 - (todo.Users[_local_7].u * 2));
					_local_12 = (_local_12 * 2);
					poin.push({
						"points":_local_12,
						"index":_local_7
					});
					if (todo.Users[_local_7].Bride)
					{
						_local_5[todo.Users[_local_7].u] = {
							"b":todo.Users[_local_7].Bride,
							"index":(poin.length - 1)
						};
					};
					_local_7++;
				};
				for (_local_7 in _local_5)
				{
					_local_8 = _local_5[_local_7].b;
					if (((_local_5[_local_8]) && (_local_7 == _local_5[_local_8].b)))
					{
						_local_15 = poin[_local_5[_local_7].index].points;
						_local_16 = poin[_local_5[_local_8].index].points;
						if (_local_15 > _local_16)
						{
							poin[_local_5[_local_8].index].points = (_local_15 - 1);
						}
						else
						{
							poin[_local_5[_local_7].index].points = (_local_16 - 1);
						};
					};
				};
			}
			else
			{
				_local_7 = 0;
				while (_local_7 < _local_6)
				{
					poin.push({
						"points":todo.Users[_local_7].TickCnt,
						"index":_local_7
					});
					_local_7++;
				};
			};
			poin.sortOn("points", (Array.DESCENDING | Array.NUMERIC));
			if (todo.DoBuildUserListScrollUp)
			{
				if (((!(todo.bMobile)) && (!(main.uscrollmc.Scrolling == true))))
				{
					main.uscrollmc.position = 0;
					main.onUserScrollChange();
				};
			};
			var _local_9:* = 0;
			if (_local_3)
			{
				_local_9 = main.LookupPool(todo.w_pool);
				AddPoolToList(_local_9);
			};
			useryc2 = useryc;
			var _local_10:* = todo.Users.length;
			var _local_11:* = 0;
			while (_local_11 < _local_10)
			{
				_local_17 = poin[_local_11].index;
				todo.Users[_local_17].Vis = false;
				todo.Users[_local_17].ignored = network.OnIgnoreList(todo.Users[_local_17].u);
				if (todo.Users[_local_17].u != -1)
				{
					_local_18 = false;
					if (main.utabsmc.tabs[1].Main)
					{
						_local_18 = ((todo.Users[_local_17].friend) || (xatlib.xInt(todo.Users[_local_17].Location) >= 128));
						if (todo.Users[_local_17].u == todo.w_userno)
						{
							_local_18 = false;
						};
					}
					else
					{
						if (main.utabsmc.tabs[0].Main)
						{
							if (main.ctabsmc.TabIsPrivate())
							{
								if (main.ctabsmc.TabUser() == todo.Users[_local_17].u)
								{
									_local_18 = true;
								};
							}
							else
							{
								_local_18 = (!(todo.Users[_local_17].online == undefined));
								_local_19 = todo.Message.length;
								if (((todo.Users[_local_17].online == false) && (_local_19 < 40)))
								{
									_local_18 = false;
									_local_20 = 0;
									while (_local_20 < _local_19)
									{
										if ((todo.Message[_local_20].u == todo.Users[_local_17].u))
										{
											_local_18 = true;
											break;
										};
										_local_20++;
									};
								};
							};
							if (todo.w_userno == todo.Users[_local_17].u)
							{
								_local_18 = true;
							};
						}
						else
						{
							_local_18 = todo.Users[_local_17].TickCnt;
						};
					};
					if (_local_18)
					{
						todo.Users[_local_17].Vis = true;
						DoBride(_local_17);
						if ((((_local_2 >= 0) && (todo.Users[_local_17].Bride == todo.Users[_local_2].u)) && (todo.Users[_local_2].Bride == todo.Users[_local_17].u)))
						{
							DoBride(_local_17, 1);
							DoBride(_local_2, 1);
							if ((todo.Users[_local_17].aFlags & 0x01))
							{
								todo.Users[_local_2].M_St = (todo.Users[_local_2].M_St | 0x10);
							}
							else
							{
								todo.Users[_local_2].M_St = (todo.Users[_local_2].M_St | 0x20);
							};
						};
						AddUserToList(_local_2);
						_local_2 = _local_17;
					};
				};
				_local_11++;
			};
			AddUserToList(_local_2);
			if (_local_3)
			{
				_local_21 = 0;
				while (_local_21 < todo.Pools.length)
				{
					if (_local_21 != _local_9)
					{
						AddPoolToList(_local_21);
					};
					_local_21++;
				};
			};
			useryc3 = useryc;
		}
		*/

		public static function DoBride(_arg1, _arg2 = 0) {
			todo.Users[_arg1].M_St = 0;
			if (todo.Users[_arg1].registered == undefined) {
				return;
			};
			if (todo.HasPower(_arg1, xconst.pssh["reghide"])) {
				return;
			};
			if (((todo.Users[_arg1].Bride) && (!(_arg2)))) {
				if ((todo.Users[_arg1].aFlags & 1)) {
					todo.Users[_arg1].M_St = 4;
				} else {
					todo.Users[_arg1].M_St = 2;
				};
			} else {
				todo.Users[_arg1].M_St = 1;
			};
			if (((!(todo.Users[_arg1].VIP)) || (todo.HasPower(_arg1, xconst.pssh["subhide"])))) {
				todo.Users[_arg1].M_St = (todo.Users[_arg1].M_St | 8);
			};
			todo.Users[_arg1].M_St = (todo.Users[_arg1].M_St | 128);
		}
		public static function ClearLists(_arg1: Boolean) {
			var _local4: * ;
			var _local5: * ;
			var _local2: * = 0;
			var _local3: * = todo.Message.length;
			p = null;
			_local5 = 0;
			while (_local5 < _local3) {
				if ((todo.Message[_local2].s & 2)) {
					_local2++;
				} else {
					xmessage.DeleteOneMessageMc(_local2);
					todo.Message.splice(_local2, 1);
				};
				_local5++;
			};
			DeleteUserList(1);
			_local4 = 0;
			while (_local4 < todo.Users.length) {
				if (((((_arg1) || (!((todo.Users[_local4].u == todo.w_userno))))) && ((xatlib.xInt(todo.Users[_local4].Location) < 128)))) {
					todo.Users.splice(_local4, 1);
				} else {
					_local4++;
				};
			};
		}
		public static function DeleteOneUserMc(_arg1: Number) {
			if (_arg1 < 0) {
				return;
			};
			var _local2: * = todo.Users[_arg1];
			if (!_local2) {
				return;
			};
			if (!_local2.mc) {
				return;
			};
			if (((_local2.mc.av1) && (_local2.mc.parent))) {
				_local2.mc.parent.removeChild(_local2.mc.av1);
			};
			_local2.mc.av1 = undefined;
			if (_local2.mc.parent) {
				_local2.mc.parent.removeChild(_local2.mc);
			};
			_local2.mc = undefined;
			todo.DoBuildUserList = true;
		}
		public static function DeleteAllWith(_arg1: Number) {
			var _local2: Object = undefined;
			for (var uid in todo.Users) {
				_local2 = todo.Users[xatlib.FindUser(uid)];
				if (Number(_arg1) == Number(_local2.u)) {
					if (((_local2.mc.av1) && (_local2.mc.parent))) {
						_local2.mc.parent.removeChild(_local2.mc.av1);
					};
					_local2.mc.av1 = undefined;
					if (_local2.mc.parent) {
						_local2.mc.parent.removeChild(_local2.mc);
					};
					_local2.mc = undefined;
				}
			}

			todo.DoBuildUserList = true;
		}
		public static function DeleteUserList(_arg1 = false) {
			var _local4: * ;
			useryc = 9;
			while (1) {
				_local4 = main.uMessLst.pop();
				if (!_local4) {
					break;
				};
				if (_local4.av1 != undefined) {
					_local4.removeChild(_local4.av1);
				};
				if (_local4.parent) {
					_local4.parent.removeChild(_local4);
				};
			};
			var _local2: * = todo.Users.length;
			var _local3: * = 0;
			while (_local3 < _local2) {
				if (_arg1) {
					DeleteOneUserMc(_local3);
				} else {
					if (todo.Users[_local3] == undefined) {} else {
						if (todo.Users[_local3].mc == undefined) {} else {
							todo.Users[_local3].mc.visible = false;
							if (todo.Users[_local3].mc.av1 == undefined) {} else {
								todo.Users[_local3].mc.av1.visible = false;
								if (todo.Users[_local3].mc.av1.Gag) {
									todo.Users[_local3].mc.av1.HatsOff();
								};
							};
						};
					};
				};
				_local3++;
			};
		}
		public static function AddPoolToList(_arg1: Number) {
			var _local6: * ;
			var _local7: * ;
			var _local8: * ;
			if (main.utabsmc.tabs[0].Main == false) {
				return;
			};
			var _local2: int = xatlib.xInt(todo.Pools[_arg1]);
			var _local3: * = xatlib.xInt(((xatlib.xInt(todo.w_useroom) + _local2) % xconst.pool1.length));
			var _local4: * = xatlib.xInt((xatlib.xInt(todo.w_useroom) - _local2));
			if (_local4 < 0) {
				_local4 = (2147483647 - _local4);
			};
			_local4 = (_local4 % xconst.pool2.length);
			var _local5: * = ((xconst.pool1[_local3] + " ") + xconst.pool2[_local4]);
			if ((((_local2 < 3)) && (((_local6 = todo.gconfig["g114"]) is Object)))) {
				switch (_local2) {
					case 0:
						_local7 = _local6["m"];
						break;
					case 1:
						_local7 = _local6["t"];
						break;
					case 2:
						if (todo.HasPowerA(todo.w_GroupPowers, xconst.pssh["banpool"])) {
							_local7 = _local6["b"];
						};
						break;
				};
				if (((_local7) && ((_local7.length > 2)))) {
					_local5 = _local7;
					if (_local2 >= 1) {
						_local8 = (((_local2 == 1)) ? xatlib.RankColor(xatlib.NoToRank(_local6["rnk"])) : 0x964B00);
					};
				};
			};
			var _local9: * = new xBut(main.mcuserbackground, 4, (useryc + 3), (main.upw - xatlib.NX(24)), 20, _local5, PoolPressed, 0, 5);
			if (_local8) {
				xatlib.McSetRGB(_local9.but_back, _local8);
				_local9.SetTextCol(0);
			};
			_local9.But.w = _arg1;
			main.uMessLst.push(_local9);
			useryc = (useryc + 23);
		}
		public static function PoolPressed(_arg1: MouseEvent) {
			if (todo.Pools[_arg1.currentTarget.w] != todo.w_pool) {
				network.NetworkSetPool(todo.Pools[_arg1.currentTarget.w]);
			};
		}
		public static function AddUserToList(_arg1: Number) {
			var _local8:*;
			var _local9:MovieClip;
			var _local10:*;
			var _local11:*;
			var _local12:*;
			var _local13:*;
			var _local14:*;
			var _local15:*;
			var _local16:*;
			var _local17:*;
			var _local18:*;
			var _local19:*;
			var _local20:*;
			var _local21:*;
			var _local22:*;
			var _local23:*;
			var _local24:*;
			var _local25:*;
			var _local26:*;
			var _local27:*;
			if (_arg1 < 0) {
				return;
			};
			var _local2: Number = todo.Users[_arg1].u;
			var _local3: String = todo.Users[_arg1].n;
			if (todo.HasPowerA(todo.w_Powers, xconst.pssh["nick"], todo.w_Mask)) {
				_local3 = xatlib.GetNick(_local3, _local2);
			};
			var _local4: * = 0;
			var _local5: * = ((((((todo.Users[_arg1].s) && (todo.HasPower(_arg1, xconst.pssh["status"])))) && ((((todo.Macros == undefined)) || ((todo.Macros["SetStatus"] == undefined)))))) && (!(todo.Users[_arg1].banned)));
			var _local6: * = undefined;
			if (((main.utabsmc.tabs[2]) && (main.utabsmc.tabs[2].Main))) {
				_local6 = "tickle";
			};
			if (((((((((((((((((main.utabsmc.tabs[0].Main) && ((xconst.f_Live & todo.FlagBits)))) && (!(todo.Users[_arg1].mainowner)))) && (!(todo.Users[_arg1].owner)))) && (!(todo.Users[_arg1].moderator)))) && (!(todo.Users[_arg1].member)))) && (!((todo.Users[_arg1].u == 0xFFFFFFFF))))) && (!((todo.Users[_arg1].u == todo.w_userno))))) && (!((todo.Users[_arg1].u == 0))))) {
				return;
			};
			_local3 = ("<l>" + _local3);
			var _local7: * = (((useryc < ((main.uph + main.uscrollmc.Scr_position) + 16))) && ((useryc > (main.uscrollmc.Scr_position - 16))));
			if (((!(_local7)) && (!((todo.Users[_arg1].mc == undefined))))) {
				DeleteOneUserMc(_arg1);
			};
			if ((((todo.Users[_arg1].mc == undefined)) && (_local7))) {
				if (_local6) {
					_local8 = new xSprite();
					new smiley(_local8, _local6);
				} else {
					_local8 = new chatter2();
					_local8.Options = 0x80000000;
					if ((((_local2 == todo.w_userno)) && ((todo.Users[_arg1].flag0 & 0x0400)))) {
						_local8.alpha = 0.2;
					};
					_local12 = undefined;
					_local13 = 0xC000;
					if ((todo.Users[_arg1].flag0 & 0x0800)) {
						_local8.Options |= chatter2.Mob;
					};
					_local14 = true;
					if (main.utabsmc.tabs[0].Main == true) {
						if (todo.Users[_arg1].online) {
							if (todo.HasPower(_arg1, xconst.pssh["pink"])) {
								if (todo.Users[_arg1].member) {
									_local13 = 0x6565FF;
									_local12 = 16716947;
								} else {
									_local12 = 16738740;
								};
							};
							/*
							if (todo.HasPower(_arg1, xconst.pssh["pink"])) {
								_local12 = 16716947;
							};
							*/
							if (todo.HasPower(_arg1, xconst.pssh["blueman"])) {
								_local12 = 128;
							};

							if (todo.Users[_arg1].member) {
								_local13 = 0x6565FF;
							}

							if (todo.Users[_arg1].moderator) {
								_local14 = false;
								_local13 = 0xFFFFFF;
							};
							if (!todo.Users[_arg1].Stealth) {
								if (((todo.Users[_arg1].owner) || (todo.Users[_arg1].mainowner))) {
									_local14 = false;
									_local13 = 0xFF9900;
								};
							};

							var special = false;
							var special2 = false;
							if (todo.HasPower(_arg1, xconst.pssh["fadepawn"])) {
								special2 = 'p1fade';
							}
							if (todo.Users[_arg1].custom_pawn != undefined) {
								_local14 = true;
								_local12 = xatlib.DecodeColor(todo.Users[_arg1].custom_pawn);

								if (todo.HasPower(_arg1, xconst.pssh["sapphire"]) || todo.HasPower(_arg1, xconst.pssh["ruby"])) {
									special = 'p1ruby';
								}

								if (todo.HasPower(_arg1, xconst.pssh["everypower"])) {
									special = 'p1emerald';
								}

							} else {
								if (todo.HasPower(_arg1, xconst.pssh["cyclepawn"])) {
									_local14 = true;
									_local12 = 0x6424eb;
									special = 'p1cyclepawn';
								}

								if (todo.HasPower(_arg1, xconst.pssh["tecno"])) {
									_local14 = true;
									_local12 = 0xffffff;
									special = 'p1tecno';
								}

								if (todo.HasPower(_arg1, xconst.pssh["tempawn"])) {
									_local14 = true;
									_local12 = 0xffffff;
									special = 'p1tempawn';
								}

								if (todo.HasPower(_arg1, xconst.pssh["sapphire"])) {
									_local14 = true;
									_local12 = 0xff;
									special = 'p1ruby';
								}

								if (todo.HasPower(_arg1, xconst.pssh["yellow"])) {
									_local14 = true;
									_local12 = 16776960;
								};

								if (todo.HasPower(_arg1, xconst.pssh["purple"])) {
									_local14 = true;
									_local12 = 0x800080;
								};

								if (todo.HasPower(_arg1, xconst.pssh["rainbowpawn"])) {
									_local14 = true;
									_local12 = 0xffffff;
									special = 'p1rainbow';
								}

								if (todo.HasPower(_arg1, xconst.pssh["awepawn"])) {
									_local14 = true;
									_local12 = 0xffffff;
									special = 'p1awesome';
								}

								if (todo.HasPower(_arg1, xconst.pssh["gold"])) {
									_local14 = true;
									_local12 = 16041823;
									special = 'p1gold';
								};

								if (todo.HasPower(_arg1, xconst.pssh["ruby"])) {
									_local14 = true;
									_local12 = 14423100;
									special = 'p1ruby';
								}
								
								if (todo.HasPower(_arg1, xconst.pssh["everypower"])) {
									_local14 = true;
									_local12 = 1089554;
									special = 'p1emerald';
								}
							}
							if (todo.Users[_arg1].volunteer) {
								_local14 = true;
								_local12 = 0xC1E0FF; // 0xffffff;
								//special = 'p1morph';
							};
							if ((todo.Users[_arg1].aFlags & (1 << 21))) {
								_local14 = true;
								_local12 = 1304549;
							};
							if (((!(todo.HasPower(_arg1, xconst.pssh["flashrank"]))) || (todo.bThin))) {
								if (((!(_local14)) || ((_local12 == undefined)))) {
									_local12 = _local13;
								};
								_local13 = undefined;
							};
						} else {
							if (((!(main.ctabsmc.TabIsPrivate())) || (!((todo.Users[_arg1].onsuper == true))))) {
								_local13 = 0xFF0000;
							};
						};
						if (_local13 != 0xFF0000) {
							if (todo.Users[_arg1].ignored) {
								_local13 = 0x606060;
								_local12 = undefined;
							};
							if (((todo.Users[_arg1].banned) && (!((todo.Users[_arg1].flag0 & 131072))))) {
								_local13 = 0x964B00;
								_local12 = undefined;
							};
						};
					} else {
						if (todo.Users[_arg1].ignored) {
							_local13 = 0x606060;
						};
						if (todo.Users[_arg1].onsuper != true) {
							_local13 = 0xFF0000;
						} else {
							if (todo.Users[_arg1].available) {
								_local13 = 0xFF5800;
							};
						};
					};
					if (_local12 == undefined) {
						_local12 = _local13;
						_local13 = undefined;
					};
					_local8.ColP1 = _local12;
					_local8.ColP2 = _local13;
				};
				_local8.UserNo = _local2;
				main.mcuserbackground.addChild(_local8);
				_local8.x = 5;
				_local8.addEventListener(MouseEvent.ROLL_OVER, ChatterRollover);
				_local8.addEventListener(MouseEvent.ROLL_OUT, main.hint.HintOff);
				_local8.addEventListener(MouseEvent.MOUSE_DOWN, ChatterOnPress);
				_local8.buttonMode = true;
				

				if (_local14 == true) {
					switch(special) {
						case "p1gold":
						case "p1ruby":
						case "p1emerald":
						//case "p1morph":
						case "p1awesome":
							_local8.Pawn = special;
							if (todo.HasPower(_arg1, xconst.pssh["purple"]) && todo.Users[_arg1].Powers[0] & 1) {
								_local8.Options |= chatter2.flash;
							};
							break;
						default:
							if (special == 'p1cyclepawn') {
								_local8.Pawn = special;
								if (((todo.HasPower(_arg1, xconst.pssh["cyclepawn"])) && ((todo.Users[_arg1].Powers[0] & 1)))) {
									_local8.Options |= chatter2.flash;
								};
								if (todo.Users[_arg1].cyclepawn != undefined) {
									_local8.cyclepawn = todo.Users[_arg1].cyclepawn;
								}
							}

							if (special == 'p1tecno') {
								_local8.Pawn = special;
								if (todo.HasPower(_arg1, xconst.pssh["tecno"]) && todo.Users[_arg1].Powers[0] & 1) {
									_local8.Options |= chatter2.flash;
								};
							}

							if (special == 'p1tempawn') {
								_local8.Pawn = special;
								if (todo.HasPower(_arg1, xconst.pssh["tempawn"]) && todo.Users[_arg1].Powers[0] & 1) {
									_local8.Options |= chatter2.flash;
								};
							}

							if (special == 'p1rainbow') {
								_local8.Pawn = special;
								if (todo.HasPower(_arg1, xconst.pssh["rainbowpawn"]) && todo.Users[_arg1].Powers[0] & 1) {
									_local8.Options |= chatter2.flash;
								};
							}
							break;
					}

					if (special2 == 'p1fade') {
						_local8.Pawn2 = "p1fade";
					};
				}
				todo.Users[_arg1].epcode = undefined;
				if (todo.HasPower(_arg1, xconst.pssh["hat"])) {
					while (1) {
						/*
						if code[0] == "E"
							ep color = code char 1
							code substr 2
						if code[0] != "h"
							hat code = code char 0
						code subtr 1
						if code[0] == "F"
							flag code = code substr 1

						(E([grkbpwy]))?(\w)([^A-Z]+)(F(\w+))?
						 E p			r   pcess    F us

						*/
						_local15 = todo.Users[_arg1].n.split("(hat"); // "name(hat", "#EkrFus#ff8800)rest""
						if (_local15[1] == undefined) break;
						_local15 = _local15[1].split(")"); // "#EkrFus#ff8800", ")rest
						_local16 = _local15[0].split("#"); // "", "EkrFus", "ff8800"
						if (_local16[1] == undefined) break;
						_local17 = _local16[1]; // EkrFus
						if (!_local17) break;

						// _local17 = EkrFus // START CODE for flgpwn fix

						if (!_local17.charAt(0)) break;
						/*
						if (_local17.charAt(0) == "E" && todo.HasPower(_arg1, xconst.pssh["everypower"])) {
							todo.Users[_arg1].epcode = _local17; //EkrFus
							_local17 = _local17.substr(2); // rFus
						}
						*/
						if (todo.HasPower(_arg1, xconst.pssh["everypower"])){
							if (_local18 === "E"){
								todo.Users[_arg1].epcode = _local17;
								if (!_local17.charAt(2)) break;
								_local17 = _local17.substr(2);
								_local18 = _local17.charAt(0);
							} else {
								todo.Users[_arg1].epcode = undefined;
							};
						};

						_local18 = _local17.charAt(0); // r
						if (!_local18) break;
						_local17 = _local17.substr(1); // Fus

						if (xconst.Pawns && network.YC < xconst.Pawns["time"]) {
							var pawned = false;
							//while (_local17) {
							for(var i = 0; i < 2; i++) {
								if (_local17.length == 0) break;
								var pawn;
								if (_local17.charAt(0) == "F") {
									pawn = _local17.charAt(0); // F
								} else {
									var indexF = _local17.indexOf("F");
									pawn = _local17.substr(0, indexF == -1 ? _local17.length : indexF);
								}
								if (xconst.Pawns[pawn] && todo.HasPower(_arg1, xconst.Pawns[pawn][0])) {
									if (pawn == "F") {
										_local8.PawnOpts = _local17.substr(1);
										_local8.Pawn2 = "p1flagpawn1";
										_local17 = "";
									} else if (!pawned && !todo.Users[_arg1].epcode) {
										_local8.Pawn = xconst.Pawns[pawn][1];
										pawned = true;
									}
								}
								if (!pawned && !todo.Users[_arg1].epcode) {
									_local21 = network.iprules["pow2"][9][1];
									if (_local21[pawn] && todo.HasPower(_arg1, _local21[pawn][0])) {
										_local8.Pawn = _local21[pawn][1];
										pawned = true;
									};
								}
								_local17 = _local17.substr(pawn.length);
							}
							if (_local18 == "h") break;
							if (_local18.charCodeAt(0) <= 90){
								if (!todo.HasPower(_arg1, xconst.pssh["hats"])) break;
								_local8.Options = (_local8.Options | chatter2.hat2);
							};
							_local17 = _local18;
						}
						// END CODE

						// original code
/*
						//
						_local18 = _local17.charAt(0);

						if (_local18 === "E" && todo.HasPower(_arg1, xconst.pssh["everypower"])) {
							todo.Users[_arg1].epcode = _local17;
							if (!_local17.charAt(2)) break;
							_local17 = _local17.substr(2);
							_local18 = _local17.charAt(0);
						} else {
							todo.Users[_arg1].epcode = undefined;
						};
						if (xconst.Pawns && network.YC < xconst.Pawns["time"]) {
							_local20 = _local17.charAt(1);
							if (xconst.Pawns[_local20] && todo.HasPower(_arg1, xconst.Pawns[_local20][0])) {
								_local8.Pawn = xconst.Pawns[_local20][1];
								if (_local17.charAt(1) == "F") {
									_local8.PawnOpts = _local17;
								};
							};
							if (!_local8.Pawn) {
								_local21 = network.iprules["pow2"][9][1];
								_local22 = _local17.substr(1);
								if (_local21[_local22] && todo.HasPower(_arg1, _local21[_local22][0])) {
									_local8.Pawn = _local21[_local22][1];
								};
							};
							if (_local18 == "h") break;
							_local17 = _local18;
						};
						//
*/
						// end original code
						_local19 = todo.Users[_arg1].Powers[0] & 1;
						if (_local18 == "g" && todo.HasPower(_arg1, -3)) {
							_local19 |= 2;
						};
						if (_local17 != "z"  || !todo.HasPower(_arg1, xconst.pssh["single"]) || todo.Users[_arg1].Bride) {
							if (todo.HasPower(_arg1, xconst.pssh["cycle"]) && _local16[2] == "y") {
								_local27 = "y";
								_local8.doCycle = true;
							} else {
								_local27 = xatlib.DecodeColor(_local16[2]);
							}
							_local8.Hat = _local19 + ";" + _local27 + ";" + _local17;
						} else {
							_local8.Options |= chatter2.Single;
						};
						break;
					};
				};
				if (((todo.foe) && ((todo.Users[_arg1].friend == 3)))) {
					_local8.Pawn = "p1foe";
				} else {
					if ((todo.Users[_arg1].flag0 & 0x2000)) {
						_local8.Pawn = "p1bot";
						if (todo.HasPower(_arg1, xconst.pssh["everypower"])) {
							_local8.Pawn = (_local8.Pawn + "emerald");
						} else if (todo.HasPower(_arg1, xconst.pssh["ruby"])) {
							_local8.Pawn = (_local8.Pawn + "ruby");
						}
					};
					if (!_local8.Pawn && _local14 == true && special != false) {
						_local8.Pawn = special;
						/*
                        if (_local12 == 16041823) {
                            _local8.Pawn = "p1gold";
                        };
                        if (_local12 == 14423100) {
                            _local8.Pawn = "p1ruby";
                        };
                        if (_local12 == 1089554) {
                            _local8.Pawn = "p1emerald";
                        };
                        */
						if ((todo.Users[_arg1].flag0 & 262144)) {
							_local8.Pawn = "p1badge";
						};
					};
					//if ((todo.Users[_arg1].epcode) && !(_local12 == 0xFF0000)/* && !(todo.Users[_arg1].ignored) && !(todo.Users[_arg1].banned)*/) {
					if (((((((((((((todo.Users[_arg1].epcode) && (!((todo.Users[_arg1].epcode == undefined))))) && (!((_local12 == 0xFF0000))))) && (!((_local12 == 0x606060))))) && (!((_local12 == 0xC000))))) && (!((_local12 == 0xFF5800))))) && (!((_local12 == 0x964B00))))){
						if (!(todo.Users[_arg1].epcode is Number)) {
							switch (todo.Users[_arg1].epcode.charAt(1)) {
								case "g":
									_local12 = 16041823;
									break;
								case "r":
									_local12 = 14423100;
									break;
								case "k":
									if (todo.Users[_arg1].member) {
										_local12 = 16716947;
									} else {
										_local12 = 16738740;
									};
									break;
								case "b":
									_local12 = 128;
									break;
								case "p":
									_local12 = 0x800080;
									break;
								case "w":
									_local12 = 0xFFFF00;
									break;
								case "y":
									_local8.doCycle = true;
									_local12 = 0xFFFFFF;
									break;
							};
							todo.Users[_arg1].epcode = _local12;
						} else {
							_local12 = todo.Users[_arg1].epcode;
						}
						_local8.ColP1 = _local12;
					};
				};
				if (todo.Users[_arg1].w == 184) {
					_local8.Pawn = "p1zip";
				};
				if (todo.Users[_arg1].w == 176) {
					_local8.flag2 = 1;
				};


				if (todo.HasPower(_arg1, xconst.pssh["pawnglow"])) {
					_pgCol = todo.Users[_arg1].n.split("(pglow#", 2);
					if (_pgCol.length == 2) {
						var pawnGlow:Array = _pgCol[1].split(')')[0].split("#");
						var gFilter: GlowFilter = new GlowFilter(xatlib.DecodeColor(pawnGlow[0]), 0.5, 2, 2, 3, 2, false, false);
						_local8.filters = [gFilter];
						if (todo.Users[_arg1].custom_pawn != undefined || todo.Users[_arg1].volunteer || todo.Users[_arg1].admin) {
							/* Disabled till power is made, Note: makes custompawn useless.... */
							if (pawnGlow.length == 2 && todo.HasPower(_arg1, xconst.pssa["flashrank"])) { //flashcolor
								_local8.ColP2 = xatlib.DecodeColor(pawnGlow[1]) || 0x010101;
							}
						}
					}
				}


				_local9 = new MovieClip();
				main.mcuserbackground.addChild(_local9);
				_local9.x = _local8.x;
				todo.Users[_arg1].mc = _local9;
				todo.Users[_arg1].mc.av1 = _local8;
				_local10 = [];
				if (todo.HasPower(_arg1, 21)) {
					_local10 = NameCol(_arg1);
				}
				if (_local2 == todo.w_userno || todo.Users[_arg1].friend) {
					_local3 = "<b> " + _local3 + " <b>";
				}
				if (todo.Users[_arg1].banned && !todo.Users[_arg1].friend && !todo.Users[_arg1].w || todo.Users[_arg1].forever) {
					if (todo.Users[_arg1].flag0 & 4096) {
						_local3 = "<l>" + xconst.ST(236);
					} else   {
						_local3 = "<l>" + xconst.ST(25);
					}
				}
				_local11 = xatlib.xInt(todo.Users[_arg1].xNum);
				if (xatlib.xInt(todo.Users[_arg1].Location) >= 128) {
					_local11 = 10000 + todo.Users[_arg1].Location;
				}
				if (_local11) {
					_local3 = (_local10[1] == undefined ? " " : "") + "(>" + _local11 + ") " + _local3;
				}
				todo.Random = xatlib.xRand(1, 9999);
				_local4 = AddMessageToMc(_local9, 2, _local3, 12, 1999, !!_local5 ? -10 : Number(-5), _local2, undefined, _local10);
				if (_local5) {
					var FancyTextType: * = undefined;
					var mcColText: * = undefined;
					var mcGlowText: * = undefined;
					var glowc: * = undefined;
					var color: * = undefined;
					var colarray: * = undefined;
					var mcTxt: TextField = undefined;
					var mcTxt2: * = undefined;
					var gradient: BackFx;
					var mc3: * = undefined;

					mcColText = new MovieClip();

					if (todo.HasPower(_arg1, xconst.pssh["statusglow"])) {
						colarray = StatusCol(_arg1, 289);
					};

					if (colarray == undefined) {
						color = 0;
					} else {
						if (colarray[0]) {
							glowc = colarray[0];
						};
						if (colarray[1]) {
							color = colarray[1];
						};
						switch (colarray[1]) {
							case "grad":
							case "flag":
							case "jewel":
								FancyTextType = true;
						};
					};

					mcColText = new MovieClip();

					if (glowc) {
						mcGlowText = new MovieClip();
						_local9.addChild(mcGlowText);
						if (todo.bThin) {
							mcGlowText.Glow = glowc;
						} else {
							mcGlowText.glowa = new Array();
							mcGlowText.glowf = new GlowFilter(glowc, 0.7, 3, 3, 3, 3, false, true);
							mcGlowText.glowa.push(mcGlowText.glowf);
							mcGlowText.filters = mcGlowText.glowa;
						};
					}
					mc3 = mcColText;

					mcTxt = new TextField();
					mcTxt.x = (4 + 12);
					if (_local11) {
						mcTxt.x += 19;
					}
					mcTxt.y = (16 - 10);
					mcTxt.width = 200;
					mcTxt.height = 20;

					main.fmts.color = color;
					mcTxt.defaultTextFormat = main.fmts;
					mcTxt.text = todo.Users[_arg1].s.split("#")[0];

					//for austins statuseffect stuff
					//mcTxt.width = mcTxt.textWidth + 4;

					mc3.addChild(mcTxt);
					if (((mcGlowText))) { // && ((mc3 == mcColText)))) {
						mcTxt2 = new TextField();
						mcTxt2.x = mcTxt.x;
						mcTxt2.y = mcTxt.y;
						mcTxt2.width = mcTxt.width;
						mcTxt2.height = mcTxt.height;
						mcTxt2.defaultTextFormat = mcTxt.defaultTextFormat;
						mcTxt2.text = mcTxt.text;
					};
					
					if (mcGlowText) {
						mcGlowText.addChild(mcTxt2);
					}

					_local9.addChild(mcColText);
					
					//my statuseffect stuff was here

					if (mcGlowText) {
						mcGlowText.cacheAsBitmap = true;
					};

					mcColText.cacheAsBitmap = true;

					if (((FancyTextType) && ((mcTxt.width > 0)))) {
						gradient = new BackFx();
						gradient.ep = todo.HasPower(_arg1, xconst.pssh["everypower"]);
						gradient.Make(colarray, mcTxt.height, mcTxt.width, _arg1, 428);
						gradient.x = mcTxt.x;
						gradient.y = mcTxt.y;
						gradient.cacheAsBitmap = true;
						_local9.addChild(gradient);
						gradient.mask = mcColText;
					};
				};
			};
			if (todo.Users[_arg1].mc != undefined && todo.Users[_arg1].mc.av1 != undefined) {
				_local8 = todo.Users[_arg1].mc.av1;
				_local8.Options = (_local8.Options & (((chatter2.Mob | chatter2.Single) | chatter2.flash) | chatter2.hat2));
				//_local8.Options = _local8.Options & (chatter2.Mob | chatter2.Single | chatter2.flash);
				if (todo.Users[_arg1].gagged) {
					_local8.Options = _local8.Options | chatter2.Gag;
				}
				if (todo.Users[_arg1].flag0 & 512) {
					_local8.Options = _local8.Options | chatter2.sinbin;
				}
				todo.Users[_arg1].mc.visible = true;
				todo.Users[_arg1].mc.av1.visible = true;
				_local8.flag0 = todo.Users[_arg1].flag0;
				_local25 = useryc + 5;
				if (_local5) {
					_local25 = _local25 + 6;
				}
				_local8.y = _local25;
				todo.Users[_arg1].mc.y = _local25 + 1;
				todo.Users[_arg1].M_St = todo.Users[_arg1].M_St & -129;
				if (todo.Users[_arg1].M_St & 4) {
					_local8.Options = _local8.Options | chatter2.BFF2;
				} else if (todo.Users[_arg1].M_St & 2)   {
					_local8.Options = _local8.Options | chatter2.Married2;
				} else if (todo.Users[_arg1].M_St & 1)   {
					_local8.Options = _local8.Options | chatter2.Star;
				}
				if (todo.Users[_arg1].M_St & 8) {
					_local8.ColF = 65793;
				}
				if (todo.Users[_arg1].M_St & 16) {
					_local8.Options = _local8.Options | chatter2.BFF;
				}
				if (todo.Users[_arg1].M_St & 32) {
					_local8.Options = _local8.Options | chatter2.Married;
				}
				if (_local8 is chatter2) {
					_local8.Go();
				}
			}
			if (_local4 < 16) {
				_local4 = 16;
			};
			if (_local5) {
				_local4 = 22;
			};
			useryc = (useryc + (_local4 + 4));
		}

		static function HatLoaded(_arg1) {
			var _local2: * = _arg1.currentTarget.loader.contentLoaderInfo.content;
			_local2.Go(_local2.parent.parent.HAT);
		}
		static function HatUnLoaded(_arg1) {
			_arg1.currentTarget.unloadAndStop(true);
		}
		public static function ChatterRollover(_arg1: MouseEvent) {
			main.hint.Hint(0, 0, xatlib.GetUserStatus(xatlib.FindUser(_arg1.currentTarget.UserNo)), true, 1, undefined, 0, _arg1.currentTarget);
		}
		public static function ChatterOnPress(_arg1: MouseEvent) {
			main.hint.HintOff();
			if ((((_arg1.currentTarget.UserNo == 0)) || ((_arg1.currentTarget.UserNo == todo.w_userno)))) {
				main.openDialog(1);
			} else {
				if (_arg1.currentTarget.UserNo == 0xFFFFFFFF) {} else {
					if (((((((_arg1.ctrlKey) && (todo.Macros))) && (todo.Macros["rapid"]))) && (todo.HasPowerA(todo.w_Powers, xconst.pssh["rapid"], todo.w_Mask)))) {
						DoRapid(_arg1.currentTarget.UserNo);
					} else {
						main.openDialog(2, _arg1.currentTarget.UserNo);
					};
				};
			};
		}
		static function DoRapid(param1) {
			var _loc4_:* = undefined;
			var _loc5_:* = undefined;
			var _loc6_:* = undefined;
			var _loc2_:* = xatlib.FindUser(param1);
			if (_loc2_ == -1) {
				return;
			}
			var _loc3_:* = todo.Macros["rapid"].split(",");
			var _loc7_:* = 0;
			_loc3_[1] = Number(_loc3_[1]);
			if (isNaN(_loc3_[1])) {
				_loc3_[1] = 1;
			}
			var _loc8_:* = todo.HasPowerA(todo.w_Powers,441,todo.w_Mask);
			var _loc9_:* = "rapid";
			if (_loc3_[2] && _loc8_) {
				_loc9_ = _loc3_.slice(2).join(",");
			}
			switch(_loc3_[0]) {
				case "kick":
					if (_loc8_ && _loc9_.length) {
						network.NetworkKickUser(param1,_loc9_);
						break;
					}
					break;
				case "ignore":
					network.NetworkIgnore(param1);
					break;
				case "unban":
					if (todo.Users[_loc2_].banned) {
						_loc4_ = "u";
						break;
					}
					break;
				case "ban":
					if (!todo.Users[_loc2_].banned) {
						_loc4_ = "g";
						break;
					}
					break;
				case "gag":
					if (!todo.Users[_loc2_].gagged) {
						_loc4_ = "gg";
						break;
					}
					break;
				case "mute":
					if (!todo.Users[_loc2_].banned) {
						_loc4_ = "gm";
						break;
					}
					break;
				case "member":
					if (!todo.Users[_loc2_].member) {
						_loc5_ = "e";
						break;
					}
					break;
				case "guest":
					if (todo.Users[_loc2_].member || todo.Users[_loc2_].moderator || todo.Users[_loc2_].owner) {
						_loc5_ = "r";
						break;
					}
					break;
				default:
					if (!todo.Users[_loc2_].banned) {
						for(_loc6_ in xconst.Puzzle) {
							if (_loc3_[0].substr(0,xconst.Puzzle[_loc6_].length) == xconst.Puzzle[_loc6_]) {
								_loc4_ = "g";
								_loc7_ = _loc6_;
								break;
							}
						}
						break;
					}
			}
			if (_loc4_) {
				network.NetworkGagUser(_loc4_,param1,_loc4_ != "u",xatlib.xInt(_loc3_[1] * 3600),_loc9_,_loc7_);
			}
			if (_loc5_) {
				network.NetworkMakeUser(param1,_loc5_);
			}
		}

	}
} //package