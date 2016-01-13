package com.zombotron.gui
{
    import com.zombotron.core.*;
    import flash.display.*;

    public class PopupNewGame extends BasicMenu
    {
        private var _bg:Sprite;
        private var _popup:Sprite;
        public var parentScreen:MainMenu;

        public function PopupNewGame()
        {
            this._bg = new MenuBG_mc();
            this._bg.alpha = 0;
            addChild(this._bg);
            this._popup = new PopupBG_mc();
            this._popup.alpha = 0;
            this._popup.x = App.SCR_HALF_W;
            this._popup.y = App.SCR_HALF_H;
            addChild(this._popup);
            return;
        }// end function

        override public function hide() : void
        {
            _tm.clear();
            _tm.addTask(this.onHideWindow);
            var _loc_1:* = _elements.length;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                if (_elements[_loc_2] is TextButton)
                {
                    (_elements[_loc_2] as TextButton).onClick = null;
                }
                _tm.addTask(onHideElement, [_loc_2]);
                _tm.addPause(5);
                _loc_2++;
            }
            return;
        }// end function

        private function onContinue() : void
        {
            this.hide();
            if (this.parentScreen != null)
            {
                this.parentScreen.doPlay();
            }
            return;
        }// end function

        override public function free() : void
        {
            removeChild(this._bg);
            this._bg = null;
            super.free();
            return;
        }// end function

        private function onShowWindow() : Boolean
        {
            this._bg.alpha = this._bg.alpha + 0.1;
            this._popup.alpha = this._bg.alpha;
            if (this._bg.alpha >= 0.5)
            {
                var _loc_1:Number = 0.5;
                this._popup.alpha = 0.5;
                this._bg.alpha = _loc_1;
                return true;
            }
            return false;
        }// end function

        private function onShowPopup() : Boolean
        {
            this._popup.alpha = this._popup.alpha + 0.1;
            if (this._popup.alpha >= 1)
            {
                this._popup.alpha = 1;
                return true;
            }
            return false;
        }// end function

        private function onHideWindow() : Boolean
        {
            this._popup.alpha = this._popup.alpha - 0.2;
            this._bg.alpha = this._bg.alpha - 0.1;
            if (this._popup.alpha <= 0 || this._bg.alpha <= 0)
            {
                this.free();
                return true;
            }
            return false;
        }// end function

        private function onNewGame() : void
        {
            ZG.saveBox.clear();
            this.onContinue();
            return;
        }// end function

        override public function show() : void
        {
            _tm.clear();
            _tm.addTask(this.onShowWindow);
            _tm.addTask(this.onShowPopup);
            _tm.addTask(onMakeLabel, [215, 178, Text.TXT_START_NEW_GAME1, TextLabel.TEXT16]);
            _tm.addPause(5);
            _tm.addTask(onMakeLabel, [265, 198, Text.TXT_START_NEW_GAME2, TextLabel.TEXT16]);
            _tm.addPause(5);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W, App.SCR_HALF_H, Text.BTN_NEW_GAME, TextButton.RESTART, this.onNewGame]);
            _tm.addPause(5);
            _tm.addTask(onMakeButton, [App.SCR_HALF_W, App.SCR_HALF_H + 49, Text.BTN_CONTINUE, TextButton.RESTART, this.onContinue]);
            return;
        }// end function

    }
}
