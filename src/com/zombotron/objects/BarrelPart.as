package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;

    public class BarrelPart extends BasicObject
    {
        private var _lifeTime:int = 0;
        public static const BASIC_TOP:uint = 1;
        public static const EXPLOSION_BOTTOM:uint = 3;
        public static const CACHE_NAME:String = "BarrelParts";
        public static const BASIC_BOTTOM:uint = 2;

        public function BarrelPart()
        {
            _kind = Kind.BARREL_PART;
            _sprite = $.animCache.getAnimation(Art.BARREL_PARTS);
            _variety = BASIC_TOP;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_7:EffectBurn = null;
            _birthTime = _universe.frameTime;
            this._lifeTime = Amath.random(100, 250);
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_6.density = 0.5;
            _loc_6.friction = 0.2;
            _loc_6.restitution = 0.1;
            _loc_6.filter.groupIndex = -2;
            _loc_5.userData = this;
            _loc_5.angle = param3;
            _loc_5.position.Set(param1, param2);
            _loc_6.SetAsOrientedBox(11 / Universe.DRAW_SCALE, 6 / Universe.DRAW_SCALE, new b2Vec2(), 0);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            _isDead = false;
            _isFree = false;
            _die = false;
            _sprite.alpha = 1;
            _sprite.smoothing = _universe.smoothing;
            _sprite.gotoAndStop(_variety);
            addChild(_sprite);
            if (_variety == EXPLOSION_BOTTOM)
            {
                _loc_7 = EffectBurn.get();
                _loc_7.setBody(_body, new b2Vec2(0, -10));
                _loc_7.init(param1 * Universe.DRAW_SCALE, param2 * Universe.DRAW_SCALE);
            }
            _universe.add(this, _layer);
            _universe.bodies.add(this);
            update();
            return;
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

        public static function get() : BarrelPart
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as BarrelPart;
        }// end function

    }
}
