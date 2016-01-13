package com.zombotron.levels
{

    public class Level5 extends LevelBase
    {
        public static const MISSION_INFO:Array = [{task:"finish level in less than 180 sec", desc:"you finished the level in less than 180 sec", condition:LevelBase.MISSION_TIME, value:180}, {task:"blow up 10 enemies on this level", desc:"you blew up 10 enemies on this level", condition:LevelBase.MISSION_BOOM, value:10}, {task:"destroy 15 boxes on this level", desc:"you have 15 destroyed boxes on this level", condition:LevelBase.MISSION_BOX, value:15}];

        public function Level5()
        {
            levelNum = 5;
            return;
        }// end function

        override public function load(param1:Boolean = true) : void
        {
            _container = new Level5_mc();
            _background = new Level5BG_mc();
            setLevelSize(20, 9);
            super.load(param1);
            return;
        }// end function

    }
}
