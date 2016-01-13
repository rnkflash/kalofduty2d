package com.zombotron.gui
{
    import com.antkarlov.managers.*;
    import com.zombotron.core.*;
    import flash.display.*;
    import flash.events.*;

    public class TextButton extends BasicElement
    {
        private var _isDown:Boolean = false;
        private var _isFree:Boolean = true;
        private var _isShowingLabel:Boolean = false;
        public var tag:int = 0;
        private var _tm:TaskManager;
        private var _enable:Boolean = true;
        private var _sprite:MovieClip;
        public var onClick:Function = null;
        private var _color:uint = 1;
        private var _label:TextLabel = null;
        private var _isActive:Boolean = false;
        public static const BASIC:uint = 0;
        public static const SPONSOR_LOGO:uint = 10;
        public static const COLOR_LIME:uint = 1;
        public static const SCORES:uint = 4;
        public static const ACHIEVEMENTS:uint = 9;
        public static const MAIN_MENU:uint = 7;
        public static const BUY:uint = 6;
        public static const AUTHORS:uint = 13;
        public static const SPONSOR_LOGO_BIG:uint = 11;
        public static const COLOR_PINK:uint = 3;
        public static const PLAY:uint = 1;
        public static const RESTART:uint = 8;
        public static const MORE_GAMES:uint = 3;
        public static const SPONSOR_LIKE:uint = 12;

        public function TextButton(param1:uint = 0)
        {
            this._tm = new TaskManager();
            this._isFree = false;
            _kind = param1;
            switch(_kind)
            {
                case PLAY:
                {
                    this._label = new TextLabel(TextLabel.TEXT24);
                    this._sprite = new ButtonPlay_mc();
                    break;
                }
                case MORE_GAMES:
                {
                    this._label = new TextLabel(TextLabel.TEXT16);
                    this._sprite = new ButtonMoreGames_mc();
                    break;
                }
                case SCORES:
                {
                    this._label = new TextLabel(TextLabel.TEXT16);
                    this._sprite = new ButtonScores_mc();
                    break;
                }
                case BUY:
                {
                    this._label = new TextLabel(TextLabel.TEXT16);
                    this._sprite = new ButtonBuy_mc();
                    break;
                }
                case MAIN_MENU:
                {
                    this._label = new TextLabel(TextLabel.TEXT16);
                    this._sprite = new ButtonMainMenu_mc();
                    break;
                }
                case RESTART:
                {
                    this._label = new TextLabel(TextLabel.TEXT16);
                    this._sprite = new ButtonRestart_mc();
                    break;
                }
                case ACHIEVEMENTS:
                {
                    this._label = new TextLabel(TextLabel.TEXT16);
                    this._sprite = new ButtonAchievements_mc();
                    break;
                }
                case SPONSOR_LOGO:
                {
                    this._label = new TextLabel(TextLabel.TEXT16);
                    this._sprite = new ButtonSponsorLogo_mc();
                    break;
                }
                case SPONSOR_LOGO_BIG:
                {
                    this._label = new TextLabel(TextLabel.TEXT16);
                    this._sprite = new ButtonSponsorLogoBig_mc();
                    break;
                }
                case SPONSOR_LIKE:
                {
                    this._label = new TextLabel(TextLabel.TEXT16);
                    this._sprite = new ButtonSponsorLike_mc();
                    break;
                }
                case AUTHORS:
                {
                    this._label = new TextLabel(TextLabel.TEXT16);
                    this._sprite = new ButtonAuthors_mc();
                    break;
                }
                default:
                {
                    this._label = new TextLabel(TextLabel.TEXT16);
                    this._sprite = new ButtonBasic_mc();
                    break;
                    break;
                }
            }
            this._sprite.stop();
            addChild(this._label);
            addChild(this._sprite);
            addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
            mouseEnabled = true;
            buttonMode = true;
            return;
        }// end function

        private function onFadeIn() : Boolean
        {
            this._sprite.alpha = this._sprite.alpha + 0.1;
            var _loc_1:* = this._enable ? (1) : (0.5);
            if (this._sprite.alpha >= _loc_1)
            {
                this._sprite.alpha = _loc_1;
                this._isActive = true;
                return true;
            }
            return false;
        }// end function

        override public function hide() : void
        {
            if (this._isShowingLabel)
            {
                this._isShowingLabel = false;
                this._label.removeEventListener(Event.COMPLETE, this.labelCompleteHandler);
            }
            this._tm.addTask(this.onFadeOut);
            this._tm.addTask(this.free);
            this._isActive = false;
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
                this._label.alpha = 0.5;
                this._sprite.alpha = _loc_2;
                var _loc_2:Boolean = false;
                buttonMode = false;
                mouseEnabled = _loc_2;
            }
            else
            {
                var _loc_2:int = 1;
                this._label.alpha = 1;
                this._sprite.alpha = _loc_2;
                var _loc_2:Boolean = true;
                buttonMode = true;
                mouseEnabled = _loc_2;
            }
            return;
        }// end function

        private function mouseUpHandler(event:MouseEvent) : void
        {
            if (this._isDown && this._enable)
            {
                this._sprite.y = this._sprite.y - 2;
                this._label.y = this._label.y - 2;
                this._isDown = false;
                if (this.onClick != null && this._isActive)
                {
                    this.onClick();
                }
            }
            return;
        }// end function

        private function labelCompleteHandler(event:Event) : void
        {
            this._isShowingLabel = false;
            this._label.removeEventListener(Event.COMPLETE, this.labelCompleteHandler);
            this._tm.addTask(this.onFadeIn);
            return;
        }// end function

        private function onFadeOut() : Boolean
        {
            this._sprite.alpha = this._sprite.alpha - 0.1;
            this._label.alpha = this._sprite.alpha;
            if (this._sprite.alpha <= 0)
            {
                this._sprite.alpha = 0;
                this._label.alpha = 0;
                return true;
            }
            return false;
        }// end function

        public function setColor(param1:uint) : void
        {
            this._color = param1;
            if (this._label != null)
            {
                this._label.setColor(param1);
            }
            if (this._sprite != null && this._sprite.currentFrame != 2)
            {
                this._sprite.gotoAndStop(param1);
            }
            return;
        }// end function

        private function mouseDownHandler(event:MouseEvent) : void
        {
            if (this._enable)
            {
                this._isDown = true;
                this._sprite.y = this._sprite.y + 2;
                this._label.y = this._label.y + 2;
                ZG.sound(SoundManager.BUTTON_CLICK);
            }
            return;
        }// end function

        private function mouseOutHandler(event:MouseEvent) : void
        {
            if (this._enable)
            {
                this._sprite.gotoAndStop(this._color);
                this._label.setColor(this._color);
                if (this._isDown)
                {
                    this._sprite.y = this._sprite.y - 2;
                    this._label.y = this._label.y - 2;
                    this._isDown = false;
                }
            }
            return;
        }// end function

        override public function free() : void
        {
            if (!this._isFree)
            {
                removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
                removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
                removeEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
                removeEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
                removeChild(this._sprite);
                removeChild(this._label);
                this._label.free();
                this._label = null;
                this._sprite = null;
                this._tm.clear();
                if (this.parent != null)
                {
                    this.parent.removeChild(this);
                }
                this._isFree = true;
            }
            return;
        }// end function

        public function setText(param1:String) : void
        {
            this._label.setText(param1);
            return;
        }// end function

        private function mouseOverHandler(event:MouseEvent) : void
        {
            if (this._enable)
            {
                this._sprite.gotoAndStop(2);
                this._label.setColor(TextLabel.COLOR_ORANGE);
            }
            return;
        }// end function

        override public function show() : void
        {
            this._isShowingLabel = true;
            this._label.setAnim(TextLabel.ANIM_PRINT);
            this._label.x = this._label.x - this._label.width * 0.5;
            this._label.show();
            this._label.addEventListener(Event.COMPLETE, this.labelCompleteHandler);
            this._sprite.alpha = 0;
            this._isActive = false;
            return;
        }// end function

    }
}
