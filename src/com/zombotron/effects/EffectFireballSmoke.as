package com.zombotron.effects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class EffectFireballSmoke extends BasicEffect
    {
        public var speed:Avector;
        public static const CACHE_NAME:String = "EffectFireballSmoke";

        public function EffectFireballSmoke()
        {
            this.speed = new Avector();
            _cacheName = CACHE_NAME;
            _sprite = ZG.animCache.getAnimation(Art.EFFECT_FIREBALL_SMOKE);
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _sprite.gotoAndPlay(1);
            super.init(param1, param2, 0, param4);
            this.speed.x = _sprite.scaleX == 1 ? (-1) : (1);
            return;
        }// end function

        override public function process() : void
        {
            _sprite.x = _sprite.x + this.speed.x;
            this.speed.x = this.speed.x * 0.95;
            return;
        }// end function

        override public function free() : void
        {
            super.free();
            return;
        }// end function

        public static function get() : EffectFireballSmoke
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectFireballSmoke;
        }// end function

    }
}
