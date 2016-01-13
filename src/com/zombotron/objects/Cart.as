package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.helpers.*;

    public class Cart extends BasicObject
    {
        private var _ragdoll:Ragdoll;
        private var _wheelA:BasicObject;
        private var _wheelB:BasicObject;
        protected var _hitForce:b2Vec2;
        protected var _hitPoint:b2Vec2;
        public static const STRENGTH_OF_JOINT:Number = 50;
        public static const RAGDOLL_NAME:String = "CartRagdoll";
        public static const HEALTH:Number = 1;

        public function Cart()
        {
            this._hitPoint = new b2Vec2();
            this._hitForce = new b2Vec2();
            group = Kind.GROUP_BREAKABLE;
            _kind = Kind.CART;
            this._ragdoll = _universe.ragdollStorage.getValue(RAGDOLL_NAME);
            return;
        }// end function

        override public function die() : void
        {
            if (!_isDead)
            {
                this.makeDeadBody(this.x, this.y);
                _isDead = true;
            }
            return;
        }// end function

        override public function explode(param1:BasicObject, param2:b2Vec2, param3:b2Vec2) : Boolean
        {
            var _loc_4:Number = NaN;
            if (!_die)
            {
                _loc_4 = Amath.distance(_body.GetPosition().x, _body.GetPosition().y, param1.body.GetPosition().x, param1.body.GetPosition().y);
                _health = _health - param1.damage / _loc_4;
                if (_health <= 0)
                {
                    _health = 0;
                    this._hitPoint = new b2Vec2(param2.x, param2.y);
                    this._hitForce = new b2Vec2(param3.x, param3.y);
                    this.makeDeadBody(this.x, this.y);
                    _die = true;
                    return true;
                }
                return false;
            }
            else
            {
                return false;
            }
        }// end function

        override public function attacked(param1:b2Vec2, param2:b2Vec2, param3:Number = 1) : Boolean
        {
            var _loc_4:EffectBlow = null;
            if (!_die)
            {
                _health = _health - param3;
                if (_health <= 0)
                {
                    this._hitPoint = new b2Vec2(param1.x, param1.y);
                    this._hitForce = new b2Vec2(param2.x * 2, param2.y * 2);
                    this.makeDeadBody(this.x, this.y);
                    _die = true;
                }
                else
                {
                    _body.ApplyImpulse(new b2Vec2(param2.x * 2, param2.y * 2), param1);
                }
                _loc_4 = EffectBlow.get();
                _loc_4.init(param1.x * Universe.DRAW_SCALE, param1.y * Universe.DRAW_SCALE);
            }
            return false;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.physics.DestroyBody(_body);
                super.free();
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _sprite = ZG.animCache.getAnimation(Art.CART);
            _sprite.smoothing = _universe.smoothing;
            addChild(_sprite);
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_6.density = 0.5;
            _loc_6.friction = 0.2;
            _loc_6.restitution = 0.1;
            _loc_5.userData = this;
            _loc_5.angle = param3 * (Math.PI / 180);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_6.SetAsOrientedBox(35 / Universe.DRAW_SCALE, 6 / Universe.DRAW_SCALE, new b2Vec2(), 0);
            _loc_6.filter.categoryBits = 4;
            _loc_6.filter.groupIndex = -1;
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            this._wheelA = CartWheel.get();
            this._wheelA.kind = Kind.CART_WHEEL;
            this._wheelA.init(param1 - 21, param2 + 9);
            this._wheelB = CartWheel.get();
            this._wheelB.kind = Kind.CART_WHEEL;
            this._wheelB.init(param1 + 21, param2 + 9);
            var _loc_7:* = new b2RevoluteJointDef();
            _loc_7.Initialize(_body, this._wheelA.body, this._wheelA.body.GetWorldCenter());
            _universe.physics.CreateJoint(_loc_7);
            _loc_7 = new b2RevoluteJointDef();
            _loc_7.Initialize(_body, this._wheelB.body, this._wheelB.body.GetWorldCenter());
            _universe.physics.CreateJoint(_loc_7);
            reset();
            _health = HEALTH;
            return;
        }// end function

        override public function bulletCollision(param1:Bullet, param2:b2Vec2) : void
        {
            if (!_die)
            {
                _health = _health - param1.damage;
                if (_health <= 0)
                {
                    this._hitPoint = new b2Vec2(param2.x, param2.y);
                    this._hitForce = new b2Vec2(param1.body.GetLinearVelocity().x / 20, param1.body.GetLinearVelocity().y / 20);
                    _universe.deads.add(this);
                    _die = true;
                }
            }
            return;
        }// end function

        public function makeDeadBody(param1:Number, param2:Number) : void
        {
            var _loc_7:b2RevoluteJoint = null;
            var _loc_3:* = this._ragdoll.getBody("leftBody");
            var _loc_4:* = CartPart.get();
            _loc_4.variety = CartPart.BODY_LEFT;
            _loc_4.setSize(_loc_3.width, _loc_3.height);
            _loc_4.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getBody("rightBody");
            var _loc_5:* = CartPart.get();
            _loc_5.variety = CartPart.BODY_RIGHT;
            _loc_5.setSize(_loc_3.width, _loc_3.height);
            _loc_5.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            var _loc_6:* = new b2RevoluteJointDef();
            var _loc_8:* = new b2Vec2();
            var _loc_9:* = new b2Vec2(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_3 = this._ragdoll.getJoint("jointBody");
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_4.body, _loc_5.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, 25);
            _loc_3 = this._ragdoll.getBody("handle");
            var _loc_10:* = CartPart.get();
            _loc_10.variety = CartPart.HANDLE;
            _loc_10.setSize(_loc_3.width, _loc_3.height);
            _loc_10.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getJoint("jointHandle");
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_4.body, _loc_10.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            _loc_4.render();
            _loc_5.render();
            _loc_10.render();
            var _loc_11:* = EffectExplosion.get();
            _loc_11.variety = EffectExplosion.OBJECT_EXPLOSION;
            _loc_11.init(param1, param2);
            ZG.sound(SoundManager.OBJECT_EXPLOSION, this, true);
            _loc_4.body.ApplyImpulse(this._hitForce, this._hitPoint);
            var _loc_12:* = ZG.saveBox;
            var _loc_13:* = ZG.saveBox.destroyedObjects + 1;
            _loc_12.destroyedObjects = _loc_13;
            this.free();
            return;
        }// end function

    }
}
