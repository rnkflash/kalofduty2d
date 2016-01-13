package com.zombotron.levels
{

    public class Level7 extends LevelBase
    {
        public static const MISSION_INFO:Array = [{task:"make a mega kill on this level", desc:"awesome mega kill!", condition:LevelBase.MISSION_MEGAKILL, value:1}, {task:"collect 95 coins on this level", desc:"you have collected 95 coins on this level", condition:LevelBase.MISSION_COIN, value:95}, {task:"finish this level by making no more than 80 shots", desc:"you finished the level in less than 80 shots", condition:LevelBase.MISSION_SILENT, value:80}];

        public function Level7()
        {
            levelNum = 7;
            return;
        }// end function

        override public function load(param1:Boolean = true) : void
        {
            _container = new Level7_mc();
            _background = new Level7BG_mc();
            setLevelSize(20, 9);
            super.load(param1);
            return;
        }// end function

    }
}
