package {
    import flash.display.*;

    public dynamic class chatmain extends MovieClip {

        public var c;

        public function chatmain(){
            addFrameScript(0, this.frame1);
        }
        function frame1(){
            this.c = new chat();
            parent.addChild(this.c);
            stop();
        }

    }
}//package 
