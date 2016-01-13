package com.zombotron.effects
{
    import com.zombotron.core.*;

    public class EffectBlow extends BasicEffect
    {
        public static const CACHE_NAME:String = "EffectBlow";

        public function EffectBlow()
        {
            _cacheName = CACHE_NAME;
            _sprite = $.animCache.getAnimation(Art.EFFECT_BLOW);
            return;
        }// end function

        public static function get() : EffectBlow
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectBlow;
        }// end function

    }
}
