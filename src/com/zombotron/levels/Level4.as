package com.zombotron.levels
{

    public class Level4 extends LevelBase
    {
        public static const MISSION_INFO:Array = [{task:"make a mega kill on this level", desc:"Awesome mega kill!", condition:LevelBase.MISSION_MEGAKILL, value:1}, {task:"kill skeletons and collect 3 their heads", desc:"you have collected 3 skeleton heads", condition:LevelBase.MISSION_SKELETON, value:3}, {task:"find 5 chests on this level", desc:"you found 5 chests", condition:LevelBase.MISSION_CHEST, value:5}];

        public function Level4()
        {
            levelNum = 4;
            return;
        }// end function

        override public function load(param1:Boolean = true) : void
        {
            _container = new Level4_mc();
            _background = new Level4BG_mc();
            setLevelSize(20, 9);
            super.load(param1);
            return;
        }// end function

    }
}
