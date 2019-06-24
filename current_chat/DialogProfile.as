package {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
    import flash.net.*;

    public class DialogProfile extends Sprite {

        public var mcprofilebackground;
        var tf3:TextField;
        var tf3b;
        var tf4:TextField;
        var tf4b;
        var tf5:TextField;
        var tf5b;
        var Dia;
        var changed = false;
		var newtheme = false;

        public function DialogProfile(_arg1=0){
            var YY:* = undefined;
            var i:* = undefined;
            var s:* = undefined;
            var vt:* = undefined;
            var e:int = _arg1;
            super();
            var AddCheck:* = function (_arg1, _arg2, _arg3){
                xatlib.createTextNoWrap(Dia.txt1, (_arg1 + xatlib.NX(22)), xatlib.NY(YY), xatlib.NX(280), xatlib.NY(32), _arg2, 0x202020, 0, 100, 0, 20, "left", 1);
                var _local4:* = xatlib.AttachMovie(Dia.txt1, "checkbox");
                _local4.x = _arg1;
                _local4.y = xatlib.NY((YY + 8));
                _local4.xitem.tick.visible = !(((todo.autologin & _arg3) == 0));
                _local4.Bit = _arg3;
                _local4.addEventListener(MouseEvent.MOUSE_DOWN, OnCheck);
            };
            this.changed = false;
            var Married:* = ((todo.w_registered) && (todo.w_d2));
            if (todo.w_userrev == undefined){
                todo.w_userrev = 0;
                if (todo.lb == "t"){
                    todo.lb = "n";
                    todo.DoUpdate = true;
                    network.NetworkClose();
                };
                if (todo.lb == "n"){
                    main.logoutbutonPress();
                };
                return;
            };
            YY = (407 + 5);
			if (this.newtheme) {
				YY = YY - 80;
			}
            if (Married){
                YY = (YY + 38);
            };
            var strUserNo:* = xatlib.xInt(todo.w_userno).toString();
			if (strUserNo.substr(-12, 12) == "000000000000"){
                strUserNo = (strUserNo.substr(0, (strUserNo.length - 12)) + "T");
            } else if (strUserNo.substr(-9, 9) == "000000000"){
                strUserNo = (strUserNo.substr(0, (strUserNo.length - 9)) + "B");
            } else if (strUserNo.substr(-6, 6) == "000000"){
                strUserNo = (strUserNo.substr(0, (strUserNo.length - 6)) + "M");
            };
            this.mcprofilebackground = new xDialog(this, xatlib.NX(20), xatlib.NY(((480 - YY) / 2)), xatlib.NX(600), xatlib.NY(YY), (((todo.w_registered == undefined)) ? (" " + todo.w_userno) : ((((" " + todo.w_registered) + " (") + strUserNo) + ")")), undefined, 0, this.Delete);
            YY = ((480 - YY) / 2);
            YY = (YY + 4);
            this.Dia = this.mcprofilebackground.Dia;
            if (!todo.bMobile){
                this.Dia.mcuser = new Array();
                i = 0;
                while (i < 4) {
                    this.Dia.mcuser[i] = new xBut(this.Dia, xatlib.NX((510 - (i * 85))), xatlib.NY(YY), xatlib.NX(80), xatlib.NY(22), ((todo.w_namelist[i])!=undefined) ? todo.w_namelist[i] : xconst.ST(59), this.onUser);
                    this.Dia.mcuser[i].But.Num = i;
                    if (todo.w_namelist[i] == undefined){
                        break;
                    };
                    i = (i + 1);
                };
            };
            this.Dia.txt1 = this.Dia;
            YY = (YY + (((((385 - 200) - 24) - 37) + 6) - (130 - 37)));
            xatlib.createTextNoWrap(this.Dia.txt1, xatlib.NX((12 + 24)), xatlib.NY(YY), xatlib.NX(100), xatlib.NY(32), xconst.ST(60), 0x202020, 0, 100, 0, 24, "left", 1);
            this.tf3b = xatlib.AddBackground(this.Dia, xatlib.NX((120 + 24)), xatlib.NY(YY), xatlib.NX(460), xatlib.NY(32));
            this.tf3 = xatlib.AddTextField(this.Dia, xatlib.NX((120 + 24)), xatlib.NY(YY), xatlib.NX(460), xatlib.NY(32), "", main.fmt);
            this.tf3.type = TextFieldType.INPUT;
            YY = (YY + (429 - 385));
            this.Dia.txt1.YY = ((YY + 18) + 24);
            xatlib.createTextNoWrap(this.Dia.txt1, xatlib.NX((12 + 24)), xatlib.NY(YY), xatlib.NX(100), xatlib.NY(32), xconst.ST(61), 0x202020, 0, 100, 0, 24, "left", 1);
            this.tf4b = xatlib.AddBackground(this.Dia, xatlib.NX((120 + 24)), xatlib.NY(YY), xatlib.NX(460), xatlib.NY(32));
            this.tf4 = xatlib.AddTextField(this.Dia, xatlib.NX((120 + 24)), xatlib.NY(YY), xatlib.NX(460), xatlib.NY(32), "", main.fmt);
            this.tf4.type = TextFieldType.INPUT;
            YY = (YY + (42 + xatlib.NY(30)));
			
			if (!this.newtheme) {
				YY = (YY + xatlib.NY(40));
			}
			
            var XX:* = 40;
            var smc:* = new library("ho");
            smc.scaleX = (smc.scaleY = xatlib.SY(1));
            smc.x = xatlib.NX(XX);
            smc.y = (xatlib.NY(YY) + 15);
            this.Dia.addChild(smc);
            XX = (XX + 40);
            this.tf5b = xatlib.AddBackground(this.Dia, xatlib.NX(XX), (xatlib.NY(YY) + 15), xatlib.NX((605 - XX)), xatlib.NY(32));
            this.tf5 = xatlib.AddTextField(this.Dia, xatlib.NX(XX), (xatlib.NY(YY) + 15), xatlib.NX((605 - XX)), xatlib.NY(32), "", main.fmt);
            this.tf5.type = TextFieldType.INPUT;
            this.tf3.text = (todo.w_name = xatlib.CleanTextNoXat(todo.w_name));
            this.tf4.text = todo.w_avatar;
            this.tf5.text = todo.w_homepage;
            this.tf3.addEventListener(Event.CHANGE, xatlib.RemoveCR);
            this.tf4.addEventListener(Event.CHANGE, xatlib.RemoveCR);
            this.tf5.addEventListener(Event.CHANGE, xatlib.RemoveCR);
            YY = (YY + 58);
			if (Married){
				s = xconst.ST(152);
				if ((todo.w_d0 & 1)){
					s = xconst.ST(153);
				};
				s = (s + ": ");
				if (todo.w_bride){
					s = (s + (((todo.w_bride + " (") + todo.w_d2) + ")"));
				} else {
					s = (s + todo.w_d2);
				};
				xatlib.createTextNoWrap(this.Dia.txt1, xatlib.NX((12 + 24)), xatlib.NY(YY), xatlib.NX(460), xatlib.NY(32), s, 0x202020, 0, 100, 0, 18, "left", 1);
				this.Dia.dv = new xBut(this.Dia, xatlib.NX(445), xatlib.NY(YY), xatlib.NX(160), xatlib.NY(30), xconst.ST(150), this.onDivorce, 0);
				this.Dia.dv.But.UserNo = 1;
				this.Dia.dv.But.Mode = 2;
				YY = (YY + 38);
			};
			if (this.newtheme) {
				this.Dia.mcmacros = new xBut(this.Dia, xatlib.NX(35), xatlib.NY(YY), xatlib.NX(80), xatlib.NY(30), "Macros", this.onMacros, 0x5000000);
				this.Dia.mcmacros.SetRoll("Macros");

				this.Dia.mcpawns = new xBut(this.Dia, xatlib.NX(250), xatlib.NY(YY), xatlib.NX(25), xatlib.NY(30), " ", this.onPawns, 0x4000000);
				this.Dia.mcpawns.SetRoll("Pawns");
				xatlib.AttachBut(this.Dia.mcpawns, "p1pwn");
				this.Dia.mcpawns.c.y = xatlib.NY(8);
				this.Dia.mcpawns.c.x = xatlib.NX(9);
				
				this.Dia.mcpowers = new xBut(this.Dia, xatlib.NX(285), xatlib.NY(YY), xatlib.NX(25), xatlib.NY(30), " ", this.onPowers);
				this.Dia.mcpowers.SetRoll(xconst.ST(189));
				xatlib.AttachBut(this.Dia.mcpowers, "pwr");
				this.Dia.mcpowers.c.x = xatlib.NX(7);
				
				this.Dia.mcgifts = new xBut(this.Dia, xatlib.NX(320), xatlib.NY(YY), xatlib.NX(25), xatlib.NY(30), " ", this.onGifts);
				this.Dia.mcgifts.SetRoll(xconst.ST(257));
				xatlib.AttachBut(this.Dia.mcgifts, "giftb");
				this.Dia.mcgifts.c.x = xatlib.NX(6);
				
				if (global.xm != undefined){
					this.Dia.UseX = new xBut(this.Dia, xatlib.NX(355), xatlib.NY(YY), xatlib.NX(30), xatlib.NY(30), " ", this.UseX_onRelease);
					this.Dia.UseX.SetRoll(global.xm);
					xatlib.AttachBut(this.Dia.UseX, "coins");
					this.Dia.UseX.But.Obj = this.Dia.UseX;
					this.Dia.UseX.c.x = xatlib.NY(7);
				} else {
					this.Dia.CoinB = new xBut(this.Dia, xatlib.NX(355), xatlib.NY(YY), xatlib.NX(30), xatlib.NY(30), " ", xkiss.BuyRelease);
					this.Dia.CoinB.SetRoll(xconst.ST(206));
					xatlib.AttachBut(this.Dia.CoinB, "coins");
					this.Dia.CoinB.c.x = xatlib.NY(7);
				};
				
				if (todo.w_userno < (0x77359400 - (100000 * 2))){
					this.Dia.mcregister = new xBut(this.Dia, xatlib.NX(415), xatlib.NY(YY), xatlib.NX(80), xatlib.NY(30), xconst.ST(154), xatlib.Register_onRelease, 0x4000000);
					this.Dia.mcregister.SetRoll(xconst.ST(155));
				};
				
				this.Dia.mclang = new xBut(this.Dia, xatlib.NX(505), xatlib.NY(YY), xatlib.NX(100), xatlib.NY(30), (xconst.ST(289) + "..."), this.OK_onLang, 0x3000000);
				
				YY = (YY + 30);
				AddCheck(xatlib.NX(40), xconst.ST(65), 1);
				AddCheck(xatlib.NX(320), xconst.ST(220), 2);
				YY = (YY + 50);
				this.Dia.coins = xatlib.AttachMovie(this.Dia, "coins", {
					x:xatlib.NX(440),
					y:xatlib.NY((YY + 4)),
					scaleX:xatlib.SX(),
					scaleY:xatlib.SY()
				});
				xatlib.createTextNoWrap(this.Dia.coins, 30, -10, 130, 50, (((isNaN(todo.w_coins)) ? 0 : todo.w_coins) + " zats"), 0x202020, 0, 100, 0, 26, "center", 1);
				this.Dia.coins.addEventListener(MouseEvent.MOUSE_DOWN, xkiss.CreateBuystuff);
				if (network.YC){
					vt = (xatlib.xInt(todo.w_d1) - network.YC);
					if (vt < 0){
						vt = 0;
					};
					vt = xatlib.xInt(((vt / (24 * 3600)) + 0.3));
					xatlib.createTextNoWrap(this.Dia.txt1, xatlib.NX((12 + 24)), xatlib.NY(YY - 10), xatlib.NX(160), xatlib.NY(33), ((xconst.ST(203) + "\n") + xconst.ST(204, vt)), 0x202020, 0, 100, 0, 24, "left", 1);
				};
			} else {
				this.Dia.mcmacros = new xBut(this.Dia, xatlib.NX(35), xatlib.NY(YY), xatlib.NX(80), xatlib.NY(30), "Macros", this.onMacros, 0x5000000);
				//use later
				this.Dia.mcpawns = new xBut(this.Dia, xatlib.NX(135), xatlib.NY(YY), xatlib.NX(80), xatlib.NY(30), " Pawns", this.onPawns, 0x4000000);
				//this.Dia.mcpawns = new xBut(this.Dia, xatlib.NX(135), xatlib.NY(YY), xatlib.NX(80), xatlib.NY(30), " Pawns", this.onPowers, 0x4000000);
				xatlib.AttachBut(this.Dia.mcpawns, "p1pwn");
				
				//old
				//this.Dia.mcpawns = new xBut(this.Dia, xatlib.NX(35), xatlib.NY(YY), xatlib.NX(160), xatlib.NY(30), "Pawns", this.onPowers2);
				//xatlib.AttachBut(this.Dia.mcpawns, "p1pwn");
				this.Dia.mcpowers = new xBut(this.Dia, xatlib.NX(240), xatlib.NY(YY), xatlib.NX(160), xatlib.NY(30), xconst.ST(189), this.onPowers);
				xatlib.AttachBut(this.Dia.mcpowers, "pwr");
				this.Dia.mcgifts = new xBut(this.Dia, xatlib.NX(445), xatlib.NY(YY), xatlib.NX(160), xatlib.NY(30), xconst.ST(257), this.onGifts);
				xatlib.AttachBut(this.Dia.mcgifts, "giftb");
				YY = (YY + 30);
				AddCheck(xatlib.NX(40), xconst.ST(65), 1);
				AddCheck(xatlib.NX(320), xconst.ST(220), 2);
				YY = (YY + 30);
				YY = (YY + 5);
				if (!todo.bMobile){
					if (todo.w_userno < (0x77359400 - (100000 * 2))){
						this.Dia.mcregister = new xBut(this.Dia, xatlib.NX(35), xatlib.NY(YY), xatlib.NX(160), xatlib.NY(30), xconst.ST(154), xatlib.Register_onRelease);
						this.Dia.mcregister.SetRoll(xconst.ST(155));
					};
					this.Dia.mclang = new xBut(this.Dia, xatlib.NX(445), xatlib.NY(YY), xatlib.NX(160), xatlib.NY(30), (xconst.ST(289) + "..."), this.OK_onLang);
					if (global.xm != undefined){
						this.Dia.UseX = new xBut(this.Dia, xatlib.NX(240), xatlib.NY(YY), xatlib.NX(160), xatlib.NY(30), global.xm, this.UseX_onRelease);
						this.Dia.UseX.But.Obj = this.Dia.UseX;
					} else {
						this.Dia.CoinB = new xBut(this.Dia, xatlib.NX(240), xatlib.NY(YY), xatlib.NX(160), xatlib.NY(30), ("  " + xconst.ST(206)), xkiss.BuyRelease);
						xatlib.AttachBut(this.Dia.CoinB, "coins");
					};
				};
				YY = (YY + 50);
				this.Dia.coins = xatlib.AttachMovie(this.Dia, "coins", {
					x:xatlib.NX(440),
					y:xatlib.NY((YY + 4)),
					scaleX:xatlib.SX(),
					scaleY:xatlib.SY()
				});
				xatlib.createTextNoWrap(this.Dia.coins, 30, -10, 130, 50, (((isNaN(todo.w_coins)) ? 0 : todo.w_coins) + " zats"), 0x202020, 0, 100, 0, 26, "center", 1);
				this.Dia.coins.addEventListener(MouseEvent.MOUSE_DOWN, xkiss.CreateBuystuff);
				if (network.YC){
					vt = (xatlib.xInt(todo.w_d1) - network.YC);
					if (vt < 0){
						vt = 0;
					};
					vt = xatlib.xInt(((vt / (24 * 3600)) + 0.3));
					xatlib.createTextNoWrap(this.Dia.txt1, xatlib.NX((12 + 24)), xatlib.NY(YY), xatlib.NX(160), xatlib.NY(33), ((xconst.ST(203) + "\n") + xconst.ST(204, vt)), 0x202020, 0, 100, 0, 24, "left", 1);
				};
			}
            this.Dia.mcok = new xBut(this.Dia, xatlib.NX(240), xatlib.NY(YY), xatlib.NX(160), xatlib.NY(30), xconst.ST(45), this.OK_onRelease);
            this.ChangeProfileAvs();
        }
        public function Delete(){
            main.hint.HintOff();
            if (this.mcprofilebackground){
                this.mcprofilebackground.Delete();
            };
            main.closeDialog();
        }
        function OnCheck(_arg1:MouseEvent){
            _arg1.currentTarget.xitem.tick.visible = !(_arg1.currentTarget.xitem.tick.visible);
            if (_arg1.currentTarget.xitem.tick.visible){
                todo.autologin = (todo.autologin | _arg1.currentTarget.Bit);
            } else {
                todo.autologin = (todo.autologin & ~(_arg1.currentTarget.Bit));
            };
            xatlib.MainSolWrite("w_autologin", todo.autologin);
        }
        function onUser(_arg1:MouseEvent){
            var _local2:* = _arg1.currentTarget;
            var _local3:* = ((todo.w_userrevlist[_local2.Num])!=undefined) ? todo.w_userrevlist[_local2.Num] : 0;
            var _local4:* = ((todo.w_namelist[_local2.Num])!=undefined) ? todo.w_namelist[_local2.Num] : " ";
            var _local5:* = ((todo.w_avatarlist[_local2.Num])!=undefined) ? todo.w_avatarlist[_local2.Num] : "";
            var _local6:* = ((todo.w_homepagelist[_local2.Num])!=undefined) ? todo.w_homepagelist[_local2.Num] : "";
            todo.w_userrevlist[_local2.Num] = todo.w_userrev;
            todo.w_namelist[_local2.Num] = xatlib.CleanTextNoXat(todo.w_name);
            todo.w_avatarlist[_local2.Num] = todo.w_avatar;
            todo.w_homepagelist[_local2.Num] = todo.w_homepage;
            todo.w_name = xatlib.CleanTextNoXat(_local4);
            todo.w_avatar = _local5;
            todo.w_homepage = _local6;
            xatlib.MainSolWrite("w_userrevlist", todo.w_userrevlist);
            xatlib.MainSolWrite("w_namelist", todo.w_namelist);
            xatlib.MainSolWrite("w_avatarlist", todo.w_avatarlist);
            xatlib.MainSolWrite("w_homepagelist", todo.w_homepagelist);
            this.Delete();
            xatlib.ReLogin();
        }
        function UseX_onRelease(_arg1:MouseEvent){
            var _local2:* = _arg1.currentTarget;
            if (_local2.Done){
                this.Delete();
                return;
            };
            if (global.xn != undefined){
                this.tf3.text = xatlib.CleanText(global.xn);
            };
            if (global.xh != undefined){
                this.tf5.text = xatlib.CleanText(global.xh);
            };
            if (global.xp != undefined){
                this.tf4.text = xatlib.CleanText(global.xp);
                this.ChangeProfileAvs();
            };
            _local2.Obj.SetText(xconst.ST(66));
            _local2.Done = true;
        }
        function DeleteProfileAvs(){
            var _local1:MovieClip = this.mcprofilebackground.Dia;
            if (_local1.avc == undefined){
                return;
            };
            _local1.removeChild(_local1.avc);
            var _local2:* = 0;
            while (_local2 < _local1.acnt) {
                _local1.removeChild(_local1.xmc[_local2]);
                _local2++;
            };
        }
        function ChangeProfileAvs(){
            var r:* = undefined;
            var mc2:* = null;
            this.Dia = this.mcprofilebackground.Dia;
            var YY:* = xatlib.NY(this.Dia.txt1.YY);
            this.DeleteProfileAvs();
            var Press:* = function (){
                chat.mainDlg.GotoProfile(todo.w_userno);
            };
            this.Dia.avc = new xAvatar(this.Dia, this.tf4.text, undefined, Press, xatlib.FindUser(todo.w_userno));
            var mc:* = this.Dia.avc.Av;
            mc.x = xatlib.NX((144 - 77));
            mc.y = YY;
            this.Dia.acnt = int((xatlib.NX(470) / 33));
            this.Dia.xmc = new Array();
            var e:* = 0;
            while (e < this.Dia.acnt) {
                r = xatlib.RandAv();
                this.Dia.xmc[e] = new xAvatar(this.Dia, r);
                mc2 = this.Dia.xmc[e].Av;
                mc2.x = (xatlib.NX(144) + (33 * e));
                mc2.y = YY;
                mc2.txt = r;
                mc2.addEventListener(MouseEvent.MOUSE_DOWN, this.AvPress);
                e = (e + 1);
            };
        }
        function AvPress(_arg1:MouseEvent){
            var _local2:* = _arg1.currentTarget;
            var _local3:* = this.mcprofilebackground.Dia;
            this.tf4.text = _local2.txt;
            this.ChangeProfileAvs();
        }
        function OK_onRelease(_arg1:MouseEvent=undefined){
            var _local2:*;
            if ((((todo.messageecho == "p")) && (!((todo.w_avatar == xatlib.CleanAv(this.tf4.text)))))){
                chat.sending_lc.send(chat.fromxat, "onMsg", 4, 0, "p");
            };
            if (((((((!((todo.w_name == this.tf3.text))) || (!((todo.w_avatar == xatlib.CleanAv(this.tf4.text)))))) || (!((todo.w_homepage == this.tf5.text))))) || (this.changed))){
                todo.w_name = xatlib.NameNoXat(xatlib.CleanText(this.tf3.text), 1);
                todo.w_avatar = xatlib.CleanAv(this.tf4.text);
                this.tf4.text = xatlib.UrlAv(todo.w_avatar);
                todo.w_homepage = this.tf5.text;
                todo.w_userrev++;
                xatlib.PurgeMessageFromUser(todo.w_userno);
                _local2 = xatlib.FindUser(todo.w_userno);
                if (_local2 != -1){
                    todo.Users[_local2].n = todo.w_name;
                    todo.Users[_local2].a = todo.w_avatar;
                    todo.Users[_local2].h = todo.w_homepage;
                    todo.Users[_local2].s = ((todo.Macros)!=undefined) ? todo.Macros["status"] : undefined;
                };
                network.UpdateFriendList(todo.w_userno, 1);
                todo.w_friendlist2[todo.w_userno] = undefined;
                xatlib.ReLogin();
            };
            xatlib.MainSolWrite("w_name", todo.w_name);
            xatlib.MainSolWrite("w_avatar", todo.w_avatar);
            xatlib.MainSolWrite("w_homepage", todo.w_homepage);
            xatlib.MainSolWrite("w_userrev", todo.w_userrev);
            todo.DoUpdate = true;
            this.Delete();
        }
        function More_onRelease(_arg1:MouseEvent=undefined){
            var _local2:String;
            _local2 = ((todo.chatdomain + "avatar.php?id=") + todo.w_userno);
            xatlib.UrlPopup(xconst.ST(63), _local2);
        }
        function Effect_onRelease(_arg1:MouseEvent){
            var _local2:*;
            if ((global.xc & 0x0800)){
                main.mcLoad.OpenByN(20032);
            } else {
                _local2 = xatlib.xatlinks(xatlib.PageUrl(20032));
                xatlib.UrlPopup(xconst.ST(8), _local2, xconst.ST(17));
            };
        }
        function OK_onLang(_arg1:MouseEvent=undefined){
            var _local2:String = ((todo.chatdomain + "changelanguage.php?id=") + todo.w_useroom);
            xatlib.UrlPopup(xconst.ST(8), _local2);
        }
        function onPowers(_arg1:MouseEvent=undefined){
            this.changed = true;
            var _local2:* = new Object();
            _local2.muserid = todo.w_userno;
            _local2.strid = (((todo.w_registered == undefined)) ? (" " + todo.w_userno) : ((((" " + todo.w_registered) + " (") + todo.w_userno) + ")"));
            main.openDialog(7, _local2);
        }
		function onPowers2(_arg1:MouseEvent=undefined){
            this.changed = true;
            var _local2:* = new Object();
            _local2.muserid = todo.w_userno;
            _local2.strid = (((todo.w_registered == undefined)) ? (" " + todo.w_userno) : ((((" " + todo.w_registered) + " (") + todo.w_userno) + ")"));
            main.openDialog(8, _local2);
        }
        function onGifts(_arg1:MouseEvent=undefined){
            xmessage.OpenGifts(todo.w_userno);
        }
        function Login_onRelease(){
            this.Delete();
        }
        function Register_Link(_arg1){
            var _local2:*;
            _local2 = (todo.usedomain + "/profile");
            if (_arg1 != undefined){
                _local2 = (_local2 + ((((("?UserId=" + todo.w_userno) + "&k2=") + todo.w_k2) + "&mode=") + _arg1));
            };
            return (_local2);
        }
        function onDivorce(_arg1){
            xkiss.CreateBuystuff(todo.w_d2, 2);
        }
        function onMacros(_arg_1:MouseEvent=undefined){
            main.openDialog(12);
        }
        function onPawns(_arg_1:MouseEvent=undefined){
            //main.openDialog(13);
            this.changed = true;
            var _local2:* = new Object();
            _local2.muserid = todo.w_userno;
            _local2.strid = (((todo.w_registered == undefined)) ? (" " + todo.w_userno) : ((((" " + todo.w_registered) + " (") + todo.w_userno) + ")"));
            _local2.pawns = true;
            main.openDialog(7, _local2);
        }
    }
}//package 
