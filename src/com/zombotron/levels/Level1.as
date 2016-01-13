package com.zombotron.levels
{

    public class Level1 extends LevelBase
    {
        public static const MISSION_INFO:Array = [{task:"finish level in less than 150 sec", desc:"you finished the level in less than 150 sec", condition:LevelBase.MISSION_TIME, value:150}, {task:"collect 25 coins on this level", desc:"you have collected 25 coins on this level", condition:LevelBase.MISSION_COIN, value:25}, {task:"kill zombies and collect 10 their heads", desc:"you have collected 10 zombie heads", condition:LevelBase.MISSION_ZOMBIE, value:10}];

        public function Level1()
        {
            levelNum = 1;
            return;
        }// end function

        override public function load(param1:Boolean = true) : void
        {
            _container = new Level1_mc();
            _background = new Level1BG_mc();
            setLevelSize(17, 9);
            super.load(param1);
            return;
        }// end function

    }
}
