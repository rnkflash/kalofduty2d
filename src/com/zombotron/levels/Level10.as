package com.zombotron.levels
{

    public class Level10 extends LevelBase
    {
        public static const MISSION_INFO:Array = [{task:"find and collect 5 bags", desc:"you have collected 5 bags", condition:LevelBase.MISSION_BAG, value:5}, {task:"collect 50 coins on this level", desc:"you have collected 50 coins on this level", condition:LevelBase.MISSION_COIN, value:50}, {task:"finish this level by making no more than 80 shots", desc:"you finished the level in less than 80 shots", condition:LevelBase.MISSION_SILENT, value:80}];

        public function Level10()
        {
            levelNum = 10;
            return;
        }// end function

        override public function load(param1:Boolean = true) : void
        {
            _container = new Level10_mc();
            _background = new Level10BG_mc();
            setLevelSize(20, 5);
            super.load(param1);
            return;
        }// end function

    }
}
