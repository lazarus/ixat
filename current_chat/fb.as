package {
    import flash.display.*;

    public dynamic class fb extends MovieClip {

        public var hold:MovieClip;

        public function fb(){
            addFrameScript(0, this.frame1);
        }
        function frame1(){
            new xBut(this.hold, 0, 0, 32, 32, "", undefined, xBut.b_NoPress, 8, 3889560);
        }

    }
}//package 
