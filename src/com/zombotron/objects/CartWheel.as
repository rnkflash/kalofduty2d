package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class CartWheel extends BasicObject
    {
        private var _lifeTime:int;
        public static const CACHE_NAME:String = "CartWheel";

        public function CartWheel()
        {
            this._lifeTime = 0;
            _kind = Kind.CART_WHEEL;
            _sprite = ZG.animCache.getAnimation(Art.CART_WHEEL);
            _layer = Universe.LAYER_MAIN_FG;
            return;
        }// end function

        override public function set kind(param1:uint) : void
        {
            if (_kind != param1)
            {
                _kind = param1;
                switch(_kind)
                {
                    case Kind.CART_WHEEL:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.CART_WHEEL);
                        break;
                    }
                    case Kind.TRUCK_WHEEL:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.TRUCK_WHEEL);
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

        override public function jointDead(param1:b2RevoluteJoint = null) : void
        {
            if (!_isDead)
            {
                this._lifeTime = Amath.random(100, 200);
                _isDead = true;
            }
            return;
        }// end function

        override public function process() : void
        {
            if (_isDead)
            {
                var _loc_1:String = this;
                var _loc_2:* = this._lifeTime - 1;
                _loc_1._lifeTime = _loc_2;
                if (this._lifeTime <= 0)
                {
                    _sprite.alpha = _sprite.alpha - 0.02;
                    if (_sprite.alpha <= 0)
                    {
                        this.free();
                    }
                }
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _sprite.smoothing = _universe.smoothing;
            _sprite.alpha = 1;
            addChild(_sprite);
            var _loc_5:* = new b2CircleDef();
            var _loc_6:* = new b2BodyDef();
            _loc_6.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_6.userData = this;
            switch(_kind)
            {
                case Kind.CART_WHEEL:
                {
                    _loc_5.radius = 0.25;
                    _loc_5.density = 0.5;
                    break;
                }
                case Kind.TRUCK_WHEEL:
                {
                    _loc_5.radius = 0.42;
                    _loc_5.density = 1.5;
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_5.friction = 10;
            _loc_5.restitution = 0.2;
            _loc_5.filter.categoryBits = 2;
            _loc_5.filter.maskBits = 4;
            _loc_5.filter.groupIndex = -1;
            _body = _universe.physics.CreateBody(_loc_6);
            _body.CreateShape(_loc_5);
            _body.SetMassFromShapes();
            reset();
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.physics.DestroyBody(_body);
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                super.free();
            }
            return;
        }// end function

        public static function get() : CartWheel
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as CartWheel;
        }// end function

    }
}
