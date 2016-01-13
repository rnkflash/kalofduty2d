package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;

    public class CartPart extends BasicObject
    {
        private var _height:Number = 10;
        private var _width:Number = 10;
        private var _lifeTime:int;
        public static const BODY_LEFT:int = 1;
        public static const BODY_RIGHT:int = 2;
        public static const HANDLE:int = 3;
        public static const CACHE_NAME:String = "CartParts";

        public function CartPart()
        {
            _kind = Kind.CART_PART;
            _sprite = ZG.animCache.getAnimation(Art.CART_PARTS);
            return;
        }// end function

        public function setSize(param1:Number, param2:Number) : void
        {
            this._width = param1 * 0.5;
            this._height = param2 * 0.5;
            return;
        }// end function

        override public function hitEffect(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
        {
            var _loc_5:* = EffectHitTo.get();
            _loc_5.variety = EffectHitTo.METAL;
            _loc_5.init(param1, param2, param3, param4);
            ZG.sound(SoundManager.HIT_TO_ROBOT, this, true);
            return true;
        }// end function

        override public function process() : void
        {
            if (_universe.frameTime - _birthTime >= this._lifeTime)
            {
                _sprite.alpha = _sprite.alpha - 0.02;
                if (_sprite.alpha <= 0)
                {
                    _sprite.alpha = 0;
                    this.free();
                }
            }
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.bodies.remove(this);
                _universe.physics.DestroyBody(_body);
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                super.free();
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_6.density = 0.5;
            _loc_6.friction = 0.8;
            _loc_6.restitution = 0.1;
            _loc_6.filter.groupIndex = -2;
            _loc_5.userData = this;
            _loc_6.SetAsBox(this._width / Universe.DRAW_SCALE, this._height / Universe.DRAW_SCALE);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_5.angle = Amath.toRadians(param3);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            _sprite.gotoAndStop(_variety);
            _sprite.scaleX = param4;
            _sprite.smoothing = _universe.smoothing;
            _sprite.alpha = 1;
            addChild(_sprite);
            reset();
            this._lifeTime = 250;
            _universe.bodies.add(this);
            update();
            return;
        }// end function

        public static function get() : CartPart
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as CartPart;
        }// end function

    }
}
