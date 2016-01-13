package com.zombotron.gui
{
    import com.zombotron.core.*;
    import flash.net.*;

    public class CongratsMenu extends BasicMenu
    {
        private var _finalResult:int = 0;
        private static const AUTHORS:String = "mailto:zombotron.game@gmail.com";
        private static const SPONSOR_URL:String = "http://www.armorgames.com/";

        public function CongratsMenu()
        {
            return;
        }// end function

        override public function hide() : void
        {
            var _loc_1:TextButton = null;
            _tm.clear();
            var _loc_2:* = _elements.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (_elements[_loc_3] is TextButton)
                {
                    _loc_1 = _elements[_loc_3] as TextButton;
                    _loc_1.onClick = null;
                    _tm.addTask(onHideElement, [_loc_3]);
                    _tm.addPause(1);
                }
                else
                {
                    onHideElement(_loc_3);
                }
                _loc_3++;
            }
            if (contains(_game.agi))
            {
                removeChild(_game.agi);
            }
            _tm.addTask(onComplete);
            return;
        }// end function

        private function onMainMenu() : void
        {
            _game.nextScreen = Game.SCR_MAIN_MENU;
            this.hide();
            return;
        }// end function

        private function onAuthors() : void
        {
            var _loc_1:* = new URLRequest(AUTHORS);
            navigateToURL(_loc_1);
            return;
        }// end function

        override public function free() : void
        {
            super.free();
            return;
        }// end function

        override public function show() : void
        {
            ZG.playerGui.removeHotkeys();
            ZG.media.musicReset();
            ZG.media.playTrack("track1");
            _tm.addTask(onMakeLabel, [90, 76, "you are great warrior", TextLabel.TEXT8]);
            _tm.addPause(10);
            _tm.addTask(onMakeLabel, [90, 88, "congratulations!", TextLabel.TEXT16]);
            _tm.addPause(40);
            _tm.addTask(onMakeLabel, [90, 121, "your main mission has been completed.", TextLabel.TEXT8]);
            _tm.addPause(50);
            _tm.addTask(onMakeLabel, [90, 130, "but it\'s not over..", TextLabel.TEXT8]);
            _tm.addPause(40);
            _tm.addTask(onMakeLabel, [90, 139, "to be continued...", TextLabel.TEXT8]);
            _tm.addPause(50);
            _tm.addTask(onMakeLabel, [90, 186, "results:", TextLabel.TEXT16]);
            _tm.addPause(10);
            _tm.addTask(onMakeLabel, [90, 220, "enemies killed:" + ZG.saveBox.getTotalKilled().toString(), TextLabel.TEXT8]);
            _tm.addPause(10);
            _tm.addTask(onMakeLabel, [90, 229, "coins collected:" + ZG.saveBox.totalCoins.toString(), TextLabel.TEXT8]);
            _tm.addPause(10);
            _tm.addTask(onMakeLabel, [90, 238, "objects destroyed: " + ZG.saveBox.destroyedObjects.toString(), TextLabel.TEXT8]);
            _tm.addPause(10);
            _tm.addTask(onMakeLabel, [90, 247, "total shots: " + ZG.saveBox.getTotalShots().toString(), TextLabel.TEXT8]);
            _tm.addPause(10);
            _tm.addTask(onMakeLabel, [90, 256, "missions completed: " + ZG.saveBox.missions.length.toString(), TextLabel.TEXT8]);
            _tm.addPause(20);
            this._finalResult = ZG.saveBox.calcFinalResult();
            _tm.addTask(onMakeLabel, [90, 278, "and your final score: ", TextLabel.TEXT8]);
            _tm.addPause(50);
            _tm.addTask(onMakeLabel, [90, 290, this._finalResult.toString(), TextLabel.TEXT16]);
            _tm.addPause(40);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W + 98, App.SCR_HALF_H - 63, "", TextButton.SPONSOR_LOGO_BIG, this.onPlayMore]);
            _tm.addPause(15);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W + 98, App.SCR_HALF_H + 70, "", TextButton.AUTHORS, this.onAuthors]);
            _tm.addPause(15);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W - 175, App.SCR_HALF_H + 151, Text.BTN_MAIN_MENU, TextButton.MAIN_MENU, this.onMainMenu]);
            _tm.addPause(5);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W, App.SCR_HALF_H + 151, Text.BTN_SUBMIT_SCORE, TextButton.BASIC, this.onSubmit]);
            _tm.addPause(5);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W + 177, App.SCR_HALF_H + 151, Text.BTN_PLAY_MORE, TextButton.MAIN_MENU, this.onPlayMore]);
            return;
        }// end function

        private function onSubmit() : void
        {
            if (_game.agi != null)
            {
                addChild(_game.agi);
                _game.agi.showScoreboardSubmit(this._finalResult);
            }
            return;
        }// end function

        private function onPlayMore() : void
        {
            var _loc_1:* = new URLRequest(SPONSOR_URL);
            navigateToURL(_loc_1, "_blank");
            return;
        }// end function

    }
}
