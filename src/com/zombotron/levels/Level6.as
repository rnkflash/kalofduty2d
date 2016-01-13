package com.zombotron.levels
{

    public class Level6 extends LevelBase
    {
        public static const MISSION_INFO:Array = [{task:"find and collect 7 bags", desc:"you have collected 7 bags", condition:LevelBase.MISSION_BAG, value:7}, {task:"kill zombies and collect 6 their heads", desc:"you have collected 6 zombie heads", condition:LevelBase.MISSION_ZOMBIE, value:6}, {task:"buy new weapon on this level", desc:"you have purchased a new weapon", condition:LevelBase.MISSION_SHOPING, value:1}];

        public function Level6()
        {
            levelNum = 6;
            return;
        }// end function

        override public function load(param1:Boolean = true) : void
        {
            _container = new Level6_mc();
            _background = new Level6BG_mc();
            setLevelSize(20, 9);
            super.load(param1);
            return;
        }// end function

    }
}
