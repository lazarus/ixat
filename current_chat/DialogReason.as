package {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
    import flash.net.*;

    public class DialogReason extends Sprite {

        const TO = 5;

        public var mcreasonbackground;
        var tf;
        var tf2;
        var UserNo;
        var bBan;
        var bDunce;
        var bNaughty;
        var bYellow;

        public function DialogReason(_arg1){
            var _local4:*;
            var _local5:*;
            var _local6:*;
            var _local7:*;
            var _local12:*;
            var _local13:Number;
            this.tf2 = {text:""};
            super();
            this.UserNo = _arg1.UserNo;
            this.bBan = _arg1.bBan;
            this.bDunce = _arg1.bDunce;
            this.bNaughty = _arg1.bNaughty;
            var _local2:* = new Array();
            var _local3:int = xatlib.FindUser(todo.w_userno);
            _local7 = xatlib.FindUser(this.UserNo);
            if (((((this.bBan) || (this.bDunce))) || (this.bNaughty))){
                if (this.bBan){
                    if (todo.HasPower(_local3, 41)){
						if(todo.Users[_local7].flag0 & 0x100) {
							_local2.push("Un" + xconst.ST(197), this.ReasonGag);
						} else {
							_local2.push(xconst.ST(197), this.ReasonGag);
						}
                    };
                    if (((todo.HasPower(_local3, 46)) && (todo.w_owner))){
                        _local2.push(xconst.ST(198), this.ReasonMute);
                    };
                };
                if (this.bBan){
                    for (_local4 in xconst.Puzzle) {
                        if (todo.HasPower(_local3, _local4)){
                            _local2.push(((xconst.Puzzle[_local4] + "Ban;=") + _local4), this.ReasonOK);
                        };
                    };
                };
				if (todo.HasPower(_local3, xconst.pssh["redcard"])){
                    if ((todo.Users[_local7].flag0 & 0x200000)){
                        _local2.push(xconst.ST(279), this.ReasonRed);
                    } else {
                        _local2.push(xconst.ST(278), this.ReasonRed);
                    };
                };
            } else {
                if (todo.HasPower(_local3, 25)){
                    _local2.push("Boot", this.ReasonBoot);
                };
                if (todo.HasPower(_local3, 121)){
                    _local2.push("Zap", this.ReasonZap);
                };
                if (todo.HasPower(_local3, 158)){
                    if ((todo.Users[_local7].flag0 & 0x8000)){
                        _local2.push(xconst.ST(246), this.ReasonDunce);
                    } else {
                        _local2.push(xconst.ST(245), this.ReasonDunce);
                    };
                };
                if (todo.HasPower(_local3, xconst.pssh["naughtystep"])){
                    _local7 = xatlib.FindUser(this.UserNo);
                     if ((todo.Users[_local7].flag0 & 0x80000)){
     	                _local2.push(xconst.ST(267), this.ReasonNaughty);
                     } else {
                        _local2.push(xconst.ST(266), this.ReasonNaughty);
                    };
                };
                if (todo.HasPower(_local3, xconst.pssh["yellowcard"])){
                    if ((todo.Users[_local7].flag0 & 0x100000)){
                        _local2.push(xconst.ST(271), this.ReasonYellow);
                    } else {
                        _local2.push(xconst.ST(270), this.ReasonYellow);
                    };
                };
            };
            if (this.bBan){
                _local2.push(xconst.ST(81), this.ReasonKickBan);
            } else {
                if (this.bDunce){
                } else {
                    _local2.push(xconst.ST(79), this.ReasonKickBan);
                };
            };
            _local2.push(xconst.ST(66), this.CloseReason);
            var _local8:* = (((main.upx - 270) - 15) - 50);
            if (_local8 < 5){
                _local8 = 5;
            };
			//Techy ~ fixed ban time textbox width
            var _local9:* = xatlib.NY(30);
            this.mcreasonbackground = new xDialog(this, _local8, _local9, (270 + 60), (160 + (40 * ((_local2.length + 2) >> 2))), (" " + ((((this.bBan) || (this.bDunce))) ? xconst.ST(81) : xconst.ST(79))), undefined, 0);
            var _local10:* = this.mcreasonbackground.Dia;
            _local10.txt1 = xatlib.createTextNoWrap(_local10, (_local8 + 10), (_local9 + 30), 310, 22, ((((this.bBan) || (this.bDunce))) ? xconst.ST(113) : xconst.ST(114)), 0, 0, 100, 0, 14, "left", 1);
            var _local11:* = xatlib.AddBackground(_local10, (_local8 + 10), (_local9 + 55), 310, 32);
            this.tf = xatlib.AddTextField(_local11, 0, this.TO, 310, 32, "", main.fmt);
            this.tf.type = TextFieldType.INPUT;
            this.tf.addEventListener(Event.CHANGE, xatlib.RemoveCR);
            if (((this.bBan) || (this.bDunce))){
                _local10.txt2 = xatlib.createTextNoWrap(_local10, (_local8 + 10), (_local9 + 95), 310, 22, xconst.ST(115), 0, 0, 100, 0, 14, "left", 1);
                _local12 = xatlib.AddBackground(_local10, (_local8 + 10), (_local9 + 120), 155, 32);
                this.tf2 = xatlib.AddTextField(_local12, 0, this.TO, 155, 32, "1", main.fmt);
                this.tf2.type = TextFieldType.INPUT;
                _local10.txt3 = xatlib.createTextNoWrap(_local10, (_local8 + 165), (_local9 + 120), 155, 32, ((xconst.ST(116) + "  ") + ((todo.w_owner) ? xconst.ST(117) : xconst.ST(118))), 0, 0, 100, 0, 14, "left", 1);
            } else {
                _local13 = xatlib.FindUser(todo.w_userno);
                if (todo.HasPower(_local13, 25)){
                    _local10.txt2 = xatlib.createTextNoWrap(_local10, (_local8 + 10), (_local9 + 95), 310, 22, xconst.ST(248), 0, 0, 100, 0, 14, "left", 1);
                    _local12 = xatlib.AddBackground(_local10, (_local8 + 10), (_local9 + 120), 310, 32);
                    this.tf2 = xatlib.AddTextField(_local12, 0, this.TO, 310, 32, "", main.fmt);
                    this.tf2.type = TextFieldType.INPUT;
                };
            };
            _local4 = 0;
            while (_local4 < _local2.length) {
                _local6 = _local2[_local4].split(";=");
                _local5 = ("b" + _local4);
                _local10[_local5] = new xBut(_local10, (_local8 + (((_local4 & 2)) ? 170 : 10)), (_local9 + 160), 150, 30, _local6[0], _local2[(_local4 + 1)]);
                _local10[_local5].But.UserNo = this.UserNo;
                if (_local6[1]){
                    _local10[_local5].But.Power = xatlib.xInt(_local6[1]);
                };
                if ((_local4 & 2)){
                    _local9 = (_local9 + 40);
                };
                _local4 = (_local4 + 2);
            };
        }
        function Delete(){
            main.closeDialog();
        }
        function ReasonBoot(_arg1:MouseEvent=undefined){
            if (this.tf.text.indexOf("#") != -1){
                this.tf.text = this.tf.text.substr(0, this.tf.text.indexOf("#"));
            };
            if (this.tf2.text == ""){
                return;
            };
            this.ReasonOK(_arg1);
        }
        function ReasonZap(_arg1:MouseEvent=undefined){
            if (this.tf.text.indexOf("#") == -1){
                this.tf.text = (this.tf.text + "#raspberry");
            };
            this.ReasonOK(_arg1);
        }
        function ReasonKickBan(_arg1:MouseEvent=undefined){
            if (((!(this.bBan)) && (!(this.bDunce)))){
                this.tf2.text = "";
            };
            this.ReasonOK(_arg1);
        }
        function ReasonOK(_arg1:MouseEvent=undefined){
            var _local2:*;
            if (((this.bBan) || (this.bDunce))){
                this.DoBan("g", _arg1.currentTarget.Power);
            } else {
                if (this.tf.text.length > 0){
                    if (this.tf2.text.length > 0){
                        this.tf.text = (this.tf.text + ("#" + this.tf2.text));
                    } else {
                        if (this.tf.text.indexOf("#") != -1){
                            _local2 = this.tf.text.split("#");
                            this.tf.text = (((_local2[0] + " #") + _local2[1]) + "#bump");
                        };
                    };
                    network.NetworkKickUser(this.UserNo, this.tf.text);
                } else {
                    todo.helpstr = xconst.ST(124);
                    todo.HelpUpdate = 0;
                };
            };
            this.CloseReason();
        }
        function ReasonGag(_arg1:MouseEvent=undefined){
            this.DoBan("gg");
            this.CloseReason();
        }
        function ReasonMute(_arg1:MouseEvent=undefined){
            this.DoBan("gm");
            this.CloseReason();
        }
        function ReasonDunce(_arg1:MouseEvent=undefined){
            this.DoBan("gd");
            this.CloseReason();
        }
        function ReasonNaughty(_arg1:MouseEvent=undefined){
            this.DoBan("gn");
            this.CloseReason();
        }
        function ReasonYellow(_arg1:MouseEvent=undefined){
            this.DoBan("gy");
            this.CloseReason();
        }
		function ReasonRed(_arg1:MouseEvent=undefined)
		{
			this.DoBan("gr");
			this.CloseReason();
		}
        function DoBan(_arg1, _arg2=undefined){
            var _local3:Number = 1;
            if (!isNaN(this.tf2.text)){
                _local3 = Math.abs(Number(this.tf2.text));
            };
            if (_local3 > 8760){
                _local3 = 0;
            };
            network.NetworkGagUser(_arg1, this.UserNo, true, xatlib.xInt((_local3 * 3600)), this.tf.text, _arg2);
        }
        function CloseReason(_arg1:MouseEvent=undefined){
            this.Delete();
        }

    }
}//package 
