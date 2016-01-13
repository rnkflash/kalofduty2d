package com.zombotron.effects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class EffectPixel extends BasicEffect
    {
        private var _delay:int;
        public var speed:Avector;
        private var _variety:uint = 1;
        public var fadeSpeed:Number = 0.05;
        public static const PIXEL_ORANGE:uint = 2;
        public static const CACHE_NAME:String = "EffectPixel";
        public static const PIXEL_GREEN:uint = 1;

        public function EffectPixel()
        {
            this.speed = new Avector();
            this._delay = 0;
            _cacheName = CACHE_NAME;
            _layer = Universe.LAYER_FG_EFFECTS;
            _sprite = ZG.animCache.getAnimation(Art.PARTICLE_PIXEL);
            return;
        }// end function

        override public function process() : void
        {
            x = x + this.speed.x;
            y = y + this.speed.y;
            this.speed.y = this.speed.y + 0.4;
            this.speed.x = this.speed.x * 0.95;
            _sprite.alpha = _sprite.alpha - this.fadeSpeed;
            _sprite.scaleX = _sprite.scaleX - 0.01;
            _sprite.scaleY = _sprite.scaleX;
            if (_sprite.alpha <= 0)
            {
                _sprite.alpha = 0;
                this.free();
            }
            if (this._delay <= 0)
            {
                this._delay = 2;
                _sprite.rotation = this.speed.angleDeg();
            }
            else
            {
                var _loc_1:String = this;
                var _loc_2:* = this._delay - 1;
                _loc_1._delay = _loc_2;
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            this.fadeSpeed = 0.05;
            this.variety = PIXEL_GREEN;
            var _loc_5:* = param4;
            _sprite.scaleY = param4;
            _sprite.scaleX = _loc_5;
            _sprite.alpha = 1;
            _sprite.smoothing = _universe.smoothing;
            x = param1;
            y = param2;
            _sprite.rotation = param3;
            addChild(_sprite);
            _universe.add(this, _layer);
            _isFree = false;
            _universe.effects.add(this);
            return;
        }// end function

        override public function free() : void
        {
            _universe.effects.remove(this);
            super.free();
            return;
        }// end function

        public function set variety(param1:uint) : void
        {
            if (this._variety != param1)
            {
                this._variety = param1;
                _sprite.gotoAndStop(param1);
            }
            return;
        }// end function

        public static function get() : EffectPixel
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectPixel;
        }// end function

    }
}
