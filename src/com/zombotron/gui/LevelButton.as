package com.zombotron.gui
{
    import com.antkarlov.managers.*;
    import com.zombotron.core.*;
    import flash.display.*;
    import flash.events.*;

    public class LevelButton extends BasicElement
    {
        private var _isDown:Boolean = false;
        private var _labelBig:TextLabel;
        private var _isFree:Boolean = false;
        private var _tm:TaskManager;
        private var _labelSmall:TextLabel;
        public var tag:int = -1;
        private var _star1:Sprite;
        private var _star2:Sprite;
        private var _enable:Boolean = true;
        private var _star3:Sprite;
        private var _sprite:MovieClip;
        private var _isActive:Boolean = false;

        public function LevelButton()
        {
            this._tm = new TaskManager();
            this._labelBig = new TextLabel(TextLabel.TEXT16);
            addChild(this._labelBig);
            this._labelSmall = new TextLabel(TextLabel.TEXT8);
            addChild(this._labelSmall);
            this._sprite = new ButtonLevel_mc();
            this._sprite.stop();
            addChild(this._sprite);
            return;
        }// end function

        public function get enable() : Boolean
        {
            return this._enable;
        }// end function

        public function set enable(param1:Boolean) : void
        {
            this._enable = param1;
            if (!this._enable)
            {
                var _loc_2:Number = 0.5;
                this._labelSmall.alpha = 0.5;
                var _loc_2:* = _loc_2;
                this._labelBig.alpha = _loc_2;
                this._sprite.alpha = _loc_2;
                var _loc_2:Boolean = false;
                buttonMode = false;
                mouseEnabled = _loc_2;
            }
            else
            {
                var _loc_2:int = 1;
                this._labelSmall.alpha = 1;
                var _loc_2:* = _loc_2;
                this._labelBig.alpha = _loc_2;
                this._sprite.alpha = _loc_2;
                var _loc_2:Boolean = true;
                buttonMode = true;
                mouseEnabled = _loc_2;
            }
            return;
        }// end function

        public function set star2(param1:Boolean) : void
        {
            if (param1)
            {
                this._star2 = new ButtonStar_mc();
                this._star2.x = -5;
                this._star2.y = 7;
                this._sprite.addChild(this._star2);
            }
            else if (this._star2 != null)
            {
                this._sprite.removeChild(this._star2);
                this._star2 = null;
            }
            return;
        }// end function

        override public function hide() : void
        {
            this._tm.addInstantTask(this.doRemoveHandlers);
            this._tm.addTask(this.doFadeOut);
            return;
        }// end function

        private function mouseUpHandler(event:MouseEvent) : void
        {
            if (this._isDown && this._enable)
            {
                this._sprite.y = this._sprite.y - 2;
                this._labelBig.y = this._labelBig.y - 2;
                this._labelSmall.y = this._labelSmall.y - 2;
                this._isDown = false;
            }
            return;
        }// end function

        public function set star3(param1:Boolean) : void
        {
            if (param1)
            {
                this._star3 = new ButtonStar_mc();
                this._star3.x = 7;
                this._star3.y = 7;
                this._sprite.addChild(this._star3);
            }
            else if (this._star3 != null)
            {
                this._sprite.removeChild(this._star3);
                this._star3 = null;
            }
            return;
        }// end function

        private function doAddHandlers() : void
        {
            if (this._enable)
            {
                this._isActive = true;
                addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
                addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
                addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
                addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
                mouseEnabled = true;
                buttonMode = true;
            }
            return;
        }// end function

        private function mouseDownHandler(event:MouseEvent) : void
        {
            if (this._enable)
            {
                this._isDown = true;
                this._sprite.y = this._sprite.y + 2;
                this._labelBig.y = this._labelBig.y + 2;
                this._labelSmall.y = this._labelSmall.y + 2;
                ZG.sound(SoundManager.BUTTON_CLICK);
            }
            return;
        }// end function

        private function doFadeOut() : Boolean
        {
            this._sprite.alpha = this._sprite.alpha - 0.2;
            var _loc_1:* = this._sprite.alpha;
            this._labelSmall.alpha = this._sprite.alpha;
            this._labelBig.alpha = _loc_1;
            if (this._sprite.alpha <= 0)
            {
                var _loc_1:int = 0;
                this._labelBig.alpha = 0;
                var _loc_1:* = _loc_1;
                this._labelSmall.alpha = _loc_1;
                this._sprite.alpha = _loc_1;
                this.free();
                return true;
            }
            return false;
        }// end function

        private function mouseOutHandler(event:MouseEvent) : void
        {
            if (this._enable)
            {
                this._sprite.gotoAndStop(1);
                this._labelBig.setColor(TextLabel.COLOR_LIME);
                this._labelSmall.setColor(TextLabel.COLOR_LIME);
                if (this._isDown)
                {
                    this._sprite.y = this._sprite.y - 2;
                    this._labelBig.y = this._labelBig.y - 2;
                    this._labelSmall.y = this._labelSmall.y - 2;
                    this._isDown = false;
                }
            }
            return;
        }// end function

        override public function free() : void
        {
            if (!this._isFree)
            {
                this._labelBig.free();
                this._labelSmall.free();
                if (this._star1 != null)
                {
                    this._sprite.removeChild(this._star1);
                    this._star1 = null;
                }
                if (this._star2 != null)
                {
                    this._sprite.removeChild(this._star2);
                    this._star2 = null;
                }
                if (this._star3 != null)
                {
                    this._sprite.removeChild(this._star3);
                    this._star3 = null;
                }
                removeChild(this._sprite);
                this._sprite = null;
                this._tm.clear();
                this._isFree = true;
            }
            return;
        }// end function

        private function mouseOverHandler(event:MouseEvent) : void
        {
            if (this._enable)
            {
                this._sprite.gotoAndStop(2);
                this._labelBig.setColor(TextLabel.COLOR_ORANGE);
                this._labelSmall.setColor(TextLabel.COLOR_ORANGE);
            }
            return;
        }// end function

        public function setText(param1:String) : void
        {
            this._labelBig.setText(param1);
            this._labelBig.setWidth(39);
            this._labelSmall.setText(param1 == "10" ? (Text.TXT_BOSS) : (Text.TXT_LEVEL));
            this._labelSmall.setWidth(39);
            return;
        }// end function

        private function doRemoveHandlers() : void
        {
            if (this._enable)
            {
                this._isActive = false;
                removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
                removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
                removeEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
                removeEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
                mouseEnabled = false;
                buttonMode = false;
            }
            return;
        }// end function

        private function doFadeIn() : Boolean
        {
            this._sprite.alpha = this._sprite.alpha + 0.1;
            var _loc_2:* = this._sprite.alpha;
            this._labelSmall.alpha = this._sprite.alpha;
            this._labelBig.alpha = _loc_2;
            var _loc_1:* = this._enable ? (1) : (0.5);
            if (this._sprite.alpha >= _loc_1)
            {
                var _loc_2:* = _loc_1;
                this._labelBig.alpha = _loc_1;
                var _loc_2:* = _loc_2;
                this._labelSmall.alpha = _loc_2;
                this._sprite.alpha = _loc_2;
                return true;
            }
            return false;
        }// end function

        override public function show() : void
        {
            this._isActive = false;
            this._labelBig.y = this._labelBig.y - 10;
            this._labelBig.x = this._labelBig.x - (this._labelBig.width * 0.5 - 1);
            this._labelBig.alpha = 0;
            this._labelBig.show();
            (this._labelSmall.y + 1);
            this._labelSmall.x = this._labelSmall.x - this._labelSmall.width * 0.5;
            this._labelSmall.alpha = 0;
            this._labelSmall.show();
            this._sprite.alpha = 0;
            this._tm.addTask(this.doFadeIn);
            this._tm.addInstantTask(this.doAddHandlers);
            return;
        }// end function

        public function set star1(param1:Boolean) : void
        {
            if (param1)
            {
                this._star1 = new ButtonStar_mc();
                this._star1.x = -17;
                this._star1.y = 7;
                this._sprite.addChild(this._star1);
            }
            else if (this._star1 != null)
            {
                this._sprite.removeChild(this._star1);
                this._star1 = null;
            }
            return;
        }// end function

    }
}
