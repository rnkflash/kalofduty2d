package com.zombotron.effects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class EffectElectroShock extends BasicEffect
    {
        public static const CACHE_NAME:String = "EffectElectroShock";

        public function EffectElectroShock()
        {
            _cacheName = CACHE_NAME;
            _layer = Universe.LAYER_FG_EFFECTS;
            _sprite = $.animCache.getAnimation(Art.EFFECT_ELECTRO_SHOCK);
            _smooth = false;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            super.init(param1, param2, param3, param4);
            _universe.effects.add(this);
            return;
        }// end function

        override public function free() : void
        {
            _universe.effects.remove(this);
            super.free();
            return;
        }// end function

        override public function process() : void
        {
            var _loc_1:* = EffectSpark.get();
            _loc_1.speed = new Avector(Amath.random(-3, 3), Amath.random(-1, -5));
            _loc_1.speed.x = _loc_1.speed.x + (_loc_1.speed.x < 0 ? (-3) : (3));
            _loc_1.variety = EffectSpark.BLUE;
            _loc_1.init(_sprite.x, _sprite.y);
            return;
        }// end function

        public static function get() : EffectElectroShock
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectElectroShock;
        }// end function

    }
}
