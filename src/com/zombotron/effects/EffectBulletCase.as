package com.zombotron.effects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class EffectBulletCase extends BasicEffect
    {
        private var _speed:Avector;
        private var _variety:uint = 0;
        private var _rotate:Number;
        public static const SHOTGUN:uint = 2;
        public static const CACHE_NAME:String = "EffectBulletCase";
        public static const BASIC:uint = 1;

        public function EffectBulletCase()
        {
            _cacheName = CACHE_NAME;
            this.variety = BASIC;
            this._speed = new Avector();
            this._rotate = 0;
            return;
        }// end function

        override public function process() : void
        {
            _sprite.x = _sprite.x + this._speed.x;
            _sprite.y = _sprite.y + this._speed.y;
            _sprite.rotation = _sprite.rotation + this._rotate;
            this._speed.y = this._speed.y + 0.8;
            this._speed.x = this._speed.x * 0.95;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _sprite.play();
            addChild(_sprite);
            if (param4 < 0)
            {
                this._speed.x = Amath.random(2, 4);
            }
            else
            {
                this._speed.x = Amath.random(-2, -4);
            }
            this._speed.y = Amath.random(-4, -8);
            this._rotate = Amath.random(-5, 5);
            super.init(param1, param2);
            _universe.effects.add(this);
            return;
        }// end function

        override public function free() : void
        {
            _universe.effects.remove(this);
            super.free();
            return;
        }// end function

        public function set variety(param1:uint) : void
        {
            if (this._variety != param1)
            {
                this._variety = param1;
                switch(this._variety)
                {
                    case SHOTGUN:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_BULLET_CASE2);
                        break;
                    }
                    default:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.EFFECT_BULLET_CASE1);
                        break;
                        break;
                    }
                }
            }
            return;
        }// end function

        public static function get() : EffectBulletCase
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectBulletCase;
        }// end function

    }
}
