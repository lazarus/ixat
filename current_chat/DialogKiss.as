package {
    import flash.display.*;

    public class DialogKiss extends Sprite {

        public function DialogKiss(_arg1){
            if (_arg1.Mode == null){
                _arg1.Mode = 0;
            };
            if (_arg1.SubMode == null){
                _arg1.SubMode = 0;
            };
            if (_arg1.Front == null){
                _arg1.Front = "";
            };
            if (_arg1.Message == null){
                _arg1.Message = "";
            };
            xkiss.CreateBuystuff(_arg1.Marry, _arg1.Mode, _arg1.SubMode, _arg1.Front, _arg1.Message);
        }
        function Delete(){
            main.closeDialog();
        }

    }
}//package 
