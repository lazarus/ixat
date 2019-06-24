package {
    import flash.display.*;
    import flash.utils.*;

    public dynamic class library extends Sprite {

        public var type:String = null;
        public var ww = 0;
        public var hh = 0;
        public var xitem;

        public function library(_arg1:String){
            var _local2:Class;
            super();
            this.type = _arg1;
            if (this.ww == 0){
                _local2 = (getDefinitionByName(_arg1) as Class);
                this.xitem = new (_local2)();
                this.ww = this.xitem.width;
                this.hh = this.xitem.height;
                addChild(this.xitem);
            } else {
                this.xitem = this;
            };
        }
    }
}//package 
