package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;

    public class Bullet extends BasicObject
    {
        public var allowStatistic:Boolean = true;
        private var _ang:Number = 0;
        private var _soundOnce:Boolean = false;
        public var impulse:Number;
        public static const SHOTGUN:uint = 2;
        public static const GUN:uint = 3;
        public static const CACHE_NAME:String = "Bullets";
        public static const GRENADEGUN:uint = 4;
        public static const PISTOL:uint = 1;
        public static const MACHINEGUN:uint = 5;

        public function Bullet()
        {
            _kind = Kind.BULLET;
            _sprite = ZG.animCache.getAnimation(Art.BULLET);
            _variety = PISTOL;
            return;
        }// end function

        override public function die() : void
        {
            this.free();
            return;
        }// end function

        private function makeHitEffect(param1:Number, param2:Number, param3:BasicObject) : void
        {
            var _loc_5:EffectHitTo = null;
            var _loc_6:EffectSpark = null;
            var _loc_7:int = 0;
            var _loc_4:Boolean = true;
            if (param3 != null)
            {
                if (param3.group == Kind.GROUP_BREAKABLE || param3.group == Kind.GROUP_ROBOT || param3.group == Kind.GROUP_SKELETON || param3.group == Kind.GROUP_ZOMBIE)
                {
                    var _loc_8:* = ZG.saveBox;
                    var _loc_9:* = ZG.saveBox.accuracyShots + 1;
                    _loc_8.accuracyShots = _loc_9;
                }
                switch(param3.kind)
                {
                    case Kind.ENEMY_ZOMBIE:
                    case Kind.ENEMY_ZOMBIE_BOMB:
                    case Kind.ENEMY_ZOMBIE_ARMOR:
                    case Kind.ENEMY_WHEEL:
                    case Kind.ENEMY_BOSS:
                    case Kind.BOSS_PART:
                    case Kind.HERO_PART:
                    {
                        _loc_5 = EffectHitTo.get();
                        _loc_5.variety = EffectHitTo.MEAT;
                        _loc_5.init(param1, param2, this._ang, _sprite.scaleX);
                        ZG.sound(SoundManager.HIT_TO_ZOMBIE, this, this._soundOnce);
                        break;
                    }
                    case Kind.ZOMBIE_PART:
                    case Kind.ZOMBIE_BOMB_PART:
                    case Kind.HERO:
                    {
                        if (!param3.hitEffect(param1, param2, this._ang, _sprite.scaleX))
                        {
                            _loc_5 = EffectHitTo.get();
                            _loc_5.variety = EffectHitTo.MEAT;
                            _loc_5.init(param1, param2, this._ang, _sprite.scaleX);
                            ZG.sound(SoundManager.HIT_TO_DEADBODY, this, this._soundOnce);
                        }
                        break;
                    }
                    case Kind.ROPE:
                    case Kind.BAG:
                    {
                        _loc_5 = EffectHitTo.get();
                        _loc_5.variety = EffectHitTo.WOOD;
                        _loc_5.init(param1, param2, this._ang, _sprite.scaleX);
                        ZG.sound(SoundManager.HIT_TO_GROUND, this, this._soundOnce);
                        break;
                    }
                    case Kind.BARREL:
                    case Kind.BARREL_PART:
                    case Kind.DOOR:
                    case Kind.VERTICAL_ELEVATOR:
                    case Kind.CART:
                    case Kind.CART_PART:
                    case Kind.ENEMY_TURRET:
                    case Kind.HORIZONTAL_ELEVATOR:
                    case Kind.BRIDGE:
                    case Kind.SHOP_PART:
                    case Kind.DOOR_PART:
                    case Kind.CHEST:
                    case Kind.TRUCK:
                    case Kind.TRAILER:
                    case Kind.CART_WHEEL:
                    {
                        _loc_5 = EffectHitTo.get();
                        _loc_5.variety = EffectHitTo.METAL;
                        _loc_5.init(param1, param2, this._ang, _sprite.scaleX);
                        ZG.sound(SoundManager.HIT_TO_BARREL, this, this._soundOnce);
                        break;
                    }
                    case Kind.ENEMY_ROBOT_SPADE:
                    case Kind.ENEMY_ROBOT_PICK:
                    case Kind.ROBOT_WHEEL:
                    case Kind.HELMET:
                    {
                        _loc_5 = EffectHitTo.get();
                        _loc_5.variety = EffectHitTo.METAL;
                        _loc_5.init(param1, param2, this._ang, _sprite.scaleX);
                        _loc_6 = EffectSpark.get();
                        _loc_7 = _sprite.scaleX < 0 ? (Amath.random(2, 5)) : (Amath.random(-2, -5));
                        _loc_6.speed.set(_loc_7, Amath.random(-1, -4));
                        _loc_6.variety = Amath.random(1, 2);
                        _loc_6.init(param1, param2);
                        ZG.sound(SoundManager.HIT_TO_ROBOT, this, this._soundOnce);
                        break;
                    }
                    case Kind.ROBOT_PART:
                    {
                        _loc_5 = EffectHitTo.get();
                        _loc_5.variety = EffectHitTo.METAL;
                        _loc_5.init(param1, param2, this._ang, _sprite.scaleX);
                        ZG.sound(SoundManager.HIT_TO_ROBOT, this, this._soundOnce);
                        break;
                    }
                    case Kind.BOX:
                    case Kind.BOX_SMALL:
                    case Kind.WOOD_PLANK:
                    case Kind.SHEILD:
                    case Kind.ENEMY_SKELETON:
                    case Kind.SKELETON_PART:
                    case Kind.SKELETON_WHEEL:
                    {
                        _loc_5 = EffectHitTo.get();
                        _loc_5.variety = EffectHitTo.WOOD;
                        _loc_5.init(param1, param2, this._ang, _sprite.scaleX);
                        if (param3.kind == Kind.ENEMY_SKELETON || param3.kind == Kind.SKELETON_PART)
                        {
                            ZG.sound(SoundManager.HIT_TO_SKELETON, this, this._soundOnce);
                        }
                        else
                        {
                            ZG.sound(SoundManager.HIT_TO_BOX, this, this._soundOnce);
                        }
                        break;
                    }
                    case Kind.BOX_PLANK:
                    {
                        _loc_5 = EffectHitTo.get();
                        _loc_5.variety = EffectHitTo.WOOD;
                        _loc_5.init(param1, param2, this._ang, _sprite.scaleX * -1);
                        ZG.sound(SoundManager.HIT_TO_BOX, this, this._soundOnce);
                        break;
                    }
                    case Kind.TRIGGER_PART:
                    {
                        break;
                    }
                    default:
                    {
                        _loc_4 = false;
                        break;
                        break;
                    }
                }
            }
            else
            {
                _loc_4 = false;
            }
            if (!_loc_4)
            {
                _loc_5 = EffectHitTo.get();
                _loc_5.variety = EffectHitTo.GROUND;
                _loc_5.init(param1, param2, this._ang, _sprite.scaleX);
                ZG.sound(SoundManager.HIT_TO_GROUND, this, this._soundOnce);
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_6.density = 0.5;
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
            _sprite.scaleX = param4;
            _sprite.gotoAndStop(_variety);
            addChild(_sprite);
            this.allowStatistic = true;
            reset();
            show();
            render();
            return;
        }// end function

        public function set damage(param1:Number) : void
        {
            _damage = param1;
            return;
        }// end function

        override public function set variety(param1:uint) : void
        {
            _variety = param1;
            this._soundOnce = _variety == SHOTGUN ? (true) : (false);
            return;
        }// end function

        override public function explode(param1:BasicObject, param2:b2Vec2, param3:b2Vec2) : Boolean
        {
            return true;
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

        public function collision(param1:b2Vec2, param2:BasicObject = null) : void
        {
            if (!_isDead)
            {
                _isDead = true;
                this.makeHitEffect(param1.x * Universe.DRAW_SCALE, param1.y * Universe.DRAW_SCALE, param2);
                _universe.triggers.bulletCollision(param1.x, param1.y);
                _universe.deads.add(this);
            }
            return;
        }// end function

        override public function process() : void
        {
            var _loc_1:b2Vec2 = null;
            var _loc_2:b2Vec2 = null;
            _loc_1 = _universe.physics.m_gravity;
            _loc_2 = _body.GetLinearVelocity();
            _loc_2.x = _loc_2.x - _loc_1.x * Universe.TIME_STEP;
            _loc_2.y = _loc_2.y - _loc_1.y * Universe.TIME_STEP;
            _body.SetLinearVelocity(_loc_2);
            return;
        }// end function

        override public function get damage() : Number
        {
            return _damage;
        }// end function

        public static function get() : Bullet
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as Bullet;
        }// end function

    }
}
