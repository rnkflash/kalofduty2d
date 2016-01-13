package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;

    public class Bridge extends BasicObject
    {
        private var _deadJoints:int = 0;
        private var _lifeTime:int = 0;
        public static const CACHE_NAME:String = "Bridge";

        public function Bridge()
        {
            _kind = Kind.BRIDGE;
            _sprite = ZG.animCache.getAnimation(Art.BRIDGE);
            _layer = Universe.LAYER_MAIN_FG;
            return;
        }// end function

        override public function jointDead(param1:b2RevoluteJoint = null) : void
        {
            var _loc_2:b2Vec2 = null;
            var _loc_3:EffectExplosion = null;
            if (param1 != null)
            {
                _loc_2 = param1.GetAnchor1();
                _loc_3 = EffectExplosion.get();
                _loc_3.variety = EffectExplosion.JOINT_EXPLOSION;
                _loc_3.init(_loc_2.x * Universe.DRAW_SCALE, _loc_2.y * Universe.DRAW_SCALE, 0, Amath.random(-1, 1) < 0 ? (-1) : (1));
                ZG.sound(SoundManager.JOINT_DEAD, this, true);
                var _loc_4:String = this;
                var _loc_5:* = this._deadJoints + 1;
                _loc_4._deadJoints = _loc_5;
                if (this._deadJoints == 2)
                {
                    _birthTime = _universe.frameTime;
                    this._lifeTime = Amath.random(100, 150);
                    _universe.bodies.add(this);
                    _isDead = true;
                }
            }
            return;
        }// end function

        override public function process() : void
        {
            if (_isDead)
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
            }
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                if (_isDead)
                {
                    _universe.bodies.remove(this);
                }
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                _universe.physics.DestroyBody(_body);
                super.free();
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _sprite.alpha = 1;
            _sprite.smoothing = _universe.smoothing;
            _sprite.gotoAndStop(Amath.random(1, 2));
            addChild(_sprite);
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_6.density = 0.2;
            _loc_6.friction = 0.5;
            _loc_6.restitution = 0.1;
            _loc_6.filter.categoryBits = 4;
            _loc_6.filter.groupIndex = -100;
            _loc_5.userData = this;
            _loc_5.angle = Amath.toRadians(param3);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_6.SetAsBox(25 / Universe.DRAW_SCALE, 6 / Universe.DRAW_SCALE);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            this._deadJoints = 0;
            reset();
            show();
            return;
        }// end function

        public static function get() : Bridge
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as Bridge;
        }// end function

    }
}
