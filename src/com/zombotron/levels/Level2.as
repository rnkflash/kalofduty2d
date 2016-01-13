package com.zombotron.levels
{

    public class Level2 extends LevelBase
    {
        public static const MISSION_INFO:Array = [{task:"buy new weapon on this level", desc:"you have purchased a new weapon", condition:LevelBase.MISSION_SHOPING, value:1}, {task:"blow up 10 enemies on this level", desc:"you blew up 10 enemies on this level", condition:LevelBase.MISSION_BOOM, value:10}, {task:"kill robots and collect 2 their heads", desc:"you have collected 2 robot\'s heads", condition:LevelBase.MISSION_ROBOT, value:2}];

        public function Level2()
        {
            levelNum = 2;
            return;
        }// end function

        override public function load(param1:Boolean = true) : void
        {
            _container = new Level2_mc();
            _background = new Level2BG_mc();
            setLevelSize(20, 9);
            super.load(param1);
            return;
        }// end function

    }
}
