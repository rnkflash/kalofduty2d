package com.zombotron.gui
{
    import com.antkarlov.repositories.*;
    import com.zombotron.core.*;
    import flash.display.*;
    import flash.events.*;

    public class SelectLevelMenu extends BasicMenu
    {
        private var $:Global;
        private var _arrows:MovieClip;

        public function SelectLevelMenu()
        {
            this.$ = Global.getInstance();
            return;
        }// end function

        private function stageClickHandler(event:MouseEvent) : void
        {
            if (event.currentTarget is LevelButton)
            {
                _game.nextStage = (event.currentTarget as LevelButton).tag;
            }
            ZG.saveBox.loadPlayer(_game.nextStage);
            _game.nextScreen = Game.SCR_STAGE_LOADING;
            this.hide();
            return;
        }// end function

        override public function hide() : void
        {
            var _loc_1:TextButton = null;
            _tm.clear();
            _tm.addTask(this.onHideArrows);
            var _loc_2:* = _elements.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (_elements[_loc_3] is TextButton)
                {
                    _loc_1 = _elements[_loc_3] as TextButton;
                    _loc_1.onClick = null;
                    if (_loc_1.tag > 0)
                    {
                        _loc_1.removeEventListener(MouseEvent.CLICK, this.stageClickHandler);
                    }
                }
                _tm.addTask(onHideElement, [_loc_3]);
                _tm.addPause(1);
                _loc_3++;
            }
            _tm.addTask(onComplete);
            return;
        }// end function

        private function onShowArrows() : Boolean
        {
            this._arrows.alpha = this._arrows.alpha + 0.1;
            if (this._arrows.alpha >= 1)
            {
                this._arrows.alpha = 1;
                return true;
            }
            return false;
        }// end function

        private function onHideArrows() : Boolean
        {
            this._arrows.alpha = this._arrows.alpha - 0.1;
            if (this._arrows.alpha <= 0)
            {
                this._arrows.alpha = 0;
                return true;
            }
            return false;
        }// end function

        override public function free() : void
        {
            var _loc_2:BasicElement = null;
            removeChild(this._arrows);
            this._arrows = null;
            var _loc_1:* = _elements.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_1)
            {
                
                _loc_2 = _elements[_loc_3] as BasicElement;
                if (_loc_2 is TextButton && (_loc_2 as TextButton).tag > 0)
                {
                    _loc_2.removeEventListener(MouseEvent.CLICK, this.stageClickHandler);
                }
                _loc_2.free();
                _elements[_loc_3] = null;
                _loc_3++;
            }
            _elements.length = 0;
            _tm.clear();
            return;
        }// end function

        override public function show() : void
        {
            ZG.playerGui.removeHotkeys();
            _tm.addTask(onMakeLabel, [91, 76, Text.TXT_CONFIDENTIAL_DATA, TextLabel.TEXT8]);
            _tm.addPause(20);
            _tm.addTask(onMakeLabel, [91, 87, Text.TXT_SYSTEM_OF_LABORATORIES, TextLabel.TEXT16]);
            _tm.addPause(30);
            _tm.addTask(this.onMakeArrows, [165, 169]);
            var _loc_1:* = ZG.saveBox.isMissionCompleted;
            var _loc_2:* = ZG.saveBox.isLevelEnabled;
            _tm.addInstantTask(this.doMakeLevelButton, [138, 240, "1", this._loc_1(1, 0), this._loc_1(1, 1), this._loc_1(1, 2), this._loc_2(1)]);
            if (this.$.domain != "armorgames.com")
            {
                _tm.addInstantTask(this.doMakeLevelButton, [211, 240, "2", this._loc_1(2, 0), this._loc_1(2, 1), this._loc_1(2, 2), -1]);
                _tm.addInstantTask(this.doMakeLevelButton, [211, 173, "3", this._loc_1(3, 0), this._loc_1(3, 1), this._loc_1(3, 2), -1]);
                _tm.addInstantTask(this.doMakeLevelButton, [284, 173, "4", this._loc_1(4, 0), this._loc_1(4, 1), this._loc_1(4, 2), -1]);
                _tm.addInstantTask(this.doMakeLevelButton, [284, 240, "5", this._loc_1(5, 0), this._loc_1(5, 1), this._loc_1(5, 2), -1]);
                _tm.addInstantTask(this.doMakeLevelButton, [284, 307, "6", this._loc_1(6, 0), this._loc_1(6, 1), this._loc_1(6, 2), -1]);
                _tm.addInstantTask(this.doMakeLevelButton, [357, 307, "7", this._loc_1(7, 0), this._loc_1(7, 1), this._loc_1(7, 2), -1]);
                _tm.addInstantTask(this.doMakeLevelButton, [357, 240, "8", this._loc_1(8, 0), this._loc_1(8, 1), this._loc_1(8, 2), -1]);
                _tm.addInstantTask(this.doMakeLevelButton, [430, 240, "9", this._loc_1(9, 0), this._loc_1(9, 1), this._loc_1(9, 2), -1]);
                _tm.addInstantTask(this.doMakeLevelButton, [503, 240, "10", this._loc_1(10, 0), this._loc_1(10, 1), this._loc_1(10, 2), -1]);
            }
            else
            {
                _tm.addInstantTask(this.doMakeLevelButton, [211, 240, "2", this._loc_1(2, 0), this._loc_1(2, 1), this._loc_1(2, 2), this._loc_2(2)]);
                _tm.addInstantTask(this.doMakeLevelButton, [211, 173, "3", this._loc_1(3, 0), this._loc_1(3, 1), this._loc_1(3, 2), this._loc_2(3)]);
                _tm.addInstantTask(this.doMakeLevelButton, [284, 173, "4", this._loc_1(4, 0), this._loc_1(4, 1), this._loc_1(4, 2), this._loc_2(4)]);
                _tm.addInstantTask(this.doMakeLevelButton, [284, 240, "5", this._loc_1(5, 0), this._loc_1(5, 1), this._loc_1(5, 2), this._loc_2(5)]);
                _tm.addInstantTask(this.doMakeLevelButton, [284, 307, "6", this._loc_1(6, 0), this._loc_1(6, 1), this._loc_1(6, 2), this._loc_2(6)]);
                _tm.addInstantTask(this.doMakeLevelButton, [357, 307, "7", this._loc_1(7, 0), this._loc_1(7, 1), this._loc_1(7, 2), this._loc_2(7)]);
                _tm.addInstantTask(this.doMakeLevelButton, [357, 240, "8", this._loc_1(8, 0), this._loc_1(8, 1), this._loc_1(8, 2), this._loc_2(8)]);
                _tm.addInstantTask(this.doMakeLevelButton, [430, 240, "9", this._loc_1(9, 0), this._loc_1(9, 1), this._loc_1(9, 2), this._loc_2(9)]);
                _tm.addInstantTask(this.doMakeLevelButton, [503, 240, "10", this._loc_1(10, 0), this._loc_1(10, 1), this._loc_1(10, 2), this._loc_2(10)]);
            }
            _tm.addTask(this.onShowArrows);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W, App.SCR_H - 74, Text.BTN_MAIN_MENU, TextButton.MAIN_MENU, this.onMainMenu]);
            return;
        }// end function

        private function onMainMenu() : void
        {
            _game.nextScreen = Game.SCR_MAIN_MENU;
            this.hide();
            return;
        }// end function

        private function doMakeLevelButton(param1:int, param2:int, param3:String, param4:Boolean, param5:Boolean, param6:Boolean, param7:int = 0) : void
        {
            var _loc_8:LevelButton = null;
            _loc_8 = new LevelButton();
            _loc_8.setText(param3);
            _loc_8.x = param1;
            _loc_8.y = param2;
            _loc_8.tag = param7;
            _loc_8.enable = param7 < 0 ? (false) : (true);
            _loc_8.star1 = param4;
            _loc_8.star2 = param5;
            _loc_8.star3 = param6;
            _loc_8.show();
            addChild(_loc_8);
            _elements[_elements.length] = _loc_8;
            if (_loc_8.enable)
            {
                _loc_8.addEventListener(MouseEvent.CLICK, this.stageClickHandler);
            }
            return;
        }// end function

        private function onMakeArrows(param1:int, param2:int) : Boolean
        {
            this._arrows = new LevelArrows_mc();
            this._arrows.x = param1;
            this._arrows.y = param2;
            this._arrows.alpha = 0;
            addChild(this._arrows);
            return true;
        }// end function

    }
}
