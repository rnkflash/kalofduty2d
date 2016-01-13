package com.zombotron.effects
{
    import com.zombotron.core.*;

    public class EffectBurnSmall extends EffectBurn
    {
        public static const CACHE_NAME:String = "EffectBurnSmall";

        public function EffectBurnSmall()
        {
            _cacheName = CACHE_NAME;
            super(_cacheName);
            return;
        }// end function

        public static function get() : EffectBurnSmall
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectBurnSmall;
        }// end function

    }
}
