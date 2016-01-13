package com.zombotron.gui
{
    import com.antkarlov.math.*;
    import flash.display.*;
    import flash.events.*;

    public class ElectronBoard extends Sprite
    {
        private var _boardWidth:int = 0;
        private var _isHide:Boolean = false;
        private var _pixelInterval:int = 1;
        private var _boardHeight:int = 0;
        private var _pixelSize:int = 4;
        private var _kind:uint = 0;
        private var _boardPixels:Array;
        private var _isStarted:Boolean = false;
        public static const KIND_GAME_TITLE:uint = 2;
        public static const KIND_DEVELOPER:uint = 1;

        public function ElectronBoard()
        {
            return;
        }// end function

        public function stop() : void
        {
            if (this._isStarted)
            {
                if (this._isHide)
                {
                    removeEventListener(Event.ENTER_FRAME, this.hideHandler);
                }
                else
                {
                    removeEventListener(Event.ENTER_FRAME, this.showHandler);
                }
                this._isStarted = false;
            }
            return;
        }// end function

        public function get boardWidth() : int
        {
            return (this._pixelSize + this._pixelInterval) * this._boardWidth;
        }// end function

        public function hide() : void
        {
            var _loc_1:Object = null;
            var _loc_3:int = 0;
            this.stop();
            var _loc_2:int = 0;
            while (_loc_2 < this._boardHeight)
            {
                
                _loc_3 = 0;
                while (_loc_3 < this._boardWidth)
                {
                    
                    _loc_1 = this._boardPixels[_loc_2][_loc_3];
                    if (_loc_1.alpha > 0)
                    {
                        _loc_1.delay = Amath.random(0, 25) + Amath.random(0, 12);
                    }
                    else
                    {
                        _loc_1.visible = false;
                    }
                    _loc_3++;
                }
                _loc_2++;
            }
            this._isHide = true;
            this.start();
            return;
        }// end function

        public function showHandler(event:Event) : void
        {
            var _loc_3:Object = null;
            var _loc_7:int = 0;
            var _loc_2:Boolean = true;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            this.graphics.clear();
            this.graphics.lineStyle(0, 0, 0);
            var _loc_6:int = 0;
            while (_loc_6 < this._boardHeight)
            {
                
                _loc_7 = 0;
                while (_loc_7 < this._boardWidth)
                {
                    
                    _loc_3 = this._boardPixels[_loc_6][_loc_7];
                    if (_loc_3.delay <= 0)
                    {
                        if (!_loc_3.visible)
                        {
                            _loc_3.visible = true;
                            _loc_3.alpha = 1;
                        }
                        else if (_loc_3.visible && _loc_3.color == 0)
                        {
                            if (_loc_3.alpha <= 0)
                            {
                                _loc_3.alpha = 0;
                            }
                            else
                            {
                                _loc_3.alpha = _loc_3.alpha - 0.05;
                                _loc_2 = false;
                            }
                        }
                    }
                    else
                    {
                        _loc_3.delay = _loc_3.delay - _loc_3.speed;
                    }
                    if (_loc_3.visible && _loc_3.color != 12254233)
                    {
                        this.graphics.beginFill(12254233, _loc_3.alpha);
                        this.graphics.drawRect(_loc_4, _loc_5, this._pixelSize, this._pixelSize);
                        this.graphics.endFill();
                    }
                    else if (!_loc_3.visible)
                    {
                        _loc_2 = false;
                    }
                    _loc_4 = _loc_4 + (this._pixelSize + this._pixelInterval);
                    _loc_7++;
                }
                _loc_4 = 0;
                _loc_5 = _loc_5 + (this._pixelSize + this._pixelInterval);
                _loc_6++;
            }
            if (_loc_2)
            {
                this.stop();
                dispatchEvent(new Event(Event.COMPLETE));
            }
            return;
        }// end function

        public function start() : void
        {
            if (!this._isStarted)
            {
                if (this._isHide)
                {
                    addEventListener(Event.ENTER_FRAME, this.hideHandler);
                }
                else
                {
                    addEventListener(Event.ENTER_FRAME, this.showHandler);
                }
                this._isStarted = true;
            }
            return;
        }// end function

        private function hideHandler(event:Event) : void
        {
            var _loc_3:Object = null;
            var _loc_7:int = 0;
            var _loc_2:Boolean = true;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            this.graphics.clear();
            this.graphics.lineStyle(0, 0, 0);
            var _loc_6:int = 0;
            while (_loc_6 < this._boardHeight)
            {
                
                _loc_7 = 0;
                while (_loc_7 < this._boardWidth)
                {
                    
                    _loc_3 = this._boardPixels[_loc_6][_loc_7];
                    if (_loc_3.delay <= 0)
                    {
                        if (_loc_3.visible)
                        {
                            if (_loc_3.alpha <= 0)
                            {
                                _loc_3.alpha = 0;
                                _loc_3.visible = false;
                            }
                            else
                            {
                                _loc_3.alpha = _loc_3.alpha - 0.1;
                                _loc_2 = false;
                            }
                        }
                    }
                    else
                    {
                        _loc_3.delay = _loc_3.delay - _loc_3.speed;
                    }
                    if (_loc_3.visible && _loc_3.color != 12254233)
                    {
                        this.graphics.beginFill(12254233, _loc_3.alpha);
                        this.graphics.drawRect(_loc_4, _loc_5, this._pixelSize, this._pixelSize);
                        this.graphics.endFill();
                        _loc_2 = false;
                    }
                    _loc_4 = _loc_4 + (this._pixelSize + this._pixelInterval);
                    _loc_7++;
                }
                _loc_4 = 0;
                _loc_5 = _loc_5 + (this._pixelSize + this._pixelInterval);
                _loc_6++;
            }
            if (_loc_2)
            {
                this.stop();
                dispatchEvent(new Event(Event.COMPLETE));
            }
            return;
        }// end function

        public function get boardHeight() : int
        {
            return (this._pixelSize + this._pixelInterval) * this._boardHeight;
        }// end function

        public function set kind(param1:uint) : void
        {
            if (this._kind != param1)
            {
                this._kind = param1;
                switch(this._kind)
                {
                    case KIND_DEVELOPER:
                    {
                        this.makeMask(new AntKarlov_mc());
                        break;
                    }
                    case KIND_GAME_TITLE:
                    {
                        this.makeMask(new Zombotron_mc());
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        private function makeMask(param1:Sprite) : void
        {
            var _loc_2:Array = null;
            var _loc_5:int = 0;
            this._boardPixels = [];
            var _loc_3:* = new BitmapData(param1.width, param1.height, true);
            _loc_3.draw(param1);
            this._boardWidth = param1.width;
            this._boardHeight = param1.height;
            var _loc_4:int = 0;
            while (_loc_4 < this._boardHeight)
            {
                
                _loc_2 = [];
                _loc_5 = 0;
                while (_loc_5 < this._boardWidth)
                {
                    
                    _loc_2[int(_loc_2.length)] = {color:_loc_3.getPixel(_loc_5, _loc_4), visible:false, alpha:0, speed:Amath.random(1, 2), delay:Amath.random(0, 50) + Amath.random(0, 25)};
                    _loc_5++;
                }
                this._boardPixels[int(this._boardPixels.length)] = _loc_2;
                _loc_4++;
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
