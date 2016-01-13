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
    import com.antkarlov.repositories.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.events.*;
    import com.zombotron.interfaces.*;

    public class EnemyTurret extends BasicObject implements IActiveObject
    {
        private var _targetAngle:Number = 0;
        private var _shootTime:int = 0;
        private var _targetObject:BasicObject = null;
        private var _isAlert:Boolean = false;
        private var _schedules:Repository;
        private var _visionList:Array;
        private var _sensorContacts:Array;
        private var _alias:String = "";
        private var _aFlasher:Animation;
        private var _attackDelay:int = 0;
        private var _conditions:Conditions;
        private var _wheelA:CartWheel;
        private var _wheelB:CartWheel;
        private var _trigger:TriggerPart;
        private var _gunCharger:int = 3;
        private var _targetPos:Avector;
        private var _motorA:b2RevoluteJoint;
        private var _motorB:b2RevoluteJoint;
        private var _tasks:TaskManager;
        private var _state:uint = 1;
        private var _aWeapon:Animation;
        private var _isHaveTrigger:Boolean = false;
        private var _isAim:Boolean = true;
        private var _moveDir:uint = 1;
        private var _alertTime:int = 0;
        private var _thinkInterval:int = 0;
        private var _raycastList:Array;
        private var _aBack:Animation;
        private var _schedule:Schedule = null;
        private var _turretDir:uint = 1;
        private static const EXPLOSION_DAMAGE:Number = 2;
        private static const SHOOT_INTERVAL:int = 15;
        private static const SCHEDULE_MOVE:String = "move";
        private static const WEAPON_Y:int = -14;
        private static const THINK_INTERVAL:int = 5;
        private static const CONDITION_OBSTACLE:uint = 5;
        private static const STATE_ATTACK:uint = 2;
        private static const CONDITION_SEE_ENEMY:uint = 2;
        private static const EXPLOSION_DELAY:int = 120;
        private static const EXPLOSION_POWER:int = 3;
        private static const HEALTH:Number = 1.5;
        private static const SCHEDULE_ATTACK:String = "attack";
        private static const CONDITION_IDLE:uint = 1;
        private static const BULLET_X:int = 36;
        private static const CONDITION_FIND_ENEMY:uint = 3;
        private static const ALERT_INTERVAL:int = 300;
        private static const STATE_IDLE:uint = 1;
        private static const DIR_RIGHT:uint = 2;
        private static const BULLET_Y:int = -2;
        private static const STATE_MOVE:uint = 3;
        private static const DAMAGE:Number = 0.2;
        private static const DIR_LEFT:uint = 1;
        private static const WEAPON_X:int = 3;
        private static const CONDITION_CAN_ATTACK:uint = 4;
        private static const SCHEDULE_IDLE:String = "idle";

        public function EnemyTurret()
        {
            this._conditions = new Conditions();
            this._schedules = new Repository();
            this._visionList = [];
            this._raycastList = [];
            this._targetPos = new Avector();
            this._tasks = new TaskManager();
            this._sensorContacts = [];
            group = Kind.GROUP_ROBOT;
            _kind = Kind.ENEMY_TURRET;
            this._aBack = $.animCache.getAnimation(Art.TURRET_BODY_BACK);
            _sprite = $.animCache.getAnimation(Art.TURRET_BODY);
            this._aFlasher = $.animCache.getAnimation(Art.TURRET_FLASHER);
            this._aWeapon = $.animCache.getAnimation(Art.TURRET_WEAPON);
            _allowSensing = true;
            var _loc_1:* = new Schedule(SCHEDULE_IDLE);
            _loc_1.addFewTasks([this.onIdleInit, this.onIdle]);
            _loc_1.addFewInterrupts([CONDITION_SEE_ENEMY, CONDITION_CAN_ATTACK]);
            this._schedules.setValue(SCHEDULE_IDLE, _loc_1);
            var _loc_2:* = new Schedule(SCHEDULE_ATTACK);
            _loc_2.addFewTasks([this.onAttackInit, this.onAttack, this.onAttackEnd]);
            this._schedules.setValue(SCHEDULE_ATTACK, _loc_2);
            var _loc_3:* = new Schedule(SCHEDULE_MOVE);
            _loc_3.addFewTasks([this.onMoveInit, this.onMove]);
            _loc_3.addFewInterrupts([CONDITION_CAN_ATTACK, CONDITION_OBSTACLE]);
            this._schedules.setValue(SCHEDULE_MOVE, _loc_3);
            return;
        }// end function

        private function seeToPoint(param1:b2Vec2) : BasicObject
        {
            var _loc_6:b2Body = null;
            var _loc_2:* = new b2Segment();
            _loc_2.p1 = new b2Vec2(_body.GetPosition().x, _body.GetPosition().y - 0.5);
            _loc_2.p2 = param1;
            var _loc_3:Array = [1];
            var _loc_4:* = new b2Vec2();
            var _loc_5:* = _universe.physics.RaycastOne(_loc_2, _loc_3, _loc_4, false, null);
            if (_loc_5)
            {
                _loc_6 = _loc_5.GetBody();
                if (_loc_6.m_userData is BasicObject)
                {
                    return _loc_6.m_userData as BasicObject;
                }
            }
            return null;
        }// end function

        private function onAttack() : Boolean
        {
            var _loc_1:Number = NaN;
            if (this._targetObject)
            {
                _loc_1 = Amath.getAngleDeg(_position.x + this._aWeapon.x, _position.y + this._aWeapon.y, this._targetObject.x, this._targetObject.y);
                if (this._turretDir == DIR_RIGHT)
                {
                    this._targetAngle = _loc_1 - this.rotation;
                    this._targetAngle = this._targetAngle > 358 ? (358) : (this._targetAngle);
                    this._targetAngle = this._targetAngle < 280 ? (280) : (this._targetAngle);
                }
                else
                {
                    this._targetAngle = _loc_1 - 180 - this.rotation;
                    this._targetAngle = this._targetAngle > 70 ? (70) : (this._targetAngle);
                    this._targetAngle = this._targetAngle < 2 ? (2) : (this._targetAngle);
                }
                this._isAim = false;
            }
            if (this._gunCharger > 0 && this._attackDelay >= 15)
            {
                this.shoot();
                return false;
            }
            return true;
        }// end function

        private function onIdleInit() : Boolean
        {
            if (!this._isAlert && this._aFlasher.playing)
            {
                this._aFlasher.gotoAndStop(13);
            }
            return true;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            this._aBack.smoothing = _universe.smoothing;
            addChild(this._aBack);
            this._aWeapon.smoothing = _universe.smoothing;
            this._aWeapon.gotoAndStop(1);
            this._aWeapon.x = -WEAPON_X;
            this._aWeapon.y = WEAPON_Y;
            addChild(this._aWeapon);
            _sprite.smoothing = _universe.smoothing;
            _sprite.gotoAndStop(1);
            addChild(_sprite);
            this._aFlasher.smoothing = _universe.smoothing;
            this._aFlasher.y = -26;
            this._aFlasher.gotoAndStop(13);
            addChild(this._aFlasher);
            if (this._turretDir == DIR_RIGHT)
            {
                this._aWeapon.scaleX = -1;
                this._aWeapon.x = WEAPON_X;
                this._aWeapon.rotation = -2;
                _sprite.scaleX = -1;
                this._aBack.scaleX = -1;
            }
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_6.density = 0.5;
            _loc_6.friction = 1;
            _loc_6.restitution = 0.1;
            _loc_6.filter.categoryBits = 2;
            _loc_6.filter.maskBits = 4;
            _loc_6.filter.groupIndex = 2;
            _loc_6.SetAsBox(30 / Universe.DRAW_SCALE, 6 / Universe.DRAW_SCALE);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_5.userData = this;
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _loc_6.SetAsOrientedBox(18 / Universe.DRAW_SCALE, 11 / Universe.DRAW_SCALE, new b2Vec2(0, -0.4), 0);
            _body.CreateShape(_loc_6);
            _loc_6.isSensor = true;
            _loc_6.SetAsOrientedBox(40 / Universe.DRAW_SCALE, 6 / Universe.DRAW_SCALE, new b2Vec2(), 0);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            this._wheelA = CartWheel.get();
            this._wheelA.kind = Kind.CART_WHEEL;
            this._wheelA.init(param1 - 22, param2 + 10);
            var _loc_7:* = new b2RevoluteJointDef();
            _loc_7.enableMotor = true;
            _loc_7.Initialize(this._wheelA.body, _body, this._wheelA.body.GetWorldCenter());
            this._motorA = _universe.physics.CreateJoint(_loc_7) as b2RevoluteJoint;
            this._wheelB = CartWheel.get();
            this._wheelB.kind = Kind.CART_WHEEL;
            this._wheelB.init(param1 + 22, param2 + 10);
            _loc_7 = new b2RevoluteJointDef();
            _loc_7.Initialize(this._wheelB.body, _body, this._wheelB.body.GetWorldCenter());
            this._motorB = _universe.physics.CreateJoint(_loc_7) as b2RevoluteJoint;
            this._trigger = new TriggerPart();
            this._trigger.partOf = this;
            this._trigger.setSize(5, 10);
            this._trigger.init(param1, param2 - 30);
            this._trigger.addEventListener(BasicObjectEvent.BULLET_COLLISION, this.bulletCollisionHandler);
            _loc_7 = new b2RevoluteJointDef();
            _loc_7.Initialize(this._trigger.body, _body, this._trigger.body.GetWorldCenter());
            _loc_7.enableLimit = true;
            this._isHaveTrigger = true;
            _health = ZG.hardcoreMode ? (HEALTH) : (HEALTH * 0.66);
            _damage = ZG.hardcoreMode ? (DAMAGE) : (DAMAGE * 0.66);
            this._isAlert = false;
            reset();
            this.setSchedule(SCHEDULE_IDLE);
            _universe.objects.add(this);
            return;
        }// end function

        private function generateConditions() : void
        {
            var _loc_1:BasicObject = null;
            var _loc_2:BasicObject = null;
            var _loc_6:Number = NaN;
            this._conditions.clear();
            this.getObjectsAround();
            var _loc_3:* = this._visionList.length;
            var _loc_4:int = 0;
            this._raycastList.length = 0;
            var _loc_5:uint = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_1 = this._visionList[_loc_5].obj;
                if (_loc_1.kind == Kind.HERO || _loc_1.kind == Kind.ENEMY_ZOMBIE || _loc_1.kind == Kind.ENEMY_ZOMBIE_ARMOR || _loc_1.kind == Kind.ENEMY_ZOMBIE_BOMB || _loc_1.kind == Kind.ENEMY_SKELETON)
                {
                    _loc_2 = this.seeToPoint(new b2Vec2(_loc_1.body.GetPosition().x, _loc_1.body.GetPosition().y));
                    _loc_6 = Amath.getAngleDeg(_position.x, _position.y, _loc_1.x, _loc_1.y) - this.rotation;
                    if (_loc_2 && _loc_2 is BasicObject)
                    {
                        this._raycastList[this._raycastList.length] = new Avector(_loc_2.body.GetPosition().x, _loc_2.body.GetPosition().y);
                    }
                    switch(this._turretDir)
                    {
                        case DIR_LEFT:
                        {
                            if (_loc_2 && _loc_6 > 180 && _loc_6 < 270 && (_loc_2 is Player || _loc_2 is EnemyZombie || _loc_2 is EnemyZombieArmor || _loc_2 is EnemyZombieBomb || _loc_2 is PlayerWheel || _loc_2 is EnemyWheel))
                            {
                                this._conditions.setValue(CONDITION_CAN_ATTACK);
                                this._alertTime = _universe.frameTime;
                                this._isAlert = true;
                                this._targetObject = _loc_2 as BasicObject;
                                this._targetPos.set(this._targetObject.x, this._targetObject.y);
                                break;
                            }
                            break;
                        }
                        case DIR_RIGHT:
                        {
                            if (_loc_2 && _loc_6 < 358 && _loc_6 > 270 && (_loc_2 is Player || _loc_2 is EnemyZombie || _loc_2 is EnemyZombieArmor || _loc_2 is EnemyZombieBomb || _loc_2 is PlayerWheel || _loc_2 is EnemyWheel))
                            {
                                this._conditions.setValue(CONDITION_CAN_ATTACK);
                                this._alertTime = _universe.frameTime;
                                this._isAlert = true;
                                this._targetObject = _loc_2 as BasicObject;
                                this._targetPos.set(this._targetObject.x, this._targetObject.y);
                                break;
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                _loc_5 = _loc_5 + 1;
            }
            if (this._isAlert && _universe.frameTime - this._alertTime < ALERT_INTERVAL)
            {
                if (!this._conditions.contains(CONDITION_CAN_ATTACK))
                {
                    if (Amath.equal(this._targetPos.x, _position.x, 5))
                    {
                        this._conditions.setValue(CONDITION_IDLE);
                    }
                    else
                    {
                        this._moveDir = this._targetPos.x < _position.x ? (DIR_LEFT) : (DIR_RIGHT);
                        this._conditions.setValue(CONDITION_FIND_ENEMY);
                    }
                }
            }
            else if (this._isAlert)
            {
                this._isAlert = false;
                this._conditions.setValue(CONDITION_IDLE);
            }
            else
            {
                this._conditions.setValue(CONDITION_IDLE);
            }
            if (this._sensorContacts.length > 0)
            {
                _loc_3 = this._sensorContacts.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_3)
                {
                    
                    _loc_1 = this._sensorContacts[_loc_5] as BasicObject;
                    if (_loc_1 && (this._moveDir == DIR_LEFT && _loc_1.x < _position.x || this._moveDir == DIR_RIGHT && _loc_1.x > _position.x))
                    {
                        this._conditions.setValue(CONDITION_OBSTACLE);
                        this.brake();
                        break;
                    }
                    _loc_5 = _loc_5 + 1;
                }
            }
            this._sensorContacts.length = 0;
            return;
        }// end function

        private function setSchedule(param1:String) : void
        {
            this._schedule = this._schedules.getValue(param1);
            return;
        }// end function

        private function taskExplosion() : Boolean
        {
            var res:Array;
            var body:b2Body;
            var self:b2Shape;
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
            eff.variety = EffectExplosion.BOMB_EXPLOSION;
            eff.init(_position.x, _position.y);
            ZG.sound(SoundManager.TURRET_EXPLOSION, this);
            _universe.quake(2);
            var effBurn:* = EffectBurn.get();
            effBurn.setBody(_body, new b2Vec2(0, this._aFlasher.y + 5));
            effBurn.timeLife(100);
            effBurn.init(_position.x, _position.y + this._aFlasher.y);
            _sprite.gotoAndStop(4);
            this._aWeapon.alpha = 0;
            this.makeDeadBody(_position.x, _position.y);
            return true;
        }// end function

        public function get activateDistance() : int
        {
            return -1;
        }// end function

        public function set dir(param1:String) : void
        {
            switch(param1)
            {
                case "right":
                {
                    this._turretDir = DIR_RIGHT;
                    break;
                }
                default:
                {
                    this._turretDir = DIR_LEFT;
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function brake() : void
        {
            this._motorA.SetMotorSpeed(0);
            this._motorA.SetMaxMotorTorque(0);
            this._motorB.SetMotorSpeed(0);
            this._motorB.SetMaxMotorTorque(0);
            return;
        }// end function

        private function renderVision() : void
        {
            var _loc_1:Avector = null;
            var _loc_2:Avector = null;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            if (ZG.debugMode && _body != null)
            {
                _loc_1 = new Avector();
                _universe.layerDraws.graphics.lineStyle(1, 10470965, 0.8);
                _universe.layerDraws.graphics.beginFill(10470965, 0.5);
                _loc_3 = this._raycastList.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_1.set(_body.GetPosition().x, _body.GetPosition().y);
                    _loc_2 = this._raycastList[_loc_4];
                    _universe.layerDraws.graphics.moveTo(_loc_1.x * Universe.DRAW_SCALE, _loc_1.y * Universe.DRAW_SCALE);
                    _universe.layerDraws.graphics.lineTo(_loc_2.x * Universe.DRAW_SCALE, _loc_2.y * Universe.DRAW_SCALE);
                    _loc_4 = _loc_4 + 1;
                }
                _universe.layerDraws.graphics.endFill();
            }
            return;
        }// end function

        private function shoot() : void
        {
            var _loc_1:Avector = null;
            var _loc_2:Number = NaN;
            var _loc_3:Avector = null;
            var _loc_4:EffectShoot = null;
            var _loc_5:Bullet = null;
            var _loc_6:EffectBulletCase = null;
            if (this._shootTime >= SHOOT_INTERVAL)
            {
                if (this._gunCharger > 0)
                {
                    this._aWeapon.repeat = false;
                    this._aWeapon.gotoAndPlay(1);
                    this._shootTime = 0;
                    if (_sprite.currentFrame == 1)
                    {
                        _sprite.gotoAndStop(2);
                    }
                    else
                    {
                        _sprite.gotoAndStop(1);
                    }
                    _loc_1 = new Avector(_position.x + this._aWeapon.x, _position.y + this._aWeapon.y);
                    _loc_2 = this._aWeapon.rotation + this.rotation;
                    _loc_3 = new Avector((-BULLET_X) * this._aWeapon.scaleX, BULLET_Y);
                    _loc_3.rotateAroundDeg(_loc_1, _loc_2);
                    _loc_4 = EffectShoot.get();
                    _loc_4.variety = EffectShoot.TURRET_SHOT;
                    _loc_4.init(_loc_3.x, _loc_3.y, _loc_2, this._aWeapon.scaleX);
                    _loc_5 = Bullet.get();
                    _loc_5.damage = _damage;
                    _loc_5.init(_loc_3.x, _loc_3.y, _loc_2 + Amath.random(-8, 8), this._aWeapon.scaleX * -1);
                    _loc_5.allowStatistic = false;
                    _loc_6 = EffectBulletCase.get();
                    _loc_3 = Amath.rotatePointDeg(_position.x + -5 * this._aWeapon.scaleX, _position.y - 15, _position.x, _position.y, _sprite.rotation);
                    _loc_6.init(_loc_3.x, _loc_3.y, 0, _sprite.scaleX * -1);
                    ZG.sound(SoundManager.TURRET_SHOT, this);
                    var _loc_7:String = this;
                    var _loc_8:* = this._gunCharger - 1;
                    _loc_7._gunCharger = _loc_8;
                }
            }
            return;
        }// end function

        private function makeDeadBody(param1:Number, param2:Number) : void
        {
            var _loc_3:b2BodyDef = null;
            var _loc_4:b2PolygonDef = null;
            var _loc_5:b2Vec2 = null;
            var _loc_6:Coin = null;
            var _loc_7:int = 0;
            if (!_isDead)
            {
                _universe.physics.DestroyBody(_body);
                _loc_3 = new b2BodyDef();
                _loc_4 = new b2PolygonDef();
                _loc_4.density = 0.5;
                _loc_4.friction = 1;
                _loc_4.restitution = 0.1;
                _loc_4.SetAsBox(30 / Universe.DRAW_SCALE, 6 / Universe.DRAW_SCALE);
                _loc_3.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
                _loc_3.userData = this;
                _body = _universe.physics.CreateBody(_loc_3);
                _body.CreateShape(_loc_4);
                _body.SetMassFromShapes();
                this._wheelA.jointDead();
                this._wheelB.jointDead();
                _loc_7 = 0;
                while (_loc_7 < 2)
                {
                    
                    _loc_5 = new b2Vec2(Amath.random(0, 3) / 20, (Amath.random(-3, -2) - Math.random()) / 10);
                    _loc_5.x = _sprite.scaleX == DIR_LEFT ? (-_loc_5.x) : (_loc_5.x);
                    _loc_6 = Coin.get();
                    _loc_6.init(param1, param2);
                    _loc_6.body.ApplyImpulse(_loc_5, _loc_6.body.GetWorldCenter());
                    _loc_7++;
                }
                _universe.motiKillEnemy();
                _isDead = true;
            }
            return;
        }// end function

        private function getObjectsAround() : void
        {
            var _loc_3:b2Body = null;
            var _loc_4:BasicObject = null;
            var _loc_1:* = new b2AABB();
            _loc_1.lowerBound.Set(_body.GetWorldCenter().x - 10, _body.GetWorldCenter().y - 10);
            _loc_1.upperBound.Set(_body.GetWorldCenter().x + 10, _body.GetWorldCenter().y + 10);
            var _loc_2:Array = [];
            _universe.physics.Query(_loc_1, _loc_2, 40);
            var _loc_5:* = _loc_2.length;
            this._visionList.length = 0;
            var _loc_6:uint = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_3 = (_loc_2[_loc_6] as b2Shape).GetBody();
                if (_loc_3.m_userData is BasicObject)
                {
                    _loc_4 = _loc_3.m_userData as BasicObject;
                    switch(_loc_4.kind)
                    {
                        case Kind.HERO:
                        {
                            this._visionList[this._visionList.length] = {obj:_universe.player, priority:101};
                            break;
                        }
                        case Kind.ENEMY_ZOMBIE:
                        case Kind.ENEMY_ZOMBIE_ARMOR:
                        case Kind.ENEMY_ZOMBIE_BOMB:
                        case Kind.ENEMY_SKELETON:
                        {
                            this._visionList[this._visionList.length] = {obj:_loc_4, priority:100};
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                _loc_6 = _loc_6 + 1;
            }
            this._visionList.sortOn("priority", Array.DESCENDING | Array.NUMERIC);
            return;
        }// end function

        private function onMove() : Boolean
        {
            if (Amath.equal(_position.x, this._targetPos.x, 5))
            {
                this.brake();
                return true;
            }
            switch(this._moveDir)
            {
                case DIR_LEFT:
                {
                    if (_body.GetLinearVelocity().x < 9)
                    {
                        this._motorA.SetMotorSpeed(10);
                        this._motorA.SetMaxMotorTorque(15);
                        this._motorB.SetMotorSpeed(10);
                        this._motorB.SetMaxMotorTorque(15);
                    }
                    else
                    {
                        this.brake();
                    }
                    break;
                }
                case DIR_RIGHT:
                {
                    if (_body.GetLinearVelocity().x > -9)
                    {
                        this._motorA.SetMotorSpeed(-10);
                        this._motorA.SetMaxMotorTorque(15);
                        this._motorB.SetMotorSpeed(-10);
                        this._motorB.SetMaxMotorTorque(15);
                    }
                    else
                    {
                        this.brake();
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

        private function onIdle() : Boolean
        {
            var _loc_1:* = _body.GetLinearVelocity();
            if (_loc_1.x != 0)
            {
                this._wheelA.body.SetAngularVelocity(0);
                this._wheelB.body.SetAngularVelocity(0);
            }
            if (!this._isAlert && this._aFlasher.playing)
            {
                this._aFlasher.gotoAndStop(13);
            }
            return false;
        }// end function

        private function onAttackEnd() : Boolean
        {
            this._attackDelay = this._attackDelay > 15 ? (0) : (this._attackDelay);
            return true;
        }// end function

        private function aimToTarget() : void
        {
            if (this._targetAngle < Amath.normAngleDeg(this._aWeapon.rotation))
            {
                (this._aWeapon.rotation - 1);
            }
            else if (this._targetAngle > Amath.normAngleDeg(this._aWeapon.rotation))
            {
                (this._aWeapon.rotation + 1);
            }
            if (Amath.equal(this._targetAngle, Amath.normAngleDeg(this._aWeapon.rotation), 2))
            {
                this._aWeapon.rotation = this._targetAngle;
                this._isAim = true;
            }
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector();
        }// end function

        override public function bulletCollision(param1:Bullet, param2:b2Vec2) : void
        {
            if (!_die)
            {
                _health = _health - param1.damage;
                if (_health <= 0)
                {
                    this.bulletCollisionHandler();
                }
            }
            return;
        }// end function

        public function action(param1:Function = null) : void
        {
            $.trace("EnemyTurret::action()");
            return;
        }// end function

        public function get alias() : String
        {
            return this._alias;
        }// end function

        override public function toString() : String
        {
            var _loc_1:* = this._turretDir == DIR_LEFT ? ("left") : ("right");
            return "{EnemyTurret [alias: " + this._alias + ", dir: " + _loc_1 + "]}";
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.physics.DestroyBody(_body);
                this._trigger.removeEventListener(BasicObjectEvent.BULLET_COLLISION, this.bulletCollisionHandler);
                if (this._isHaveTrigger)
                {
                    this._trigger.free();
                    this._isHaveTrigger = false;
                }
                removeChild(this._aFlasher);
                removeChild(this._aWeapon);
                removeChild(this._aBack);
                this._tasks.clear();
                this._schedule.reset();
                _universe.objects.remove(this);
                super.free();
            }
            return;
        }// end function

        override public function process() : void
        {
            super.process();
            if (_die)
            {
                return;
            }
            if (_universe.frameTime - this._thinkInterval > THINK_INTERVAL)
            {
                this.think();
                this._thinkInterval = _universe.frameTime;
            }
            var _loc_1:String = this;
            var _loc_2:* = this._shootTime + 1;
            _loc_1._shootTime = _loc_2;
            var _loc_1:String = this;
            var _loc_2:* = this._attackDelay + 1;
            _loc_1._attackDelay = _loc_2;
            if (this._schedule)
            {
                this._schedule.process();
            }
            if (!this._isAim)
            {
                this.aimToTarget();
            }
            this.renderVision();
            return;
        }// end function

        override public function get damage() : Number
        {
            return EXPLOSION_DAMAGE;
        }// end function

        override public function die() : void
        {
            return;
        }// end function

        private function taskDead() : Boolean
        {
            _sprite.alpha = _sprite.alpha - 0.02;
            this._aBack.alpha = _sprite.alpha;
            if (_sprite.alpha <= 0)
            {
                _sprite.alpha = 0;
                this._aBack.alpha = 0;
                this.free();
                return true;
            }
            return false;
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        private function onMoveInit() : Boolean
        {
            _body.WakeUp();
            return true;
        }// end function

        private function onAttackInit() : Boolean
        {
            if (!this._aFlasher.playing)
            {
                this._aFlasher.play();
            }
            this._gunCharger = 3;
            this.brake();
            return true;
        }// end function

        private function selectNewSchedule() : void
        {
            switch(this._state)
            {
                case STATE_IDLE:
                {
                    if (this._conditions.contains(CONDITION_CAN_ATTACK))
                    {
                        this.setSchedule(SCHEDULE_ATTACK);
                    }
                    else if (this._conditions.contains(CONDITION_FIND_ENEMY) && !this._conditions.contains(CONDITION_OBSTACLE))
                    {
                        this.setSchedule(SCHEDULE_MOVE);
                    }
                    else if (this._conditions.contains(CONDITION_IDLE) || this._conditions.contains(CONDITION_OBSTACLE))
                    {
                        this.setSchedule(SCHEDULE_IDLE);
                    }
                    break;
                }
                case STATE_ATTACK:
                {
                    if (this._conditions.contains(CONDITION_CAN_ATTACK))
                    {
                        this.setSchedule(SCHEDULE_ATTACK);
                    }
                    else if (this._conditions.contains(CONDITION_FIND_ENEMY) && !this._conditions.contains(CONDITION_OBSTACLE))
                    {
                        this.setSchedule(SCHEDULE_MOVE);
                    }
                    else if (this._conditions.contains(CONDITION_IDLE) || this._conditions.contains(CONDITION_OBSTACLE))
                    {
                        this.setSchedule(SCHEDULE_IDLE);
                    }
                    break;
                }
                case STATE_MOVE:
                {
                    if (this._conditions.contains(CONDITION_OBSTACLE))
                    {
                        this.brake();
                    }
                    if (this._conditions.contains(CONDITION_CAN_ATTACK))
                    {
                        this.brake();
                        this.setSchedule(SCHEDULE_ATTACK);
                    }
                    else if (this._conditions.contains(CONDITION_IDLE) || this._conditions.contains(CONDITION_OBSTACLE))
                    {
                        this.brake();
                        this.setSchedule(SCHEDULE_IDLE);
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

        public function changeState() : void
        {
            return;
        }// end function

        private function bulletCollisionHandler(event:BasicObjectEvent = null) : void
        {
            var _loc_2:EffectHitTo = null;
            var _loc_3:EffectBurnSmall = null;
            if (!_die)
            {
                _loc_2 = EffectHitTo.get();
                _loc_2.variety = EffectHitTo.GROUND;
                _loc_2.init(_position.x, _position.y + this._aFlasher.y, this.rotation + 90);
                _loc_3 = EffectBurnSmall.get();
                _loc_3.setBody(_body, new b2Vec2(0, this._aFlasher.y + 5));
                _loc_3.timeLife(150);
                _loc_3.init(_position.x, _position.y + this._aFlasher.y);
                _sprite.gotoAndStop(3);
                _universe.joints.add(this._motorA, 45);
                _universe.joints.add(this._motorB, 45);
                this._aFlasher.alpha = 0;
                this.brake();
                this._tasks.clear();
                this._tasks.addPause(EXPLOSION_DELAY);
                this._tasks.addTask(this.taskExplosion);
                this._tasks.addPause(Amath.random(150, 300));
                this._tasks.addTask(this.taskDead);
                ZG.sound(SoundManager.TURRET_DIE, this);
                this._isHaveTrigger = false;
                _die = true;
            }
            return;
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
                    this.bulletCollisionHandler();
                }
                return false;
            }
            else
            {
                return false;
            }
        }// end function

        private function think() : void
        {
            this.generateConditions();
            if (this._schedule.isComplete(this._conditions))
            {
                this.selectNewSchedule();
            }
            return;
        }// end function

    }
}
