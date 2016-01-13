package com.zombotron.effects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class EffectHitTo extends BasicEffect
    {
        private var _variety:uint;
        public static const METAL:uint = 3;
        public static const GROUND:uint = 1;
        public static const CACHE_NAME:String = "EffectHitTo";
        public static const MEAT:uint = 4;
        public static const WOOD:uint = 2;

        public function EffectHitTo()
        {
            this.variety = GROUND;
            _cacheName = CACHE_NAME;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            super.init(param1, param2, param3, param4);
            _sprite.scaleY = Amath.random(-1, 1) < 0 ? (-1) : (1);
            return;
        }// end function

        public function set variety(param1:uint) : void
        {
            if (this._variety != param1)
            {
                this._variety = param1;
                switch(this._variety)
                {
                    case GROUND:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_HIT_TO_GROUND);
                        break;
                    }
                    case WOOD:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_HIT_TO_WOOD);
                        break;
                    }
                    case METAL:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_HIT_TO_METAL);
                        break;
                    }
                    case MEAT:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_HIT_TO_MEAT);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        public static function get() : EffectHitTo
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectHitTo;
        }// end function

    }
}
