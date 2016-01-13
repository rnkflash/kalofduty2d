package com.zombotron.gui
{
    import com.antkarlov.managers.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class TextLabel extends BasicElement
    {
        private var _animProcessor:TaskManager;
        private var _textLabel:MovieClip;
        private var _caret:Array;
        private var _text:String = "";
        private var _textField:TextField;
        private var _charIndex:int = 1;
        private var _displayText:String = "";
        private var _color:uint = 12254233;
        private var _tm:TaskManager;
        private var _animMode:uint = 0;
        public static const COLOR_WHITE:uint = 4;
        public static const COLOR_LIME:uint = 1;
        public static const TEXT16:uint = 2;
        public static const TEXT_SMALL:uint = 5;
        public static const TEXT_PRICE:uint = 4;
        public static const ANIM_FADE_OUT:uint = 3;
        public static const ANIM_FADE_IN:uint = 2;
        public static const ANIM_PRINT:uint = 1;
        public static const ANIM_NONE:uint = 0;
        public static const COLOR_ORANGE:uint = 2;
        public static const TEXT8:uint = 1;
        public static const TEXT24:uint = 3;
        public static const COLOR_GRAY:uint = 5;
        public static const COLOR_PINK:uint = 3;

        public function TextLabel(param1:uint = 2)
        {
            this._tm = new TaskManager();
            this._animProcessor = new TaskManager();
            this._caret = [];
            _kind = param1;
            switch(_kind)
            {
                case TEXT8:
                {
                    this._textLabel = new Text8_mc();
                    break;
                }
                case TEXT16:
                {
                    this._textLabel = new Text16_mc();
                    break;
                }
                case TEXT24:
                {
                    this._textLabel = new Text24_mc();
                    break;
                }
                case TEXT_PRICE:
                {
                    this._textLabel = new TextPrice_mc();
                    break;
                }
                case TEXT_SMALL:
                {
                    this._textLabel = new TextSmall_mc();
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this._textLabel["textField"] != null)
            {
                this._textField = this._textLabel["textField"] as TextField;
            }
            this._textLabel.stop();
            this._textLabel.visible = false;
            addChild(this._textLabel);
            return;
        }// end function

        private function onDrawCaret() : Boolean
        {
            var _loc_2:Object = null;
            var _loc_1:Boolean = true;
            this.graphics.clear();
            this.graphics.lineStyle(0, 0, 0);
            var _loc_3:int = 0;
            while (_loc_3 < this._caret.length)
            {
                
                _loc_2 = this._caret[int(_loc_3)];
                if (_loc_2.visible)
                {
                    this.graphics.beginFill(this._color, _loc_2.alpha);
                    switch(_kind)
                    {
                        case TEXT8:
                        {
                            this.graphics.drawRect(_loc_2.x, -4, 6, 7);
                            break;
                        }
                        case TEXT16:
                        {
                            this.graphics.drawRect(_loc_2.x, -7, 12, 14);
                            break;
                        }
                        case TEXT24:
                        {
                            this.graphics.drawRect(_loc_2.x, -8, 16, 15);
                            break;
                        }
                        case TEXT_PRICE:
                        {
                            this.graphics.drawRect(_loc_2.x, -7, 10, 12);
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    this.graphics.endFill();
                    _loc_2.alpha = _loc_2.alpha - 0.2;
                    if (_loc_2.alpha <= 0)
                    {
                        _loc_2.visible = false;
                        _loc_2.alpha = 0;
                    }
                    _loc_1 = false;
                }
                _loc_3++;
            }
            if (_loc_1)
            {
                this._caret.length = 0;
            }
            return _loc_1;
        }// end function

        override public function hide() : void
        {
            this._tm.addTask(this.onFadeOut);
            return;
        }// end function

        public function setAnim(param1:uint) : void
        {
            if (this._animMode != param1)
            {
                this._animMode = param1;
            }
            return;
        }// end function

        private function onPrint() : Boolean
        {
            if (this._text.length == 0)
            {
                dispatchEvent(new Event(Event.COMPLETE));
                return true;
            }
            switch(_kind)
            {
                case TEXT8:
                {
                    break;
                }
                case TEXT16:
                {
                    break;
                }
                case TEXT24:
                {
                    break;
                }
                case TEXT_PRICE:
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this._caret.length == 1)
            {
            }
            var _loc_1:String = this;
            var _loc_2:* = this._charIndex + 1;
            _loc_1._charIndex = _loc_2;
            return false;
        }// end function

        private function onFadeOut() : Boolean
        {
            this._textLabel.alpha = this._textLabel.alpha - 0.1;
            if (this._textLabel.alpha <= 0)
            {
                this._textLabel.alpha = 0;
                return true;
            }
            return false;
        }// end function

        private function showAsPrint() : void
        {
            this._charIndex = 0;
            this._tm.addTask(this.onPrint);
            return;
        }// end function

        public function setColor(param1:uint) : void
        {
            switch(param1)
            {
                case COLOR_LIME:
                {
                    this._color = 12254233;
                    this._textField.textColor = this._color;
                    if (_kind == TEXT_PRICE)
                    {
                        this._textLabel.gotoAndStop(1);
                    }
                    break;
                }
                case COLOR_ORANGE:
                {
                    this._color = 16749081;
                    this._textField.textColor = this._color;
                    break;
                }
                case COLOR_PINK:
                {
                    this._color = 16270258;
                    this._textField.textColor = this._color;
                    if (_kind == TEXT_PRICE)
                    {
                        this._textLabel.gotoAndStop(2);
                    }
                    break;
                }
                case COLOR_WHITE:
                {
                    this._color = 14933691;
                    this._textField.textColor = this._color;
                    break;
                }
                case COLOR_GRAY:
                {
                    this._color = 4871249;
                    this._textField.textColor = this._color;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function getWidth() : int
        {
            return this._textField.width;
        }// end function

        override public function free() : void
        {
            if (this._textLabel)
            {
                removeChild(this._textLabel);
            }
            this._textLabel = null;
            this._textField = null;
            this._caret.length = 0;
            this._tm.clear();
            if (this.parent != null)
            {
                this.parent.removeChild(this);
            }
            return;
        }// end function

        public function setText(param1:String) : void
        {
            if (param1 != this._text)
            {
                this._text = param1;
                this._textField.text = this._text;
                switch(_kind)
                {
                    case TEXT_SMALL:
                    {
                        this._textField.autoSize = TextFieldAutoSize.RIGHT;
                        break;
                    }
                    default:
                    {
                        this._textField.autoSize = TextFieldAutoSize.LEFT;
                        break;
                        break;
                    }
                }
            }
            return;
        }// end function

        public function setWidth(param1:int) : void
        {
            this._textField.width = param1;
            return;
        }// end function

        override public function show() : void
        {
            switch(this._animMode)
            {
                case ANIM_NONE:
                {
                    this._textLabel.visible = true;
                    break;
                }
                case ANIM_PRINT:
                {
                    this._charIndex = 0;
                    this._caret.length = 0;
                    this._textField.text = "";
                    this._textLabel.visible = true;
                    this._displayText = "";
                    this.showAsPrint();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
