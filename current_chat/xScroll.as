package {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;

    class xScroll extends Sprite {

        var Scr_x:Number;
        var Scr_y:Number;
        var Scr_width:Number;
        var Scr_height:Number;
        var Scr_buttonheight:Number;
        var Scr_thumbheight:Number;
        var Scr_step:Number;
        public var Scr_size;
        var Scr_position;
        var scrollbackground:MovieClip;
        var mcScrollUp:xBut;
        var mcScrollDown:xBut;
        var mcThumb:xBut;
        var ChangeFunc;
        var Scrolling;
        var ScrollPressed;

        public function xScroll(_arg1, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:Number, _arg7:Number, _arg8:Number, _arg9:Number, _arg10:Number, _arg11){
            if (_arg1 != undefined){
                _arg1.addChild(this);
            };
            this.Scr_x = _arg2;
            this.Scr_y = _arg3;
            this.Scr_width = _arg4;
            this.Scr_height = _arg5;
            this.Scr_buttonheight = _arg6;
            this.Scr_thumbheight = _arg7;
            this.Scr_step = _arg8;
            this.Scr_size = _arg9;
            this.Scr_position = _arg10;
            this.ChangeFunc = _arg11;
            this.Scrolling = false;
            this.ScrollPressed = false;
            var _local12:* = xatlib.AddBackground(this, (this.Scr_x - 1), this.Scr_y, (this.Scr_width + 1), this.Scr_height, true);
            _local12.alpha = 0.4;
			_local12.addEventListener(MouseEvent.CLICK, this.onScrollClick);//techy
            this.mcScrollUp = new xBut(this, this.Scr_x, this.Scr_y, this.Scr_width, this.Scr_buttonheight, "", this.onScrollUp, 0, 6);
            this.mcScrollUp.gfx = new library("sc_up");
            this.mcScrollUp.gfx.x = int(((this.Scr_width - 6) / 2));
            this.mcScrollUp.gfx.y = int(((this.Scr_buttonheight - 3) / 2));
            this.mcScrollUp.addChild(this.mcScrollUp.gfx);
            this.mcScrollDown = new xBut(this, this.Scr_x, ((this.Scr_y + this.Scr_height) - this.Scr_buttonheight), this.Scr_width, this.Scr_buttonheight, "", this.onScrollDown, 0, 6);
            this.mcScrollDown.gfx = new library("sc_dn");
            this.mcScrollDown.gfx.x = int(((this.Scr_width - 6) / 2));
            this.mcScrollDown.gfx.y = int(((this.Scr_buttonheight - 3) / 2));
            this.mcScrollDown.addChild(this.mcScrollDown.gfx);
            this.mcThumb = new xBut(this, this.Scr_x, (((this.Scr_y + this.Scr_height) - this.Scr_buttonheight) - this.Scr_thumbheight), this.Scr_width, this.Scr_thumbheight, "", null, xBut.b_NoPress, 6);
            this.mcThumb.gfx = new library("sc_dr");
            this.mcThumb.buttonMode = true;
            this.mcThumb.gfx.x = int(((this.Scr_width - 6) / 2));
            this.mcThumb.gfx.y = int(((this.Scr_thumbheight - 7) / 2));
            this.mcThumb.addChild(this.mcThumb.gfx);
            this.mcThumb.addEventListener(MouseEvent.MOUSE_DOWN, this.onThumb);
            this.mcThumb.addEventListener(MouseEvent.MOUSE_UP, this.onThumbRelease);
            this.Update();
            this.RefreshColor();
        }
		//Techy ~ clicking & holding scroll buttons will continue to scroll
		function onScrollUp(e:Event):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, onScrollUpRelease);
			addEventListener(Event.ENTER_FRAME, scrollUpTick);
		}

		function onScrollUpRelease(e:Event):void {
			removeEventListener(Event.ENTER_FRAME,scrollUpTick);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onScrollUpRelease);
		}
		
		function scrollUpTick(e:Event):void {
            this.ScrollPressed = true;
            this.Scr_position = (this.Scr_position - this.Scr_step);
            if (this.Scr_position < 0){
                this.Scr_position = 0;
            };
            this.ChangeFunc();
            this.Update();
		}
		//end
		
		//Techy ~ clicking scroll background to move there
        function onScrollClick(_arg1:Event):*
        {
			this.ScrollPressed = true;
			var _local2:* = ((stage.mouseY - this.Scr_y) - this.Scr_buttonheight);
            var _local3:* = (((this.Scr_height - this.Scr_buttonheight) - this.Scr_buttonheight) - this.Scr_thumbheight);
            this.Scr_position = ((this.Scr_size * _local2) / _local3);
            if (this.Scr_position > this.Scr_size)
            {
                this.Scr_position = this.Scr_size;
            };
            this.ChangeFunc();
			this.Update();
        }
		//end
		
		function onScrollDown(e:Event):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, onScrollDownRelease);
			addEventListener(Event.ENTER_FRAME,scrollDownTick);
		}

		function onScrollDownRelease(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, scrollDownTick);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onScrollDownRelease);
		}

		function scrollDownTick(e:Event):void {
            this.ScrollPressed = true;
            this.Scr_position = (this.Scr_position + this.Scr_step);
            if (this.Scr_position > this.Scr_size){
                this.Scr_position = this.Scr_size;
            };
            this.ChangeFunc();
            this.Update();
		}
        public function RefreshColor(){
            this.mcScrollUp.RefreshColor();
            this.mcScrollDown.RefreshColor();
            this.mcThumb.RefreshColor();
            xatlib.McSetRGB(this.mcScrollUp.gfx.xitem.back, todo.ButColW);
            xatlib.McSetRGB(this.mcScrollDown.gfx.xitem.back, todo.ButColW);
        }
        function onThumb(_arg1:Event){
            this.Scrolling = true;
            this.mcThumb.startDrag(false, new Rectangle(this.Scr_x, (this.Scr_y + this.Scr_buttonheight), 0, ((this.Scr_height - this.Scr_thumbheight) - (this.Scr_buttonheight * 2))));
            stage.addEventListener(MouseEvent.MOUSE_UP, this.onThumbRelease);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onThumbMouseMove);
        }
        function onThumbRelease(_arg1:Event){
            this.Scrolling = false;
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.onThumbRelease);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onThumbMouseMove);
            this.mcThumb.stopDrag();
        }
        function onThumbMouseMove(_arg1:Event){
            var _local2:* = ((this.mcThumb.y - this.Scr_y) - this.Scr_buttonheight);
            var _local3:* = (((this.Scr_height - this.Scr_buttonheight) - this.Scr_buttonheight) - this.Scr_thumbheight);
            this.Scr_position = ((this.Scr_size * _local2) / _local3);
            this.ChangeFunc();
        }
        function set position(_arg1:Number){
            this.Scr_position = _arg1;
            this.Update();
        }
        function set ssize(_arg1:Number){
            this.Scr_size = _arg1;
            this.Update();
        }
        function Update(){
            if (this.Scr_position < 0){
                this.Scr_position = 0;
            };
            this.mcThumb.y = ((this.Scr_y + this.Scr_buttonheight) + (((((this.Scr_height - this.Scr_buttonheight) - this.Scr_buttonheight) - this.Scr_thumbheight) * this.Scr_position) / this.Scr_size));
        }
        function Delete(){
        }

    }
}//package 
