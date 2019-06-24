package {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;

    public class cachedSprite extends Sprite {

        public static const cs_RollOver = 1;
        private static const TTL:int = 60;

        public static var dic:Dictionary = new Dictionary();

        var bd:BitmapData;
        var Frames:int;
        var Pending:Boolean = true;
        var Timeout:int = 0;
        public var Flags:int = 0;

        public static function Tidy(){
            var _local1:*;
            var _local2:*;
            for (_local1 in dic) {
                _local2 = dic[_local1];
                _local2.Timeout++;
                if (_local2.Timeout > TTL){
                    if (_local2.bd){
                        _local2.bd.dispose();
                    };
                    delete dic[_local1];
                };
            };
        }

    }
}//package 
