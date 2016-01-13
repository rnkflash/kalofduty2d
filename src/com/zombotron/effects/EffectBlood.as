package com.zombotron.effects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class EffectBlood extends BasicEffect
    {
        private var _delay:int;
        public var speed:Avector;
        public static const CACHE_NAME:String = "EffectBlood";

        public function EffectBlood()
        {
            this.speed = new Avector();
            this._delay = 0;
            _cacheName = CACHE_NAME;
            _sprite = $.animCache.getAnimation(Art.PARTICLE_BLOOD);
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            if (this.speed == null)
            {
                this.speed = new Avector(Amath.random(-3, 3), Amath.random(-1, -8));
            }
            super.init(param1, param2);
            _universe.effects.add(this);
            return;
        }// end function

        override public function process() : void
        {
            _sprite.x = _sprite.x + this.speed.x;
            _sprite.y = _sprite.y + this.speed.y;
            this.speed.y = this.speed.y + 0.4;
            this.speed.x = this.speed.x * 0.95;
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

        override public function free() : void
        {
            _universe.effects.remove(this);
            super.free();
            this.speed = null;
            return;
        }// end function

        public static function get() : EffectBlood
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectBlood;
        }// end function

    }
}
