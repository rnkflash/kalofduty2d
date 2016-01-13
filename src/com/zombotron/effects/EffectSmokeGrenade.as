package com.zombotron.effects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class EffectSmokeGrenade extends BasicEffect
    {
        public var speed:Avector;
        public static const CACHE_NAME:String = "EffectSmokeGrenade";

        public function EffectSmokeGrenade()
        {
            this.speed = new Avector();
            _cacheName = CACHE_NAME;
            _sprite = ZG.animCache.getAnimation(Art.EFFECT_SMOKE_GRENADE);
            _sprite.speed = 0.5;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _sprite.gotoAndStop(1);
            super.init(param1, param2, Amath.random(0, 360));
            return;
        }// end function

        override public function process() : void
        {
            return;
        }// end function

        override public function free() : void
        {
            super.free();
            return;
        }// end function

        public static function get() : EffectSmokeGrenade
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectSmokeGrenade;
        }// end function

    }
}
