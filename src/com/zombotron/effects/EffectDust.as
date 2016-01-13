package com.zombotron.effects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class EffectDust extends BasicEffect
    {
        public static const CACHE_NAME:String = "dust";

        public function EffectDust()
        {
            _cacheName = CACHE_NAME;
            _smooth = false;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:* = Amath.random(0, 1) == 0 ? (Art.EFFECT_DUST1) : (Art.EFFECT_DUST2);
            _sprite = ZG.animCache.getAnimation(_loc_5);
            _sprite.speed = 0.5;
            super.init(param1, param2, param3, param4);
            return;
        }// end function

        public static function get() : EffectDust
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectDust;
        }// end function

    }
}
