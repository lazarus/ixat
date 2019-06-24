package {
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
	import flash.external.ExternalInterface;

    public class chat extends Sprite {

        public static const cVersion = "042718_1"; //mmddyy_vv
        public static const sv = 51;
        public static const lv = 2;
        static const period = 120;
        static const times = 36;

        public static var debug = false;
        static var force_xc = undefined;
        static var force_lang = undefined;
        static var gctrick = 0;
        static var framet = 0;
        static var framec = 0;
        static var timesc = 0;
        static var fpsstr = "";
        static var fps = 12;
        static var afps = 12;
        static var fpsa = 0;
        static var fpsc = 0;
        static var timer = new Object();
        static var State = 0;
        static var Timeout = undefined;
        static var sot = null;
        static var keybits:Array = new Array(0x0100);
        static var ctrlTimer;
        public static var mainDlg:main;
        public static var beep:Sound;
        public static var dingdong:Sound;
        public static var tab_sound:Sound;
		public static var tickle_sound:Sound;
		public static var tickle2_sound:Sound;
        public static var sending_lc:LocalConnection;
        public static var receiving_lc:LocalConnection;
        public static var toxat = "toxat";
        public static var fromxat = "fromxat";
        public static var AppTimeout = undefined;
        public static var connectchannel = undefined;
        public static var connectuser = undefined;
        public static var connectmessage = undefined;
        public static var connectmsg = undefined;
        public static var onMsg2;
        static var axtrace:Array = new Array();
        static var hxtrace:Object = new Object();
        static var memdata = new Array();
        static var fpsdata = new Array();
        static var fpstimer = undefined;
        static var vsmilietest = undefined;
        static var vfakemessage = undefined;
        static var vavtest = undefined;
        static var vgraph = undefined;
        static var debuglog = "";
        public static var vmsgcount = undefined;
        static var feed = undefined;
        static var sockstr = undefined;
        static var socklast = -120;
        static var socklost = 0;
        static var feeddata = new Array();
        static var mcstrip = null;
        static var amc:Array = null;
        static var amcd:Array = null;
        static var xcachetick = 0;
        static var bd:BitmapData;
        static var bigmc:xSprite;
        static var sc:int = 0;
        static var smstats = false;
        static var cacheback:int = 0;
        static var stest:int = 0;
        static var stesta = [];		

        public function chat(){
            addEventListener(Event.ADDED_TO_STAGE, this.init);
        }
		
        static function NotAway(){
            var _local_1:* = xatlib.FindUser(todo.w_userno);
			if ((((_local_1 >= 0)) && ((todo.Users[_local_1].flag0 & 0x4000)))){
            //if (_local_1 != undefined && todo.Users[_local_1] != undefined && (todo.Users[_local_1].flag0 & 0x4000)){
                network.NetworkSendMsg(todo.w_userno, "/back");
            };
            todo.Away = 1;
        } 
		
        public static function onLang(_arg1:Event){
            var _local2:URLLoader = URLLoader(_arg1.target);
            todo.LangText = _local2.data;
            xconst.CreateST();
            xconst.MakeBads();
        }
        static function isKeyDown(_arg1:int):Boolean{
            return ((true == Boolean(keybits[_arg1])));
        }
		
		static function debug_init(){
            debug = true;
            hxtrace["chat"] = "trace";
            hxtrace["network"] = "trace";
            hxtrace["tx"] = "trace";
            hxtrace["rx"] = "trace";
            hxtrace["im"] = "trace";
            hxtrace["main"] = "trace";
            hxtrace["lcrx"] = "trace";
            hxtrace["panic"] = "trace,log,sock";
            hxtrace["smstats"] = "trace,log,dbgstr";
            hxtrace["cc"] = "trace,log,dbgstr,sock,help";
            hxtrace["timer"] = "trace,log";
            framet = getTimer();
        }
        static function debug_tick(){
            var _local1:*;
            var _local2:*;
            var _local3:*;
            var _local4:*;
            var _local5:*;
            if (!todo.helpstr){
                _local1 = axtrace.shift();
                if (_local1 != undefined){
                    _local2 = ((("[" + _local1.channel.toString()) + "] ") + _local1.str.toString());
                    todo.helpstr = _local2;
                    todo.helpupdate = 0;
                };
            };
            if (todo.debug){
                debug_memory();
            };
            if (vsmilietest){
                debug_smilietest(vsmilietest);
            };
            if (vfakemessage){
                debug_fakemessages(vfakemessage);
            };
            if (vavtest){
                debug_avtest(vavtest);
            };
            if (vgraph){
                debug_graph(vgraph);
            };
            if (((((!((feed == undefined))) && (((todo.tick % 6) == 0)))) || ((feed < 90)))){
                _local3 = new DataEvent("");
                _local3.data = feeddata[feed];
                network.myOnXML(_local3);
                feed++;
                if (feed >= feeddata.length){
                    feed = undefined;
                };
            };
            if (sockstr != undefined){
                if ((todo.tick - socklast) > 120){
                    if (socklost != 0){
                        sockstr = (sockstr + (" SOCKLOST=" + socklost.toString()));
                    };
                    network.NetworkSendMsg(1, ("/KD " + sockstr), 0, 0, 1);
                    sockstr = undefined;
                    socklast = todo.tick;
                    socklost = 0;
                };
            };
            if (xcachetick == 1){
                _local4 = amc.length;
                _local5 = 0;
                while (_local5 < _local4) {
                    amc[_local5].image.y = (amc[_local5].image.y - 30);
                    if (amc[_local5].image.y <= -900){
                        amc[_local5].image.y = 0;
                    };
                    _local5++;
                };
            } else {
                if (xcachetick == 2){
                    _local4 = amc.length;
                    _local5 = 0;
                    while (_local5 < _local4) {
                        amc[_local5].scrollRect = new Rectangle(0, (amcd[_local5] * 30), 30, 30);
                        var _local6 = amcd;
                        var _local7 = _local5;
                        var _local8 = (_local6[_local7] + 1);
                        _local6[_local7] = _local8;
                        if (amcd[_local5] >= 30){
                            amcd[_local5] = 0;
                        };
                        _local5++;
                    };
                } else {
                    if (xcachetick == 3){
                        _local4 = amc.length;
                        _local5 = 0;
                        while (_local5 < _local4) {
                            amc[0].bitmapData.fillRect(new Rectangle(0, 0, 20, 20), 0xFFFFFF);
                            amc[_local5].bitmapData.copyPixels(bd, new Rectangle(0, (amcd[_local5] * 30), 20, 20), new Point(0, 0), null, null, true);
                            _local6 = amcd;
                            _local7 = _local5;
                            _local8 = (_local6[_local7] + 1);
                            _local6[_local7] = _local8;
                            if (amcd[_local5] >= 30){
                                amcd[_local5] = 0;
                            };
                            _local5++;
                        };
                    } else {
                        if (xcachetick == 4){
                            if (1){
                                amc[0].bitmapData.fillRect(new Rectangle(0, 0, 728, 486), 0xFFFFFF);
                            } else {
                                amc[0].bitmapData.dispose();
                                amc[0].bitmapData = new BitmapData(728, 486, true, 0xFFFFFF);
                            };
                            _local4 = amcd.length;
                            _local5 = 0;
                            while (_local5 < _local4) {
                                amc[0].bitmapData.copyPixels(bd, new Rectangle(0, (amcd[_local5] * 30), 30, 30), new Point((((_local5 % 20) * 30) + 30), ((Math.floor((_local5 / 20)) * 30) + 30)), null, null, true);
                                _local6 = amcd;
                                _local7 = _local5;
                                _local8 = (_local6[_local7] + 1);
                                _local6[_local7] = _local8;
                                if (amcd[_local5] >= 30){
                                    amcd[_local5] = 0;
                                };
                                _local5++;
                            };
                        };
                    };
                };
            };
        }
        static function xtrace(_arg1, _arg2){
            var _local5:*;
            var _local6:URLRequest;
            var _local3:Object = new Object();
            _local3.channel = _arg1;
            _local3.str = _arg2;
            var _local4:* = hxtrace[_arg1];
            if (_local4 != undefined){
                _local5 = ((("[" + _local3.channel.toString()) + "] ") + _local3.str.toString());
                if (_local4.indexOf("trace") != -1){
                };
                if (_local4.indexOf("help") != -1){
                    axtrace.push(_local3);
                };
                if (_local4.indexOf("dbgstr") != -1){
                    main.dbgstr = _local5;
                };
                if (_local4.indexOf("log") != -1){
                    debuglog = (debuglog + (xatlib.searchreplace(";=", ";-", _local5) + ";="));
                };
                if (_local4.indexOf("message") != -1){
                    xatlib.GeneralMessage("debug", _local5);
                };
                if (_local4.indexOf("url") != -1){
                    _local6 = new URLRequest(((((todo.Http + "//") + _local3.channel.toString()) + ".fred?v=") + _local3.str.toString()));
                    navigateToURL(_local6);
                };
                if (_local4.indexOf("sock") != -1){
                    sockstr = _local5;
                    if (sockstr != undefined){
                        socklost++;
                    };
                };
            };
        }
        public static function xdebug_timer(_arg1){
            var _local2:* = new Date();
            var _local3:* = _local2.getTime();
            var _local4:* = ((timer[_arg1])!=null) ? (_local3 - timer[_arg1]) : 0;
            timer[_arg1] = _local3;
            return (_local4);
        }
        public static function debug_cmd(_arg1){
            var _local2:*;
            var _local3:*;
            var _local4:*;
            var _local5:*;
            var _local6:*;
            _local2 = _arg1.split(" ");
            switch (_local2[1]){
                case "clearlists":
                    xmessage.ClearLists(true);
                    _local3 = false;
                    todo.Users.push({
                        n:xatlib.NameNoXat(todo.w_name),
                        s:((todo.Macros)!=undefined) ? todo.Macros["status"] : undefined,
                        u:todo.w_userno,
                        v:todo.w_userrev,
                        a:todo.w_avatar,
                        h:todo.w_homepage,
                        online:true,
                        banned:_local3,
                        owner:false,
                        OnXat:!(((xatlib.xInt(global.xc) & 32) == 0)),
                        registered:todo.w_registered,
                        VIP:todo.w_VIP,
                        Bride:todo.w_d2,
                        aFlags:todo.w_d0,
                        Powers:todo.w_Powers
                    });
                    break;
                case "avs":
                    todo.avs = xatlib.xInt(_local2[2]);
                    break;
                case "cacheback":
                    cacheback = xatlib.xInt(_local2[2]);
                    break;
                case "zappri":
                    global.Sock = new Array("127.0.0.1", "127.0.0.1", "127.0.0.1", "127.0.0.1");
                    break;
                case "primary":
                    global.Sock = new Array("174.36.242.26", "174.36.242.34", "174.36.242.42", "69.4.231.250");
                    break;
                case "shadow":
                    global.Sock = new Array("208.43.218.82", "174.36.56.202", "174.36.4.146", "174.36.56.186");
                    break;
                case "gctrick":
                    chat.gctrick = xatlib.xInt(_local2[2]);
                    todo.helpstr = ("/debug gctrick=" + chat.gctrick);
                    todo.helpupdate = 0;
                    break;
                case "smilietest":
                    vsmilietest = xatlib.xInt(_local2[2]);
                    break;
                case "fakemessage":
                    vfakemessage = xatlib.xInt(_local2[2]);
                    break;
                case "avtest":
                    vavtest = xatlib.xInt(_local2[2]);
                    break;
                case "graph":
                    vgraph = xatlib.xInt(_local2[2]);
                    if (vgraph == 0){
                        main.equ.graphics.clear();
                    };
                    break;
                case "xtrace":
                    hxtrace[_local2[2]] = _local2[3];
                    break;
                case "msgcount":
                    vmsgcount = ((_local2[2]) ? _local2[2] : undefined);
                    break;
                case "feed":
                    feed = 0;
                    break;
                case "fps":
                    _local4 = xatlib.xInt(_local2[2]);
                    if (_local4 == 0){
                        _local4 = 12;
                    };
                    mainDlg.stage.frameRate = (fps = (afps = _local4));
                    fpsa = (fpsc = 0);
                    framec = (timesc = 0);
                    framet = getTimer();
                    fpsstr = "";
                    break;
                case "cache":
                    debug_xcacheasbitmap(xatlib.xInt(_local2[2]), xatlib.xInt(_local2[3]));
                    break;
                case "nocache":
                    debug_xnocache(xatlib.xInt(_local2[2]), _local2[3]);
                    break;
                case "smstats":
                    smstats = ((smstats) ? false : true);
                    break;
                case "dp":
                    _arg1 = (((("<ap p=\"" + _local2[2]) + "\" i=\"") + _local2[3]) + "\" />");
                    todo.helpstr = _arg1;
                    todo.helpupdate = 0;
                    network.socket.send(_arg1);
                    break;
                case "bump":
                    todo.BumpSound = (todo.CustomSound = "laserfire3");
                    todo.DoAudieSnd = true;
                    break;
                case "stest":
                    stest = 1;
                    if (todo.Macros["stest"]){
                        _local5 = todo.Macros["stest"].split(",");
                        _local6 = 1;
                        while (_local6 < 101) {
                            if (!_local5[_local6]){
                                break;
                            };
                            xconst.smih[_local5[_local6]] = true;
                            xconst.topsh[_local5[_local6]] = 1;
                            stesta[_local5[_local6]] = 1;
                            if (_local5[_local6].substr(0, 2) == "bk"){
                                xconst.backs[("b" + (100 + _local6))] = _local5[_local6];
                                xconst.backsR = xconst.ReverseObj(xconst.backs);
                            };
                            _local6++;
                        };
                        if (((_local2[2]) && (_local2[3]))){
                            todo.w_email = _local2[2];
                            todo.w_password = _local2[3];
                        };
                    };
                    break;
                case undefined:
                    todo.debug = ((todo.debug) ? false : true);
                    main.debugtext.visible = todo.debug;
                    break;
            };
        }
        public static function debug_memory(){
            memdata.unshift(System.totalMemory);
            if (memdata.length > xatlib.NX(425)){
                memdata.pop();
            };
            var _local1:* = getTimer();
            if (fpstimer != undefined){
                fpsdata.unshift((_local1 - fpstimer));
                if (fpsdata.length > xatlib.NX(425)){
                    fpsdata.pop();
                };
            };
            fpstimer = _local1;
            var _local2:* = (Math.round((((memdata[0] / 0x0400) / 0x0400) * 100)) / 100).toString();
            main.debugtext.text = ((((((_local2 + " MB ") + fps) + " FPS ") + afps) + " aFPS ") + main.dbgstr);
        }
        public static function debug_avtest(_arg1){
            var _local2:*;
            var _local3:*;
            if ((todo.tick % 12) == 0){
                _local2 = xatlib.FindUser(todo.w_userno);
                _local3 = ((todo.tick / 12) % 3);
                if (_local3 == 0){
                    _local3 = "//www.xatech.com/web_gear/background/xat_flames.jpg";
                };
                _local3 = (_local3 + ("?t=" + ((todo.tick / 12) % 8)));
                todo.Users[_local2].a = _local3;
                todo.Message.push({
                    i:((todo.mi * 2) + 1),
                    n:0,
                    t:("Message:" + (todo.tick / 12)),
                    u:todo.w_userno,
                    s:((main.ctabsmc.TabIsPrivate()) ? 2 : 0),
                    d:main.ctabsmc.TabUser()
                });
                todo.DoUpdateMessages = true;
                todo.ScrollDown = true;
            };
        }
        public static function debug_smilietest(_arg1){
            var _local3:*;
            var _local4:*;
            var _local5:*;
            var _local6:*;
            var _local2:* = 12;
            if (_arg1 == 3){
                _local2 = 144;
            };
            if ((todo.tick % _local2) == 0){
                _local3 = "";
                if (_arg1 == 1){
                    _local4 = 0;
                    while (_local4 < 10) {
                        _local5 = Math.floor((Math.random() * xconst.smia.length));
                        _local3 = (_local3 + (("(" + xconst.smia[_local5]) + ") "));
                        _local4++;
                    };
                } else {
                    if (_arg1 == 2){
                        _local4 = 0;
                        while (_local4 < 10) {
                            _local3 = (_local3 + "(");
                            _local6 = 0;
                            while (_local6 < 5) {
                                _local5 = xconst.smia.length;
                                _local5 = Math.floor((Math.random() * _local5));
                                _local3 = (_local3 + (xconst.smia[_local5] + "#"));
                                _local6++;
                            };
                            _local3 = _local3.substr(0, -1);
                            _local3 = (_local3 + ") ");
                            _local4++;
                        };
                    } else {
                        if (_arg1 == 3){
                            _local4 = 0;
                            while (_local4 < 10) {
                                if ((_local4 + sc) < xconst.smia.length){
                                    _local3 = (_local3 + (("(" + xconst.smia[(_local4 + sc)]) + ") "));
                                };
                                _local4++;
                            };
                            sc = (sc + 10);
                        };
                    };
                };
                todo.Message.push({
                    i:((todo.mi * 2) + 1),
                    n:0,
                    t:_local3,
                    u:todo.w_userno,
                    s:((main.ctabsmc.TabIsPrivate()) ? 2 : 0),
                    d:main.ctabsmc.TabUser()
                });
                todo.DoUpdateMessages = true;
                todo.ScrollDown = true;
            };
        }
        public static function debug_fakemessages(_arg1){
            var _local4:*;
            var _local5:*;
            var _local6:*;
            var _local2:* = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam consectetur, ante et eleifend faucibus, elit mi rhoncus ante, sit amet commodo justo nisi vel lectus. Donec porta tincidunt mauris a mollis. Maecenas ullamcorper ullamcorper nisi ac consequat. Proin leo purus, tincidunt eget sodales eget, elementum nec ante. Ut enim lorem, posuere a bibendum vitae, sodales sit amet diam. Fusce justo ipsum, vestibulum et ornare ac, aliquam non lacus. Fusce euismod pulvinar faucibus. Morbi adipiscing euismod magna, nec dapibus felis porta congue. Aenean eget luctus ipsum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris ut eros est, pretium fringilla est. Phasellus dolor dui, consequat eget feugiat pharetra, rutrum vel leo. Nulla facilisi. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam tempus vehicula sapien lacinia rhoncus. Suspendisse blandit, orci eu euismod iaculis, erat eros dictum mauris, in tincidunt orci est sit amet diam. Aenean tristique, lacus a aliquet tempus, est quam bibendum purus, nec pulvinar leo dui ac lorem. Fusce elementum ipsum eget dolor dignissim elementum. Aenean molestie nunc faucibus nulla condimentum molestie aliquet eros posuere. Quisque sapien justo, pretium eget mattis at, pulvinar sed eros.";
            var _local3:* = _local2.split(" ");
            if (_arg1 > 200){
                _arg1 = 200;
            };
            while (_arg1-- > 0) {
                _local4 = "";
                _local5 = Math.floor((Math.random() * 20));
                _local6 = 0;
                while (_local6 < _local5) {
                    _local4 = (_local4 + (_local3[Math.floor((Math.random() * _local3.length))] + " "));
                    _local6++;
                };
                todo.Message.push({
                    i:((todo.mi * 2) + 1),
                    n:0,
                    t:_local4,
                    u:todo.w_userno,
                    s:((main.ctabsmc.TabIsPrivate()) ? 2 : 0),
                    d:main.ctabsmc.TabUser()
                });
            };
            todo.DoUpdateMessages = true;
            todo.ScrollDown = true;
            vfakemessage = undefined;
        }
        public static function debug_graph(_arg1){
            var _local3:int;
            var _local4:*;
            main.equ.x = xatlib.NX(10);
            main.equ.y = xatlib.NY(470);
            var _local2:Graphics = main.equ.graphics;
            _local2.clear();
            if ((_arg1 & 4)){
                _local2.lineStyle(0, 204);
                _local2.beginFill(204, 0.5);
                _local2.moveTo(0, 0);
                _local3 = 0;
                while (_local3 < fpsdata.length) {
                    _local2.lineTo(_local3, (-(fpsdata[_local3]) / 2));
                    _local3++;
                };
                _local2.lineTo(fpsdata.length, 0);
                _local2.endFill();
            };
            if ((_arg1 & 2)){
                _local2.moveTo(0, -120);
                _local3 = 0;
                while (_local3 < (memdata.length - 1)) {
                    _local4 = (memdata[_local3] - memdata[(_local3 + 1)]);
                    _local2.moveTo(_local3, -120);
                    _local2.lineStyle(1, (((_local4 <= 0)) ? 0xCC0000 : 0xCC00));
                    _local2.lineTo(_local3, (-120 - ((_local4 * 20) / 100000)));
                    _local3++;
                };
                _local2.lineTo(memdata.length, -120);
            };
            if ((_arg1 & 1)){
                _local2.lineStyle(0, 0xCC00);
                _local2.beginFill(0xCC00, 0.5);
                _local2.moveTo(0, 0);
                _local3 = 0;
                while (_local3 < memdata.length) {
                    _local2.lineTo(_local3, (-(memdata[_local3]) / 1000000));
                    _local3++;
                };
                _local2.lineTo(memdata.length, 0);
                _local2.endFill();
            };
        }
        public static function debug_xnocache(_arg1, _arg2){
            var _local7:*;
            var _local8:*;
            if (_arg1 == 0){
                _arg1 = 12;
            };
            if (_arg2 == undefined){
                _arg2 = "pty";
            };
            var _local3:* = 0;
            var _local4:* = new Array();
            var _local5:* = new Array();
            var _local6:* = 0;
            while (_local6 < 20) {
                _local7 = 0;
                while (_local7 < _arg1) {
                    _local8 = (_local4[_local3] = new MovieClip());
                    _local8.x = (30 + (_local6 * 30));
                    _local8.y = (30 + (_local7 * 30));
                    mainDlg.addChild(_local4[_local3]);
                    _local8.SF = 2;
                    _local8.SP = 16;
                    _local8.SA = "";
                    _local8.mc = new smiley(_local8, _arg2);
                    _local8.addChild(_local8.mc);
                    _local3++;
                    _local7++;
                };
                _local6++;
            };
        }
        public static function debug_xcacheasbitmap(_arg1, _arg2){
            var _local5:*;
            var _local6:*;
            var _local7:*;
            var _local8:*;
            if (_arg2 == 0){
                _arg2 = 12;
            };
            mcstrip = new Sprite();
            bd = new BitmapData(30, 900, true, 0xFFFFFF);
            var _local3:* = 0;
            while (_local3 < 30) {
                _local5 = new smile();
                _local5.rotation = (_local3 * 12);
                _local5.x = ((Math.sin(((_local5.rotation - 45) * (Math.PI / 180))) * 13.4350288) + 9.5);
                _local5.y = (((_local3 * 30) - (Math.cos(((_local5.rotation - 45) * (Math.PI / 180))) * 13.4350288)) + 9.5);
                mcstrip.addChild(_local5);
                _local3++;
            };
            bd.draw(mcstrip);
            amc = new Array();
            amcd = new Array();
            var _local4:* = 0;
            if ((((_arg1 == 0)) || ((_arg1 == 1)))){
                _local6 = 0;
                while (_local6 < _arg2) {
                    _local7 = 0;
                    while (_local7 < 20) {
                        amc[_local4] = new xSprite();
                        _local8 = new Sprite();
                        _local8.graphics.beginFill(0xFFFFFF);
                        _local8.graphics.drawRect(0, 0, 24, 24);
                        _local8.graphics.endFill();
                        amc[_local4].addChild(_local8);
                        amc[_local4].mask = _local8;
                        amc[_local4].image = new Bitmap(bd);
                        amc[_local4].cacheAsBitmap = (((_arg1 == 0)) ? false : true);
                        amc[_local4].addChild(amc[_local4].image);
                        amc[_local4].x = (30 + (_local7 * 30));
                        amc[_local4].y = (30 + (_local6 * 30));
                        mainDlg.addChild(amc[_local4]);
                        _local4++;
                        _local7++;
                    };
                    _local6++;
                };
                xcachetick = 1;
            } else {
                if ((((_arg1 == 2)) || ((_arg1 == 3)))){
                    _local6 = 0;
                    while (_local6 < _arg2) {
                        _local7 = 0;
                        while (_local7 < 20) {
                            amc[_local4] = new xSprite();
                            amc[_local4].cacheAsBitmap = (((_arg1 == 2)) ? false : true);
                            amcd[_local4] = 0;
                            amc[_local4].image = new Bitmap(bd);
                            amc[_local4].addChild(amc[_local4].image);
                            amc[_local4].x = (30 + (_local7 * 30));
                            amc[_local4].y = (30 + (_local6 * 30));
                            mainDlg.addChild(amc[_local4]);
                            _local4++;
                            _local7++;
                        };
                        _local6++;
                    };
                    xcachetick = 2;
                } else {
                    if ((((_arg1 == 4)) || ((_arg1 == 5)))){
                        _local6 = 0;
                        while (_local6 < _arg2) {
                            _local7 = 0;
                            while (_local7 < 20) {
                                amc[_local4] = new Bitmap(bd);
                                amc[_local4].cacheAsBitmap = (((_arg1 == 4)) ? false : true);
                                amcd[_local4] = 0;
                                amc[_local4].x = (30 + (_local7 * 30));
                                amc[_local4].y = (30 + (_local6 * 30));
                                mainDlg.addChild(amc[_local4]);
                                _local4++;
                                _local7++;
                            };
                            _local6++;
                        };
                        xcachetick = 2;
                    } else {
                        if ((((_arg1 == 6)) || ((_arg1 == 7)))){
                            _local6 = 0;
                            while (_local6 < _arg2) {
                                _local7 = 0;
                                while (_local7 < 20) {
                                    amc[_local4] = new Bitmap(new BitmapData(30, 30, true, 0xFFFFFF));
                                    amc[_local4].cacheAsBitmap = (((_arg1 == 6)) ? false : true);
                                    amcd[_local4] = 0;
                                    amc[_local4].x = (30 + (_local7 * 30));
                                    amc[_local4].y = (30 + (_local6 * 30));
                                    mainDlg.addChild(amc[_local4]);
                                    _local4++;
                                    _local7++;
                                };
                                _local6++;
                            };
                            xcachetick = 3;
                        } else {
                            if ((((_arg1 == 8)) || ((_arg1 == 9)))){
                                amc[0] = new Bitmap(new BitmapData(728, 486, true, 0xFFFFFF));
                                amc[0].cacheAsBitmap = (((_arg1 == 8)) ? false : true);
                                mainDlg.addChild(amc[0]);
                                _local6 = 0;
                                while (_local6 < (_arg2 * 20)) {
                                    amcd[_local6] = 0;
                                    _local6++;
                                };
                                xcachetick = 4;
                            };
                        };
                    };
                };
            };
        }


        function init(_arg1:Event){
            var _local2:*;
            var _local3:*;
            todo.config["WEB"] = true;
            debug_init();			
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            todo.StageWidth = stage.stageWidth;
            todo.StageHeight = stage.stageHeight;
            stage.addEventListener(Event.RESIZE, this.onResize);
            if (todo.config["WEB"]){
                Security.allowDomain("*");
                Security.allowInsecureDomain("*");
				
                if (((parent) && (parent.parent))){
                    _local3 = parent.parent.root.loaderInfo;
                } else {
                    _local3 = root.loaderInfo;
                };
				_local2 = _local3.parameters;
                if (_local3.url.indexOf("https") === 0){
                    todo.Http = "https:";
                };
				todo.cdndomain = (todo.Http + "//cdn.ixat.io");
				//todo.cdndomain = "//ixat.io";
                todo.usedomain = (todo.Http + todo.usedomain);
                todo.chatdomain = (todo.Http + todo.chatdomain);
                todo.imagedomain = (todo.Http + todo.imagedomain);
                todo.flashdomain = (todo.Http + todo.flashdomain);
				xatlib.noCurve = _local2.nocurve ? true : false;
				
                if (_local2.id != undefined){
                    todo.w_room = xatlib.xInt(_local2.id);
                };
                if (_local2.pass != undefined){
                    todo.pass = (global.pass = xatlib.xInt(_local2.pass));
                };
                if (_local2.rf != undefined){
                    global.rf = xatlib.xInt(_local2.rf);
                };
                if (_local2.gn != undefined){
                    global.gn = _local2.gn;
                };
                if (_local2.um != undefined){
                    global.um = xatlib.xInt(_local2.um);
                };
                if (_local2.lg != undefined){
                    global.lg = _local2.lg;
                };
                if (_local2.rl != undefined){
                    global.rl = _local2.rl;
                };
                if (((!((_local2.pw == undefined))) && (!((_local2.em == undefined))))){
                    todo.w_password = xatlib.CleanText(_local2.pw, 1);
                };
                if (_local2.pw == "##"){
                    todo.RefreshLogin = true;
                };
                if (_local2.em != undefined){
                    todo.w_email = xatlib.CleanText(_local2.em, 0);
                };
                if (_local2.cn != undefined){
                    global.cn = xatlib.xInt(_local2.cn);
                };
                global.gb = _local2.gb;
                if (_local2.xn != undefined){
                    global.xn = _local2.xn;
                };
                if (_local2.xp != undefined){
                    global.xp = _local2.xp;
                };
                if (_local2.xh != undefined){
                    global.xh = _local2.xh;
                };
                if (_local2.xb != undefined){
                    global.xb = _local2.xb;
                };
                if (_local2.xl != undefined){
                    global.xl = _local2.xl;
                };
                if (_local2.xm != undefined){
                    global.xm = _local2.xm;
                };
                if (_local2.xt != undefined){
                    global.xt = _local2.xt;
                };
                if (_local2.xo != undefined){
                    global.xo = _local2.xo;
                };
                if (_local2.xc != undefined){
                    global.xc = xatlib.xInt(_local2.xc);
                };
                global.sv = sv;
                global.lv = lv;
            };
			
			todo.sockdomain = "198.251.80.169";
			todo.useport = 337;
			
			todo.w_useroom = todo.w_room;
			xconst.xconstInit();
            beep = new beepsnd();
            tab_sound = new beepsnd();
            dingdong = new dingdongsnd();
			tickle_sound = new ticklesnd();
			tickle2_sound = new tickle2snd();
            this.SetState(0);
            if (xatlib.xInt(Capabilities.version.split(" ")[1]) < 10){
                gctrick = 60;
            };
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onkeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP, this.onkeyUp);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onmouseMove);
            addEventListener(Event.ENTER_FRAME, this.tick);
		}
		
        function onResize(_arg1:Event){
        }
        function onmouseMove(_arg1:Event){
            if ((((todo.OnSuper == false)) && ((todo.lb == "t")))){
                network.NetworkSendMsg(1, "/K2", 0, 0, 1);
                todo.OnSuper = true;
            };
            if (todo.Away){
                NotAway();
            };
        }
        function SetState(_arg1, _arg2=undefined){
            State = _arg1;
            Timeout = _arg2;
        }
        function tick(_arg1:Event){
            var flushret:* = undefined;
            var temp_comm:* = undefined;
            var Request:* = null;
            var loader:* = null;
            var t:* = undefined;
            var str:* = undefined;
            var event:* = _arg1;
            xdebug_timer("chattick");			
            if (State == 0){
                sot = xatlib.getLocal("chat", "/");
                sot.objectEncoding = ObjectEncoding.AMF0;
                sot.data.w_test = Math.random();
                this.SetState(1);
            };
            if (State == 1){
                flushret = sot.flush();
                if (flushret == SharedObjectFlushStatus.FLUSHED){
                    sot = null;
                    this.SetState(2);
                };
            };
            if (State == 2){
                this.CookieStuff();
                if (todo.w_lang == undefined){
                    if (todo.w_roomlang == undefined){
                        this.SetState(5);
                    } else {
                        todo.w_lang = todo.w_roomlang;
                        this.SetState(3);
                    };
                } else {
                    if (todo.w_lang == 0){
                        this.SetState(5);
                    } else {
                        this.SetState(3);
                    };
                };
            };
			if (State == 3){
                todo.LangText = undefined;
                if (((((!(todo.w_lang)) || ((todo.w_lang == "English")))) || ((todo.w_lang.substr(0, 2) == "en")))){
                    this.SetState(5);
                } else {
					/* for new lang file shit
					temp_comm = ((todo.usedomain + "/json/lang/getlang2.php?f=box&l=") + todo.w_lang);
					*/
                    temp_comm = ((((todo.usedomain + "/json/lang/Chat/") + todo.w_lang) + ".php?c=") + global.sv);
                    xatlib.LoadVariables(temp_comm, onLang);
                    this.SetState(4, 20);
                };
            };
            if (State == 4){
                if (todo.LangText != undefined){
                    this.SetState(5);
                };
                if (Timeout != undefined){
                    Timeout--;
                };
                if (Timeout <= 0){
                    this.SetState(5);
                };
            };
            if (State == 5){
                mainDlg = new main();
                addChild(mainDlg);
                mainDlg.StartChat();
                network.NetworkInit();
                network.NetworkStartChat();
                if (!todo.config["nolocalconnection"]){
                    this.AppComms();
                };
                if (todo.w_room == 8){
                    xatlib.AddBackground(this, -10, -10, 240, 160, (((((128 << 10) | xatlib.c_tl) | xatlib.c_tr) | xatlib.c_bl) | xatlib.c_br));
                };
                if ((global.xc & 1)){
                    if (global.xp != undefined){
                        xatlib.GeneralMessage(" ", (xconst.ST(249) + global.xp));
                        main.box_layer.GeneralMessageH.Dia.Ok.But.PressFunc = function (_arg1){
                            main.box_layer.GeneralMessageH.Delete();
                            todo.w_avatar = global.xp;
                            xatlib.MainSolWrite("w_avatar", todo.w_avatar);
                            xatlib.ReLogin();
                        };
                    };
                };
                Request = new URLRequest();
                Request.url = (todo.chatdomain + "pow2.php");
                Request.method = URLRequestMethod.GET;
                loader = new URLLoader();
                loader.load(Request);
                loader.addEventListener(Event.COMPLETE, this.PowHandler);
                this.SetState(6);
            };
            if (State == 6){
                if (AppTimeout != undefined){
                    AppTimeout--;
                    if (AppTimeout <= 0){
                        if (todo.messageecho == "m"){
                            todo.messageecho = undefined;
                        };
                        AppTimeout = undefined;
                    };
                };
                network.NetworkTick();
                tickcode.DoTick();
                if (mainDlg){
                    mainDlg.tick2(null);
                };
            };
            if (((!((gctrick == 0))) && (((todo.tick % gctrick) == 0)))){
                try {
                    new LocalConnection().connect("foo");
                    new LocalConnection().connect("foo");
                } catch(e:Error) {
                };
            };
            if (((((((debug) || ((((todo.useport == 10025)) && ((todo.sockdomain == "174.36.242.26")))))) && (!(todo.bStrip)))) && (!(todo.bSmilies)))){
                framec++;
                if (framec >= period){
                    t = getTimer();
                    fps = (Math.round((((period * 1000) / (t - framet)) * 100)) / 100);
                    fpsa = (fpsa + fps);
                    fpsc++;
                    afps = (Math.round(((fpsa / fpsc) * 100)) / 100);
                    fpsstr = (fpsstr + (fps.toString() + ","));
                    timesc++;
                    if (timesc >= times){
                        str = (((((((((("lag=" + fpsstr) + Capabilities.version) + ",") + System.totalMemory) + ",") + mainDlg.stage.frameRate) + ",") + afps) + ",") + cVersion);
                        network.NetworkSendMsg(1, ("/KD " + str), 0, 0, 1);
                        fpsstr = "";
                        timesc = 0;
                    };
                    framet = t;
                    framec = 0;
                };
            };			
			debug_tick();
            if (ctrlTimer != undefined){
                ctrlTimer--;
                if (ctrlTimer <= 0){
                    ctrlTimer = undefined;
                    keybits[Keyboard.CONTROL] = false;
                };
            };
            t = xdebug_timer("chattick");
            chat.timer["tickslg"] = int(((t + (xatlib.xInt(chat.timer["tickslg"]) * 15)) / 16));			
        }

		function PowHandler(_arg_1:Event){
            var _local_6:*;
            var _local_7:*;
            var _local_9:*;
            var _local_10:*;
            var _local_2:URLLoader = URLLoader(_arg_1.target);
            var _local_3:* = xJSON.decode(_local_2.data);
            network.iprules["pow2"] = _local_3;
            var _local_4:* = false;
            var _local_5:* = false;
            var _local_8:* = 0;
            while (_local_8 < _local_3.length) {
                for (_local_9 in _local_3[_local_8][1]) {
                    switch (_local_3[_local_8][0]){
                        case "backs":
                            _local_4 = true;
                            xconst.backs[_local_9] = _local_3[_local_8][1][_local_9];
                            break;
                        case "hugs":
                            _local_5 = true;
                            xconst.hugs[_local_9] = _local_3[_local_8][1][_local_9];
                            break;
                        case "topsh":
                            xconst.topsh[_local_9] = xatlib.xInt(_local_3[_local_8][1][_local_9]);
                            xconst.smi = (xconst.smi + ("," + _local_9));
                            xconst.smia.push(_local_9);
                            xconst.smih[_local_9] = true;
                            break;
                        case "Puzzle":
                            xconst.Puzzle[_local_9] = _local_3[_local_8][1][_local_9];
                            break;
                        case "pssa":
                            _local_10 = xatlib.xInt(_local_3[_local_8][1][_local_9]);
                            xconst.pssa[(_local_10 + 1)] = _local_9;
                            xconst.smi = (xconst.smi + ("," + _local_9));
                            xconst.smia.push(_local_9);
                            xconst.smih[_local_9] = true;
                            xconst.pssh[_local_9] = _local_10;
                            break;
                        case "pawns":
                            xconst.Pawns = _local_3[_local_8][1];
                            break;
                        case "actions":
                            xconst.BuildActiontable(_local_3[_local_8][1], 0);
                            _local_3[_local_8][1] = null;
                            break;
                        case "isgrp":
                            xconst.IsGroup[_local_9] = _local_3[_local_8][1][_local_9];
                            break;
						case "SuperP":
							xconst.AddToSuperP(_local_9, _local_3[_local_8][1][_local_9]);
							break;
						case "pawnids":
                            todo.Pawns = _local_3[_local_8][1];
                            break;
						case "staff":
							todo.ixatStaff = _local_3[_local_8][1];
                            break;
						case "volunteers":
							todo.ixatVolunteer = _local_3[_local_8][1];
                            break;
                    };
                };
                _local_8++;
            };
            if (_local_4){
                xconst.backsR = xconst.ReverseObj(xconst.backs);
            };
            if (_local_5){
                xconst.hugsR = xconst.ReverseObj(xconst.hugs);
            };
        }
		
        function CookieStuff(){
            var _local4:Date;
            var _local5:*;
            var _local6:*;
            if (todo.w_lang == undefined){
                todo.w_lang = global.lg;
            };
            if (todo.w_langv == undefined){
                todo.w_langv = global.lv;
            };
            var _local1:* = xatlib.getLocal(("chat" + String(todo.w_room)), "/");
            _local1.objectEncoding = ObjectEncoding.AMF0;
            if (_local1 != null){
                if (todo.pass != undefined){
                    _local1.data.pass = todo.pass;
                    _local1.flush();
                } else {
                    todo.pass = _local1.data.pass;
                    if (todo.pass != undefined){
                        todo.pass = xatlib.xInt(todo.pass);
                    };
                };
            };
            var _local2:* = xatlib.getLocal("chat", "/");
            _local2.objectEncoding = ObjectEncoding.AMF0;
            var _local3:* = 1;
            if (((1) && (!((_local2 == null))))){
                _local4 = new Date();
                _local5 = _local4.getTime();
                _local6 = 0;
                if (_local2.data.w_lastroom != undefined){
                    _local3 = _local2.data.w_lastroom;
                };
                if (_local2.data.w_lastauto != undefined){
                    _local6 = _local2.data.w_lastauto;
                };
                _local2.data.w_lastauto = _local5;
                if (todo.w_lang != undefined){
                    if (xatlib.xInt(todo.w_lang) < 10000){
                        _local2.data.w_lang = todo.w_lang;
                    };
                } else {
                    if (_local2.data.w_lang != undefined){
                        todo.w_lang = _local2.data.w_lang;
                    };
                };
                _local2.flush();
                if (_local2.data.w_userno != undefined){
                    if (_local2.data.w_userno != undefined){
                        todo.w_userno = xatlib.xInt(_local2.data.w_userno);
                    };
                    if (_local2.data.w_userrev != undefined){
                        todo.w_userrev = xatlib.xInt(_local2.data.w_userrev);
                    };
                    if (_local2.data.w_k1b != undefined){
                        todo.w_k1 = xatlib.xInt(_local2.data.w_k1b);
                    };
                    if (_local2.data.w_k1c != undefined){
                        todo.w_k1 = _local2.data.w_k1c;
                    };
                    if (_local2.data.w_k2 != undefined){
                        todo.w_k2 = xatlib.xInt(_local2.data.w_k2);
                    };
                    todo.w_cb = xatlib.xInt(_local2.data.w_cb);
                    if (_local2.data.w_name != undefined){
                        todo.w_name = xatlib.CleanTextNoXat(_local2.data.w_name);
                    };
                    if (_local2.data.w_avatar != undefined){
                        todo.w_avatar = xatlib.CleanAv(_local2.data.w_avatar);
                    };
                    if (_local2.data.w_homepage != undefined){
                        todo.w_homepage = _local2.data.w_homepage;
                    };
                    if (_local2.data.w_d0 != undefined){
                        todo.w_d0 = xatlib.xInt(_local2.data.w_d0);
                    };
                    if (_local2.data.w_d1 != undefined){
                        todo.w_d1 = xatlib.xInt(_local2.data.w_d1);
                    };
                    todo.w_d2 = xatlib.xInt(_local2.data.w_d2);
                    todo.w_d3 = xatlib.xInt(_local2.data.w_d3);
                    todo.w_dt = xatlib.xInt(_local2.data.w_dt);
                    todo.w_Powers = _local2.data.w_Powers;
                    todo.w_Mask = _local2.data.w_Mask;
                    todo.w_bride = _local2.data.w_bride;
                    todo.w_xats = _local2.data.w_xats;
                    todo.w_PowerO = _local2.data.w_PowerO;
                    todo.w_sn = _local2.data.w_sn;
                    if (_local2.data.w_coins != undefined){
                        todo.w_coins = xatlib.xInt(_local2.data.w_coins);
                    };
                    if (_local2.data.w_k3 != undefined){
                        todo.w_k3 = xatlib.xInt(_local2.data.w_k3);
                    };
                    if (_local2.data.w_registered != undefined){
                        todo.w_registered = _local2.data.w_registered;
                    };
                    todo.w_autologin = _local2.data.w_autologin;
                    todo.w_news = xatlib.xInt(_local2.data.w_news);
                    todo.w_Vol[1] = _local2.data.w_Vol1;
                    todo.w_Vol[2] = _local2.data.w_Vol2;
                    todo.w_Vol[5] = _local2.data.w_Vol5;
                    todo.w_Vol[6] = _local2.data.w_Vol6;
                    todo.w_Vol[7] = _local2.data.w_Vol7;
                    todo.w_Vol[8] = _local2.data.w_Vol8;
                    todo.w_Vol[9] = _local2.data.w_Vol9;
                    if ((((todo.w_autologin == undefined)) || ((todo.w_autologin == true)))){
                        todo.w_autologin = 0xFFFF;
                    };
                    if (todo.w_autologin == false){
                        todo.w_autologin = 65534;
                    };
                    todo.autologin = todo.w_autologin;
                    if (!(global.xc & 32)){
                        if ((_local5 - _local6) < (((todo.w_room == _local3)) ? 10000 : 2000)){
                            todo.w_autologin = (todo.w_autologin & ~(1));
                        };
                    };
                    if ((((todo.w_useroom > 100)) && ((((todo.StageWidth < 220)) || ((todo.StageHeight < 140)))))){
                        todo.w_autologin = (todo.w_autologin & ~(1));
                    } else {
                        if ((global.xc & 0x0200)){
                            todo.w_autologin = (todo.w_autologin & ~(1));
                        } else {
                            if ((((todo.w_useroom > 100)) && (!((global.pw == undefined))))){
                                todo.w_autologin = (todo.w_autologin | 1);
                            };
                        };
                    };
                    if (_local2.data.w_banlist != undefined){
                        todo.w_banlist = _local2.data.w_banlist;
                    };
                    if (_local2.data.w_friendlist != undefined){
                        todo.w_friendlist = _local2.data.w_friendlist;
                    };
					network.OnFriendList(0);
                    if (_local2.data.w_friendlist2 != undefined){
                        todo.w_friendlist2 = _local2.data.w_friendlist2;
                    };
                    if (_local2.data.w_ignorelist2 != undefined){
                        todo.w_ignorelist2 = _local2.data.w_ignorelist2;
                    };
                    if (_local2.data.w_userrevlist != undefined){
                        todo.w_userrevlist = _local2.data.w_userrevlist;
                    };
                    if (_local2.data.w_namelist != undefined){
                        todo.w_namelist = _local2.data.w_namelist;
                    };
                    if (_local2.data.w_avatarlist != undefined){
                        todo.w_avatarlist = _local2.data.w_avatarlist;
                    };
                    if (_local2.data.w_homepagelist != undefined){
                        todo.w_homepagelist = _local2.data.w_homepagelist;
                    };
                    todo.w_Options = _local2.data.w_Options;
                    todo.Macros = _local2.data.Macros;
                    if (!todo.Macros){
                        todo.Macros = {};
                    };
                    global.sv = _local2.data.w_sv;
                };
            };
            if (todo.w_Vol[1] == undefined){
                todo.w_Vol[1] = 35;
            };
            if (todo.w_Vol[2] == undefined){
                todo.w_Vol[2] = 35;
            };            
			if (todo.w_Vol[5] == undefined){
                todo.w_Vol[5] = 35;
            };
            if (todo.w_Vol[6] == undefined){
                todo.w_Vol[6] = 35;
            };     
			if (todo.w_Vol[7] == undefined){
                todo.w_Vol[7] = 35;
            };
            if (todo.w_Vol[7] == undefined){
                todo.w_Vol[7] = 35;
            };
			if (todo.w_Vol[8] == undefined){
                todo.w_Vol[8] = 35;
            };
            if (todo.w_Vol[9] == undefined){
                todo.w_Vol[9] = 35;
            };
            if (((!((_local2 == null))) && (!((_local2.data.w_sound == undefined))))){
                todo.w_sound = _local2.data.w_sound;
            };
			if (((!((_local2 == null))) && (!((_local2.data.w_audio == undefined))))){
                todo.w_audio = _local2.data.w_audio;
            };
            network.TrimIgnoreList();
            if (global.xn != undefined){
                if ((((todo.w_name == "")) || (xatlib.IsDefaultName(todo.w_name)))){
                    todo.w_name = global.xn;
                };
            };
            if (global.xp != undefined){
                if (todo.w_avatar == ""){
                    todo.w_avatar = global.xp;
                };
            };
            if (global.xh != undefined){
                if (todo.w_homepage == ""){
                    todo.w_homepage = global.xh;
                };
            };
            if (global.xl != undefined){
                todo.MainFlagBits = (todo.MainFlagBits | xconst.f_Lobby);
            };
            if (network.OnFriendList(3)){
                network.UpdateFriendList(3, 0);
            };
            todo.w_roomlang = global.rl;
            if (force_lang != undefined){
                todo.w_lang = force_lang;
            };
        }
        function onkeyDown(_arg1:KeyboardEvent):void{
            if (_arg1.keyCode == Keyboard.CONTROL){
                ctrlTimer = 12;
            };
            keybits[_arg1.keyCode] = true;
        }
        function onkeyUp(_arg1:KeyboardEvent):void{
            if (_arg1.keyCode == Keyboard.CONTROL){
                ctrlTimer = undefined;
            };
            keybits[_arg1.keyCode] = false;
        }
        function sending_lc_Status(_arg1:Event){
        }
        function AppComms(){
            onMsg2 = this.onMsg;
            if (force_xc != undefined){
                global.xc = force_xc;
            };
            if (global.cn != undefined){
                toxat = (toxat + global.cn);
                fromxat = (fromxat + global.cn);
            };
            if ((global.xc & 0x0800)){
                sending_lc = new LocalConnection();
                sending_lc.addEventListener(StatusEvent.STATUS, this.sending_lc_Status);
                receiving_lc = new LocalConnection();
                receiving_lc.client = this;
                try {
                    receiving_lc.connect(toxat);
                } catch(error:ArgumentError) {
                };
            };
        }
        public function onMsg(_arg1, _arg2, _arg3){
            var _local4:*;
            var _local5:*;
            var _local6:*;
            var _local7:*;
            var _local8:*;
            var _local9:*;
            var _local10:*;
            var _local11:*;
            var _local12:*;
            var _local13:*;
            var _local14:*;
            var _local15:*;
            if (_arg1 == 1){
                connectchannel = _arg1;
                connectuser = _arg2;
                connectmessage = _arg3;
                if (todo.lb != "n"){
                    sending_lc.send(fromxat, "onMsg", _arg1, _arg2, _arg3);
                };
                AppTimeout = 120;
            } else {
                if (_arg1 == 2){
                    _local4 = main.ctabsmc.TabUser();
                    sending_lc.send(fromxat, "onMsg", 2, (((_local4 == undefined)) ? 0 : _local4), "");
                } else {
                    if (_arg1 == 3){
                        if (_arg3 == 0){
                            _arg3 = todo.w_userno;
                        };
                        _local5 = xatlib.FindUser(_arg3);
                        if (_local5 != -1){
                            sending_lc.send(fromxat, "onMsg", _arg1, ((_arg3)==todo.w_userno) ? 0 : todo.Users[_local5].u, todo.Users[_local5].n);
                        };
                    } else {
                        if (_arg1 == 4){
                            if (_arg3 == "m"){
                                if (network.YC){
                                    _local6 = (xatlib.xInt(todo.w_d1) - network.YC);
                                    if (_local6 < 0){
                                        _local6 = 0;
                                    };
                                    _local6 = xatlib.xInt(((_local6 / (24 * 3600)) + 0.3));
                                    if (_local6 > 0){
                                        todo.messageecho = _arg3;
                                    } else {
                                        todo.helpstr = "You need to be a subscriber to use translator";
                                        todo.helpupdate = 0;
                                    };
                                };
                            } else {
                                todo.messageecho = _arg3;
                                if (todo.messageecho == "a"){
                                    sending_lc.send(fromxat, "onMsg", 4, 0, "d");
                                    _local7 = todo.Users.length;
                                    _local8 = 0;
                                    while (_local8 < _local7) {
                                        if (todo.Users[_local8].online == true){
                                            sending_lc.send(fromxat, "onMsg", 4, todo.Users[_local8].u, ("u" + todo.Users[_local8].a));
                                        };
                                        _local8++;
                                    };
                                };
                            };
                        } else {
                            if ((((_arg1 >= 10000)) || ((_arg1 == 0)))){
                                if ((((_arg1 >= 40000)) && ((_arg1 <= 50000)))){
                                    if (_arg3 == "j"){
                                        network.NetworkSendExtMessage(_arg3);
                                    } else {
                                        network.NetworkSendxmlExtMessage(_arg3);
                                    };
                                } else {
                                    network.NetworkSendExtMessage(_arg1, _arg2, _arg3);
                                };
                            } else {
                                if (_arg1 == 5){
                                    stage.focus = main.textfield2;
                                    main.textfield2.appendText(_arg3);
                                    main.textfield2.setSelection(main.textfield2.text.length, main.textfield2.text.length);
                                } else {
                                    if (_arg1 == 6){
                                        if (_arg3 == 0){
                                            _arg3 = todo.w_userno;
                                        };
                                        _local9 = xatlib.FindUser(_arg3);
                                        if (_local9 != -1){
                                            sending_lc.send(fromxat, "onMsg", _arg1, todo.Users[_local9].u, todo.Users[_local9]);
                                        };
                                    } else {
                                        if (_arg1 == 7){
                                            if (_arg3 == "x"){
                                                chat.mainDlg.GotoProfile(_arg2);
                                            } else {
                                                if (_arg3 == "p"){
                                                    main.openDialog(2, _arg2);
                                                } else {
                                                    if (_arg3 == "b"){
                                                        xatlib.Register_onRelease(1);
                                                    } else {
                                                        _local10 = _arg3.split(",");
                                                        if (_local10[0] == "ban"){
                                                            network.NetworkGagUser("g", _arg2, true, xatlib.xInt(_local10[1]), _local10[2]);
                                                        };
                                                    };
                                                };
                                            };
                                        } else {
                                            if (_arg1 == 8){
                                                if (_arg3){
                                                    todo.w_avatar = _arg3;
                                                };
                                                todo.w_cb++;
                                                _local11 = xatlib.getLocal("chat", "/");
                                                _local11.objectEncoding = ObjectEncoding.AMF0;
                                                if (((1) && (!((_local11 == null))))){
                                                    _local11.data.w_cb = todo.w_cb;
                                                    _local11.data.w_avatar = todo.w_avatar;
                                                    _local11.flush();
                                                };
                                                todo.lb = "n";
                                                todo.DoUpdate = true;
                                                network.NetworkClose();
                                                main.logoutbutonPress();
                                            } else {
                                                if (_arg1 == 9){
                                                    _local12 = "not set";
                                                    switch (_arg3){
                                                        case "sv":
                                                            _local12 = global.sv;
                                                            break;
                                                        case "smi":
                                                            _local12 = xconst.smi;
                                                            break;
                                                        case "w_xats":
                                                            _local12 = todo.w_xats;
                                                            break;
                                                        case "YC":
                                                            _local12 = network.YC;
                                                            break;
                                                        case "w_d1":
                                                            _local12 = todo.w_d1;
                                                            break;
                                                        case "w_dt":
                                                            _local12 = todo.w_dt;
                                                            break;
                                                        case "w_Powers":
                                                            _local12 = todo.w_Powers;
                                                            break;
                                                        case "w_Mask":
                                                            _local12 = (((((todo.w_Mask == undefined)) || ((todo.w_Mask == 0)))) ? "0,0,0" : todo.w_Mask);
                                                            break;
                                                        case "w_langv":
                                                            _local12 = todo.w_langv;
                                                            break;
                                                        case "pssa":
                                                            _local12 = xconst.pssa;
                                                            break;
                                                        case "w_PowerO":
                                                            _local12 = todo.w_PowerO;
                                                            break;
                                                        case "w_lang":
                                                            _local12 = todo.w_lang;
                                                            break;
                                                        case "config":
                                                            _local12 = todo.config;
                                                            break;
                                                        case "gUserNo":
                                                            _local12 = global.gUserNo;
                                                            break;
                                                        case "w_useroom":
                                                            _local12 = todo.w_useroom;
                                                            break;
                                                        case "gconfig":
                                                            _local12 = todo.gconfig;
                                                            break;
                                                        case "w_cb":
                                                            _local12 = todo.w_cb;
                                                            break;
                                                        case "w_r":
                                                            _local12 = todo.w_r;
                                                            break;
                                                        case "WY":
                                                            _local12 = todo.WY;
                                                            break;
                                                        case "w_room_cb":
                                                            _local12 = todo.w_room_cb;
                                                            break;
                                                        default:
                                                            if (1){
                                                            };
                                                    };
                                                    sending_lc.send(fromxat, "onMsg", _arg1, _arg3, _local12);
                                                } else {
                                                    if (_arg1 == 10){
                                                        _local13 = todo.Message.length;
                                                        _local14 = 0;
                                                        while (_local14 < _local13) {
                                                            if (todo.Message[_local14].i == xatlib.xInt(_arg2)){
                                                                if (_arg3 != ""){
                                                                    if (todo.Message[_local14].t.indexOf(" [") != -1){
                                                                        todo.Message[_local14].t = (((todo.Message[_local14].t.substr(0, todo.Message[_local14].t.indexOf(" [")) + " [") + _arg3) + "]");
                                                                    } else {
                                                                        todo.Message[_local14].t = (((todo.Message[_local14].t + " [") + _arg3) + "]");
                                                                    };
                                                                };
                                                                xmessage.DeleteOneMessageMc(_local14);
                                                                todo.DoUpdateMessages = true;
                                                                if ((xatlib.xInt(_arg2) & 1)){
                                                                    _local15 = todo.Message[_local14].t;
                                                                    todo.DoUpdateMessages = true;
                                                                    todo.ScrollDown = true;
                                                                    todo.LastScrollTime = undefined;
                                                                    if (todo.MessageCount > 0){
                                                                        todo.MessageCount = 25;
                                                                    };
                                                                    if (_local15 != todo.LastMessageToSend){
                                                                        if (todo.MessageToSend.length == 0){
                                                                            todo.MessageToSend = _local15;
                                                                        };
                                                                        todo.MessageToSend = todo.MessageToSend.substr(0, 0x0100);
                                                                    } else {
                                                                        todo.MessageCount = 25;
                                                                    };
                                                                };
                                                                break;
                                                            };
                                                            _local14++;
                                                        };
                                                    } else {
                                                        if (_arg1 == 12){
                                                            if (todo.systemMessages.indexOf(_arg3) == -1){
                                                                todo.systemMessages = (todo.systemMessages + _arg3);
                                                            };
                                                            if (_arg3 == "v"){
                                                                sending_lc.send(fromxat, "onMsg", _arg1, _arg3, (((todo.w_sound & 1)) ? todo.w_Vol[1] : 0));
                                                            };
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

    }
}//package 
