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

    public class Bomb extends BasicObject
    {
        private var _delay:int;
        private var _effBurn:EffectBurnTiny;
        public static const CACHE_NAME:String = "Bombs";
        private static const EXPLOSION_DAMAGE:Number = 2;
        private static const EXPLOSION_POWER:int = 2;

        public function Bomb()
        {
            _kind = Kind.BOMB;
            _sprite = ZG.animCache.getAnimation(Art.BOMB);
            _sprite.speed = 0.25;
            return;
        }// end function

        override public function die() : void
        {
            if (!_die)
            {
                this.explosion();
                _die = true;
            }
            return;
        }// end function

        override public function jointDead(param1:b2RevoluteJoint = null) : void
        {
            var _loc_2:b2Vec2 = null;
            _loc_2 = _body.GetLinearVelocity();
            _loc_2.x = _loc_2.x * 0.04;
            _body.ApplyImpulse(new b2Vec2(_loc_2.x * -1, -0.5), _body.GetWorldCenter());
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _sprite.smoothing = _universe.smoothing;
            _sprite.scaleX = param4;
            _sprite.play();
            addChild(_sprite);
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2CircleDef();
            _loc_6.radius = 0.25;
            _loc_6.density = 0.5;
            _loc_6.friction = 10;
            _loc_6.restitution = 0;
            _loc_6.filter.groupIndex = -2;
            _loc_5 = new b2BodyDef();
            _loc_5.userData = this;
            _loc_5.allowSleep = false;
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            this._effBurn = EffectBurnTiny.get();
            this._effBurn.setBody(_body, new Avector(0, -13));
            this._effBurn.init(0, 0);
            this._delay = 105;
            ZG.sound(SoundManager.BOMB_ALARM, this);
            reset();
            return;
        }// end function

        override public function process() : void
        {
            super.process();
            var _loc_1:String = this;
            var _loc_2:* = this._delay - 1;
            _loc_1._delay = _loc_2;
            if (this._delay <= 0)
            {
                this.explosion();
            }
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _sprite.stop();
                this._effBurn.die();
                _universe.physics.DestroyBody(_body);
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                super.free();
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
            if (_body == null)
            {
                return;
            }
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
            eff.init(_position.x, _position.y);
            ZG.media.stop(SoundManager.BOMB_ALARM);
            ZG.sound(SoundManager.BOMB_EXPLOSION, this);
            _universe.quake(2);
            _universe.motiExplosion();
            this.free();
            return;
        }// end function

        override public function get damage() : Number
        {
            return EXPLOSION_DAMAGE;
        }// end function

        override public function bulletCollision(param1:Bullet, param2:b2Vec2) : void
        {
            if (!_isDead)
            {
                _universe.deads.add(this);
                _isDead = true;
            }
            return;
        }// end function

        public static function get() : Bomb
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as Bomb;
        }// end function

    }
}
