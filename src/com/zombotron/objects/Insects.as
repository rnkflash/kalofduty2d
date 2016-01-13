package com.zombotron.objects
{
    import com.antkarlov.anim.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;

    public class Insects extends BasicObject implements IActiveObject
    {
        private var _insects:Array;
        private var _alias:String = "nonameInsects";
        public var areaHeight:int = 10;
        private var _color:uint = 1;
        public var numInsects:uint = 3;
        private var _target:Avector;
        private var _changeInterval:int = 0;
        public var areaWidth:int = 10;

        public function Insects()
        {
            this._insects = [];
            this._target = new Avector();
            _kind = Kind.INSECTS;
            _layer = Universe.LAYER_FG_EFFECTS;
            return;
        }// end function

        public function changeState() : void
        {
            return;
        }// end function

        public function set color(param1:String) : void
        {
            switch(param1)
            {
                case "yellow":
                {
                    this._color = 2;
                    break;
                }
                default:
                {
                    this._color = 1;
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function get activateDistance() : int
        {
            return -1;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:Animation = null;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:Avector = null;
            var _loc_9:int = 0;
            while (_loc_9 < this.numInsects)
            {
                
                _loc_8 = new Avector();
                _loc_8.x = Amath.random(param1 - this.areaWidth * 0.5, param1 + this.areaWidth * 0.5);
                _loc_8.y = Amath.random(param2 - this.areaHeight * 0.5, param2 + this.areaHeight * 0.5);
                _loc_6 = Amath.random(1, 3);
                _loc_7 = Amath.random(2, 5);
                _loc_5 = ZG.animCache.getAnimation(Art.PARTICLE_INSECTS);
                _loc_5.gotoAndStop(this._color);
                _loc_5.x = Amath.random(param1 - this.areaWidth * 0.5, param1 + this.areaWidth * 0.5);
                _loc_5.y = Amath.random(param2 - this.areaHeight * 0.5, param2 + this.areaHeight * 0.5);
                this._insects[this._insects.length] = {sprite:_loc_5, velocity:_loc_6, angularVelocity:_loc_7, target:_loc_8, fade:false, fadeDelay:Amath.random(1, 20), angle:0, speed:new Avector()};
                addChild(_loc_5);
                _loc_9++;
            }
            _position.set(param1, param2);
            this._target.x = Amath.random(param1 - this.areaWidth * 0.5, param1 + this.areaWidth * 0.5);
            this._target.y = Amath.random(param2 - this.areaHeight * 0.5, param2 + this.areaHeight * 0.5);
            this._changeInterval = Amath.random(50, 200);
            reset();
            show();
            _universe.objects.add(this);
            return;
        }// end function

        override public function render() : void
        {
            return;
        }// end function

        public function get alias() : String
        {
            return this._alias;
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        override public function free() : void
        {
            var _loc_1:Object = null;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (!_isFree)
            {
                _loc_2 = this._insects.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_1 = this._insects[_loc_3];
                    removeChild(_loc_1.sprite);
                    this._insects[_loc_3] = null;
                    _loc_3++;
                }
                this._insects.length = 0;
                _universe.objects.remove(this);
                super.free();
            }
            return;
        }// end function

        override public function visibleCulling() : void
        {
            if (_visibleCulling)
            {
                _tileX = _position.x / LevelBase.TILE_SIZE;
                _tileY = _position.y / LevelBase.TILE_SIZE;
                if (_tileX >= _universe.level.tileX1 && _tileX < _universe.level.tileX2 && _tileY >= _universe.level.tileY1 && _tileY < _universe.level.tileY2)
                {
                    show();
                }
                else
                {
                    hide();
                }
            }
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector();
        }// end function

        override public function process() : void
        {
            var _loc_1:Object = null;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            this.visibleCulling();
            if (!_isVisible)
            {
                return;
            }
            var _loc_4:int = 0;
            while (_loc_4 < this.numInsects)
            {
                
                _loc_1 = this._insects[_loc_4];
                _loc_2 = Amath.getAngleDeg(_loc_1.sprite.x, _loc_1.sprite.y, _loc_1.target.x, _loc_1.target.y);
                _loc_3 = _loc_1.angle - _loc_2;
                if (_loc_3 > 180)
                {
                    _loc_3 = -360 + _loc_3;
                }
                else if (_loc_3 < -180)
                {
                    _loc_3 = 360 + _loc_3;
                }
                if (Math.abs(_loc_3) < _loc_1.angularVelocity)
                {
                    _loc_1.angle = _loc_1.angle - _loc_3;
                }
                else if (_loc_3 > 0)
                {
                    _loc_1.angle = _loc_1.angle - _loc_1.angularVelocity;
                }
                else
                {
                    _loc_1.angle = _loc_1.angle + _loc_1.angularVelocity;
                }
                _loc_1.speed.asSpeed(_loc_1.velocity * 0.5, Amath.toRadians(_loc_1.angle));
                _loc_1.sprite.x = _loc_1.sprite.x + _loc_1.speed.x;
                _loc_1.sprite.y = _loc_1.sprite.y + _loc_1.speed.y;
                if (_loc_1.fadeDelay <= 0)
                {
                    _loc_1.fade = true;
                }
                else if (!_loc_1.fade)
                {
                    var _loc_5:* = _loc_1;
                    var _loc_6:* = _loc_1.fadeDelay - 1;
                    _loc_5.fadeDelay = _loc_6;
                    if (_loc_1.sprite.alpha <= 1)
                    {
                        _loc_1.sprite.alpha = _loc_1.sprite.alpha + 0.05;
                    }
                }
                if (_loc_1.fade)
                {
                    _loc_1.sprite.alpha = _loc_1.sprite.alpha - 0.05;
                    if (_loc_1.sprite.alpha <= 0)
                    {
                        _loc_1.sprite.alpha = 0;
                        _loc_1.fade = false;
                        _loc_1.fadeDelay = Amath.random(1, 20);
                    }
                }
                if (this._changeInterval <= 0)
                {
                    _loc_1.target.x = Amath.random(_position.x - this.areaWidth * 0.5, _position.x + this.areaWidth * 0.5);
                    _loc_1.target.y = Amath.random(_position.y - this.areaHeight * 0.5, _position.y + this.areaHeight * 0.5);
                    _loc_1.velocity = Amath.random(1, 3);
                    _loc_1.angularVelocity = Amath.random(2, 5);
                    this._changeInterval = Amath.random(50, 200);
                }
                _loc_4++;
            }
            var _loc_5:String = this;
            var _loc_6:* = this._changeInterval - 1;
            _loc_5._changeInterval = _loc_6;
            return;
        }// end function

        public function action(param1:Function = null) : void
        {
            return;
        }// end function

    }
}
