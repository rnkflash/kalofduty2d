package com.zombotron.levels
{

    public class Level8 extends LevelBase
    {
        public static const MISSION_INFO:Array = [{task:"finish level in less than 300 sec", desc:"you finished the level in less than300 sec", condition:LevelBase.MISSION_TIME, value:300}, {task:"find and collect 8 bags", desc:"you have collected 8 bags", condition:LevelBase.MISSION_BAG, value:8}, {task:"kill skeletons and collect 20 of their heads", desc:"you have collected 20 skeleton heads", condition:LevelBase.MISSION_SKELETON, value:20}];

        public function Level8()
        {
            levelNum = 8;
            return;
        }// end function

        override public function load(param1:Boolean = true) : void
        {
            _container = new Level8_mc();
            _background = new Level8BG_mc();
            setLevelSize(20, 9);
            super.load(param1);
            return;
        }// end function

    }
}
