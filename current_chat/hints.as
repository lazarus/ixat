package {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
    import flash.geom.*;

    public class hints extends Sprite {

        var HintHldMc:MovieClip;
        var HintDisplayed:Boolean = false;
        var HintBoxx:Number;
        var HintBoxy:Number;
        var Hinttxt:String;
        var Hintvis:Boolean = false;
        var HintPos:Number;
        var Hintsize:Number;
        var HintMaxWidth:Number;
        var HintUpdate:Number = -1;
        var HintMc;
        var heartbeatduration:Number = 83;
		var NewTheme:Boolean = false;

        public function hints(){
            if (todo.config["nohints"]){
                return;
            };
            addEventListener(Event.ENTER_FRAME, this.tick);
        }
        public function EasyHint(_arg1:MouseEvent){
            var _local2:* = _arg1.currentTarget;
            this.Hint(xatlib.xInt(_local2.hint["Boxx"]), xatlib.xInt(_local2.hint["Boxy"]), _local2.hint["Hint"], true, xatlib.xInt(_local2.hint["Pos"]), xatlib.xInt(_local2.hint["size"]), xatlib.xInt(_local2.hint["MaxWidth"]), _local2.hint["mc"]);
        }
        public function AddEasyHint(_arg1, _arg2, _arg3=undefined){
            if (!_arg3){
                _arg3 = {};
            };
            _arg3.Hint = _arg2;
            _arg3.mc = _arg1;
            _arg1.hint = _arg3;
            _arg1.addEventListener(MouseEvent.ROLL_OVER, this.EasyHint);
            _arg1.addEventListener(MouseEvent.ROLL_OUT, this.HintOff);
            _arg1.buttonMode = true;
        }
        public function Hint(_arg1:Number, _arg2:Number, _arg3:String, _arg4:Boolean=true, _arg5:Number=0, _arg6:Number=0, _arg7:Number=0, _arg8=undefined){
            if (this.HintDisplayed == true){
                if (_arg4 == true){
                    this.HintUpdate = 0;
                } else {
                    this.HintUpdate = 500;
                };
            } else {
                this.HintUpdate = 1000;
            };
            this.HintBoxx = _arg1;
            this.HintBoxy = _arg2;
            this.Hinttxt = _arg3;
            this.Hintvis = _arg4;
            this.HintPos = _arg5;
            this.Hintsize = _arg6;
            this.HintMaxWidth = _arg7;
            this.HintMc = _arg8;
        }
        public function HintOff(_arg1=0){
            this.Hint(0, 0, "", false);
        }
        public function DoHint(_arg1:Number, _arg2:Number, _arg3:String, _arg4:Boolean, _arg5:Number, _arg6:Number, _arg7:Number, _arg8){
            var _local10:TextFormat;
            var _local16:Point;
            var _local9 = (_arg7 > 0);
            if ((((_arg7 < 2)) || ((_arg7 == undefined)))){
                _arg7 = 200;
            };
            if (this.HintHldMc != undefined){
                this.HintHldMc.parent.removeChild(this.HintHldMc);
                this.HintHldMc = undefined;
            };
            _local10 = new TextFormat();
            _local10.align = "left";
            _local10.color = this.NewTheme ? 0x000000 : todo.ButColW;
            _local10.font = "_sans";
            _local10.size = _arg6;
            if ((((_local10.size == undefined)) || ((_local10.size <= 1)))){
                _local10.size = 12;
            };
            var _local11:* = new TextField();
            _local11.text = _arg3;
            if (_local9){
                _local11.autoSize = "left";
                _local11.multiline = true;
                _local11.wordWrap = true;
            };
            _local11.setTextFormat(_local10);
            var _local12:* = (_local11.textWidth + 4);
            _local11.width = _local12;
            var _local13:* = (_local11.textHeight + 2);
            if (_local9){
                _local13 = _local11.height;
            };
            _local11.height = _local13;
            if (!_local9){
                _local11.height = (_local11.height + 2);
            };
            if (_arg8 != undefined){
                _local16 = new Point();
                _local16 = _arg8.localToGlobal(_local16);
                _arg1 = (_arg1 + _local16.x);
                _arg2 = (_arg2 + _local16.y);
            };
            this.HintHldMc = new MovieClip();
            this.HintHldMc.x = _arg1;
            this.HintHldMc.y = ((_arg2 - _local13) - 6);
            if (_arg5 == 1){
                this.HintHldMc.y = _arg2;
                this.HintHldMc.x = ((_arg1 - _local12) - 4);
            };
            if (_arg5 == 2){
                this.HintHldMc.y = _arg2;
                this.HintHldMc.x = _arg1;
            };
            if (_arg5 == 3){
                this.HintHldMc.x = ((_arg1 - _local12) - 4);
            };
            if (this.HintHldMc.x < 0){
                this.HintHldMc.x = 0;
            };
            var _local14:* = 0;
            var _local15:* = 2;
			if (this.NewTheme) {
				this.HintHldMc.addChild(xatlib.AddBackground(this.HintHldMc, _local14, _local15, _local12, _local13));//techy
			} else {
				this.HintHldMc.graphics.beginFill(todo.ButCol, 90);
				this.HintHldMc.graphics.lineStyle(1, todo.ButColW, 100);
				this.HintHldMc.graphics.drawRect(_local14, _local15, _local12, _local13);
				this.HintHldMc.graphics.endFill();
			}
            this.HintHldMc.addChild(_local11);
			addChild(this.HintHldMc);
        }
        public function tick(_arg1:Event){
            if (this.HintUpdate >= 0){
                if (this.HintUpdate > this.heartbeatduration){
                    this.HintUpdate = (this.HintUpdate - this.heartbeatduration);
                } else {
                    this.HintUpdate = 0;
                };
                if (this.HintUpdate == 0){
                    this.HintDisplayed = this.Hintvis;
                    if (todo.w_hints){
                        this.DoHint(this.HintBoxx, this.HintBoxy, this.Hinttxt, this.Hintvis, this.HintPos, this.Hintsize, this.HintMaxWidth, this.HintMc);
                        this.HintUpdate = -1;
                    };
                };
            };
        }

    }
}//package 
