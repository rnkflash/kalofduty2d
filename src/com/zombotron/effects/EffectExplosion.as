package com.zombotron.effects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class EffectExplosion extends BasicEffect
    {
        private var _variety:uint;
        public static const EXPLOSION:uint = 1;
        public static const CACHE_NAME:String = "EffectExplosion";
        public static const OBJECT_EXPLOSION:uint = 4;
        public static const JOINT_EXPLOSION:uint = 3;
        public static const BOMB_EXPLOSION:uint = 2;

        public function EffectExplosion()
        {
            this.variety = EXPLOSION;
            _cacheName = CACHE_NAME;
            _layer = Universe.LAYER_FG_EFFECTS;
            _smooth = false;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            param4 = Amath.random(-1, 1) < 0 ? (-1) : (1);
            super.init(param1, param2, param3, param4);
            return;
        }// end function

        public function set variety(param1:uint) : void
        {
            if (this._variety != param1)
            {
                this._variety = param1;
                switch(this._variety)
                {
                    case EXPLOSION:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_EXPLOSION);
                        break;
                    }
                    case BOMB_EXPLOSION:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_BOMB_EXPLOSION);
                        break;
                    }
                    case JOINT_EXPLOSION:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_JOINT_EXPLOSION);
                        break;
                    }
                    case OBJECT_EXPLOSION:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_OBJECT_EXPLOSION);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _sprite.speed = 0.5;
            }
            return;
        }// end function

        public static function get() : EffectExplosion
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectExplosion;
        }// end function

    }
}
