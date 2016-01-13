package com.zombotron.gui
{
    import com.antkarlov.*;
    import com.zombotron.core.*;
    import flash.display.*;
    import flash.net.*;

    public class MainMenu extends BasicMenu
    {
        private var _authors:Sprite;
        private var _gameLogo:ElectronBoard;
        private static const SPONSOR_URL:String = "http://www.armorgames.com/";
        private static const SPONSOR_LIKE:String = "http://facebook.com/armorgames/";
        private static const AUTHORS:String = "mailto:zombotron.game@gmail.com";

        public function MainMenu()
        {
            return;
        }// end function

        private function onScores() : void
        {
            if (_game.agi != null)
            {
                addChild(_game.agi);
                _game.agi.showScoreboardList();
            }
            return;
        }// end function

        override public function hide() : void
        {
            _tm.clear();
            _tm.addTask(this.onHideLogo);
            var _loc_1:* = _elements.length;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                (_elements[int(_loc_2)] as TextButton).onClick = null;
                _tm.addTask(onHideElement, [_loc_2]);
                _tm.addPause(5);
                _loc_2++;
            }
            if (contains(_game.agi))
            {
                removeChild(_game.agi);
            }
            _tm.addTask(onComplete);
            return;
        }// end function

        private function onAchievements() : void
        {
            _game.nextScreen = Game.SCR_ACHIEVEMENT;
            this.hide();
            return;
        }// end function

        private function onMakeLogo() : Boolean
        {
            this._gameLogo = new ElectronBoard();
            this._gameLogo.kind = ElectronBoard.KIND_GAME_TITLE;
            this._gameLogo.x = int(App.SCR_HALF_W - this._gameLogo.boardWidth * 0.5);
            this._gameLogo.y = 64;
            addChild(this._gameLogo);
            this._gameLogo.start();
            return true;
        }// end function

        override public function free() : void
        {
            if (contains(this._gameLogo))
            {
                removeChild(this._gameLogo);
            }
            if (this._authors != null && contains(this._authors))
            {
                removeChild(this._authors);
            }
            super.free();
            return;
        }// end function

        private function onMoreGames() : void
        {
            var _loc_1:* = new URLRequest(SPONSOR_URL);
            navigateToURL(_loc_1, "_blank");
            return;
        }// end function

        private function onAuthors() : void
        {
            var _loc_1:* = new URLRequest(AUTHORS);
            navigateToURL(_loc_1);
            return;
        }// end function

        private function onSponsorLike() : void
        {
            var _loc_1:* = new URLRequest(SPONSOR_LIKE);
            navigateToURL(_loc_1, "_blank");
            return;
        }// end function

        private function onPlay() : void
        {
            var _loc_1:PopupNewGame = null;
            if (ZG.saveBox.isHaveSave == 1)
            {
                _loc_1 = new PopupNewGame();
                _loc_1.parentScreen = this;
                addChild(_loc_1);
                _loc_1.show();
            }
            else
            {
                MochiBot.track(this, "215d4e9a");
                this.doPlay();
            }
            return;
        }// end function

        private function onHideLogo() : Boolean
        {
            this._gameLogo.hide();
            return true;
        }// end function

        override public function show() : void
        {
            _tm.addTask(this.onMakeLogo);
            _tm.addPause(40);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W - 25, App.SCR_HALF_H - 58, Text.BTN_PLAY, TextButton.PLAY, this.onPlay]);
            _tm.addPause(5);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W + 55, App.SCR_HALF_H - 58, "", TextButton.ACHIEVEMENTS, this.onAchievements]);
            _tm.addPause(10);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W, App.SCR_HALF_H - 5, Text.BTN_MORE_GAMES, TextButton.MORE_GAMES, this.onMoreGames]);
            _tm.addPause(10);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W, App.SCR_HALF_H + 45, Text.BTN_SCORES, TextButton.SCORES, this.onScores]);
            _tm.addPause(5);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W, App.SCR_HALF_H + 123, "", TextButton.SPONSOR_LOGO, this.onMoreGames]);
            _tm.addPause(5);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W + 186, App.SCR_HALF_H + 130, "", TextButton.SPONSOR_LIKE, this.onSponsorLike]);
            _tm.addPause(5);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W, App.SCR_HALF_H + 189, "", TextButton.AUTHORS, this.onAuthors]);
            return;
        }// end function

        public function doPlay() : void
        {
            _game.nextScreen = Game.SCR_SELECT_LEVEL;
            this.hide();
            return;
        }// end function

    }
}
