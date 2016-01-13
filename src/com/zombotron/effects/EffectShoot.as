package com.zombotron.effects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class EffectShoot extends BasicEffect
    {
        private var _variety:uint = 0;
        public static const MACHINEGUN_SHOT:uint = 5;
        public static const PISTOL_SHOT:uint = 1;
        public static const GRENADEGUN_SHOT:uint = 4;
        public static const CACHE_NAME:String = "EffectsShoot";
        public static const SHOTGUN_SHOT:uint = 2;
        public static const TURRET_SHOT:uint = 6;
        public static const GUN_SHOT:uint = 3;

        public function EffectShoot()
        {
            this._variety = 0;
            _cacheName = CACHE_NAME;
            this.variety = PISTOL_SHOT;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _sprite.gotoAndStop(1);
            super.init(param1, param2, param3, param4);
            if (this._variety != MACHINEGUN_SHOT)
            {
                _sprite.scaleY = Amath.random(-1, 1) < 0 ? (-1) : (1);
            }
            else
            {
                _sprite.scaleY = 1;
            }
            return;
        }// end function

        public function set variety(param1:uint) : void
        {
            if (this._variety != param1)
            {
                this._variety = param1;
                switch(this._variety)
                {
                    case PISTOL_SHOT:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_PISTOL_SHOT);
                        break;
                    }
                    case SHOTGUN_SHOT:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_SHOTGUN_SHOT);
                        break;
                    }
                    case GUN_SHOT:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_GUN_SHOT);
                        break;
                    }
                    case GRENADEGUN_SHOT:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_GRENADEGUN_SHOT);
                        break;
                    }
                    case MACHINEGUN_SHOT:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_MACHINEGUN_SHOT);
                        break;
                    }
                    case TURRET_SHOT:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_TURRET_SHOT);
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

        public static function get() : EffectShoot
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectShoot;
        }// end function

    }
}
