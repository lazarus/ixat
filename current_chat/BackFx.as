// Decompiled by AS3 Sorcerer 3.32
// http://www.as3sorcerer.com/

//BackFx

package {
    import flash.display.MovieClip;
    import flash.utils.Dictionary;
    import flash.geom.Matrix;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.events.IOErrorEvent;
    import flash.display.GradientType;
    import flash.display.SpreadMethod;
    import flash.display.InterpolationMethod;
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.filters.*;

    public dynamic class BackFx extends MovieClip {

        public static var TickDict = new Dictionary(true);
        private static var lut15 = new Array(128, 180, 222, 249, 254, 238, 203, 154, 102, 53, 18, 2, 7, 34, 76);
        private static var usefA = {
            "1":18,
            "3":72,
            "4":144
        };
        private static var RepeatA = {
            "2":4,
            "3":8
        };
        private static var growthcycleA = {
            "1":12,
            "3":72
        };
        private static var growthA = {
            "1":0,
            "3":0.2,
            "4":0.3
        };

        public var Debug:Boolean = false;
        private var gh:int;
        private var gw:int;
        private var uid:int;
        private var hmod = 1;
        private var MODE = 0;
        private var usef = 36;
        private var Rot:int = 45;
        private var Repeat = 2;
        private var gradienttype;
        private var colors:Array;
        private var alphas:Array;
        private var ratios:Array;
        private var matrix:Matrix;
        private var spread;
        private var interpolation;
        private var focalpoint:int;
        private var tc = 0;
        private var min;
        private var max;
        private var dif;
        private var growth;
        private var growthcycle;
        private var scale;
        private var dir;
        private var sinlut;
        private var coslut;
        private var BitMapLoader;
		private var Ruby;
		public var ep;
        private var Canvas;
        var mc;
        var c:Class;
        var bmp;
        var bd2:BitmapData;
        var bmp2:Bitmap;

        public function BackFx(){
            this.sinlut = new Array();
            this.coslut = new Array();
            this.Canvas = new Sprite();
            super();
        }
        public static function MasterTick(e:*=0){
            var key:* = undefined;
            for (key in TickDict) {
                try {
                    key.tick();
                } catch(e) {
                    delete TickDict[key];
                };
            };
        }

        public function Make(_arg_1:*, _arg_2:int, _arg_3:int, _arg_4:int, powerid:int = 426){
            if (!(_arg_1 is Array)){
                return;
            };
            this.addChild(this.Canvas);
            this.gh = _arg_2;
            this.gw = _arg_3;
            this.uid = _arg_4;
			switch (_arg_1[1]){
				case "flag":
				case "jewel":
					this.MakeImage1(_arg_1);
					break;
				default:
					this.MakeGrad(_arg_1, powerid);
            };
            if (this.MODE != 0){
                this.min = 0;
                this.max = (this.Canvas.width / 2);
                this.dif = -(Math.abs((this.min - this.max)));
                TickDict[this] = 1;
                addEventListener(Event.REMOVED_FROM_STAGE, this.cleanUp, false, 0, true);
            };
        }
		
		//Techy ~ Fix for invalid flags causes text to be invis
        private function LoadedFail(_arg_1:*){
			var _local_2:* = "xat";
			removeChild(this.BitMapLoader);
            this.BitMapLoader = new Loader();
            var _local_4:String = xatlib.SmilieUrl(_local_2, "sm2/flag");
            if (this.Debug){
                _local_4 = (("http://www.xatech.com/images/sm2/flag/" + _local_2) + ".swf");
            };
            var _local_5:URLRequest = new URLRequest(_local_4);
            this.BitMapLoader.load(_local_5);
            this.BitMapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.ImageLoaded);
            this.BitMapLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.LoadedFail);
            addChild(this.BitMapLoader);
        }
		
        private function ImageLoaded(_arg_1:Event){
            var _local_2:*;
            if (this.BitMapLoader.contentLoaderInfo.applicationDomain.hasDefinition("flag")){
                this.c = (this.BitMapLoader.contentLoaderInfo.applicationDomain.getDefinition("flag") as Class);
            };
            if (this.c){
                this.mc = (new this.c() as MovieClip);
				if (this.Ruby){
					xatlib.McSetRGB(this.mc.col0, this.Ruby);
				};
            };
            if (!this.mc){
                //this.mc = new xatsat();
				this.mc = this.BitMapLoader;
            };
            this.bd2 = new BitmapData(this.gw, this.gh, false, 0xFFFFFF);
            this.bmp2 = new Bitmap(this.bd2, "auto", true);
            this.Canvas.addChild(this.bmp2);
            this.scale = (this.gw / this.mc.width);
            if ((((((this.MODE == 2)) || ((this.MODE == 3)))) || ((this.MODE == 4)))){
                if ((this.gw / this.mc.height) > this.scale){
                    this.scale = (this.gw / this.mc.height);
                };
                this.hmod = (2 / 3);
            } else {
                if (this.MODE == 5){
                    this.hmod = (2 / 3);
                    this.scale = (this.scale / this.hmod);
                };
            };
            if ((((this.MODE == 3)) || ((this.MODE == 4)))){
                _local_2 = 0;
                while (_local_2 < this.growthcycle) {
                    if ((((this.MODE == 3)) || ((this.MODE == 4)))){
                        this.sinlut[_local_2] = Math.sin(((2 * Math.PI) * (_local_2 / this.growthcycle)));
                    };
                    if (this.MODE == 4){
                        this.coslut[_local_2] = Math.cos(((2 * Math.PI) * (_local_2 / this.growthcycle)));
                    };
                    _local_2++;
                };
            };
            if (this.MODE == 5){
                _local_2 = 0;
                while (_local_2 < this.usef) {
                    this.sinlut[_local_2] = Math.sin(((2 * Math.PI) * (_local_2 / this.usef)));
                    _local_2++;
                };
            };
        }
        private function MakeImage1(_arg_1:Array){
			var _local_5:String;
			var _local_7:*;
			var _local_8:*;
			var _local_9:*;
			var _local_10:*;
			var _local_11:int;
			var _local_12:*;
            this.MODE = 4;
            this.usef = 72;
            this.growthcycle = 36;
            this.growth = 0.1;
            this.dir = 1;
			var _local_2:int = 3;
			var _local_3:* = _arg_1[2];
			if (_arg_1[1] == "jewel"){
				this.Ruby = xatlib.DecodeColor(_arg_1[2], "v");
				if (!this.Ruby){
					_local_2 = 2;
					if (this.ep){
						this.Ruby = 1089554;
					} else {
						this.Ruby = 14423100;
					};
				} else {
					if (!this.ep){
						_local_7 = ((this.Ruby >> 16) & 0xFF);
						_local_8 = ((this.Ruby >> 8) & 0xFF);
						_local_9 = (this.Ruby & 0xFF);
						if (_local_8 > _local_7){
							_local_8 = _local_7;
						};
						if (_local_8 > _local_9){
							_local_8 = _local_9;
						};
						this.Ruby = (((_local_7 << 16) + (_local_8 << 8)) + _local_9);
					};
				};
			} else {
				if (!_local_3){
					_local_3 = "xat";
				};
				_local_3 = _local_3.replace(/[^0-9a-zA-Z]/g, "");
			};
			var _local_4:* = _local_2;
			while (_local_4 < _arg_1.length) {
				_local_10 = _arg_1[_local_4];
				if (_local_10){
					_local_10 = _local_10.toString();
					_local_12 = _local_10.charAt(0);
					_local_11 = int(_local_10.substr(1));
					if (_local_12 == "r"){
                        this.MODE = 2;
                    } else {
                        if (_local_12 == "e"){
                            this.MODE = 3;
                        } else {
                            if (_local_12 == "f"){
                                this.usef = usefA[_local_11];
                                if (!this.usef){
                                    this.usef = 36;
                                };
                            } else {
                                if (_local_12 == "u"){
                                    this.MODE = 5;
                                } else {
                                    if (_local_12 == "c"){
                                        this.growthcycle = growthcycleA[_local_11];
                                        if (!this.growthcycle){
                                            this.growthcycle = 36;
                                        };
                                    } else {
                                        if (_local_12 == "g"){
                                            this.growth = growthA[_local_11];
                                            if (!this.growth){
                                                this.growth = 0.1;
                                            };
                                        } else {
                                            if (_local_12 == "d"){
                                                this.dir = -1;
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
                _local_4++;
            };
            this.BitMapLoader = new Loader();
			if (this.Ruby){
				_local_5 = xatlib.SmilieUrl("ruby", "misc");
			} else {
				_local_5 = xatlib.SmilieUrl(_local_3, "sm2/flag");
				if (this.Debug){
					_local_5 = (("http://www.xatech.com/images/sm2/flag/" + _local_3) + ".swf");
				};
            };
            var _local_6:URLRequest = new URLRequest(_local_5);
            this.BitMapLoader.load(_local_6);
            this.BitMapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.ImageLoaded);
            this.BitMapLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.LoadedFail);
            addChild(this.BitMapLoader);
        }
        private function MakeGrad(_arg_1:Array, powerid:*){
            var _local_2:int;
            var _local_4:*;
            var _local_5:int;
            var _local_6:*;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            this.MODE = ((todo.HasPower(this.uid, powerid)) ? 1 : 0);
            this.alphas = [];
            this.ratios = [];
            var _local_3:int;
            this.gradienttype = GradientType.LINEAR;
            this.colors = new Array();
            _local_2 = 2;
            while (_local_2 < _arg_1.length) {
                _local_4 = _arg_1[_local_2];
                if (_local_4){
                    _local_4 = _local_4.toString();
                    _local_6 = _local_4.charAt(0);
                    _local_5 = int(_local_4.substr(1));
                    if (_local_6 == "r"){
                        this.Rot = _local_5;
                    } else {
                        if (_local_6 == "s"){
                            _local_3 = _local_5;
                        } else {
                            if (_local_6 == "f"){
                                this.usef = usefA[_local_5];
                                if (!this.usef){
                                    this.usef = 36;
                                };
                            } else {
                                if (_local_6 == "o"){
                                    this.Repeat = RepeatA[_local_5];
                                    if (!this.Repeat){
                                        this.Repeat = 2;
                                    };
                                } else {
                                    _local_4 = int(_local_4);
                                    if (!_local_4) break;
                                    this.colors.push(_local_4);
                                };
                            };
                        };
                    };
                };
                _local_2++;
            };
            if (this.colors.length > 15){
                this.colors.length = 15;
            };
            if (this.colors.length < 2){
                _local_7 = 0;
                while (_local_7 < 15) {
                    _local_8 = lut15[((_local_7 + _local_3) % 15)];
                    _local_9 = lut15[(((_local_7 + _local_3) + 10) % 15)];
                    _local_10 = lut15[(((_local_7 + _local_3) + 5) % 15)];
                    this.colors[_local_7] = (((_local_8 << 16) + (_local_9 << 8)) + _local_10);
                    _local_7++;
                };
            };
            if (this.MODE == 1){
                if (this.Rot > 45){
                    this.Rot = 45;
                } else {
                    if (this.Rot < -45){
                        this.Rot = -45;
                    };
                };
                this.Rot = ((Math.atan(((Math.tan(((this.Rot * Math.PI) / 180)) * this.gh) / this.gw)) * 180) / Math.PI);
            };
            if (this.MODE == 1){
                if (this.colors[0] != this.colors[(this.colors.length - 1)]){
                    if (this.colors.length < 15){
                        this.colors.push(this.colors[0]);
                    } else {
                        this.colors[14] = this.colors[0];
                    };
                };
            };
            _local_2 = 0;
            while (_local_2 < this.colors.length) {
                this.alphas.push(1);
                this.ratios.push(Math.round(((_local_2 * 0xFF) / (this.colors.length - 1))));
                _local_2++;
            };
            this.spread = (((this.MODE == 1)) ? SpreadMethod.REPEAT : SpreadMethod.REFLECT);
            this.interpolation = InterpolationMethod.RGB;
            this.focalpoint = 0;
            this.DrawGrad();
        }
        private function DrawGrad(){
            if (this.MODE == 1){
                this.gw = (this.gw * 2);
            };
            var _local_1:* = 0;
            var _local_2:* = ((2 * Math.cos(((this.Rot * Math.PI) / 180))) * this.gw);
            var _local_3:* = ((2 * Math.sin(((this.Rot * Math.PI) / 180))) * this.gh);
            var _local_4:* = ((_local_1 * _local_2) / 72);
            var _local_5:* = ((_local_1 * _local_3) / 72);
            this.matrix = new Matrix();
            this.matrix.createGradientBox((((this.MODE == 1)) ? (this.gw / this.Repeat) : this.gw), this.gh, ((this.Rot * Math.PI) / 180), _local_4, _local_5);
            this.Canvas.graphics.beginGradientFill(this.gradienttype, this.colors, this.alphas, this.ratios, this.matrix, this.spread, this.interpolation, this.focalpoint);
            this.Canvas.graphics.drawRect(0, 0, this.gw, this.gh);
            this.Canvas.graphics.endFill();
        }
        private function tick(_arg_1:*=0){
            var _local_6:*;
            if (((!(this.mc)) && (!((this.MODE == 1))))){
                return;
            };
            var _local_2:* = 0;
            var _local_3:* = 0;
            var _local_4:* = 0;
            var _local_5:* = 1;
            switch (this.MODE){
                case 1:
                    this.Canvas.x = (this.min + ((this.dif / (this.usef - 1)) * (this.tc % this.usef)));
                    break;
                case 2:
                    _local_4 = (((-360 / this.usef) * (this.tc % this.usef)) * this.dir);
                    _local_2 = (this.gw / 2);
                    _local_3 = (this.gh / 2);
                    _local_5 = this.scale;
                    break;
                case 3:
                    _local_4 = (((-360 / this.usef) * (this.tc % this.usef)) * this.dir);
                    _local_2 = (this.gw / 2);
                    _local_3 = (this.gh / 2);
                    _local_5 = ((this.scale + (this.scale * this.growth)) + ((this.scale * this.growth) * this.sinlut[(this.tc % this.growthcycle)]));
                    break;
                case 4:
                    _local_4 = (((-360 / this.usef) * (this.tc % this.usef)) * this.dir);
                    _local_2 = ((this.gw / 2) + ((this.gw * this.growth) * this.coslut[(this.tc % this.growthcycle)]));
                    _local_3 = ((this.gh / 2) + ((this.gw * this.growth) * this.sinlut[(this.tc % this.growthcycle)]));
                    _local_5 = (this.scale + ((this.scale * this.growth) * 2));
                    break;
                case 5:
                    _local_2 = (this.gw / 2);
                    _local_3 = ((this.gh / 2) + ((((this.mc.height * this.scale) - this.gh) / 2) * this.sinlut[(this.tc % this.usef)]));
                    _local_5 = this.scale;
                    break;
            };
            if ((((((((this.MODE == 2)) || ((this.MODE == 3)))) || ((this.MODE == 4)))) || ((this.MODE == 5)))){
                _local_6 = new Matrix();
                _local_6.translate((-(this.mc.width) / 2), (-(this.mc.height) / 2));
                _local_6.scale((_local_5 * this.hmod), _local_5);
                _local_6.rotate(((_local_4 * Math.PI) / 180));
                _local_6.translate(_local_2, _local_3);
                this.bd2.draw(this.mc, _local_6);
            };
            this.tc++;
        }
        private function cleanUp(_arg_1:*=0){
            try {
                delete TickDict[this];
            } catch(e) {
            };
        }

    }
}//package 
