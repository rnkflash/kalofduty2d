package com.zombotron.gui
{
    import com.zombotron.core.*;
    import com.zombotron.levels.*;

    public class LoadingScreen extends BasicMenu
    {
        private var _popupMission:PopupMission;
        private var _blinkOut:Boolean = true;
        private var _blinkLabel:TextLabel;

        public function LoadingScreen()
        {
            return;
        }// end function

        private function onHide() : Boolean
        {
            this.alpha = this.alpha - 0.2;
            if (this.alpha <= 0)
            {
                this.alpha = 0;
                return true;
            }
            return false;
        }// end function

        private function onBlink() : Boolean
        {
            if (this._blinkOut)
            {
                this._blinkLabel.alpha = this._blinkLabel.alpha - 0.2;
                if (this._blinkLabel.alpha <= 0)
                {
                    this._blinkLabel.alpha = 0;
                    this._blinkOut = false;
                }
            }
            else
            {
                this._blinkLabel.alpha = this._blinkLabel.alpha + 0.2;
                if (this._blinkLabel.alpha >= 1)
                {
                    this._blinkLabel.alpha = 1;
                    this._blinkOut = true;
                }
            }
            return false;
        }// end function

        override public function hide() : void
        {
            _tm.clear();
            this._popupMission.hide();
            _tm.addTask(this.onHide);
            _tm.addPause(5);
            _tm.addTask(onComplete);
            return;
        }// end function

        override public function free() : void
        {
            super.free();
            return;
        }// end function

        private function onSetBlinkLabel() : void
        {
            this._blinkLabel = _elements[(_elements.length - 1)] as TextLabel;
            return;
        }// end function

        override public function show() : void
        {
            this._popupMission = new PopupMission();
            this._popupMission.x = 362;
            this._popupMission.y = 162;
            var _loc_1:* = LevelBase.getMissions(_game.nextStage);
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                this._popupMission.addMission(_loc_1[_loc_2].condition, _loc_1[_loc_2].task, _loc_1[_loc_2].desc, ZG.saveBox.isMissionCompleted(_game.nextStage, _loc_2));
                _loc_2++;
            }
            this._popupMission.show();
            addChild(this._popupMission);
            _tm.addPause(20);
            _tm.addInstantTask(onMakeLabel, [100, 229, Text.TXT_PLEASE_WAIT, TextLabel.TEXT8]);
            _tm.addPause(10);
            _tm.addInstantTask(onMakeLabel, [100, App.SCR_HALF_H, Text.TXT_LOADING_STAGE + _game.nextStage.toString(), TextLabel.TEXT16]);
            _tm.addPause(80);
            _tm.addInstantTask(this.onLoadLevel);
            _tm.addInstantTask(onMakeLabel, [100, App.SCR_HALF_H + 31, Text.TXT_GAME_PROGRESS_IS_SAVED, TextLabel.TEXT8]);
            _tm.addPause(20);
            _tm.addInstantTask(onMakeLabel, [100, App.SCR_HALF_H + 41, Text.TXT_PRESS_SPACE_TO_START, TextLabel.TEXT8]);
            _tm.addPause(5);
            _tm.addInstantTask(this.onSetBlinkLabel);
            _tm.addTask(this.onBlink);
            return;
        }// end function

        private function onLoadLevel() : void
        {
            _game.loadNextStage();
            return;
        }// end function

    }
}
