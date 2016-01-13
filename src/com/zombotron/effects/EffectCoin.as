package com.zombotron.effects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class EffectCoin extends BasicEffect
    {
        private var _sparkInterval:int = 0;
        private var _pixel:EffectPixel;
        private var _rotationSpeed:int = 10;
        private var _speed:Avector;
        private var _target:Avector;
        private var _angle:Number = 45;
        private var _pos:Avector;
        public static const CACHE_NAME:String = "EffectCoin";

        public function EffectCoin()
        {
            this._speed = new Avector();
            this._pos = new Avector();
            _cacheName = CACHE_NAME;
            _sprite = $.animCache.getAnimation(Art.COIN);
            _layer = Universe.LAYER_FG_EFFECTS;
            return;
        }// end function

        override public function free() : void
        {
            this._pixel = null;
            _universe.effects.remove(this);
            super.free();
            return;
        }// end function

        override public function process() : void
        {
            var _loc_3:int = 0;
            this._pos.x = _sprite.x + _universe.x;
            this._pos.y = _sprite.y + _universe.y;
            var _loc_1:* = Amath.getAngleDeg(this._pos.x, this._pos.y, this._target.x, this._target.y);
            var _loc_2:* = this._angle - _loc_1;
            if (_loc_2 > 180)
            {
                _loc_2 = -360 + _loc_2;
            }
            else if (_loc_2 < -180)
            {
                _loc_2 = 360 + _loc_2;
            }
            if (Math.abs(_loc_2) < this._rotationSpeed)
            {
                this._angle = this._angle - _loc_2;
            }
            else if (_loc_2 > 0)
            {
                this._angle = this._angle - this._rotationSpeed;
            }
            else
            {
                this._angle = this._angle + this._rotationSpeed;
            }
            this._speed.asSpeed(10, Amath.toRadians(this._angle));
            _sprite.x = _sprite.x + this._speed.x;
            _sprite.y = _sprite.y + this._speed.y;
            var _loc_4:String = this;
            var _loc_5:* = this._sparkInterval - 1;
            _loc_4._sparkInterval = _loc_5;
            if (this._sparkInterval <= 0)
            {
                this._pixel = EffectPixel.get();
                this._pixel.speed.set(this._speed.x * 0.2 + Amath.random(-2, 2), this._speed.y * 0.2 + Amath.random(-2, -2));
                this._pixel.init(_sprite.x + Amath.random(-3, 3), _sprite.y + Amath.random(-3, 3), 0, 0.6);
                this._sparkInterval = Amath.random(2, 6);
            }
            if (Amath.distance(this._pos.x, this._pos.y, this._target.x, this._target.y) < 25)
            {
                _universe.player.giveCoin();
                _loc_3 = 0;
                while (_loc_3 < 3)
                {
                    
                    this._pixel = EffectPixel.get();
                    this._pixel.speed.set(Amath.random(-3, 3), Amath.random(-2, -1));
                    this._pixel.init(_sprite.x, _sprite.y);
                    _loc_3++;
                }
                this.free();
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            this._target = ZG.playerGui.getCoinsPos();
            _sprite.x = param1;
            _sprite.y = param2;
            _sprite.play();
            addChild(_sprite);
            _universe.add(this, _layer);
            _universe.effects.add(this);
            _isFree = false;
            this._angle = 45;
            ZG.sound(SoundManager.COIN_COLLECT, _sprite);
            return;
        }// end function

        public static function get() : EffectCoin
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectCoin;
        }// end function

    }
}
