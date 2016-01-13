package com.zombotron.gui
{
    import com.antkarlov.math.*;
    import flash.display.*;
    import flash.events.*;

    public class FallPixels extends Sprite
    {
        private var _delay:int = 0;
        private var _isStarted:Boolean = false;
        private var _pixels:Array;

        public function FallPixels()
        {
            this._pixels = [];
            return;
        }// end function

        public function start() : void
        {
            if (!this._isStarted)
            {
                addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
                this._isStarted = true;
            }
            return;
        }// end function

        private function enterFrameHandler(event:Event) : void
        {
            var _loc_2:Object = null;
            var _loc_5:Boolean = false;
            var _loc_6:int = 0;
            var _loc_7:String = this;
            var _loc_8:* = this._delay + 1;
            _loc_7._delay = _loc_8;
            if (this._delay >= 5)
            {
                _loc_5 = false;
                _loc_6 = 0;
                while (_loc_6 < this._pixels.length)
                {
                    
                    _loc_2 = this._pixels[int(_loc_6)];
                    if (!_loc_2.visible)
                    {
                        _loc_2.alpha = 0;
                        _loc_2.visible = true;
                        _loc_2.x = Amath.random(20, 300) * 2;
                        _loc_2.y = Amath.random(50, 220) * 2;
                        _loc_2.speed = Math.random();
                        _loc_2.toHide = false;
                        _loc_5 = true;
                        break;
                    }
                    _loc_6++;
                }
                if (!_loc_5)
                {
                    this._pixels[int(this._pixels.length)] = {x:Amath.random(20, 300) * 2, y:Amath.random(20, 220) * 2, visible:true, alpha:0, speed:Math.random(), toHide:false};
                }
                this._delay = 0;
            }
            this.graphics.clear();
            this.graphics.lineStyle(0, 0, 0);
            var _loc_3:* = this._pixels.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = this._pixels[int(_loc_4)];
                if (_loc_2.visible)
                {
                    _loc_2.y = _loc_2.y - _loc_2.speed;
                    if (_loc_2.toHide)
                    {
                        if (_loc_2.alpha <= 0)
                        {
                            _loc_2.visible = false;
                        }
                        else
                        {
                            _loc_2.alpha = _loc_2.alpha - 0.01;
                        }
                    }
                    else if (!_loc_2.toHide)
                    {
                        if (_loc_2.alpha >= 1)
                        {
                            _loc_2.toHide = true;
                            _loc_2.alpha = 1;
                        }
                        else
                        {
                            _loc_2.alpha = _loc_2.alpha + 0.1;
                        }
                    }
                    this.graphics.beginFill(12254233, _loc_2.alpha);
                    this.graphics.drawRect(_loc_2.x, _loc_2.y, 2 + int(_loc_2.speed * 2), 2 + int(_loc_2.speed * 2));
                    this.graphics.endFill();
                }
                _loc_4++;
            }
            return;
        }// end function

        public function stop() : void
        {
            if (this._isStarted)
            {
                removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
                this._isStarted = false;
            }
            return;
        }// end function

        public function free() : void
        {
            this.stop();
            return;
        }// end function

    }
}
