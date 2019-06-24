// Decompiled by AS3 Sorcerer 3.32
// http://www.as3sorcerer.com/

//Jinx

package {
    public class Jinx {

        public var JinxType;
        private var Rand:int;
        private var seed:int;
        private var Last;
        private var Arg;
        private var jinxendtime;

        public static function EffectToJinx(_arg_1:*){
            _arg_1 = xconst.hugs[_arg_1];
            if (!_arg_1){
                return (false);
            };
            _arg_1 = xconst.hugsR[(100000 + (_arg_1 % 10000))];
            if (!_arg_1){
                return (false);
            };
            return (_arg_1);
        }

        public function DoJinx(_arg_1:*, _arg_2:*, _arg_3:*){
            var _local_4:*;
            var _local_5:*;
            if (_arg_1.indexOf(">") != -1){
                return (_arg_1);
            };
            var _local_6:* = _arg_2.split(/([a-z]+)/);
            this.jinxendtime = xatlib.xInt(_local_6[0]);
            var _local_7:* = (this.jinxendtime - xatlib.SockTime());
            if (_local_7 < 0){
                return (_arg_1);
            };
            this.JinxType = EffectToJinx(_local_6[1]);
            if (!this.JinxType){
                return (_arg_1);
            };
            this.seed = (this.Rand = xatlib.ChkSum((_arg_1 + _arg_3)));
            var _local_8:* = xatlib.xInt(_local_6[2]);
            if (_local_8 > 100){
                _local_8 = 100;
            };
            if (this.JinxType == "hang"){
                if (_local_8 <= 0){
                    _local_8 = 50;
                };
                this.Arg = xatlib.xInt((_local_8 * (4 / 50)));
                if (this.Arg == 0){
                    return (_arg_1);
                };
            } else {
                if (_local_8 <= 0){
                    _local_8 = 25;
                };
                if ((this.Rand % 100) > _local_8){
                    return (_arg_1);
                };
            };
            this.JinxType = (this.JinxType + "jinx");
            _local_7 = xatlib.xInt(((_local_7 / 60) + 30));
            _arg_1 = _arg_1.split(" ");
            var _local_9:* = [];
            _local_4 = 0;
            while (_local_4 < _arg_1.length) {
                if ((((_arg_1[_local_4].charAt(0) == "(")) && ((_arg_1[_local_4].charAt((_arg_1[_local_4].length - 1)) == ")")))){
                    _local_9.push(_arg_1[_local_4]);
                    _arg_1[_local_4] = ">";
                };
                _local_4++;
            };
            _arg_1 = this.JinxIt(_arg_1, _local_6[1]);
            _local_4 = 0;
            while (_local_4 < _arg_1.length) {
                if (_arg_1[_local_4] == ">"){
                    _arg_1[_local_4] = _local_9.pop();
                };
                _local_4++;
            };
            _arg_1 = _arg_1.join(" ");
            if (this.jinxendtime < 2147483647){
                _arg_1 = (_arg_1 + (((((((("  (" + this.JinxType) + "#w") + _local_7) + this.Last) + _local_8) + "_") + this.Rand) + ")"));
            };
            return (_arg_1);
        }
        private function JinxIt(_arg_1:*, _arg_2:*){
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
			var _local_13:*;
            if (_arg_2 == "jumble"){
                _arg_2 = (this.Rand % 4);
            };
            switch (_arg_2){
                case 0:
                case "reverse":
                    this.Last = "reverse";
                    _local_3 = 0;
                    while (_local_3 < _arg_1.length) {
                        _arg_1[_local_3] = _arg_1[_local_3].split("").reverse().join("");
                        _local_3++;
                    };
                    break;
                case 1:
                case "mix":
                default:
                    this.Last = "mix";
                    _local_3 = 0;
                    while (_local_3 < _arg_1.length) {
                        _arg_1[_local_3] = _arg_1[_local_3].split("").sort(this.randomSort).join("");
                        _local_3++;
                    };
                    break;
                case 2:
                case "ends":
                    this.Last = "ends";
                    _local_3 = 0;
                    while (_local_3 < _arg_1.length) {
                        _local_4 = _arg_1[_local_3].split("");
                        _local_5 = _local_4[0];
                        _local_4[0] = _local_4[(_local_4.length - 1)];
                        _local_4[(_local_4.length - 1)] = _local_5;
                        _arg_1[_local_3] = _local_4.join("");
                        _local_3++;
                    };
                    break;
                case 3:
                case "middle":
                    this.Last = "middle";
                    _local_3 = 0;
                    while (_local_3 < _arg_1.length) {
                        _local_4 = _arg_1[_local_3].split("");
                        if (_local_4.length > 3){
                            _local_5 = _local_4[0];
                            _local_6 = _local_4[(_local_4.length - 1)];
							_local_11 = _local_4.slice(1, (_local_4.length - 1));
							_local_11 = _local_11.sort(this.randomSort);
							_local_11.unshift(_local_5);
							_local_11.push(_local_6);
							_arg_1[_local_3] = _local_11.join("");
                        };
                        _local_3++;
                    };
                    break;
                case 14:
                case "hang":
                    this.Last = "hang";
                    _local_7 = _arg_1.join(" ");
                    _local_8 = /[ >]/g;
                    _local_4 = _local_7.replace(_local_8, "");
                    if (_local_4.length <= 0){
                        this.jinxendtime = 1000000000000000;
                    } else {
                        _local_4 = _local_4.split("");
                        if (this.Arg > _local_4.length){
                            this.Arg = _local_4.length;
                        };
                        _local_3 = 0;
                        while (_local_3 < this.Arg) {
                            _local_7 = _local_7.split(_local_4[(this.random() % _local_4.length)]).join("_");
                            _local_3++;
                        };
                    };
                    _arg_1 = _local_7.split(" ");
                    break;
                case 16:
                case "egg":
                    this.Last = "egg";
                    _local_7 = _arg_1.join(" ");
                    _local_8 = /[EȄȆḔḖḘḚḜẸẺẼẾỀỂỄỆĒĔĖĘĚÈÉÊËeȅȇḕḗḙḛḝẹẻẽếềểễệēĕėęěèéêë]/g;
                    _local_7 = _local_7.replace(_local_8, "egge");
                    _local_8 = /[AÀÁÂÃÄÅĀĂĄǺȀȂẠẢẤẦẨẪẬẮẰẲẴẶḀÆǼaàáâãäåāăąǻȁȃạảấầẩẫậắằẳẵặḁæǽ]/g;
                    _local_7 = _local_7.replace(_local_8, "egga");
                    _local_8 = /[IȈȊḬḮỈỊĨĪĬĮİÌÍÎÏĲiȉȋḭḯỉịĩīĭįiìíîïĳ]/g;
                    _local_7 = _local_7.replace(_local_8, "eggi");
                    _local_8 = /[OŒØǾȌȎṌṎṐṒỌỎỐỒỔỖỘỚỜỞỠỢŌÒÓŎŐÔÕÖoœøǿȍȏṍṏṑṓọỏốồổỗộớờởỡợōòóŏőôõö]/g;
                    _local_7 = _local_7.replace(_local_8, "eggo");
                    _local_8 = /[UŨŪŬŮŰŲÙÚÛÜȔȖṲṴṶṸṺỤỦỨỪỬỮỰuũūŭůűųùúûüȕȗṳṵṷṹṻụủứừửữự]/g;
                    _local_7 = _local_7.replace(_local_8, "eggu");
                    _local_8 = /[YẙỲỴỶỸŶŸÝyẙỳỵỷỹŷÿý]/g;
                    _local_7 = _local_7.replace(_local_8, "eggy");
                    _arg_1 = _local_7.split(" ");
                    break;
				case "pig":
					this.Last = "pig";
					_arg_1 = _arg_1.map(function(s:String, index:int, array:Array):String {
						return (s.charAt(0).match(/([AaEeIiOoUu].*)/) ? s + "yay" : s.split(/([AaEeIiOoUu].*)/).reverse().join("") + "ay");
					});
					break;
                case 9:
                case "space":
                    this.Last = "space";
                    this.jinxendtime = 0;
                    _arg_1 = [_arg_1.join("")];
                    _local_8 = /[ >]/g;
                    _arg_1[0] = _arg_1[0].replace(_local_8, "");
                    break;
                case 11:
                case "rspace":
                    this.Last = "rspace";
                    this.jinxendtime = 0;
                    _local_7 = _arg_1.join(" ");
                    _local_8 = /\s+/g;
                    _local_7 = _local_7.replace(_local_8, " ");
                    _local_8 = /[>]/g;
                    _local_7 = _local_7.replace(_local_8, " ");
                    _arg_1 = _local_7.split(" ");
                    _local_8 = /[ ]/g;
                    _local_7 = _local_7.replace(_local_8, "");
                    _local_9 = new Array();
                    if (_arg_1.length <= 4){
                        _local_12 = _local_7.length;
                        _local_13 = 0;
                        while (_local_13 < _local_12) {
                            _local_8 = ((this.random() % 1000000) / 10000);
                            if (_local_8 < 2.998){
                                _local_9[_local_13] = 1;
                            } else {
                                if (_local_8 < 20.649){
                                    _local_9[_local_13] = 2;
                                } else {
                                    if (_local_8 < 41.16){
                                        _local_9[_local_13] = 3;
                                    } else {
                                        if (_local_8 < 55.947){
                                            _local_9[_local_13] = 4;
                                        } else {
                                            if (_local_8 < 66.647){
                                                _local_9[_local_13] = 5;
                                            } else {
                                                if (_local_8 < 75.035){
                                                    _local_9[_local_13] = 6;
                                                } else {
                                                    if (_local_8 < 82.974){
                                                        _local_9[_local_13] = 7;
                                                    } else {
                                                        if (_local_8 < 88.917){
                                                            _local_9[_local_13] = 8;
                                                        } else {
                                                            _local_9[_local_13] = 9;
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                            _local_13 = (_local_13 + _local_9[_local_13]);
                        };
                    } else {
                        _local_3 = 0;
                        while (_local_3 < _arg_1.length) {
                            _local_9[_local_3] = _arg_1[_local_3].length;
                            _local_3++;
                        };
                        _local_9.sort(this.randomSort);
                    };
                    _local_8 = / /g;
                    _local_7 = _local_7.replace(_local_8, "");
                    _local_10 = 0;
                    _local_3 = 0;
                    while (_local_3 < (_arg_1.length - 1)) {
                        _local_10 = (_local_10 + _local_9[_local_3]);
                        _local_7 = ((_local_7.slice(0, _local_10) + " ") + _local_7.slice(_local_10));
                        _local_10++;
                        _local_3++;
                    };
                    _arg_1 = _local_7.split(" ");
            };
            return (_arg_1);
        }
        private function randomSort(_arg_1:*, _arg_2:*):Number{
            if ((Math.random() & 1)){
                return (-1);
            };
            return (1);
        }
        private function random():int{
            this.seed = (this.seed ^ (this.seed << 21));
            this.seed = (this.seed ^ (this.seed >>> 35));
            this.seed = (this.seed ^ (this.seed << 4));
            return (this.seed);
        }

    }
}//package 

