package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.anim.*;
    import com.antkarlov.controllers.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.antkarlov.repositories.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.gui.*;
    import com.zombotron.helpers.*;
    import com.zombotron.levels.*;
    import flash.events.*;
    import flash.utils.*;

    public class Player extends BasicObject
    {
        public var missionShoping:int = 0;
        private var _coins:int;
        public var missionSkeleton:int = 0;
        private var _shootTime:int;
        private var _tm:TaskManager;
        private var _hitPoint:b2Vec2;
        private var _wheelBody:b2Body;
        private var _isSuicide:Boolean;
        private var _aLegs:Animation;
        private var _aidkit:int;
        private var _weapon:Weapon;
        public var missionCoin:int = 0;
        private var _armor:Number;
        private var _schedules:Repository;
        public var missionRobot:int = 0;
        private var _timer:Timer;
        public var missionBarrel:int = 0;
        private var _isControl:Boolean = false;
        private var _oldTime:int = 0;
        private var _conditions:Conditions;
        private var _wheel:PlayerWheel;
        private var _aHand:Animation;
        private var _coveredDistance:int = 0;
        private var _hitForce:b2Vec2;
        public var missionTime:int = 0;
        private var _dustDelay:int;
        private var _joint:b2RevoluteJoint;
        private var _secondWeapon:Weapon;
        private var _state:int = 0;
        public var missionBoom:int = 0;
        public var missionMegaKill:int = 0;
        private var _aWeapon:Animation;
        public var missionBox:int = 0;
        public var missionShot:int = 0;
        private var _dustTimeSmall:int;
        private var _offset:Number;
        private var _aBody:Animation;
        public var fatalFall:Boolean = false;
        private var _aBag:Animation;
        public var missionZombie:int = 0;
        public var missionChest:int = 0;
        public var missionBag:int = 0;
        private var _isReloading:Boolean;
        private var _aHead:Animation;
        private var _smoothing:Boolean;
        private var _schedule:Schedule = null;
        private var _dustTime:int;
        public static const STRENGTH_OF_JOINT:int = 50;
        public static const CONDITION_JUMP:int = 4;
        public static const SCHEDULE_STAY:String = "stay";
        public static const STATE_FALL:int = 3;
        public static const CONDITION_WALK:int = 2;
        private static const HAND_X:int = 9;
        private static const HEAD_X:int = 2;
        public static const SCHEDULE_JUMP:String = "jump";
        public static const STATE_WALK:int = 1;
        private static const HAND_Y:int = -3;
        private static const EXPLOSION_POWER:int = 2;
        public static const CONDITION_DIE:int = 1;
        public static const CONDITION_STAY:int = 3;
        public static const HEALTH:Number = 1;
        public static const STATE_STAY:int = 0;
        public static const SCHEDULE_FALL:String = "fall";
        public static const SCHEDULE_WALK:String = "walk";
        private static const HEAD_Y:int = -7;
        private static const WEAPON_X:int = 9;
        private static const EXPLOSION_DAMAGE:Number = 2;
        public static const STATE_JUMP:int = 2;
        private static const WEAPON_Y:int = -3;
        public static const CONDITION_FALL:int = 0;

        public function Player(param1:Number, param2:Number)
        {
            this._tm = new TaskManager();
            this._timer = new Timer(1000);
            group = Kind.GROUP_PLAYER;
            _kind = Kind.HERO;
            this._smoothing = _universe.smoothing;
            this._offset = 0;
            this._wheel = new PlayerWheel();
            this._conditions = new Conditions();
            this._schedules = new Repository();
            this._state = STATE_STAY;
            this._schedule = null;
            this._timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
            var _loc_3:* = new Schedule(SCHEDULE_STAY);
            _loc_3.addFewTasks([this.onStayInit, this.onStayAnim, this.onStay]);
            _loc_3.addFewInterrupts([CONDITION_FALL, CONDITION_DIE, CONDITION_WALK, CONDITION_JUMP]);
            this._schedules.setValue(SCHEDULE_STAY, _loc_3);
            var _loc_4:* = new Schedule(SCHEDULE_WALK);
            _loc_4.addFewTasks([this.onWalkInit, this.onWalkAnim, this.onWalk]);
            _loc_4.addFewInterrupts([CONDITION_FALL, CONDITION_DIE, CONDITION_STAY, CONDITION_JUMP]);
            this._schedules.setValue(SCHEDULE_WALK, _loc_4);
            var _loc_5:* = new Schedule(SCHEDULE_FALL);
            _loc_5.addFewTasks([this.onFallInit, this.onFallAnim, this.onFall]);
            _loc_5.addFewInterrupts([CONDITION_STAY, CONDITION_DIE]);
            this._schedules.setValue(SCHEDULE_FALL, _loc_5);
            var _loc_6:* = new Schedule(SCHEDULE_JUMP);
            _loc_6.addFewTasks([this.onJumpInit, this.onJumpAnim, this.onFall]);
            this._schedules.setValue(SCHEDULE_JUMP, _loc_6);
            this._schedule = this._schedules.getValue(SCHEDULE_STAY);
            this._weapon = new Weapon();
            this._weapon.kind = ShopBox.ITEM_PISTOL;
            this._secondWeapon = null;
            this.init(param1, param2);
            ZG.key.register(this.doAction, KeyCode.F);
            ZG.key.register(this.doAction, KeyCode.S);
            ZG.key.register(this.doAction, KeyCode.E);
            ZG.key.register(this.doAction, KeyCode.DOWN);
            ZG.key.register(this.gunReload, KeyCode.R);
            ZG.key.register(this.useAidkit, KeyCode.H);
            ZG.key.register(this.switchWeapon, KeyCode.Q);
            ZG.key.register(this.suicide, KeyCode.X);
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

        public function get coins() : int
        {
            return this._coins;
        }// end function

        public function set coins(param1:int) : void
        {
            this._coins = param1;
            ZG.playerGui.coins(this._coins);
            return;
        }// end function

        private function onStayAnim() : Boolean
        {
            var _loc_1:* = this._aLegs.scaleX;
            this.beginSetAnim();
            this._aLegs = ZG.animCache.getAnimation(Art.HERO_LEGS_STAY);
            this._aLegs.scaleX = _loc_1;
            this.endSetAnim();
            return true;
        }// end function

        public function weaponAmmo(param1:Boolean = false) : uint
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_5:Number = NaN;
            var _loc_6:Boolean = false;
            if (this._secondWeapon == null)
            {
                _loc_2 = this._weapon.ammoKind;
                _loc_3 = this._weapon.supply;
                _loc_4 = this._weapon.chargerCapacity;
            }
            else if (Math.random() > 0.5)
            {
                _loc_2 = this._secondWeapon.ammoKind;
                _loc_3 = this._secondWeapon.supply;
                _loc_4 = this._secondWeapon.chargerCapacity;
            }
            else
            {
                _loc_2 = this._weapon.ammoKind;
                _loc_3 = this._weapon.supply;
                _loc_4 = this._weapon.chargerCapacity;
            }
            if (!param1)
            {
                _loc_5 = ZG.hardcoreMode ? (0.65) : (0.55);
                _loc_6 = false;
                if (_loc_3 < _loc_4 * Amath.random(2, 3))
                {
                    _loc_6 = Math.random() > _loc_5 ? (true) : (false);
                }
                return _loc_6 ? (_loc_2) : (ShopBox.ITEM_UNDEFINED);
            }
            else
            {
                return _loc_2;
            }
        }// end function

        private function onStayInit() : Boolean
        {
            this._joint.EnableLimit(true);
            return true;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            this._smoothing = _universe.smoothing;
            ZG.playerGui.totalHealth(ZG.hardcoreMode ? (HEALTH) : (HEALTH + HEALTH * 0.5));
            ZG.playerGui.totalArmor(1);
            if (!_isDead)
            {
                if (!ZG.saveBox.haveData)
                {
                    this.armor = 0;
                    this.charger = this._weapon.chargerCapacity;
                    this.supply = 30;
                    log(Art.TXT_BIOBOT_INITIALIZED);
                }
                else
                {
                    this.loadData();
                }
            }
            this.health = ZG.hardcoreMode ? (HEALTH) : (HEALTH + HEALTH * 0.5);
            this.armor = this._armor;
            this.charger = this._weapon.charger;
            this.supply = this._weapon.supply;
            ZG.playerGui.currentWeapon(this._weapon.kind);
            ZG.playerGui.coins(this._coins);
            ZG.playerGui.aidkit(this._aidkit);
            this.updateWeapon();
            if (!_isDead)
            {
                this.saveData();
                ZG.saveBox.save(_universe.level.levelNum);
            }
            this.initPhysicBody(param1, param2);
            this.initGraphicBody();
            this._aHead.gotoAndStop(1);
            this.fatalFall = false;
            this._isSuicide = false;
            this._isReloading = false;
            this._shootTime = 0;
            this._conditions.clear();
            this._schedule.reset();
            this._schedule = this._schedules.getValue(SCHEDULE_STAY);
            if (!_isDead)
            {
                this.resetMissions();
            }
            reset();
            show();
            this.render();
            this._coveredDistance = this.x;
            return;
        }// end function

        public function gunReload() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            if (_isDead)
            {
                _universe.restartLevel();
            }
            if (!this.isControl)
            {
                return;
            }
            if (this._weapon.charger == this._weapon.chargerCapacity)
            {
                ZG.playerGui.chargerBlink();
                return;
            }
            if (this._weapon.supply == 0)
            {
                ZG.sound(SoundManager.MISFIRE, this, true);
                return;
            }
            if (!this._isReloading && !_isFree)
            {
                _loc_1 = this._aWeapon.x;
                _loc_2 = this._aWeapon.y;
                removeChild(this._aWeapon);
                this._aWeapon = ZG.animCache.getAnimation(this._weapon.reloadAnim);
                this._aWeapon.x = _loc_1;
                this._aWeapon.y = _loc_2;
                this._aWeapon.smoothing = this._smoothing;
                addChild(this._aWeapon);
                this.aimToMouse();
                this._aWeapon.repeat = false;
                this._aWeapon.play();
                this._aWeapon.addEventListener(Event.COMPLETE, this.reloadCompleteHandler);
                this._isReloading = true;
                ZG.sound(this._weapon.reloadSnd, this);
            }
            return;
        }// end function

        private function generateConditions() : void
        {
            var _loc_2:b2ContactPoint = null;
            this._conditions.clear();
            if (!this.isControl)
            {
                this._conditions.setValue(CONDITION_STAY);
                return;
            }
            var _loc_1:uint = 0;
            if (ZG.key.isDown(KeyCode.LEFT) || ZG.key.isDown(KeyCode.A) || ZG.key.isDown(KeyCode.RIGHT) || ZG.key.isDown(KeyCode.D) && _contacts.length > 0)
            {
                this._conditions.setValue(CONDITION_WALK);
            }
            else if (_contacts.length > 0)
            {
                this._conditions.setValue(CONDITION_STAY);
            }
            if (ZG.key.isDown(KeyCode.UP) || ZG.key.isDown(KeyCode.W) || ZG.key.isDown(KeyCode.SPACEBAR) && _contacts.length > 0)
            {
                this._conditions.setValue(CONDITION_JUMP);
            }
            if (_body.GetLinearVelocity().y > 0.2 && _contacts.length == 0)
            {
                this._conditions.setValue(CONDITION_FALL);
            }
            return;
        }// end function

        private function explosion() : void
        {
            var res:Array;
            var body:b2Body;
            var p1:b2Vec2;
            var p2:b2Vec2;
            var i:int;
            this.armor = 0;
            this.hurt(this.health);
            this.health = 0;
            this._hitForce = new b2Vec2();
            this._hitPoint = new b2Vec2(_body.GetPosition().x, _body.GetPosition().y);
            this.makeDeadBody(this.x, this.y);
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
            eff.variety = EffectExplosion.EXPLOSION;
            eff.init(this.x, this.y);
            ZG.sound(SoundManager.BOMB_EXPLOSION, this);
            _universe.quake(4);
            this.free();
            return;
        }// end function

        public function shoot() : void
        {
            var _loc_1:EffectShoot = null;
            var _loc_2:EffectBulletCase = null;
            var _loc_3:Avector = null;
            var _loc_4:BulletGrenade = null;
            var _loc_5:int = 0;
            var _loc_6:Bullet = null;
            if (!this.isControl)
            {
                return;
            }
            if (this._shootTime >= this._weapon.shootInterval && !this._isReloading)
            {
                if (this._weapon.charger == 0)
                {
                    if (this._weapon.supply == 0 && this._weapon.charger == 0 && this._secondWeapon != null && this._secondWeapon.supply > 0)
                    {
                        this.switchWeapon();
                    }
                    else
                    {
                        this.gunReload();
                    }
                }
                else if (this._weapon.charger > 0)
                {
                    this._aWeapon.repeat = false;
                    this._aWeapon.gotoAndPlay(1);
                    this._shootTime = 0;
                    _loc_1 = EffectShoot.get();
                    _loc_1.variety = this._weapon.shootEffect;
                    _loc_1.init(this.x + this._aWeapon.x, this.y + this._aWeapon.y, this._aWeapon.rotation, this._aWeapon.scaleX);
                    _loc_2 = EffectBulletCase.get();
                    _loc_2.variety = this._weapon.bulletCase;
                    _loc_3 = Amath.rotatePointDeg(this.x + this._aWeapon.x + 24 * this._aWeapon.scaleX, this.y + this._aWeapon.y + 2, this.x + this._aWeapon.x, this.y + this._aWeapon.y, this._aWeapon.rotation);
                    _loc_2.init(_loc_3.x, _loc_3.y, 0, this._aWeapon.scaleX);
                    _loc_3 = new Avector();
                    if (this._weapon.kind == ShopBox.ITEM_GRENADEGUN)
                    {
                        _loc_4 = BulletGrenade.get();
                        _loc_4.impulse = Amath.distance(_universe.w_mouseX, _universe.w_mouseY, this.x, this.y) * 0.005;
                        _loc_4.variety = this._weapon.bulletVariety;
                        _loc_4.damage = this._weapon.damage;
                        _loc_3.set(this._weapon.bulletPos.x * this._aWeapon.scaleX, this._weapon.bulletPos.y);
                        _loc_3.rotateAroundDeg(new Avector(this._aWeapon.x, this._aWeapon.y), this._aWeapon.rotation);
                        _loc_4.init(this.x + _loc_3.x, this.y + _loc_3.y, this._aWeapon.rotation + this._weapon.dispersion, this._aWeapon.scaleX);
                        ZG.saveBox.statisticShot(this._weapon.kind);
                    }
                    else
                    {
                        _loc_5 = 0;
                        while (_loc_5 < this._weapon.bulletsNum)
                        {
                            
                            _loc_6 = Bullet.get();
                            _loc_6.impulse = this._weapon.bulletsNum == 1 ? (1.5) : ((Math.random() + 1));
                            _loc_6.variety = this._weapon.bulletVariety;
                            _loc_6.damage = this._weapon.damage;
                            _loc_3.set(this._weapon.bulletPos.x * this._aWeapon.scaleX, this._weapon.bulletPos.y);
                            _loc_3.rotateAroundDeg(new Avector(this._aWeapon.x, this._aWeapon.y), this._aWeapon.rotation);
                            _loc_6.init(this.x + _loc_3.x, this.y + _loc_3.y, this._aWeapon.rotation + this._weapon.dispersion, this._aWeapon.scaleX);
                            ZG.saveBox.statisticShot(this._weapon.kind);
                            _loc_5++;
                        }
                    }
                    ZG.sound(this._weapon.shootSnd, this);
                    var _loc_7:String = this;
                    var _loc_8:* = this.charger - 1;
                    _loc_7.charger = _loc_8;
                    if (this._weapon.charger == 0)
                    {
                        if (this._weapon.supply == 0 && this._weapon.charger == 0 && this._secondWeapon != null && this._secondWeapon.supply > 0)
                        {
                            this.switchWeapon();
                        }
                        else
                        {
                            this.gunReload();
                        }
                    }
                    if (ZG.playerGui.isHaveMission(LevelBase.MISSION_SILENT))
                    {
                        var _loc_7:String = this;
                        var _loc_8:* = this.missionShot + 1;
                        _loc_7.missionShot = _loc_8;
                        ZG.playerGui.updateMission(LevelBase.MISSION_SILENT, this.missionShot, false);
                    }
                }
            }
            return;
        }// end function

        private function onFallInit() : Boolean
        {
            this._joint.EnableLimit(false);
            return true;
        }// end function

        private function onFallAnim() : Boolean
        {
            var _loc_1:* = this._aLegs.scaleX;
            var _loc_2:* = this._aLegs.currentFrame;
            this.beginSetAnim();
            this._aLegs = $.animCache.getAnimation(Art.HERO_LEGS_JUMP);
            this._aLegs.scaleX = _loc_1;
            this._aLegs.gotoAndStop(_loc_2);
            this.endSetAnim();
            return true;
        }// end function

        private function hurt(param1:Number) : void
        {
            ZG.saveBox.careful = 0;
            if (this.armor > 0)
            {
                this.armor = this.armor - param1;
            }
            else
            {
                this.health = this.health - param1;
                if (_health <= 0.6)
                {
                    this.useAidkit();
                }
            }
            return;
        }// end function

        private function makeDeadBody(param1:int, param2:int) : void
        {
            var _loc_6:b2RevoluteJoint = null;
            var _loc_7:b2Vec2 = null;
            var _loc_15:b2Vec2 = null;
            var _loc_16:Coin = null;
            if (_isDead)
            {
                return;
            }
            var _loc_18:* = ZG.saveBox;
            var _loc_19:* = ZG.saveBox.deaths + 1;
            _loc_18.deaths = _loc_19;
            _isDead = true;
            var _loc_3:* = HeroPart.get();
            _loc_3.variety = HeroPart.BODY;
            _loc_3.init(param1, param2, 0, this._aBody.scaleX);
            var _loc_4:* = HeroPart.get();
            _loc_4.variety = HeroPart.HEAD;
            _loc_4.init(param1, param2, 0, this._aBody.scaleX);
            var _loc_5:* = new b2RevoluteJointDef();
            _loc_7 = _loc_4.body.GetWorldCenter();
            _loc_7.y = _loc_7.y + 10 / Universe.DRAW_SCALE;
            _loc_5.lowerAngle = Amath.toRadians(-20);
            _loc_5.upperAngle = Amath.toRadians(20);
            _loc_5.enableLimit = true;
            _loc_5.Initialize(_loc_4.body, _loc_3.body, _loc_7);
            _loc_6 = _universe.physics.CreateJoint(_loc_5) as b2RevoluteJoint;
            _universe.joints.add(_loc_6, STRENGTH_OF_JOINT);
            var _loc_8:* = HeroPart.get();
            _loc_8.variety = HeroPart.HAND_RIGHT;
            _loc_8.init(param1, param2, 0, this._aBody.scaleX);
            _loc_7 = _loc_8.body.GetWorldCenter();
            var _loc_9:* = this._aBody.scaleX == -1 ? (10) : (-10);
            _loc_7.x = _loc_7.x + _loc_9 / Universe.DRAW_SCALE;
            _loc_5.lowerAngle = Amath.toRadians(-120);
            _loc_5.upperAngle = Amath.toRadians(120);
            _loc_5.enableLimit = true;
            _loc_5.Initialize(_loc_8.body, _loc_3.body, _loc_7);
            _loc_6 = _universe.physics.CreateJoint(_loc_5) as b2RevoluteJoint;
            _universe.joints.add(_loc_6, STRENGTH_OF_JOINT);
            var _loc_10:* = HeroPart.get();
            _loc_10.variety = HeroPart.HAND_LEFT;
            _loc_10.init(param1, param2, 0, this._aBody.scaleX);
            _loc_7 = _loc_10.body.GetWorldCenter();
            _loc_9 = this._aBody.scaleX == -1 ? (10) : (-10);
            _loc_7.x = _loc_7.x + _loc_9 / Universe.DRAW_SCALE;
            _loc_5.lowerAngle = Amath.toRadians(-90);
            _loc_5.upperAngle = Amath.toRadians(90);
            _loc_5.enableLimit = true;
            _loc_5.Initialize(_loc_10.body, _loc_3.body, _loc_7);
            _loc_6 = _universe.physics.CreateJoint(_loc_5) as b2RevoluteJoint;
            _universe.joints.add(_loc_6, STRENGTH_OF_JOINT);
            var _loc_11:* = HeroPart.get();
            _loc_11.variety = this._aBody.scaleX == -1 ? (HeroPart.LEG_RIGHT) : (HeroPart.LEG_LEFT);
            _loc_11.init(param1, param2, 0, this._aBody.scaleX);
            var _loc_12:* = HeroPart.get();
            _loc_12.variety = this._aBody.scaleX == -1 ? (HeroPart.LEG_LEFT) : (HeroPart.LEG_RIGHT);
            _loc_12.init(param1, param2, 0, this._aBody.scaleX);
            _loc_7 = _loc_11.body.GetWorldCenter();
            _loc_7.y = _loc_7.y - 10 / Universe.DRAW_SCALE;
            _loc_5.lowerAngle = Amath.toRadians(-60);
            _loc_5.upperAngle = Amath.toRadians(60);
            _loc_5.enableLimit = true;
            _loc_5.Initialize(_loc_11.body, _loc_3.body, _loc_7);
            _loc_6 = _universe.physics.CreateJoint(_loc_5) as b2RevoluteJoint;
            _universe.joints.add(_loc_6, STRENGTH_OF_JOINT);
            _loc_7 = _loc_12.body.GetWorldCenter();
            _loc_7.y = _loc_7.y - 10 / Universe.DRAW_SCALE;
            _loc_5.Initialize(_loc_12.body, _loc_3.body, _loc_7);
            _loc_6 = _universe.physics.CreateJoint(_loc_5) as b2RevoluteJoint;
            _universe.joints.add(_loc_6, STRENGTH_OF_JOINT);
            _loc_10.render();
            _loc_3.render();
            if (this._aBody.scaleX == -1)
            {
                _loc_12.render();
                _loc_11.render();
            }
            else
            {
                _loc_11.render();
                _loc_12.render();
            }
            _loc_4.render();
            _loc_8.render();
            var _loc_13:* = CollectableItem.get();
            _loc_13.variety = this._weapon.kind;
            _loc_13.collectable = false;
            _loc_13.init(param1, param2, 0, this._aBody.scaleX);
            _loc_3.body.ApplyImpulse(this._hitForce, this._hitPoint);
            _loc_4.body.SetAngularVelocity(0);
            _universe.playerBody = _loc_3.body;
            ZG.sound(SoundManager.HERO_DEAD, this);
            var _loc_14:* = Amath.random(3, 6);
            _loc_14 = _loc_14 > this._coins ? (this._coins) : (_loc_14);
            var _loc_17:int = 0;
            while (_loc_17 < _loc_14)
            {
                
                _loc_15 = new b2Vec2(Amath.random(-3, 3) / 20, (Amath.random(-3, -2) - Math.random()) / 10);
                _loc_16 = Coin.get();
                _loc_16.init(param1, param2);
                _loc_16.body.ApplyImpulse(_loc_15, _loc_16.body.GetWorldCenter());
                var _loc_18:String = this;
                var _loc_19:* = this._coins - 1;
                _loc_18._coins = _loc_19;
                _loc_17++;
            }
            ZG.playerGui.coins(this._coins);
            log(Art.TXT_YOU_ARE_IS_DEAD);
            log(Text.CON_PRESS_SPACEBAR_TO_RESPAWN);
            this._tm.addPause(70);
            this._tm.addInstantTask(this.doShowHint);
            return;
        }// end function

        private function suicide() : void
        {
            if (!this._isSuicide)
            {
                this._tm.clear();
                this._tm.addPause(105);
                this._tm.addInstantTask(this.explosion);
                this._aHead.play();
                ZG.sound(SoundManager.BOMB_ALARM, this);
                log("self-destruct mode is activated..");
                this._isSuicide = true;
            }
            return;
        }// end function

        public function giveCoin(param1:int = 1) : void
        {
            this._coins = this._coins + param1;
            ZG.playerGui.coins(this._coins);
            var _loc_2:String = this;
            var _loc_3:* = this.missionCoin + 1;
            _loc_2.missionCoin = _loc_3;
            ZG.playerGui.updateMission(LevelBase.MISSION_COIN, this.missionCoin);
            _universe.checkAchievement(AchievementItem.BIG_MONEY);
            return;
        }// end function

        private function endSetAnim() : void
        {
            if (this._aLegs)
            {
                addChild(this._aLegs);
            }
            if (this._aHand)
            {
                addChild(this._aHand);
            }
            if (this._aBody)
            {
                addChild(this._aBody);
            }
            if (this._aHead)
            {
                addChild(this._aHead);
            }
            if (this._aWeapon)
            {
                addChild(this._aWeapon);
            }
            return;
        }// end function

        private function onWalk() : Boolean
        {
            var _loc_1:b2Vec2 = null;
            switch(this._aLegs.currentFrame)
            {
                case 4:
                case 8:
                case 13:
                case 17:
                {
                    this._offset = 1;
                    break;
                }
                case 6:
                case 15:
                {
                    this._offset = 2;
                    break;
                }
                case 1:
                case 10:
                {
                    this._offset = 0;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (ZG.key.isDown(KeyCode.RIGHT) || ZG.key.isDown(KeyCode.D))
            {
                if (this._aLegs.scaleX < 0)
                {
                    this._aLegs.scaleX = 1;
                    ZG.saveBox.coveredDistance = ZG.saveBox.coveredDistance + Math.abs(this.x - this._coveredDistance);
                    this._coveredDistance = this.x;
                }
                this._wheelBody.SetAngularVelocity(20);
            }
            else if (ZG.key.isDown(KeyCode.LEFT) || ZG.key.isDown(KeyCode.A))
            {
                if (this._aLegs.scaleX > 0)
                {
                    this._aLegs.scaleX = -1;
                    ZG.saveBox.coveredDistance = ZG.saveBox.coveredDistance + Math.abs(this.x - this._coveredDistance);
                    this._coveredDistance = this.x;
                }
                this._wheelBody.SetAngularVelocity(-20);
            }
            else
            {
                _loc_1 = _body.GetLinearVelocity();
                if (_loc_1.x != 0)
                {
                    _loc_1.x = 0;
                    _body.SetLinearVelocity(_loc_1);
                    this._wheelBody.SetAngularVelocity(0);
                }
            }
            return false;
        }// end function

        override public function bulletCollision(param1:Bullet, param2:b2Vec2) : void
        {
            var _loc_3:EffectBlood = null;
            var _loc_4:uint = 0;
            if (!_isFree)
            {
                this.hurt(param1.damage);
                if (this.health <= 0 && !_die)
                {
                    this._hitPoint = new b2Vec2(param2.x, param2.y);
                    this._hitForce = new b2Vec2(param1.body.GetLinearVelocity().x / 20, param1.body.GetLinearVelocity().y / 20);
                    _universe.deads.add(this);
                    _die = true;
                }
                _loc_4 = 0;
                while (_loc_4 < 2)
                {
                    
                    _loc_3 = EffectBlood.get();
                    _loc_3.speed = new Avector(Amath.random(1, 5), Amath.random(-1, -5));
                    _loc_3.speed.x = this._aBody.scaleX < 0 ? (_loc_3.speed.x) : (_loc_3.speed.x * -1);
                    _loc_3.init(param2.x * Universe.DRAW_SCALE, param2.y * Universe.DRAW_SCALE);
                    _loc_4 = _loc_4 + 1;
                }
            }
            return;
        }// end function

        public function get charger() : int
        {
            return this._weapon.charger;
        }// end function

        private function updateWeapon() : void
        {
            if (this._aWeapon == null)
            {
                return;
            }
            if (contains(this._aWeapon))
            {
                removeChild(this._aWeapon);
            }
            var _loc_1:* = this._aWeapon.x;
            var _loc_2:* = this._aWeapon.y;
            this._aWeapon = $.animCache.getAnimation(this._weapon.shootAnim);
            this._aWeapon.x = _loc_1;
            this._aWeapon.y = _loc_2;
            this._aWeapon.smoothing = this._smoothing;
            addChild(this._aWeapon);
            this.aimToMouse();
            ZG.playerGui.currentWeapon(this._weapon.kind);
            ZG.playerGui.charger(this._weapon.charger);
            ZG.playerGui.supply(this._weapon.supply);
            return;
        }// end function

        private function onJumpAnim() : Boolean
        {
            var _loc_1:* = this._aLegs.scaleX;
            this.beginSetAnim();
            this._aLegs = $.animCache.getAnimation(Art.HERO_LEGS_JUMP);
            this._aLegs.scaleX = _loc_1;
            this.endSetAnim();
            return true;
        }// end function

        override public function addContact(param1:b2ContactPoint) : Boolean
        {
            var _loc_2:BasicObject = null;
            var _loc_4:EffectBlow = null;
            var _loc_5:b2ContactPoint = null;
            var _loc_6:EffectDust = null;
            var _loc_7:EffectDustSmall = null;
            if (param1.shape1.GetBody().GetUserData() as BasicObject != this)
            {
                _loc_2 = param1.shape1.GetBody().GetUserData() as BasicObject;
            }
            else if (param1.shape2.GetBody().GetUserData() as BasicObject != this)
            {
                _loc_2 = param1.shape2.GetBody().GetUserData() as BasicObject;
            }
            if (_loc_2 != null && _loc_2.body.GetPosition().y < _body.GetPosition().y - 0.5)
            {
                this._hitPoint = new b2Vec2(param1.position.x, param1.position.y);
                this._hitForce = new b2Vec2(_loc_2.body.GetLinearVelocity().x * 5, _loc_2.body.GetLinearVelocity().y * 5);
                switch(_loc_2.kind)
                {
                    case Kind.STONE:
                    {
                        if (_loc_2.body.GetLinearVelocity().y > 1)
                        {
                            this.hurt(_loc_2.body.GetLinearVelocity().y * 0.1);
                            if (this.health == 0)
                            {
                                _universe.deads.add(this);
                                _die = true;
                            }
                            _loc_2.fatalDamage(_loc_2.body.GetPosition(), _loc_2.body.GetLinearVelocity());
                            _loc_4 = EffectBlow.get();
                            _loc_4.init(param1.position.x * Universe.DRAW_SCALE, param1.position.y * Universe.DRAW_SCALE);
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            var _loc_3:* = Amath.getAngleDeg(param1.position.x, param1.position.y, this._wheelBody.GetPosition().x, this._wheelBody.GetPosition().y);
            if (_loc_3 >= 210 && _loc_3 <= 335)
            {
                _loc_5 = new b2ContactPoint();
                _loc_5.shape1 = param1.shape1;
                _loc_5.shape2 = param1.shape2;
                _loc_5.position = param1.position;
                _loc_5.velocity = param1.velocity;
                _loc_5.normal = param1.normal;
                _loc_5.separation = param1.separation;
                _loc_5.friction = param1.friction;
                _loc_5.restitution = param1.restitution;
                _loc_5.id = param1.id;
                _contacts[_contacts.length] = _loc_5;
                if (param1.shape1.GetBody().GetUserData() is Ground || param1.shape2.GetBody().GetUserData() is Ground)
                {
                    if (_body.GetLinearVelocity().y > 3 && _universe.frameTime - this._dustTime > 10)
                    {
                        _loc_6 = EffectDust.get();
                        _loc_6.init(this.x - 10, this.y + 28);
                        _loc_6 = EffectDust.get();
                        _loc_6.init(this.x + 10, this.y + 28, 0, -1);
                        this._dustTime = _universe.frameTime;
                        this._dustDelay = Amath.random(5, 20);
                        this._dustTimeSmall = _universe.frameTime;
                    }
                    else if (_universe.frameTime - this._dustTimeSmall > this._dustDelay && Amath.abs(_body.GetLinearVelocity().x) > 2)
                    {
                        _loc_7 = EffectDustSmall.get();
                        _loc_7.velocity.x = _body.GetLinearVelocity().x * 0.3;
                        _loc_7.init(this.x + -4 * this._aLegs.scaleX, this.y + 32, 0, this._aLegs.scaleX);
                        this._dustDelay = Amath.random(2, 15);
                        this._dustTimeSmall = _universe.frameTime;
                    }
                }
            }
            if (!_die && (_body.GetLinearVelocity().y > 20 || this.fatalFall && _body.GetLinearVelocity().y > 5))
            {
                this.health = this.health - this.health;
                log(Art.TXT_SPARTA);
                ZG.playerGui.motivation(Motivation.MOTI_CRAZY_SELFKILLER);
                this._hitPoint = new b2Vec2(_body.GetPosition().x, _body.GetPosition().y);
                this._hitForce = new b2Vec2(_body.GetLinearVelocity().x / 2, _body.GetLinearVelocity().y / 2);
                _universe.deads.add(this);
                _die = true;
            }
            return true;
        }// end function

        public function get health() : Number
        {
            return _health;
        }// end function

        private function timerHandler(event:TimerEvent) : void
        {
            var _loc_3:String = this;
            var _loc_4:* = this.missionTime - 1;
            _loc_3.missionTime = _loc_4;
            var _loc_2:Boolean = false;
            if (this._oldTime - this.missionTime >= 10)
            {
                this._oldTime = this.missionTime;
                _loc_2 = true;
            }
            ZG.playerGui.updateMission(LevelBase.MISSION_TIME, this.missionTime, false, _loc_2);
            if (this.missionTime <= 0)
            {
                this.missionTime = 0;
                this._timer.stop();
            }
            return;
        }// end function

        override public function process() : void
        {
            if (_isFree)
            {
                return;
            }
            this.think();
            if (this._schedule)
            {
                this._schedule.process();
            }
            var _loc_1:String = this;
            var _loc_2:* = this._shootTime + 1;
            _loc_1._shootTime = _loc_2;
            if (_universe.isMouseDown)
            {
                this.shoot();
            }
            this.aimToMouse();
            _contacts.length = 0;
            return;
        }// end function

        public function switchWeapon() : void
        {
            var _loc_1:Weapon = null;
            if (!this.isControl)
            {
                return;
            }
            if (this._secondWeapon != null && !this._isReloading)
            {
                _loc_1 = this._weapon;
                this._weapon = this._secondWeapon;
                this._secondWeapon = _loc_1;
                this.updateWeapon();
                ZG.sound(SoundManager.WEAPON_SWITCH, this);
            }
            return;
        }// end function

        private function onJumpInit() : Boolean
        {
            var _loc_1:* = _body.GetLinearVelocity();
            if (_loc_1.x > 5)
            {
                _loc_1.x = 5;
                _body.SetLinearVelocity(_loc_1);
            }
            else if (_loc_1.x < -5)
            {
                _loc_1.x = -5;
                _body.SetLinearVelocity(_loc_1);
            }
            _body.ApplyImpulse(new b2Vec2(0, -4), _body.GetWorldCenter());
            ZG.sound(SoundManager.HERO_JUMP, this, true);
            _contacts.length = 0;
            return true;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                this._wheel.free();
                _universe.physics.DestroyBody(_body);
                this._schedule.reset();
                this.beginSetAnim();
                super.free();
            }
            return;
        }// end function

        public function giveAmmo(param1:uint) : void
        {
            if (this._weapon.ammoKind == param1)
            {
                this.supply = this.supply + this._weapon.ammoPack;
            }
            else if (this._secondWeapon != null && this._secondWeapon.ammoKind == param1)
            {
                this._secondWeapon.supply = this._secondWeapon.supply + this._secondWeapon.ammoPack;
            }
            return;
        }// end function

        private function initGraphicBody() : void
        {
            if (!this._aLegs)
            {
                this._aLegs = ZG.animCache.getAnimation(Art.HERO_LEGS_STAY);
                this._aHand = ZG.animCache.getAnimation(Art.HERO_HAND_BACK);
                this._aBody = ZG.animCache.getAnimation(Art.HERO_BODY);
                this._aHead = ZG.animCache.getAnimation(Art.HERO_HEAD);
                this._aWeapon = ZG.animCache.getAnimation(this._weapon.shootAnim);
            }
            this._aLegs.smoothing = this._smoothing;
            this._aHand.smoothing = this._smoothing;
            this._aBody.smoothing = this._smoothing;
            this._aHead.smoothing = this._smoothing;
            this._aHead.stop();
            this._aHead.speed = 0.5;
            this._aWeapon.smoothing = this._smoothing;
            this._aWeapon.x = -WEAPON_X;
            this._aWeapon.y = WEAPON_Y;
            this._aHand.x = -WEAPON_X;
            this._aHand.y = WEAPON_Y;
            this._aHead.x = -HEAD_X;
            this._aHead.y = HEAD_Y;
            var _loc_1:* = this._aWeapon.scaleX;
            this._aHead.scaleX = this._aWeapon.scaleX;
            this._aHand.scaleX = _loc_1;
            this.endSetAnim();
            return;
        }// end function

        public function set charger(param1:int) : void
        {
            this._weapon.charger = param1;
            ZG.playerGui.charger(param1);
            return;
        }// end function

        public function set armor(param1:Number) : void
        {
            this._armor = param1 <= 0.01 ? (0) : (param1);
            ZG.playerGui.armor(this._armor);
            return;
        }// end function

        override public function die() : void
        {
            if (!_isDead)
            {
                this.makeDeadBody(this.x, this.y);
                this.free();
                _isDead = true;
            }
            return;
        }// end function

        public function useAidkit() : void
        {
            var _loc_2:EffectHealth = null;
            if (!this.isControl)
            {
                return;
            }
            var _loc_1:* = ZG.hardcoreMode ? (HEALTH) : (HEALTH + HEALTH * 0.5);
            if (this._aidkit > 0 && _health != _loc_1)
            {
                var _loc_3:String = this;
                var _loc_4:* = this._aidkit - 1;
                _loc_3._aidkit = _loc_4;
                ZG.playerGui.aidkit(this._aidkit);
                _loc_2 = EffectHealth.get();
                _loc_2.targetSprite = this;
                _loc_2.init(this.x, this.y);
                this.health = _health + 0.5 > _loc_1 ? (_loc_1) : (_health + 0.5);
                ZG.sound(SoundManager.USE_AIDKIT, this);
                log(Text.CON_AUTO_USE_AIDKIT);
            }
            return;
        }// end function

        private function onWalkInit() : Boolean
        {
            this._joint.EnableLimit(false);
            return true;
        }// end function

        private function onWalkAnim() : Boolean
        {
            var _loc_1:* = this._aLegs.scaleX;
            this.beginSetAnim();
            this._aLegs = $.animCache.getAnimation(Art.HERO_LEGS_WALK);
            this._aLegs.play();
            this._aLegs.scaleX = _loc_1;
            this.endSetAnim();
            return true;
        }// end function

        override public function render() : void
        {
            x = _body.GetPosition().x * Universe.DRAW_SCALE;
            y = _body.GetPosition().y * Universe.DRAW_SCALE;
            return;
        }// end function

        public function giveAidkit() : void
        {
            var _loc_1:String = this;
            var _loc_2:* = this._aidkit + 1;
            _loc_1._aidkit = _loc_2;
            ZG.playerGui.aidkit(this._aidkit);
            return;
        }// end function

        private function doAction() : void
        {
            if (!_isFree && this.isControl)
            {
                _universe.objects.callDistanceAction(_body.GetPosition().x, _body.GetPosition().y, null, false);
            }
            return;
        }// end function

        public function get armor() : Number
        {
            return this._armor;
        }// end function

        private function initPhysicBody(param1:Number, param2:Number) : void
        {
            var _loc_3:b2Body = null;
            var _loc_4:* = new b2BodyDef();
            var _loc_5:* = new b2PolygonDef();
            _loc_5.density = 0.1;
            _loc_5.friction = 0.01;
            _loc_5.restitution = 0.1;
            _loc_5.filter.groupIndex = 2;
            _loc_5.filter.categoryBits = 2;
            _loc_5.filter.maskBits = 4;
            _loc_5.SetAsBox(12 / Universe.DRAW_SCALE, 20 / Universe.DRAW_SCALE);
            _loc_4.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_4.fixedRotation = true;
            _loc_4.userData = this;
            _body = _universe.physics.CreateBody(_loc_4);
            _body.CreateShape(_loc_5);
            _body.SetMassFromShapes();
            _universe.playerBody = _body;
            this._wheel.init(param1, param2 + 20);
            this._wheel.parentObj = this;
            this._wheelBody = this._wheel.body;
            var _loc_6:* = new b2RevoluteJointDef();
            _loc_6.Initialize(this._wheelBody, _body, this._wheelBody.GetWorldCenter());
            this._joint = _universe.physics.CreateJoint(_loc_6) as b2RevoluteJoint;
            return;
        }// end function

        public function set isControl(param1:Boolean) : void
        {
            this._isControl = param1;
            if (!this._isControl && this.missionTime > 0)
            {
                this._timer.stop();
            }
            else if (this._isControl && this.missionTime > 0)
            {
                this._timer.start();
            }
            return;
        }// end function

        public function loadData() : void
        {
            var _loc_1:* = ZG.saveBox;
            this._weapon.kind = _loc_1.firstWeapon;
            this._weapon.charger = _loc_1.firstCharger;
            this._weapon.supply = _loc_1.firstSupply;
            if (_loc_1.secondWeapon != ShopBox.ITEM_UNDEFINED)
            {
                if (this._secondWeapon == null)
                {
                    this._secondWeapon = new Weapon();
                }
                this._secondWeapon.kind = _loc_1.secondWeapon;
                this._secondWeapon.charger = _loc_1.secondCharger;
                this._secondWeapon.supply = _loc_1.secondSupply;
            }
            else
            {
                this._secondWeapon = null;
            }
            _health = _loc_1.health;
            this._armor = _loc_1.armor;
            this._aidkit = _loc_1.aidKit;
            this._coins = _loc_1.coins;
            return;
        }// end function

        override public function get damage() : Number
        {
            return EXPLOSION_DAMAGE;
        }// end function

        private function beginSetAnim() : void
        {
            if (this._aLegs)
            {
                removeChild(this._aLegs);
            }
            if (this._aHand)
            {
                removeChild(this._aHand);
            }
            if (this._aBody)
            {
                removeChild(this._aBody);
            }
            if (this._aHead)
            {
                removeChild(this._aHead);
            }
            if (this._aWeapon)
            {
                removeChild(this._aWeapon);
            }
            return;
        }// end function

        public function takeCoins(param1:int = 1) : void
        {
            this._coins = this._coins - param1;
            ZG.playerGui.coins(this._coins);
            return;
        }// end function

        public function haveWeapon(param1:uint) : Boolean
        {
            return this._weapon.kind == param1 || this._secondWeapon != null && this._secondWeapon.kind == param1;
        }// end function

        private function selectNewSchedule() : void
        {
            switch(this._state)
            {
                case STATE_STAY:
                {
                    if (this._conditions.contains(CONDITION_JUMP))
                    {
                        this._schedule = this._schedules.getValue(SCHEDULE_JUMP);
                        this._state = STATE_JUMP;
                    }
                    else if (this._conditions.contains(CONDITION_FALL))
                    {
                        this._schedule = this._schedules.getValue(SCHEDULE_FALL);
                        this._state = STATE_FALL;
                    }
                    else if (this._conditions.contains(CONDITION_WALK))
                    {
                        this._schedule = this._schedules.getValue(SCHEDULE_WALK);
                        this._state = STATE_WALK;
                    }
                    break;
                }
                case STATE_WALK:
                {
                    if (this._conditions.contains(CONDITION_STAY))
                    {
                        this._schedule = this._schedules.getValue(SCHEDULE_STAY);
                        this._state = STATE_STAY;
                    }
                    else if (this._conditions.contains(CONDITION_FALL))
                    {
                        this._schedule = this._schedules.getValue(SCHEDULE_FALL);
                        this._state = STATE_FALL;
                    }
                    else if (this._conditions.contains(CONDITION_JUMP))
                    {
                        this._schedule = this._schedules.getValue(SCHEDULE_JUMP);
                        this._state = STATE_JUMP;
                    }
                    break;
                }
                case STATE_FALL:
                {
                    if (this._conditions.contains(CONDITION_STAY))
                    {
                        this._schedule = this._schedules.getValue(SCHEDULE_STAY);
                        this._state = STATE_STAY;
                    }
                    else if (this._conditions.contains(CONDITION_WALK))
                    {
                        this._schedule = this._schedules.getValue(SCHEDULE_WALK);
                        this._state = STATE_WALK;
                    }
                    break;
                }
                case STATE_JUMP:
                {
                    if (this._conditions.contains(CONDITION_STAY))
                    {
                        this._schedule = this._schedules.getValue(SCHEDULE_STAY);
                        this._state = STATE_STAY;
                    }
                    else if (this._conditions.contains(CONDITION_WALK))
                    {
                        this._schedule = this._schedules.getValue(SCHEDULE_WALK);
                        this._state = STATE_WALK;
                    }
                    else if (this._conditions.contains(CONDITION_FALL))
                    {
                        this._schedule = this._schedules.getValue(SCHEDULE_FALL);
                        this._state = STATE_FALL;
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

        public function pickupWeapon(param1:uint, param2:uint = 0) : void
        {
            var _loc_3:CollectableItem = null;
            if (this._secondWeapon == null)
            {
                this._secondWeapon = new Weapon();
                this._secondWeapon.kind = param1;
                this._secondWeapon.charger = 0;
                this._secondWeapon.supply = param2;
                this.loadAmmo();
                this.switchWeapon();
                ZG.sound(SoundManager.WEAPON_PICKUP, this);
            }
            else if (this._weapon.kind != param1)
            {
                _loc_3 = CollectableItem.get();
                _loc_3.variety = this._weapon.kind;
                _loc_3.init(this.x, this.y, Amath.random(-60, 60), this._aWeapon.scaleX);
                _loc_3.ammoSupply = this._weapon.charger + this._weapon.supply;
                _loc_3.body.ApplyImpulse(new b2Vec2(this._aWeapon.scaleX < 0 ? (-0.2) : (0.2), -0.3), _loc_3.body.GetWorldCenter());
                this._weapon.kind = param1;
                this._weapon.charger = 0;
                this._weapon.supply = param2;
                this.loadAmmo();
                this.updateWeapon();
                ZG.sound(SoundManager.WEAPON_PICKUP, this);
            }
            return;
        }// end function

        public function isNeedAmmo() : Boolean
        {
            var _loc_1:* = this._weapon.supply <= this._weapon.chargerCapacity ? (true) : (false);
            if (this._secondWeapon != null)
            {
                _loc_1 = this._secondWeapon.supply <= this._secondWeapon.chargerCapacity ? (true) : (false);
            }
            return _loc_1;
        }// end function

        private function doShowHint() : void
        {
            if (_isDead)
            {
                ZG.playerGui.motivation(Motivation.MOTI_RESPAWN);
            }
            return;
        }// end function

        public function set health(param1:Number) : void
        {
            _health = param1 <= 0.01 ? (0) : (param1);
            ZG.playerGui.health(_health);
            return;
        }// end function

        public function get isControl() : Boolean
        {
            return this._isControl;
        }// end function

        private function loadAmmo() : void
        {
            var _loc_1:* = this._weapon.chargerCapacity - this._weapon.charger;
            _loc_1 = this._weapon.supply < _loc_1 ? (this._weapon.supply) : (_loc_1);
            this._weapon.supply = this._weapon.supply - _loc_1;
            this._weapon.charger = this._weapon.charger + _loc_1;
            ZG.playerGui.charger(this._weapon.charger);
            ZG.playerGui.supply(this._weapon.supply);
            return;
        }// end function

        public function resetMissions() : void
        {
            this.missionCoin = 0;
            this.missionZombie = 0;
            this.missionTime = 0;
            this.missionRobot = 0;
            this.missionBoom = 0;
            this.missionShoping = 0;
            this.missionBarrel = 0;
            this.missionMegaKill = 0;
            this.missionShot = 0;
            this.missionChest = 0;
            this.missionBox = 0;
            this.missionSkeleton = 0;
            this.missionBag = 0;
            if (ZG.playerGui.isHaveMission(LevelBase.MISSION_TIME))
            {
                var _loc_1:* = ZG.playerGui.getMissionValue(LevelBase.MISSION_TIME);
                this.missionTime = ZG.playerGui.getMissionValue(LevelBase.MISSION_TIME);
                this._oldTime = _loc_1;
                this._timer.start();
            }
            return;
        }// end function

        public function set supply(param1:int) : void
        {
            this._weapon.supply = param1;
            ZG.playerGui.supply(param1);
            return;
        }// end function

        public function saveData() : void
        {
            var _loc_1:* = ZG.saveBox;
            _loc_1.firstWeapon = this._weapon.kind;
            _loc_1.firstCharger = this._weapon.charger;
            _loc_1.firstSupply = this._weapon.supply;
            if (this._secondWeapon != null)
            {
                _loc_1.secondWeapon = this._secondWeapon.kind;
                _loc_1.secondCharger = this._secondWeapon.charger;
                _loc_1.secondSupply = this._secondWeapon.supply;
            }
            else
            {
                _loc_1.secondWeapon = ShopBox.ITEM_UNDEFINED;
                _loc_1.secondCharger = 0;
                _loc_1.secondSupply = 0;
            }
            _loc_1.health = this.health;
            _loc_1.armor = this.armor;
            _loc_1.aidKit = this._aidkit;
            _loc_1.coins = this._coins;
            _loc_1.haveData = true;
            return;
        }// end function

        override public function explode(param1:BasicObject, param2:b2Vec2, param3:b2Vec2) : Boolean
        {
            var _loc_4:Number = NaN;
            var _loc_5:EffectBlood = null;
            var _loc_6:int = 0;
            if (!_isFree)
            {
                _loc_4 = Amath.distance(param1.body.GetPosition().x, param1.body.GetPosition().y, _body.GetPosition().x, _body.GetPosition().y);
                if (_loc_4 > 4.5)
                {
                    return true;
                }
                this._hitPoint = new b2Vec2(param2.x, param2.y);
                this._hitForce = new b2Vec2(param3.x, param3.y);
                this.hurt(param1.damage / _loc_4 * 0.4);
                _loc_6 = 0;
                while (_loc_6 < 2)
                {
                    
                    _loc_5 = EffectBlood.get();
                    _loc_5.speed = new Avector(Amath.random(1, 5), Amath.random(-1, -5));
                    _loc_5.speed.x = param1.body.GetPosition().x < _body.GetPosition().x ? (_loc_5.speed.x) : (_loc_5.speed.x * -1);
                    _loc_5.init(param2.x * Universe.DRAW_SCALE, param2.y * Universe.DRAW_SCALE);
                    _loc_6++;
                }
                if (this.health == 0)
                {
                    this.makeDeadBody(this.x, this.y);
                    this.free();
                }
            }
            return true;
        }// end function

        private function aimToMouse() : void
        {
            if (!this.isControl)
            {
                return;
            }
            var _loc_1:Number = 0;
            var _loc_2:* = Amath.getAngleDeg(this.x + this._aWeapon.x, this.y + this._aWeapon.y, _universe.w_mouseX, _universe.w_mouseY - 5, true);
            if (_loc_2 > 270 || _loc_2 < 90)
            {
                if (this._aWeapon.scaleX < 0)
                {
                    this._aWeapon.scaleX = 1;
                    this._aWeapon.x = -WEAPON_X;
                    this._aHead.scaleX = 1;
                    this._aHead.x = -HEAD_X;
                    _loc_1 = Amath.getAngleDeg(this.x + this._aHead.x, this.y + this._aHead.y + this._offset, _universe.w_mouseX, _universe.w_mouseY, true);
                    _loc_1 = _loc_1 > 270 && _loc_1 < 310 ? (310) : (_loc_1);
                    _loc_1 = _loc_1 < 90 && _loc_1 > 45 ? (45) : (_loc_1);
                    this._aHead.rotation = _loc_1;
                    this._aBody.scaleX = 1;
                    this._aHand.scaleX = 1;
                    this._aHand.x = this._aWeapon.x;
                }
                this._aBody.y = this._offset;
                this._aHead.y = HEAD_Y + this._offset;
                this._aWeapon.y = WEAPON_Y + this._offset;
                this._aHand.y = this._aWeapon.y;
                this._aWeapon.rotation = Amath.getAngleDeg(this.x - WEAPON_X, this.y + WEAPON_Y + this._offset, _universe.w_mouseX, _universe.w_mouseY, true);
                this._aHand.rotation = this._aWeapon.rotation;
                _loc_2 = Amath.getAngleDeg(this.x + this._aHead.x, this.y + this._aHead.y, _universe.w_mouseX, _universe.w_mouseY, true);
                if (_loc_2 > 310 && _loc_2 < 360 || _loc_2 > 0 && _loc_2 < 45)
                {
                    this._aHead.rotation = _loc_2;
                }
            }
            else if (_loc_2 < 270 && _loc_2 > 90)
            {
                if (this._aWeapon.scaleX > 0)
                {
                    this._aWeapon.scaleX = -1;
                    this._aWeapon.x = WEAPON_X;
                    this._aHead.x = HEAD_X;
                    this._aHead.scaleX = -1;
                    _loc_1 = Amath.getAngleDeg(this.x + this._aHead.x, this.y + this._aHead.y + this._offset, _universe.w_mouseX, _universe.w_mouseY, true);
                    _loc_1 = _loc_1 < 270 && _loc_1 > 220 ? (220) : (_loc_1);
                    _loc_1 = _loc_1 > 90 && _loc_1 < 135 ? (135) : (_loc_1);
                    this._aHead.rotation = _loc_1 - 180;
                    this._aBody.scaleX = -1;
                    this._aHand.scaleX = -1;
                    this._aHand.x = this._aWeapon.x;
                }
                this._aBody.y = this._offset;
                this._aHead.y = HEAD_Y + this._offset;
                this._aWeapon.y = WEAPON_Y + this._offset;
                this._aHand.y = this._aWeapon.y;
                this._aWeapon.rotation = Amath.getAngleDeg(this.x + this._aWeapon.x, this.y + this._aWeapon.y, _universe.w_mouseX, _universe.w_mouseY, true) - 180;
                this._aHand.rotation = this._aWeapon.rotation;
                _loc_2 = Amath.getAngleDeg(this.x + this._aHead.x, this.y + this._aHead.y, _universe.w_mouseX, _universe.w_mouseY, true);
                if (_loc_2 < 220 && _loc_2 > 135)
                {
                    this._aHead.rotation = _loc_2 - 180;
                }
            }
            return;
        }// end function

        override public function attacked(param1:b2Vec2, param2:b2Vec2, param3:Number = 1) : Boolean
        {
            var _loc_4:EffectBlow = null;
            var _loc_5:EffectBlood = null;
            var _loc_6:uint = 0;
            if (!_isFree)
            {
                this.hurt(param3);
                if (this.health == 0)
                {
                    this._hitPoint = new b2Vec2(param1.x, param1.y);
                    this._hitForce = new b2Vec2(param2.x, param2.y);
                    this.makeDeadBody(this.x, this.y);
                    this.free();
                }
                _loc_4 = EffectBlow.get();
                _loc_4.init(param1.x * Universe.DRAW_SCALE, param1.y * Universe.DRAW_SCALE);
                _loc_6 = 0;
                while (_loc_6 < 2)
                {
                    
                    _loc_5 = EffectBlood.get();
                    _loc_5.speed = new Avector(Amath.random(1, 5), Amath.random(-1, -5));
                    _loc_5.speed.x = this._aBody.scaleX < 0 ? (_loc_5.speed.x) : (_loc_5.speed.x * -1);
                    _loc_5.init(param1.x * Universe.DRAW_SCALE, param1.y * Universe.DRAW_SCALE);
                    _loc_6 = _loc_6 + 1;
                }
            }
            return true;
        }// end function

        public function get supply() : int
        {
            return this._weapon.supply;
        }// end function

        private function onStay() : Boolean
        {
            _body.SetLinearVelocity(new b2Vec2(0, _body.GetLinearVelocity().y));
            return false;
        }// end function

        private function reloadCompleteHandler(event:Event = null) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            if (this._isReloading)
            {
                this._aWeapon.removeEventListener(Event.COMPLETE, this.reloadCompleteHandler);
                this._isReloading = false;
                if (!_isFree)
                {
                    _loc_2 = this._aWeapon.x;
                    _loc_3 = this._aWeapon.y;
                    removeChild(this._aWeapon);
                    this._aWeapon = ZG.animCache.getAnimation(this._weapon.shootAnim);
                    this._aWeapon.x = _loc_2;
                    this._aWeapon.y = _loc_3;
                    this._aWeapon.smoothing = this._smoothing;
                    addChild(this._aWeapon);
                    this.aimToMouse();
                    this.loadAmmo();
                }
            }
            return;
        }// end function

        private function onFall() : Boolean
        {
            var _loc_3:b2Vec2 = null;
            if (ZG.key.isDown(KeyCode.LEFT) || ZG.key.isDown(KeyCode.A))
            {
                if (this._aLegs.scaleX == 1)
                {
                    this._aLegs.scaleX = -1;
                }
                if (_body.GetLinearVelocity().x > -5)
                {
                    _body.ApplyImpulse(new b2Vec2(-0.5, 0), _body.GetWorldCenter());
                }
            }
            else if (ZG.key.isDown(KeyCode.RIGHT) || ZG.key.isDown(KeyCode.D))
            {
                if (this._aLegs.scaleX == -1)
                {
                    this._aLegs.scaleX = 1;
                }
                if (_body.GetLinearVelocity().x < 5)
                {
                    _body.ApplyImpulse(new b2Vec2(0.5, 0), _body.GetWorldCenter());
                }
            }
            else
            {
                _loc_3 = _body.GetLinearVelocity();
                if (_loc_3.x != 0)
                {
                    _loc_3.x = 0;
                    _body.SetLinearVelocity(_loc_3);
                }
            }
            var _loc_1:int = 1;
            var _loc_2:* = int(_body.GetLinearVelocity().y);
            if (_loc_2 >= 0)
            {
                _loc_1 = _loc_2 < 5 ? (10 + _loc_2) : (15);
                _loc_1 = _loc_1 > 15 ? (15) : (_loc_1);
            }
            else if (_loc_2 < 0)
            {
                _loc_1 = _loc_2 > -10 ? (10 + _loc_2) : (1);
                _loc_1 = _loc_1 == 0 ? (10) : (_loc_1);
            }
            this._aLegs.gotoAndStop(_loc_1);
            if (_contacts.length > 0)
            {
                return true;
            }
            return false;
        }// end function

    }
}
