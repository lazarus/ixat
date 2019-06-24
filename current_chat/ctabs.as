package {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.geom.*;

    public class ctabs extends Sprite {

        public var tabs:Array;
        public var MaxT:Number = 10;
        var LastPC;
        var tabsmc;
        public var Notif:Boolean;

        public function ctabs(){
            this.tabs = new Array();
            super();
        }
        public function CreateTabs(){
            this.tabs[0] = new Object();
            this.tabs[0].t = (this.tabs[0].h = ((global.gn)!=null) ? global.gn : xconst.ST(0));
            this.tabs[0].Col = 0xFFFFFF;
            this.tabs[0].Flags = 0;
            this.tabs[0].pFunc = main(parent).Home_onRelease;
            this.tabs[0].Skip = true;
            this.tabs[1] = new Object();
            this.tabs[1].t = ((((!((global.xl == undefined))) && (!((global.xt == undefined))))) ? global.xt : "Error!");
            this.tabs[1].h = (this.tabs[1].t + " ");
            this.tabs[1].Col = 0xFFFFFF;
            this.tabs[1].Flags = 0;
            this.tabs[1].pFunc = main(parent).Lobby_onRelease;
            this.tabs[1].dFunc = main(parent).GoGroup;
            this.tabs[1].Skip = true;
            this.UpdateTabs(0);
        }
        public function UpdateTabs(_arg1:Number=NaN){
            var _local4:*;
            if (_arg1 >= this.MaxT){
                _arg1 = NaN;
            };
            if (!isNaN(_arg1)){
                _local4 = 0;
                while (_local4 < this.tabs.length) {
                    this.tabs[_local4].Main = false;
                    if (_local4 != _arg1){
                        this.tabs[_local4].Sound = undefined;
                    };
                    _local4++;
                };
                this.tabs[_arg1].Main = true;
                xmessage.DeleteOneUserMc(xatlib.FindUser(this.LastPC));
                this.LastPC = this.tabs[_arg1].User;
                xmessage.DeleteOneUserMc(xatlib.FindUser(this.LastPC));
            };
            if (this.tabs.length > 2){
                this.tabs[0].Skip = undefined;
            } else {
                if (this.tabs[1].Skip == true){
                    this.tabs[0].Skip = true;
                };
            };
            this.AddTabs(todo.tpx, todo.tpy, todo.tpw, todo.tph);
            var _local2:* = 0;
            while (_local2 < this.tabs.length) {
                this.ColorTab(_local2, this.tabs[_local2].Col);
                _local2++;
            };
            var _local3:* = this.TabUser();
            if (_local3 != todo.LastTabUser){
                if (chat.sending_lc != undefined){
                    chat.sending_lc.send(chat.fromxat, "onMsg", 2, (((((_local3 == undefined)) || (isNaN(_local3)))) ? 0 : _local3), "");
                };
            };
            todo.LastTabUser = _local3;
        }
        public function ColorTab(_arg1:Number, _arg2:Number){
            if ((((this.tabs[_arg1].Flags & 32)) && (this.tabs[_arg1].Main))){
                _arg2 = 0xFFFFFF;
            };
            this.tabs[_arg1].Col = _arg2;
            if (this.tabs[_arg1].mc == undefined){
                return;
            };
            var _local3:* = this.tabs[_arg1].mc.bub.xitem.back;
            if (!_local3){
                return;
            };
            var _local4:* = _local3.transform.colorTransform;
            _local4.color = _arg2;
            _local3.transform.colorTransform = _local4;
            if ((((_arg2 == 0xFFFFFF)) && ((this.tabs[_arg1].Flags & 1)))){
                _local3.alpha = 0;
            } else {
                _local3.alpha = 1;
            };
        }
        public function GlowTab(_arg1:Number){
            if (this.tabs[_arg1].mc == undefined){
                return;
            };
            if (this.tabs[_arg1].Sound == undefined){
                todo.DoMessageSnd = false;
                todo.DoTabSnd = true;
                this.tabs[_arg1].Sound = true;
            };
            this.tabs[_arg1].glowc = 6;
            todo.TabGlowFlag = true;
            this.tabs[_arg1].mc.bub.filters = [todo.TextGlow];
        }
        public function AddTabText(_arg1:Number, _arg2:Number, _arg3:Number){
            var XX:* = undefined;
            var YY:* = undefined;
            var swt:* = undefined;
            var n:* = _arg1;
            var sw:* = _arg2;
            var sh:* = _arg3;
            var mc:* = this.tabs[n].mc;
            var Tab:* = this.tabs[n];
            var sym:* = "bubble";
            if ((Tab.Flags & 1)){
                sym = "lock";
            };
            if ((Tab.Flags & 8)){
                sym = (10000 + Tab.Location);
            };
            if ((Tab.Flags & 32)){
                sym = "notif";
            };
            var Tx:* = 4;
            if (!(Tab.Flags & 4)){
                mc.bub = new library(sym);
                mc.addChild(mc.bub);
                XX = mc.bub.width;
                YY = mc.bub.height;
                var _local5 = mc.bub;
                with (_local5) {
                    scaleX = (scaleY = ((1 / YY) * (sh - 6)));
                    y = 3;
                    swt = sw;
                    if (swt > 100){
                        swt = 100;
                    };
                    x = (sw * (10 / xatlib.NX(120)));
                    Tx = int(((x + (scaleX * XX)) + (sw * (4 / 120))));
                };
            };
            var mcFmt:* = new TextFormat();
            mcFmt.align = "left";
            mcFmt.bold = true;
            mcFmt.font = "_sans";
            var s2:* = xatlib.Blend(sh, 18, 28, 10, 16);
            mcFmt.size = int(s2);
            mcFmt.color = 0x101010;
            var mcTxt:* = new TextField();
            mcTxt.x = Tx;
            mcTxt.y = 0;
            mcTxt.width = (sw - Tx);
            mcTxt.height = sh;
            mcTxt.autoSize = TextFieldAutoSize.NONE;
            mcTxt.selectable = false;
            mcTxt.defaultTextFormat = mcFmt;
            mcTxt.text = Tab.t;
            var t:* = mc.addChild(mcTxt);
            var z:* = xatlib.Blend((sh - mcTxt.textHeight), 5, 10, 0, 3);
            mcTxt.y = (mcTxt.y + z);
            mcTxt.y = (mcTxt.y + z);
        }
        public function AddTabs(_arg1, _arg2, _arg3, _arg4){
            var Main:* = undefined;
            var MainX:* = undefined;
            var mcx:* = null;
            var Wid3:* = undefined;
            var mc:* = undefined;
            var Mask:* = undefined;
            var tpx:* = _arg1;
            var tpy:* = _arg2;
            var tpw:* = _arg3;
            var tph:* = _arg4;
            var n:* = this.tabs.length;
            var v:* = 0;
            var m:* = 0;
            while (m < n) {
                if (this.tabs[m].Skip != true){
                    v = (v + 1);
                };
                m = (m + 1);
            };
            var RightM:* = 12;
            var HasTickle:* = (((v > 2)) && ((this.tabs[2].Flags & 32)));
            var TickWidth:* = xatlib.xInt(20);
            if (HasTickle){
                RightM = 6;
            };
            RightM = xatlib.NX(RightM);
            var f:* = (xatlib.c_solid | xatlib.c_NoCol);
            if (v > 0){
                f = ((xatlib.c_bl | xatlib.c_nolb) | xatlib.c_NoCol);
            };
            if (this.tabsmc != null){
                removeChild(this.tabsmc);
            };
            this.tabsmc = new MovieClip();
            addChild(this.tabsmc);
            this.tabsmc.x = tpx;
            this.tabsmc.y = (tpy + tph);
            var mctextbackgroundb:* = xatlib.AddBackground(this.tabsmc, 0, -(tph), tpw, tph, f);
            if (v == 0){
                return;
            };
            var MainW:* = xatlib.NX(120);
            if (MainW > (tpw / 2)){
                MainW = xatlib.xInt((tpw / 2));
            };
            var Olap:* = 3;
            if (v > this.MaxT){
                v = this.MaxT;
            };
            var Wid2:* = xatlib.xInt(((((tpw - RightM) - MainW) + (Olap * 2)) / (v - 1)));
            if (HasTickle){
                MainW = xatlib.NX(68);
                Wid2 = xatlib.NX(64);
                if (this.tabs[2].Main){
                    MainW = Wid2;
                };
                if (this.tabs[0].Main){
                    MainW = (MainW - 3);
                };
            };
            var xx:* = 0;
            var TabH:* = xatlib.NY(24);
            if (Wid2 > MainW){
                Wid2 = MainW;
            };
            var vv:* = 0;
            m = 0;
            while (m < n) {
                if (this.tabs[m].Skip == true){
                } else {
                    vv = (vv + 1);
                    if (vv > this.MaxT){
                        break;
                    };
                    if (this.tabs[m].Main == true){
                        if ((this.tabs[m].Flags & 32)){
                            MainW = TickWidth;
                        };
                        Main = m;
                        MainX = (xx - Olap);
                        xx = (xx + (MainW - (2 * Olap)));
                        if (m == 0){
                            MainX = (MainX + Olap);
                            xx = (xx + Olap);
                        };
                    } else {
                        if (this.tabsmc.sec == undefined){
                            this.tabsmc.sec = new MovieClip();
                            this.tabsmc.addChild(this.tabsmc.sec);
                        };
                        Wid3 = Wid2;
                        if (((HasTickle) && ((vv == 3)))){
                            Wid3 = TickWidth;
                        };
                        mcx = xatlib.ButtonCurve2(8, (Wid3 + 1), TabH, ((xatlib.c_tl + xatlib.c_tr) + xatlib.c_nolt), 0, 0xCCCCCC, 0, 0xFFFFFF, 0.4);
                        this.tabsmc.sec.addChild(mcx);
                        this.tabs[m].mc = mcx;
                        this.AddTabText(m, Wid3, TabH);
                        mcx.x = (mcx.x + xx);
                        xx = (xx + Wid3);
                    };
                };
                m = (m + 1);
            };
            mcx = xatlib.ButtonCurve2(8, MainW, TabH, ((xatlib.c_tl + xatlib.c_tr) + xatlib.c_nolt), 1, 0xCCCCCC, 1, 0xFFFFFF, 0.4);
            mcx.x = MainX;
            this.tabsmc.addChild(mcx);
            this.tabs[Main].mc = mcx;
            this.AddTabText(Main, MainW, TabH);
            vv = this.MaxT;
            m = 0;
            while (m < n) {
                vv = (vv - 1);
                if (vv < 0){
                    break;
                };
                if (this.tabs[m].Skip == true){
                } else {
                    mc = this.tabs[m].mc;
                    mc.dFunc = this.tabs[m].dFunc;
                    mc.t = this.tabs[m].t;
                    mc.h = this.tabs[m].h;
                    mc.n = m;
                    mc.buttonMode = true;
                    mc.mouseChildren = false;
                    mc.addEventListener(MouseEvent.ROLL_OVER, this.TabRollover);
                    mc.addEventListener(MouseEvent.ROLL_OUT, main.hint.HintOff);
                    mc.addEventListener(MouseEvent.MOUSE_DOWN, this.TabMouseDown);
                };
                m = (m + 1);
            };
            if (this.tabsmc.sec != undefined){
                Mask = xatlib.ButtonCurve2(8, MainW, TabH, (((xatlib.c_tl + xatlib.c_tr) + xatlib.c_nolt) + xatlib.c_inv), 0, 0, 0);
                Mask.x = MainX;
                this.tabsmc.sec.addChild(Mask);
                this.tabsmc.sec.mask = Mask;
                Mask.visible = false;
            };
            var _local6 = this.tabsmc;
            with (_local6) {
                graphics.lineStyle(1, 0xCCCCCC, 100);
                graphics.moveTo(0, 0);
                graphics.lineTo(MainX, 0);
                graphics.moveTo((MainX + MainW), 0);
                graphics.lineTo((int(tpw) - 8), 0);
            };
            this.tabsmc.addEventListener(MouseEvent.ROLL_OUT, this.TabMouseOut);
        }
        function TabMouseDown(_arg1:MouseEvent){
            if (this.tabs[_arg1.currentTarget.n].pFunc){
                this.tabs[_arg1.currentTarget.n].pFunc(_arg1.currentTarget.n);
            };
        }
        function TabMouseOut(_arg1:MouseEvent){
            if (this.tabsmc.del != undefined){
                this.tabsmc.removeChild(this.tabsmc.del);
                this.tabsmc.del = undefined;
            };
        }
        function TabRollover(_arg1:MouseEvent){
            var _local2:int;
            var _local3:*;
            if (_arg1.currentTarget.h != undefined){
                _local2 = 0;
                if ((this.tabs[_arg1.currentTarget.n].Flags & 32)){
                    _local2 = 3;
                };
                main.hint.Hint(8, 0, _arg1.currentTarget.h, true, _local2, undefined, 200, _arg1.currentTarget);
            };
            if (this.tabsmc.del != undefined){
                this.tabsmc.removeChild(this.tabsmc.del);
                this.tabsmc.del = undefined;
            };
            if (_arg1.currentTarget.dFunc != undefined){
                if (_arg1.currentTarget.dFunc == main(parent).GoGroup){
                    _local3 = new library("Home");
                } else {
                    _local3 = new library("xdelete");
                };
                this.tabsmc.addChild(_local3);
                this.tabsmc.del = _local3;
                _local3.dFunc = _arg1.currentTarget.dFunc;
                _local3.x = (((_arg1.currentTarget.x + _arg1.currentTarget.width) - 9) - 6);
                _local3.y = int(((_arg1.currentTarget.height - 9) / 2));
                _local3.n = _arg1.currentTarget.n;
                _local3.addEventListener(MouseEvent.MOUSE_DOWN, this.DoFunc);
                _local3.buttonMode = true;
            };
        }
        function DoFunc(_arg1:MouseEvent){
            _arg1.currentTarget.dFunc(_arg1.currentTarget.n);
        }
        public function TabSelected():Number{
            var _local1:* = this.tabs.length;
            var _local2:* = 0;
            while (_local2 < _local1) {
                if (this.tabs[_local2].Main == true){
                    return (_local2);
                };
                _local2++;
            };
            return (0);
        }
        public function TabIsPrivate():Boolean{
            var _local1:* = this.TabSelected();
            return ((((this.tabs[_local1].Flags & 1)) ? true : false));
        }
        public function TabUser():Number{
            var _local1:* = this.TabSelected();
            return (this.tabs[_local1].User);
        }
        public function TabAdd(_arg1, _arg2, _arg3, _arg4, _arg5):Number{
            var _local6:Number = -1;
            var _local7:* = 0;
            while (_local7 < this.tabs.length) {
                if (this.tabs[_local7].User == _arg1){
                    _local6 = _local7;
                    break;
                };
                _local7++;
            };
            if (_local6 == -1){
                _local6 = this.tabs.length;
                this.tabs[_local6] = new Object();
            };
            this.tabs[_local6].User = _arg1;
            this.tabs[_local6].h = xatlib.GetUsername(_arg1);
            this.tabs[_local6].t = xatlib.StripSmilies(this.tabs[_local6].h);
            var _local8:* = xatlib.FindUser(_arg1);
            if (this.tabs[_local6].t == ""){
                todo.Users[_local8].tUpd = _local6;
            };
            this.tabs[_local6].Col = _arg2;
            this.tabs[_local6].Flags = (_arg3 | xatlib.xInt(this.tabs[_local6].Flags));
            this.tabs[_local6].pFunc = _arg4;
            this.tabs[_local6].dFunc = _arg5;
            this.tabs[_local6].Location = todo.Users[_local8].Location;
            return (_local6);
        }
        public function SetVisitorsTab(_arg1:int=0){
            var _local2:int;
            if (_arg1 == 2){
                this.Notif = false;
            };
            var _local3:int;
            while (_local3 < this.tabs.length) {
                if (this.tabs[_local3].Main){
                    _local2 = _arg1;
                };
                this.tabs[_local3].Main = (_local3 == _arg1);
                _local3++;
            };
            if (((!((_local2 == _arg1))) && ((((_arg1 == 2)) || ((_local2 == 2)))))){
                xmessage.DeleteUserList(1);
            };
            this.AddTabs(main.upx, main.upy, main.upw, main.uph);
            if (this.Notif){
                this.ColorTab(2, 0x9900);
            };
        }
        public function CreateVisitorsTabs(){
            this.tabs[0] = new Object();
            this.tabs[0].t = (this.tabs[0].h = xconst.ST(2));
            this.tabs[0].Col = 0xFFFFFF;
            this.tabs[0].Flags = 4;
            this.tabs[0].pFunc = main(parent).OnUsers;
            this.tabs[1] = new Object();
            this.tabs[1].t = xconst.ST(3);
            this.tabs[1].h = (this.tabs[1].t + " ");
            this.tabs[1].Col = 0xFFFFFF;
            this.tabs[1].Flags = 4;
            this.tabs[1].pFunc = main(parent).OnFriends;
            if (((!(todo.bMobile)) && (todo.HasPowerA(todo.w_Powers, 81, todo.w_Mask)))){
                this.tabs[2] = new Object();
                this.tabs[2].t = "";
                this.tabs[2].h = (xconst.ST(0xFF) + " ");
                this.tabs[2].Col = 0xFFFFFF;
                this.tabs[2].Flags = 32;
                this.tabs[2].pFunc = main(parent).OnTickle;
            };
            this.SetVisitorsTab(0);
        }

    }
}//package 
