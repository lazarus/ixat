package {
    import flash.xml.*;
    import flash.events.*;
    import com.adobe.serialization.json.*;
    import flash.display.*;
    import flash.text.*;
    import flash.net.*;
    import flash.utils.*;
    import flash.filters.*;
    import flash.system.*;

    public class xatlib {

        public static const c_tl:Number = (1 << 8);
        public static const c_tr:Number = (2 << 8);
        public static const c_bl:Number = (4 << 8);
        public static const c_br:Number = (8 << 8);
        public static const c_nolt:Number = (16 << 8);
        public static const c_nolb:Number = (32 << 8);
        public static const c_inv:Number = (64 << 8);
        public static const c_solid:Number = (128 << 8);
        public static const c_NoCol:Number = (128 << 9);
        public static const c_Mask:Number = (128 << 10);
        public static const c_Clip:Number = (128 << 11);
        public static const b_mouseChild = (128 << 12);

        public static var FastFind1 = new Object();
        public static var r1:RegExp = /[\x00-\x08\x10\x0B\x0C\x0E-\x19\x7F]|(?<=^|[\x00-\x7F])[\x80-\xBF]+|([\xC0\xC1]|[\xF0-\xFF])[\x80-\xBF]*|[\xC2-\xDF]((?![\x80-\xBF])|[\x80-\xBF]{2,})|[\xE0-\xEF](([\x80-\xBF](?![\x80-\xBF]))|(?![\x80-\xBF]{2})|[\x80-\xBF]{3,})/;
        public static var r2:RegExp = /\xE0[\x80-\x9F][\x80-\xBF]|\xED[\xA0-\xBF][\x80-\xBF]/;

        public static function getURL(_arg1, _arg2){
            var _local3:URLRequest = new URLRequest(_arg1);
            try {
                navigateToURL(_local3);
            } catch(e:Error) {
            };
        }
        public static function XMLOrder(_arg1:XMLDocument, _arg2:Array):String{
            var _local4:*;
            var _local5:*;
            var _local3 = (("<" + _arg1.firstChild.nodeName.toString()) + " ");
            for (_local4 in _arg2) {
                if (_arg1.firstChild.attributes[_arg2[_local4]] != undefined){
                    _local5 = _arg1.firstChild.attributes[_arg2[_local4]].toString();
                    if (_arg2[_local4] != "sn"){
                        _local5 = searchreplace("&", "&amp;", _local5);
                        _local5 = searchreplace("'", "&apos;", _local5);
                        _local5 = searchreplace("<", "&lt;", _local5);
                        _local5 = searchreplace(">", "&gt;", _local5);
                    };
                    _local5 = searchreplace("\"", "&quot;", _local5);
                    _local3 = (_local3 + (((_arg2[_local4] + "=\"") + _local5) + "\" "));
                };
            };
            _local3 = (_local3 + "/>");
            return (_local3);
        }
        public static function GeneralMessage(_arg1:String="", _arg2:String="", _arg3=1){
            var _local4:*;
            if (main.box_layer.GeneralMessageH){
                main.box_layer.GeneralMessageH.Delete();
            };
            main.box_layer.GeneralMessageH = undefined;
            if (((!((_arg1.length == 0))) || (!((_arg2.length == 0))))){
                _local4 = undefined;
                main.box_layer.GeneralMessageH = new xDialog(main.box_layer, _local4, _local4, _local4, _local4, _arg1, _arg2, _arg3);
            };
        }
        public static function UnfairPopup(_arg1, _arg2){
            UnfairPopupClose();
            var _local3:* = (main.box_layer.mcPopup = new xDialog(main.box_layer, int(((20 * todo.StageWidth) / 640)), int((((140 - 14) * todo.StageHeight) / 480)), int(((600 * todo.StageWidth) / 640)), int((((((192 + 32) + 24) + 14) * todo.StageHeight) / 480)), _arg1, _arg2, 0, UnfairPopupClose));
            var _local4:* = _local3.DiaBack.width;
            var _local5:* = _local3.DiaBack.height;
            var _local6:* = _local3.DiaBack.x;
            var _local7:* = _local3.DiaBack.y;
            var _local8:* = xatlib.NY(32);
            var _local9:* = (((_local7 + _local5) - _local8) - 22);
            var _local10:* = ((_local4 / 3) - 16);
            var _local11:* = new xBut(_local3, (_local6 + 8), _local9, _local10, _local8, xconst.ST(101), xatlib.mccopyurl_onRelease2);
            var _local12:* = new xBut(_local3, (((_local6 + (_local4 / 2)) - (_local4 / 6)) + 8), _local9, _local10, _local8, xconst.ST(102), UnfairPopupClose);
            var _local13:* = new xBut(_local3, (((_local6 + _local4) - (_local4 / 3)) + 8), _local9, _local10, _local8, xconst.ST(103), UnfairFindAnotherGroup);
        }
        public static function UnfairFindAnotherGroup(_arg1:MouseEvent=undefined){
            UnfairPopupClose();
            var _local2:* = (todo.usedomain + "/groups");
            xatlib.UrlPopup(xconst.ST(8), _local2);
        }
        public static function UnfairPopupClose(_arg1:MouseEvent=undefined){
            if (((!(main.box_layer.mcPopup)) || (!(main.box_layer.mcPopup.sParent)))){
                return;
            };
            main.box_layer.mcPopup.Delete();
            delete main.box_layer.mcPopup;
            main.box_layer.mcPopup = null;
        }
        public static function mccopyurl_onRelease2(_arg1:MouseEvent=undefined){
            var _local2:URLVariables = new URLVariables();
            _local2.d = network.UnfairMessage;
            _local2.i = network.UnfairFile;
            xatlib.LoadVariables("http://web.xat.com/report/data.php", undefined, _local2, 1);
            UnfairPopupClose();
            var _local3:* = ((("http://web.xat.com/report/report.php?i=" + network.UnfairFile) + "&g=") + network.UnfairGroupName);
            getURL(_local3, "_blank");
            UrlPopup(xconst.ST(8), _local3);
        }
        public static function UrlPopup(_arg1:String, _arg2:String, _arg3:String=undefined){
            var _local16:*;
            if (!todo.config["useconfirmweblink"]){
                xatlib.getURL(_arg2, "_blank");
            };
            UnfairPopupClose();
            var _local4:* = undefined;
            if (!_arg3){
                _arg3 = "";
            } else {
                _arg3 = (_arg3 + "\n");
            };
            var _local5:* = (main.box_layer.mcPopup = new xDialog(main.box_layer, _local4, _local4, _local4, _local4, _arg1, (_arg3 + _arg2), 0, UnfairPopupClose));
            var _local6:* = _local5.DiaBack.width;
            var _local7:* = _local5.DiaBack.height;
            var _local8:* = _local5.DiaBack.x;
            var _local9:* = _local5.DiaBack.y;
            var _local10:* = 8;
            var _local11:* = int((_local6 / ((_local10 * 2) + 3)));
            var _local12:* = int(((_local6 * _local10) / ((_local10 * 2) + 3)));
            var _local13:* = _local12;
            var _local14:* = 22;
            var _local15:* = new xBut(_local5, (((_local8 + _local6) - _local11) - _local12), (((_local9 + _local7) - _local14) - 20), _local12, _local14, xconst.ST(102), UnfairPopupClose);
            if (_arg2.length > 0){
                _local16 = new xBut(_local5, (_local8 + _local11), (((_local9 + _local7) - _local14) - 20), _local13, _local14, ((todo.config["useconfirmweblink"]) ? "Goto Link" : xconst.ST(104)), mccopyurl_onRelease3);
                _local16.HomePage = _arg2;
            };
        }
        public static function mccopyurl_onRelease3(_arg1:MouseEvent){
            UnfairPopupClose();
            if (todo.config["useconfirmweblink"]){
                xatlib.getURL(_arg1.currentTarget.HomePage, "_blank");
            } else {
                System.setClipboard(_arg1.currentTarget.HomePage);
                GeneralMessage(xconst.ST(105), xconst.ST(106));
            };
        }
        public static function ButtonCurve2(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number=0, _arg5:Number=1, _arg6:Number=0xFFFFFF, _arg7:Number=1, _arg8:Number=0xFFFFFF, _arg9:Number=1):xSprite{
			if(xatlib.noCurve)
			{
				_arg1 = 0;
			}
			
            var _local10:* = new xSprite();
            var _local11:* = _arg1;
            if (_arg2 < (_local11 * 2)){
                _local11 = int((_arg2 / 2));
            };
            if (_arg3 < (_local11 * 2)){
                _local11 = int((_arg3 / 2));
            };
            var _local12:* = _local11;
            var _local13:* = _local11;
            var _local14:* = _local11;
            var _local15:* = _local11;
            if ((_arg4 & c_tl)){
                _local15 = 0;
            };
            if ((_arg4 & c_tr)){
                _local12 = 0;
            };
            if ((_arg4 & c_bl)){
                _local14 = 0;
            };
            if ((_arg4 & c_br)){
                _local13 = 0;
            };
            var _local16:uint = 100;
            _local10.graphics.beginFill(_arg8, _arg9);
            _local10.graphics.lineStyle(_arg5, _arg6, _arg7, true, "none", "none", "round", 1);
            if ((_arg4 & c_inv)){
                _local10.graphics.moveTo(todo.tpw, 0);
            } else {
                _local10.graphics.moveTo((_local15 + 0), 0);
            };
            if ((_arg4 & c_nolt)){
                _local10.graphics.lineStyle(0, 0, 0);
            } else {
                _local10.graphics.lineStyle(_arg5, _arg6, _arg7, true, "none", "none", "round", 1);
            };
            _local10.graphics.lineTo((_arg2 - _local12), 0);
            if (_local12 > 0){
                _local10.graphics.curveTo(_arg2, 0, _arg2, _local12);
            };
            _local10.graphics.lineStyle(_arg5, _arg6, _arg7, true, "none", "none", "round", 1);
            _local10.graphics.lineTo(_arg2, ((_arg3 - _local13) - 2));
            if ((_arg4 & c_nolb)){
                _local10.graphics.lineStyle(0, 0, 0);
            } else {
                _local10.graphics.lineStyle(_arg5, _arg6, _arg7, true, "none", "none", "round", 1);
            };
            if (_local13 > 0){
                _local10.graphics.curveTo(_arg2, _arg3, ((_arg2 - _local13) - 2), _arg3);
            };
            _local10.graphics.lineTo(_local14, _arg3);
            _local10.graphics.lineStyle(_arg5, _arg6, _arg7, true, "none", "none", "round", 1);
            _local10.graphics.curveTo(0, _arg3, 0, (_arg3 - _local14));
            _local10.graphics.lineStyle(_arg5, _arg6, _arg7, true, "none", "none", "round", 1);
            _local10.graphics.lineTo(0, _local15);
            _local10.graphics.curveTo(0, 0, _local15, 0);
            if ((_arg4 & c_inv)){
                _local10.graphics.lineTo(-(todo.tpw), 0);
                _local10.graphics.lineTo(-(todo.tpw), 50);
                _local10.graphics.lineTo(todo.tpw, 50);
                _local10.graphics.lineTo(todo.tpw, 0);
            };
            _local10.graphics.endFill();
            return (_local10);
        }
        public static function Blend(_arg1, _arg2, _arg3, _arg4, _arg5){
            if (_arg1 <= _arg2){
                return (_arg4);
            };
            if (_arg1 >= _arg3){
                return (_arg5);
            };
            var _local6:* = int(((((_arg1 - _arg2) / (_arg3 - _arg2)) * (_arg5 - _arg4)) + _arg4));
            return (_local6);
        }
        public static function AddBackground(_arg1, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6=0):xSprite{
            var _local7:* = todo.ButCol;
            var _local8:* = 0.4;
            if ((_arg6 & c_NoCol)){
                _local7 = 0xFFFFFF;
            };
            if ((_arg6 & c_solid)){
                _local7 = 0xCCCCCC;
                _local8 = 1;
            };
            var _local9:* = 0xFFFFFF;
            var _local10:* = 0.4;
            var _local11:* = 1;
            if ((_arg6 & (128 << 10))){
                _local9 = 0x808080;
                _local10 = 1;
                _local11 = undefined;
            };
            var _local12:* = ButtonCurve2(8, _arg4, _arg5, _arg6, _local11, _local7, _local8, _local9, _local10);
            _local12.x = _arg2;
            _local12.y = _arg3;
            _arg1.addChild(_local12);
            return (_local12);
        }
        public static function createTextNoWrap(_arg1, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:String, _arg7:Number, _arg8:Number, _arg9:Number, _arg10:Number, _arg11:Number, _arg12:String, _arg13:Number){
            var _local14:*;
            var _local15:*;
            var _local17:Number;
            var _local18:Number;
            var _local19:*;
            _arg2 = int(_arg2);
            _arg3 = int(_arg3);
            _arg4 = int(_arg4);
            _arg5 = int(_arg5);
            _local15 = new TextFormat();
            _local15.align = _arg12;
            _local15.bold = true;
            _local15.color = _arg7;
            _local15.font = "_sans";
            _local15.size = _arg11;
            var _local16:* = new TextField();
            _local16.x = (_arg2 + 1);
            _local16.y = (1 + _arg3);
            _local16.width = (_arg4 - (1 * 2));
            _local16.height = (_arg5 - (1 * 2));
            _local16.autoSize = _arg12;
            _local16.selectable = true;
            _local16.defaultTextFormat = _local15;
            _local16.text = _arg6;
            _arg1.addChild(_local16);
            if ((_arg13 & 2)){
                _local16.multiline = true;
                _local16.wordWrap = true;
            };
            if (_local16.width > (_arg4 - (1 * 2))){
                _local17 = ((_local15.size * ((_arg4 - (1 * 2)) / _local16.width)) - 0.5);
                _local18 = 4;
                _local19 = ((_local15.size - _local17) / _local18);
                if (_local19 < 1){
                    _local19 = 1;
                };
                while ((((_local16.width > (_arg4 - (1 * 2)))) && ((_local15.size > 1)))) {
                    _local15.size = (_local15.size - _local19);
                    _local16.defaultTextFormat = _local15;
                    _local16.text = _arg6;
                };
            };
            _local16.y = ((_arg3 + int(((_arg5 - _local16.height) / 2))) - 1);
            return (_local16);
        }
        public static function CleanText(_arg_1:*, _arg_2:*=undefined):String{
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:String;
            _arg_1 = String(_arg_1);
            var _local_3 = "";
            _local_4 = 0;
            while (_local_4 < _arg_1.length) {
                _local_5 = _arg_1.charCodeAt(_local_4);
                _local_6 = _arg_1.charAt(_local_4);
                if (_local_5 >= 32){
                    if (_local_6 != "<"){
                        if (_local_6 != ">"){
                            if (_local_6 != '"'){
                                if (_local_6 != "'"){
                                    if (_local_6 != ","){
                                        if (_local_6 == " "){
                                            if (_arg_2 != 1){
                                                _local_3 = (_local_3 + "_");
                                            };
                                        } else {
                                            _local_3 = (_local_3 + _local_6);
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
                _local_4++;
            };
            return (_local_3);
        }
        public static function GetStatus(_arg_1:*){
            if (!_arg_1){
                return (undefined);
            };
            _arg_1 = _arg_1.split("##")[1];
            if (!_arg_1){
                return (undefined);
            };
            _arg_1 = searchreplace("_", " ", _arg_1);
            while (((_arg_1) && ((_arg_1.charAt(0) == " ")))) {
                _arg_1 = _arg_1.substr(1);
            };
            if (!_arg_1){
                return (undefined);
            };
            return (_arg_1);
        }
        public static function NameNoXat(_arg_1:*, _arg_2:*=undefined){
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_8:*;
            var _local_9:*;
            var _local_12:*;
            var _local_13:Array;
            var _local_14:String;
            var _local_15:*;
            var _local_16:*;
            if (_arg_1 == null){
                return (null);
            };
            // TypeError: Error #1006: value is not a function.
            // at xatlib$/NameNoXat()
            _arg_1 = _arg_1.split("##")[0];
            if (_arg_1.indexOf("&lt;") != -1){
                return ("nope");
            };
            if (_arg_1.indexOf("<") != -1){
                return ("nope");
            };
            var _local_6:* = _arg_1.length;
            _local_3 = 0;
            for (;_local_3 < _local_6;_local_3++) {
                _local_5 = _local_4;
                _local_4 = _arg_1.charAt(_local_3);
                switch (_local_4){
                    case "­":
                    case " ":
                    case "_":
                        continue;
                };
                if (!(((_local_3 > 0)) && ((_local_4 == _local_5)))) break;
            };
            if (_local_3 > 0){
                _arg_1 = _arg_1.substr(_local_3);
            };
            var _local_7:Array = _arg_1.split("");
            _local_6 = _local_7.length;
            var _local_10:Boolean = true;
            var _local_11:* = false;
            _arg_1 = "";
            _local_3 = 0;
            while (_local_3 < _local_6) {
                _local_5 = _local_7[_local_3];
                _local_4 = _local_5.charCodeAt();
                if ((((_local_4 >= 28)) && ((_local_4 <= 31)))){
                    _local_5 = "_";
                } else {
                    if (_local_5 == "("){
                        _local_8 = true;
                    } else {
                        if (_local_5 == ")"){
                            _local_8 = false;
                        } else {
                            if ((((_local_4 >= 127)) && ((_local_4 <= 159)))){
                                _local_5 = "_";
                            } else {
                                if ((((_local_5 == " ")) || (((!(_local_8)) && ((_local_5 == "#")))))){
                                    _local_5 = "_";
                                };
                            };
                        };
                    };
                };
                if (_local_4 > 0xFF){
                    if(_local_5 == "Χ" || _local_5 == "Х") {
                        _local_5 = "X";
                    } else if(_local_5 == "Α" || _local_5 == "А")   {
                        _local_5 = "A";
                    } else if(_local_5 == "Τ" || _local_5 == "Т")   {
                        _local_5 = "T";
                    } else if(_local_5 == "х")   {
                        _local_5 = "x";
                    } else if(_local_5 == "а")   {
                        _local_5 = "a";
                    } else if(_local_5 == "α")   {
                        _local_5 = "a";
                    } else if(_local_5 == "Μ" || _local_5 == "М")   {
                        _local_5 = "M";
                    } else if(_local_5 == "і")   {
                        _local_5 = "i";
                    } else if(_local_5 == "Ν")   {
                        _local_5 = "N";
                    } else if(_local_5 == "ԁ")   {
                        _local_5 = "d";
                    } else if(_local_5 == "m")   {
                        _local_5 = "m";
                    } else if(_local_5 == "і")   {
                        _local_5 = "i";
                    } else if(_local_5 == "Η" || _local_5 == "Н")   {
                        _local_5 = "H";
                    } else if(_local_5 == "Ε" || _local_5 == "Е")   {
                        _local_5 == "E";
                    } else if(_local_5 == "һ")   {
                        _local_5 = "h";
                    } else if(_local_5 == "е")   {
                        _local_5 = "e";
                    } else if(_local_5 == "Ɩ" || _local_5 == "Ι" || _local_5 == "І" || _local_5 == "Ӏ" || _local_5 == "ӏ" || _local_5 == "ｌ")   {
                        _local_5 = "I";
                    } else if(_local_5 == "р")   {
                        _local_5 = "p";
                    } else if(_local_5 == " " || _local_5 == "卐" || _local_5 == "­")   {
                        _local_5 = "_";
                    }
                    switch (_local_5){
                        case " ":
                        case " ":
                        case " ":
                        case " ":
                        case " ":
                        case " ":
                        case " ":
                        case " ":
                        case " ":
                        case " ":
                        case " ":
                        case "​":
                        case "‌":
                        case "‍":
                        case "‎":
                        case "‏":
                        case " ":
                        case " ":
                        case "‪":
                        case "‫":
                        case "‬":
                        case "‭":
                        case "‮":
                        case " ":
                        case " ":
                        case "⁠":
                        case "⁡":
                        case "⁢":
                        case "⁣":
                        case "⁤":
                        case "u2066":
                        case "u2067":
                        case "u2068":
                        case "u2069":
                        case "⁪":
                        case "⁫":
                        case "⁬":
                        case "⁭":
                        case "⁮":
                        case "⁯":
                            _local_5 = "_";
                    };
                };
                _local_7[_local_3] = _local_5;
                _local_5 = _local_5.toLowerCase();
                if ((((_local_5 == "a")) || ((_local_5 == "h")))){
                    _local_9 = true;
                };
                _local_3++;
            };
            if (_local_9){
                _local_13 = new Array();
                _local_14 = "";
                _local_3 = 0;
                while (_local_3 < _local_6) {
                    _local_14 = (_local_14 + _local_7[_local_3]);
                    if (_local_7[_local_3].charCodeAt() < 0x0100){
                        _local_13.push(_local_14);
                        _local_14 = "";
                    };
                    _local_3++;
                };
                _local_13.push(_local_14);
                _local_3 = 0;
                for (;_local_3 < _local_13.length;_local_3++) {
                    _local_15 = new Array(5);
                    _local_16 = 0;
                    while (_local_16 < 5) {
                        if ((_local_3 + _local_16) < _local_13.length){
                            _local_15[_local_16] = _local_13[(_local_3 + _local_16)].charAt((_local_13[(_local_3 + _local_16)].length - 1));
                        };
                        _local_16++;
                    };
                    if (_local_3 < (_local_13.length - 2)){
                        if ((((((((_local_15[0] == "x")) || ((_local_15[0] == "X")))) && ((((_local_15[1] == "a")) || ((_local_15[1] == "A")))))) && ((((_local_15[2] == "t")) || ((_local_15[2] == "T")))))){
                            _local_12 = 0;
                            while (_local_12 < 3) {
                                _arg_1 = (_arg_1 + (_local_13[(_local_3 + _local_12)].substr(0, (_local_13[(_local_3 + _local_12)].length - 1)) + "Q"));
                                _local_12++;
                            };
                            _local_3 = (_local_3 + 2);
                            continue;
                        };
                    };
                    if (_local_3 < (_local_13.length - 3)){
                        if ((((((((((_local_15[0] == "h")) || ((_local_15[0] == "H")))) && ((((_local_15[1] == "e")) || ((_local_15[1] == "E")))))) && ((((((_local_15[2] == "l")) || ((_local_15[2] == "L")))) || ((_local_15[2] == "I")))))) && ((((_local_15[3] == "p")) || ((_local_15[3] == "P")))))){
                            _local_12 = 0;
                            while (_local_12 < 4) {
                                _arg_1 = (_arg_1 + (_local_13[(_local_3 + _local_12)].substr(0, (_local_13[(_local_3 + _local_12)].length - 1)) + "Q"));
                                _local_12++;
                            };
                            _local_3 = (_local_3 + 3);
                            continue;
                        };
                    };
                    if (_local_3 < (_local_13.length - 4)){
                        if ((((((((((((_local_15[0] == "a")) || ((_local_15[0] == "A")))) && ((((_local_15[1] == "d")) || ((_local_15[1] == "D")))))) && ((((_local_15[2] == "m")) || ((_local_15[2] == "M")))))) && ((((((_local_15[3] == "i")) || ((_local_15[3] == "I")))) || ((_local_15[3] == "l")))))) && ((((_local_15[4] == "n")) || ((_local_15[4] == "N")))))){
                            _local_12 = 0;
                            while (_local_12 < 5) {
                                _arg_1 = (_arg_1 + (_local_13[(_local_3 + _local_12)].substr(0, (_local_13[(_local_3 + _local_12)].length - 1)) + "Q"));
                                _local_12++;
                            };
                            _local_3 = (_local_3 + 4);
                            continue;
                        };
                    };
                    _arg_1 = (_arg_1 + _local_13[_local_3]);
                };
            } else {
                _arg_1 = _local_7.join("");
            };
            while (_arg_1.substr(0, 1) == "_") {
                _arg_1 = _arg_1.substr(1);
            };
            if (_arg_2 == undefined){
                if (_arg_1.charAt(0) == "("){
                    _arg_1 = ("  " + _arg_1);
                };
                _arg_1 = PreProcSmilie(_arg_1);
            };
            return (_arg_1);
        }
        public static function CleanTextNoXat(_arg1):String{
            return (CleanText(NameNoXat(_arg1, 1)));
        }
        public static function CleanMessage(_arg1:String):String{
            var _local3:Number;
            var _local4:Number;
            var _local5:String;
            var _local2 = "";
            _local3 = 0;
            while (_local3 < _arg1.length) {
                _local4 = _arg1.charCodeAt(_local3);
                _local5 = _arg1.charAt(_local3);
                if (_local5 == "\t"){
                    _local2 = (_local2 + " ");
                } else {
                    if (_local4 < 32){
                    } else {
                        _local2 = (_local2 + _local5);
                    };
                };
                _local3++;
            };
            return (_local2);
        }
        public static function CleanCommas(_arg1:String):String{
            var _local3:Number;
            var _local4:Number;
            var _local5:String;
            var _local2 = "";
            _local3 = 0;
            while (_local3 < _arg1.length) {
                _local4 = _arg1.charCodeAt(_local3);
                _local5 = _arg1.charAt(_local3);
                if (_local5 == ","){
                    _local2 = (_local2 + " ");
                } else {
                    if (_local4 < 32){
                    } else {
                        _local2 = (_local2 + _local5);
                    };
                };
                _local3++;
            };
            return (_local2);
        }
        public static function TimeStamp():String{
            var _local1:Date = new Date();
            var _local2:Number = Number(_local1.getTime());
            return (("&t=" + _local2));
        }
        public static function NX(_arg1:Number):Number{
            return (int(((_arg1 * todo.StageWidth) / 640)));
        }
        public static function NY(_arg1:Number):Number{
            return (int(((_arg1 * todo.StageHeight) / 480)));
        }
        public static function SX(_arg1=1):Number{
            var _local2:* = (todo.StageWidth / 640);
            if (_arg1){
                _local2 = (_local2 * _arg1);
            };
            return (_local2);
        }
        public static function SY(_arg1=1):Number{
            var _local2:* = (todo.StageHeight / 480);
            if (_arg1){
                _local2 = (_local2 * _arg1);
            };
            return (_local2);
        }
        public static function UrlAv(_arg1):String{
            var _local2:Number = xInt(_arg1);
			if(_local2 > 0 && _local2 < 1760)
			{
				return todo.chatdomain + "av/" + _arg1 + ".png";
            }
            return (String(_arg1));
        }
        public static function RandAv(_arg1=undefined){
            var _local2:Number = (1 + Math.floor((Math.random() * 1759)));
            if (_arg1 == undefined){
                return (_local2);
            };
            return (UrlAv(_local2));
        }
        public static function xRand(_arg1, _arg2){
            return ((xInt(Math.floor((Math.random() * ((_arg2 - _arg1) + 1)))) + _arg1));
        }
        public static function ParseAv(_arg1):String{
            if (_arg1.substr(0, 4) == "http"){
                return (_arg1);
            };
            var _local2:Number = xInt(_arg1);
            if ((((_local2 > 0)) && ((_local2 <= 1758)))){
                return (UrlAv(_local2));
            };
            return ("_");
        }
        public static function CleanAv(_arg1){
            var _local6:Number;
            if (_arg1 == undefined){
                return;
            };
            var _local2:Number = xInt(_arg1);
			/*
            if ((((_local2 > 0)) && ((_local2 <= 1758)))){
                return (_local2);
            };
			*/
            if (_local2 < 0){
                return ("");
            };
            var _local3:String = _arg1.toLowerCase();
            var _local4 = "/web_gear/av/";
            if (_local3.indexOf(".swf") != -1){
                return ("");
            };
            var _local5:* = _local3.indexOf(_local4);
            if (_local5 >= 0){
                _local6 = parseInt(_local3.substr((_local5 + _local4.length)));
                if (_local6 > 0){
                    return (_local6);
                };
            };
            return (_arg1);
        }
        public static function IsDefaultAvatar(_arg1){
            return ((CleanAv(_arg1) > 0));
        }
        public static function xInt(_arg1):Number{
            var _local2:Number = parseInt(String(_arg1));
            if (isNaN(_local2)){
                return (0);
            };
            return (_local2);
        }
        public static function FindUser(_arg1:Number):Number{
            var _local2:* = FastFind1[_arg1];
            if (((((!((_local2 == undefined))) && (!((todo.Users[_local2] == undefined))))) && ((todo.Users[_local2].u == _arg1)))){
                return (_local2);
            };
            var _local3:* = todo.Users.length;
            _local2 = 0;
            while (_local2 < _local3) {
                if (todo.Users[_local2].u == _arg1){
                    FastFind1[_arg1] = _local2;
                    return (_local2);
                };
                _local2++;
            };
            return (-1);
        }
		
        public static function FindUserByReg(_arg_1:String):Number{
			if(String(Number(_arg_1)) == _arg_1) { // Thanks to oj <3
				return FindUser(xInt(_arg_1));
			}
			var _local_2 = 0;
            var _local_3:* = todo.Users.length;
            while (_local_2 < _local_3) {
                if (todo.Users[_local_2].registered) {
					if(todo.Users[_local_2].registered.toLowerCase() == _arg_1){
						return (_local_2);
					}
                };
                _local_2++;
            };
            return (-1);
        }
		public static function GetUserStatus(_arg_1:Number):String{
            var _local_3:*;
            var _local_4:*;
            if (_arg_1 == -1){
                return ("");
            };
            var _local_2 = "";
            var _local_5:* = todo.Users[_arg_1];
            _local_3 = (_local_5.online == true);
            if (((!(_local_3)) && (((!((main.utabsmc.tabs[0].Main == true))) || (main.ctabsmc.TabIsPrivate()))))){
                _local_3 = (_local_5.onsuper == true);
                if (_local_5.available){
                    _local_4 = true;
                };
            };
            if (_local_5.u == todo.w_userno){
                _local_2 = (xconst.ST(107) + " ");
            };
            if (_local_3){
                if (_local_5.OnXat){
                    _local_2 = (_local_2 + xconst.ST(108));
                } else {
                    if (_local_4){
                        _local_2 = (_local_2 + xconst.ST(275));
                    } else {
                        _local_2 = (_local_2 + xconst.ST(109));
                    };
                };
            } else {
                _local_2 = (_local_2 + xconst.ST(110));
            };
            if (main.utabsmc.tabs[0].Main == true){
                if (!_local_5.Stealth){
	                if (_local_5.mainowner == true){
	                    _local_2 = (_local_2 + (" " + xconst.ST(134)));
	                } else if (_local_5.owner == true){
	                    _local_2 = (_local_2 + (" " + xconst.ST(24)));
	                } else if (_local_5.moderator == true){
	                    _local_2 = (_local_2 + (" " + xconst.ST(23)));
	                } else if (_local_5.member == true){
	                    _local_2 = (_local_2 + (" " + xconst.ST(22)));
	                };
                };
            };
            if ((_local_5.aFlags & (1 << 21))){
                _local_2 = (_local_2 + (" " + xconst.ST(251)));
            };
            if ((_local_5.volunteer)){
                _local_2 = (_local_2 + (" volunteer"));
            };
            if ((_local_5.flag0 & 0x0200)){
                _local_2 = (_local_2 + (" " + xconst.ST(195)));
            };
			switch ((_local_5.friend & 11)){
				case 3:
					_local_2 = (_local_2 + (" " + xconst.ST(262)));
					break;
				case 9:
					if (todo.goodfriend){
						_local_2 = (_local_2 + (" " + xconst.ST(293)));
						if ((_local_5.friend & 16)){
							_local_2 = (_local_2 + "ð ");
						};
						break;
					};
				case 1:
					_local_2 = (_local_2 + (" " + xconst.ST(111)));
					break;
			};
            if ((((_local_5.banned == true)) && ((main.utabsmc.tabs[0].Main == true)))){
                if (_local_5.w){
                    _local_2 = (_local_2 + (" " + xconst.Puzzle[_local_5.w]));
                };
                if ((_local_5.flag0 & 0x1000)){
                    _local_2 = (_local_2 + (" " + xconst.ST(236)));
                } else {
                    _local_2 = (_local_2 + (" " + xconst.ST(25)));
                };
            } else {
                if (_local_5.ignored == true){
                    _local_2 = (_local_2 + (" " + xconst.ST(112)));
                } else {
                    if (_local_5.gagged == true){
                        _local_2 = (_local_2 + (" " + xconst.ST(188)));
                    };
                };
            };
            if (((_local_5.VIP) && (!(todo.HasPower(_arg_1, 2))))){
                _local_2 = (_local_2 + (" " + xconst.ST(158)));
            } else {
                if (((_local_5.registered) && (!(todo.HasPower(_arg_1, 9))))){
                    _local_2 = (_local_2 + (" " + xconst.ST(159)));
                };
            };
            if (_local_5.Bride){
                if ((_local_5.aFlags & 1)){
                    _local_2 = (_local_2 + (" " + xconst.ST(160)));
                } else {
                    _local_2 = (_local_2 + (" " + xconst.ST(161)));
                };
            };
            return (_local_2);
        }

        public static function GetNameNumber(_arg1:Number){
            var _local2:* = _arg1.toString();
            var _local3:* = FindUser(_arg1);
            if (_local3 < 0){
                return ("NotFound");
            };
			if (_local2.substr(-12, 12) == "000000000000"){
                _local2 = (_local2.substr(0, (_local2.length - 12)) + "T");
            }else if (_local2.substr(-9, 9) == "000000000"){
                _local2 = (_local2.substr(0, (_local2.length - 9)) + "B");
            }else if (_local2.substr(-6, 6) == "000000"){
                _local2 = (_local2.substr(0, (_local2.length - 6)) + "M");
            };
            _local2 = ((todo.Users[_local3].registered)!=undefined) ? (((todo.Users[_local3].registered + " (") + _local2) + ")") : _arg1.toString();
            if ((((_arg1 >= (0x77359400 - 100000))) && ((_arg1 < 0x77359400)))){
                _local2 = " ";
            };
            return (FixLI(_local2));
        }
        public static function GetUsername(_arg1:Number, _arg2=undefined, _arg3=undefined, _arg4=undefined):String{
            var _local7:*;
            var _local5:* = "";
            var _local6:* = FindUser(_arg1);
            if (_local6 != -1){
                if (_arg2){
                    if (todo.Users[_local6].registered){
                        _local5 = todo.Users[_local6].registered;
                    };
                } else {
                    _local5 = todo.Users[_local6].n;
                };
            };
            if (_arg3){
                if (((!((_local6 == -1))) && (!((todo.Users[_local6].s == undefined))))){
                    _local7 = todo.Users[_local6].s.split("#");
                    _local5 = (_local5 + ("\n" + _local7[0]));
                };
                if (_arg1 > 5){
                    _local5 = (_local5 + "\n(NOT ixat staff!)");
                } else {
                    _local5 = (_local5 + "\n(ixat staff)");
                };
                if (_arg4 != undefined){
                    _local5 = (_local5 + " [");
                    _local6 = FindUser(_arg4);
                    if (todo.Users[_local6].registered){
                        _local5 = (_local5 + todo.Users[_local6].registered);
                    } else {
                        _local5 = (_local5 + _arg4);
                    };
                    _local5 = (_local5 + "]");
                };
            };
            return (_local5);
        }
        public static function StripSmilies(_arg1){
            var _local3:*;
            var _local5:*;
            if (_arg1 == null){
                return;
            };
            var _local2:* = "";
            var _local4:* = false;
            _local3 = 0;
            while (_local3 < _arg1.length) {
                _local5 = _arg1.charAt(_local3);
                if (((!(_local4)) && (!((_local5 == "("))))){
                    _local2 = (_local2 + _local5);
                } else if (_local5 == "("){
                    _local4 = true;
                } else if (_local5 == ")"){
                    _local4 = false;
                };
                _local3++;
            };
            if (_local2.length == 0){
                return (_arg1);
            };
            return (_local2);
        }
        public static function IsDefaultName(_arg1:String){
            var _local5:*;
            var _local2:Boolean;
            var _local3:Boolean;
            var _local4:* = 0;
            while (_local4 < xconst.name1.length) {
                if (_arg1.indexOf(xconst.name1[_local4]) != -1){
                    _local2 = true;
                    break;
                };
                _local4++;
            };
            if (_local2){
                _local5 = 0;
                while (_local5 < xconst.name2.length) {
                    if (_arg1.indexOf(xconst.name2[_local5]) != -1){
                        _local3 = true;
                        break;
                    };
                    _local5++;
                };
            };
            if (((_local2) && (_local3))){
                return (true);
            };
            return (false);
        }
        public static function GetDefaultName(_arg1:Number){
            var _local2:* = ((_arg1 ^ 0x5555) % (42 * 24));
            var _local3:* = (_local2 % 42);
            _local2 = int((_local2 / 42));
            return ((xconst.name1[_local3] + xconst.name2[_local2]));
        }
        public static function GetDefaultAvatar(_arg1:Number){
            return ((((_arg1 ^ 0x5555) % 1758) + 1));
        }
        public static function PurgeMessageFromUser(_arg1:Number){
            var _local2:* = todo.Message.length;
            var _local3:* = 0;
            while (_local3 < _local2) {
                if (todo.Message[_local3].u == _arg1){
                    xmessage.DeleteOneMessageMc(_local3);
                };
                _local3++;
            };
        }
        public static function CountLinks(_arg1:String, _arg2:Number=0){
            var _local5:*;
            var _local6:*;
            if (_arg1 == null){
                return (null);
            };
            var _local3:Array = new Array();
            var _local4:* = 0;
            _local3 = _arg1.split(" ");
            _local5 = 0;
            while (_local5 < _local3.length) {
                _local6 = WordIsLink(_local3[_local5]);
                if (_local6){
                    _local4++;
                    if (_arg2){
                        return (_local6);
                    };
                };
                _local5++;
            };
            return (_local4);
        }
        public static function WordIsLink(_arg_1:String):String{
            var _local_6:int;
            if (_arg_1.indexOf(".") < 0){
                return (undefined);
            };
            var _local_2:String = _arg_1.toLowerCase();
            if (_local_2.indexOf("http") >= 0){
                return (_arg_1);
            };
            var _local_3:Boolean;
            var _local_4:Number = 2;
            if (_local_2.indexOf("www.") >= 0){
                _local_3 = true;
            };
            var _local_5:Number = _local_2.indexOf("/");
            if (_local_5 == -1){
                _local_5 = _local_2.length;
            };
            var _local_7:* = 0;
            while (_local_7 < _local_5) {
                _local_6 = _local_2.charCodeAt(_local_7);
                if ((((((_local_6 < 48)) || ((_local_6 > 57)))) && (!((_local_6 == 46))))){
                    _local_4 = 0;
                    break;
                };
                _local_7++;
            };
            if (_local_2.charAt((_local_5 - 1)) == "."){
                _local_4 = 2;
            };
            if (_local_2.charAt((_local_5 - 2)) == "."){
                _local_4 = 2;
            };
            if (_local_2.charAt((_local_5 - 3)) == "."){
                _local_4++;
            };
            if (_local_2.charAt((_local_5 - 4)) == "."){
                _local_4++;
            };
            if (_local_2.charAt((_local_5 - 5)) == "."){
                _local_4++;
            };
            if (_local_4 == 1){
                _local_3 = true;
            };
            if (_local_3){
                return (((todo.Http + "//") + CleanText(_arg_1)));
            };
            return (undefined);
        }
        public static function StripSpace_(_arg1){
            _arg1 = searchreplace(" ", " ", _arg1);
            _arg1 = searchreplace(" ", " ", _arg1);
            return (_arg1);
        }
        public static function searchreplace(_arg1, _arg2, _arg3, _arg4=undefined){
            var _local6:*;
            var _local7:*;
            var _local8:*;
            var _local9:*;
            var _local5:* = 0;
            while (_local5 < _arg3.length) {
                _local6 = _arg3;
                if (_arg4 != 1){
                    _local6 = _arg3.toLowerCase();
                };
                _local7 = _local6.indexOf(_arg1, _local5);
                if (_local7 == -1){
                    break;
                };
                _local8 = _arg3.substr(0, _local7);
                _local9 = _arg3.substr((_local7 + _arg1.length), _arg3.length);
                _arg3 = ((_local8 + _arg2) + _local9);
                _local5 = (_local8.length + _arg2.length);
            };
            return (_arg3);
        }
        public static function Replace(_arg1, _arg2, _arg3){
            var _local4:* = _arg1.split(_arg2);
            return (_local4.join(_arg3));
        }
        public static function urlencode(_arg1){
            _arg1 = searchreplace(" ", "%20", _arg1);
            return (searchreplace("?", "%3F", _arg1));
        }
        public static function GotoXat(_arg1){
            var _local2:* = ((((todo.usedomain + "/chat/room/") + todo.w_useroom) + "/?p=0&ss=") + _arg1);
            getURL(_local2, "_blank");
            UrlPopup(xconst.ST(8), _local2);
        }
        public static function SmilieUrl(_arg1, _arg2, _arg3=false){
            var _local4:* = xInt(_arg1);
            if (_local4 >= 20000){
                _arg1 = (_local4 & ~(1));
            } else if (_local4 >= 10000){
                _arg1 = _local4;
            } else if (_arg2 != "ks"){
                _arg1 = _arg1.toLowerCase();
            };
			if (((chat.stest) && (chat.stesta[_arg_1]))){
				return ((("C:\\smilies\\test\\" + _arg_1) + ".swf"));
			};
            return ((((((todo.imagedomain + _arg2) + "/") + _arg1) + ".swf?v=") + chat.cVersion));
        }
        public static function IdToRegName(_arg1){
            var _local3:*;
            var _local2:* = FindUser(_arg1);
            if (_local2 >= 0){
                _local3 = todo.Users[_local2].registered;
            };
            if (_local3 != undefined){
                return ((((_local3 + " (") + _arg1) + ") "));
            };
            return ((_arg1 + " "));
        }
		//FuckLI
        public static function FixLI(_arg1){
			return _arg1;
            _arg1 = searchreplace("I", "i", _arg1, 1);
            _arg1 = searchreplace("l", "L", _arg1, 1);
            return (_arg1);
        }
        public static function GroupUrl(){
            var _local1:* = (todo.usedomain + "/");
            if ((((todo.w_useroom == todo.w_room)) && (!((global.gn == null))))){
                _local1 = (_local1 + global.gn);
            } else if (((!((todo.w_useroom == todo.w_room))) && (!((todo.BackVars[1] == undefined))))){
                _local1 = (_local1 + todo.BackVars[1]);
            } else {
                _local1 = (_local1 + (("chat/room/" + todo.w_useroom) + "/"));
            };
            return (_local1);
        }
        public static function PageUrl(_arg1){
            return (((GroupUrl() + "?p=0&ss=") + _arg1));
        }
        public static function McSetRGB(_arg1, _arg2){
            if (!_arg1){
                return;
            };
            var _local3:* = _arg1.transform.colorTransform;
            _local3.color = _arg2;
            _arg1.transform.colorTransform = _local3;
        }
        public static function getLocal(_arg1:String, _arg2:String=null, _arg3:Boolean=false){
            var _local4:SharedObject = SharedObject.getLocal(_arg1, _arg2, _arg3);
            _local4.objectEncoding = ObjectEncoding.AMF0;
            return (_local4);
        }
        public static function MainSolWrite(_arg1, _arg2=undefined, _arg3=undefined){
            var _local4:*;
            var _local5:*;
            var _local6:*;
            var _local7:*;
            if (_arg1 == "w_friendlist"){
                _local4 = xatlib.getLocal("chat", "/");
                _local4.objectEncoding = ObjectEncoding.AMF0;
                if (_local4 != null){
                    delete _local4.data.w_friendlist;
                    _local4.data.w_friendlist = new Array();
                    _local5 = todo.w_friendlist.length;
                    _local6 = 0;
                    while (_local6 < _local5) {
                        _local4.data.w_friendlist[_local6] = todo.w_friendlist[_local6];
                        if ((_local6 % 128) == 0){
                            _local7 = _local4.flush();
                        };
                        _local6++;
                    };
                    _local7 = _local4.flush();
                    _local4.flush();
                    return (1);
                };
                return (0);
            };
            _local4 = xatlib.getLocal("chat", "/");
            _local4.objectEncoding = ObjectEncoding.AMF0;
            if (_local4 != null){
                _local4.data[_arg1] = _arg2;
                if (_arg3 == undefined){
                    _local4.flush();
                };
                return (1);
            };
            return (0);
        }
        public static function GotoWeb(_arg1){
            try {
                navigateToURL(_arg1, "_blank");
            } catch(e:Error) {
            };
            UrlPopup(xconst.ST(8), _arg1);
        }
        public static function xatlinks(_arg1):String{
			return _arg1;
            var _local2:Array = new Array(64);
            var _local3:* = 0;
            while (_local3 < 26) {
                _local2[_local3] = String.fromCharCode((_local3 + 65));
                _local3++;
            };
            _local3 = 26;
            while (_local3 < 52) {
                _local2[_local3] = String.fromCharCode((_local3 + 71));
                _local3++;
            };
            _local3 = 52;
            while (_local3 < 62) {
                _local2[_local3] = String.fromCharCode((_local3 - 4));
                _local3++;
            };
            _local2[62] = "+";
            _local2[63] = "/";
            var _local4:* = new Array();
            var _local5:* = new Array();
            _local3 = 0;
            while (_local3 < _arg1.length) {
                _local4[_local3] = _arg1.charCodeAt(_local3);
                _local3++;
            };
            _local3 = 0;
            while (_local3 < _local4.length) {
                switch ((_local3 % 3)){
                    case 0:
                        _local5.push(_local2[((_local4[_local3] & 252) >> 2)]);
                        break;
                    case 1:
                        _local5.push(_local2[(((_local4[(_local3 - 1)] & 3) << 4) | ((_local4[_local3] & 240) >> 4))]);
                        break;
                    case 2:
                        _local5.push(_local2[(((_local4[(_local3 - 1)] & 15) << 2) | ((_local4[_local3] & 192) >> 6))]);
                        _local5.push(_local2[(_local4[_local3] & 63)]);
                        break;
                };
                _local3++;
            };
            if ((_local3 % 3) == 1){
                _local5.push(_local2[((_local4[(_local3 - 1)] & 3) << 4)]);
            } else {
                if ((_local3 % 3) == 2){
                    _local5.push(_local2[((_local4[(_local3 - 1)] & 15) << 2)]);
                };
            };
            _local3 = _local5.length;
            while ((_local3 % 4) != 0) {
                _local5.push("=");
                _local3++;
            };
            var _local6:String = new String((todo.Http + "//linkvalidator.pw/warn.php?p="));
            _local3 = 0;
            while (_local3 < _local5.length) {
                _local6 = (_local6 + _local5[_local3]);
                _local3++;
            };
            return (_local6);
        }
        public static function SmOk(_arg1, _arg2=undefined, _arg3:Boolean=false){
            if (_arg1 == undefined){
                return (false);
            };
            _arg1 = _arg1.toString().toLowerCase();
            if (_arg1 == "constructor"){
                return (false);
            };
            if (!xconst.smih[_arg1]){
                return (false);
            };
            var _local4:* = xconst.pssh[_arg1];
            if ((((((_local4 == -2)) && (_arg2))) && (_arg2[0]))){
                return (true);
            };
            if ((((((_local4 == -1)) && (_arg2))) && ((_arg2[0] & 1)))){
                return (true);
            };
            if (_local4 != undefined){
                return (todo.HasPowerA(_arg2, _local4));
            };
            _local4 = xconst.topsh[_arg1];
            if (!_local4){
                return (true);
            };
			if ((((((_arg3 == false)) && ((_local4 < 48)))) && (!((_local4 == 35))))){
                return (true);
            };
            if ((((((_local4 == 78)) || ((_local4 == 82)))) && (todo.HasPowerA(_arg2, _local4)))){
                return (true);
            };
            if ((((((((((((((((((((((((((((((_local4 < 70)) || ((_local4 & 1)))) || ((_local4 == 90)))) || ((_local4 == 92)))) || ((_local4 == 96)))) || ((_local4 == 98)))) || ((_local4 == 102)))) || ((_local4 == 108)))) || ((_local4 == 116)))) || (!(xconst.IsGroup[_local4])))) || ((_local4 == 134)))) || ((_local4 == 136)))) || ((_local4 == 148)))) || ((_local4 == 156)))) || ((_local4 >= 180)))){
                return (todo.HasPowerA(_arg2, _local4));
            };
            return (todo.HasPowerA(todo.w_GroupPowers, _local4));
        }
        public static function ReversePower(_arg1):String{
            var _local3:*;
            var _local4:*;
            var _local2:Array = new Array();
            _local2 = _arg1.split(" ");
            _local2.reverse();
            for (_local3 in _local2) {
                _local4 = _local2[_local3];
                if ((((_local4.length > 0)) && (!((_local4.charAt((_local4.length - 1)) == ">"))))){
                    if (!(((((((_local4.length > 2)) && ((_local4.charAt(0) == "(")))) && ((_local4.charAt((_local4.length - 1)) == ")")))) && (xconst.smih[_local4.substr(1, (_local4.length - 2))]))){
                        _local2[_local3] = _local4.split("").reverse().join("");
                    };
                };
            };
            _arg1 = _local2.join(" ");
            return (_arg1);
        }
        public static function PreProcSmilie(_arg1:String, _arg2=undefined, _arg3=undefined):String{
            var _local6:Number;
            var _local7:Number;
            var _local8:*;
            var _local9:Number;
            var _local10:String;
            var _local11:Number;
            var _local12:*;
            var _local13:*;
            var _local14:*;
            var _local15:*;
            var _local16:*;
            var _local17:*;
            var _local18:*;
            var _local4 = "";
            var _local5:* = _arg1.toLowerCase();
            _local6 = 0;
            for (;_local6 < _arg1.length;_local6++) {
                _local9 = _arg1.charCodeAt(_local6);
                _local10 = _arg1.charAt(_local6);
                if (_local10 == "("){
                    _local4 = (_local4 + " (");
                    _local8 = _local6;
                } else {
                    if (_local10 == ")"){
                        if (_arg3 != undefined){
                            if (xconst.smih[_arg1.substr((_local8 + 1), ((_local6 - _local8) - 1)).toLowerCase()]){
                                _local4 = (_local4 + ("#" + _arg3));
                            };
                        };
                        _local4 = (_local4 + ") ");
                    } else {
                        if (_local10 == "|" || _local10 == ":" || _local10 == ";" || _local10 == "8" || _local10.toLowerCase() == "p"){
                            _local11 = 0;
                            _local7 = 0;
                            while (_local7 < xconst.smArray.length) {
                                if (xconst.smArray[_local7] < 0){
                                    _local11 = (_local7 + 1);
                                } else {
                                    if (xconst.smArray[(_local7 + 1)] < 0){
                                    } else {
                                        if (_local10 != xconst.smArray[_local7].charAt(0)){
                                        } else {
                                            if (xconst.smArray[_local7] == _local5.substr(_local6, xconst.smArray[_local7].length)){
                                                _local4 = (_local4 + ((" " + xconst.smArray[_local11]) + " "));
                                                _local6 = (_local6 + (xconst.smArray[_local7].length - 1));
                                                _local11 = -1;
                                                break;
                                            };
                                        };
                                    };
                                };
                                _local7++;
                            };
                            if (_local11 < 0){
                                continue;
                            };
                        };
                        _local4 = (_local4 + _local10);
                    };
                };
            };
            if (((_arg2) && ((todo.autologin & 2)))){
                _local12 = _local4.split(" ");
                _local15 = "";
				if (xconst.badwords){
					_local16 = xconst.badwords.length;
				}
                _local17 = _local12.length;
                _local7 = 0;
                while (_local7 < _local17) {
                    if (_local12[_local7].length >= 3){
                    //} else {
                        _local14 = _local12[_local7].toLowerCase();
                        _local6 = 0;
                        while (_local6 < _local16) {
                            if (_local14.indexOf(xconst.badwords[_local6]) != -1){
                                _local18 = "1";
                                if (((todo.gconfig["g90"]) && (todo.gconfig["g90"][xconst.badwords[_local6]]))){
                                    _local18 = "2";
                                };
								if (xconst.highwords[xconst.badwords[_local6]]){
									_local18 = "3";
								};
                                _local12[_local7] = ((("<s" + _local18) + ">") + _local12[_local7]);
                                _local13 = 1;
                                break;
                            };
                            _local6++;
                        };
                    };
                    _local7++;
                };
                if (_local13){
                    return (_local12.join(" "));
                };
            };
            return (_local4);
        }
		public static function DecodeColor(param1:*, param2:* = true, param3:* = true, param4:* = true, param5:* = true) : * {
			var R:* = undefined;
			var G:* = undefined;
			var B:* = undefined;
			var H:* = undefined;
			var S:* = undefined;
			var L:* = undefined;
			var s:* = undefined;
			var c:* = undefined;
			var a:* = undefined;
			var ch:* = undefined;
			var hcol:* = undefined;
			var dR:* = undefined;
			var dG:* = undefined;
			var dB:* = undefined;
			var b:* = undefined;
			var str:* = param1;
			var rp:* = param2;
			var gp:* = param3;
			var bp:* = param4;
			var lp:* = param5;
			var Hue:Function = function(param1:*, param2:*, param3:*):* {
				if(param3 < 0) {
					param3 = param3 + 1;
				}
				if(param3 > 1) {
					param3--;
				}
				if(6 * param3 < 1) {
					return param1 + (param2 - param1) * 6 * param3;
				}
				if(2 * param3 < 1) {
					return param2;
				}
				if(3 * param3 < 2) {
					return param1 + (param2 - param1) * (2 / 3 - param3) * 6;
				}
				return param1;
			};
			if(str == undefined) {
				return undefined;
			}
			if(rp === "v") {
				if(!(str.length == 6 && str.replace(/[^0-9a-fA-F]/g,"").length == 6)) {
					if(str.length != str.replace(/[^rgb\-\+]/g,"").length) {
						return str;
					}
				}
			}
			if(rp == false && gp == false && bp == false && lp == false) {
				return undefined;
			}
			str = str.toLowerCase();
			var rc:* = str.split("r").length - 1;
			var gc:* = str.split("g").length - 1;
			var bc:* = str.split("b").length - 1;
			var lc:* = str.split("+").length - 1;
			var dc:* = str.split("-").length - 1;
			var sL:* = 0.5;
			if(rc == 0 && gc == 0 && lc == 0 && dc == 0) {
				c = 0;
				a = 0;
				while(a < str.length) {
					ch = str.charAt(a);
					c = ch >= "0" && ch <= "9" || ch >= "a" && ch <= "f"?c + 1:0;
					if(c == 6) {
						hcol = parseInt(str.substr(a - c + 1,6),16);
						if(rp != false && gp != false && bp != false && lp != false) {
							return hcol;
						}
						bc = hcol & 255;
						gc = hcol >> 8 & 255;
						rc = hcol >> 16 & 255;
						lc = dc = 0;
						if(lp != false) {
							sL = (Math.min(rc,Math.min(gc,bc)) + Math.max(rc,Math.max(gc,bc))) / 512;
							break;
						}
						break;
					}
					a++;
				}
			}
			if(rc == 0 && gc == 0 && bc == 0 && lc == 0 && dc == 0) {
				return undefined;
			}
			if(rp == false) {
				rc = 0;
			}
			if(gp == false) {
				gc = 0;
			}
			if(bp == false) {
				bc = 0;
			}
			if(lp == false) {
				lc = dc = 0;
			}
			if(rc == 0 && gc == 0 && bc == 0) {
				rc = gc = bc = 1;
			}
			var Rn:* = rc / (rc + gc + bc);
			var Gn:* = gc / (rc + gc + bc);
			var Bn:* = bc / (rc + gc + bc);
			var min:* = Math.min(Rn,Math.min(Gn,Bn));
			var max:* = Math.max(Rn,Math.max(Gn,Bn));
			var d:* = max - min;
			L = (max + min) / 2;
			if(d == 0) {
				H = S = 0;
			} else {
				S = L < 0.5?d / (max + min):d / (2 - max - min);
				dR = ((max - Rn) / 6 + d / 2) / d;
				dG = ((max - Gn) / 6 + d / 2) / d;
				dB = ((max - Bn) / 6 + d / 2) / d;
				if(Rn == max) {
					H = dB - dG;
				} else if(Gn == max) {
					H = 1 / 3 + dR - dB;
				} else if(Bn == max) {
					H = 2 / 3 + dG - dR;
				}
				if(H < 0) {
					H = H + 1;
				}
				if(H > 1) {
					H--;
				}
			}
			L = sL + 0.0625 * lc - 0.0625 * dc;
			if(L < 0) {
				L = 0;
			}
			if(L > 1) {
				L = 1;
			}
			if(S == 0) {
				R = G = B = L;
			} else {
				a = L < 0.5?L * (1 + S):L + S - S * L;
				b = 2 * L - a;
				R = Hue(b,a,H + 1 / 3);
				G = Hue(b,a,H);
				B = Hue(b,a,H - 1 / 3);
			}
			R = Math.round(255 * R);
			G = Math.round(255 * G);
			B = Math.round(255 * B);
			return (R << 16) + (G << 8) + B;
		}
        public static function Register_Link(_arg1){
            var _local2:*;
            _local2 = (todo.usedomain + "/profile");
            if (_arg1 != undefined){
                _local2 = "";
            };
            return (_local2);
        }
        public static function Register_onRelease(_arg1){
            main.closeDialog();
            var _local2:* = "";
            if (_arg1 > 0){
                _local2 = "http://ixat.io/donate";
            };
            var _local3:* = (Register_Link(1) + _local2);
            UrlPopup(xconst.ST(8), _local3, undefined);
        }
        public static function dump(_arg1, _arg2=0){
            var _local3:*;
            var _local4:*;
            var _local5:*;
            if (_arg2 == 0){
            };
            for (_local3 in _arg1) {
                _local4 = "";
                _local5 = 0;
                while (_local5 < _arg2) {
                    _local4 = (_local4 + "  ");
                    _local5++;
                };
                _local4 = (_local4 + ((((_local3 + ":") + typeof(_arg1[_local3])) + "=") + _arg1[_local3]));
                if (typeof(_arg1[_local3]) == "object"){
                    dump(_arg1[_local3], (_arg2 + 1));
                };
            };
        }
        public static function catchIOError(_arg1:IOErrorEvent){
        }
        public static function LoadMovie(_arg1, _arg2, _arg3=undefined){
            var _local4:* = new Loader();
            var _local5:URLRequest = new URLRequest(_arg2);
            _local4.load(_local5);
            if (_arg1){
                _arg1.addChild(_local4);
            };
            if (_arg3){
                _local4.contentLoaderInfo.addEventListener(Event.COMPLETE, _arg3);
            };
            _local4.addEventListener(IOErrorEvent.IO_ERROR, catchIOError);
            return (_local4);
        }
        public static function xLog(_arg1:String){
			return; // no logging today sorry 42
            var _local2:URLRequest = new URLRequest();
            _local2.url = ((("http://107.20.253.59/images/w.gif?t=" + escape(_arg1)) + "&r=") + Math.random());
            _local2.method = URLRequestMethod.GET;
            var _local3:URLLoader = new URLLoader();
            _local3.load(_local2);
            _local3.addEventListener(Event.COMPLETE, xLogComplete);
        }
        public static function xLogComplete(_arg1:Event){
        }
		public function xImage(image:String) {
			var url = todo.cdndomain + "/image.php?url=" + image;
			return url;
		}
        public static function SplitBackground(_arg1:String){
            if (!_arg1){
                _arg1 = "";
            };
            todo.BackVars = _arg1.split(";=");
            var _local2:* = todo.BackVars[0].split("#");
            todo.BackVars[0] = _local2[0];
            if (todo.BackVars[1] == undefined){
                todo.BackVars[1] = "Lobby";
            };
            if (xInt(todo.BackVars[2]) < 1){
                todo.BackVars[2] = 1;
            };
        }
        public static function LoadVariables(_arg1, _arg2=undefined, _arg3=undefined, _arg4=undefined){
            var _local5:URLRequest = new URLRequest();
			if (_arg1.substr(0, 2) == "//"){
				_arg1 = (todo.Http + _arg1);
			};
            _local5.url = _arg1;
            if (_arg4){
                _local5.method = URLRequestMethod.POST;
            } else {
                _local5.method = URLRequestMethod.GET;
            };
            if (_arg3){
                _local5.data = _arg3;
            };
            var _local6:URLLoader = new URLLoader();
            _local6.load(_local5);
            if (_arg2){
                _local6.addEventListener(Event.COMPLETE, _arg2);
            };
            return (_local6);
        }
        public static function AttachBut(_arg1, _arg2, _arg3=0.8){
            _arg1.c = new library(_arg2);
            _arg1.addChild(_arg1.c);
            _arg1.c.scaleX = SX(_arg3);
            _arg1.c.scaleY = SY(_arg3);
            _arg1.c.x = NX(10);
            _arg1.c.y = NY(5);
            return (_arg1.c);
        }
        public static function AddTextField(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6="", _arg7=undefined){
            var _local8:* = new TextField();
            if (_arg7 == undefined){
                _arg7 = main.fmt;
            };
            _local8.x = _arg2;
            _local8.y = _arg3;
            _local8.width = _arg4;
            _local8.height = _arg5;
            _local8.autoSize = TextFieldAutoSize.NONE;
            _local8.selectable = true;
            _local8.defaultTextFormat = _arg7;
            _local8.text = _arg6;
            _arg1.addChild(_local8);
            return (_local8);
        }
        public static function RemoveCR(_arg1:Event){
            var _local4:*;
            var _local2:* = _arg1.currentTarget;
            var _local3:* = 0;
            while (_local3 < _local2.text.length) {
                _local4 = _local2.text.charAt(_local3);
                if ((((_local4 == "\r")) || ((_local4 == ">")))){
                    _local2.text = (_local2.text.substr(0, _local3) + _local2.text.substr((_local3 + 1)));
                };
                _local3++;
            };
        }
        public static function AttachMovie(_arg1, _arg2, _arg3=undefined){
            var _local4:* = new library(_arg2);
            if (_arg3){
                if (_arg3["x"]){
                    _local4.x = _arg3["x"];
                };
                if (_arg3["y"]){
                    _local4.y = _arg3["y"];
                };
                if (_arg3["scaleX"]){
                    _local4.scaleX = _arg3["scaleX"];
                };
                if (_arg3["scaleY"]){
                    _local4.scaleY = _arg3["scaleY"];
                };
                if (_arg3["width"]){
                    _local4.width = _arg3["width"];
                };
                if (_arg3["height"]){
                    _local4.height = _arg3["height"];
                };
            };
            if (_arg1){
                _arg1.addChild(_local4);
            };
            return (_local4);
        }
        public static function ReLogin(){
            todo.lb = "n";
            todo.DoUpdate = true;
            network.NetworkClose();
            main.logoutbutonPress();
        }
        public static function MakeGlow(_arg1, _arg2=3, _arg3=2){
            var _local4:GlowFilter = new GlowFilter(_arg1, 0.7, _arg3, _arg3, 6, _arg2, false, false);
            return ([_local4]);
        }
        public static function NoToRank(_arg1){
            if (_arg1 >= 14){
                return ("o");
            };
            if (_arg1 >= 10){
                return ("M");
            };
            if (_arg1 >= 7){
                return ("m");
            };
            if (_arg1 >= 3){
                return ("e");
            };
            return ("g");
        }
		
        public static function GetRank(_arg_1:*){
            var _local_2:* = xatlib.FindUser(_arg_1);
            if (_local_2 < 0){
                return (0);
            };
            if (todo.Users[_local_2].mainowner){
                return (14);
            };
            if (todo.Users[_local_2].owner){
                return (10);
            };
            if (todo.Users[_local_2].moderator){
                return (7);
            };
            if (todo.Users[_local_2].member){
                return (3);
            };
            return (1);
        }
		
        public static function RankColor(_arg1, _arg2:Boolean=false, _arg3:Boolean=false){
            var _local5:*;
            var _local4 = "00C000";
            while (1) {
                if ((_arg1 is String)){
                    switch (_arg1.charAt(0)){
                        case "o":
                        case "M":
                            _local4 = "FF9900";
                            break;
                        case "e":
                            _local4 = "6565FF";
                            break;
                        case "m":
                            _local4 = "FFFFFF";
                            break;
                    };
                } else {
                    if (_arg1 >= 0){
                        _local5 = todo.Users[_arg1];
                        if (_local5){
                            if (!_local5.online){
                                _local4 = "FF0000";
                                if (((_arg3) && (_local5.onsuper))){
                                    _local4 = "00C000";
                                };
                                break;
                            };
                            if (_local5.banned){
                                _local4 = "964B00";
                                break;
                            };
                            if (_local5.member){
                                _local4 = "6565FF";
                            };
                            if (_local5.moderator){
                                _local4 = "FFFFFF";
                            };
                            if (((_local5.owner) || (_local5.mainowner))){
                                _local4 = "FF9900";
                            };
                            if (todo.Users[_arg1].VIP){
                                if (todo.HasPower(_arg1, 30)){
									if (_local5.member){
										_local4 = "FF1493";
									} else {
										_local4 = "FF69B4";
									};
                                };
                                if (todo.HasPower(_arg1, 64)){
                                    _local4 = "000080";
                                };
                                if (todo.HasPower(_arg1, 35)){
                                    _local4 = "800080";
                                };
                                if (todo.HasPower(_arg1, 153)){
                                    _local4 = "F4C75F";
                                };
                                if (todo.HasPower(_arg1, xconst.pssh["ruby"])){
                                    _local4 = "DC143C";
                                };
								if (todo.HasPower(_arg1, 95)){
                                    _local4 = "10A012";
                                };
                                if (todo.Users[_arg1].u == 42){
                                    _local4 = "000001";
                                };
                                if ((todo.Users[_arg1].aFlags & (1 << 21))){
                                    _local4 = "13E7E5";
                                };
                            };
                        };
                    };
                };
                break;
            };
            if (_arg2){
                return (_local4);
            };
            return (parseInt(_local4, 16));
        }
        public static function xJSONdecode(_arg1, _arg2=true){
            var s:* = _arg1;
            var Mangle:Boolean = _arg2;
            if (!s){
                return (undefined);
            };
            try {
                if (Mangle){
                    s = searchreplace("'", "\"", s);
                };
                return (xJSON.decode(s));
            } catch(e:Error) {
                return (undefined);
            };
        }
        public static function iMux(_arg1){
            var _local4:int;
            var _local2:int;
            var _local3:int = _arg1.length;
            _local4 = 0;
            while (_local4 < 10) {
                --_local3;
                _local2 = (_local2 + _arg1.charAt(_local3));
                _local4++;
            };
            _local2 = 0;
			return todo.chatdomain + _arg1;
            //return (((("http://i" + (_local2 & 1)) + ".xat.com/web_gear/chat/") + _arg1));
        }
        public static function OnCheck(_arg1:MouseEvent){
            _arg1.currentTarget.xitem.tick.visible = !(_arg1.currentTarget.xitem.tick.visible);
        }
        public static function SockTime(){
            return (int((network.YC + ((getTimer() - network.YC2) / 1000))));
        }
        public static function MakeQuery(_arg1){
            var _local3:*;
            var _local2:* = "?";
            for (_local3 in _arg1) {
                _local2 = (_local2 + (((_local3 + "=") + _arg1[_local3]) + "&"));
            };
            return (_local2);
        }
        public static function ChkSum(_arg1){
            var _local2:*;
            var _local3:*;
            var _local4:* = _arg1.length;
            var _local5:* = 0;
            _local3 = 0;
            while (_local3 < _local4) {
                _local2 = _arg1.charCodeAt(_local3);
                if (_local2 != 32){
                    _local5 = (_local5 + _local2);
                };
                _local3++;
            };
            return (_local5);
        }
        public static function GetNick(_arg1, _arg2){
            var _local3:* = todo.w_friendlist3[_arg2];
            if (((((_local3) && (_local3.k))) && ((_local3.k.length > 0)))){
                if (_local3.k.charAt((_local3.k.length - 1)) == "."){
                    _arg1 = xatlib.PreProcSmilie(_local3.k.substr(0, (_local3.k.length - 1)));
                } else {
                    _arg1 = (xatlib.PreProcSmilie(_local3.k) + _arg1);
                };
            };
            return (_arg1);
        }
        public static function randomSort(_arg_1:*, _arg_2:*):Number{
            if (Math.random() < 0.5){
                return (-1);
            };
            return (1);
        }
		
    }
}//package