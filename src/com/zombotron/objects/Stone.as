package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.helpers.*;

    public class Stone extends BasicObject
    {
        private var _hitPoint:b2Vec2;
        private var _ragdoll:Ragdoll;
        private var _hitForce:b2Vec2;
        private static const STRENGTH_OF_JOINT:int = 25;
        public static const CACHE_NAME:String = "Stones";
        public static const RAGDOLL_NAME1:String = "StoneRagdoll1";
        public static const RAGDOLL_NAME2:String = "StoneRagdoll2";
        public static const STONE1:uint = 1;
        public static const STONE2:uint = 2;
        private static const HEALTH:Number = 1;

        public function Stone()
        {
            group = Kind.GROUP_BREAKABLE;
            _kind = Kind.STONE;
            _sprite = ZG.animCache.getAnimation(Art.STONE);
            _allowContacts = true;
            this.variety = STONE1;
            return;
        }// end function

        override public function die() : void
        {
            if (!_isDead)
            {
                this._hitForce.x = this._hitForce.x / 15;
                this._hitForce.y = this._hitForce.y / 15;
                this.makeDeadBody(this.x, this.y);
                _isDead = true;
            }
            return;
        }// end function

        override public function addContact(param1:b2ContactPoint) : Boolean
        {
            if (super.addContact(param1))
            {
                if (_body.GetLinearVelocity().Length() > 5)
                {
                    ZG.sound(SoundManager.STONE_COLLISION, this, true);
                }
                return true;
            }
            return false;
        }// end function

        override public function fatalDamage(param1:b2Vec2, param2:b2Vec2) : void
        {
            this._hitPoint = new b2Vec2(param1.x, param1.y);
            this._hitForce = new b2Vec2(param2.x / 2.5, param2.y / 2.5);
            _universe.deads.add(this);
            _die = true;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_6:b2CircleDef = null;
            _health = HEALTH;
            reset();
            _sprite.smoothing = _universe.smoothing;
            _sprite.gotoAndStop(_variety);
            addChild(_sprite);
            var _loc_5:* = new b2BodyDef();
            _loc_6 = new b2CircleDef();
            _loc_6.radius = _variety == STONE1 ? (0.7) : (0.5);
            _loc_6.density = 0.7;
            _loc_6.friction = 5;
            _loc_6.restitution = 0.1;
            _loc_6.filter.categoryBits = 4;
            _loc_5.userData = this;
            _loc_5.angle = param3 * (Math.PI / 180);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            return;
        }// end function

        override public function explode(param1:BasicObject, param2:b2Vec2, param3:b2Vec2) : Boolean
        {
            var _loc_4:Number = NaN;
            if (!_isDead)
            {
                _loc_4 = Amath.distance(_body.GetPosition().x, _body.GetPosition().y, param1.body.GetPosition().x, param1.body.GetPosition().y);
                _health = _health - param1.damage / _loc_4;
                if (_health <= 0)
                {
                    _health = 0;
                    this._hitPoint = new b2Vec2(param2.x, param2.y);
                    this._hitForce = new b2Vec2(param3.x * 3, param3.y * 3);
                    this.makeDeadBody(this.x, this.y);
                    return true;
                }
            }
            return false;
        }// end function

        override public function attacked(param1:b2Vec2, param2:b2Vec2, param3:Number = 1) : Boolean
        {
            _health = _health - param3 * 2.5;
            if (_health <= 0)
            {
                _health = 0;
                this._hitPoint = new b2Vec2(param1.x, param1.y);
                this._hitForce = new b2Vec2(param2.x * 2, param2.y * 2);
                this.makeDeadBody(this.x, this.y);
            }
            else
            {
                _body.ApplyImpulse(param2, param1);
            }
            var _loc_4:* = EffectBlow.get();
            _loc_4.init(param1.x * Universe.DRAW_SCALE, param1.y * Universe.DRAW_SCALE);
            return false;
        }// end function

        override public function set variety(param1:uint) : void
        {
            if (_variety != param1)
            {
                _variety = param1;
                _sprite.gotoAndStop(_variety);
                switch(_variety)
                {
                    case STONE1:
                    {
                        this._ragdoll = _universe.ragdollStorage.getValue(RAGDOLL_NAME1);
                        break;
                    }
                    case STONE2:
                    {
                        this._ragdoll = _universe.ragdollStorage.getValue(RAGDOLL_NAME2);
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

        private function makeDeadBody(param1:Number, param2:Number) : void
        {
            var _loc_8:b2RevoluteJoint = null;
            var _loc_3:* = this._ragdoll.getBody("part1");
            var _loc_4:* = StonePart.get();
            _loc_4.variety = _variety == STONE1 ? (StonePart.STONE1_PART1) : (StonePart.STONE2_PART1);
            _loc_4.setSize(_loc_3.width, _loc_3.height);
            _loc_4.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getBody("part2");
            var _loc_5:* = StonePart.get();
            _loc_5.variety = _variety == STONE1 ? (StonePart.STONE1_PART2) : (StonePart.STONE2_PART2);
            _loc_5.setSize(_loc_3.width, _loc_3.height);
            _loc_5.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getBody("part3");
            var _loc_6:* = StonePart.get();
            _loc_6.variety = _variety == STONE1 ? (StonePart.STONE1_PART3) : (StonePart.STONE2_PART3);
            _loc_6.setSize(_loc_3.width, _loc_3.height);
            _loc_6.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            var _loc_7:* = new b2RevoluteJointDef();
            var _loc_9:* = new b2Vec2();
            var _loc_10:* = new b2Vec2(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_3 = this._ragdoll.getJoint("joint1");
            _loc_3.addOffset(_loc_10, _loc_9);
            _loc_3.setLimits(_loc_7);
            _loc_7.Initialize(_loc_4.body, _loc_5.body, _loc_9);
            _loc_8 = _universe.physics.CreateJoint(_loc_7) as b2RevoluteJoint;
            _universe.joints.add(_loc_8, STRENGTH_OF_JOINT);
            _loc_3 = this._ragdoll.getJoint("joint2");
            _loc_3.addOffset(_loc_10, _loc_9);
            _loc_3.setLimits(_loc_7);
            _loc_7.Initialize(_loc_4.body, _loc_6.body, _loc_9);
            _loc_8 = _universe.physics.CreateJoint(_loc_7) as b2RevoluteJoint;
            _universe.joints.add(_loc_8, STRENGTH_OF_JOINT);
            _loc_4.render();
            _loc_5.render();
            _loc_6.render();
            var _loc_11:* = EffectExplosion.get();
            _loc_11.variety = EffectExplosion.OBJECT_EXPLOSION;
            _loc_11.init(param1, param2);
            ZG.sound(SoundManager.STONE_BREAK, this, true);
            _loc_4.body.ApplyImpulse(this._hitForce, this._hitPoint);
            var _loc_12:* = ZG.saveBox;
            var _loc_13:* = ZG.saveBox.destroyedObjects + 1;
            _loc_12.destroyedObjects = _loc_13;
            this.free();
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

        override public function bulletCollision(param1:Bullet, param2:b2Vec2) : void
        {
            if (!_die)
            {
                _health = _health - param1.damage;
                if (_health <= 0)
                {
                    _health = 0;
                    this._hitPoint = new b2Vec2(param2.x, param2.y);
                    this._hitForce = new b2Vec2(param1.body.GetLinearVelocity().x, param1.body.GetLinearVelocity().y);
                    _universe.deads.add(this);
                    _die = true;
                }
            }
            return;
        }// end function

        public static function get() : Stone
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as Stone;
        }// end function

    }
}
