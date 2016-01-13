package com.zombotron.core
{
    import com.antkarlov.events.*;
    import com.antkarlov.math.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;

    public class Background extends Sprite
    {
        private var _isInit:Boolean = false;
        private var _container:Sprite;
        private var _tileHeight:int = 5;
        private var _bitmaps:Array;
        public var queueCurrent:uint = 0;
        private var _tileWidth:int = 8;
        public var queueTotal:uint = 0;
        private var _list:Array;
        public static const TILE_SIZE:int = 172;

        public function Background()
        {
            this._list = [];
            this.makeArray();
            this._container = new SkyBG1_mc();
            var _loc_1:* = this._container.numChildren;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                if (this._container.getChildAt(_loc_2) is Sprite && (this._container.getChildAt(_loc_2) as Sprite).name == "screen_frame")
                {
                    this._list[this._list.length] = _loc_2;
                }
                _loc_2++;
            }
            this.queueTotal = this._list.length;
            return;
        }// end function

        override public function get width() : Number
        {
            return this._tileWidth * TILE_SIZE;
        }// end function

        private function makeArray() : void
        {
            var _loc_1:Array = null;
            var _loc_3:int = 0;
            this._bitmaps = [];
            var _loc_2:int = 0;
            while (_loc_2 < this._tileHeight)
            {
                
                _loc_1 = [];
                _loc_3 = 0;
                while (_loc_3 < this._tileWidth)
                {
                    
                    _loc_1[_loc_1.length] = {bitmap:null, visible:false};
                    _loc_3++;
                }
                this._bitmaps[this._bitmaps.length] = _loc_1;
                _loc_2++;
            }
            return;
        }// end function

        public function reset(param1:Number, param2:Number) : void
        {
            var _loc_3:Object = null;
            var _loc_7:int = 0;
            var _loc_4:int = 0;
            while (_loc_4 < this._tileHeight)
            {
                
                _loc_7 = 0;
                while (_loc_7 < this._tileWidth)
                {
                    
                    _loc_3 = this._bitmaps[_loc_4][_loc_7];
                    if (_loc_3.visible)
                    {
                        _loc_3.visible = false;
                        removeChild(_loc_3.bitmap);
                    }
                    _loc_7++;
                }
                _loc_4++;
            }
            var _loc_5:* = -Amath.fromPercent(param1, this._tileWidth * TILE_SIZE) + App.SCR_HALF_W;
            var _loc_6:* = -Amath.fromPercent(param2, this._tileHeight * TILE_SIZE) + App.SCR_HALF_H;
            _loc_5 = _loc_5 > 0 ? (0) : (_loc_5);
            _loc_6 = _loc_6 > 0 ? (0) : (_loc_6);
            _loc_5 = Math.abs(_loc_5) > this.width - App.SCR_W ? (-this.width + App.SCR_W) : (_loc_5);
            _loc_6 = Math.abs(_loc_6) > this.height - App.SCR_H ? (-this.height + App.SCR_H) : (_loc_6);
            x = _loc_5;
            y = _loc_6;
            return;
        }// end function

        public function move(param1:Number, param2:Number) : void
        {
            var _loc_3:* = x;
            var _loc_4:* = y;
            _loc_3 = _loc_3 - param1 / 20;
            _loc_4 = _loc_4 - param2 / 20;
            _loc_3 = _loc_3 > 0 ? (0) : (_loc_3);
            _loc_4 = _loc_4 > 0 ? (0) : (_loc_4);
            _loc_3 = Math.abs(_loc_3) > this.width - App.SCR_W ? (-this.width + App.SCR_W) : (_loc_3);
            _loc_4 = Math.abs(_loc_4) > this.height - App.SCR_H ? (-this.height + App.SCR_H) : (_loc_4);
            x = _loc_3;
            y = _loc_4;
            this.updatePosition();
            return;
        }// end function

        private function updatePosition() : void
        {
            var _loc_1:Object = null;
            var _loc_5:int = 0;
            var _loc_2:* = Math.abs(x);
            var _loc_3:* = Math.abs(y);
            var _loc_4:int = 0;
            while (_loc_4 < this._tileHeight)
            {
                
                _loc_5 = 0;
                while (_loc_5 < this._tileWidth)
                {
                    
                    _loc_1 = this._bitmaps[_loc_4][_loc_5];
                    if (!_loc_1.visible && _loc_1.bitmap.x + TILE_SIZE > _loc_2 && _loc_1.bitmap.x < _loc_2 + App.SCR_W && _loc_1.bitmap.y + TILE_SIZE > _loc_3 && _loc_1.bitmap.y < _loc_3 + App.SCR_H)
                    {
                        _loc_1.visible = true;
                        addChild(_loc_1.bitmap);
                    }
                    else if (_loc_1.visible && (_loc_1.bitmap.x + TILE_SIZE < _loc_2 || _loc_1.bitmap.x > _loc_2 + App.SCR_W || (_loc_1.bitmap.y + TILE_SIZE < _loc_3 || _loc_1.bitmap.y > _loc_3 + App.SCR_H)))
                    {
                        _loc_1.visible = false;
                        removeChild(_loc_1.bitmap);
                    }
                    _loc_5++;
                }
                _loc_4++;
            }
            return;
        }// end function

        public function get isInit() : Boolean
        {
            return this._isInit;
        }// end function

        public function processQueue() : void
        {
            if (!this._isInit)
            {
                this.process();
            }
            return;
        }// end function

        override public function get height() : Number
        {
            return this._tileHeight * TILE_SIZE;
        }// end function

        private function process() : void
        {
            var _loc_1:Sprite = null;
            var _loc_4:BitmapData = null;
            var _loc_5:Bitmap = null;
            var _loc_6:Rectangle = null;
            var _loc_7:Matrix = null;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            _loc_1 = this._container.getChildAt(this._list[this.queueCurrent]) as Sprite;
            _loc_2 = Math.round(_loc_1.x / TILE_SIZE);
            _loc_3 = Math.round(_loc_1.y / TILE_SIZE);
            _loc_6 = new Rectangle(_loc_1.x, _loc_1.y, _loc_1.width, _loc_1.height);
            _loc_1.visible = false;
            _loc_4 = new BitmapData(_loc_6.width, _loc_6.height, true, 0);
            _loc_7 = new Matrix();
            _loc_7.translate(-_loc_6.x, -_loc_6.y);
            _loc_4.draw(this._container, _loc_7);
            _loc_5 = new Bitmap();
            _loc_5.bitmapData = _loc_4;
            _loc_5.x = _loc_1.x;
            _loc_5.y = _loc_1.y;
            if (_loc_2 >= 0 && _loc_3 >= 0 && _loc_2 < this._tileWidth && _loc_3 < this._tileHeight)
            {
                this._bitmaps[_loc_3][_loc_2] = {bitmap:_loc_5, visible:false};
            }
            dispatchEvent(new ProcessEvent(ProcessEvent.PROGRESS, this.queueCurrent / this.queueTotal));
            var _loc_8:String = this;
            var _loc_9:* = this.queueCurrent + 1;
            _loc_8.queueCurrent = _loc_9;
            if (this.queueCurrent == this.queueTotal)
            {
                this._isInit = true;
                this._container = null;
                this._list.length = 0;
                dispatchEvent(new ProcessEvent(ProcessEvent.COMPLETE));
            }
            else
            {
                setTimeout(this.process, 1);
            }
            return;
        }// end function

    }
}
