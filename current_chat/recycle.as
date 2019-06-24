package {
    import flash.events.*;
    import flash.display.*;
    import flash.net.*;
    import flash.utils.*;
    import flash.system.*;
    import flash.geom.*;

    public class recycle extends MovieClip {

        var tc = 0;
        var bin;
        var subd;
        var cput = 0;
        var cget = 0;
        public var total;

        public function recycle(){
            this.bin = new Dictionary(true);
            this.subd = new Dictionary();
            super();
            addEventListener(Event.ENTER_FRAME, this.tick);
        }
        public function put(_arg1, _arg2){
            this.cput++;
            if ((this.bin[_arg1] is Dictionary)){
                this.bin[_arg1][_arg2] = true;
            } else {
                if (this.subd[_arg1]){
                    delete this.subd[_arg1];
                };
                this.subd[_arg1] = new Dictionary(true);
                this.subd[_arg1][_arg2] = true;
                this.bin[_arg1] = this.subd[_arg1];
            };
        }
        function grab(_arg1){
            var _local2:*;
            var _local3:*;
            this.cget++;
            if (!this.bin[_arg1]){
                return (null);
            };
            if ((this.bin[_arg1] is Dictionary)){
                _local2 = null;
                for (_local3 in this.bin[_arg1]) {
                    if (_local2){
                        return (_local2);
                    };
                    _local2 = _local3;
                    delete this.bin[_arg1][_local3];
                };
                delete this.subd[_arg1];
                delete this.bin[_arg1];
                return (_local2);
            };
            return (null);
        }
        function dump(_arg1=undefined){
            var _local3:*;
            var _local4:*;
            var _local5:*;
            var _local2:* = "";
            this.total = 0;
            if (_arg1 == undefined){
                _arg1 = this.bin;
            };
            for (_local3 in _arg1) {
                if ((_arg1[_local3] is Dictionary)){
                    _local4 = 0;
                    for (_local5 in _arg1[_local3]) {
                        _local4++;
                    };
                    _local2 = (_local2 + (((("(" + _local4) + ") ") + _local3) + ", "));
                    this.total = (this.total + _local4);
                } else {
                    _local2 = (_local2 + (("(1) " + _local3) + ", "));
                    this.total++;
                };
            };
            _local4 = 0;
            for (_local3 in this.subd) {
                _local4++;
            };
            _local2 = (_local2 + ((" (subd=" + _local4) + ")"));
            _local2 = (_local2 + (((((" Recycle Size: " + this.total) + " cput=") + this.cput) + " cget=") + this.cget));
            this.cget = (this.cput = 0);
            if (this.total == 0){
                _local2 = "";
            };
            return (_local2);
        }
        function tick(_arg1:Event){
            var _local2:*;
            var _local3:*;
            var _local4:*;
            this.tc++;
            if ((this.tc % 12) == 0){
                for (_local2 in this.subd) {
                    _local3 = 0;
                    for (_local4 in this.subd[_local2]) {
                        _local3 = 1;
                        break;
                    };
                    if (_local3 == 0){
                        delete this.subd[_local2];
                        delete this.bin[_local2];
                    };
                };
            };
        }

    }
}//package 
