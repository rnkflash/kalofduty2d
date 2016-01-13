package com.zombotron.gui
{
    import com.antkarlov.managers.*;
    import com.zombotron.core.*;
    import flash.display.*;
    import flash.text.*;

    public class ConsoleGui extends BasicElement
    {
        private var _lines:Array;
        private var _animProcessor:TaskManager;
        private var _caret:Array;
        private var _textField:TextField = null;
        private var _displayText:String;
        private var _stopped:Boolean = false;
        private var _tm:TaskManager;
        private var _charIndex:int = 0;
        private var _labels:Array;
        private var _stream:String = "";

        public function ConsoleGui()
        {
            var _loc_1:Sprite = null;
            this._labels = [];
            this._lines = [];
            this._caret = [];
            this._tm = new TaskManager();
            this._animProcessor = new TaskManager();
            var _loc_2:int = 0;
            while (_loc_2 < 4)
            {
                
                _loc_1 = new ConsoleString_mc();
                this._labels[int(this._labels.length)] = _loc_1;
                _loc_1.y = 9 * _loc_2;
                if (_loc_1["tf"] != null)
                {
                    this._textField = _loc_1["tf"] as TextField;
                    this._textField.text = _loc_2 == 3 ? (">") : (":");
                }
                addChild(_loc_1);
                _loc_2++;
            }
            return;
        }// end function

        private function onNextLine() : Boolean
        {
            if (this._stopped)
            {
                this._lines.length = 0;
                return true;
            }
            if (this._lines.length > 0)
            {
                this.log(this._lines.shift());
            }
            return true;
        }// end function

        override public function hide() : void
        {
            this._animProcessor.clear();
            this._animProcessor.addTask(this.onFadeOut);
            return;
        }// end function

        public function log(param1:String, param2:Boolean = true) : void
        {
            if (this._stream != "")
            {
                this._lines[this._lines.length] = param1;
                return;
            }
            this._stream = param1;
            if (this._textField != null)
            {
                this._charIndex = 0;
                this._displayText = ">";
            }
            this._tm.addTask(this.onOutput);
            this._tm.addTask(this.onNextLine);
            if (param2)
            {
                ZG.sound(SoundManager.TERMINAL_MESSAGE);
            }
            return;
        }// end function

        public function clear() : void
        {
            this._tm.clear();
            (this._labels[0]["tf"] as TextField).text = ":";
            (this._labels[1]["tf"] as TextField).text = ":";
            (this._labels[2]["tf"] as TextField).text = ":";
            (this._labels[3]["tf"] as TextField).text = ">";
            return;
        }// end function

        private function onFadeIn() : Boolean
        {
            this.alpha = this.alpha + 0.2;
            if (this.alpha >= 1)
            {
                this.alpha = 1;
                return true;
            }
            return false;
        }// end function

        private function onFadeOut() : Boolean
        {
            this.alpha = this.alpha - 0.2;
            if (this.alpha <= 0)
            {
                this.alpha = 0;
                this._caret.length = 0;
                this._stopped = true;
                return true;
            }
            return false;
        }// end function

        private function onOutput() : Boolean
        {
            if (this._charIndex < this._stream.length)
            {
                this._displayText = this._displayText + this._stream.charAt(this._charIndex);
                this._textField.text = this._displayText;
                this._caret[int(this._caret.length)] = {x:8 + 6 * this._charIndex, alpha:1, visible:true};
                if (this._caret.length == 1)
                {
                    this._animProcessor.addTask(this.onDrawCaret);
                }
                var _loc_1:String = this;
                var _loc_2:* = this._charIndex + 1;
                _loc_1._charIndex = _loc_2;
            }
            else
            {
                (this._labels[0]["tf"] as TextField).text = (this._labels[1]["tf"] as TextField).text;
                (this._labels[1]["tf"] as TextField).text = (this._labels[2]["tf"] as TextField).text;
                (this._labels[2]["tf"] as TextField).text = ":" + this._stream;
                this._stream = "";
                this._charIndex = 0;
                this._textField.text = ">";
                return true;
            }
            return false;
        }// end function

        override public function free() : void
        {
            this._tm.clear();
            this._animProcessor.clear();
            this._textField = null;
            var _loc_1:* = this._labels.length;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                removeChild(this._labels[int(_loc_2)]);
                this._labels[int(_loc_2)] = null;
                _loc_2++;
            }
            this._labels.length = 0;
            this._caret.length = 0;
            this._lines.length = 0;
            return;
        }// end function

        private function onDrawCaret() : Boolean
        {
            var _loc_2:Object = null;
            var _loc_1:Boolean = true;
            this.graphics.clear();
            this.graphics.lineStyle(0, 0, 0);
            var _loc_3:* = this._caret.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = this._caret[int(_loc_4)];
                if (_loc_2.visible)
                {
                    this.graphics.beginFill(12254233, _loc_2.alpha);
                    this.graphics.drawRect(_loc_2.x, 30, 6, 7);
                    this.graphics.endFill();
                    _loc_2.alpha = _loc_2.alpha - 0.25;
                    if (_loc_2.alpha <= 0)
                    {
                        _loc_2.visible = false;
                        _loc_2.alpha = 0;
                    }
                    _loc_1 = false;
                }
                _loc_4++;
            }
            if (_loc_1)
            {
                this._caret.length = 0;
            }
            return _loc_1;
        }// end function

        override public function show() : void
        {
            this._stopped = false;
            this.alpha = 0;
            this._animProcessor.addTask(this.onFadeIn);
            return;
        }// end function

    }
}
