package com.zombotron.gui
{
    import com.antkarlov.controllers.*;
    import com.antkarlov.managers.*;
    import com.zombotron.core.*;
    import com.zombotron.levels.*;
    import flash.display.*;
    import flash.net.*;

    public class PauseMenu extends BasicMenu
    {
        private var _heroParts:Array;
        private var _popupMission:PopupMission;
        private var _statParts:Array;
        private var _internalTm:TaskManager;
        private var _resumeToGame:Boolean = false;
        private var _weapon:MovieClip;
        private static const SPONSOR_URL:String = "http://www.armorgames.com/";

        public function PauseMenu()
        {
            this._heroParts = new Array(17);
            this._statParts = new Array(7);
            this._internalTm = new TaskManager();
            return;
        }// end function

        private function onHideMenu() : void
        {
            ZG.game.hideMenu();
            return;
        }// end function

        override public function hide() : void
        {
            var _loc_1:TextButton = null;
            this.removeHotkeys();
            _tm.clear();
            this._popupMission.hide();
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
            this._internalTm.clear();
            this._internalTm.addTask(this.onHideStats);
            if (this._resumeToGame)
            {
                _tm.addInstantTask(this.onHideMenu);
                _tm.addPause(5);
            }
            _tm.addTask(onComplete);
            return;
        }// end function

        private function onMakeStat(param1:int, param2:int, param3:int) : Boolean
        {
            var _loc_4:MovieClip = null;
            if (this._statParts[param1] == null)
            {
                _loc_4 = new Stats_mc();
                _loc_4.x = param2;
                _loc_4.y = param3;
                _loc_4.alpha = 0;
                _loc_4.gotoAndStop((param1 + 1));
                addChild(_loc_4);
                this._statParts[param1] = _loc_4;
            }
            _loc_4 = this._statParts[param1];
            _loc_4.alpha = _loc_4.alpha + 0.5;
            if (_loc_4.alpha >= 1)
            {
                _loc_4.alpha = 1;
                return true;
            }
            return false;
        }// end function

        private function onMakeHeroPart(param1:int) : Boolean
        {
            var _loc_2:MovieClip = null;
            if (this._heroParts[param1] == null)
            {
                _loc_2 = new HeroStats_mc();
                _loc_2.x = 143;
                _loc_2.y = 140 + 10 * param1;
                _loc_2.alpha = 0;
                _loc_2.gotoAndStop((param1 + 1));
                addChild(_loc_2);
                this._heroParts[param1] = _loc_2;
            }
            _loc_2 = this._heroParts[param1];
            _loc_2.alpha = _loc_2.alpha + 0.5;
            if (_loc_2.alpha >= 1)
            {
                _loc_2.alpha = 1;
                return true;
            }
            return false;
        }// end function

        private function removeHotkeys() : void
        {
            ZG.key.unregister(KeyCode.SPACEBAR);
            ZG.key.unregister(KeyCode.ESC);
            ZG.key.unregister(KeyCode.P);
            return;
        }// end function

        private function onHideStats() : Boolean
        {
            var _loc_1:MovieClip = null;
            var _loc_2:int = 0;
            var _loc_3:* = this._heroParts.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_1 = this._heroParts[_loc_2] as MovieClip;
                if (_loc_1 != null)
                {
                    _loc_1.alpha = _loc_1.alpha - 0.1;
                }
                _loc_2++;
            }
            _loc_3 = this._statParts.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_1 = this._statParts[_loc_2] as MovieClip;
                if (_loc_1 != null)
                {
                    _loc_1.alpha = _loc_1.alpha - 0.1;
                }
                _loc_2++;
            }
            if (this._weapon != null)
            {
                this._weapon.alpha = this._weapon.alpha - 0.1;
            }
            if (_loc_1 != null && _loc_1.alpha <= 0)
            {
                return true;
            }
            return false;
        }// end function

        private function onPlayMore() : void
        {
            var _loc_1:* = new URLRequest(SPONSOR_URL);
            navigateToURL(_loc_1, "_blank");
            return;
        }// end function

        private function onMakeWeapon(param1:int, param2:int, param3:uint) : Boolean
        {
            if (this._weapon == null)
            {
                switch(param3)
                {
                    case 1:
                    {
                        param2 = param2 - 2;
                        break;
                    }
                    case 3:
                    {
                        param2 = param2 + 5;
                        break;
                    }
                    case 5:
                    {
                        param2 = param2 + 10;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this._weapon = new ShopIcons_mc();
                this._weapon.x = param1;
                this._weapon.y = param2;
                this._weapon.alpha = 0;
                this._weapon.gotoAndStop(param3);
                addChild(this._weapon);
            }
            this._weapon.alpha = this._weapon.alpha + 0.5;
            if (this._weapon.alpha >= 1)
            {
                this._weapon.alpha = 1;
                return true;
            }
            return false;
        }// end function

        private function onResume() : void
        {
            _game.nextScreen = Game.SCR_GAME;
            this._resumeToGame = true;
            ZG.media.musicResume();
            ZG.media.soundResume();
            this.hide();
            return;
        }// end function

        private function onLevels() : void
        {
            _game.nextScreen = Game.SCR_SELECT_LEVEL;
            this._resumeToGame = false;
            ZG.media.musicReset();
            ZG.media.playTrack("track1");
            this.hide();
            return;
        }// end function

        private function onRestart() : void
        {
            var _loc_1:* = Universe.getInstance();
            if (!_loc_1.isRestarting)
            {
                _loc_1.restartLevel();
            }
            ZG.media.musicReset();
            this.onResume();
            return;
        }// end function

        override public function free() : void
        {
            var _loc_1:MovieClip = null;
            var _loc_2:* = this._heroParts.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_1 = this._heroParts[_loc_3] as MovieClip;
                if (_loc_1 != null && contains(_loc_1))
                {
                    removeChild(_loc_1);
                }
                this._heroParts[_loc_3] = null;
                _loc_3++;
            }
            _loc_2 = this._statParts.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_1 = this._statParts[_loc_3] as MovieClip;
                if (_loc_1 != null && contains(_loc_1))
                {
                    removeChild(_loc_1);
                }
                this._statParts[_loc_3] = null;
                _loc_3++;
            }
            if (this._weapon != null && contains(this._weapon))
            {
                removeChild(this._weapon);
            }
            this._weapon = null;
            this._heroParts.length = 0;
            this._statParts.length = 0;
            this._internalTm.clear();
            super.free();
            return;
        }// end function

        override public function show() : void
        {
            ZG.media.musicPause();
            ZG.media.soundPause();
            _tm.addTask(onMakeLabel, [70, 73, Text.TXT_BIOBOT_STATISTICS, TextLabel.TEXT8]);
            _tm.addPause(10);
            _tm.addTask(onMakeLabel, [70, 84, Text.TXT_PAUSE_SCREEN, TextLabel.TEXT16]);
            _tm.addPause(40);
            this._popupMission = new PopupMission();
            this._popupMission.x = 393;
            this._popupMission.y = 147;
            var _loc_1:* = LevelBase.getMissions(ZG.game.nextStage);
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                this._popupMission.addMission(_loc_1[_loc_2].condition, _loc_1[_loc_2].task, _loc_1[_loc_2].desc, ZG.saveBox.isMissionCompleted(ZG.game.nextStage, _loc_2));
                _loc_2++;
            }
            this._popupMission.show();
            addChild(this._popupMission);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W - 199, App.SCR_H - 83, Text.BTN_LEVELS, TextButton.SCORES, this.onLevels]);
            _tm.addPause(8);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W - 76, App.SCR_H - 83, Text.BTN_RESTART, TextButton.RESTART, this.onRestart]);
            _tm.addPause(5);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W + 47, App.SCR_H - 83, Text.BTN_RESUME, TextButton.SCORES, this.onResume]);
            _tm.addPause(5);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W + 181, App.SCR_H - 83, Text.BTN_PLAY_MORE, TextButton.MAIN_MENU, this.onPlayMore]);
            _tm.addPause(15);
            _tm.addTask(onMakeLabel, [App.SCR_HALF_W - 81, App.SCR_H - 49, Text.TXT_PRESS_SPACEBAR_TO_RESUME, TextLabel.TEXT8]);
            _tm.addTask(this.onSetHotkeys);
            this._internalTm.addPause(30);
            _loc_2 = 0;
            while (_loc_2 < 17)
            {
                
                this._internalTm.addTask(this.onMakeHeroPart, [_loc_2]);
                _loc_2++;
            }
            this._internalTm.addTask(this.onMakeStat, [0, 230, 155]);
            this._internalTm.addTask(onMakeLabel, [253, 127, Text.TXT_DEATHS, TextLabel.TEXT8]);
            this._internalTm.addTask(onMakeLabel, [253, 137, ZG.saveBox.deaths.toString(), TextLabel.TEXT8]);
            this._internalTm.addTask(this.onMakeStat, [1, 254, 204]);
            this._internalTm.addTask(onMakeLabel, [276, 176, Text.TXT_PLAYTIME, TextLabel.TEXT8]);
            this._internalTm.addTask(onMakeLabel, [276, 186, ZG.saveBox.getPlayTime(), TextLabel.TEXT8]);
            this._internalTm.addTask(this.onMakeStat, [2, 257, 249]);
            this._internalTm.addTask(onMakeLabel, [279, 268, Text.TXT_FAVOURITE_GUN, TextLabel.TEXT8]);
            this._internalTm.addTask(this.onMakeWeapon, [279, 277, ZG.saveBox.getFavouriteWeapon()]);
            this._internalTm.addTask(this.onMakeStat, [3, 213, 310]);
            this._internalTm.addTask(onMakeLabel, [91, 329, Text.TXT_COVERED_DISTANCE, TextLabel.TEXT8]);
            this._internalTm.addTask(onMakeLabel, [91, 339, ZG.saveBox.getCoveredDistance() + Text.TXT_MILES, TextLabel.TEXT8]);
            this._internalTm.addTask(this.onMakeStat, [4, 162, 270]);
            this._internalTm.addTask(onMakeLabel, [71, 284, Text.TXT_TOTAL_COINS, TextLabel.TEXT8]);
            this._internalTm.addTask(onMakeLabel, [71, 294, ZG.saveBox.totalCoins.toString(), TextLabel.TEXT8]);
            this._internalTm.addTask(this.onMakeStat, [5, 143, 234]);
            this._internalTm.addTask(onMakeLabel, [71, 253, Text.TXT_ACCURACY, TextLabel.TEXT8]);
            this._internalTm.addTask(onMakeLabel, [71, 263, ZG.saveBox.getAccuracy().toString() + "%", TextLabel.TEXT8]);
            this._internalTm.addTask(this.onMakeStat, [6, 181, 185]);
            this._internalTm.addTask(onMakeLabel, [71, 157, Text.TXT_KILLED_ENEMIES, TextLabel.TEXT8]);
            this._internalTm.addPause(5);
            this._internalTm.addTask(onMakeLabel, [71, 167, ZG.saveBox.zombiesKilled.toString() + Text.TXT_KILLED_ZOMBIES, TextLabel.TEXT8]);
            var _loc_3:int = 167;
            if (ZG.saveBox.robotsKilled > 0)
            {
                _loc_3 = _loc_3 + 8;
                this._internalTm.addPause(5);
                this._internalTm.addTask(onMakeLabel, [71, _loc_3, ZG.saveBox.robotsKilled.toString() + Text.TXT_KILLED_ROBOTS, TextLabel.TEXT8]);
            }
            if (ZG.saveBox.skeletonsKilled > 0)
            {
                _loc_3 = _loc_3 + 8;
                this._internalTm.addPause(5);
                this._internalTm.addTask(onMakeLabel, [71, _loc_3, ZG.saveBox.skeletonsKilled.toString() + Text.TXT_KILLED_SKELETONS, TextLabel.TEXT8]);
            }
            _loc_3 = _loc_3 + 8;
            this._internalTm.addPause(5);
            this._internalTm.addTask(onMakeLabel, [71, _loc_3, ZG.saveBox.getTotalKilled().toString() + Text.TXT_KILLED_TOTAL, TextLabel.TEXT8]);
            return;
        }// end function

        private function onSetHotkeys() : Boolean
        {
            ZG.key.register(this.onResume, KeyCode.SPACEBAR);
            ZG.key.register(this.onResume, KeyCode.ESC);
            ZG.key.register(this.onResume, KeyCode.P);
            return true;
        }// end function

    }
}
