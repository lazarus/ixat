package {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import flash.net.*;
	import flash.xml.XMLDocument;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.external.ExternalInterface;

	public class DialogPowers extends Sprite {

		var mcpowersbackground;
		var mcpowersbackb;
		var mcpowersback;
		var mcpowersbackmask;
		var bpowersscrollmc;
		var powersinc;
		var powersincc;
		var userid;
		var boutin;
		var sM;
		var bph;

		public function DialogPowers(_arg_1:*){
			var _local_6:*;
			var _local_7:*;
			var _local_8:*;
			var _local_9:*;
			var _local_12:*;
			var _local_13:*;
			var _local_14:*;
			var _local_15:*;
			super();
			if (todo.w_Mask == undefined){
				todo.w_Mask = todo.NO_POWERS.slice();
			};
			this.sM = todo.w_Mask.slice();
			this.powersinc = 0;
			this.powersincc = 0;
			this.userid = _arg_1.muserid;
			this.boutin = false;
			this.mcpowersbackground = new xDialog(this, xatlib.NX(120), xatlib.NY(30), xatlib.NX(400), xatlib.NY(380), " " + xatlib.GetNameNumber(this.userid) + " " + xconst.ST(189), undefined, 0, this.Delete);
			var _local_2:* = this.mcpowersbackground.Dia;
			_local_2.mcclose = new xBut(_local_2, xatlib.NX(240), xatlib.NY(370), xatlib.NX(160), xatlib.NY(30), xconst.ST(45), this.PowersClose);
			
			if(todo.w_userno == this.userid) {
				_local_2.mcenableall = new xBut(_local_2, xatlib.NX(345), xatlib.NY(280), xatlib.NX(75), xatlib.NY(20), "Enable All", this.PowAll, 0x3000000);
				_local_2.mcenableall.mode = true;
				
				_local_2.mcdisableall = new xBut(_local_2, xatlib.NX(430), xatlib.NY(280), xatlib.NX(75), xatlib.NY(20), "Disable All", this.PowAll, 0x3000000);
				_local_2.mcdisableall.mode = false;
				
				_local_2.mcassignall = new xBut(_local_2, xatlib.NX(345), xatlib.NY(305), xatlib.NX(75), xatlib.NY(20), "Assign All", this.PowAssigner, 0x3000000);
				_local_2.mcassignall.mode = 1;
				_local_2.mcassignall.visible = false;
				
				_local_2.mcunassignall = new xBut(_local_2, xatlib.NX(430), xatlib.NY(305), xatlib.NX(75), xatlib.NY(20), "Unassign All", this.PowAssigner, 0x3000000);
				_local_2.mcunassignall.mode = 0;
				_local_2.mcunassignall.visible = false;
			}
			_local_2.txt2 = new MovieClip();
			_local_2.addChild(_local_2.txt2);
			xatlib.createTextNoWrap(_local_2.txt2, xatlib.NX(130), xatlib.NY(275), xatlib.NX(50), xatlib.NY(32), "Search:", 2105376, 0, 100, 0, 24, "left", 1);
			_local_2.mcsearchboxb = xatlib.AddBackground(_local_2, xatlib.NX(175), xatlib.NY(275) + 3, xatlib.NX(70), xatlib.NY(24));
			_local_2.mcsearchbox = xatlib.AddTextField(_local_2, xatlib.NX(175), xatlib.NY(275) + 3, xatlib.NX(70), xatlib.NY(24), "", main.fmt);
			_local_2.mcsearchbox.type = TextFieldType.INPUT;
			_local_2.mcsearchbox.text = "";
			_local_2.mcsearchbox.addEventListener(Event.CHANGE, this.SearchUpdate);
			_local_2.mcgetpowers = new xBut(_local_2, xatlib.NX(345), xatlib.NY(330), xatlib.NX(160), xatlib.NY(30), xconst.ST(290), this.GetPowers);
			xatlib.AttachBut(_local_2.mcgetpowers, "pwr");
			var _local_3:* = xatlib.NX(380);
			this.bph = (xatlib.NY(240) - 40);
			var _local_4:* = xatlib.NX(130);
			var _local_5:* = (xatlib.NY(30) + 40);
			this.mcpowersbackb = xatlib.AddBackground(_local_2, _local_4, _local_5, _local_3, this.bph);
			this.mcpowersback = new MovieClip();
			this.mcpowersbackb.addChild(this.mcpowersback);
			this.mcpowersback.Width = _local_3;
			this.mcpowersbackmask = xatlib.AddBackground(_local_2, (_local_4 + 1), (_local_5 + 1), ((_local_3 - 2) - xatlib.NX(16)), (this.bph - 2), 0);
			this.mcpowersback.mask = this.mcpowersbackmask;
			this.bpowersscrollmc = new xScroll(_local_2, ((_local_4 + _local_3) - xatlib.NX(16)), _local_5, xatlib.NX(16), this.bph, xatlib.NX(16), xatlib.NX(32), 30, (10 * 100), (0 * 100), this.onPowersScrollChange);
			
			if(_arg_1.pawns === true) {
				this.mcpowersbackground.Dia.mcsearchbox.text = "pawns";
			}

			this.AddPowers();
			
			var _local_10:* = xatlib.FindUser(this.userid);
			if (((!((todo.Users[_local_10].coins == undefined))) && (!((todo.Users[_local_10].days == undefined))))){
				_local_2.txt2.y += 45;
				_local_2.mcsearchbox.y += 45;
				_local_2.mcsearchboxb.y += 45;
				_local_2.days = xatlib.AttachMovie(_local_2, "star", {
					"x":xatlib.NX(140),
					"y":xatlib.NY(280),
					"scaleX":xatlib.SX(),
					"scaleY":xatlib.SY()
				});
				xatlib.createTextNoWrap(_local_2.days, 30, -10, 130, 50, xconst.ST(204, todo.Users[_local_10].days), 0x202020, 0, 100, 0, 26, "center", 1);
				_local_2.coins = xatlib.AttachMovie(_local_2, "coins", {
					"x":xatlib.NX(340),
					"y":xatlib.NY(280),
					"scaleX":xatlib.SX(),
					"scaleY":xatlib.SY()
				});
				xatlib.createTextNoWrap(_local_2.coins, 30, -10, 130, 50, (todo.Users[xatlib.FindUser(this.userid)].coins + " xats"), 0x202020, 0, 100, 0, 26, "center", 1);
			};
			var _local_11:* = undefined;
			if (todo.w_userno == this.userid){
				if (network.YC){
					_local_15 = (xatlib.xInt(todo.w_d1) - network.YC);
					if (_local_15 < 0){
						_local_15 = 0;
					};
					_local_15 = xatlib.xInt(((_local_15 / (24 * 3600)) + 0.3));
					if (_local_15 == 0){
						_local_11 = "If you had powers they will return when you have days";
					};
				};
			};
			if (todo.Users[_local_10].debug != undefined){
				_local_11 = todo.Users[_local_10].debug;
			};
			if (_local_11 != undefined){
				_local_2.txt1 = new MovieClip();
				_local_2.addChild(_local_2.txt1);
				xatlib.createTextNoWrap(_local_2.txt1, xatlib.NX(120), xatlib.NY(336), xatlib.NX(400), 50, _local_11, 0x202020, 0, 100, 0, 26, "center", 1);
				_local_2.mcsearchbox.visible = false;
				_local_2.mcsearchboxb.visible = false;
				_local_2.txt2.visible = false;
				_local_2.mcdisableall.visible = false;
				_local_2.mcenableall.visible = false;
				_local_2.mcassignall.visible = false;
				_local_2.mcunassignall.visible = false;
				
			}
		}
		
		static function PowOnOff(_arg_1:*, _arg_2:*){
			if (todo.w_Mask[0] == undefined){
				todo.w_Mask = todo.NO_POWERS.slice();
			};
			var _local_3:* = xatlib.xInt((_arg_1 / 32));
			var _local_4:* = (1 << (_arg_1 % 32));
			if (_arg_2){
				todo.w_Mask[_local_3] = (todo.w_Mask[_local_3] & ~(_local_4));
			} else {
				todo.w_Mask[_local_3] = (todo.w_Mask[_local_3] | _local_4);
			};
			if (todo.w_Mask[_local_3] < 0){
				todo.w_Mask[_local_3] = (todo.w_Mask[_local_3] + 4294967296);
			};
			xatlib.MainSolWrite("w_Mask", todo.w_Mask);
		}
		
		function PowAssigner(e:MouseEvent=undefined) {
			var curr:* = e.currentTarget;
			var g = 1;
			var self:* = xatlib.FindUser(todo.w_userno);
			for(var grp in xconst.IsGroup){
				if (todo.HasPower(self, grp)) {
					Assigner(grp, curr.mode); 
				}
			}
		}
		
		function Assigner(power:*, mode:*) {
			//main.box_layer.GeneralMessageH.Delete();
			var _local_3:* = new XMLDocument();
			var _local_4:* = _local_3.createElement("ap");
			_local_4.attributes.p = xatlib.xInt(power).toString();
			_local_4.attributes.a = mode;
			_local_3.appendChild(_local_4);
			network.socket.send(xatlib.XMLOrder(_local_3, new Array("p", "a")));
		}

		function Delete(){
			main.hint.HintOff();
			if (!this.mcpowersbackground){
				return;
			};
			this.mcpowersbackground.Delete();
			this.mcpowersbackb.removeChild(this.mcpowersback);
			this.mcpowersback = null;
			this.mcpowersbackground = null;
			main.closeDialog();
		}
		function AddPower(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*){
			var _local_5:*;
			if (_arg_3){
				_local_5 = xatlib.AttachMovie(this.mcpowersback, "checkbox");
				this.mcpowersback.addChild(_local_5);
				_local_5.x = (10 - 9);
				_local_5.y = (this.powersinc + 8);
				_local_5.addEventListener(MouseEvent.MOUSE_DOWN, this.OnPowerCheck);
				_local_5.Bit = _arg_1;
				_local_5.xitem.tick.visible = _arg_2;
			};
			var _local_6:* = new MovieClip();
			this.mcpowersback.addChild(_local_6);
			_local_6.x = 5;
			xmessage.SmB = true;
			var _local_7:* = "";
			if (((((!((_arg_1 == 0))) && (!((_arg_4 == undefined))))) && (!((_arg_4 == 0))))){
				_local_7 = ((" [" + _arg_4) + "]");
			};
			var mcpower = new xSprite();
			if (xconst.IsGroup[_arg_1]) {
				mcpower.Power = _arg_1;
			}
			mcpower.buttonMode = true;
			mcpower.addEventListener(MouseEvent.MOUSE_DOWN, this.OnPowerClick);
			var _local_8:* = xatlib.LoadMovie(mcpower, (((todo.imagedomain + "smw/") + xconst.pssa[(_arg_1 + 1)].toString()) + ".png"));
			_local_8.x = (((15 + 3) - 15) + 2);
			_local_8.y = this.powersinc;
			_local_6.addChild(mcpower);
			var _local_9:* = (8 + xmessage.AddMessageToMc(_local_6, 1, (("   <b> " + xconst.pssa[(_arg_1 + 1)]) + _local_7), 30, (this.mcpowersback.Width - 30), this.powersinc, this.userid));
			xmessage.SmB = undefined;
			if ((this.powersincc % 2) == 1){
				_local_6.x = (_local_6.x + (xatlib.NX(360) / 2));
				if (_local_5){
					_local_5.x = (_local_5.x + (xatlib.NX(360) / 2));
				};
				this.powersinc = (this.powersinc + _local_9);
			};
			this.powersincc++;
		}  
		
		function OnPowerClick(e:MouseEvent){
			var t:* = e.currentTarget;
			if (t.Power != undefined){
				var self:* = xatlib.FindUser(todo.w_userno);
				if (todo.HasPower(self, t.Power)){
					xatlib.GeneralMessage(xconst.ST(237), xconst.ST(238, xconst.pssa[(t.Power + 1)]), 0);
					var Dia:* = main.box_layer.GeneralMessageH.Dia;
					var w:* = Dia.DiaBack.width;
					var h:* = Dia.DiaBack.height;
					var x:* = Dia.DiaBack.x;
					var y:* = Dia.DiaBack.y;
					var f:* = 8;
					var d:* = int((w / ((f * 2) + 3)));
					var w1:* = int(((w * f) / ((f * 2) + 3)));
					var w2:* = w1;
					var buth:* = 22;
					var buth:* = 22;
					new xBut(Dia, (((x + w) - d) - w1), (((y + h) - buth) - 20), w1, buth, "UnAssign", function (_arg_1:*){
						AssignRel(0, t);
					});
					new xBut(Dia, (x + d), (((y + h) - buth) - 20), w2, buth, "Assign", function (_arg_1:*){
						AssignRel(1, t);
					});
				};
			}
		}
		
		private static function AssignRel(_arg_1:*, _arg_2:*){
			main.box_layer.GeneralMessageH.Delete();
			var _local_3:* = new XMLDocument();
			var _local_4:* = _local_3.createElement("ap");
			_local_4.attributes.p = xatlib.xInt(_arg_2.Power).toString();
			_local_4.attributes.a = _arg_1;
			_local_3.appendChild(_local_4);
			var _local_5:String = xatlib.XMLOrder(_local_3, new Array("p", "a"));
			network.socket.send(_local_5);
			chat.xtrace("tx", _local_5);
		}
		
		function onPowersScrollChange(){
			var _local_1:* = (((this.powersinc - this.bph) + 4) + ((((this.powersincc % 2) == 1)) ? 30 : 0));
			if (_local_1 < 0){
				_local_1 = 0;
			};
			this.bpowersscrollmc.Scr_size = _local_1;
			var _local_2:* = this.bpowersscrollmc.Scr_position;
			this.mcpowersback.y = -(_local_2);
		}
		function OnPowerCheck(e:MouseEvent){
			var curr:* = e.currentTarget;
			this.boutin = true;
			curr.xitem.tick.visible = !(curr.xitem.tick.visible);
			PowOnOff(curr.Bit, curr.xitem.tick.visible);
		}
		function PowersClose(e:MouseEvent=undefined){
			var _local_2:*;
			if (this.boutin){
				_local_2 = xatlib.FindUser(todo.w_userno);
				if (_local_2 != -1){
					todo.Users[_local_2].n = todo.w_name;
					todo.Users[_local_2].a = todo.w_avatar;
					todo.Users[_local_2].h = todo.w_homepage;
					todo.Users[_local_2].s = (((todo.Macros)!=undefined) ? todo.Macros["status"] : undefined);
				};
				network.UpdateFriendList(todo.w_userno, 1);
				todo.w_friendlist2[todo.w_userno] = undefined;
				xatlib.ReLogin();
			};
			this.Delete();
			if (this.sM[0] != todo.w_Mask[0]){
				todo.w_friendlist2[todo.w_userno] = undefined;
			};
		}
		function GetPowers(e:MouseEvent=undefined){
			this.PowersClose();
			var _local_2:* = (todo.usedomain + "/powers");
			xatlib.UrlPopup(xconst.ST(8), _local_2);
		}
		function PowDecode(_arg_1:*){
			var _local_5:*;
			var _local_6:*;
			var _local_2:* = new Array();
			if (((!(_arg_1)) || ((_arg_1.length == 0)))){
				return (_local_2);
			};
			var _local_3:* = _arg_1.split("|");
			var _local_4:* = 0;
			while (_local_4 < _local_3.length) {
				_local_5 = _local_3[_local_4].split("=");
				_local_6 = xatlib.xInt(_local_5[1]);
				if (_local_6 == 0){
					_local_6 = 1;
				};
				_local_2[_local_5[0]] = (_local_6 + 1);
				_local_4++;
			};
			return (_local_2);
		}
		
		function PowAll(e:MouseEvent=undefined) {
			var curr:* = e.currentTarget;
			this.boutin = true;
			for (var i = 0; i < this.mcpowersback.numChildren; i++) {
				var child:* = this.mcpowersback.getChildAt(i);
				if(child.xitem){
					child.xitem.tick.visible = curr.mode;
					PowOnOff(Number(child.Bit), curr.mode);
				}
			}
			//todo.w_Mask = todo.ALL_POWERS.slice(); // todo.NO_POWERS.slice();
			//xatlib.MainSolWrite("w_Mask", todo.w_Mask);
		}
		
		function SearchUpdate(e:Event){
			for (var i = 0; i < this.mcpowersback.numChildren; i++) {
				this.mcpowersback.removeChildAt(i);
			}
			this.mcpowersbackb.removeChild(this.mcpowersback);
			this.mcpowersback = new MovieClip();
			this.mcpowersbackb.addChild(this.mcpowersback);
			this.mcpowersback.Width = xatlib.NX(380);
			this.mcpowersbackmask = xatlib.AddBackground(this.mcpowersbackground.Dia, (xatlib.NX(130) + 1), ((xatlib.NY(30) + 40) + 1), ((xatlib.NX(380) - 2) - xatlib.NX(16)), (this.bph - 2), 0);
			this.mcpowersback.mask = this.mcpowersbackmask;
			this.powersinc = 0;
			this.powersincc = 0;
			AddPowers();
			if (this.mcpowersbackground.Dia.mcsearchbox.text.toLowerCase() == "group") {
				this.mcpowersbackground.Dia.mcassignall.visible = true;
				this.mcpowersbackground.Dia.mcunassignall.visible = true;
			} else {
				this.mcpowersbackground.Dia.mcassignall.visible = false;
				this.mcpowersbackground.Dia.mcunassignall.visible = false;
			}
		}
		
		function AddPowers() {
			var Dia:* = this.mcpowersbackground.Dia;
			var addCheckBox:Boolean;
			var mPowers:*;
			var extras:*;
			var powers:*;
			var hugs = [];
			//var pawns = [];
			for(var hug in xconst.hugs){
				hugs.push(xconst.hugs[hug] % 10000);
			}/* 
			for(var pwn in xconst.Pawns){
				if (pwn != "!" && pwn != "time") {
					pawns.push(xconst.Pawns[pwn][0]);
				}
			} */
			if (todo.w_userno == this.userid){
				addCheckBox = true;
				mPowers = todo.w_Powers;
				extras = this.PowDecode(todo.w_PowerO);
				powers = ((todo.w_Mask[0])!=undefined) ? todo.w_Mask : undefined;
			} else {
				mPowers = todo.Users[xatlib.FindUser(this.userid)].UnmaskedPowers;
				extras = this.PowDecode(todo.Users[xatlib.FindUser(this.userid)].PowerO);
				powers = todo.Users[xatlib.FindUser(this.userid)].Powers;
			};
			if (mPowers){
				if(mPowers[2] & 1 << 31 && (Dia.mcsearchbox.text.toLowerCase() == "" || Dia.mcsearchbox.text == "")) {
					this.AddPower(95,((~(powers[2]) >> 31) & 1),addCheckBox,extras[95]);
				};
				for(var i:int = 0; i < mPowers.length; i++) {
					for(var i2:int = 0; i2 < 32; i2++) {
						if ((((((((((i2 == 0)) && ((i == 0)))) && (addCheckBox))) && (todo.w_ALLP))) || (((((!((((i2 == 0)) && ((i == 0))))) && (((mPowers[i] >> i2) & 1)))) && ((i2 < (xconst.pssa.length - 1))))))){
							var pid:Number = ((i * 32) + i2);
							if(pid !== 95) {
								var addPowerToList:Boolean = true;
								if (Dia.mcsearchbox.text && Dia.mcsearchbox.text.toLowerCase() !== ""){
									switch(Dia.mcsearchbox.text.toLowerCase()) {
										case "game": case "games":
											if(!xconst.Game[pid])
												addPowerToList = false;
											break;
										case "puzzle": case "puzzles":
											if(!xconst.Puzzle[pid])
												addPowerToList = false;
											break;
										case "group":
											if(!xconst.IsGroup[pid])
												addPowerToList = false;
											break;
										case "color": case "colors":
											var colors = [13, 14, 15, 16];
											if(colors.indexOf(pid) == -1)
												addPowerToList = false;
											break;
										case "hug": case "hugs":
											if(hugs.indexOf(pid) == -1)
												addPowerToList = false;
											break;
										case "off": case "disable": case "disabled":
											if(!todo.HasPowerA(powers, pid))
												addPowerToList = false;
											break;
										case "on": case "enable": case "enabled":
											if(todo.HasPowerA(powers, pid))
												addPowerToList = false;
											break;
										case "pawn": case "pawns":
											if(todo.Pawns.indexOf(pid) == -1)
												addPowerToList = false;
											break;
										default:
											var _loc6_ = xconst.pssa[pid + 1];
											for(var i3:int = 0; i3 < _loc6_.length; i3++) {
												if(Dia.mcsearchbox.text.charAt(i3) && _loc6_.charAt(i3) !== Dia.mcsearchbox.text.charAt(i3).toLowerCase()) {
													addPowerToList = false;
												} 
											}
											break;
									}
								}
								if(addPowerToList) {
									this.AddPower(pid, ((~(powers[i]) >> i2) & 1), addCheckBox, extras[pid]);
								};
							};
						};
					};
				};
			};
		}
	}
	
}//package 

