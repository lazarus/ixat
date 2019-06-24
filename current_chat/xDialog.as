package {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.ui.*;

    public dynamic class xDialog extends MovieClip {

        var Dia;
        public var sParent;
        var Background;
        var DiaBack;
        var DiaBar;

        public function xDialog(_arg1, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:String, _arg7:String, _arg8:Number=0, _arg9=undefined){
            var _local11:*;
            var _local12:*;
            this.Dia = this;
            super();
            if (chat.mainDlg){
                main.hint.HintOff();
            };
            this.sParent = _arg1;
            var _local10:Number = 0;
            this.Background = xatlib.ButtonCurve2(0, todo.StageWidth, todo.StageHeight, 0, 0, 0, 0, 0);
            this.Background.alpha = 0.3;
            this.Background.addEventListener(MouseEvent.MOUSE_DOWN, this.DoDelete);
            this.Background.buttonMode = true;
            _arg1.addChild(this.Background);
            _arg1.addChild(this);
            if (isNaN(_arg2)){
                _arg4 = 300;
                if (_arg4 > (todo.StageWidth - 10)){
                    _arg4 = (todo.StageWidth - 10);
                };
                _arg5 = 170;
                if (_arg5 > (todo.StageHeight - 10)){
                    _arg5 = (todo.StageHeight - 10);
                };
                _arg2 = ((todo.StageWidth / 2) - (_arg4 / 2));
                _arg3 = ((todo.StageHeight / 2) - (_arg5 / 2));
            };
            this.DiaBack = new xBut(this, _arg2, _arg3, _arg4, _arg5, "", undefined, ((xBut.b_Panel | xBut.b_Border) | xBut.b_NoPress));
			this.DiaBack.alpha = 0.6;
            if (((_arg6) && ((_arg6.length > 0)))){
                _local10 = xatlib.NY(30);
                if (_local10 < 23){
                    _local10 = 23;
                };
                if (_local10 > 30){
                    _local10 = 30;
                };
                this.DiaBar = new xBut(this, _arg2, _arg3, _arg4, _local10, (" " + _arg6), undefined, (((((xatlib.c_bl | xatlib.c_br) | xBut.b_LeftText) | xBut.b_Border) | xBut.b_NoPress) | xatlib.b_mouseChild));
                _local11 = new library("close");
                addChild(_local11);
                _local12 = int(((_local10 - _local11.height) / 2));
                _local11.y = (_arg3 + _local12);
                _local11.x = (((_arg2 + _arg4) - _local11.width) - _local12);
                _local11.buttonMode = true;
                _local11.addEventListener(MouseEvent.MOUSE_DOWN, this.DoDelete);
            };
            if (((_arg7) && ((_arg7.length > 0)))){
                xatlib.createTextNoWrap(this.DiaBack.But, 5, _local10, (_arg4 - 10), ((_arg5 - _local10) - 30), _arg7, 0, 16777185, 100, 0, 18, "left", 2);
            };
            if ((_arg8 & 1)){
                this.Dia.Ok = new xBut(this, (_arg2 + int(((_arg4 - 100) / 2))), ((_arg3 + _arg5) - 30), 100, 25, xconst.ST(45), this.Delete);
            };
        }
        public function DoDelete(_arg1:MouseEvent=undefined){
            if (((this.sParent) && (!((this.sParent.Delete == null))))){
                this.sParent.Delete();
            } else {
                this.Delete();
            };
        }
        public function Delete(_arg1:MouseEvent=undefined){
            if (!this.sParent){
                return;
            };
            this.sParent.removeChild(this.Background);
            this.sParent.removeChild(this);
            this.sParent = null;
        }

    }
}//package 
