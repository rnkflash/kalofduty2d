package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.helpers.*;
    import com.zombotron.levels.*;

    public class Barrel extends BasicObject
    {
        private var _isExplosion:Boolean;
        private var _burnInterval:int;
        private var _hitPoint:b2Vec2;
        private var _isBullet:Boolean;
        private var _hitForce:b2Vec2;
        private var _isBurn:Boolean;
        public static const CACHE_NAME:String = "Barrels";
        private static const EXPLOSION_DAMAGE:Number = 3;
        private static const EXPLOSION_POWER:int = 3;

        public function Barrel()
        {
            group = Kind.GROUP_BREAKABLE;
            _kind = Kind.BARREL;
            _sprite = $.animCache.getAnimation(Art.BARREL);
            _allowContacts = true;
            return;
        }// end function

        override public function die() : void
        {
            if (!_isDead)
            {
                this.makeDeadBody(_position.x, _position.y);
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
                    ZG.sound(SoundManager.BARREL_COLLISION, this, true);
                }
                return true;
            }
            return false;
        }// end function

        override public function set kind(param1:uint) : void
        {
            if (_kind != param1)
            {
                _kind = param1;
                switch(_kind)
                {
                    case Kind.BARREL:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.BARREL);
                        break;
                    }
                    case Kind.BARREL_EXPLOSION:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.BARREL_EXPLOSION);
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

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
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
            _loc_6.SetAsOrientedBox(11 / Universe.DRAW_SCALE, 15 / Universe.DRAW_SCALE, new b2Vec2(), 0);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            _health = 1;
            this._burnInterval = 100;
            this._isBurn = false;
            _isFree = false;
            _isDead = false;
            _die = false;
            this._isBullet = false;
            this._isExplosion = false;
            _isVisible = true;
            _universe.add(this, _layer);
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

        private function explosion() : void
        {
            var res:Array;
            var body:b2Body;
            var p1:b2Vec2;
            var p2:b2Vec2;
            var i:int;
            var aabb:* = new b2AABB();
            aabb.lowerBound.Set(_body.GetWorldCenter().x - 5, _body.GetWorldCenter().y - 5);
            aabb.upperBound.Set(_body.GetWorldCenter().x + 5, _body.GetWorldCenter().y + 5);
            res;
            _universe.physics.Query(aabb, res, 30);
            var n:* = res.length;
            p1 = new b2Vec2();
            p2 = new b2Vec2();
            var distance:Number;
            var power:* = new b2Vec2();
            n = res.length;
            i;
            while (i < n)
            {
                
                body = res[i].GetBody();
                if (body == null)
                {
                }
                else
                {
                    try
                    {
                        distance = b2Distance.Distance(p1, p2, _body.GetShapeList(), _body.GetXForm(), res[i], body.GetXForm());
                    }
                    catch (e:Error)
                    {
                        distance;
                        trace(p1, p2, _body, res[i], body);
                    }
                    distance = distance <= 1 && distance >= 0 ? (1) : (distance);
                    if (body.m_userData is BasicObject)
                    {
                        power.x = p1.x < p2.x ? (EXPLOSION_POWER / distance) : ((-EXPLOSION_POWER) / distance);
                        power.y = p1.y < p2.y ? (EXPLOSION_POWER / distance) : ((-EXPLOSION_POWER) / distance);
                        if (!(body.m_userData as BasicObject).explode(this, p2, power))
                        {
                            body.ApplyImpulse(power, p2);
                        }
                    }
                }
                i = (i + 1);
            }
            var eff:* = EffectExplosion.get();
            eff.variety = EffectExplosion.EXPLOSION;
            eff.init(_position.x, _position.y);
            ZG.sound(SoundManager.BARREL_EXPLOSION, this);
            _universe.quake(4);
            _universe.motiExplosion();
            this._isExplosion = true;
            this.makeExpDeadBody(_position.x, _position.y, _body.GetAngle());
            return;
        }// end function

        override public function explode(param1:BasicObject, param2:b2Vec2, param3:b2Vec2) : Boolean
        {
            var _loc_4:Number = NaN;
            var _loc_5:EffectBurnSmall = null;
            switch(_kind)
            {
                case Kind.BARREL_EXPLOSION:
                {
                    if (!this._isExplosion && !this._isBurn)
                    {
                        _loc_5 = EffectBurnSmall.get();
                        this._burnInterval = Amath.random(50, 100);
                        _loc_5.timeLife(this._burnInterval);
                        _loc_5.setBody(_body, new b2Vec2());
                        _loc_5.init(param2.x * Universe.DRAW_SCALE, param2.y * Universe.DRAW_SCALE);
                        this._isBurn = true;
                    }
                    break;
                }
                case Kind.BARREL:
                {
                    _loc_4 = Amath.distance(_body.GetPosition().x, _body.GetPosition().y, param1.body.GetPosition().x, param1.body.GetPosition().y);
                    this.health = this.health - param1.damage / _loc_4;
                    if (this.health <= 0)
                    {
                        this._hitPoint = new b2Vec2(param2.x, param2.y);
                        this._hitForce = new b2Vec2(param3.x / 2.5, param3.y / 2.5);
                        this.makeDeadBody(_position.x, _position.y);
                        return true;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return false;
        }// end function

        private function get health() : Number
        {
            return _health;
        }// end function

        private function makeExpDeadBody(param1:Number, param2:Number, param3:Number) : void
        {
            var _loc_4:* = Amath.rotatePointDeg(param1, param2 + 10, param1, param2, Amath.toDegrees(_body.GetAngle()));
            var _loc_5:* = BarrelPart.get();
            _loc_5.variety = BarrelPart.EXPLOSION_BOTTOM;
            _loc_5.init(_loc_4.x / Universe.DRAW_SCALE, _loc_4.y / Universe.DRAW_SCALE, _body.GetAngle());
            this.free();
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

        override public function attacked(param1:b2Vec2, param2:b2Vec2, param3:Number = 1) : Boolean
        {
            var _loc_4:EffectBlow = null;
            switch(_kind)
            {
                case Kind.BARREL_EXPLOSION:
                {
                    _loc_4 = EffectBlow.get();
                    _loc_4.init(_body.GetPosition().x * Universe.DRAW_SCALE, _body.GetPosition().y * Universe.DRAW_SCALE);
                    _body.ApplyImpulse(param2, param1);
                    if (!this._isExplosion && !this._isBurn)
                    {
                        this.explode(this, param1, param2);
                        this._burnInterval = 100;
                    }
                    break;
                }
                case Kind.BARREL:
                {
                    if (!_isDead)
                    {
                        this.health = this.health - param3 * 2.5;
                        if (this.health <= 0)
                        {
                            this._hitPoint = new b2Vec2(param1.x, param1.y);
                            this._hitForce = new b2Vec2(param2.x / 2.5, param2.y / 2.5);
                            this.makeDeadBody(_position.x, _position.y);
                        }
                        else
                        {
                            _body.ApplyImpulse(param2, param1);
                        }
                        _loc_4 = EffectBlow.get();
                        _loc_4.init(param1.x * Universe.DRAW_SCALE, param1.y * Universe.DRAW_SCALE);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            ZG.sound(SoundManager.BARREL_COLLISION, this, true);
            return false;
        }// end function

        override public function process() : void
        {
            super.process();
            if (this._isBullet && !this._isExplosion)
            {
                this.explosion();
            }
            else if (!this._isExplosion && this._isBurn)
            {
                var _loc_1:String = this;
                var _loc_2:* = this._burnInterval - 1;
                _loc_1._burnInterval = _loc_2;
                if (this._burnInterval <= 0)
                {
                    this._burnInterval = 0;
                    this._isBurn = false;
                    this.explosion();
                }
            }
            return;
        }// end function

        override public function bulletCollision(param1:Bullet, param2:b2Vec2) : void
        {
            switch(_kind)
            {
                case Kind.BARREL_EXPLOSION:
                {
                    if (!this._isExplosion)
                    {
                        this._isBullet = true;
                    }
                    break;
                }
                case Kind.BARREL:
                {
                    if (!_die && param1 != null)
                    {
                        this.health = this.health - param1.damage;
                        if (this.health <= 0)
                        {
                            this._hitPoint = new b2Vec2(param2.x, param2.y);
                            this._hitForce = new b2Vec2(param1.body.GetLinearVelocity().x / 40, param1.body.GetLinearVelocity().y / 40);
                            _universe.deads.add(this);
                            _die = true;
                        }
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function makeDeadBody(param1:Number, param2:Number) : void
        {
            var _loc_6:EffectSpark = null;
            var _loc_9:EffectCollectableItem = null;
            var _loc_3:* = Amath.rotatePointDeg(param1, param2 - 10, param1, param2, Amath.toDegrees(_body.GetAngle()));
            var _loc_4:* = BarrelPart.get();
            _loc_4.variety = BarrelPart.BASIC_TOP;
            _loc_4.init(_loc_3.x / Universe.DRAW_SCALE, _loc_3.y / Universe.DRAW_SCALE, _body.GetAngle());
            _loc_3 = Amath.rotatePointDeg(param1, param2 + 10, param1, param2, Amath.toDegrees(_body.GetAngle()));
            var _loc_5:* = BarrelPart.get();
            _loc_5.variety = BarrelPart.BASIC_BOTTOM;
            _loc_5.init(_loc_3.x / Universe.DRAW_SCALE, _loc_3.y / Universe.DRAW_SCALE, _body.GetAngle());
            _loc_3.asSpeed(0.5, _body.GetAngle() - Math.PI / 2);
            _loc_4.body.ApplyImpulse(new b2Vec2(this._hitForce.x + _loc_3.x, this._hitForce.y + _loc_3.y), this._hitPoint);
            _loc_3.asSpeed(0.5, _body.GetAngle() + Math.PI / 2);
            _loc_5.body.ApplyImpulse(new b2Vec2(this._hitForce.x + _loc_3.x, this._hitForce.y + _loc_3.y), this._hitPoint);
            var _loc_7:int = 0;
            while (_loc_7 < 4)
            {
                
                _loc_6 = EffectSpark.get();
                _loc_6.variety = Amath.random(1, 2);
                _loc_6.speed = new Avector(Amath.random(-5, 5), Amath.random(-1, -5));
                _loc_6.init(param1, param2);
                _loc_7++;
            }
            var _loc_8:* = EffectExplosion.get();
            _loc_8.variety = EffectExplosion.OBJECT_EXPLOSION;
            _loc_8.init(param1, param2);
            ZG.sound(SoundManager.OBJECT_EXPLOSION, this, true);
            if (ZG.playerGui.isHaveMission(LevelBase.MISSION_BARREL))
            {
                _loc_9 = EffectCollectableItem.get();
                _loc_9.variety = ShopBox.ITEM_SPIRIT_BARREL;
                _loc_9.init(_position.x, _position.y, this.rotation);
                _loc_9.angle = -45;
            }
            var _loc_10:* = ZG.saveBox;
            var _loc_11:* = ZG.saveBox.destroyedObjects + 1;
            _loc_10.destroyedObjects = _loc_11;
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

        override public function get damage() : Number
        {
            return EXPLOSION_DAMAGE;
        }// end function

        public static function get() : Barrel
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as Barrel;
        }// end function

    }
}
