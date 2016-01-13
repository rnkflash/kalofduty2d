package com.zombotron.events
{
    import flash.events.*;

    public class CompleteLevelEvent extends Event
    {
        public var nextLevel:int = 0;
        public var nextEntry:String = "";
        public static const LEVEL_COMPLETE:String = "CompleteLevelEvent";

        public function CompleteLevelEvent(param1:int, param2:String, param3:String, param4:Boolean = false, param5:Boolean = false)
        {
            this.nextLevel = param1;
            this.nextEntry = param2;
            super(param3, param4, param5);
            return;
        }// end function

    }
}
