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
    import com.zombotron.levels.*;

    public class Box extends BasicObject
    {
        private var _hitPoint:b2Vec2;
        private var _hitForce:b2Vec2;
        private static const STRENGTH_OF_JOINT:int = 25;
        public static const CACHE_NAME:String = "Boxes";
        private static const BOX_HEALTH:Number = 1;

        public function Box()
        {
            group = Kind.GROUP_BREAKABLE;
            _kind = Kind.BOX;
            _sprite = ZG.animCache.getAnimation(Art.BOX);
            _allowContacts = true;
            return;
        }// end function

        override public function die() : void
        {
            var _loc_1:b2Body = null;
            if (!_isDead)
            {
                _loc_1 = this.makeDeadBody(this.x, this.y);
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

        override public function explode(param1:BasicObject, param2:b2Vec2, param3:b2Vec2) : Boolean
        {
            var _loc_4:Number = NaN;
            var _loc_5:b2Body = null;
            if (!_isDead)
            {
                _loc_4 = Amath.distance(_body.GetPosition().x, _body.GetPosition().y, param1.body.GetPosition().x, param1.body.GetPosition().y);
                this.health = this.health - param1.damage / _loc_4;
                if (this.health <= 0)
                {
                    this.health = 0;
                    param3.x = param3.x * 3;
                    param3.y = param3.y * 3;
                    _loc_5 = this.makeDeadBody(this.x, this.y);
                    if (_loc_5 != null)
                    {
                        _loc_5.ApplyImpulse(param3, param2);
                    }
                    return true;
                }
            }
            return false;
        }// end function

        private function get health() : Number
        {
            return _health;
        }// end function

        override public function addContact(param1:b2ContactPoint) : Boolean
        {
            if (super.addContact(param1))
            {
                if (_body.GetLinearVelocity().Length() > 5)
                {
                    ZG.sound(SoundManager.BOX_COLLISION, this, true);
                }
                return true;
            }
            return false;
        }// end function

        override public function attacked(param1:b2Vec2, param2:b2Vec2, param3:Number = 1) : Boolean
        {
            var _loc_5:b2Body = null;
            this.health = this.health - param3 * 2.5;
            if (this.health <= 0)
            {
                this.health = 0;
                _loc_5 = this.makeDeadBody(this.x, this.y);
                param2.x = param2.x * 2;
                param2.y = param2.y * 2;
                if (_loc_5 != null)
                {
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

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _health = BOX_HEALTH;
            reset();
            _sprite.smoothing = _universe.smoothing;
            _sprite.gotoAndStop(1);
            addChild(_sprite);
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_6.density = 0.5;
            _loc_6.friction = 0.2;
            _loc_6.restitution = 0.1;
            _loc_6.filter.categoryBits = 4;
            _loc_5.userData = this;
            _loc_5.angle = param3 * (Math.PI / 180);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_6.SetAsOrientedBox(18 / Universe.DRAW_SCALE, 18 / Universe.DRAW_SCALE, new b2Vec2(), 0);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            return;
        }// end function

        private function set health(param1:Number) : void
        {
            _health = param1;
            if (_health <= 0.3)
            {
                _sprite.gotoAndStop(3);
            }
            else if (_health <= 0.7)
            {
                _sprite.gotoAndStop(2);
            }
            return;
        }// end function

        private function makeDeadBody(param1:Number, param2:Number) : b2Body
        {
            var _loc_3:Array = null;
            var _loc_4:BoxPart = null;
            var _loc_5:int = 0;
            var _loc_6:b2RevoluteJointDef = null;
            var _loc_7:b2RevoluteJoint = null;
            var _loc_8:b2Vec2 = null;
            var _loc_9:EffectExplosion = null;
            var _loc_10:EffectCollectableItem = null;
            if (!_isDead)
            {
                _loc_3 = [];
                _loc_5 = 8;
                while (_loc_5 > 3)
                {
                    
                    _loc_4 = BoxPart.get();
                    _loc_4.variety = _loc_5;
                    _loc_4.init(param1, param2);
                    _loc_3[_loc_3.length] = _loc_4.body;
                    _loc_5 = _loc_5 - 1;
                }
                _loc_6 = new b2RevoluteJointDef();
                _loc_8 = (_loc_3[0] as b2Body).GetWorldCenter();
                _loc_8.x = _loc_8.x - 12 / Universe.DRAW_SCALE;
                _loc_8.y = _loc_8.y + 12 / Universe.DRAW_SCALE;
                _loc_6.enableLimit = true;
                _loc_6.Initialize(_loc_3[0], _loc_3[2], _loc_8);
                _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
                _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
                _loc_8 = (_loc_3[1] as b2Body).GetWorldCenter();
                _loc_8.y = _loc_8.y + 12 / Universe.DRAW_SCALE;
                _loc_6.Initialize(_loc_3[1], _loc_3[2], _loc_8);
                _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
                _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
                _loc_8 = (_loc_3[2] as b2Body).GetWorldCenter();
                _loc_8.x = _loc_8.x + 12 / Universe.DRAW_SCALE;
                _loc_6.Initialize(_loc_3[2], _loc_3[3], _loc_8);
                _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
                _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
                _loc_8 = (_loc_3[3] as b2Body).GetWorldCenter();
                _loc_8.y = _loc_8.y - 12 / Universe.DRAW_SCALE;
                _loc_6.Initialize(_loc_3[3], _loc_3[4], _loc_8);
                _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
                _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
                _loc_8 = (_loc_3[4] as b2Body).GetWorldCenter();
                _loc_8.x = _loc_8.x - 12 / Universe.DRAW_SCALE;
                _loc_6.Initialize(_loc_3[4], _loc_3[1], _loc_8);
                _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
                _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
                _loc_9 = EffectExplosion.get();
                _loc_9.variety = EffectExplosion.OBJECT_EXPLOSION;
                _loc_9.init(param1, param2);
                ZG.sound(SoundManager.OBJECT_EXPLOSION, this, true);
                if (ZG.playerGui.isHaveMission(LevelBase.MISSION_BOX))
                {
                    _loc_10 = EffectCollectableItem.get();
                    _loc_10.variety = ShopBox.ITEM_SPIRIT_BOX;
                    _loc_10.init(this.x, this.y, this.rotation);
                    _loc_10.angle = -45;
                }
                var _loc_11:* = ZG.saveBox;
                var _loc_12:* = ZG.saveBox.destroyedObjects + 1;
                _loc_11.destroyedObjects = _loc_12;
                this.free();
                _isDead = true;
                return _loc_4.body;
            }
            return null;
        }// end function

        override public function bulletCollision(param1:Bullet, param2:b2Vec2) : void
        {
            if (!_die)
            {
                this.health = this.health - param1.damage;
                if (this.health <= 0)
                {
                    this.health = 0;
                    this._hitPoint = new b2Vec2(param2.x, param2.y);
                    this._hitForce = new b2Vec2(param1.body.GetLinearVelocity().x, param1.body.GetLinearVelocity().y);
                    _universe.deads.add(this);
                    _die = true;
                }
            }
            return;
        }// end function

        override public function fatalDamage(param1:b2Vec2, param2:b2Vec2) : void
        {
            this._hitPoint = new b2Vec2(param1.x, param1.y);
            this._hitForce = new b2Vec2(param2.x / 2.5, param2.y / 2.5);
            _universe.deads.add(this);
            _die = true;
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

        public static function get() : Box
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as Box;
        }// end function

    }
}
