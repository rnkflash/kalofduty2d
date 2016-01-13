package com.zombotron.levels
{

    public class Level9 extends LevelBase
    {
        public static const MISSION_INFO:Array = [{task:"blow up 15 enemies on this level", desc:"you blew up 15 enemies on this level", condition:LevelBase.MISSION_BOOM, value:15}, {task:"destroy 15 barrels on this level", desc:"you have 15 destroyed barrels on this level", condition:LevelBase.MISSION_BARREL, value:15}, {task:"find 7 chest on this level", desc:"you found 7 chests", condition:LevelBase.MISSION_CHEST, value:7}];

        public function Level9()
        {
            levelNum = 9;
            return;
        }// end function

        override public function load(param1:Boolean = true) : void
        {
            _container = new Level9_mc();
            _background = new Level9BG_mc();
            setLevelSize(20, 9);
            super.load(param1);
            return;
        }// end function

    }
}
