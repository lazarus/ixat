package {
    import flash.xml.*;
    import flash.events.*;
    import com.adobe.serialization.json.*;
    import flash.display.*;
    import flash.text.*;
    import flash.net.*;
    import flash.utils.*;

    public class xkiss extends Sprite {

        private static const PowerKiss = {
            Snow:56,
            Animal:-116,
            WildHorses:124,
            SteamTrain:124,
            Rocket:133,
            Stoneage:135
        };

        static var mcBuystuffbackground;
        static var Frontfldbackground;
        static var Messfldbackground;
        static var PassField;
        static var PassFieldbackground;
        static var Frontfld;
        static var Messfld;
        static var tXatsbackground;
        static var tXats;
        static var tTime;
        static var tTimebackground;
        static var CoinB;
        static var mc3o;
        static var KissTime;
        static var Name;
        static var KissMc;
        static var mLoader2;
        static var KissOpts;
        private static var PuzzleOpts;
        private static var PuzzleLoader;
        static var Wink;
        static var WinkOpts;
        static var WinkTO:int;
        static var Bride:int;
        static var Private;
        static var nMarry;
        static var nMode;
        static var nSubMode;
        static var ob = new Array();
        static var gssa;
        static var t;
        static var nFront = "";
        static var nMessage = "";

        static function CreateBuystuff(_arg_1:*, _arg_2:*=0, _arg_3:*=0, _arg_4:*="", _arg_5:*=""){
            var _local_6:URLRequest;
            var _local_7:URLLoader;
            nMarry = _arg_1;
            nMode = _arg_2;
            nSubMode = _arg_3;
            nFront = _arg_4;
            nMessage = _arg_5;
            if (((((!((_arg_2 == 4))) && (!((_arg_2 == 0))))) || (((!((ob[nMode] == null))) && ((ob[nMode][0] is Object)))))){
                CreateBuystuff2(nMarry, nMode, nSubMode);
            } else {
                _local_6 = new URLRequest();
                _local_6.url = (todo.chatdomain + (((_arg_2 == 4)) ? "gift2.php" : "kiss.php") + "?l=" + todo.w_lang);
                _local_6.method = URLRequestMethod.GET;
                _local_7 = new URLLoader();
                _local_7.load(_local_6);
                _local_7.addEventListener(Event.COMPLETE, Handler);
            };
        }
        static function Handler(_arg1:Event){
            var _local2:URLLoader = URLLoader(_arg1.target);
            ob[nMode] = xJSON.decode(_local2.data);
            if ((ob[nMode][0] is Object)){
                CreateBuystuff2(nMarry, nMode, nSubMode);
            };
        }
        static function CreateBuystuff2(_arg_1:*, _arg_2:*=0, _arg_3:*=0){
            var _local_6:*;
            var _local_9:*;
            var _local_13:*;
            var _local_14:*;
            var _local_15:*;
            var _local_16:*;
            var _local_17:*;
            var _local_18:*;
            _arg_2 = xatlib.xInt(_arg_2);
            var _local_4:* = (((_arg_2 == 4)) || ((_arg_2 == 0)));
            var _local_5:Date = new Date();
            var _local_7:* = undefined;
            var _local_8:* = xatlib.FindUser(_arg_1);
            if (_local_8 >= 0){
                _local_7 = todo.Users[_local_8].registered;
            };
            switch (_arg_2){
                case 1:
                    _local_9 = xconst.ST(221);
                    break;
                case 2:
                    _local_9 = xconst.ST(222);
                    break;
                case 3:
                    _local_9 = xconst.ST(223, _local_7);
                    break;
                case 4:
                    _local_9 = ("Gift to " + _local_7);
                    break;
                default:
                    _local_9 = xconst.ST(224);
            };
            var _local_10:Array = new Array(405, 365, 285, 305, 440);
            var _local_11:* = ((480 - _local_10[_arg_2]) / 2);
            mcBuystuffbackground = new xDialog(main.dialogs, xatlib.NX(20), xatlib.NY(_local_11), xatlib.NX(600), xatlib.NY(_local_10[_arg_2]), _local_9, undefined, 0, mcBuystuffbackground_close);
            _local_11 = (_local_11 + 30);
            var _local_12:MovieClip = mcBuystuffbackground.Dia;
            if (_arg_2 == 3){
                _local_9 = xconst.ST(181);
            } else {
                _local_9 = xconst.ST(182);
            };
            _local_12.txt1 = new MovieClip();
            _local_12.addChild(_local_12.txt1);
            xatlib.createTextNoWrap(_local_12.txt1, xatlib.NX((12 + 24)), xatlib.NY(_local_11), xatlib.NX(560), xatlib.NY(32), _local_9, 0x202020, 0, 100, 0, 18, "left", 1);
            if (_arg_2 == 4){
                _local_11 = (_local_11 + 35);
                xatlib.createTextNoWrap(_local_12.txt1, xatlib.NX((12 + 24)), xatlib.NY(_local_11), xatlib.NX(100), xatlib.NY(32), "Front", 0x202020, 0, 100, 0, xatlib.NX(20), "left", 1);
                Frontfldbackground = xatlib.AddBackground(_local_12, xatlib.NX((120 + 24)), xatlib.NY(_local_11), xatlib.NX(290), xatlib.NY(32));
                Frontfld = xatlib.AddTextField(Frontfldbackground, 0, xatlib.NY(6), xatlib.NX(290), xatlib.NY(32));
                Frontfld.type = TextFieldType.INPUT;
                Frontfld.maxChars = 40;
                Frontfld.addEventListener(Event.CHANGE, xatlib.RemoveCR);
                Frontfld.text = nFront;
                Private = xatlib.AttachMovie(_local_12.txt1, "checkbox");
                Private.x = xatlib.NX(((300 + 120) + 24));
                Private.y = xatlib.NY((_local_11 + 9));
                Private.xitem.tick.visible = false;
                Private.addEventListener(MouseEvent.MOUSE_DOWN, xatlib.OnCheck);
                xatlib.createTextNoWrap(_local_12.txt1, xatlib.NX(((300 + 133) + 24)), xatlib.NY((_local_11 + 10)), xatlib.NX(200), xatlib.NY(10), "Private message", 0x202020, 0, 100, 0, 18, "left", 1);
            };
            _local_11 = (_local_11 + 35);
            xatlib.createTextNoWrap(_local_12.txt1, xatlib.NX((12 + 24)), xatlib.NY(_local_11), xatlib.NX(100), xatlib.NY(32), xconst.ST(183), 0x202020, 0, 100, 0, xatlib.NX(20), "left", 1);
            Messfldbackground = xatlib.AddBackground(_local_12, xatlib.NX((120 + 24)), xatlib.NY(_local_11), xatlib.NX(460), xatlib.NY(32));
            Messfld = xatlib.AddTextField(Messfldbackground, 0, xatlib.NY(6), xatlib.NX(460), xatlib.NY(32));
            Messfld.type = TextFieldType.INPUT;
            Messfld.maxChars = 140;
            Messfld.text = nMessage;
            Messfld.addEventListener(Event.CHANGE, xatlib.RemoveCR);
            _local_11 = (_local_11 + 35);
            xatlib.createTextNoWrap(_local_12.txt1, xatlib.NX((12 + 24)), xatlib.NY(_local_11), xatlib.NX(100), xatlib.NY(32), xconst.ST(184), 0x202020, 0, 100, 0, xatlib.NX(20), "left", 1);
            PassFieldbackground = xatlib.AddBackground(_local_12, xatlib.NX((120 + 24)), xatlib.NY(_local_11), xatlib.NX(460), xatlib.NY(32));
            PassField = xatlib.AddTextField(PassFieldbackground, 0, xatlib.NY(6), xatlib.NX(460), xatlib.NY(32));
            PassField.type = TextFieldType.INPUT;
            PassField.displayAsPassword = true;
            PassField.addEventListener(Event.CHANGE, xatlib.RemoveCR);
            if (_local_4){
                _local_11 = (_local_11 + 45);
                _local_13 = 42;
                _local_14 = (xatlib.c_bl + xatlib.c_br);
                _local_15 = 125;
                if (_arg_2 == 0){
                    _local_15 = 80;
                };
                _local_6 = 0;
                while (_local_6 < ob[nMode].length) {
                    if ((((ob[nMode][_local_6][0].charAt(0) == "@")) || ((_arg_2 == 0)))){
                        if (_local_12.cat == null){
                            _local_12.cat = new Object();
                        };
                        _local_12.cat[_local_6] = new xBut(_local_12, xatlib.NX(_local_13), xatlib.NY(_local_11), xatlib.NX(_local_15), xatlib.NY(30), (((_arg_2 == 0)) ? ob[nMode][_local_6][0] : ob[nMode][_local_6][0].substr(1)), catPress, _local_14);
                        _local_12.cat[_local_6].nSubMode = _local_6;
                        _local_13 = (_local_13 + (_local_15 + 2));
                    };
                    _local_6++;
                };
                _local_11 = (_local_11 - 10);
            };
            _local_11 = (_local_11 + 50);
            _local_12.Kiss = new Array();
            if (_local_4){
                _local_11 = (_local_11 - 10);
                _local_16 = xatlib.AddBackground(_local_12, xatlib.NX(34), xatlib.NY(_local_11), xatlib.NX(570), xatlib.NY(180));
                _local_11 = (_local_11 + 10);
            };
            gssa = null;
            switch (_arg_2){
                case 0:
                case 4:
                    _local_6 = 0;
                    while (_local_6 < 2) {
                        if (!ob[nMode][nSubMode][(_local_6 + 1)]) break;
                        gssa = ob[nMode][nSubMode][(_local_6 + 1)].split(",");
                        _local_11 = (_local_11 + AddKisses(ob, 2, 7, _local_11, _local_12, gssa[0], gssa[1], (((_arg_2 == 4)) ? 5 : 0), _arg_1));
                        _local_6++;
                    };
                    break;
                case 1:
                    gssa = GetMariageKisses(241);
                    _local_11 = (_local_11 + AddKisses(null, 0, gssa.length, _local_11, _local_12, "Marry", 200, 3, _arg_1));
                    gssa = GetMariageKisses(xconst.pssh["bestfriend"]);
                    _local_11 = (_local_11 + AddKisses(null, 0, gssa.length, _local_11, _local_12, "Best Friend", 200, 4, _arg_1));
                    break;
                case 2:
                    gssa = GetMariageKisses(269);
                    _local_11 = (_local_11 + AddKisses(null, 0, gssa.length, _local_11, _local_12, xconst.ST(150), 0, 2));
                    break;
                case 3:
                    _local_11 = (_local_11 + 10);
                    xatlib.createTextNoWrap(_local_12.txt1, xatlib.NX((12 + 24)), xatlib.NY(_local_11), xatlib.NX(210), xatlib.NY(32), xconst.ST(202, _local_7), 0x202020, 0, 100, 0, xatlib.NX(16), "left", 1);
                    xatlib.createTextNoWrap(_local_12.txt1, xatlib.NX(((12 + 24) + 230)), xatlib.NY(_local_11), xatlib.NX(60), xatlib.NY(32), (xconst.ST(205) + ":"), 0x202020, 0, 100, 0, xatlib.NX(16), "left", 1);
                    tXatsbackground = xatlib.AddBackground(_local_12, xatlib.NX(((12 + 24) + 290)), xatlib.NY(_local_11), xatlib.NX(50), xatlib.NY(32));
                    tXats = xatlib.AddTextField(tXatsbackground, 0, xatlib.NY(6), xatlib.NX(50), xatlib.NY(32));
                    tXats.type = TextFieldType.INPUT;
                    tXats.defaultTextFormat = main.fmt;
                    tXats.addEventListener(Event.CHANGE, xatlib.RemoveCR);
                    xatlib.createTextNoWrap(_local_12.txt1, xatlib.NX((((12 + 24) + 230) + 120)), xatlib.NY(_local_11), xatlib.NX(60), xatlib.NY(32), (xconst.ST(208) + ":"), 0x202020, 0, 100, 0, xatlib.NX(16), "left", 1);
                    tTimebackground = xatlib.AddBackground(_local_12, xatlib.NX((((12 + 24) + 290) + 120)), xatlib.NY(_local_11), xatlib.NX(50), xatlib.NY(32));
                    tTime = xatlib.AddTextField(tTimebackground, 0, xatlib.NY(6), xatlib.NX(50), xatlib.NY(32));
                    tTime.type = TextFieldType.INPUT;
                    tTime.defaultTextFormat = main.fmt;
                    tTime.addEventListener(Event.CHANGE, xatlib.RemoveCR);
                    _local_12.mcgo = new xBut(_local_12, xatlib.NX(504), xatlib.NY(_local_11), xatlib.NX(100), xatlib.NY(32), xconst.ST(149), Transfer_onRelease);
                    _local_12.mcgo.But.b = _arg_1;
                    _local_11 = (_local_11 + 50);
                    _local_12.mctrade = new xBut(_local_12, xatlib.NX(40), xatlib.NY(_local_11), xatlib.NX(100), xatlib.NY(32), "Trade", Trade_onRelease);
                    xatlib.createTextNoWrap(_local_12.txt1, xatlib.NX(152), xatlib.NY(_local_11), xatlib.NX(448), xatlib.NY(32), "Open the trading engine for easier and safer trading.", 0x202020, 0, 100, 0, 24, "left", 1);
                    _local_11 = (_local_11 + 50);
                    break;
            };
            _local_11 = (_local_11 + 9);
            if (((todo.w_VIP) && (network.YC))){
                _local_17 = (xatlib.xInt(todo.w_d1) - network.YC);
                if (_local_17 < 0){
                    _local_17 = 0;
                };
                _local_17 = xatlib.xInt(((_local_17 / (24 * 3600)) + 0.3));
                _local_12.days = xatlib.AttachMovie(_local_12, "star", {
                    "x":xatlib.NX((12 + 24)),
                    "y":xatlib.NY(_local_11),
                    "scaleX":xatlib.SX(),
                    "scaleY":xatlib.SY()
                });
                xatlib.createTextNoWrap(_local_12.days, 30, -10, 130, 50, xconst.ST(204, _local_17), 0x202020, 0, 100, 0, 26, "center", 1);
            };
            _local_12.mcok = new xBut(_local_12, xatlib.NX(240), xatlib.NY(_local_11), xatlib.NX(160), xatlib.NY(30), xconst.ST(244), K_Can_onRelease);
            if (todo.w_coins){
                _local_12.coins = xatlib.AttachMovie(_local_12, "coins", {
                    "x":xatlib.NX(440),
                    "y":xatlib.NY(_local_11),
                    "scaleX":xatlib.SX(),
                    "scaleY":xatlib.SY()
                });
                xatlib.createTextNoWrap(_local_12.coins, 30, -10, 130, 50, ((todo.w_coins + " ") + xconst.ST(205)), 0x202020, 0, 100, 0, 26, "center", 1);
                _local_12.coins.onRelease = BuyRelease;
            } else {
                CoinB = new xBut(_local_12, xatlib.NX(440), xatlib.NY(_local_11), xatlib.NX(160), xatlib.NY(30), ("  " + xconst.ST(206)), BuyRelease);
                _local_18 = xatlib.AttachMovie(CoinB, "coins");
                _local_18.scaleX = xatlib.SX(0.8);
                _local_18.scaleY = xatlib.SY(0.8);
                _local_18.x = xatlib.NX(10);
                _local_18.y = xatlib.NY(5);
            };
        }
        static function GetMariageKisses(_arg1){
            var _local3:*;
            var _local4:*;
            var _local5:*;
            var _local2:* = todo.HasPower(xatlib.FindUser(todo.w_userno), _arg1);
            switch (_arg1){
                case 241:
                    _local3 = xconst.kssa.slice(0, 2);
                    break;
                case xconst.pssh["bestfriend"]:
                    _local3 = xconst.kssa.slice(2, 3);
                    break;
                case 269:
                    _local3 = xconst.kssa.slice(3, 5);
                    break;
            };
            if (_local2){
                for (_local5 in xconst.kssw) {
                    if (xconst.kssw[_local5] == _arg1){
                        _local3.push(_local5);
                    };
                };
            };
            return (_local3);
        }
        static function Transfer_onRelease(_arg1:MouseEvent){
            BlowKiss({
                b:_arg1.currentTarget.b,
                n:"T",
                Type:3
            });
        }
        static function Trade_onRelease(_arg1:MouseEvent=undefined){
            var _local2:*;
            if ((global.xc & 0x0800)){
                main.mcLoad.OpenByN(30008);
            } else {
                _local2 = xatlib.xatlinks(xatlib.PageUrl(30008));
                xatlib.UrlPopup(xconst.ST(8), _local2, xconst.ST(17));
            };
        }
        static function BuyRelease(_arg1:MouseEvent){
            xatlib.Register_onRelease(1);
        }
        static function AddKisses(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8=0, _arg9=undefined, _arg10=0){
            var _local12:*;
            var _local14:*;
            var _local15:*;
            var _local16:*;
            var _local17:*;
            var _local18:*;
            var _local19:*;
            var _local11:* = "ks";
            if (_arg7 != 0){
                _arg5.coins = xatlib.AttachMovie(_arg5, "coins", {
                    x:xatlib.NX(86),
                    y:xatlib.NY((_arg4 + 30)),
                    scaleX:xatlib.SY(0.8),
                    scaleY:xatlib.SY(0.8)
                });
            };
            xatlib.createTextNoWrap(_arg5, xatlib.NX(36), xatlib.NY((_arg4 + 3)), xatlib.NX(90), xatlib.NY(52), ((_arg6 + "\n") + ((_arg7)!=0) ? _arg7 : ""), 0x202020, 0, 100, 0, 18, "left", 1);
            var _local13:* = _arg2;
            while (_local13 < 99) {
                var _temp1 = _arg3;
                _arg3 = (_arg3 - 1);
                if (_temp1 == 0){
                    break;
                };
                _local14 = new MovieClip();
                _arg5.Kiss.push(_local14);
                _arg5.addChild(_local14);
                if ((((_arg8 == 5)) || ((_arg8 == 0)))){
                    _local14.n = gssa[_local13];
                    _local14.gt = _arg6;
                    if (!_local14.n){
                        break;
                    };
                    if (_arg8 == 5){
                        _local11 = "gift";
                    };
                } else {
                    while (gssa.length > 5) {
                        gssa.splice(xatlib.xRand(0, 1), 1);
                    };
                    _local14.n = gssa[_local13];
                };
                if (!_local14.n){
                    break;
                };
                _local14.c = _arg7;
                _local14.b = _arg9;
                _local14.u = todo.w_userno;
                _local14.Type = _arg8;
                _local14.scaleX = xatlib.SX();
                _local14.scaleY = xatlib.SY();
                _local15 = undefined;
                _local12 = ("t" + _local14.n);
                if (_arg8 == 5){
                    _local15 = GiftLoaded;
                    _local12 = _local14.n;
                    _local14.visible = false;
                };
                if (_local14.n.charAt(0) == "@"){
                    _local17 = new xBut(_local14, 0, 0, 60, 75, "", KissPress);
                    _local17.n = _local14.n;
                    xatlib.createTextNoWrap(_local14, -10, 60, 80, 20, _local14.n.substr(1), 0xFFFFFF, 0, 100, 0, 10, "center", 1);
                    _local18 = 0;
                    while (_local18 < _arg1[nMode].length) {
                        if (_arg1[nMode][_local18][0] == _local14.n.substr(1)){
                            _local19 = _arg1[nMode][_local18][1].split(",");
                            _local12 = _local19[2];
                            xatlib.LoadMovie(_local14, xatlib.SmilieUrl(_local12, _local11), GiftLoaded2);
                        };
                        _local18++;
                    };
                } else {
                    xatlib.LoadMovie(_local14, xatlib.SmilieUrl(_local12, _local11), _local15);
                };
                _local12 = xatlib.NX(95);
                if (_arg8 == 5){
                    _local12 = xatlib.NX(66);
                };
                _local14.x = (xatlib.NX(137) + (_local12 * (_local13 - _arg2)));
                _local14.y = xatlib.NY(_arg4);
                _local14.addEventListener(MouseEvent.MOUSE_DOWN, KissPress);
                if ((((_arg8 == 5)) && (!((_local14.n.charAt(0) == "@"))))){
                    _local14.addEventListener(MouseEvent.ROLL_OVER, KissOver);
                    _local14.addEventListener(MouseEvent.ROLL_OUT, KissOut);
                };
                _local16 = ((_local14.n.charAt(0))!="@") ? (xconst.ST(207) + " ") : "";
                switch (_arg8){
                    case 2:
                        _local16 = (_local16 + (xconst.ST(150) + ":"));
                        break;
                    case 3:
                        _local16 = (_local16 + xconst.ST(209));
                        break;
                    case 4:
                        _local16 = (_local16 + xconst.ST(210));
                        break;
                    case 5:
                        _local16 = (_local16 + (_arg6 + " "));
                        break;
                };
                _local16 = (_local16 + _local14.n);
                _local14.hint = {
                    Hint:_local16,
                    mc:_local14
                };
                _local14.addEventListener(MouseEvent.ROLL_OVER, main.hint.EasyHint);
                _local14.addEventListener(MouseEvent.ROLL_OUT, main.hint.HintOff);
                _local13++;
            };
            return (85);
        }
        static function KissOver(_arg1){
            t = new Object();
            t["g"] = _arg1.currentTarget.n;
            t["s"] = Frontfld.text;
            if (chat.sending_lc){
                chat.sending_lc.send(chat.fromxat, "onMsg", 9, "preview", t);
            };
        }
        static function KissOut(_arg1){
            if (chat.sending_lc){
                chat.sending_lc.send(chat.fromxat, "onMsg", 9, "preview", null);
            };
        }
        static function GiftLoaded(_arg1){
            var _local2:* = _arg1.currentTarget.content;
            if (!_local2){
                return;
            };
            if (_local2.width > _local2.height){
                _local2.scaleX = (_local2.scaleY = (60 / _local2.width));
                _local2.y = ((60 - _local2.height) / 2);
            } else {
                _local2.scaleX = (_local2.scaleY = (60 / _local2.height));
                _local2.x = ((60 - _local2.width) / 2);
            };
            _local2.parent.parent.visible = true;
        }
        static function GiftLoaded2(_arg1){
            var _local2:* = _arg1.currentTarget.content;
            if (!_local2){
                return;
            };
            _local2.y = 5;
            if (_local2.width > _local2.height){
                _local2.scaleX = (_local2.scaleY = (50 / _local2.width));
                _local2.y = (_local2.y + ((50 - _local2.height) / 2));
            } else {
                _local2.scaleX = (_local2.scaleY = (50 / _local2.height));
                _local2.x = (5 + ((50 - _local2.width) / 2));
            };
            _local2.parent.parent.visible = true;
        }
        static function KissPress(_arg1:MouseEvent){
            var _local2:*;
            var _local3:*;
            var _local4:*;
            main.hint.HintOff();
            if (todo.w_coins < _arg1.currentTarget.c){
                xatlib.Register_onRelease(1);
            } else {
                if (_arg1.currentTarget.n.charAt(0) == "@"){
                    _local2 = 0;
                    _local3 = 0;
                    while (_local3 < ob[nMode].length) {
                        if (ob[nMode][_local3][0] == _arg1.currentTarget.n.substr(1)){
                            _local4 = new Object();
                            _local4.Marry = nMarry;
                            _local4.Mode = nMode;
                            _local4.SubMode = _local3;
                            _local4.Front = Frontfld.text;
                            _local4.Message = Messfld.text;
                            main.openDialog(3, _local4);
                            break;
                        };
                        _local3++;
                    };
                } else {
                    BlowKiss(_arg1.currentTarget);
                };
            };
        }
        static function mcBuystuffbackground_close(){
            main.hint.HintOff();
            mcBuystuffbackground.Delete();
            main.closeDialog();
        }
        static function catPress(_arg1:MouseEvent=undefined){
            var _local2:*;
            if (nSubMode != _arg1.target.nSubMode){
                _local2 = new Object();
                _local2.Marry = nMarry;
                _local2.Mode = nMode;
                _local2.SubMode = _arg1.target.nSubMode;
                _local2.Front = ((Frontfld) ? Frontfld.text : "");
                _local2.Message = ((Messfld) ? Messfld.text : "");
                main.openDialog(3, _local2);
            };
        }
        static function K_Can_onRelease(_arg1:MouseEvent=undefined){
            mcBuystuffbackground_close();
        }
        static function BlowKiss(_arg1){
            var _local4:*;
            var _local5:*;
            var _local6:URLVariables;
            var _local2:* = BadKiss(_arg1.n, _arg1.u);
            if (_local2){
                _local5 = xconst.ST(252);
                if (_local2 == 2){
                    _local5 = xconst.ST(253);
                };
                xatlib.GeneralMessage("", _local5);
                return;
            };
            if ((((_arg1.Type == 0)) && ((PassField.text.length == 0)))){
                Kiss({
                    t:Messfld.text,
                    u:todo.w_userno,
                    k:_arg1.n
                }, true);
                return;
            };
            var _local3:* = new XMLDocument();
            _local4 = _local3.createElement("a");
            _local4.attributes.p = PassField.text.replace(/[\/;#]/g, "");
            _local4.attributes.m = Messfld.text;
            _local4.attributes.k = _arg1.n;
            if (_arg1.n == "T"){
                _local4.attributes.x = xatlib.xInt(tXats.text);
                _local4.attributes.s = xatlib.xInt(tTime.text);
                if (_local4.attributes.x < 0){
                    return;
                };
                if (_local4.attributes.s < 0){
                    return;
                };
                if ((((_local4.attributes.s == 0)) && ((_local4.attributes.x < 10)))){
                    return;
                };
                if ((((_local4.attributes.s == 0)) && ((_local4.attributes.x == 0)))){
                    return;
                };
            };
            if (_arg1.Type == 2){
                _local4.attributes.b = 1;
            } else {
                if (_arg1.Type == 3){
                    _local4.attributes.b = _arg1.b;
                } else {
                    if (_arg1.Type == 4){
                        _local4.attributes.f = _arg1.b;
                    };
                };
            };
            if (_arg1.Type == 5){
                _local6 = new URLVariables();
                _local6.g = _arg1.n;
                _local6.c = _arg1.c;
                _local6.b = _arg1.b;
                _local6.m = Messfld.text;
                _local6.s = Frontfld.text;
                _local6.u = todo.w_userno;
                _local6.r = todo.w_useroom;
                _local6.w = xconst.ST(254, xatlib.GetNameNumber(todo.w_userno), xatlib.GetNameNumber(_arg1.b), _arg1.gt);
                Bride = _arg1.b;
                _local6.t = todo.w_dt;
                _local6.p = PassField.text;
                _local6.f = 1;
                if (Private.xitem.tick.visible){
                    _local6.f = (_local6.f & ~(1));
                };
                xatlib.LoadVariables((todo.chatdomain + "buygifts.php"), GiftCallback, _local6, 1);
            } else {
                _local3.appendChild(_local4);
                network.socket.send(xatlib.XMLOrder(_local3, new Array("f", "b", "s", "x", "k", "m", "p")));
            };
            xatlib.GeneralMessage("", xconst.ST(211));
        }
        private static function GiftCallback(_arg1){
            if (_arg1.currentTarget.data != "OK"){
                xatlib.GeneralMessage("", _arg1.currentTarget.data);
            } else {
                xatlib.GeneralMessage();
                xmessage.OpenGifts(Bride);
            };
        }
        private static function BadKiss(_arg1, _arg2){
            var _local3:* = PowerKiss[_arg1];
            if (_local3 > 0){
                return (((todo.HasPower(xatlib.FindUser(_arg2), _local3)) ? 0 : 1));
            };
            if (_local3 < 0){
                return (((todo.HasPowerA(todo.w_GroupPowers, -(_local3))) ? 0 : 2));
            };
            return (0);
        }

        public static function Kiss(_arg_1:*, _arg_2:*=false){
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            if (_arg_1.h){
                _local_4 = _arg_1.t.split("#");
                _local_5 = {
                    "n":0,
                    "t":((((((("<h>;=" + _arg_1.h) + ";=") + _arg_1.t) + ";=") + _arg_1.b) + ";=") + _arg_1.j),
                    "u":_arg_1.u,
                    "s":0,
                    "d":0
                };
                if (_arg_1.b){
                    if (_arg_1.b == todo.w_userno){
                        _local_5["d"] = _arg_1.u;
                    } else {
                        _local_5["d"] = _arg_1.b;
                    };
                    if (_arg_1.e){
                        _local_5["s"] = 2;
                    };
                    if (_arg_1.h >= 100000){
                        _local_6 = xatlib.FindUser(_arg_1.b);
                        if (_local_6 >= 0){
                            if (_arg_1.e){
                                todo.Users[_local_6].JinxPc = _arg_1.j;
                            } else {
                                todo.Users[_local_6].Jinx = _arg_1.j;
                            };
                        };
                    };
                };
                todo.Message.push(_local_5);
                todo.DoUpdateMessages = true;
                todo.ScrollDown = true;
                return;
            };
            if (_arg_1.k == "T"){
                _local_7 = _arg_1.b;
                if (((_local_7) && ((((todo.w_userno == _local_7)) || ((todo.w_userno == _arg_1.u)))))){
                    if (!_arg_2){
                        main.closeDialog();
                        xatlib.GeneralMessage();
                        CloseKiss();
                    };
                    xatlib.GeneralMessage("", (xconst.ST(162, _arg_1.x, _arg_1.s, xatlib.IdToRegName(_arg_1.u), xatlib.IdToRegName(_local_7)) + _arg_1.t), 2);
                    network.NetworkLogin(todo.w_userno, 0);
                    todo.WV2 = true;
                };
                return;
            };
            if (!_arg_2){
                main.closeDialog();
                xatlib.GeneralMessage();
                CloseKiss();
            };
            KissMc = new MovieClip();
            main.kiss_layer.addChild(KissMc);
            if (BadKiss(_arg_1.k, _arg_1.u)){
                return;
            };
            mc3o = _arg_1;
            todo.uKiss = 0;
            if (!_arg_2){
                todo.uKiss = mc3o.u;
            };
            LoadKiss();
            AddName(todo.Users[xatlib.FindUser(xatlib.xInt(mc3o.u))].n);
            KissTime = -1;
            KissMc.addEventListener(Event.ENTER_FRAME, KissTick);
            AddMessage();
        }

        static function KissTick(_arg1){
            KissTime--;
            if (KissTime == (-10 * 12)){
                KissMc.removeChild(Name);
                Name = undefined;
            };
            if (KissTime < (-30 * 12)){
                CloseKiss();
            };
        }
        static function AddMessage(){
            var _local1:*;
            if (mc3o != undefined){
                _local1 = mc3o.t.split("#");
                todo.Message.push({
                    n:0,
                    t:((((("<inf8> " + mc3o.k) + ": (") + mc3o.k) + ") ") + _local1[0]),
                    u:mc3o.u,
                    s:0,
                    d:0
                });
                todo.DoUpdateMessages = true;
                todo.ScrollDown = true;
            };
        }
        public static function CloseKiss(_arg1=0){
            if (KissMc){
                try {
                    main.kiss_layer.removeChild(KissMc);
                    if (Name){
                        KissMc.removeChild(Name);
                    };
                    KissMc.removeEventListener(Event.ENTER_FRAME, KissTick);
                } catch(e) {
                };
            };
            if (((todo.uKiss) && ((((((todo.w_userno == mc3o.u)) || ((todo.w_userno == mc3o.b)))) || ((todo.w_userno == mc3o.f)))))){
                network.NetworkLogin(todo.w_userno, 0);
                todo.WV2 = true;
            };
            if (mLoader2){
                mLoader2.unloadAndStop(true);
            };
            Name = (mc3o = (KissMc = (mLoader2 = undefined)));
            todo.uKiss = 0;
        }
        static function AddName(_arg1){
            if ((((_arg1 == undefined)) || ((_arg1.length == 0)))){
                return;
            };
            Name = new Sprite();
            KissMc.addChild(Name);
            var _local2:* = xatlib.ButtonCurve2(0, todo.StageWidth, 25, 0, 1, 0xFFFFFF, 1, 0xFFFFFF, 0.5);
            Name.addChild(_local2);
            _local2.y = (todo.StageHeight - 28);
            var _local3:* = new MovieClip();
            Name.addChild(_local3);
            xmessage.AddMessageToMc(_local3, 0, _arg1, 0, 999, (todo.StageHeight - 28), 0);
            var _local4:* = xatlib.xInt(((todo.StageWidth - xmessage.xPos) / 2));
            if (_local4 < 0){
                _local4 = 0;
            };
            _local3.x = _local4;
            _local2.addEventListener(MouseEvent.MOUSE_DOWN, WhoIs);
            _local3.addEventListener(MouseEvent.MOUSE_DOWN, WhoIs);
            var _local5:* = new close();
            Name.addChild(_local5);
            _local5.x = (todo.StageWidth - 20);
            _local5.y = ((todo.StageHeight - 28) + 5);
            _local5.addEventListener(MouseEvent.MOUSE_DOWN, CloseKiss);
        }
        private static function WhoIs(_arg1=0){
            main.openDialog(2, todo.uKiss);
        }
        static function LoadAs2Kiss(){
            var _local3:*;
            var _local4:URLRequest;
            mc3o.SV = global.sv;
            mc3o.SF = (2 + 4);
            var _local1:* = mc3o.t.split("#");
            _local1.shift();
            xmessage.PowSm(mc3o, _local1, 0, todo.ALL_POWERS);
            if ((todo.w_sound & 1)){
                mc3o.Vol = todo.w_Vol[1];
            };
            mc3o.WW = todo.StageWidth;
            mc3o.HH = todo.StageHeight;
            mLoader2 = new Loader();
            KissMc.addChild(mLoader2);
            var _local2:URLVariables = new URLVariables();
            for (_local3 in mc3o) {
                _local2[_local3] = mc3o[_local3];
            };
            _local4 = new URLRequest();
            _local4.url = todo.imagedomain + "ks/kshim.swf";
            _local4.method = URLRequestMethod.GET;
            _local4.data = _local2;
            mLoader2.load(_local4);
            mLoader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, xatlib.catchIOError);
        }
        static function LoadWink(_arg1){
            if (todo.Macros["blast"] == "off"){
                return;
            };
            if (Wink){
                return;
            };
            WinkOpts = {};
            WinkTO = 20;
            var _local2:* = xatlib.xInt(_arg1.attributes.d);
            var _local3:String = _arg1.attributes.t;
            var _local4:int = xatlib.xInt(_arg1.attributes.v);
            var _local5 = 1;
            while (_local4 > 1) {
                _local4 = (_local4 / 2);
                _local5++;
            };
            _local4 = (xatlib.xInt(_arg1.attributes.r) % _local5);
            if (todo.Macros[_local3]){
                _local4 = (xatlib.xInt(todo.Macros[_local3]) - 1);
            };
            if (_local4 >= _local5){
                _local4 = (_local5 - 1);
            };
            if (_local4 > 3){
                _local4 = 3;
            };
            _local3 = (_local3 + String((_local4 + 1)));
            var _local6:* = _arg1.attributes.o;
            var _local7:* = xatlib.FindUser(_local2);
            if (_local7 < 0){
                return;
            };
            WinkOpts.WW = todo.StageWidth;
            WinkOpts.HH = todo.StageHeight;
            WinkOpts.Done = WinkDone;
            WinkOpts.Cols = [xatlib.RankColor(_local7), xatlib.RankColor(_local6)];
            WinkOpts.Text = [xatlib.StripSmilies(todo.Users[_local7].n)];
            Wink = xatlib.LoadMovie(main.wink_layer, xatlib.SmilieUrl(_local3, "blast"), WinkLoaded);
        }
        private static function WinkLoaded(_arg1){
            var _local2:* = _arg1.currentTarget.loader.contentLoaderInfo.content;
            _local2.Go(WinkOpts);
        }
        static function WinkDone(){
            if (!Wink){
                return;
            };
            main.wink_layer.removeChild(Wink);
            Wink = undefined;
        }
        static function LoadKiss(){
            KissOpts = {};
            KissOpts.WW = todo.StageWidth;
            KissOpts.HH = todo.StageHeight;
            KissOpts.Done = CloseKiss;
            KissOpts.Message = mc3o.t;
            KissOpts.SmInfo = new Object();
            KissOpts.SmInfo.SV = global.sv;
            KissOpts.SmInfo.SF = (2 + 4);
            KissOpts.UserNo = mc3o.u;
            var _local_1:* = mc3o.t.split("#");
            _local_1.shift();
            xmessage.PowSm(KissOpts.SmInfo, _local_1, 0, todo.ALL_POWERS);
            if ((todo.w_sound & 1)){
                KissOpts.Vol = todo.w_Vol[1];
            };
            KissOpts.Cols = [xatlib.RankColor(xatlib.FindUser(mc3o.u)), xatlib.RankColor(xatlib.FindUser(mc3o.b))];
            mc3o.k = mc3o.k.replace(/[^0-9a-zA-Z]/g, "");
            mLoader2 = xatlib.LoadMovie(KissMc, xatlib.SmilieUrl(mc3o.k, "ks"), KissLoaded);
        }
        private static function KissLoaded(_arg1){
            var _local2:* = _arg1.currentTarget.loader.contentLoaderInfo.content;
            _local2.Go(KissOpts);
        }
        static function LoadPuzzle(_arg1:int){
            ClosePuzzle(0);
            PuzzleOpts = {};
            PuzzleOpts.u = todo.w_userno;
            PuzzleOpts.r = todo.w_useroom;
            PuzzleOpts.p = _arg1;
            PuzzleOpts.t = network.GetGagTime(todo.w_useroom);
            PuzzleOpts.HH = todo.StageHeight;
            PuzzleOpts.WW = todo.StageWidth;
            PuzzleOpts.YC = xatlib.SockTime();
            PuzzleOpts.Done = ClosePuzzle;
            PuzzleOpts.Send = chat.onMsg2;
            if ((todo.w_sound & 1)){
                PuzzleOpts.Vol = todo.w_Vol[1];
            };
            PuzzleLoader = xatlib.LoadMovie(main.puzzle_layer, (((todo.flashdomain  + (50000 + PuzzleOpts.p)) + ".swf?") + global.gb), PuzzleLoaded);
            main.puzzle_layer.mouseEnabled = false;
            PuzzleLoader.mouseEnabled = false;
            network.UpdateChannel(0, todo.w_userno);
        }
        private static function PuzzleLoaded(_arg1){
            var _local2:* = _arg1.currentTarget.loader.contentLoaderInfo.content;
            _local2.Go(PuzzleOpts);
        }
        static function ClosePuzzle(_arg1=0){
            if (PuzzleLoader){
                network.UpdateChannel(0, todo.w_userno);
                main.puzzle_layer.removeChild(PuzzleLoader);
                PuzzleLoader.unloadAndStop(true);
            };
            PuzzleLoader = undefined;
        }

    }
}//package 
