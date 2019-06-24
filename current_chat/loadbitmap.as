package {
    import flash.events.*;
    import flash.display.*;
    import flash.net.*;
    import flash.utils.*;
    import flash.geom.*;

    public class loadbitmap extends MovieClip {

        private static var doms = {
            imgur:"com",
            postimg:"cc",
            postimage:"org"
        };
        private static const doms_cd = {
            xat:"com",
            xatech:"com"
        };

        private static var ccnt = 0;
        private static var cdic = new Dictionary();
        public static var TickDict = new Dictionary(true);

        private var m_urlStream;
        private var m_Loader;
        private var m_data:ByteArray;
        private var m_read;
        private var m_width;
        private var m_height;
        public var Url;
        private var pass = 0;
        private var m_Handler;
        private var dom1:String;
        private var dom2:String;
        public var bitmap;
        private var Retry:int = 0;
        private var RetryCnt:int = 0;

        public function loadbitmap(_arg1, _arg2, _arg3=80, _arg4=80, _arg5=null){
            var _local6:*;
            var _local7:Bitmap;
            super();
            if (_arg1){
                _arg1.addChild(this);
            };
			this.Url = _arg2.split("#");
			this.Url = this.Url[0];
			if (this.Url){
				this.Url = xatlib.UrlAv(this.Url);
            };
            this.SetDom();
            if (((!(this.dom1)) || ((this.Url.toLowerCase().indexOf(".swf") >= 0)))){
                this.DoHandler();
                return;
            };
            this.m_width = _arg3;
            this.m_height = _arg4;
            ccnt++;
            this.m_Handler = _arg5;
            if (cdic[this.Url]){
                _local7 = new Bitmap(cdic[this.Url].bmp.bitmapData.clone());
                cdic[this.Url].cnt = ccnt;
                cdic[this.Url].bmp = _local7;
                addChild(_local7);
                this.DoHandler();
                return;
            };
            this.LoadIt();
        }
        public static function MasterTick(){
            var _local1:*;
            for (_local1 in TickDict) {
                _local1.tick();
            };
        }

        private function LoadIt(){
            var _local1:URLRequest;
            if (((todo.bMobile) || ((doms_cd[this.dom1] === this.dom2)))){
                this.m_data = new ByteArray();
                this.m_read = 0;
                _local1 = new URLRequest(this.Url);
                this.m_urlStream = new URLStream();
                this.m_urlStream.addEventListener(Event.COMPLETE, this.streamComplete, false, 0, true);
                this.m_urlStream.addEventListener(ProgressEvent.PROGRESS, this.streamProgress, false, 0, true);
                this.m_urlStream.addEventListener(IOErrorEvent.IO_ERROR, this.binevent, false, 0, true);
                this.m_urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.secErr, false, 0, true);
                this.m_urlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler, false, 0, true);
                this.m_urlStream.load(_local1);
                /*
                 * will need to edit some stuff in steamComplete for if it's a gif
                var player:GIFPlayer = new GIFPlayer();
                player.loadBytes(this.m_data);

                addChild(player);
                */
            } else {
                this.secErr();
            };
        }
        private function DoHandler(_arg1=null){
            if (TickDict[this]){
                delete TickDict[this];
            };
            if (this.m_Handler){
                this.m_Handler();
            };
            this.m_Handler = null;
        }
        private function streamProgress(_arg1:ProgressEvent):void{
            var _local2:*;
            this.pass++;
            if (this.m_urlStream.bytesAvailable >= 2){
                _local2 = this.m_urlStream.bytesAvailable;
                this.m_urlStream.readBytes(this.m_data, this.m_read, _local2);
                this.m_read = (this.m_read + _local2);
                if (((((((!((this.pass == 1))) || ((((this.m_data[0] == 0xFF)) && ((this.m_data[1] == 216)))))) || ((((this.m_data[0] == 71)) && ((this.m_data[1] == 73)))))) || ((((this.m_data[0] == 137)) && ((this.m_data[1] == 80)))))){
                } else {
                    this.m_urlStream.close();
                    this.m_urlStream = null;
                    this.DoHandler();
                };
            };
        }
        private function streamComplete(_arg1:Event):void{
            this.m_urlStream.readBytes(this.m_data, this.m_read, this.m_urlStream.bytesAvailable);
            this.m_urlStream.close();
            this.m_urlStream = null;
            this.m_Loader = new Loader();
            this.m_Loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loaderComplete, false, 0, true);
            this.m_Loader.addEventListener(IOErrorEvent.IO_ERROR, this.passevent, false, 0, true);
            this.m_Loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.passevent, false, 0, true);
            this.m_Loader.loadBytes(this.m_data);
        }
        private function loaderComplete(_arg1:Event):void{
            var outputBitmapData:* = null;
            var old:* = undefined;
            var key:* = undefined;
            var e:* = _arg1;
            var tt:* = this;
            var src:* = this.m_Loader.contentLoaderInfo.content;
            var srcRect:* = DisplayObject(src).getBounds(DisplayObject(src));
            if ((((srcRect.width == 1)) && ((srcRect.height == 1)))){
                this.httpStatusHandler({status:202});//503});
                return;
            };
            //new GIFImage?
            var srcBitmapData:* = new BitmapData(srcRect.width, srcRect.height, true, 0);
            srcBitmapData.draw(src);
            this.m_Loader.unloadAndStop(true);
            this.m_Loader = null;
            if (this.m_height == 0){
                this.bitmap = srcBitmapData;
                this.DoHandler();
                return;
            };
            var zwidth:* = srcRect.width;
            var zheight:* = srcRect.height;
            if ((((this.m_height == 80)) && (((srcBitmapData.width / srcBitmapData.height) >= 2)))){
                if (zheight > 80){
                    zheight = 80;
                };
                zwidth = int(((zheight * srcBitmapData.width) / srcBitmapData.height));
            } else {
                if (zheight > this.m_height){
                    zheight = this.m_height;
                };
                if (zwidth > this.m_width){
                    zwidth = this.m_width;
                };
            };
            var matrix:* = new Matrix();
            matrix.scale((zwidth / srcBitmapData.width), (zheight / srcBitmapData.height));
            try {
                outputBitmapData = new BitmapData(zwidth, zheight, true, 0);
            } catch(e:Error) {
                DoHandler();
                return;
            };
            var smoothing:* = true;
            if ((((zheight == srcRect.width)) && ((zwidth == srcRect.height)))){
                matrix = null;
                smoothing = false;
            };
            outputBitmapData.draw(srcBitmapData, matrix, null, null, null, smoothing);
            if ((src is DisplayObject)){
                srcBitmapData.dispose();
            };
            var bmp:* = new Bitmap(outputBitmapData);
            bmp.smoothing = true;
            addChild(bmp);
            if ((((((this.m_height == 80)) || ((this.m_height == 30)))) || ((this.m_height == 0)))){
                cdic[this.Url] = new Object();
                cdic[this.Url].cnt = ccnt;
                cdic[this.Url].bmp = bmp;
                old = (ccnt - 50);
                for (key in cdic) {
                    if (cdic[key].cnt < old){
                        delete cdic[key];
                    };
                };
            };
            this.DoHandler();
        }
        private function httpStatusHandler(_arg1):void{
            if ((((((_arg1.status == 503)) || ((_arg1.status == 599)))) || ((_arg1.status == 202)))){
                TickDict[this] = 1;
                if (this.Retry < 4){
                    this.Retry++;
                    this.RetryCnt = (this.Retry * 12);
                    return;
                };
                this.DoHandler();
            };
        }
        private function tick(){
            this.RetryCnt--;
            if (this.RetryCnt == 0){
                this.LoadIt();
                return;
            };
        }
        private function passevent(_arg1:Event):void{
            dispatchEvent(_arg1);
        }
        private function binevent(_arg1:Event):void{
        }
        private function SetDom():void{
            var _local1:* = this.Url.split("//");
			_local1[0] = _local1[0].toLowerCase();
			if (((!((_local1[0] === "http:"))) && (!((_local1[0] === "https:"))))){
				return;
			};
            if (!_local1[1]){
                return;
            };
            _local1 = _local1[1].split("/");
            _local1 = _local1[0].toLowerCase();
            _local1 = _local1.split(".");
            var _local2:* = _local1.length;
            this.dom1 = _local1[(_local2 - 2)];
            this.dom2 = _local1[(_local2 - 1)];
        }
        private function secErr(_arg1=0):void{
            var _local2:*;
            if (this.m_urlStream){
                this.m_urlStream.close();
                this.m_urlStream = null;
            };
            this.m_Loader = new Loader();
			this.Url = this.Url.replace(/;'"`#&\./g, "");
            if (doms[this.dom1] === this.dom2){
                _local2 = this.Url;
            } else {
               // _local2 = xatlib.iMux(((((("GetImage5.php?W=" + this.m_width) + "&H=") + this.m_height) + "&U=") + this.Url));
			   _local2 = this.Url;
            };
            var _local3:URLRequest = new URLRequest(_local2);
            this.m_Loader.load(_local3);
            addChild(this.m_Loader);
            this.m_Loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.DoHandler);
            this.m_Loader.addEventListener(IOErrorEvent.IO_ERROR, this.passevent);
        }

    }
}//package 
