package com.zombotron.effects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class EffectDustSmall extends BasicEffect
    {
        public var velocity:Avector;
        public static const CACHE_NAME:String = "dustSmall";

        public function EffectDustSmall()
        {
            this.velocity = new Avector();
            _cacheName = CACHE_NAME;
            _smooth = false;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:String = null;
            switch(Amath.random(1, 3))
            {
                case 1:
                {
                    _loc_5 = Art.EFFECT_DUST_SMALL1;
                    break;
                }
                case 2:
                {
                    _loc_5 = Art.EFFECT_DUST_SMALL2;
                    break;
                }
                default:
                {
                    _loc_5 = Art.EFFECT_DUST_SMALL3;
                    break;
                    break;
                }
            }
            _sprite = ZG.animCache.getAnimation(_loc_5);
            _sprite.speed = 0.5;
            this.velocity.y = (-Math.random()) * 0.5;
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
            _sprite.x = _sprite.x + this.velocity.x;
            _sprite.y = _sprite.y + this.velocity.y;
            this.velocity.x = this.velocity.x * 0.9;
            this.velocity.y = this.velocity.y * 0.9;
            return;
        }// end function

        public static function get() : EffectDustSmall
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectDustSmall;
        }// end function

    }
}
