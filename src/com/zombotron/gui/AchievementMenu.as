package com.zombotron.gui
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.helpers.*;
    import flash.display.*;
    import flash.events.*;

    public class AchievementMenu extends BasicMenu
    {
        private var _sprite:Sprite;
        private var _achievements:Array;

        public function AchievementMenu()
        {
            this._achievements = [];
            return;
        }// end function

        private function doHideAchi(param1:int) : void
        {
            (this._achievements[param1] as AchievementItem).hide();
            return;
        }// end function

        private function onMakeAchieve(param1:int, param2:int, param3:uint, param4:Boolean, param5:int) : void
        {
            var _loc_6:* = new AchievementItem();
            _loc_6.x = param1;
            _loc_6.y = param2;
            addChild(_loc_6);
            _loc_6.show(param3, param4, param5);
            this._achievements[this._achievements.length] = _loc_6;
            return;
        }// end function

        override public function hide() : void
        {
            _tm.clear();
            var _loc_1:* = _elements.length;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                onHideElement(_loc_2);
                _loc_2++;
            }
            _loc_1 = this._achievements.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _tm.addInstantTask(this.doHideAchi, [_loc_2]);
                _tm.addPause(1);
                _loc_2++;
            }
            _tm.addPause(10);
            _tm.addTask(onComplete);
            return;
        }// end function

        private function mouseClickHandler(event:MouseEvent) : void
        {
            this._sprite.removeEventListener(MouseEvent.CLICK, this.mouseClickHandler);
            _game.nextScreen = Game.SCR_MAIN_MENU;
            this.hide();
            return;
        }// end function

        private function onMakeExit() : void
        {
            this._sprite = new GameBg_mc();
            this._sprite.alpha = 0;
            this._sprite.addEventListener(MouseEvent.CLICK, this.mouseClickHandler);
            addChild(this._sprite);
            return;
        }// end function

        override public function free() : void
        {
            removeChild(this._sprite);
            this._sprite = null;
            this._achievements.length = 0;
            super.free();
            return;
        }// end function

        override public function show() : void
        {
            _tm.addTask(onMakeLabel, [76, 62, Text.TXT_YOUR, TextLabel.TEXT8]);
            _tm.addPause(10);
            _tm.addTask(onMakeLabel, [76, 72, Text.TXT_ACHIEVEMENTS, TextLabel.TEXT16]);
            _tm.addPause(20);
            var _loc_1:* = ZG.saveBox;
            _tm.addInstantTask(this.onMakeAchieve, [76, 105, AchievementItem.SECOND_BLOOD, _loc_1.isHaveAchievement(AchievementItem.SECOND_BLOOD), Amath.toPercent(_loc_1.zombiesKilled, Kind.ACHI_SECOND_KILL)]);
            _tm.addPause(3);
            _tm.addInstantTask(this.onMakeAchieve, [326, 105, AchievementItem.BOMBERMAN, _loc_1.isHaveAchievement(AchievementItem.BOMBERMAN), Amath.toPercent(_loc_1.explodedEnemies, Kind.ACHI_BOMBERMAN)]);
            _tm.addPause(3);
            _tm.addInstantTask(this.onMakeAchieve, [76, 158, AchievementItem.BUTCHER, _loc_1.isHaveAchievement(AchievementItem.BUTCHER), Amath.toPercent(_loc_1.zombiesKilled, Kind.ACHI_BUTCHER)]);
            _tm.addPause(3);
            _tm.addInstantTask(this.onMakeAchieve, [326, 158, AchievementItem.UNDEAD_KILLER, _loc_1.isHaveAchievement(AchievementItem.UNDEAD_KILLER), Amath.toPercent(_loc_1.skeletonsKilled, Kind.ACHI_UNDEAD_KILLER)]);
            _tm.addPause(3);
            _tm.addInstantTask(this.onMakeAchieve, [76, 211, AchievementItem.TASTE_IRON, _loc_1.isHaveAchievement(AchievementItem.TASTE_IRON), Amath.toPercent(_loc_1.robotsKilled, Kind.ACHI_TASTE_IRON)]);
            _tm.addPause(3);
            _tm.addInstantTask(this.onMakeAchieve, [326, 211, AchievementItem.TREASURE_HUNTER, _loc_1.isHaveAchievement(AchievementItem.TREASURE_HUNTER), Amath.toPercent(_loc_1.foundedSecrets, Kind.ACHI_TREASURE_HUNTER)]);
            _tm.addPause(3);
            _tm.addInstantTask(this.onMakeAchieve, [76, 264, AchievementItem.TINMAN, _loc_1.isHaveAchievement(AchievementItem.TINMAN), Amath.toPercent(_loc_1.robotsKilled, Kind.ACHI_TINMAN)]);
            _tm.addPause(3);
            _tm.addInstantTask(this.onMakeAchieve, [326, 264, AchievementItem.EXTERMINATOR, _loc_1.isHaveAchievement(AchievementItem.EXTERMINATOR), Amath.toPercent(_loc_1.exterminator, Kind.ACHI_EXTERMINATOR)]);
            _tm.addPause(3);
            _tm.addInstantTask(this.onMakeAchieve, [76, 317, AchievementItem.BIG_MONEY, _loc_1.isHaveAchievement(AchievementItem.BIG_MONEY), Amath.toPercent(ZG.saveBox.totalCoins, Kind.ACHI_BIG_MONEY)]);
            _tm.addPause(3);
            _tm.addInstantTask(this.onMakeAchieve, [326, 317, AchievementItem.CAREFUL, _loc_1.isHaveAchievement(AchievementItem.CAREFUL), Amath.toPercent(_loc_1.careful, Kind.ACHI_CAREFUL)]);
            _tm.addPause(3);
            _tm.addInstantTask(this.onMakeAchieve, [76, 370, AchievementItem.SILENT_KILLER, _loc_1.isHaveAchievement(AchievementItem.SILENT_KILLER), Amath.toPercent(_loc_1.silentKills, Kind.ACHI_SILENT_KILLER)]);
            _tm.addPause(3);
            _tm.addInstantTask(this.onMakeAchieve, [326, 370, AchievementItem.WINNER, _loc_1.isHaveAchievement(AchievementItem.WINNER), Amath.toPercent(ZG.saveBox.completedLevels, Kind.ACHI_WINNER)]);
            _tm.addPause(3);
            _tm.addTask(onMakeLabel, [201, 439, Text.TXT_CLICK_ANYWHERE_TO_EXIT, TextLabel.TEXT8]);
            _tm.addInstantTask(this.onMakeExit);
            return;
        }// end function

    }
}
