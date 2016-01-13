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

    public class WoodPlank extends BasicObject
    {
        private var _hitForce:b2Vec2;
        private var _hitPoint:b2Vec2;
        private static const STRENGTH_OF_JOINT:int = 25;
        public static const CACHE_NAME:String = "WoodPlanks";
        private static const HEALTH:Number = 1.5;
        public static const WOOD1:uint = 1;
        public static const WOOD2:uint = 2;
        public static const WOOD3:uint = 3;
        public static const WOOD4:uint = 4;
        public static const WOOD5:uint = 5;
        public static const WOOD6:uint = 6;
        public static const WOOD7:uint = 7;
        public static const WOOD8:uint = 8;
        public static const WOOD9:uint = 9;

        public function WoodPlank()
        {
            group = Kind.GROUP_BREAKABLE;
            _kind = Kind.WOOD_PLANK;
            _variety = WOOD1;
            _sprite = $.animCache.getAnimation(Art.WOOD1);
            _allowContacts = true;
            return;
        }// end function

        override public function die() : void
        {
            var _loc_1:b2Body = null;
            if (!_isDead)
            {
                _loc_1 = this.makeDeadBody(this.x, this.y, this.rotation);
                if (_loc_1 != null)
                {
                    this._hitForce.x = this._hitForce.x / 15;
                    this._hitForce.y = this._hitForce.y / 15;
                    _loc_1.ApplyImpulse(this._hitForce, this._hitPoint);
                }
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
                    ZG.sound(SoundManager.WOOD_COLLISION, this, true);
                }
                return true;
            }
            return false;
        }// end function

        override public function attacked(param1:b2Vec2, param2:b2Vec2, param3:Number = 1) : Boolean
        {
            var _loc_5:b2Body = null;
            _health = _health - param3 * 2.5;
            if (_health <= 0)
            {
                _health = 0;
                _loc_5 = this.makeDeadBody(this.x, this.y, this.rotation);
                if (_loc_5 != null)
                {
                    param2.x = param2.x * 2;
                    param2.y = param2.y * 2;
                    _loc_5.ApplyImpulse(param2, param1);
                }
            }
            else
            {
                _body.ApplyImpulse(param2, param1);
            }
            var _loc_4:* = EffectBlow.get();
            _loc_4.init(param1.x * Universe.DRAW_SCALE, param1.y * Universe.DRAW_SCALE);
            ZG.sound(SoundManager.BOX_COLLISION, this, true);
            return false;
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

        override public function set variety(param1:uint) : void
        {
            if (_variety != param1)
            {
                _variety = param1;
                switch(_variety)
                {
                    case WOOD1:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.WOOD1);
                        break;
                    }
                    case WOOD2:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.WOOD2);
                        break;
                    }
                    case WOOD3:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.WOOD3);
                        break;
                    }
                    case WOOD4:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.WOOD4);
                        break;
                    }
                    case WOOD5:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.WOOD5);
                        break;
                    }
                    case WOOD6:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.WOOD6);
                        break;
                    }
                    case WOOD7:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.WOOD7);
                        break;
                    }
                    case WOOD8:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.WOOD8);
                        break;
                    }
                    case WOOD9:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.WOOD9);
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
            var _loc_2:b2Vec2 = null;
            var _loc_3:EffectExplosion = null;
            if (param1 != null)
            {
                _loc_2 = param1.GetAnchor1();
                _loc_3 = EffectExplosion.get();
                _loc_3.variety = EffectExplosion.JOINT_EXPLOSION;
                _loc_3.init(_loc_2.x * Universe.DRAW_SCALE, _loc_2.y * Universe.DRAW_SCALE);
                ZG.sound(SoundManager.JOINT_DEAD, this, true);
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_6:b2PolygonDef = null;
            _sprite.smoothing = _universe.smoothing;
            addChild(_sprite);
            var _loc_5:* = new b2BodyDef();
            _loc_6 = new b2PolygonDef();
            var _loc_7:* = new Avector();
            switch(_variety)
            {
                case WOOD1:
                {
                    _loc_7.set(43, 8);
                    break;
                }
                case WOOD2:
                {
                    _loc_7.set(38, 10);
                    break;
                }
                case WOOD3:
                {
                    _loc_7.set(40, 10);
                    break;
                }
                case WOOD4:
                {
                    _loc_7.set(35, 11);
                    break;
                }
                case WOOD5:
                {
                    _loc_7.set(35, 8);
                    break;
                }
                case WOOD6:
                {
                    _loc_7.set(40, 12);
                    break;
                }
                case WOOD7:
                {
                    _loc_7.set(40, 8);
                    break;
                }
                case WOOD8:
                {
                    _loc_7.set(25, 7);
                    break;
                }
                case WOOD9:
                {
                    _loc_7.set(35, 10);
                    break;
                }
                default:
                {
                    _loc_7.set(43, 10);
                    break;
                    break;
                }
            }
            _loc_6.density = 0.2;
            _loc_6.friction = 0.5;
            _loc_6.restitution = 0.1;
            _loc_6.filter.categoryBits = 4;
            _loc_6.filter.groupIndex = -100;
            _loc_5.userData = this;
            _loc_5.angle = Amath.toRadians(param3);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_6.SetAsBox(_loc_7.x / Universe.DRAW_SCALE, _loc_7.y / Universe.DRAW_SCALE);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            _health = HEALTH;
            reset();
            show();
            update();
            return;
        }// end function

        private function makeDeadBody(param1:Number, param2:Number, param3:Number) : b2Body
        {
            var _loc_9:b2RevoluteJoint = null;
            var _loc_10:b2Vec2 = null;
            var _loc_4:* = new Avector();
            var _loc_5:* = new Avector(_loc_4.x - 20, _loc_4.y);
            _loc_5.rotateAroundDeg(_loc_4, param3);
            var _loc_6:* = WoodPart.get();
            _loc_6.variety = Amath.random(1, 4);
            _loc_6.init(param1 + _loc_5.x, param2 + _loc_5.y, param3);
            var _loc_7:* = WoodPart.get();
            _loc_7.variety = Amath.random(1, 4);
            _loc_7.init(param1 + _loc_4.x, param2 + _loc_4.y, param3);
            var _loc_8:* = new b2RevoluteJointDef();
            _loc_10 = _loc_6.body.GetWorldCenter();
            _loc_8.Initialize(_loc_6.body, _loc_7.body, _loc_10);
            _loc_9 = _universe.physics.CreateJoint(_loc_8) as b2RevoluteJoint;
            _universe.joints.add(_loc_9, STRENGTH_OF_JOINT);
            var _loc_11:* = EffectExplosion.get();
            _loc_11.variety = EffectExplosion.JOINT_EXPLOSION;
            _loc_11.init(param1, param2);
            ZG.sound(SoundManager.OBJECT_EXPLOSION, this, true);
            this.free();
            _isDead = true;
            var _loc_12:* = ZG.saveBox;
            var _loc_13:* = ZG.saveBox.destroyedObjects + 1;
            _loc_12.destroyedObjects = _loc_13;
            return _loc_7.body;
        }// end function

        override public function explode(param1:BasicObject, param2:b2Vec2, param3:b2Vec2) : Boolean
        {
            var _loc_4:Number = NaN;
            var _loc_5:b2Body = null;
            if (!_isDead)
            {
                _loc_4 = Amath.distance(_body.GetPosition().x, _body.GetPosition().y, param1.body.GetPosition().x, param1.body.GetPosition().y);
                _health = _health - param1.damage / _loc_4;
                if (_health <= 0)
                {
                    _health = 0;
                    _loc_5 = this.makeDeadBody(this.x, this.y, this.rotation);
                    if (_loc_5 != null)
                    {
                        _loc_5.ApplyImpulse(param3, param2);
                    }
                    return true;
                }
            }
            return false;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                _universe.physics.DestroyBody(_body);
                super.free();
            }
            return;
        }// end function

        public static function get() : WoodPlank
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as WoodPlank;
        }// end function

    }
}
