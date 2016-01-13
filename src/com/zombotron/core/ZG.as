package com.zombotron.core
{
    import com.antkarlov.anim.*;
    import com.antkarlov.controllers.*;
    import com.antkarlov.debug.*;
    import com.zombotron.gui.*;
    import com.zombotron.helpers.*;

    public class ZG extends Object
    {
        public static var universe:Universe;
        public static var hardcoreMode:Boolean;
        public static var saveBox:SaveBox;
        public static var sound:Function;
        public static var testMode:Boolean;
        public static var debugMode:Boolean;
        public static var console:Console;
        public static var key:KeyController;
        public static var playerGui:PlayerGui;
        public static var media:SoundManager;
        public static var animCache:AnimationCache;
        public static var game:Game;

        public function ZG()
        {
            return;
        }// end function

        public static function setData() : void
        {
            game = Game.getInstance();
            media = SoundManager.getInstance();
            sound = media.sound;
            animCache = AnimationCache.getInstance();
            console = Console.getInstance();
            key = KeyController.getInstance();
            saveBox = new SaveBox();
            playerGui = PlayerGui.getInstance();
            debugMode = false;
            hardcoreMode = false;
            testMode = false;
            return;
        }// end function

        public static function divideString(param1:String, param2:int) : Array
        {
            var _loc_4:Array = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:int = 0;
            var _loc_3:Array = [];
            if (param1.length > param2)
            {
                _loc_4 = param1.split(" ");
                _loc_5 = "";
                _loc_6 = "";
                _loc_7 = 0;
                while (_loc_7 < _loc_4.length)
                {
                    
                    _loc_5 = _loc_5 + (_loc_4[_loc_7] + " ");
                    if (_loc_5.length > param2)
                    {
                        _loc_3[_loc_3.length] = _loc_6;
                        var _loc_8:* = _loc_4[_loc_7] + " ";
                        _loc_5 = _loc_4[_loc_7] + " ";
                        _loc_6 = _loc_8;
                    }
                    else
                    {
                        _loc_6 = _loc_5;
                    }
                    _loc_7++;
                }
                _loc_3[_loc_3.length] = _loc_6;
            }
            else
            {
                _loc_3[_loc_3.length] = param1;
            }
            return _loc_3;
        }// end function

    }
}
