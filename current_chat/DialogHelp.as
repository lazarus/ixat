package {
    import flash.events.*;
    import com.adobe.serialization.json.*;
    import flash.display.*;
    import flash.net.*;
	
	import flash.utils.ByteArray;

    public class DialogHelp extends Sprite {

        public var HelpText;
        public var mchelpbackb;
        public var mchelpbackground;
        public var mchelpback;
        public var mchelpbackmask;
        public var bhelpscrollmc;
        public var helpinc = 0;
        public var bpw;
        public var bph;
        public var bpx;
        public var bpy;

        public function DialogHelp(_arg1=0){
            var _local7:URLRequest;
            var _local8:URLLoader;
            super();
            this.HelpText = undefined;
            if (_arg1 == 1){
                _local7 = new URLRequest();
                _local7.url = (todo.usedomain + "/terms.php?z4");
                _local7.method = URLRequestMethod.GET;
                _local8 = new URLLoader();
                _local8.load(_local7);
                _local8.addEventListener(Event.COMPLETE, this.Handler);
            };
            if (_arg1 == 2){
                _local7 = new URLRequest();
                _local7.url = (todo.usedomain + "/changes.php?z4");
                _local7.method = URLRequestMethod.GET;
                _local8 = new URLLoader();
                _local8.load(_local7);
                _local8.addEventListener(Event.COMPLETE, this.Handler);
            };
            this.mchelpbackground = new xDialog(this, xatlib.NX(20), xatlib.NY(20), xatlib.NX(600), xatlib.NY(440), (" " + xconst.ST(14)), undefined, 0, this.Delete);
            var _local2:* = this.mchelpbackground.Dia;
            var _local3:* = 36;
            var _local4:* = 137;
            var _local5:* = new xBut(this.mchelpbackground, xatlib.NX(_local3), xatlib.NY(60), xatlib.NX(135), xatlib.NY(26), xconst.ST(291), this.FAQPress, (xatlib.c_bl + xatlib.c_br));
            _local3 = (_local3 + _local4);
            var _local6:* = new xBut(this.mchelpbackground, xatlib.NX(_local3), xatlib.NY(60), xatlib.NX(135), xatlib.NY(26), xconst.ST(292), this.TermsPress, (xatlib.c_bl + xatlib.c_br));
            _local3 = (_local3 + _local4);
            var _local9:* = new xBut(this.mchelpbackground, xatlib.NX(_local3), xatlib.NY(60), xatlib.NX(135), xatlib.NY(26), "Changelog", this.ChangesPress, (xatlib.c_bl + xatlib.c_br));
            _local3 = (_local3 + _local4);
            _local2.mcreturn2 = new xBut(this.mchelpbackground, xatlib.NX(240), xatlib.NY(420), xatlib.NX(160), xatlib.NY(30), xconst.ST(45), this.OK_onRelease);
            this.bpw = xatlib.NX(580);
            this.bph = (xatlib.NY((390 - 30)) - 40);
            this.bpx = xatlib.NX(30);
            this.bpy = (xatlib.NY((20 + 25)) + 40);
            this.mchelpbackb = xatlib.AddBackground(this.mchelpbackground, this.bpx, this.bpy, this.bpw, this.bph);
            this.mchelpback = new MovieClip();
            this.mchelpbackb.addChild(this.mchelpback);
            this.mchelpback.Width = this.bpw;
            this.mchelpbackmask = xatlib.AddBackground(this.mchelpbackground, (this.bpx + 1), (this.bpy + 1), ((this.bpw - 2) - xatlib.NX(16)), (this.bph - 2), xatlib.c_Mask);
            this.mchelpback.mask = this.mchelpbackmask;
            this.bhelpscrollmc = new xScroll(this.mchelpbackground, ((this.bpx + this.bpw) - xatlib.NX(16)), this.bpy, xatlib.NX(16), this.bph, xatlib.NX(16), xatlib.NX(32), 30, (10 * 100), (0 * 100), this.onHelpScrollChange);
            if (_arg1 == 0){
                this.Displayhelp();
            };
        }
        function Delete(){
            main.hint.HintOff();
            if (this.mchelpbackground){
                this.mchelpbackground.Delete();
            };
            main.closeDialog();
        }
		function OK_onRelease(_arg_1:MouseEvent=undefined){
			this.Delete();
		}
        function Displayhelp(){
            var _local1:*;
            var _local2:*;
            this.helpinc = 0;
            //this.AddHelpLine(todo.usedomain + "/wiki for detailed help.");
            //this.AddHelpLine("");
            for (_local1 in xconst.HelpTable) {
                _local2 = xconst.HelpTable[_local1];
                if (_local2.substr(0, 3) == "BB "){
                    _local2 = (("<b> " + _local2.substr(3)) + " </b>");
                };
                this.AddHelpLine(_local2);
            };
            this.AddHelpLine("");
            this.AddHelpLine("Edit: <b> " + chat.cVersion + " </b>");
            this.AddHelpLine("<b> Maintained by </b> Andy, Austin, Techy");
			
            this.onHelpScrollChange();
        }
        function Handler(_arg_1:Event){
            var _local_2:*;
            this.helpinc = 0;
            var _local_3:URLLoader = URLLoader(_arg_1.target);
            var _local_4:* = _local_3.data;
            var _local_5:* = _local_4.split("<");
            if (_local_5.length > 500){
                _local_5.length = 500;
            };
            var _local_6:* = 0;
            while (_local_6 < _local_5.length) {
                _local_2 = _local_5[_local_6].charAt(0);
                if (_local_2 == "/"){
                    this.AddHelpLine("");
                } else {
                    if (_local_2 == "p"){
                        _local_2 = _local_5[_local_6].split(">");
                        if (_local_2[1]){
                            if (_local_2[1].substr(0, 3) == "BB "){
								_local_2[1] = ("<b> " + _local_2[1].substr(3)) + " </b>";
							};
							this.AddHelpLine(_local_2[1]);
                        };
                    } else {
                        if (_local_2 == "b"){
                            this.AddHelpLine(_local_5[_local_6].substr(4));
                        };
                    };
                };
                _local_6++;
            };
            this.onHelpScrollChange();
        }
        function AddHelpLine(_arg1:String){
            var _local2:* = new MovieClip();
            this.mchelpback.addChild(_local2);
            _local2.x = 5;
            this.helpinc = (this.helpinc + (4 + xmessage.AddMessageToMc(_local2, 4, _arg1, 0, (this.mchelpback.Width - 30), this.helpinc)));
        }
        function onHelpScrollChange(){
            var _local1:* = ((this.helpinc - this.bph) + 4);
            if (_local1 < 0){
                _local1 = 0;
            };
            this.bhelpscrollmc.Scr_size = _local1;
            var _local2:* = this.bhelpscrollmc.Scr_position;
            this.mchelpback.y = -(_local2);
        }
        function FAQPress(_arg1:Event){
            main.openDialog(5, 0);
        }
        function TermsPress(_arg1:Event){
            main.openDialog(5, 1);
        }
        function ChangesPress(_arg1:Event){
            main.openDialog(5, 2);
        }
        function tick(_arg1:Event){
        }
    }
}//package 
