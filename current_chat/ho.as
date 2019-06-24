package {
    import flash.display.*;

    public dynamic class ho extends MovieClip {

        public var hold:MovieClip;

        public function ho(){
            addFrameScript(0, this.frame1);
        }
        function frame1(){
		//Techy ~ remove last argument to make homeicon same color as chat buttons
            new xBut(this.hold, 0, 0, 32, 32, "", undefined, xBut.b_NoPress, 8, 122623);
        }

    }
}//package 
