package com.zombotron.gui
{
    import com.antkarlov.managers.*;
    import flash.display.*;
    import flash.events.*;

    public class BasicButton extends BasicElement
    {
        private var _sprite:MovieClip;
        public var onClick:Function = null;
        private var _isDown:Boolean = false;
        private var _isActive:Boolean = false;
        private var _tm:TaskManager;
        public static const CLOSE:uint = 1;

        public function BasicButton(param1:uint = 1)
        {
            this._tm = new TaskManager();
            _kind = param1;
            switch(_kind)
            {
                default:
                {
                    this._sprite = new ButtonClose_mc();
                    break;
                    break;
                }
            }
            this._sprite.gotoAndStop(1);
            addChild(this._sprite);
            mouseEnabled = true;
            buttonMode = true;
            addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
            addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            return;
        }// end function

        private function onFadeIn() : Boolean
        {
            this._sprite.alpha = this._sprite.alpha + 0.1;
            if (this._sprite.alpha >= 1)
            {
                this._sprite.alpha = 1;
                this._isActive = true;
                return true;
            }
            return false;
        }// end function

        private function mouseOutHandler(event:MouseEvent) : void
        {
            this._sprite.gotoAndStop(1);
            if (this._isDown)
            {
                this._sprite.y = this._sprite.y - 2;
                this._isDown = false;
            }
            return;
        }// end function

        override public function hide() : void
        {
            this._isActive = false;
            this._tm.addTask(this.onFadeOut);
            return;
        }// end function

        private function mouseDownHandler(event:MouseEvent) : void
        {
            this._isDown = true;
            this._sprite.y = this._sprite.y + 2;
            return;
        }// end function

        private function mouseUpHandler(event:MouseEvent) : void
        {
            if (this._isDown)
            {
                this._sprite.y = this._sprite.y - 2;
                this._isDown = false;
                if (this.onClick != null && this._isActive)
                {
                    this.onClick();
                }
            }
            return;
        }// end function

        override public function free() : void
        {
            removeChild(this._sprite);
            this._sprite = null;
            return;
        }// end function

        private function mouseOverHandler(event:MouseEvent) : void
        {
            this._sprite.gotoAndStop(2);
            return;
        }// end function

        private function onFadeOut() : Boolean
        {
            this._sprite.alpha = this._sprite.alpha - 0.1;
            if (this._sprite.alpha <= 0)
            {
                this._sprite.alpha = 0;
                return true;
            }
            return false;
        }// end function

        override public function show() : void
        {
            this._sprite.alpha = 0;
            this._tm.addTask(this.onFadeIn);
            return;
        }// end function

    }
}
