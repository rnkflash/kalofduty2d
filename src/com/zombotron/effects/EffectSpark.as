package com.zombotron.effects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class EffectSpark extends BasicEffect
    {
        private var _delay:int;
        public var speed:Avector;
        private var _variety:uint;
        public static const YELLOW:uint = 1;
        public static const CACHE_NAME:String = "EffectSpark";
        public static const BLUE:uint = 3;
        public static const ORANGE:uint = 2;

        public function EffectSpark()
        {
            this.speed = new Avector();
            this._variety = YELLOW;
            this._delay = 0;
            _cacheName = CACHE_NAME;
            _layer = Universe.LAYER_FG_EFFECTS;
            _sprite = $.animCache.getAnimation(Art.EFFECT_SPARK_YELLOW);
            return;
        }// end function

        override public function process() : void
        {
            _sprite.x = _sprite.x + this.speed.x;
            _sprite.y = _sprite.y + this.speed.y;
            this.speed.y = this.speed.y + 0.4;
            this.speed.x = this.speed.x * 0.95;
            if (this._delay <= 0)
            {
                this._delay = 2;
                _sprite.rotation = this.speed.angleDeg();
            }
            else
            {
                var _loc_1:String = this;
                var _loc_2:* = this._delay - 1;
                _loc_1._delay = _loc_2;
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
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
                    case YELLOW:
                    {
                        _sprite = $.animCache.getAnimation(Art.EFFECT_SPARK_YELLOW);
                        break;
                    }
                    case ORANGE:
                    {
                        _sprite = $.animCache.getAnimation(Art.EFFECT_SPARK_ORANGE);
                        break;
                    }
                    case BLUE:
                    {
                        _sprite = $.animCache.getAnimation(Art.EFFECT_SPARK_BLUE);
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

        public static function get() : EffectSpark
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectSpark;
        }// end function

    }
}
