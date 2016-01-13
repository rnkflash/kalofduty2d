package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.interfaces.*;

    public class BulletGrenade extends BasicObject implements IBullet
    {
        public var allowStatistic:Boolean = true;
        private var _speed:Avector;
        private var _effInterval:int = 0;
        private var _ang:Number = 0;
        private var _soundOnce:Boolean = false;
        public var impulse:Number;
        public static const CACHE_NAME:String = "Grenades";
        private static const EXPLOSION_POWER:int = 2;

        public function BulletGrenade()
        {
            this._speed = new Avector();
            _kind = Kind.BULLET;
            _sprite = ZG.animCache.getAnimation(Art.BULLET);
            return;
        }// end function

        override public function die() : void
        {
            if (!_die)
            {
                _die = true;
                this.explosion();
                this.free();
            }
            return;
        }// end function

        private function explosion() : void
        {
            var res:Array;
            var body:b2Body;
            var self:b2Shape;
            var p1:b2Vec2;
            var p2:b2Vec2;
            var i:int;
            var aabb:* = new b2AABB();
            aabb.lowerBound.Set(_body.GetWorldCenter().x - 4, _body.GetWorldCenter().y - 4);
            aabb.upperBound.Set(_body.GetWorldCenter().x + 4, _body.GetWorldCenter().y + 4);
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
            eff.variety = EffectExplosion.BOMB_EXPLOSION;
            eff.init(x, y);
            ZG.sound(SoundManager.BOMB_EXPLOSION, this);
            _universe.quake(2);
            return;
        }// end function

        override public function render() : void
        {
            var _loc_1:EffectSmokeGrenade = null;
            x = _body.GetPosition().x * Universe.DRAW_SCALE;
            y = _body.GetPosition().y * Universe.DRAW_SCALE;
            this._speed.set(_body.GetLinearVelocity().x * Universe.DRAW_SCALE, _body.GetLinearVelocity().y * Universe.DRAW_SCALE);
            rotation = this._speed.angleDeg();
            var _loc_2:String = this;
            var _loc_3:* = this._effInterval + 1;
            _loc_2._effInterval = _loc_3;
            if (this._effInterval >= 2)
            {
                _loc_1 = EffectSmokeGrenade.get();
                _loc_1.init(this.x, this.y);
                this._effInterval = 0;
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_6.density = 1;
            _loc_6.friction = 0.2;
            _loc_6.restitution = 0.1;
            _loc_6.filter.categoryBits = 4;
            _loc_6.filter.groupIndex = -101;
            _loc_5.userData = this;
            _loc_5.isBullet = true;
            _loc_5.angle = param3 * (Math.PI / 180);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_6.SetAsOrientedBox(5 / Universe.DRAW_SCALE, 2 / Universe.DRAW_SCALE, new b2Vec2(), 0);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            var _loc_7:* = new Avector();
            _loc_7.asSpeed(this.impulse * param4, Amath.toRadians(param3));
            _body.ApplyImpulse(new b2Vec2(_loc_7.x, _loc_7.y), _body.GetWorldCenter());
            this._ang = param3;
            _sprite.smoothing = _universe.smoothing;
            _sprite.gotoAndStop(_variety);
            addChild(_sprite);
            this.allowStatistic = true;
            reset();
            show();
            this.render();
            return;
        }// end function

        public function set damage(param1:Number) : void
        {
            _damage = param1;
            return;
        }// end function

        override public function explode(param1:BasicObject, param2:b2Vec2, param3:b2Vec2) : Boolean
        {
            return true;
        }// end function

        override public function get damage() : Number
        {
            return _damage;
        }// end function

        public function collision(param1:b2Vec2, param2:BasicObject = null) : void
        {
            if (!_isDead)
            {
                _isDead = true;
                _universe.triggers.bulletCollision(param1.x, param1.y);
                _universe.deads.add(this);
            }
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

        public static function get() : BulletGrenade
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as BulletGrenade;
        }// end function

    }
}
