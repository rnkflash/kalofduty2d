package com.zombotron.levels
{

    public class Level3 extends LevelBase
    {
        public static const MISSION_INFO:Array = [{task:"finish this level by making no more than 60 shots", desc:"you finished the level in less than 60 shots", condition:LevelBase.MISSION_SILENT, value:60}, {task:"destroy 12 barrels on this level", desc:"you have 12 destroyed barrels on this level", condition:LevelBase.MISSION_BARREL, value:12}, {task:"collect 40 coins on this level", desc:"you have collected 40 coins on this level", condition:LevelBase.MISSION_COIN, value:40}];

        public function Level3()
        {
            levelNum = 3;
            return;
        }// end function

        override public function load(param1:Boolean = true) : void
        {
            _container = new Level3_mc();
            _background = new Level3BG_mc();
            setLevelSize(20, 9);
            super.load(param1);
            return;
        }// end function

    }
}
