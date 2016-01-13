package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.antkarlov.repositories.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.events.*;
    import com.zombotron.gui.*;
    import com.zombotron.helpers.*;
    import com.zombotron.interfaces.*;

    public class Boss extends BasicEnemy implements IEnemyObject
    {
        public var callbackJump:String = "null";
        private var _isAlert:Boolean = false;
        private var _wheelBody:b2Body;
        private var _fireImpulse:Avector;
        private var _targetToFire:BasicObject;
        private var _ragdoll:Ragdoll;
        private var _schedules:Repository;
        private var _conditions:Conditions;
        private var _wheel:EnemyWheel;
        private var _thinkTime:int = 0;
        private var _headLeft:TriggerPart;
        private var _targetToAttack:BasicObject;
        private var _joint:b2RevoluteJoint;
        private var _state:int = 0;
        private var _delay:int = 80;
        private var _headRight:TriggerPart;
        private var _reflected:Boolean = false;
        private var _oldScale:int = 0;
        private var _alertTime:int = 0;
        private var _dir:int = 1;
        private var _godModeInterval:int = 0;
        private var _jumpInterval:int = 0;
        private var _schedule:Schedule = null;
        private var _fireInterval:int = 0;
        public var callbackDie:String = "null";
        private static const SCHEDULE_STAY:String = "stay";
        public static const RAGDOLL_NAME:String = "RagdollBoss";
        private static const CONDITION_WALK:uint = 1;
        private static const THINK_INTERVAL:int = 4;
        private static const CONDITION_SEE_ENEMY:uint = 4;
        private static const DIR_LEFT:int = 1;
        private static const CONDITION_STAY:uint = 0;
        private static const CONDITION_CAN_JUMP:uint = 6;
        private static const CONDITION_CAN_FIRE:uint = 7;
        private static const DIR_RIGHT:int = -1;
        private static const WALK_SPEED:int = 5;
        private static const STATE_JUMP:uint = 4;
        private static const STRENGTH_OF_JOINT:int = 300;
        private static const STATE_FIRE:uint = 3;
        private static const CONDITION_CAN_BREAK:uint = 5;
        private static const CONDITION_OBSTACLE:uint = 3;
        private static const STATE_ATTACK:uint = 2;
        private static const STATE_WALK:uint = 1;
        private static const HEALTH:Number = 40;
        private static const SCHEDULE_JUMP:String = "jump";
        private static const SCHEDULE_FIRE:String = "fire";
        private static const STATE_STAY:uint = 0;
        private static const ALERT_INTERVAL:int = 150;
        private static const DAMAGE:Number = 0.6;
        private static const SCHEDULE_ATTACK:String = "attack";
        private static const SCHEDULE_WALK:String = "walk";
        private static const CONDITION_CAN_ATTACK:uint = 2;

        public function Boss()
        {
            this._wheel = new EnemyWheel();
            this._conditions = new Conditions();
            this._schedules = new Repository();
            this._fireImpulse = new Avector();
            group = Kind.GROUP_BOSS;
            _kind = Kind.ENEMY_BOSS;
            _allowContacts = true;
            _allowSensing = true;
            _visibleCulling = false;
            this._ragdoll = _universe.ragdollStorage.getValue(RAGDOLL_NAME);
            var _loc_1:* = new Schedule(SCHEDULE_STAY);
            _loc_1.addFewTasks([this.onStayInit, this.onStayAnim, this.onStay]);
            _loc_1.addFewInterrupts([CONDITION_SEE_ENEMY, CONDITION_CAN_ATTACK, CONDITION_CAN_BREAK]);
            this._schedules.setValue(SCHEDULE_STAY, _loc_1);
            var _loc_2:* = new Schedule(SCHEDULE_WALK);
            _loc_2.addFewTasks([this.onWalkInit, this.onWalkAnim, this.onWalk]);
            _loc_2.addFewInterrupts([CONDITION_OBSTACLE, CONDITION_CAN_ATTACK, CONDITION_CAN_BREAK]);
            this._schedules.setValue(SCHEDULE_WALK, _loc_2);
            var _loc_3:* = new Schedule(SCHEDULE_ATTACK);
            _loc_3.addFewTasks([this.onAttackInit, this.onAttackAnim, this.onAttack]);
            this._schedules.setValue(SCHEDULE_ATTACK, _loc_3);
            var _loc_4:* = new Schedule(SCHEDULE_FIRE);
            _loc_4.addFewTasks([this.onFireInit, this.onFireAnim, this.onFire]);
            this._schedules.setValue(SCHEDULE_FIRE, _loc_4);
            var _loc_5:* = new Schedule(SCHEDULE_JUMP);
            _loc_5.addFewTasks([this.onJumpInit, this.onJumpAnim, this.onJump]);
            this._schedules.setValue(SCHEDULE_JUMP, _loc_5);
            return;
        }// end function

        private function onAttack() : Boolean
        {
            var _loc_1:Boolean = false;
            var _loc_2:b2Vec2 = null;
            var _loc_3:b2Vec2 = null;
            var _loc_4:EffectSpark = null;
            var _loc_5:uint = 0;
            if (this._targetToAttack != null && this._targetToAttack.body != null)
            {
                _loc_1 = false;
                _loc_1 = Math.abs(_body.GetPosition().y - this._targetToAttack.body.GetPosition().y) > 5 ? (true) : (false);
                if (!_loc_1 && _sprite.currentFrame == 26 || _loc_1 && _sprite.currentFrame == 25)
                {
                    _loc_2 = new b2Vec2(this._targetToAttack.body.GetPosition().x, this._targetToAttack.body.GetPosition().y);
                    if (_loc_1)
                    {
                        _loc_2.y = _loc_2.y + 0.8;
                    }
                    else
                    {
                        _loc_2.x = _loc_2.x + (_sprite.scaleX == DIR_LEFT ? (1) : (-1));
                    }
                    if (Amath.distance(this._targetToAttack.body.GetPosition().x, this._targetToAttack.body.GetPosition().y, _loc_2.x, _loc_2.y) < 3)
                    {
                        _loc_3 = new b2Vec2(2, -2);
                        _loc_3.x = _loc_3.x * (_sprite.scaleX == DIR_LEFT ? (-0.9) : (0.9));
                        if (!this._targetToAttack.attacked(_loc_2, _loc_3, _damage))
                        {
                            _loc_5 = 0;
                            while (_loc_5 < 2)
                            {
                                
                                _loc_4 = EffectSpark.get();
                                _loc_4.variety = Amath.random(1, 2);
                                _loc_4.speed = new Avector(Amath.random(1, 5), Amath.random(-1, -5));
                                _loc_4.speed.x = _sprite.scaleX < 0 ? (_loc_4.speed.x) : (_loc_4.speed.x * -1);
                                _loc_4.init(_loc_2.x * Universe.DRAW_SCALE, _loc_2.y * Universe.DRAW_SCALE);
                                _loc_5 = _loc_5 + 1;
                            }
                        }
                        this._targetToAttack = null;
                        ZG.sound(SoundManager.BOSS_ATTACK, this);
                    }
                }
            }
            return _sprite.currentFrame == _sprite.totalFrames ? (true) : (false);
        }// end function

        private function onStayAnim() : Boolean
        {
            switchAnim(Art.BOSS_STAND);
            return true;
        }// end function

        private function generateConditions() : void
        {
            this._conditions.clear();
            this.getObjectsAround(group, 0, 20);
            this.vision();
            if (_senseContacts.length > 0)
            {
                this.sense();
                this._conditions.setValue(CONDITION_WALK);
            }
            else
            {
                this._conditions.setValue(CONDITION_WALK);
                this._conditions.setValue(CONDITION_STAY);
            }
            if (this._jumpInterval >= 200 && !this._conditions.contains(CONDITION_CAN_ATTACK) && !this._conditions.contains(CONDITION_CAN_FIRE))
            {
                this._conditions.setValue(CONDITION_CAN_JUMP);
            }
            _senseContacts.length = 0;
            return;
        }// end function

        private function hurt(param1:Number) : void
        {
            _health = _health - param1;
            ZG.playerGui.bossHealth(_health);
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _curAnim = "";
            switchAnim(Art.BOSS_STAND);
            this.initPhysicBody(param1, param2);
            _visionList.length = 0;
            _health = HEALTH;
            _damage = DAMAGE;
            this._alertTime = 0;
            this._isAlert = false;
            reset();
            this.show();
            ZG.playerGui.totalBossHealth(_health);
            ZG.playerGui.showBossBar();
            ZG.playerGui.bossHealth(_health);
            this.setSchedule(SCHEDULE_STAY);
            this._thinkTime = _universe.frameTime;
            return;
        }// end function

        private function setSchedule(param1:String) : void
        {
            this._schedule = this._schedules.getValue(param1);
            return;
        }// end function

        private function isEnemyUnit(param1:uint) : Boolean
        {
            if (param1 == Kind.GROUP_PLAYER || param1 == Kind.GROUP_ROBOT || param1 == Kind.GROUP_SKELETON || param1 == Kind.GROUP_ZOMBIE)
            {
                return true;
            }
            return false;
        }// end function

        private function onStayInit() : Boolean
        {
            this._state = STATE_STAY;
            this._delay = _universe.frameTime + Amath.random(50, 80);
            this._joint.EnableLimit(true);
            return true;
        }// end function

        private function makeDeadBody(param1:Number, param2:Number) : void
        {
            var _loc_7:b2RevoluteJoint = null;
            var _loc_3:* = this._ragdoll.getBody("body");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_4:* = new BossPart();
            _loc_4.variety = BossPart.BODY;
            _loc_4.setSize(_loc_3.width, _loc_3.height);
            _loc_4.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getBody("head");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_5:* = new BossPart();
            _loc_5.variety = BossPart.HEAD;
            _loc_5.setSize(_loc_3.width, _loc_3.height);
            _loc_5.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            var _loc_6:* = new b2RevoluteJointDef();
            var _loc_8:* = new b2Vec2();
            var _loc_9:* = new b2Vec2(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_3 = this._ragdoll.getJoint("jointHead");
            _loc_3.scaleX = _sprite.scaleX;
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_5.body, _loc_4.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            _loc_3 = this._ragdoll.getBody("rightHand");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_10:* = new BossPart();
            _loc_10.variety = BossPart.HAND_RIGHT;
            _loc_10.setSize(_loc_3.width, _loc_3.height);
            _loc_10.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getJoint("jointRightHand");
            _loc_3.scaleX = _sprite.scaleX;
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_10.body, _loc_4.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            _loc_3 = this._ragdoll.getBody("leftHand1");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_11:* = new BossPart();
            _loc_11.variety = BossPart.HAND_LEFT1;
            _loc_11.setSize(_loc_3.width, _loc_3.height);
            _loc_11.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getJoint("jointLeftHand1");
            _loc_3.scaleX = _sprite.scaleX;
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_11.body, _loc_4.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            _loc_3 = this._ragdoll.getBody("leftHand2");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_12:* = new BossPart();
            _loc_12.variety = BossPart.HAND_LEFT2;
            _loc_12.setSize(_loc_3.width, _loc_3.height);
            _loc_12.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getJoint("jointLeftHand2");
            _loc_3.scaleX = _sprite.scaleX;
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_12.body, _loc_11.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            _loc_3 = this._ragdoll.getBody("rightLeg");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_13:* = new BossPart();
            _loc_13.variety = BossPart.LEG_RIGHT;
            _loc_13.setSize(_loc_3.width, _loc_3.height);
            _loc_13.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getJoint("jointRightLeg");
            _loc_3.scaleX = _sprite.scaleX;
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_13.body, _loc_4.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            _loc_3 = this._ragdoll.getBody("leftLeg");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_14:* = new BossPart();
            _loc_14.variety = BossPart.LEG_LEFT;
            _loc_14.setSize(_loc_3.width, _loc_3.height);
            _loc_14.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getJoint("jointLeftLeg");
            _loc_3.scaleX = _sprite.scaleX;
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_14.body, _loc_4.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            _loc_10.show();
            _loc_13.show();
            _loc_4.show();
            _loc_14.show();
            _loc_5.show();
            _loc_11.show();
            _loc_12.show();
            _loc_4.body.ApplyImpulse(new b2Vec2(_hitForce.x / 5, _hitForce.y / 5), _hitPoint);
            _loc_5.body.SetAngularVelocity(0);
            var _loc_15:* = new b2Vec2(Amath.random(0, 3) / 20, (Amath.random(-3, -2) - Math.random()) / 10);
            _loc_15.x = _sprite.scaleX == DIR_LEFT ? (-_loc_15.x) : (_loc_15.x);
            var _loc_16:* = Coin.get();
            _loc_16.init(param1, param2);
            _loc_16.body.ApplyImpulse(_loc_15, _loc_16.body.GetWorldCenter());
            ZG.saveBox.bossKilled = 11;
            _universe.checkAchievement(AchievementItem.WINNER);
            ZG.playerGui.hideBossBar();
            ZG.sound(SoundManager.BOSS_DIE, this);
            _universe.objects.callAction(this.callbackDie, null, "boss");
            return;
        }// end function

        private function canAttack(param1:BasicObject) : Boolean
        {
            if (Amath.distance(param1.body.GetPosition().x, param1.body.GetPosition().y, _body.GetPosition().x, _body.GetPosition().y) <= 5)
            {
                return true;
            }
            return false;
        }// end function

        override public function addContact(param1:b2ContactPoint) : Boolean
        {
            var _loc_2:BasicObject = null;
            var _loc_3:EffectBlow = null;
            if (param1.shape1.IsSensor() || param1.shape2.IsSensor())
            {
                return false;
            }
            if (_contacts.indexOf(param1) == -1)
            {
                _contacts[_contacts.length] = param1;
                if (param1.shape1.GetBody().GetUserData() as BasicObject != this)
                {
                    _loc_2 = param1.shape1.GetBody().GetUserData() as BasicObject;
                }
                else if (param1.shape2.GetBody().GetUserData() as BasicObject != this)
                {
                    _loc_2 = param1.shape2.GetBody().GetUserData() as BasicObject;
                }
                _hitPoint = new b2Vec2(_body.GetPosition().x, _body.GetPosition().y);
                _hitForce = new b2Vec2(_body.GetLinearVelocity().x * 5, _body.GetLinearVelocity().y * 5);
                if (_loc_2 != null && _loc_2.body.GetPosition().y < _body.GetPosition().y - 0.5)
                {
                    switch(_loc_2.kind)
                    {
                        case Kind.BARREL:
                        case Kind.BARREL_EXPLOSION:
                        case Kind.BOX:
                        case Kind.WOOD_PLANK:
                        case Kind.CART:
                        case Kind.TRAILER:
                        case Kind.STONE:
                        {
                            if (_loc_2.body.GetLinearVelocity().y > 0.5)
                            {
                                this.hurt(_loc_2.body.GetLinearVelocity().y * 0.2);
                                if (_health <= 0)
                                {
                                    _universe.deads.add(this);
                                    _die = true;
                                }
                                ZG.sound(SoundManager.BOSS_COLLISION, this, true);
                                _loc_2.fatalDamage(_loc_2.body.GetPosition(), _loc_2.body.GetLinearVelocity());
                                _loc_3 = EffectBlow.get();
                                _loc_3.init(param1.position.x * Universe.DRAW_SCALE, param1.position.y * Universe.DRAW_SCALE);
                                return true;
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                return true;
            }
            return false;
        }// end function

        override protected function getObjectsAround(param1:uint, param2:int, param3:int = 10) : void
        {
            var _loc_6:b2Body = null;
            var _loc_7:BasicObject = null;
            var _loc_4:* = new b2AABB();
            _loc_4.lowerBound.Set(_body.GetWorldCenter().x - param3, _body.GetWorldCenter().y - param3);
            _loc_4.upperBound.Set(_body.GetWorldCenter().x + param3 * 2, _body.GetWorldCenter().y + param3 * 2);
            var _loc_5:Array = [];
            _universe.physics.Query(_loc_4, _loc_5, 100);
            var _loc_8:* = _loc_5.length;
            _visionList.length = 0;
            var _loc_9:int = 0;
            while (_loc_9 < _loc_8)
            {
                
                _loc_6 = (_loc_5[_loc_9] as b2Shape).GetBody();
                if (_loc_6.m_userData is BasicObject)
                {
                    _loc_7 = _loc_6.m_userData as BasicObject;
                    if (_loc_7.group == Kind.GROUP_PLAYER)
                    {
                        _visionList[_visionList.length] = {obj:_loc_7, priority:1001};
                    }
                    else
                    {
                    }
                    _visionList[_visionList.length] = {obj:_loc_7, priority:101};
                }
                _loc_9++;
            }
            _visionList.sortOn("priority", Array.DESCENDING | Array.NUMERIC);
            return;
        }// end function

        private function godMode(param1:Boolean) : void
        {
            this._headLeft.SetAsSensor(param1);
            this._headRight.SetAsSensor(param1);
            this._godModeInterval = param1 == true ? (60) : (0);
            return;
        }// end function

        private function onWalk() : Boolean
        {
            switch(this._dir)
            {
                case DIR_LEFT:
                {
                    if (_sprite.scaleX < 0)
                    {
                        _sprite.scaleX = 1;
                    }
                    this._wheelBody.SetAngularVelocity(-4);
                    break;
                }
                case DIR_RIGHT:
                {
                    if (_sprite.scaleX > 0)
                    {
                        _sprite.scaleX = -1;
                    }
                    this._wheelBody.SetAngularVelocity(4);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _universe.frameTime == this._delay ? (true) : (false);
        }// end function

        override public function bulletCollision(param1:Bullet, param2:b2Vec2) : void
        {
            if (this._godModeInterval > 0)
            {
                return;
            }
            if (!_die)
            {
                this.hurt(param1.damage * 0.6);
                if (_health <= 0)
                {
                    _hitPoint = new b2Vec2(param2.x, param2.y);
                    _hitForce = new b2Vec2(param1.body.GetLinearVelocity().x, param1.body.GetLinearVelocity().y);
                    _universe.deads.add(this);
                    _die = true;
                }
            }
            return;
        }// end function

        override public function hide() : void
        {
            if (_isVisible)
            {
                _sprite.stop();
                _universe.remove(this, _layer);
                _isVisible = false;
            }
            return;
        }// end function

        public function get isAlert() : Boolean
        {
            return this._isAlert;
        }// end function

        public function get alertTime() : int
        {
            return this._alertTime;
        }// end function

        private function onJumpInit() : Boolean
        {
            this._state = STATE_ATTACK;
            this._joint.EnableLimit(true);
            this._jumpInterval = 0;
            return true;
        }// end function

        private function onJumpAnim() : Boolean
        {
            switchAnim(Art.BOSS_JUMP, false);
            return true;
        }// end function

        private function onFireInit() : Boolean
        {
            this._state = STATE_ATTACK;
            this._joint.EnableLimit(true);
            if (this._targetToFire != null)
            {
                _sprite.scaleX = this._targetToFire.body.GetPosition().x < _body.GetPosition().x ? (DIR_LEFT) : (DIR_RIGHT);
            }
            this.godMode(true);
            this._fireInterval = 0;
            return true;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _sprite.stop();
                this._wheel.free();
                _universe.physics.DestroyBody(_body);
                if (this._headLeft != null)
                {
                    this._headLeft.free();
                }
                if (this._headRight != null)
                {
                    this._headRight.free();
                }
                this._schedule.reset();
                super.free();
            }
            return;
        }// end function

        private function onFireAnim() : Boolean
        {
            switchAnim(Art.BOSS_FIRE, false);
            return true;
        }// end function

        private function hitToHead(event:BasicObjectEvent) : void
        {
            if (this._godModeInterval > 0)
            {
                return;
            }
            if (!_die)
            {
                this.hurt(event.bulletDamage);
                if (_health <= 0)
                {
                    this._headLeft.onDie = this.saveForces;
                    _universe.deads.add(this._headLeft);
                    _universe.deads.add(this._headRight);
                    _universe.deads.add(this);
                    this._headLeft = null;
                    this._headRight = null;
                    _die = true;
                }
            }
            return;
        }// end function

        override public function process() : void
        {
            _position.x = this._wheelBody.GetPosition().x * Universe.DRAW_SCALE;
            _position.y = this._wheelBody.GetPosition().y * Universe.DRAW_SCALE - 45;
            var _loc_1:String = this;
            var _loc_2:* = this._fireInterval + 1;
            _loc_1._fireInterval = _loc_2;
            var _loc_1:String = this;
            var _loc_2:* = this._jumpInterval + 1;
            _loc_1._jumpInterval = _loc_2;
            if (this._godModeInterval != 0)
            {
                var _loc_1:String = this;
                var _loc_2:* = this._godModeInterval - 1;
                _loc_1._godModeInterval = _loc_2;
                if (this._godModeInterval == 0)
                {
                    this._oldScale = 0;
                    this.godMode(false);
                }
            }
            if (this._oldScale != _sprite.scaleX)
            {
                this._oldScale = _sprite.scaleX;
                if (this._oldScale == DIR_LEFT)
                {
                    this._headLeft.SetAsSensor(false);
                    this._headRight.SetAsSensor(true);
                }
                else if (this._oldScale == DIR_RIGHT)
                {
                    this._headLeft.SetAsSensor(true);
                    this._headRight.SetAsSensor(false);
                }
            }
            if (_universe.frameTime - this._thinkTime > THINK_INTERVAL)
            {
                this.think();
                this._thinkTime = _universe.frameTime;
            }
            if (this._schedule)
            {
                this._schedule.process();
            }
            renderVision();
            return;
        }// end function

        private function onWalkInit() : Boolean
        {
            this._state = STATE_WALK;
            this._delay = _universe.frameTime + Amath.random(150, 200);
            this._joint.EnableLimit(false);
            return true;
        }// end function

        private function onWalkAnim() : Boolean
        {
            switchAnim(Art.BOSS_WALK);
            return true;
        }// end function

        override public function get damage() : Number
        {
            return 10;
        }// end function

        override public function die() : void
        {
            if (!_isDead)
            {
                this.makeDeadBody(_position.x, _position.y);
                this.free();
                _isDead = true;
            }
            return;
        }// end function

        override public function render() : void
        {
            visibleCulling();
            if (_isVisible)
            {
                x = _position.x;
                y = _position.y;
            }
            return;
        }// end function

        public function get alertId() : uint
        {
            return 0;
        }// end function

        private function initPhysicBody(param1:Number, param2:Number) : void
        {
            var _loc_6:b2RevoluteJointDef = null;
            var _loc_3:* = new b2BodyDef();
            var _loc_4:* = new b2PolygonDef();
            _loc_4.density = 0.1;
            _loc_4.friction = 0.01;
            _loc_4.restitution = 0.1;
            _loc_4.filter.categoryBits = 2;
            _loc_4.filter.maskBits = 4;
            _loc_4.filter.groupIndex = 2;
            _loc_4.SetAsBox(32 / Universe.DRAW_SCALE, 45 / Universe.DRAW_SCALE);
            _loc_3.position.Set(param1 / Universe.DRAW_SCALE, (param2 - 2) / Universe.DRAW_SCALE);
            _loc_3.fixedRotation = true;
            _loc_3.userData = this;
            _body = _universe.physics.CreateBody(_loc_3);
            _body.CreateShape(_loc_4);
            this._headLeft = new TriggerPart();
            this._headLeft.partOf = this;
            this._headLeft.group = Kind.GROUP_BOSS;
            this._headLeft.kind = Kind.ENEMY_BOSS;
            this._headLeft.allowDeath = false;
            this._headLeft.setSize(30, 30);
            this._headLeft.init(param1 - 40, param2 - 60);
            this._headLeft.addEventListener(BasicObjectEvent.BULLET_COLLISION, this.hitToHead);
            _loc_6 = new b2RevoluteJointDef();
            _loc_6.Initialize(this._headLeft.body, _body, this._headLeft.body.GetWorldCenter());
            _loc_6.enableLimit = true;
            this._headRight = new TriggerPart();
            this._headRight.partOf = this;
            this._headRight.group = Kind.GROUP_BOSS;
            this._headRight.kind = Kind.ENEMY_BOSS;
            this._headRight.allowDeath = false;
            this._headRight.setSize(30, 30);
            this._headRight.init(param1 + 40, param2 - 60);
            this._headRight.addEventListener(BasicObjectEvent.BULLET_COLLISION, this.hitToHead);
            _loc_6 = new b2RevoluteJointDef();
            _loc_6.Initialize(this._headRight.body, _body, this._headRight.body.GetWorldCenter());
            _loc_6.enableLimit = true;
            _loc_4.isSensor = true;
            var _loc_5:* = new b2Vec2();
            _loc_5.Set(0, -1);
            _loc_4.SetAsOrientedBox(80 / Universe.DRAW_SCALE, 80 / Universe.DRAW_SCALE, _loc_5, 0);
            _body.CreateShape(_loc_4);
            _body.SetMassFromShapes();
            this._wheel.variety = EnemyWheel.BOSS;
            this._wheel.init(param1, param2 + 40);
            this._wheel.parentObj = this;
            this._wheelBody = this._wheel.body;
            this._wheel.group = this.group;
            _loc_6 = new b2RevoluteJointDef();
            _loc_6.Initialize(this._wheelBody, _body, this._wheelBody.GetWorldCenter());
            this._joint = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            var _loc_7:* = this._wheelBody.GetPosition().x * Universe.DRAW_SCALE;
            this.x = this._wheelBody.GetPosition().x * Universe.DRAW_SCALE;
            _position.x = _loc_7;
            var _loc_7:* = this._wheelBody.GetPosition().y * Universe.DRAW_SCALE - 20;
            this.y = this._wheelBody.GetPosition().y * Universe.DRAW_SCALE - 20;
            _position.y = _loc_7;
            return;
        }// end function

        private function onJump() : Boolean
        {
            var _loc_1:EffectDust = null;
            if (_sprite.currentFrame == 29)
            {
                _universe.objects.callAction(this.callbackJump, null, "boss");
                _loc_1 = EffectDust.get();
                _loc_1.init(_position.x - 30, _position.y + 80);
                _loc_1 = EffectDust.get();
                _loc_1.init(_position.x + 30, _position.y + 80, 0, -1);
                _universe.quake(3);
                ZG.sound(SoundManager.BOSS_JUMP, this);
            }
            return _sprite.currentFrame == _sprite.totalFrames ? (true) : (false);
        }// end function

        private function onFire() : Boolean
        {
            var _loc_1:Number = NaN;
            var _loc_2:Fireball = null;
            if (_sprite.currentFrame == 16)
            {
                _loc_1 = Amath.getAngle(_body.GetPosition().x, _body.GetPosition().y, this._targetToFire.body.GetPosition().x, this._targetToFire.body.GetPosition().y);
                this._fireImpulse.asSpeed(2, Amath.toRadians(Amath.toDegrees(_loc_1) + 15 * _sprite.scaleX));
                _loc_2 = new Fireball();
                _loc_2.init(_position.x - 45 * _sprite.scaleX, _position.y - 19);
                _loc_2.body.ApplyImpulse(new b2Vec2(this._fireImpulse.x, this._fireImpulse.y), _loc_2.body.GetWorldCenter());
                ZG.sound(SoundManager.BOSS_FIRE, this);
            }
            return _sprite.currentFrame == _sprite.totalFrames ? (true) : (false);
        }// end function

        private function onAttackInit() : Boolean
        {
            this._state = STATE_ATTACK;
            this._joint.EnableLimit(true);
            if (this._targetToAttack != null)
            {
                _sprite.scaleX = this._targetToAttack.body.GetPosition().x < _body.GetPosition().x ? (DIR_LEFT) : (DIR_RIGHT);
            }
            return true;
        }// end function

        private function onAttackAnim() : Boolean
        {
            switchAnim(Art.BOSS_ATTACK, false);
            return true;
        }// end function

        private function selectNewSchedule() : void
        {
            switch(this._state)
            {
                case STATE_STAY:
                {
                    if (this._conditions.contains(CONDITION_CAN_ATTACK))
                    {
                        this.setSchedule(SCHEDULE_ATTACK);
                    }
                    else if (this._conditions.contains(CONDITION_CAN_FIRE))
                    {
                        this.setSchedule(SCHEDULE_FIRE);
                    }
                    else if (this._conditions.contains(CONDITION_SEE_ENEMY) && !this._conditions.contains(CONDITION_OBSTACLE))
                    {
                        this.setSchedule(SCHEDULE_WALK);
                    }
                    else if (this._conditions.contains(CONDITION_SEE_ENEMY) && this._conditions.contains(CONDITION_OBSTACLE) && this._conditions.contains(CONDITION_CAN_BREAK))
                    {
                        this.setSchedule(SCHEDULE_ATTACK);
                    }
                    else if (this._conditions.contains(CONDITION_OBSTACLE))
                    {
                        if (!this._reflected)
                        {
                            this._dir = this._dir * -1;
                        }
                        this.setSchedule(SCHEDULE_STAY);
                    }
                    else if (this._conditions.contains(CONDITION_CAN_JUMP))
                    {
                        this.setSchedule(SCHEDULE_JUMP);
                    }
                    else if (this._conditions.contains(CONDITION_WALK))
                    {
                        this.setSchedule(SCHEDULE_WALK);
                    }
                    break;
                }
                case STATE_WALK:
                {
                    if (this._conditions.contains(CONDITION_CAN_ATTACK))
                    {
                        this.setSchedule(SCHEDULE_ATTACK);
                    }
                    else if (this._conditions.contains(CONDITION_CAN_FIRE))
                    {
                        this.setSchedule(SCHEDULE_FIRE);
                    }
                    else if (this._conditions.contains(CONDITION_SEE_ENEMY) && !this._conditions.contains(CONDITION_OBSTACLE))
                    {
                        this.setSchedule(SCHEDULE_WALK);
                    }
                    else if (this._conditions.contains(CONDITION_SEE_ENEMY) && this._conditions.contains(CONDITION_OBSTACLE) && this._conditions.contains(CONDITION_CAN_BREAK))
                    {
                        this.setSchedule(SCHEDULE_ATTACK);
                    }
                    else if (this._conditions.contains(CONDITION_CAN_JUMP))
                    {
                        this.setSchedule(SCHEDULE_JUMP);
                    }
                    else if (this._conditions.contains(CONDITION_OBSTACLE) || this._conditions.contains(CONDITION_STAY))
                    {
                        if (!this._reflected)
                        {
                            this._dir = this._dir * -1;
                        }
                        this.setSchedule(SCHEDULE_STAY);
                    }
                    break;
                }
                case STATE_ATTACK:
                {
                    if (this._conditions.contains(CONDITION_CAN_ATTACK))
                    {
                        this.setSchedule(SCHEDULE_ATTACK);
                    }
                    else if (this._conditions.contains(CONDITION_CAN_FIRE))
                    {
                        this.setSchedule(SCHEDULE_FIRE);
                    }
                    else if (this._conditions.contains(CONDITION_SEE_ENEMY) && !this._conditions.contains(CONDITION_OBSTACLE))
                    {
                        this.setSchedule(SCHEDULE_WALK);
                    }
                    else if (this._conditions.contains(CONDITION_SEE_ENEMY) && this._conditions.contains(CONDITION_OBSTACLE) && this._conditions.contains(CONDITION_CAN_BREAK))
                    {
                        this.setSchedule(SCHEDULE_ATTACK);
                    }
                    else if (this._conditions.contains(CONDITION_OBSTACLE) || this._conditions.contains(CONDITION_STAY))
                    {
                        if (!this._reflected)
                        {
                            this._dir = this._dir * -1;
                        }
                        this.setSchedule(SCHEDULE_STAY);
                    }
                    else if (this._conditions.contains(CONDITION_CAN_JUMP))
                    {
                        this.setSchedule(SCHEDULE_JUMP);
                    }
                    else if (this._conditions.contains(CONDITION_WALK))
                    {
                        this.setSchedule(SCHEDULE_WALK);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            this._reflected = false;
            return;
        }// end function

        private function sense() : void
        {
            var _loc_1:b2Vec2 = null;
            var _loc_4:BasicObject = null;
            var _loc_2:* = _senseContacts.length;
            var _loc_3:uint = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = _senseContacts[_loc_3] as BasicObject;
                if (_loc_4.body == null)
                {
                }
                else
                {
                    _loc_1 = _loc_4.body.GetPosition();
                    if (this._dir == DIR_LEFT && _loc_1.x < _body.GetPosition().x || this._dir == DIR_RIGHT && _loc_1.x > _body.GetPosition().x)
                    {
                        if (this.isEnemyUnit(_loc_4.group) && this.canAttack(_loc_4))
                        {
                            this._conditions.setValue(CONDITION_CAN_ATTACK);
                            this._targetToAttack = _loc_4;
                        }
                        if (_loc_4.group == Kind.GROUP_BREAKABLE && this.canAttack(_loc_4))
                        {
                            this._conditions.setValue(CONDITION_CAN_BREAK);
                            this._targetToAttack = _loc_4;
                        }
                        this._conditions.setValue(CONDITION_OBSTACLE);
                    }
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        private function saveForces(param1:b2Vec2, param2:b2Vec2) : void
        {
            _hitPoint = new b2Vec2(param2.x, param2.y);
            _hitForce = new b2Vec2(param1.x, param1.y);
            return;
        }// end function

        private function onStay() : Boolean
        {
            var _loc_1:* = _body.GetLinearVelocity();
            if (_loc_1.x != 0)
            {
                _loc_1.x = 0;
                _body.SetLinearVelocity(_loc_1);
                this._wheelBody.SetAngularVelocity(0);
            }
            return _universe.frameTime == this._delay ? (true) : (false);
        }// end function

        override public function explode(param1:BasicObject, param2:b2Vec2, param3:b2Vec2) : Boolean
        {
            var _loc_4:Number = NaN;
            if (this._godModeInterval > 0 || param1 is Fireball)
            {
                return false;
            }
            if (!_die)
            {
                _loc_4 = Amath.distance(_body.GetPosition().x, _body.GetPosition().y, param1.body.GetPosition().x, param1.body.GetPosition().y);
                this.hurt(param1.damage / _loc_4);
                if (_health <= 0)
                {
                    _health = 0;
                    _hitPoint = new b2Vec2(param2.x, param2.y);
                    _hitForce = new b2Vec2(param3.x * 20, param3.y * 20);
                    this.die();
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

        override public function removeSensorContact(param1:BasicObject) : Boolean
        {
            if (super.removeSensorContact(param1))
            {
                if (this._targetToAttack == param1)
                {
                    this._targetToAttack = null;
                }
                return true;
            }
            return false;
        }// end function

        private function vision() : void
        {
            var _loc_1:BasicObject = null;
            var _loc_2:BasicObject = null;
            var _loc_4:IEnemyObject = null;
            _raycastList.length = 0;
            var _loc_3:* = new b2Vec2();
            var _loc_5:* = _visionList.length;
            var _loc_6:int = 0;
            var _loc_7:Number = 0;
            var _loc_8:uint = 0;
            while (_loc_8 < _loc_5)
            {
                
                _loc_1 = _visionList[_loc_8].obj;
                _loc_3.x = _loc_1.body.GetPosition().x;
                _loc_3.y = _loc_1.body.GetPosition().y;
                if (this.isEnemyUnit(_loc_1.group))
                {
                    _loc_7 = _loc_3.x < _body.GetPosition().x ? (-2) : (2);
                    _loc_2 = seeToPoint(_loc_3, _loc_7, 1.5);
                    if (_loc_2 != null)
                    {
                        addRaycastPoint(_body.GetPosition(), _loc_2.body.GetPosition(), _loc_7, 1.5);
                        if (this.isEnemyUnit(_loc_2.group))
                        {
                            this._dir = _loc_1.body.GetPosition().x < _body.GetPosition().x ? (DIR_LEFT) : (DIR_RIGHT);
                            this._conditions.setValue(CONDITION_SEE_ENEMY);
                            if (this._fireInterval >= 150)
                            {
                                this._targetToFire = _loc_1;
                                this._conditions.setValue(CONDITION_CAN_FIRE);
                            }
                            this._alertTime = _universe.frameTime;
                            this._isAlert = true;
                            break;
                        }
                    }
                }
                _loc_8 = _loc_8 + 1;
            }
            if (this._isAlert && _universe.frameTime - this._alertTime < ALERT_INTERVAL)
            {
                if (!this._conditions.contains(CONDITION_SEE_ENEMY))
                {
                    this._conditions.setValue(CONDITION_SEE_ENEMY);
                }
            }
            else if (this._isAlert)
            {
                this._isAlert = false;
            }
            return;
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

        override public function show() : void
        {
            if (!_isVisible)
            {
                _sprite.play();
                _universe.add(this, _layer);
                _isVisible = true;
            }
            return;
        }// end function

    }
}
