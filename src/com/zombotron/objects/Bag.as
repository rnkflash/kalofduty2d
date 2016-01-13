package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.helpers.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;

    public class Bag extends BasicObject implements IItemObject
    {
        private var _isCollected:Boolean = false;
        private var _collectable:Boolean = false;
        public static const CACHE_NAME:String = "Bags";
        public static const HEALTH:Number = 0.5;

        public function Bag()
        {
            group = Kind.GROUP_BREAKABLE;
            _kind = Kind.BAG;
            _sprite = ZG.animCache.getAnimation(Art.BAG);
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
                    this.makeDeadBody(this.x, this.y);
                    return true;
                }
            }
            return false;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _sprite.smoothing = _universe.smoothing;
            addChild(_sprite);
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_5.userData = this;
            _loc_6.vertexCount = 3;
            _loc_6.vertices[0].Set(0, -0.4);
            _loc_6.vertices[1].Set(0.4, 0.4);
            _loc_6.vertices[2].Set(-0.4, 0.4);
            _loc_6.density = 0.7;
            _loc_6.friction = 0.8;
            _loc_6.restitution = 0.2;
            _loc_5.angle = param3 * (Math.PI / 180);
            _loc_6.filter.groupIndex = -2;
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _loc_6 = new b2PolygonDef();
            _loc_6.vertexCount = 3;
            _loc_6.vertices[0].Set(0, 0);
            _loc_6.vertices[1].Set(-0.2, -0.4);
            _loc_6.vertices[2].Set(0.2, -0.4);
            _loc_6.density = 2;
            _loc_6.friction = 0.8;
            _loc_6.restitution = 0.2;
            _loc_6.filter.groupIndex = -2;
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            reset();
            this._isCollected = false;
            _health = HEALTH;
            if (ZG.playerGui.isHaveMission(LevelBase.MISSION_BAG))
            {
                this._collectable = true;
                _universe.items.add(this);
            }
            else
            {
                this._collectable = false;
            }
            return;
        }// end function

        override public function attacked(param1:b2Vec2, param2:b2Vec2, param3:Number = 1) : Boolean
        {
            _health = _health - param3 * 2.5;
            if (_health <= 0)
            {
                _health = 0;
                this.makeDeadBody(this.x, this.y);
            }
            else
            {
                _body.ApplyImpulse(param2, param1);
            }
            var _loc_4:* = EffectBlow.get();
            _loc_4.init(param1.x * Universe.DRAW_SCALE, param1.y * Universe.DRAW_SCALE);
            ZG.sound(SoundManager.BAG_COLLISION, this, true);
            return false;
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

        override public function bulletCollision(param1:Bullet, param2:b2Vec2) : void
        {
            if (!_die)
            {
                _health = _health - param1.damage;
                if (_health <= 0)
                {
                    _health = 0;
                    _universe.deads.add(this);
                    _die = true;
                }
            }
            return;
        }// end function

        public function collect() : void
        {
            var _loc_1:EffectCollectableItem = null;
            if (!this._isCollected && ZG.playerGui.isHaveMission(LevelBase.MISSION_BAG))
            {
                _loc_1 = EffectCollectableItem.get();
                _loc_1.variety = ShopBox.ITEM_BAG;
                _loc_1.init(this.x, this.y, this.rotation);
                _loc_1.angle = -45;
                this._isCollected = true;
                this.free();
            }
            return;
        }// end function

        private function makeDeadBody(param1:int, param2:int) : void
        {
            var _loc_5:b2Vec2 = null;
            var _loc_6:Coin = null;
            var _loc_3:* = EffectExplosion.get();
            _loc_3.variety = EffectExplosion.JOINT_EXPLOSION;
            _loc_3.init(param1, param2, 0, Amath.random(-1, 1) < 0 ? (-1) : (1));
            var _loc_4:int = 0;
            while (_loc_4 < 3)
            {
                
                _loc_5 = new b2Vec2(Amath.random(-3, 3) / 20, (Amath.random(-3, -2) - Math.random()) / 10);
                _loc_6 = Coin.get();
                _loc_6.init(param1, param2);
                _loc_6.body.ApplyImpulse(_loc_5, _loc_6.body.GetWorldCenter());
                _loc_4++;
            }
            var _loc_7:* = ZG.saveBox;
            var _loc_8:* = ZG.saveBox.destroyedObjects + 1;
            _loc_7.destroyedObjects = _loc_8;
            this.free();
            return;
        }// end function

        override public function fatalDamage(param1:b2Vec2, param2:b2Vec2) : void
        {
            _universe.deads.add(this);
            _die = true;
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                if (this._collectable)
                {
                    _universe.items.remove(this);
                }
                _universe.physics.DestroyBody(_body);
                super.free();
            }
            return;
        }// end function

        public static function get() : Bag
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as Bag;
        }// end function

    }
}
