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
    import com.zombotron.gui.*;
    import com.zombotron.helpers.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;

    public class EnemyZombieBomb extends BasicEnemy implements IEnemyObject
    {
        private var _delay:int = 80;
        private var _joint:b2RevoluteJoint;
        private var _state:int = 0;
        private var _isAlert:Boolean = false;
        private var _effBurn:EffectBurnTiny;
        private var _reflected:Boolean = false;
        private var _wheelBody:b2Body;
        private var _ragdoll:Ragdoll;
        private var _selfExplosion:Boolean;
        public var upperLimit:Number = 0;
        public var lowerLimit:Number = 0;
        private var _schedules:Repository;
        private var _alertTime:int = 0;
        private var _fadeEffect:Boolean = false;
        private var _dir:int = 1;
        private var _conditions:Conditions;
        private var _alertId:int = 0;
        private var _wheel:EnemyWheel;
        private var _thinkTime:int = 0;
        private var _color:int = 2;
        private var _targetToAttack:BasicObject;
        private var _schedule:Schedule = null;
        public var enableLimit:Boolean = false;
        private static const SCHEDULE_STAY:String = "stay";
        public static const RAGDOLL_NAME:String = "ZombieBomb";
        private static const CONDITION_WALK:int = 1;
        private static const THINK_INTERVAL:int = 4;
        private static const CONDITION_SEE_ENEMY:int = 4;
        private static const DIR_LEFT:int = 1;
        private static const EXPLOSION_POWER:int = 2;
        private static const CONDITION_STAY:int = 0;
        private static const COLOR_ORANGE:int = 3;
        private static const DIR_RIGHT:int = -1;
        private static const WALK_SPEED:int = 5;
        private static const STRENGTH_OF_JOINT:int = 50;
        public static const CACHE_NAME:String = "EnemyZombieBomb";
        private static const VISION_OFFSET:Number = 0.5;
        private static const CONDITION_CAN_BREAK:int = 5;
        private static const CONDITION_OBSTACLE:int = 3;
        private static const COLOR_BLUE:int = 1;
        private static const STATE_WALK:int = 1;
        private static const HEALTH:Number = 0.7;
        private static const STATE_ATTACK:int = 2;
        private static const COLOR_GREEN:int = 2;
        private static const ALERT_INTERVAL:int = 300;
        private static const STATE_STAY:int = 0;
        private static const SCHEDULE_ATTACK:String = "attack";
        private static const SCHEDULE_WALK:String = "walk";
        private static const EXPLOSION_DAMAGE:Number = 2;
        private static const CONDITION_CAN_ATTACK:int = 2;

        public function EnemyZombieBomb()
        {
            group = Kind.GROUP_ZOMBIE;
            _kind = Kind.ENEMY_ZOMBIE_BOMB;
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
            _loc_3.addFewTasks([this.onAttackInit]);
            this._schedules.setValue(SCHEDULE_ATTACK, _loc_3);
            return;
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

        private function onStayAnim() : Boolean
        {
            switch(this._color)
            {
                case COLOR_GREEN:
                {
                    switchAnim(Art.ZOMBIE_BOMB_STAND_GREEN);
                    break;
                }
                case COLOR_ORANGE:
                {
                    switchAnim(Art.ZOMBIE_BOMB_STAND_ORANGE);
                    break;
                }
                default:
                {
                    switchAnim(Art.ZOMBIE_BOMB_STAND_BLUE);
                    break;
                    break;
                }
            }
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
                this._wheel.free();
                _universe.physics.DestroyBody(_body);
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                this.enableLimit = false;
                this._fadeEffect = false;
                this._schedule.reset();
                super.free();
            }
            return;
        }// end function

        private function onStayInit() : Boolean
        {
            this._state = STATE_STAY;
            this._delay = this._fadeEffect ? (0) : (_universe.frameTime + Amath.random(50, 100));
            this._joint.EnableLimit(true);
            return true;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            this._color = Amath.random(1, 3);
            _curAnim = "";
            switch(this._color)
            {
                case COLOR_GREEN:
                {
                    switchAnim(Art.ZOMBIE_BOMB_STAND_GREEN);
                    break;
                }
                case COLOR_ORANGE:
                {
                    switchAnim(Art.ZOMBIE_BOMB_STAND_ORANGE);
                    break;
                }
                default:
                {
                    switchAnim(Art.ZOMBIE_BOMB_STAND_BLUE);
                    break;
                    break;
                }
            }
            this.initPhysicBody(param1, param2);
            this._effBurn = EffectBurnTiny.get();
            this._effBurn.setBody(_body, new Avector(0, -11));
            this._effBurn.init(0, 0);
            reset();
            _visionList.length = 0;
            _health = ZG.hardcoreMode ? (HEALTH) : (HEALTH * 0.66);
            this._isAlert = false;
            this._alertTime = 0;
            this._alertId = 0;
            this._selfExplosion = false;
            this.show();
            _sprite.alpha = this._fadeEffect ? (0) : (1);
            this._state = STATE_STAY;
            this.setSchedule(SCHEDULE_STAY);
            this._thinkTime = _universe.frameTime;
            return;
        }// end function

        private function onWalkAnim() : Boolean
        {
            switch(this._color)
            {
                case COLOR_GREEN:
                {
                    switchAnim(Art.ZOMBIE_BOMB_WALK_GREEN);
                    break;
                }
                case COLOR_ORANGE:
                {
                    switchAnim(Art.ZOMBIE_BOMB_WALK_ORANGE);
                    break;
                }
                default:
                {
                    switchAnim(Art.ZOMBIE_BOMB_WALK_BLUE);
                    break;
                    break;
                }
            }
            return true;
        }// end function

        private function setSchedule(param1:String) : void
        {
            this._schedule = this._schedules.getValue(param1);
            return;
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

        override public function get damage() : Number
        {
            return EXPLOSION_DAMAGE;
        }// end function

        private function initPhysicBody(param1:Number, param2:Number) : void
        {
            var _loc_4:b2PolygonDef = null;
            var _loc_3:* = new b2BodyDef();
            _loc_4 = new b2PolygonDef();
            _loc_4.density = 0.1;
            _loc_4.friction = 0.01;
            _loc_4.restitution = 0.1;
            _loc_4.filter.categoryBits = 2;
            _loc_4.filter.maskBits = 4;
            _loc_4.filter.groupIndex = 2;
            _loc_4.SetAsBox(12 / Universe.DRAW_SCALE, 16 / Universe.DRAW_SCALE);
            _loc_3.position.Set(param1 / Universe.DRAW_SCALE, (param2 + 4) / Universe.DRAW_SCALE);
            _loc_3.fixedRotation = true;
            _loc_3.userData = this;
            _body = _universe.physics.CreateBody(_loc_3);
            _body.CreateShape(_loc_4);
            _loc_4.isSensor = true;
            _loc_4.SetAsOrientedBox(30 / Universe.DRAW_SCALE, 26 / Universe.DRAW_SCALE, new b2Vec2(0, -0.4), 0);
            _body.CreateShape(_loc_4);
            _body.SetMassFromShapes();
            this._wheel.init(param1, param2 + 20);
            this._wheel.parentObj = this;
            this._wheelBody = this._wheel.body;
            this._wheel.group = this.group;
            var _loc_5:* = new b2RevoluteJointDef();
            _loc_5.Initialize(this._wheelBody, _body, this._wheelBody.GetWorldCenter());
            this._joint = _universe.physics.CreateJoint(_loc_5) as b2RevoluteJoint;
            var _loc_6:* = this._wheelBody.GetPosition().x * Universe.DRAW_SCALE;
            this.x = this._wheelBody.GetPosition().x * Universe.DRAW_SCALE;
            _position.x = _loc_6;
            var _loc_6:* = this._wheelBody.GetPosition().y * Universe.DRAW_SCALE - 20;
            this.y = this._wheelBody.GetPosition().y * Universe.DRAW_SCALE - 20;
            _position.y = _loc_6;
            return;
        }// end function

        public function get alertId() : uint
        {
            return this._alertId;
        }// end function

        private function makeDeadBody(param1:Number, param2:Number) : void
        {
            var _loc_7:b2RevoluteJoint = null;
            var _loc_16:Bomb = null;
            var _loc_17:CollectableItem = null;
            var _loc_3:* = this._ragdoll.getBody("body");
            var _loc_4:* = ZombieBombPart.get();
            _loc_4.color = this._color;
            _loc_4.variety = ZombieBombPart.BODY;
            _loc_4.setSize(_loc_3.width, _loc_3.height);
            _loc_4.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getBody("rightHand");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_5:* = ZombieBombPart.get();
            _loc_5.variety = ZombieBombPart.HAND_RIGHT;
            _loc_5.color = this._color;
            _loc_5.setSize(_loc_3.width, _loc_3.height);
            _loc_5.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            var _loc_6:* = new b2RevoluteJointDef();
            var _loc_8:* = new b2Vec2();
            var _loc_9:* = new b2Vec2(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_3 = this._ragdoll.getJoint("jointRightHand");
            _loc_3.scaleX = _sprite.scaleX;
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_5.body, _loc_4.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            _loc_3 = this._ragdoll.getBody("leftHand");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_10:* = ZombieBombPart.get();
            _loc_10.variety = ZombieBombPart.HAND_LEFT;
            _loc_10.color = this._color;
            _loc_10.setSize(_loc_3.width, _loc_3.height);
            _loc_10.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getJoint("jointLeftHand");
            _loc_3.scaleX = _sprite.scaleX;
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_10.body, _loc_4.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            _loc_3 = this._ragdoll.getBody("rightLeg");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_11:* = ZombieBombPart.get();
            _loc_11.color = this._color;
            _loc_11.variety = ZombieBombPart.LEG_RIGHT;
            _loc_11.setSize(_loc_3.width, _loc_3.height);
            _loc_11.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getJoint("jointRightLeg");
            _loc_3.scaleX = _sprite.scaleX;
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_11.body, _loc_4.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            _loc_3 = this._ragdoll.getBody("leftLeg");
            _loc_3.scaleX = _sprite.scaleX;
            var _loc_12:* = ZombieBombPart.get();
            _loc_12.color = this._color;
            _loc_12.variety = ZombieBombPart.LEG_LEFT;
            _loc_12.setSize(_loc_3.width, _loc_3.height);
            _loc_12.init(param1 + _loc_3.x, param2 + _loc_3.y, _loc_3.angle, _sprite.scaleX);
            _loc_3 = this._ragdoll.getJoint("jointLeftLeg");
            _loc_3.scaleX = _sprite.scaleX;
            _loc_3.addOffset(_loc_9, _loc_8);
            _loc_3.setLimits(_loc_6);
            _loc_6.Initialize(_loc_12.body, _loc_4.body, _loc_8);
            _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            _universe.joints.add(_loc_7, STRENGTH_OF_JOINT);
            this._effBurn.die();
            if (!this._selfExplosion)
            {
                _loc_3 = this._ragdoll.getBody("bomb");
                _loc_3.scaleX = _sprite.scaleX;
                _loc_16 = Bomb.get();
                _loc_16.init(param1 + _loc_3.x, param2 + _loc_3.y);
            }
            if (!this._selfExplosion)
            {
                _loc_3 = this._ragdoll.getJoint("jointBomb");
                _loc_3.scaleX = _sprite.scaleX;
                _loc_3.addOffset(_loc_9, _loc_8);
                _loc_3.setLimits(_loc_6);
                _loc_6.Initialize(_loc_16.body, _loc_10.body, _loc_8);
                _loc_7 = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
                _universe.joints.add(_loc_7, 10);
            }
            _loc_5.render();
            _loc_11.render();
            _loc_4.render();
            _loc_12.render();
            _loc_4.body.ApplyImpulse(new b2Vec2(_hitForce.x / 20, _hitForce.y / 20), _hitPoint);
            var _loc_13:* = new b2Vec2(Amath.random(0, 3) / 20, (Amath.random(-3, -2) - Math.random()) / 10);
            _loc_13.x = _sprite.scaleX == DIR_LEFT ? (-_loc_13.x) : (_loc_13.x);
            var _loc_14:* = Coin.get();
            _loc_14.init(param1, param2);
            _loc_14.body.ApplyImpulse(_loc_13, _loc_14.body.GetWorldCenter());
            _universe.motiKillEnemy();
            ZG.saveBox.statisticKill(this.group);
            _universe.checkAchievement(0);
            ZG.sound(SoundManager.HIT_TO_DEADBODY, this);
            var _loc_15:* = _universe.player.weaponAmmo();
            if (_loc_15 != ShopBox.ITEM_UNDEFINED)
            {
                _loc_13.x = Amath.random(0, 3) / 20;
                _loc_13.y = (Amath.random(-3, -2) - Math.random()) / 10;
                _loc_17 = _universe.makeCollectableItem(_loc_15, 1, param1, param2);
                _loc_17.body.ApplyImpulse(_loc_13, _loc_17.body.GetWorldCenter());
            }
            return;
        }// end function

        private function sense() : void
        {
            var _loc_1:b2Vec2 = null;
            var _loc_2:BasicObject = null;
            var _loc_3:* = _senseContacts.length;
            var _loc_4:uint = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = _senseContacts[_loc_4] as BasicObject;
                if (_loc_2.body == null)
                {
                }
                else
                {
                    _loc_1 = _loc_2.body.GetPosition();
                    if (this._dir == DIR_LEFT && _loc_1.x < _body.GetPosition().x || this._dir == DIR_RIGHT && _loc_1.x > _body.GetPosition().x)
                    {
                        if (this.isEnemyUnit(_loc_2.group))
                        {
                            this._conditions.setValue(CONDITION_CAN_ATTACK);
                            this._targetToAttack = _loc_2;
                        }
                        if (_loc_2.group == Kind.GROUP_BREAKABLE)
                        {
                            this._conditions.setValue(CONDITION_CAN_BREAK);
                            this._targetToAttack = _loc_2;
                        }
                        if (Math.abs(_body.GetPosition().y - _loc_1.y) < 1)
                        {
                            this._conditions.setValue(CONDITION_OBSTACLE);
                        }
                    }
                }
                _loc_4 = _loc_4 + 1;
            }
            return;
        }// end function

        private function explosion() : void
        {
            var _loc_3:b2Body = null;
            var _loc_4:b2Shape = null;
            var _loc_1:* = new b2AABB();
            _loc_1.lowerBound.Set(_body.GetWorldCenter().x - 4, _body.GetWorldCenter().y - 4);
            _loc_1.upperBound.Set(_body.GetWorldCenter().x + 4, _body.GetWorldCenter().y + 4);
            var _loc_2:Array = [];
            _universe.physics.Query(_loc_1, _loc_2, 30);
            var _loc_5:* = _loc_2.length;
            var _loc_6:uint = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_3 = (_loc_2[_loc_6] as b2Shape).GetBody();
                if (_loc_3 != null && _loc_3.m_userData is EnemyZombieBomb)
                {
                    if (_loc_3.m_userData as EnemyZombieBomb == this)
                    {
                        _loc_4 = _loc_2[_loc_6];
                        _loc_2[_loc_6] = null;
                        _loc_2.splice(_loc_6, 1);
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
                if (_loc_3 == null)
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
            _loc_11.init(x, y);
            ZG.sound(SoundManager.BOMB_EXPLOSION, this);
            _universe.quake(2);
            _universe.motiExplosion();
            this.free();
            return;
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

        private function onAttackInit() : Boolean
        {
            _die = true;
            this._selfExplosion = true;
            this.makeDeadBody(_position.x, _position.y);
            this.explosion();
            this.free();
            return true;
        }// end function

        override public function hide() : void
        {
            if (_isVisible)
            {
                this._effBurn.hide();
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
                this._effBurn.show();
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

        public static function get() : EnemyZombieBomb
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EnemyZombieBomb;
        }// end function

    }
}
