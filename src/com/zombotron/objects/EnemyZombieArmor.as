package com.zombotron.objects
{
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
    import com.zombotron.levels.*;

    public class EnemyZombieArmor extends BasicEnemy implements IEnemyObject
    {
        private var _delay:int = 80;
        private var _joint:b2RevoluteJoint;
        private var _helmet:TriggerPart;
        private var _state:int = 0;
        private var _isAlert:Boolean = false;
        private var _haveHelmet:Boolean;
        private var _reflected:Boolean = false;
        private var _wheelBody:b2Body;
        private var _ragdoll:Ragdoll;
        public var upperLimit:Number = 0;
        public var lowerLimit:Number = 0;
        private var _schedules:Repository;
        private var _armor:Number;
        private var _alertTime:int = 0;
        private var _fadeEffect:Boolean = false;
        private var _dir:int = 1;
        private var _conditions:Conditions;
        private var _alertId:int = 0;
        private var _wheel:EnemyWheel;
        private var _thinkTime:int = 0;
        private var _color:int = 1;
        private var _targetToAttack:BasicObject;
        private var _schedule:Schedule = null;
        public var enableLimit:Boolean = false;
        private static const SCHEDULE_STAY:String = "stay";
        public static const RAGDOLL_NAME:String = "Zombie";
        private static const CONDITION_WALK:int = 1;
        private static const THINK_INTERVAL:int = 4;
        private static const DIR_LEFT:int = 1;
        private static const CONDITION_STAY:int = 0;
        private static const CONDITION_SEE_ENEMY:int = 4;
        private static const ARMOR:Number = 1;
        private static const DIR_RIGHT:int = -1;
        private static const WALK_SPEED:int = 5;
        private static const COLOR_ORANGE:int = 3;
        private static const STRENGTH_OF_JOINT:int = 50;
        public static const CACHE_NAME:String = "EnemyZombieArmor";
        private static const VISION_OFFSET:Number = 0.5;
        private static const CONDITION_CAN_BREAK:int = 5;
        private static const CONDITION_OBSTACLE:int = 3;
        private static const COLOR_BLUE:int = 1;
        private static const STATE_WALK:int = 1;
        private static const HEALTH:Number = 1;
        private static const STATE_ATTACK:int = 2;
        private static const COLOR_GREEN:int = 2;
        private static const ALERT_INTERVAL:int = 300;
        private static const STATE_STAY:int = 0;
        private static const DAMAGE:Number = 0.55;
        private static const SCHEDULE_ATTACK:String = "attack";
        private static const SCHEDULE_WALK:String = "walk";
        private static const CONDITION_CAN_ATTACK:int = 2;

        public function EnemyZombieArmor()
        {
            group = Kind.GROUP_ZOMBIE;
            _kind = Kind.ENEMY_ZOMBIE_ARMOR;
            _allowContacts = true;
            _allowSensing = true;
            this._ragdoll = _universe.ragdollStorage.getValue(RAGDOLL_NAME);
            this._wheel = new EnemyWheel();
            this._conditions = new Conditions();
            this._schedules = new Repository();
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
            return;
        }// end function

        private function makeHelmet(param1:b2Vec2, param2:b2Vec2) : void
        {
            var _loc_3:* = this._ragdoll.getBody("helmet");
            var _loc_4:* = ZombiePart.get();
            _loc_4.variety = ZombiePart.HELMET;
            _loc_4.color = this._color;
            _loc_4.setSize(_loc_3.width, _loc_3.height);
            _loc_4.init(this.x + _loc_3.x, this.y + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            param1.x = param1.x / 60;
            param1.y = param1.y / 60;
            _loc_4.body.ApplyImpulse(param1, param2);
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

        private function onStayAnim() : Boolean
        {
            var _loc_1:String = null;
            switch(this._color)
            {
                case COLOR_GREEN:
                {
                    break;
                }
                case COLOR_ORANGE:
                {
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            switch(this._color)
            {
                case COLOR_GREEN:
                {
                    break;
                }
                case COLOR_ORANGE:
                {
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            switchAnim(_loc_1);
            return true;
        }// end function

        private function generateConditions() : void
        {
            this._conditions.clear();
            getObjectsAround(group, this._alertId);
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
            _senseContacts.length = 0;
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                if (this._haveHelmet)
                {
                    this._helmet.free();
                }
                this._wheel.free();
                _universe.physics.DestroyBody(_body);
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                this._fadeEffect = false;
                this._schedule.reset();
                super.free();
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:String = null;
            this._color = Amath.random(1, 3);
            switch(this._color)
            {
                case COLOR_GREEN:
                {
                    _loc_5 = Art.ZOMBIE_ARMOR_STAND_GREEN;
                    break;
                }
                case COLOR_ORANGE:
                {
                    _loc_5 = Art.ZOMBIE_ARMOR_STAND_ORANGE;
                    break;
                }
                default:
                {
                    _loc_5 = Art.ZOMBIE_ARMOR_STAND_BLUE;
                    break;
                    break;
                }
            }
            _curAnim = "";
            switchAnim(_loc_5);
            this.initPhysicBody(param1, param2);
            _visionList.length = 0;
            this._haveHelmet = true;
            _health = ZG.hardcoreMode ? (HEALTH) : (HEALTH * 0.66);
            _damage = ZG.hardcoreMode ? (DAMAGE) : (DAMAGE * 0.66);
            this._armor = ZG.hardcoreMode ? (ARMOR) : (ARMOR * 0.66);
            reset();
            this._isAlert = false;
            this._alertTime = 0;
            this._alertId = 0;
            this.show();
            _sprite.alpha = this._fadeEffect ? (0) : (1);
            this.setSchedule(SCHEDULE_STAY);
            this._thinkTime = _universe.frameTime;
            return;
        }// end function

        private function onWalkAnim() : Boolean
        {
            var _loc_1:String = null;
            switch(this._color)
            {
                case COLOR_GREEN:
                {
                    break;
                }
                case COLOR_ORANGE:
                {
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            switch(this._color)
            {
                case COLOR_GREEN:
                {
                    break;
                }
                case COLOR_ORANGE:
                {
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            switchAnim(_loc_1);
            return true;
        }// end function

        private function setSchedule(param1:String) : void
        {
            this._schedule = this._schedules.getValue(param1);
            return;
        }// end function

        private function onStayInit() : Boolean
        {
            this._state = STATE_STAY;
            this._delay = this._fadeEffect ? (0) : (_universe.frameTime + Amath.random(50, 100));
            this._joint.EnableLimit(true);
            return true;
        }// end function

        private function isEnemyUnit(param1:uint) : Boolean
        {
            if (param1 == Kind.GROUP_PLAYER || param1 == Kind.GROUP_ROBOT || param1 == Kind.GROUP_SKELETON)
            {
                return true;
            }
            return false;
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
                _loc_1 = Math.abs(_body.GetPosition().y - this._targetToAttack.body.GetPosition().y) > 1 ? (true) : (false);
                if (!_loc_1 && _sprite.currentFrame == 19 || _loc_1 && _sprite.currentFrame == 15)
                {
                    _loc_2 = new b2Vec2(_body.GetPosition().x, _body.GetPosition().y);
                    if (_loc_1)
                    {
                        _loc_2.y = _loc_2.y - 0.8;
                    }
                    else
                    {
                        _loc_2.x = _loc_2.x + (_sprite.scaleX == DIR_LEFT ? (-1) : (1));
                    }
                    if (Amath.distance(this._targetToAttack.body.GetPosition().x, this._targetToAttack.body.GetPosition().y, _loc_2.x, _loc_2.y) < 2)
                    {
                        _loc_3 = new b2Vec2(1, -1);
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
                        ZG.sound(SoundManager.ZOMBIE_ATTACK, this);
                    }
                }
            }
            return _sprite.currentFrame == _sprite.totalFrames ? (true) : (false);
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
            _loc_4.SetAsBox(12 / Universe.DRAW_SCALE, 22 / Universe.DRAW_SCALE);
            _loc_3.position.Set(param1 / Universe.DRAW_SCALE, (param2 - 2) / Universe.DRAW_SCALE);
            _loc_3.fixedRotation = true;
            _loc_3.userData = this;
            _body = _universe.physics.CreateBody(_loc_3);
            _body.CreateShape(_loc_4);
            this._helmet = new TriggerPart();
            this._helmet.partOf = this;
            this._helmet.group = Kind.GROUP_ZOMBIE;
            this._helmet.kind = Kind.HELMET;
            this._helmet.allowDeath = false;
            this._helmet.setSize(30, 26);
            this._helmet.init(param1, param2 - 15);
            this._helmet.addEventListener(BasicObjectEvent.BULLET_COLLISION, this.hitToArmor);
            _loc_6 = new b2RevoluteJointDef();
            _loc_6.Initialize(this._helmet.body, _body, this._helmet.body.GetWorldCenter());
            _loc_6.enableLimit = true;
            var _loc_5:* = new b2Vec2(0, -0.3);
            _loc_4.isSensor = true;
            _loc_4.SetAsOrientedBox(30 / Universe.DRAW_SCALE, 30 / Universe.DRAW_SCALE, _loc_5, 0);
            _body.CreateShape(_loc_4);
            _body.SetMassFromShapes();
            this._wheel.init(param1, param2 + 20);
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

        public function get alertId() : uint
        {
            return this._alertId;
        }// end function

        private function makeDeadBody(param1:Number, param2:Number) : void
        {
            var _loc_7:b2RevoluteJoint = null;
            var _loc_17:ZombiePart = null;
            var _loc_18:CollectableItem = null;
            var _loc_3:* = this._ragdoll.getBody("body");
            var _loc_4:* = ZombiePart.get();
            _loc_4.color = this._color;
            _loc_4.variety = ZombiePart.BODY;
            _loc_4.setSize(_loc_3.width, _loc_3.height);
            _loc_4.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getBody("head");
            var _loc_5:* = ZombiePart.get();
            _loc_5.color = this._color;
            _loc_5.variety = ZombiePart.HEAD;
            _loc_5.setSize(_loc_3.width, _loc_3.height);
            _loc_5.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            var _loc_6:* = new b2RevoluteJointDef();
            var _loc_8:* = new b2Vec2();
            var _loc_9:* = new b2Vec2(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_3 = this._ragdoll.getJoint("jointHead");
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_5.body, _loc_4.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            _loc_3 = this._ragdoll.getBody("rightHand");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_10:* = ZombiePart.get();
            _loc_10.color = this._color;
            _loc_10.variety = ZombiePart.HAND_RIGHT;
            _loc_10.setSize(_loc_3.width, _loc_3.height);
            _loc_10.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getJoint("jointRightHand");
            _loc_3.scaleX = _sprite.scaleX;
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_10.body, _loc_4.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            _loc_3 = this._ragdoll.getBody("leftHand");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_11:* = ZombiePart.get();
            _loc_11.color = this._color;
            _loc_11.variety = ZombiePart.HAND_LEFT;
            _loc_11.setSize(_loc_3.width, _loc_3.height);
            _loc_11.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getJoint("jointLeftHand");
            _loc_3.scaleX = _sprite.scaleX;
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_11.body, _loc_4.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            _loc_3 = this._ragdoll.getBody("rightLeg");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_12:* = ZombiePart.get();
            _loc_12.color = this._color;
            _loc_12.variety = ZombiePart.LEG_RIGHT;
            _loc_12.setSize(_loc_3.width, _loc_3.height);
            _loc_12.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getJoint("jointRightLeg");
            _loc_3.scaleX = _sprite.scaleX;
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_12.body, _loc_4.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            _loc_3 = this._ragdoll.getBody("leftLeg");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_13:* = ZombiePart.get();
            _loc_13.color = this._color;
            _loc_13.variety = ZombiePart.LEG_LEFT;
            _loc_13.setSize(_loc_3.width, _loc_3.height);
            _loc_13.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getJoint("jointLeftLeg");
            _loc_3.scaleX = _sprite.scaleX;
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_13.body, _loc_4.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            if (this._haveHelmet)
            {
                _loc_3 = this._ragdoll.getBody("helmet");
                _loc_17 = ZombiePart.get();
                _loc_17.variety = ZombiePart.HELMET;
                _loc_17.color = this._color;
                _loc_17.setSize(_loc_3.width, _loc_3.height);
                _loc_17.init(this.x + _loc_3.x, this.y + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            }
            if (this._haveHelmet)
            {
                _loc_3 = this._ragdoll.getJoint("jointHelmet");
                _loc_3.scaleX = _sprite.scaleX;
                _loc_3.addOffset(_loc_9, _loc_8);
                _loc_3.setLimits(_loc_6);
                _loc_6.Initialize(_loc_17.body, _loc_5.body, _loc_8);
                _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
                _universe.joints.add(_loc_7, 10);
            }
            _loc_10.render();
            _loc_4.render();
            _loc_12.render();
            _loc_13.render();
            _loc_5.render();
            _loc_11.render();
            _loc_4.body.ApplyImpulse(new b2Vec2(_hitForce.x / 20, _hitForce.y / 20), _hitPoint);
            _loc_5.body.SetAngularVelocity(0);
            var _loc_14:* = new b2Vec2(Amath.random(0, 3) / 20, (Amath.random(-3, -2) - Math.random()) / 10);
            _loc_14.x = _sprite.scaleX == DIR_LEFT ? (-_loc_14.x) : (_loc_14.x);
            var _loc_15:* = Coin.get();
            _loc_15.init(param1, param2);
            _loc_15.body.ApplyImpulse(_loc_14, _loc_15.body.GetWorldCenter());
            _universe.motiKillEnemy();
            ZG.saveBox.statisticKill(this.group);
            _universe.checkAchievement(0);
            ZG.sound(SoundManager.ZOMBIE_DIE, this);
            var _loc_16:* = _universe.player.weaponAmmo();
            if (_loc_16 != ShopBox.ITEM_UNDEFINED)
            {
                _loc_14.x = Amath.random(0, 3) / 20;
                _loc_14.y = (Amath.random(-3, -2) - Math.random()) / 10;
                _loc_18 = _universe.makeCollectableItem(_loc_16, 1, param1, param2);
                _loc_18.body.ApplyImpulse(_loc_14, _loc_18.body.GetWorldCenter());
            }
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
                        if (Math.abs(_body.GetPosition().y - _loc_1.y) < 1)
                        {
                            this._conditions.setValue(CONDITION_OBSTACLE);
                        }
                    }
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
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
                    break;
                }
                case STATE_ATTACK:
                {
                    if (this._conditions.contains(CONDITION_CAN_ATTACK))
                    {
                        this.setSchedule(SCHEDULE_ATTACK);
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

        private function canAttack(param1:BasicObject) : Boolean
        {
            if (Amath.distance(param1.body.GetPosition().x, param1.body.GetPosition().y, _body.GetPosition().x, _body.GetPosition().y) <= 3)
            {
                return true;
            }
            return false;
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

        public function fadeEff() : void
        {
            this._fadeEffect = true;
            return;
        }// end function

        override public function bulletCollision(param1:Bullet, param2:b2Vec2) : void
        {
            if (!_die)
            {
                _health = _health - param1.damage;
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

        public function get isAlert() : Boolean
        {
            return this._isAlert;
        }// end function

        private function onAttackAnim() : Boolean
        {
            var _loc_1:String = null;
            switch(this._color)
            {
                case COLOR_GREEN:
                {
                    break;
                }
                case COLOR_ORANGE:
                {
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            switch(this._color)
            {
                case COLOR_GREEN:
                {
                    break;
                }
                case COLOR_ORANGE:
                {
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            switchAnim(_loc_1, false);
            return true;
        }// end function

        override public function explode(param1:BasicObject, param2:b2Vec2, param3:b2Vec2) : Boolean
        {
            var _loc_4:Number = NaN;
            var _loc_5:EffectCollectableItem = null;
            if (!_die)
            {
                _loc_4 = Amath.distance(_body.GetPosition().x, _body.GetPosition().y, param1.body.GetPosition().x, param1.body.GetPosition().y);
                _health = _health - param1.damage / _loc_4;
                if (_health <= 0)
                {
                    _health = 0;
                    _hitPoint = new b2Vec2(param2.x, param2.y);
                    _hitForce = new b2Vec2(param3.x * 20, param3.y * 20);
                    this.die();
                    if (ZG.playerGui.isHaveMission(LevelBase.MISSION_BOOM))
                    {
                        _loc_5 = EffectCollectableItem.get();
                        _loc_5.variety = ShopBox.ITEM_SPIRIT_BOOM;
                        _loc_5.init(this.x, this.y, this.rotation);
                        _loc_5.angle = -45;
                    }
                    var _loc_6:* = ZG.saveBox;
                    var _loc_7:* = ZG.saveBox.explodedEnemies + 1;
                    _loc_6.explodedEnemies = _loc_7;
                    _universe.checkAchievement(AchievementItem.BOMBERMAN);
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

        override public function attacked(param1:b2Vec2, param2:b2Vec2, param3:Number = 1) : Boolean
        {
            var _loc_4:EffectBlow = null;
            var _loc_5:EffectBlood = null;
            var _loc_6:uint = 0;
            if (!_isFree)
            {
                _health = _health - param3;
                if (_health <= 0)
                {
                    _hitPoint = new b2Vec2(param1.x, param1.y);
                    _hitForce = new b2Vec2(param2.x * 20, param2.y * 20);
                    this.makeDeadBody(_position.x, _position.y);
                    this.free();
                }
                else
                {
                    _body.ApplyImpulse(param2, param1);
                }
                _loc_4 = EffectBlow.get();
                _loc_4.init(param1.x * Universe.DRAW_SCALE, param1.y * Universe.DRAW_SCALE);
                _loc_6 = 0;
                while (_loc_6 < 2)
                {
                    
                    _loc_5 = EffectBlood.get();
                    _loc_5.speed = new Avector(Amath.random(1, 5), Amath.random(-1, -5));
                    _loc_5.speed.x = _sprite.scaleX < 0 ? (_loc_5.speed.x * -1) : (_loc_5.speed.x);
                    _loc_5.init(param1.x * Universe.DRAW_SCALE, param1.y * Universe.DRAW_SCALE);
                    _loc_6 = _loc_6 + 1;
                }
            }
            return true;
        }// end function

        private function onWalk() : Boolean
        {
            switch(this._dir)
            {
                case DIR_LEFT:
                {
                    if (this.enableLimit && _position.x <= this.lowerLimit)
                    {
                        this._reflected = true;
                        this._dir = DIR_RIGHT;
                        return true;
                    }
                    if (_sprite.scaleX < 0)
                    {
                        _sprite.scaleX = 1;
                    }
                    this._wheelBody.SetAngularVelocity(-8);
                    break;
                }
                case DIR_RIGHT:
                {
                    if (this.enableLimit && _position.x >= this.upperLimit)
                    {
                        this._reflected = true;
                        this._dir = DIR_LEFT;
                        return true;
                    }
                    if (_sprite.scaleX > 0)
                    {
                        _sprite.scaleX = -1;
                    }
                    this._wheelBody.SetAngularVelocity(8);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _universe.frameTime == this._delay ? (true) : (false);
        }// end function

        public function get alertTime() : int
        {
            return this._alertTime;
        }// end function

        override public function process() : void
        {
            _position.x = this._wheelBody.GetPosition().x * Universe.DRAW_SCALE;
            _position.y = this._wheelBody.GetPosition().y * Universe.DRAW_SCALE - 20;
            if (this._fadeEffect && _sprite.alpha < 1)
            {
                _sprite.alpha = _sprite.alpha + 0.1;
                if (_sprite.alpha >= 1)
                {
                    _sprite.alpha = 1;
                    this._fadeEffect = false;
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

        private function hitToArmor(event:BasicObjectEvent) : void
        {
            var _loc_2:uint = 0;
            if (this._haveHelmet)
            {
                this._armor = this._armor - event.bulletDamage;
                if (this._armor <= 0)
                {
                    this._haveHelmet = false;
                    _loc_2 = _sprite.currentFrame;
                    switch(this._state)
                    {
                        case STATE_STAY:
                        {
                            this.onStayAnim();
                            break;
                        }
                        case STATE_WALK:
                        {
                            this.onWalkAnim();
                            break;
                        }
                        case STATE_ATTACK:
                        {
                            this.onAttackAnim();
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    _sprite.gotoAndPlay(_loc_2);
                    this._helmet.onDie = this.makeHelmet;
                    _universe.deads.add(this._helmet);
                }
            }
            return;
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
                    _loc_7 = _loc_3.x < _body.GetPosition().x ? (-VISION_OFFSET) : (VISION_OFFSET);
                    _loc_2 = seeToPoint(_loc_3, _loc_7);
                    if (_loc_2 != null)
                    {
                        addRaycastPoint(_body.GetPosition(), _loc_2.body.GetPosition(), _loc_7);
                        if (this.isEnemyUnit(_loc_2.group))
                        {
                            this._dir = _loc_1.body.GetPosition().x < _body.GetPosition().x ? (DIR_LEFT) : (DIR_RIGHT);
                            this._conditions.setValue(CONDITION_SEE_ENEMY);
                            this._alertTime = _universe.frameTime;
                            this._alertId = 1000 - distToUnit(_loc_2);
                            this._isAlert = true;
                            break;
                        }
                    }
                }
                else if (_loc_1.group == this.group)
                {
                    _loc_7 = _loc_3.x < _body.GetPosition().x ? (-VISION_OFFSET) : (VISION_OFFSET);
                    _loc_2 = seeToPoint(_loc_3, _loc_7);
                    if (_loc_2 != null)
                    {
                        addRaycastPoint(_body.GetPosition(), _loc_2.body.GetPosition(), _loc_7);
                        _loc_4 = _loc_2 as IEnemyObject;
                        if (_loc_2.group == this.group && _loc_4 != null && _loc_4.isAlert && _loc_4.alertId >= this._alertId)
                        {
                            this._dir = _loc_1.body.GetPosition().x < _body.GetPosition().x ? (DIR_LEFT) : (DIR_RIGHT);
                            this._conditions.setValue(CONDITION_SEE_ENEMY);
                            this._alertTime = _loc_4.alertTime;
                            this._alertId = _loc_4.alertId - distToUnit(_universe.player);
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
                    this._alertId = this._alertId - distToUnit(_universe.player);
                }
                this.enableLimit = false;
            }
            else if (this._isAlert || this._alertId < 0)
            {
                this._isAlert = false;
                this._alertId = 0;
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

        private function onWalkInit() : Boolean
        {
            this._state = STATE_WALK;
            this._delay = _universe.frameTime + Amath.random(50, 100);
            this._joint.EnableLimit(false);
            return true;
        }// end function

        public static function get() : EnemyZombieArmor
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EnemyZombieArmor;
        }// end function

    }
}
