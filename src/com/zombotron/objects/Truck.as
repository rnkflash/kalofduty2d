package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.anim.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.helpers.*;
    import com.zombotron.interfaces.*;

    public class Truck extends BasicObject implements IActiveObject
    {
        private var _effInterval:int = 0;
        private var _jointB:b2RevoluteJoint;
        private var _tm:TaskManager;
        private var _hitPoint:b2Vec2;
        private var _motorTorque:Number = 1;
        private var _ragdoll:Ragdoll;
        private var _jointA:b2RevoluteJoint;
        private var _aButton:Animation;
        public var upperLimit:Number = 0;
        public var lowerLimit:Number = 0;
        private var _actionPoint:Avector;
        private var _aArrow:Animation;
        private var _dir:uint = 2;
        private var _speed:Number = 0;
        private var _alias:String = "";
        private var _action:uint = 1;
        private var _wheelA:CartWheel;
        private var _wheelB:CartWheel;
        private var _hitForce:b2Vec2;
        public var enableLimit:Boolean = false;
        private static const EXPLOSION_DAMAGE:Number = 2;
        private static const ACT_MOVE:uint = 2;
        public static const RAGDOLL_NAME:String = "Truck";
        private static const DIR_LEFT:uint = 1;
        private static const ACT_STOP:uint = 1;
        private static const DIR_RIGHT:uint = 2;
        private static const EXPLOSION_DELAY:int = 120;
        private static const EXPLOSION_POWER:int = 3;
        private static const HEALTH:Number = 2;

        public function Truck()
        {
            this._hitPoint = new b2Vec2();
            this._hitForce = new b2Vec2();
            this._actionPoint = new Avector();
            this._tm = new TaskManager();
            group = Kind.GROUP_BREAKABLE;
            _kind = Kind.TRUCK;
            _sprite = ZG.animCache.getAnimation(Art.TRUCK_BODY);
            this._ragdoll = _universe.ragdollStorage.getValue(RAGDOLL_NAME);
            this._aButton = ZG.animCache.getAnimation(Art.TRUCK_BUTTON);
            this._aArrow = ZG.animCache.getAnimation(Art.ACTIVE_ELEMENT);
            return;
        }// end function

        override public function get damage() : Number
        {
            return EXPLOSION_DAMAGE;
        }// end function

        public function get activateDistance() : int
        {
            return 1;
        }// end function

        private function doDead() : Boolean
        {
            _sprite.alpha = _sprite.alpha - 0.02;
            if (_sprite.alpha <= 0)
            {
                _sprite.alpha = 0;
                this.free();
                return true;
            }
            return false;
        }// end function

        public function set dir(param1:String) : void
        {
            switch(param1)
            {
                case "right":
                {
                    this._dir = DIR_RIGHT;
                    break;
                }
                default:
                {
                    this._dir = DIR_LEFT;
                    break;
                    break;
                }
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _sprite.smoothing = _universe.smoothing;
            _sprite.scaleX = this._dir == DIR_RIGHT ? (1) : (-1);
            addChild(_sprite);
            this._aButton.scaleX = _sprite.scaleX;
            this._aButton.smoothing = _universe.smoothing;
            this._aButton.gotoAndStop(1);
            this._aButton.addChild(this._aArrow);
            this._aArrow.x = 28;
            this._aArrow.y = -32;
            this._aArrow.play();
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_6.density = 1;
            _loc_6.friction = 0.8;
            _loc_6.restitution = 0;
            _loc_6.filter.categoryBits = 4;
            _loc_6.filter.groupIndex = -2;
            _loc_5.userData = this;
            var _loc_7:* = this._ragdoll.getBody("body1");
            _loc_7.scaleX = _sprite.scaleX;
            _loc_6.SetAsOrientedBox(_loc_7.width * 0.5 / Universe.DRAW_SCALE, _loc_7.height * 0.5 / Universe.DRAW_SCALE, new b2Vec2(_loc_7.x / Universe.DRAW_SCALE, _loc_7.y / Universe.DRAW_SCALE), 0);
            _loc_5.position.Set((param1 + _loc_7.x) / Universe.DRAW_SCALE, (param2 + _loc_7.y) / Universe.DRAW_SCALE);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _loc_7 = this._ragdoll.getBody("body2");
            _loc_7.scaleX = _sprite.scaleX;
            _loc_6.SetAsOrientedBox(_loc_7.width * 0.5 / Universe.DRAW_SCALE, _loc_7.height * 0.5 / Universe.DRAW_SCALE, new b2Vec2(_loc_7.x / Universe.DRAW_SCALE, _loc_7.y / Universe.DRAW_SCALE), Amath.toRadians(_loc_7.angle));
            _body.CreateShape(_loc_6);
            _loc_7 = this._ragdoll.getBody("body3");
            _loc_7.scaleX = _sprite.scaleX;
            _loc_6.SetAsOrientedBox(_loc_7.width * 0.5 / Universe.DRAW_SCALE, _loc_7.height * 0.5 / Universe.DRAW_SCALE, new b2Vec2(_loc_7.x / Universe.DRAW_SCALE, _loc_7.y / Universe.DRAW_SCALE), Amath.toRadians(_loc_7.angle));
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            _loc_7 = this._ragdoll.getBody("wheel1");
            _loc_7.scaleX = _sprite.scaleX;
            this._wheelA = CartWheel.get();
            this._wheelA.kind = Kind.TRUCK_WHEEL;
            this._wheelA.init(param1 + _loc_7.x, param2 + _loc_7.y);
            var _loc_8:* = new b2RevoluteJointDef();
            var _loc_9:* = new b2Vec2();
            var _loc_10:* = new b2Vec2(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_7 = this._ragdoll.getJoint("jointWheel1");
            _loc_7.scaleX = _sprite.scaleX;
            _loc_7.addOffset(_loc_10, _loc_9);
            _loc_8.enableMotor = true;
            _loc_8.Initialize(_body, this._wheelA.body, _loc_9);
            this._jointA = _universe.physics.CreateJoint(_loc_8) as b2RevoluteJoint;
            this._jointA.SetMaxMotorTorque(1);
            _loc_7 = this._ragdoll.getBody("wheel2");
            _loc_7.scaleX = _sprite.scaleX;
            this._wheelB = CartWheel.get();
            this._wheelB.kind = Kind.TRUCK_WHEEL;
            this._wheelB.init(param1 + _loc_7.x, param2 + _loc_7.y);
            _loc_7 = this._ragdoll.getJoint("jointWheel2");
            _loc_7.scaleX = _sprite.scaleX;
            _loc_7.addOffset(_loc_10, _loc_9);
            _loc_8.enableMotor = true;
            _loc_8.Initialize(_body, this._wheelB.body, _loc_9);
            this._jointB = _universe.physics.CreateJoint(_loc_8) as b2RevoluteJoint;
            this._jointB.SetMaxMotorTorque(1);
            this._actionPoint.x = 27 / Universe.DRAW_SCALE;
            this._actionPoint.y = -22 / Universe.DRAW_SCALE;
            reset();
            _health = HEALTH;
            _universe.objects.add(this);
            return;
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        override public function render() : void
        {
            visibleCulling();
            if (_isVisible)
            {
                x = _body.GetPosition().x * Universe.DRAW_SCALE;
                y = _body.GetPosition().y * Universe.DRAW_SCALE;
                rotation = _body.GetAngle() / Math.PI * 180 % 360;
                this._aButton.x = x;
                this._aButton.y = y;
                this._aButton.rotation = rotation;
            }
            return;
        }// end function

        public function action(param1:Function = null) : void
        {
            if (!_die)
            {
                this._action = this._action == ACT_STOP ? (ACT_MOVE) : (ACT_STOP);
                switch(this._action)
                {
                    case ACT_MOVE:
                    {
                        this._speed = _sprite.scaleX == 1 ? (3) : (-3);
                        this._motorTorque = 45;
                        ZG.sound(SoundManager.TRUCK_MOVE, this);
                        this._aButton.gotoAndStop(2);
                        break;
                    }
                    case ACT_STOP:
                    {
                        this._speed = 0;
                        this._motorTorque = 1;
                        ZG.media.stop(SoundManager.TRUCK_MOVE);
                        this._aButton.gotoAndStop(1);
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

        public function changeState() : void
        {
            return;
        }// end function

        override public function hide() : void
        {
            if (_isVisible)
            {
                _universe.remove(this, _layer);
                _universe.remove(this._aButton, Universe.LAYER_BG_OBJECTS);
                this._aArrow.stop();
                _isVisible = false;
            }
            return;
        }// end function

        private function makeDeadBody() : void
        {
            var _loc_1:* = EffectHitTo.get();
            _loc_1.variety = EffectHitTo.GROUND;
            _loc_1.init(this.x, this.y, this.rotation + 90);
            var _loc_2:* = EffectBurnSmall.get();
            _loc_2.setBody(_body, new b2Vec2(-19 * _sprite.scaleX, -27));
            _loc_2.timeLife(EXPLOSION_DELAY);
            _loc_2.init(_position.x + -19 * _sprite.scaleX, _position.y - 27);
            _sprite.gotoAndStop(2);
            _universe.joints.add(this._jointA, 100);
            _universe.joints.add(this._jointB, 100);
            if (this._action == ACT_MOVE)
            {
                this.action();
            }
            this._tm.clear();
            this._tm.addPause(EXPLOSION_DELAY);
            this._tm.addInstantTask(this.doExplosion);
            this._tm.addPause(Amath.random(150, 300));
            this._tm.addTask(this.doDead);
            _body.ApplyImpulse(new b2Vec2(this._hitForce.x, this._hitForce.y), this._hitPoint);
            this._wheelA.jointDead();
            this._wheelB.jointDead();
            this._aArrow.alpha = 0;
            ZG.sound(SoundManager.TURRET_DIE, this);
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
                    this.makeDeadBody();
                    _die = true;
                }
            }
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            var _loc_1:* = new Avector(_body.GetPosition().x, _body.GetPosition().y);
            _loc_1 = Amath.rotatePointDeg(_loc_1.x + this._actionPoint.x, _loc_1.y + this._actionPoint.y, _body.GetPosition().x, _body.GetPosition().y, Amath.toDegrees(_body.GetAngle()));
            return _loc_1;
        }// end function

        public function get alias() : String
        {
            return this._alias;
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
                    this.makeDeadBody();
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

        private function doExplosion() : void
        {
            var _loc_3:b2Body = null;
            var _loc_4:b2Shape = null;
            var _loc_1:* = new b2AABB();
            _loc_1.lowerBound.Set(_body.GetWorldCenter().x - 5, _body.GetWorldCenter().y - 5);
            _loc_1.upperBound.Set(_body.GetWorldCenter().x + 5, _body.GetWorldCenter().y + 5);
            var _loc_2:Array = [];
            _universe.physics.Query(_loc_1, _loc_2, 30);
            var _loc_5:* = _loc_2.length;
            var _loc_6:uint = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_3 = (_loc_2[_loc_6] as b2Shape).GetBody();
                if (_loc_3 != null && _loc_3.m_userData is Truck)
                {
                    if (_loc_3.m_userData as Truck == this)
                    {
                        _loc_4 = _loc_2[_loc_6];
                        break;
                    }
                }
                _loc_6 = _loc_6 + 1;
            }
            var _loc_7:* = new b2Vec2();
            var _loc_8:* = new b2Vec2();
            var _loc_9:Number = 0;
            var _loc_10:* = new b2Vec2();
            _loc_5 = _loc_2.length;
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_3 = _loc_2[_loc_6].GetBody();
                if (_loc_3 == null || _loc_4 == null)
                {
                }
                else
                {
                    _loc_9 = b2Distance.Distance(_loc_7, _loc_8, _loc_4, _loc_4.GetBody().GetXForm(), _loc_2[_loc_6], _loc_3.GetXForm());
                    _loc_9 = _loc_9 <= 1 && _loc_9 >= 0 ? (1) : (_loc_9);
                    if (_loc_3.m_userData is BasicObject)
                    {
                        _loc_10.x = _loc_7.x < _loc_8.x ? (EXPLOSION_POWER / _loc_9) : ((-EXPLOSION_POWER) / _loc_9);
                        _loc_10.y = _loc_7.y < _loc_8.y ? (EXPLOSION_POWER / _loc_9) : ((-EXPLOSION_POWER) / _loc_9);
                        if (!(_loc_3.m_userData as BasicObject).explode(this, _loc_8, _loc_10))
                        {
                            _loc_3.ApplyImpulse(_loc_10, _loc_8);
                        }
                    }
                }
                _loc_6 = _loc_6 + 1;
            }
            var _loc_11:* = EffectExplosion.get();
            _loc_11.variety = EffectExplosion.BOMB_EXPLOSION;
            _loc_11.init(_position.x - 19, _position.y - 27);
            ZG.sound(SoundManager.TURRET_EXPLOSION, this);
            _universe.quake(2);
            var _loc_12:* = EffectBurn.get();
            _loc_12.setBody(_body, new b2Vec2(-19 * _sprite.scaleX, -27));
            _loc_12.timeLife(100);
            _loc_12.init(_position.x + -19 * _sprite.scaleX, _position.y - 27);
            _sprite.gotoAndStop(3);
            return;
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
                    this._hitForce = new b2Vec2(param2.x, param2.y);
                    this.makeDeadBody();
                }
                else
                {
                    _body.ApplyImpulse(param2, param1);
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
                this._aArrow.stop();
                this._aButton.removeChild(this._aArrow);
                ZG.media.stop(SoundManager.TRUCK_MOVE);
                _universe.objects.remove(this);
                this._wheelA.free();
                this._wheelB.free();
                _universe.physics.DestroyBody(_body);
                super.free();
            }
            return;
        }// end function

        override public function process() : void
        {
            var _loc_1:EffectSmoke = null;
            var _loc_2:Avector = null;
            if (_body != null)
            {
                _position.x = _body.GetPosition().x * Universe.DRAW_SCALE;
                _position.y = _body.GetPosition().y * Universe.DRAW_SCALE;
                if (this.enableLimit && this._action != ACT_STOP)
                {
                    if (_position.x > this.upperLimit || _position.x < this.lowerLimit)
                    {
                        this.action();
                        this._aArrow.alpha = 0;
                    }
                }
                this._jointA.SetMotorSpeed(this._speed * Math.PI);
                this._jointB.SetMotorSpeed(this._speed * Math.PI);
                this._jointA.SetMaxMotorTorque(this._motorTorque);
                this._jointB.SetMaxMotorTorque(this._motorTorque);
                if (this._action == ACT_MOVE)
                {
                    var _loc_3:String = this;
                    var _loc_4:* = this._effInterval - 1;
                    _loc_3._effInterval = _loc_4;
                    if (this._effInterval <= 0)
                    {
                        _loc_1 = EffectSmoke.get();
                        _loc_2 = new Avector(_position.x, _position.y);
                        _loc_2 = Amath.rotatePointDeg(_loc_2.x - 18, _loc_2.y - 44, _position.x, _position.y, Amath.toDegrees(_body.GetAngle()));
                        _loc_1.init(_loc_2.x, _loc_2.y);
                        this._effInterval = Amath.random(8, 13);
                    }
                }
            }
            return;
        }// end function

        override public function show() : void
        {
            if (!_isVisible)
            {
                _universe.add(this._aButton, Universe.LAYER_BG_OBJECTS);
                _universe.add(this, _layer);
                this._aArrow.play();
                _isVisible = true;
            }
            return;
        }// end function

    }
}
