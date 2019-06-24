package {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
    import flash.net.*;
    import flash.ui.*;

    public class DialogActions extends Sprite {

        const TO = 5;

        public var mcviewprofilebackground;
        var bBan;
        var bDunce;
        var bNaughty;
        var tf;
        var tf2;
        var SavedUserNo;
        var un = "";

        public function DialogActions(_arg1){
            var yy:* = undefined;
            var Dia:* = undefined;
            var s:* = undefined;
            var mc:* = null;
            var sxx:* = undefined;
            var soci:* = undefined;
            var butstate:* = undefined;
            var UserNo:* = _arg1;
            super();
            var uid:* = xatlib.FindUser(UserNo);
            var PrivChatOnly:* = (xatlib.xInt(todo.Users[uid].Location) >= 128);
            var ShowAsBanned:* = ((((todo.Users[uid].banned) && (!(todo.Users[uid].friend)))) || (todo.Users[uid].forever));
            var Me:* = xatlib.FindUser(todo.w_userno);
            var xx:* = 0;
            yy = 0;
            var StatusText:* = "";
            var bKick:* = undefined;
            var bMake:* = undefined;
            var bMake2:* = undefined;
            var bMTP:* = undefined;
            this.bBan = undefined;
            var i:* = xatlib.FindUser(todo.w_userno);
            var TabNo:* = 0;
            if (main.utabsmc.tabs[1].Main){
                TabNo = 1;
            };
            if (((main.utabsmc.tabs[2]) && (main.utabsmc.tabs[2].Main))){
                TabNo = 2;
            };
            var NotFriendButton:* = ((!((TabNo == 0))) && (todo.HasPower(i, 212)));
			var OurRank:* = xatlib.GetRank(todo.w_userno);
			var ThierRank:* = xatlib.GetRank(UserNo);
            if (((((((todo.w_owner) || (todo.w_moderator))) || (todo.w_member))) && (!(((!((TabNo == 0))) && (!(network.OnFriendList(todo.Users[i].u)))))))){
                if ((todo.Users[i].flag0 & 0x0200)){
                    bKick = false;
                } else {
                    if (todo.HasPower(i, 28)){
                        if (todo.w_mainowner){
                            bKick = false;
                            if (((todo.Users[uid].online) && (!(todo.Users[uid].mainowner)))){
                                bKick = true;
                            };
                        } else {
                            if (todo.w_owner){
                                bKick = false;
                                if (((((todo.Users[uid].online) && (!(todo.Users[uid].mainowner)))) && (!(todo.Users[uid].owner)))){
                                    bKick = true;
                                };
                            } else {
                                if (todo.w_moderator){
                                    bKick = false;
                                    if (((((((todo.Users[uid].online) && (!(todo.Users[uid].mainowner)))) && (!(todo.Users[uid].owner)))) && (!(todo.Users[uid].moderator)))){
                                        bKick = true;
                                    };
                                } else {
                                    if (todo.w_member){
                                        if (((((((((todo.Users[uid].online) && (!(todo.Users[uid].mainowner)))) && (!(todo.Users[uid].owner)))) && (!(todo.Users[uid].moderator)))) && (todo.Users[uid].banned))){
                                            bKick = true;
                                        };
                                    };
                                };
                            };
                        };
                    } else {
                        if (((todo.w_owner) || (todo.w_moderator))){
                            bKick = ((((((((todo.Users[uid].online) && (!(todo.Users[uid].mainowner)))) && (!(todo.Users[uid].owner)))) && (!(todo.Users[uid].moderator)))) ? true : false);
                        };
                    };
					if ((((OurRank >= ThierRank)) && (todo.HasPower(i, 158)))){
						bKick = (this.bDunce = true);
					};
                };
            };
            if (((((todo.w_owner) || (todo.w_moderator))) && (!(((!((TabNo == 0))) && (!(network.OnFriendList(todo.Users[i].u)))))))){
                this.bBan = false;
                if ((todo.Users[i].flag0 & 0x0200)){
                    this.bBan = false;
                } else {
                    if (todo.w_mainowner){
                        if (!todo.Users[uid].mainowner){
                            this.bBan = true;
                        };
                    } else {
                        if (todo.w_owner){
                            if (((!(todo.Users[uid].mainowner)) && (!(todo.Users[uid].owner)))){
                                this.bBan = true;
                            };
                        } else {
                            if (todo.w_moderator){
                                if (((((!(todo.Users[uid].mainowner)) && (!(todo.Users[uid].owner)))) && (!(todo.Users[uid].moderator)))){
                                    this.bBan = true;
                                };
                            };
                        };
                    };
                };
            };
            if (((((((todo.w_mainowner) || (todo.w_owner))) || (todo.w_moderator))) && (!(((!((TabNo == 0))) && (!(network.OnFriendList(todo.Users[i].u)))))))){
                bMake = true;
            };
            if (((((todo.w_mainowner) || (todo.w_owner))) && (!(((!((TabNo == 0))) && (!(network.OnFriendList(todo.Users[i].u)))))))){
                bMake2 = true;
            };
            if (todo.Users[uid].online){
                bMTP = true;
            };
            if (TabNo != 0){
                var _local3 = (this.bBan = (this.bDunce = (this.bNaughty = undefined)));
                bMake2 = _local3;
                bMake = _local3;
                bKick = _local3;
            };
            network.NetworkLocateUser(UserNo);
            xx = (((main.upx - 270) - 15) - 50);
            if (xx < 5){
                xx = 5;
            };
            yy = xatlib.NY(30);
            StatusText = (StatusText + xatlib.GetUserStatus(uid));
            var dlght:* = 100;
            if (PrivChatOnly){
                dlght = (dlght + xatlib.NY(40));
            } else {
                dlght = (dlght + xatlib.NY(20));
                dlght = (dlght + xatlib.NY(40));
                dlght = (dlght + xatlib.NY(40));
                if (((((((!((this.bBan == undefined))) || (!((this.bDunce == undefined))))) || (!((bKick == undefined))))) || (!((this.bNaughty == undefined))))){
                    dlght = (dlght + xatlib.NY(40));
                };
                if (bMake != undefined){
                    dlght = (dlght + xatlib.NY(40));
                };
                if (bMake2 != undefined){
                    dlght = (dlght + xatlib.NY(40));
                };
                if (bMTP != undefined){
					dlght = (dlght + xatlib.NY(80));
                    //dlght = (dlght + xatlib.NY(120)); big gift button
                };
                if (NotFriendButton){
                    dlght = (dlght + xatlib.NY(40));
                };
            };
            this.mcviewprofilebackground = new xDialog(this, xx, yy, (270 + 60), dlght, xatlib.GetNameNumber(UserNo), undefined, 0, this.Delete);
            Dia = this.mcviewprofilebackground.Dia;
            Dia.UserNo = UserNo;
            var Press:* = function (){
                chat.mainDlg.GotoProfile(mcviewprofilebackground.UserNo);
            };
            yy = (yy + 35);
            if (!ShowAsBanned){
                Dia.avc = new xAvatar(this.mcviewprofilebackground, todo.Users[uid].a, xconst.ST(140), Press, uid);
                mc = Dia.avc.Av;
                mc.UserNo = UserNo;
                mc.x = (xx + 5);
                mc.y = yy;
            };
            Dia.txt1 = xatlib.createTextNoWrap(Dia, ((xx + 5) + 35), (yy - 7), (270 + 10), (15 + 20), ((ShowAsBanned) ? xconst.ST(25) : xatlib.StripSmilies(xatlib.GetUsername(UserNo))), 0, 0, 100, 0, 14, "left", 1);
            Dia.txt2 = xatlib.createTextNoWrap(Dia, ((xx + 5) + 35), (yy + 9), (270 + 10), (15 + 20), StatusText, 0, 0, 100, 0, 14, "left", 1);
            yy = (yy + 50);
            if (!ShowAsBanned){
                var addSocial:* = function (_arg1, _arg2){
                    if (((!(_arg2)) || ((_arg2.length <= 5)))){
                        return;
                    };
                    Dia.soc[soci] = new MovieClip();
                    Dia.addChild(Dia.soc[soci]);
                    Dia.soc1[soci] = new library(_arg1);
                    Dia.soc1[soci].scaleX = (Dia.soc1[soci].scaleY = (xatlib.NY(180) / 200));
                    Dia.soc[soci].addChild(Dia.soc1[soci]);
                    Dia.soc[soci].x = sxx;
                    Dia.soc[soci].y = yy;
                    sxx = (sxx + xatlib.NY(40));
                    Dia.soc[soci].url = _arg2;
                    Dia.soc[soci].addEventListener(MouseEvent.MOUSE_DOWN, Home1_onPress);
                    Dia.soc[soci].hint = {
                        Hint:_arg2,
                        mc:Dia.soc[soci]
                    };
                    Dia.soc[soci].addEventListener(MouseEvent.ROLL_OVER, main.hint.EasyHint);
                    Dia.soc[soci].addEventListener(MouseEvent.ROLL_OUT, main.hint.HintOff);
                    Dia.soc[soci].buttonMode = true;
                    soci++;
                };
                sxx = (mc.x + 8);
                soci = 0;
                Dia.soc = new Array();
                Dia.soc1 = new Array();
                addSocial("ho", ((ShowAsBanned) ? undefined : todo.Users[uid].h));
                yy = (yy + xatlib.NY(36));
            };
            var PrivFlags:* = undefined;
			if (((todo.HasPower(uid, 10)) && (!(((((todo.w_mainowner) || (todo.w_owner))) || (todo.w_moderator)))))){
				PrivFlags = (xBut.b_Grayed + xBut.b_NoPress);
			};
            Dia.pm = new xBut(Dia, (xx + 10), yy, 150, xatlib.NY(30), xconst.ST(69), this.ViewprofileonPrivChat, PrivFlags);
            Dia.pm.SetRoll(xconst.ST(70));
            Dia.pm.But.UserNo = UserNo;
            PrivFlags = undefined;
			if (((todo.HasPower(uid, 69)) && (!(((((todo.w_mainowner) || (todo.w_owner))) || (todo.w_moderator)))))){
				PrivFlags = (xBut.b_Grayed + xBut.b_NoPress);
			};
            Dia.im = new xBut(Dia, (xx + 170), yy, 150, xatlib.NY(30), xconst.ST(71), this.ViewprofileonPriv, PrivFlags);
            Dia.im.SetRoll(xconst.ST(72));
            Dia.im.But.UserNo = UserNo;
            s = "";
            var friend:* = network.OnFriendList(UserNo);
            if (friend){
                s = xconst.ST(73);
            } else {
                s = xconst.ST(74);
            };
            yy = (yy + xatlib.NY(40));
            Dia.af = new xBut(Dia, (xx + 10), yy, 150, xatlib.NY(30), s, this.ViewprofileonFriend, ((todo.Users[uid].banned) ? (xBut.b_Grayed + xBut.b_NoPress) : 0));
            Dia.af.SetRoll(xconst.ST(75));
            Dia.af.But.UserNo = UserNo;
            s = xconst.ST(76);
            if (network.OnIgnoreList(UserNo)){
                s = xconst.ST(77);
            };
            Dia.ig = new xBut(Dia, (xx + 170), yy, 150, xatlib.NY(30), s, this.ViewprofileonIgnore);
            Dia.ig.SetRoll(xconst.ST(78));
            Dia.ig.But.UserNo = UserNo;
            if (NotFriendButton){
                yy = (yy + xatlib.NY(40));
                if (friend == 3){
                    s = xconst.ST(263);
                } else {
                    s = xconst.ST(262);
                };
                Dia.nf = new xBut(Dia, (xx + 10), yy, 150, xatlib.NY(30), s, this.ViewprofileonNotFriend);
                Dia.nf.But.UserNo = UserNo;
            };
            if (((((((!((bKick == undefined))) || (!((this.bBan == undefined))))) || (!((this.bDunce == undefined))))) || (!((this.bNaughty == undefined))))){
                yy = (yy + xatlib.NY(40));
            };
            if (bKick != undefined){
                s = xconst.ST(79);
                Dia.kick = new xBut(Dia, (xx + 10), yy, 150, xatlib.NY(30), s, this.ViewprofileonKick, ((bKick) ? 0 : (xBut.b_Grayed + xBut.b_NoPress)));
                Dia.kick.SetRoll(xconst.ST(80));
                Dia.kick.But.UserNo = UserNo;
            };
            if (((((!((this.bBan == undefined))) || (!((this.bDunce == undefined))))) || (!((this.bNaughty == undefined))))){
                s = xconst.ST(81);
                if ((((uid > -1)) && (todo.Users[uid].banned))){
                    s = xconst.ST(82);
                };
                Dia.ban = new xBut(Dia, (xx + 170), yy, 150, xatlib.NY(30), s, this.ViewprofileonGag, ((((((this.bBan) || (this.bDunce))) || (this.bNaughty))) ? 0 : (xBut.b_Grayed + xBut.b_NoPress)));
                Dia.ban.SetRoll(xconst.ST(83));
                Dia.ban.But.UserNo = UserNo;
            };
            if (bMake != undefined){
                yy = (yy + xatlib.NY(40));
                s = xconst.ST(135);
                butstate = (xBut.b_Grayed + xBut.b_NoPress);
                if (((((((todo.Users[uid].online) && (!(todo.Users[uid].banned)))) && (((((((todo.Users[uid].member) || (todo.Users[uid].moderator))) || (todo.Users[uid].owner))) || (todo.Users[uid].gagged))))) || (!(todo.Users[uid].online)))){
                    if ((todo.Users[i].flag0 & 0x0200)){
                    } else {
                        if (todo.w_mainowner){
                            if (!todo.Users[uid].mainowner){
                                butstate = 0;
                            };
                        } else {
                            if (todo.w_owner){
                                if (((!(todo.Users[uid].mainowner)) && (!(todo.Users[uid].owner)))){
                                    butstate = 0;
                                };
                            } else {
                                if (todo.w_moderator){
                                    if (((((!(todo.Users[uid].mainowner)) && (!(todo.Users[uid].owner)))) && (!(todo.Users[uid].moderator)))){
                                        butstate = 0;
                                    };
                                };
                            };
                        };
                    };
                };
                Dia.mv = new xBut(Dia, (xx + 10), yy, 150, xatlib.NY(30), s, this.ViewprofileonUnMake, butstate);
                Dia.mv.But.UserNo = UserNo;
                s = xconst.ST(84);
                butstate = (xBut.b_Grayed + xBut.b_NoPress);
                if (((((todo.Users[uid].online) && (!(todo.Users[uid].banned)))) && (!(todo.Users[uid].member)))){
                    if ((todo.Users[i].flag0 & 0x0200)){
                    } else {
                        if (todo.w_mainowner){
                            if (!todo.Users[uid].mainowner){
                                butstate = 0;
                            };
                        } else {
                            if (todo.w_owner){
                                if (((!(todo.Users[uid].mainowner)) && (!(todo.Users[uid].owner)))){
                                    butstate = 0;
                                };
                            } else {
                                if (todo.w_moderator){
                                    if (((((!(todo.Users[uid].mainowner)) && (!(todo.Users[uid].owner)))) && (!(todo.Users[uid].moderator)))){
                                        butstate = 0;
                                    };
                                };
                            };
                        };
                    };
                };
                Dia.me = new xBut(Dia, (xx + 170), yy, 150, xatlib.NY(30), s, this.ViewprofileonMember, butstate);
                Dia.me.But.UserNo = UserNo;
            };
            if (bMake2 != undefined){
                yy = (yy + xatlib.NY(40));
                s = xconst.ST(88);
                butstate = (xBut.b_Grayed + xBut.b_NoPress);
                if (((((((todo.Users[uid].online) && (!(todo.Users[uid].banned)))) && (!(todo.Users[uid].moderator)))) || (((todo.Users[uid].moderator) && ((todo.Users[uid].flag0 & 0x0200)))))){
                    if ((todo.Users[i].flag0 & 0x0200)){
                    } else {
                        if (todo.w_mainowner){
                            if (!todo.Users[uid].mainowner){
                                butstate = 0;
                            };
                        } else {
                            if (todo.w_owner){
                                if (((!(todo.Users[uid].mainowner)) && (!(todo.Users[uid].owner)))){
                                    butstate = 0;
                                };
                            };
                        };
                    };
                };
                Dia.mm = new xBut(Dia, (xx + 10), yy, 150, xatlib.NY(30), s, this.ViewprofileonModerate, butstate);
                Dia.mm.But.UserNo = UserNo;
                s = xconst.ST(136);
                butstate = (xBut.b_Grayed + xBut.b_NoPress);
                if (((((((todo.Users[uid].online) && (!(todo.Users[uid].banned)))) && (!(todo.Users[uid].owner)))) || (((todo.Users[uid].owner) && ((todo.Users[uid].flag0 & 0x0200)))))){
                    if ((todo.Users[i].flag0 & 0x0200)){
                    } else {
                        if (todo.w_mainowner){
                            if (!todo.Users[uid].mainowner){
                                butstate = 0;
                            };
                        };
                    };
                };
                Dia.mo = new xBut(Dia, (xx + 170), yy, 150, xatlib.NY(30), s, this.ViewprofileonOwner, butstate);
                Dia.mo.But.UserNo = UserNo;
            };
            if (bMTP){
                if (!todo.bMobile){
                    yy = (yy + xatlib.NY(40));
                    s = xconst.ST(148);
                    if (todo.Users[Me].Bride){
                        s = xconst.ST(150);
                    };
                    Dia.ma = new xBut(Dia, (xx + 10), yy, 150, xatlib.NY(30), s, this.ViewprofileonMarry, 0);
                    Dia.ma.But.UserNo = UserNo;
                    Dia.ma.But.Mode = 1;
                    if (todo.Users[Me].Bride){
                        Dia.ma.But.Mode = 2;
                    };
                    Dia.dv = new xBut(Dia, (xx + 170), yy, 150, xatlib.NY(30), xconst.ST(149), this.ViewprofileonMarry, 0);
                    Dia.dv.But.UserNo = UserNo;
                    Dia.dv.But.Mode = 3;
                    Dia.dv.SetRoll(xconst.ST(151));
					
                    yy = (yy + xatlib.NY(40));
					
                    Dia.po = new xBut(Dia, (xx + 10), yy, 150, xatlib.NY(30), xconst.ST(189), this.ViewprofileonPowers, (xBut.b_Grayed + xBut.b_NoPress));
                    xatlib.AttachBut(Dia.po, "pwr");
                    Dia.po.But.UserNo = UserNo;
                    Dia.gf = new xBut(Dia, (xx + 170), yy, 150, xatlib.NY(30), xconst.ST(0x0101), this.ViewprofileonMarry, 0);
                    xatlib.AttachBut(Dia.gf, "giftb");
                    Dia.gf.But.UserNo = UserNo;
                    Dia.gf.But.Mode = 4;
                    Dia.gf.SetRoll(xconst.ST(0x0100));	
					/*
                    Dia.po = new xBut(Dia, (xx + 10), yy, 100, xatlib.NY(30), xconst.ST(189), this.ViewprofileonPowers, (xBut.b_Grayed + xBut.b_NoPress));
                    xatlib.AttachBut(Dia.po, "pwr");
                    Dia.po.But.UserNo = UserNo;
					Dia.pwns = new xBut(Dia, (xx + 114), yy, 100, xatlib.NY(30), "Pawns", this.ViewprofileonPawns, (xBut.b_Grayed + xBut.b_NoPress));
					xatlib.AttachBut(Dia.pwns, "p1pwn");
                    Dia.pwns.But.UserNo = UserNo;
                    Dia.gf = new xBut(Dia, (xx + 218), yy, 100, xatlib.NY(30), xconst.ST(0x0101), this.ViewprofileonMarry, 0);
                    xatlib.AttachBut(Dia.gf, "giftb");
                    Dia.gf.But.UserNo = UserNo;
                    Dia.gf.But.Mode = 4;
                    Dia.gf.SetRoll(xconst.ST(0x0100));		
					*/
					/* big gift button
                    yy = (yy + xatlib.NY(40));
                    Dia.po = new xBut(Dia, (xx + 10), yy, 150, xatlib.NY(30), xconst.ST(189), this.ViewprofileonPowers, (xBut.b_Grayed + xBut.b_NoPress));
                    xatlib.AttachBut(Dia.po, "pwr");
                    Dia.po.But.UserNo = UserNo;
					Dia.pwns = new xBut(Dia, (xx + 170), yy, 150, xatlib.NY(30), "Pawns", this.ViewprofileonPawns, (xBut.b_Grayed + xBut.b_NoPress));
					xatlib.AttachBut(Dia.pwns, "p1pwn");
                    Dia.pwns.But.UserNo = UserNo;
                    Dia.pwns.SetRoll("Pawns.");
					yy = (yy + xatlib.NY(40));
                    Dia.gf = new xBut(Dia, (xx + 10), yy, 310, xatlib.NY(30), xconst.ST(0x0101), this.ViewprofileonMarry, 0);
                    xatlib.AttachBut(Dia.gf, "giftb");
                    Dia.gf.But.UserNo = UserNo;
                    Dia.gf.But.Mode = 4;
                    Dia.gf.SetRoll(xconst.ST(0x0100));*/
                };
            };
        }
        function Delete(){
            main.hint.HintOff();
            main.closeDialog();
        }
        function Home1_onPress(_arg_1:MouseEvent){
            var _local_2:String = _arg_1.currentTarget.url;
            if (_local_2.substr(0, 4).toLowerCase() != "http"){
                _local_2 = ("//" + _local_2);
            };
            _local_2 = xatlib.xatlinks(_local_2);
            if (chat.isKeyDown(Keyboard.SHIFT)){
                _local_2 = (_local_2 + "&f=1");
            };
            xatlib.UrlPopup(xconst.ST(21), _local_2);
        }
        function ViewprofileonPriv(_arg1){
            main.lockmc.visible = true;
            todo.PrivateMessage = this.mcviewprofilebackground.UserNo;
            this.Delete();
        }
        function ViewprofileonPrivChat(_arg1){
            var _local2:* = xatlib.FindUser(this.mcviewprofilebackground.UserNo);
            var _local3:* = todo.Users[_local2].Location;
            main.utabsmc.SetVisitorsTab();
            var _local4:* = 1;
            if (_local3){
                _local4 = (_local4 | 8);
            };
            _local4 = (_local4 | 16);
            var _local5:Number = main.ctabsmc.TabAdd(this.mcviewprofilebackground.UserNo, 0xFFFFFF, _local4, main.Private_onRelease, main.Private_onDelete);
            xmessage.OpenGifts(this.mcviewprofilebackground.UserNo, 2);
            main.ctabsmc.tabs[_local5].IMtype = _local3;
            main.ctabsmc.UpdateTabs(_local5);
            todo.DoBuildUserListScrollUp = true;
            todo.DoUpdateMessages = true;
            todo.ScrollDown = true;
            this.Delete();
        }
        function ViewprofileonIgnore(_arg1:MouseEvent=undefined){
            network.NetworkIgnore(this.mcviewprofilebackground.UserNo, ((chat.isKeyDown(Keyboard.SHIFT)) ? true : undefined));
            this.Delete();
        }
        function ViewprofileonGag(_arg1){
            var _local4:*;
            var _local2:* = this.mcviewprofilebackground.UserNo;
            var _local3:* = xatlib.FindUser(_local2);
            if (todo.Users[_local3].banned){
                network.NetworkGagUser("u", _local2, false, 0);
                this.Delete();
            } else {
                this.Delete();
                _local4 = new Object();
                _local4.UserNo = _local2;
                _local4.bBan = this.bBan;
                _local4.bDunce = this.bDunce;
                _local4.bNaughty = this.bNaughty;
                main.openDialog(11, _local4);
            };
        }
        function ViewprofileonKick(_arg1){
            var _local2:* = this.mcviewprofilebackground.UserNo;
            this.Delete();
            var _local3:* = new Object();
            _local3.UserNo = _local2;
            _local3.bBan = false;
            main.openDialog(11, _local3);
        }
        function ViewprofileonFriend(_arg1, _arg2=0){
            var _local3:* = this.mcviewprofilebackground.UserNo;
            network.NetworkFriendUser(_local3, ((_arg2) ? _arg2 : ((network.OnFriendList(_local3)) ? 0 : 1)));
            this.Delete();
            todo.DoBuildUserListScrollUp = true;
        }
        function ViewprofileonNotFriend(_arg1){
            var _local2:* = this.mcviewprofilebackground.UserNo;
            this.ViewprofileonFriend(_arg1, (((network.OnFriendList(_local2) == 3)) ? 1 : 3));
        }
        function ViewprofileonUnMake(_arg1){
            var _local2:* = this.mcviewprofilebackground.UserNo;
            network.NetworkMakeUser(_local2, "r");
            this.Delete();
        }
        function ViewprofileonMember(_arg1){
            var _local2:* = this.mcviewprofilebackground.UserNo;
            network.NetworkMakeUser(_local2, "e");
            this.Delete();
        }
        function ViewprofileonModerate(_arg1){
            var _local2:* = this.mcviewprofilebackground.UserNo;
            network.NetworkMakeUser(_local2, "m");
            this.Delete();
        }
        function ViewprofileonOwner(_arg1){
            var _local2:* = this.mcviewprofilebackground.UserNo;
            network.NetworkMakeUser(_local2, "M");
            this.Delete();
        }
        function ViewprofileonPowers(_arg1:Event){
            var _local2:* = new Object();
            _local2.muserid = this.mcviewprofilebackground.UserNo;
            _local2.strid = this.un;
            main.openDialog(7, _local2);
        }
		function ViewprofileonPawns(_arg1:Event){
            var _local2:* = new Object();
            _local2.muserid = this.mcviewprofilebackground.UserNo;
            _local2.strid = this.un;
            main.openDialog(8, _local2);
        }
        function ViewprofileonMarry(_arg1){
            var _local2:* = new Object();
            _local2.Marry = this.mcviewprofilebackground.UserNo;
            _local2.Mode = _arg1.currentTarget.Mode;
            main.openDialog(3, _local2);
            if (_arg1.currentTarget.Mode == 4){
                xmessage.OpenGifts(this.mcviewprofilebackground.UserNo);
            };
        }
        function WriteLocation(_arg1:String, _arg2, _arg3:String){
            var _local6:*;
            var _local7:*;
            var _local8:*;
            var _local9:*;
            var _local10:*;
            var _local11:*;
            if (!this.mcviewprofilebackground){
                return;
            };
            var _local4:MovieClip = this.mcviewprofilebackground.Dia;
            if (_local4.UserNo != xatlib.xInt(_arg2)){
                return;
            };
            var _local5:* = xatlib.xInt(_arg2).toString();
			if (_local5.substr(-12, 12) == "000000000000"){
                _local5 = (_local5.substr(0, (_local5.length - 12)) + "T");
            } else if (_local5.substr(-9, 9) == "000000000"){
                _local5 = (_local5.substr(0, (_local5.length - 9)) + "B");
            } else if (_local5.substr(-6, 6) == "000000"){
                _local5 = (_local5.substr(0, (_local5.length - 6)) + "M");
            };
			this.un = " " + (( _arg3!=undefined && _arg3!=null && _arg3 != '') ? (((_arg3 + " (") + _local5) + ")") : xatlib.xInt(_arg2));
            _local4.DiaBar.SetText(xatlib.FixLI(this.un));
            if (_local4.txt1 != undefined){
                if (_local4.txt4){
                    _local4.removeChild(_local4.txt4);
                };
                _local4.txt4 = new xSprite();
                _local4.addChild(_local4.txt4);
                xatlib.createTextNoWrap(_local4.txt4, 0, 0, (270 + 10), 15, _arg1, 0, 0, 100, 0, 14, "left", 1);
                _local4.txt4.x = (((_local4.DiaBack.x + 5) + 17) + 5);
                _local4.txt4.y = (((_local4.DiaBack.y + 37) + 15) + 16);
                if (xatlib.CountLinks(_arg1) != 0){
                    if (!((((todo.w_mainowner) || (todo.w_owner))) || (todo.w_moderator))){
                        _local6 = xatlib.FindUser(_local4.UserNo);
                        if ((todo.Users[_local6].Powers[0] & (1 << 10))){
                            _local7 = _local4.pm.But.y;
                            _local8 = _local4.pm.But.x;
                            _local4.removeChild(_local4.pm);
                            _local9 = undefined;
                            _local4.pm = new xBut(_local4, _local8, _local7, 150, xatlib.NY(30), xconst.ST(69), this.ViewprofileonPrivChat, _local9);
                            _local4.pm.SetRoll(xconst.ST(70));
                            _local4.pm.But.UserNo = _local4.UserNo;
                        };
                        if (todo.HasPower(_local6, 69)){
                            _local7 = _local4.im.But.y;
                            _local8 = _local4.im.But.x;
                            _local4.removeChild(_local4.im);
                            _local9 = undefined;
                            _local4.im = new xBut(_local4, _local8, _local7, 150, xatlib.NY(30), xconst.ST(71), this.ViewprofileonPriv, _local9);
                            _local4.im.SetRoll(xconst.ST(72));
                            _local4.im.But.UserNo = _local4.UserNo;
                        };
                    };
                    _local4.txt4.str = _arg1;
                    _local4.txt4.addEventListener(MouseEvent.MOUSE_DOWN, this.GoFriend);
                    _local4.txt4.addEventListener(MouseEvent.ROLL_OVER, this.GoFriendHint);
                    _local4.txt4.addEventListener(MouseEvent.ROLL_OUT, main.hint.HintOff);
                    _local4.txt4.buttonMode = true;
                    _local4.txt4.mouseChildren = false;
                };
                if (_local4.po != undefined){
                    _local6 = xatlib.FindUser(_local4.UserNo);
                    _local10 = _local4.po.But.y;
                    _local11 = _local4.po.But.x;
					
                    _local4.po = new xBut(_local4, _local11, _local10, 150, xatlib.NY(30), xconst.ST(189), this.ViewprofileonPowers, 0);
                    xatlib.AttachBut(_local4.po, "pwr");
                    _local4.po.But.UserNo = _local4.UserNo;
                };
				/*
                if (_local4.pwns != undefined){
                    _local6 = xatlib.FindUser(_local4.UserNo);
                    _local10 = _local4.pwns.But.y;
                    _local11 = _local4.pwns.But.x;
                    _local4.pwns = new xBut(_local4, _local11, _local10, 100, xatlib.NY(30), "Pawns", this.ViewprofileonPawns, 0);
					xatlib.AttachBut(_local4.pwns, "p1pwn");
                    _local4.pwns.But.UserNo = _local4.UserNo;
                };
				*/
            };
        }
        private function GoFriendHint(_arg1:MouseEvent){
            main.hint.Hint(0, 0, xconst.ST(91));
        }
        private function GoFriend(_arg1:MouseEvent){
            var _local2:* = xatlib.CountLinks(_arg1.currentTarget.str, 1);
            xatlib.UrlPopup(xconst.ST(91), _local2);
        }

    }
}//package 
