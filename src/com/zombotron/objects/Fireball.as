package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.interfaces.*;

    public class Fireball extends BasicObject implements IBullet
    {
        private var _effInterval:int = 0;
        public static const EXPLOSION_DAMAGE:Number = 1.5;
        public static const EXPLOSION_POWER:Number = 2;

        public function Fireball()
        {
            _kind = Kind.FIREBALL;
            _sprite = ZG.animCache.getAnimation(Art.BOSS_FIREBALL);
            _damage = EXPLOSION_DAMAGE;
            _layer = Universe.LAYER_FG_EFFECTS;
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

        override public function explode(param1:BasicObject, param2:b2Vec2, param3:b2Vec2) : Boolean
        {
            return true;
        }// end function

        override public function render() : void
        {
            var _loc_1:EffectFireballSmoke = null;
            x = _body.GetPosition().x * Universe.DRAW_SCALE;
            y = _body.GetPosition().y * Universe.DRAW_SCALE;
            var _loc_2:String = this;
            var _loc_3:* = this._effInterval + 1;
            _loc_2._effInterval = _loc_3;
            if (this._effInterval >= 3)
            {
                _loc_1 = EffectFireballSmoke.get();
                _loc_1.init(this.x, this.y, 0, _sprite.scaleX);
                this._effInterval = 0;
            }
            return;
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

        public function set damage(param1:Number) : void
        {
            _damage = param1;
            return;
        }// end function

        override public function get damage() : Number
        {
            return _damage;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _sprite.smoothing = _universe.smoothing;
            _sprite.scaleX = param4;
            _sprite.play();
            addChild(_sprite);
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2CircleDef();
            _loc_6.radius = 0.3;
            _loc_6.density = 0.5;
            _loc_6.friction = 10;
            _loc_6.restitution = 0;
            _loc_6.filter.categoryBits = 2;
            _loc_6.filter.maskBits = 4;
            _loc_6.filter.groupIndex = 2;
            _loc_5 = new b2BodyDef();
            _loc_5.userData = this;
            _loc_5.allowSleep = false;
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            reset();
            show();
            return;
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
            ZG.sound(SoundManager.BOSS_FIREBALL, this);
            _universe.quake(2);
            return;
        }// end function

    }
}
