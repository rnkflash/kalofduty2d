package com.zombotron.core
{
    import Box2D.Collision.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.anim.*;
    import com.antkarlov.cache.*;
    import com.antkarlov.controllers.*;
    import com.antkarlov.debug.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.antkarlov.repositories.*;
    import com.zombotron.controllers.*;
    import com.zombotron.effects.*;
    import com.zombotron.events.*;
    import com.zombotron.gui.*;
    import com.zombotron.helpers.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;
    import com.zombotron.listeners.*;
    import com.zombotron.objects.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class Universe extends Sprite
    {
        public var effects:EffectController;
        private var _explosionNum:int = 0;
        private var _playerSpirit:EffectCollectableItem;
        private var _lastKillNum:int = 0;
        public var objects:ObjectController;
        private var _tm:TaskManager;
        private var _layerFrontEffects:Sprite;
        public var w_mouseX:int = 0;
        public var w_mouseY:int = 0;
        private var _layerDebug:Sprite;
        public var playerBody:b2Body;
        private var $:Global;
        public var joints:JointController;
        private var _isRestarting:Boolean = false;
        public var background:Background;
        private var _haveCheckpoint:Boolean = false;
        private var _layerMain:Sprite;
        public var physics:b2World;
        private var _layerMainFg:Sprite;
        private var _layerEffects:Sprite;
        private var _layerBack:Sprite;
        private var _quakePos:Avector;
        private var _checkpointPosition:Avector;
        public var smoothing:Boolean = true;
        private var _layerBackObjects:Sprite;
        private var _animProcessor:AnimationProcessor;
        private var _explosionTime:int = 0;
        public var level:LevelBase;
        private var _quakeStarted:Boolean = false;
        private var _quakeDelay:int = 0;
        public var deads:DeadController;
        private var _quakeList:Array;
        public var ragdollStorage:Repository;
        public var cacheStorage:CacheManager;
        public var s_mouseX:int = 0;
        public var s_mouseY:int = 0;
        private var _playTime:int = 0;
        private var _checkpointTarget:String = "null";
        public var triggers:TriggerController;
        public var bodies:BodyController;
        private var _isStopped:Boolean = true;
        public var items:ItemController;
        private var _spiritMode:Boolean = false;
        public var frameTime:int = 1000;
        public var isMouseDown:Boolean = false;
        public var layerDraws:Sprite;
        private var _silentKillTime:int = 0;
        private var _lastKillTime:int = 0;
        public var player:Player;
        public var mouseDown:Boolean = false;
        private var _quakeIndex:int = 0;
        private var _currentMoti:int = 0;
        private var _layerFront:Sprite;
        public static const LAYER_FG_EFFECTS:int = 6;
        public static const TIME_STEP:Number = 0.025;
        public static const LAYER_MAIN:int = 2;
        public static const LAYER_BG_OBJECTS:int = 1;
        public static const DRAW_SCALE:Number = 30;
        public static const LAYER_FG:int = 5;
        public static const LAYER_BG:int = 0;
        public static const LAYER_EFFECTS:int = 4;
        public static const ITERATIONS:int = 15;
        public static const LAYER_MAIN_FG:int = 3;
        private static var _instance:Universe = null;

        public function Universe()
        {
            this.$ = Global.getInstance();
            this._tm = new TaskManager();
            this._quakeList = [];
            this._quakePos = new Avector();
            this._checkpointPosition = new Avector();
            if (_instance != null)
            {
                throw "Universe.as is a singleton class. Use Universe.getInstance();";
            }
            _instance = this;
            if (stage)
            {
                this.init();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, this.init);
            }
            return;
        }// end function

        public function checkAchievement(param1:uint) : void
        {
            var _loc_2:* = ZG.saveBox;
            var _loc_3:Array = [param1];
            if (param1 == 0)
            {
                _loc_3[0] = AchievementItem.SECOND_BLOOD;
                _loc_3.push(AchievementItem.BUTCHER);
                _loc_3.push(AchievementItem.TASTE_IRON);
                _loc_3.push(AchievementItem.TINMAN);
                _loc_3.push(AchievementItem.UNDEAD_KILLER);
            }
            var _loc_4:* = _loc_3.length;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_4)
            {
                
                param1 = _loc_3[_loc_5];
                switch(param1)
                {
                    case AchievementItem.SECOND_BLOOD:
                    {
                        if (!_loc_2.isHaveAchievement(param1) && _loc_2.zombiesKilled >= Kind.ACHI_SECOND_KILL)
                        {
                            ZG.playerGui.achievement(param1);
                        }
                        break;
                    }
                    case AchievementItem.BUTCHER:
                    {
                        if (!_loc_2.isHaveAchievement(param1) && _loc_2.zombiesKilled >= Kind.ACHI_BUTCHER)
                        {
                            ZG.playerGui.achievement(param1);
                        }
                        break;
                    }
                    case AchievementItem.TASTE_IRON:
                    {
                        if (!_loc_2.isHaveAchievement(param1) && _loc_2.robotsKilled >= Kind.ACHI_TASTE_IRON)
                        {
                            ZG.playerGui.achievement(param1);
                        }
                        break;
                    }
                    case AchievementItem.TINMAN:
                    {
                        if (!_loc_2.isHaveAchievement(param1) && _loc_2.robotsKilled >= Kind.ACHI_TINMAN)
                        {
                            ZG.playerGui.achievement(param1);
                        }
                        break;
                    }
                    case AchievementItem.BIG_MONEY:
                    {
                        if (!_loc_2.isHaveAchievement(param1) && ZG.saveBox.totalCoins >= Kind.ACHI_BIG_MONEY)
                        {
                            ZG.playerGui.achievement(param1);
                        }
                        break;
                    }
                    case AchievementItem.SILENT_KILLER:
                    {
                        if (!_loc_2.isHaveAchievement(param1) && _loc_2.silentKills >= Kind.ACHI_SILENT_KILLER)
                        {
                            ZG.playerGui.achievement(param1);
                        }
                        break;
                    }
                    case AchievementItem.BOMBERMAN:
                    {
                        if (!_loc_2.isHaveAchievement(param1) && _loc_2.explodedEnemies >= Kind.ACHI_BOMBERMAN)
                        {
                            ZG.playerGui.achievement(param1);
                        }
                        break;
                    }
                    case AchievementItem.UNDEAD_KILLER:
                    {
                        if (!_loc_2.isHaveAchievement(param1) && _loc_2.skeletonsKilled >= Kind.ACHI_UNDEAD_KILLER)
                        {
                            ZG.playerGui.achievement(param1);
                        }
                        break;
                    }
                    case AchievementItem.TREASURE_HUNTER:
                    {
                        if (!_loc_2.isHaveAchievement(param1) && _loc_2.foundedSecrets >= Kind.ACHI_TREASURE_HUNTER)
                        {
                            ZG.playerGui.achievement(param1);
                        }
                        break;
                    }
                    case AchievementItem.WINNER:
                    {
                        if (!_loc_2.isHaveAchievement(param1) && _loc_2.bossKilled >= Kind.ACHI_WINNER)
                        {
                            ZG.playerGui.achievement(param1);
                        }
                        break;
                    }
                    case AchievementItem.CAREFUL:
                    {
                        if (!_loc_2.isHaveAchievement(param1) && _loc_2.careful >= Kind.ACHI_CAREFUL)
                        {
                            ZG.playerGui.achievement(param1);
                        }
                        break;
                    }
                    case AchievementItem.EXTERMINATOR:
                    {
                        if (!_loc_2.isHaveAchievement(param1) && _loc_2.exterminator >= Kind.ACHI_EXTERMINATOR)
                        {
                            ZG.playerGui.achievement(param1);
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_5++;
            }
            return;
        }// end function

        public function stop() : void
        {
            if (!this._isStopped)
            {
                this._isStopped = true;
                ZG.saveBox.playTime = ZG.saveBox.playTime + (getTimer() - this._playTime);
            }
            return;
        }// end function

        public function giveControl() : void
        {
            if (this.player != null)
            {
                this.player.isControl = true;
            }
            return;
        }// end function

        private function init(event:Event = null) : void
        {
            this._animProcessor = AnimationProcessor.getInstance();
            this._layerBack = new Sprite();
            this._layerBackObjects = new Sprite();
            this._layerMain = new Sprite();
            this._layerMainFg = new Sprite();
            this._layerEffects = new Sprite();
            this._layerFront = new Sprite();
            this._layerFrontEffects = new Sprite();
            if (ZG.debugMode)
            {
                this._layerDebug = new Sprite();
                this.layerDraws = new Sprite();
            }
            addChild(this._layerBack);
            addChild(this._layerBackObjects);
            addChild(this._layerMain);
            addChild(this._layerMainFg);
            addChild(this._layerEffects);
            addChild(this._layerFront);
            addChild(this._layerFrontEffects);
            this.initPhysics();
            this.objects = new ObjectController();
            this.joints = new JointController();
            this.effects = new EffectController();
            this.deads = new DeadController();
            this.bodies = new BodyController();
            this.items = new ItemController();
            this.triggers = new TriggerController();
            ZG.console.register(this.debugGetCache, "get_cache", "- shows contents of cacheManager object.");
            ZG.console.register(this.debugAction, "action", "[alias] - call action method to object with specified alias.");
            ZG.console.register(this.debugObject, "object", "[alias] - shows attributes of the object.");
            ZG.console.register(this.debugObjects, "objects", "- shows list of objects.");
            ZG.console.register(this.debugCoins, "coins", "[num] - give NUM coins to hero.");
            ZG.console.register(this.debugEquip, "equip", "[num] - specified equip to hero.");
            if (ZG.debugMode)
            {
                ZG.key.register(this.debugDraw, KeyCode.G);
            }
            this.ragdollStorage = new Repository();
            this.ragdollStorage.setValue(EnemyZombie.RAGDOLL_NAME, new Ragdoll("ZombieRagdoll_mc"));
            this.ragdollStorage.setValue(EnemyZombieBomb.RAGDOLL_NAME, new Ragdoll("ZombieBombRagdoll_mc"));
            this.ragdollStorage.setValue(EnemyRobotPick.RAGDOLL_NAME, new Ragdoll("RobotRagdoll_mc"));
            this.ragdollStorage.setValue(Truck.RAGDOLL_NAME, new Ragdoll("TruckRagdoll_mc"));
            this.ragdollStorage.setValue(Trailer.RAGDOLL_NAME, new Ragdoll("TrailerRagdoll_mc"));
            this.ragdollStorage.setValue(Cart.RAGDOLL_NAME, new Ragdoll("CartRagdoll_mc"));
            this.ragdollStorage.setValue(EnemySkeleton.RAGDOLL_NAME, new Ragdoll("SkeletonRagdoll_mc"));
            this.ragdollStorage.setValue(Boss.RAGDOLL_NAME, new Ragdoll("BossRagdoll_mc"));
            this.ragdollStorage.setValue(Stone.RAGDOLL_NAME1, new Ragdoll("Stone1Ragdoll_mc"));
            this.ragdollStorage.setValue(Stone.RAGDOLL_NAME2, new Ragdoll("Stone2Ragdoll_mc"));
            this.cacheStorage = new CacheManager();
            this.cacheStorage.addCache(EffectShoot.CACHE_NAME, EffectShoot, 1);
            this.cacheStorage.addCache(EffectHitTo.CACHE_NAME, EffectHitTo, 5);
            this.cacheStorage.addCache(EffectExplosion.CACHE_NAME, EffectExplosion, 1);
            this.cacheStorage.addCache(EffectBlood.CACHE_NAME, EffectBlood, 10);
            this.cacheStorage.addCache(EffectBulletCase.CACHE_NAME, EffectBulletCase, 5);
            this.cacheStorage.addCache(EffectBurn.CACHE_NAME, EffectBurn, 2);
            this.cacheStorage.addCache(EffectBurnSmall.CACHE_NAME, EffectBurnSmall, 2);
            this.cacheStorage.addCache(EffectBurnTiny.CACHE_NAME, EffectBurnTiny, 2);
            this.cacheStorage.addCache(EffectBlow.CACHE_NAME, EffectBlow, 2);
            this.cacheStorage.addCache(EffectElectroShock.CACHE_NAME, EffectElectroShock, 2);
            this.cacheStorage.addCache(EffectSpark.CACHE_NAME, EffectSpark, 5);
            this.cacheStorage.addCache(EffectCoin.CACHE_NAME, EffectCoin, 5);
            this.cacheStorage.addCache(EffectPixel.CACHE_NAME, EffectPixel, 3);
            this.cacheStorage.addCache(EffectHealth.CACHE_NAME, EffectHealth, 1);
            this.cacheStorage.addCache(EffectCollectableItem.CACHE_NAME, EffectCollectableItem, 5);
            this.cacheStorage.addCache(EffectDust.CACHE_NAME, EffectDust, 4);
            this.cacheStorage.addCache(EffectDustSmall.CACHE_NAME, EffectDustSmall, 4);
            this.cacheStorage.addCache(EffectSmokeGrenade.CACHE_NAME, EffectSmokeGrenade, 1);
            this.cacheStorage.addCache(EffectSmoke.CACHE_NAME, EffectSmoke, 1);
            this.cacheStorage.addCache(EffectFireballSmoke.CACHE_NAME, EffectFireballSmoke, 1);
            this.cacheStorage.addCache(Bullet.CACHE_NAME, Bullet, 5);
            this.cacheStorage.addCache(BulletGrenade.CACHE_NAME, BulletGrenade, 1);
            this.cacheStorage.addCache(Box.CACHE_NAME, Box, 5);
            this.cacheStorage.addCache(Barrel.CACHE_NAME, Barrel, 5);
            this.cacheStorage.addCache(BoxPart.CACHE_NAME, BoxPart, 10);
            this.cacheStorage.addCache(EnemyZombie.CACHE_NAME, EnemyZombie, 5);
            this.cacheStorage.addCache(ZombiePart.CACHE_NAME, ZombiePart, 10);
            this.cacheStorage.addCache(EnemyZombieBomb.CACHE_NAME, EnemyZombieBomb, 5);
            this.cacheStorage.addCache(ZombieBombPart.CACHE_NAME, ZombieBombPart, 5);
            this.cacheStorage.addCache(EnemyZombieArmor.CACHE_NAME, EnemyZombieArmor, 5);
            this.cacheStorage.addCache(HeroPart.CACHE_NAME, HeroPart, 5);
            this.cacheStorage.addCache(BarrelPart.CACHE_NAME, BarrelPart, 5);
            this.cacheStorage.addCache(CartWheel.CACHE_NAME, CartWheel, 4);
            this.cacheStorage.addCache(Backdoor.CACHE_NAME, Backdoor, 5);
            this.cacheStorage.addCache(WoodPlank.CACHE_NAME, WoodPlank, 5);
            this.cacheStorage.addCache(WoodPart.CACHE_NAME, WoodPart, 5);
            this.cacheStorage.addCache(Bridge.CACHE_NAME, Bridge, 5);
            this.cacheStorage.addCache(Coin.CACHE_NAME, Coin, 5);
            this.cacheStorage.addCache(DoorButton.CACHE_NAME, DoorButton, 3);
            this.cacheStorage.addCache(EnemyRobotPick.CACHE_NAME, EnemyRobotPick, 5);
            this.cacheStorage.addCache(EnemyRobotSpade.CACHE_NAME, EnemyRobotSpade, 5);
            this.cacheStorage.addCache(MiningRobotPart.CACHE_NAME, MiningRobotPart, 10);
            this.cacheStorage.addCache(CollectableItem.CACHE_NAME, CollectableItem, 5);
            this.cacheStorage.addCache(Chest.CACHE_NAME, Chest, 1);
            this.cacheStorage.addCache(Bomb.CACHE_NAME, Bomb, 1);
            this.cacheStorage.addCache(CartPart.CACHE_NAME, CartPart, 3);
            this.cacheStorage.addCache(EnemySkeleton.CACHE_NAME, EnemySkeleton, 3);
            this.cacheStorage.addCache(SkeletonPart.CACHE_NAME, SkeletonPart, 3);
            this.cacheStorage.addCache(Stone.CACHE_NAME, Stone, 1);
            this.cacheStorage.addCache(StonePart.CACHE_NAME, StonePart, 1);
            removeEventListener(Event.ADDED_TO_STAGE, this.init);
            return;
        }// end function

        private function initPhysics() : void
        {
            var _loc_2:b2DebugDraw = null;
            var _loc_1:* = new b2AABB();
            _loc_1.lowerBound.Set(-50, -50);
            _loc_1.upperBound.Set(150, 150);
            this.physics = new b2World(_loc_1, new b2Vec2(0, 20), true);
            if (ZG.debugMode)
            {
                _loc_2 = new b2DebugDraw();
                _loc_2.m_sprite = this._layerDebug;
                _loc_2.m_drawScale = DRAW_SCALE;
                _loc_2.m_fillAlpha = 0.1;
                _loc_2.m_lineThickness = 1;
                _loc_2.m_drawFlags = b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit;
                this.physics.SetDebugDraw(_loc_2);
            }
            this.physics.SetContactListener(new ContactListener());
            this.physics.SetDestructionListener(new DestructionListener());
            return;
        }// end function

        public function get isRestarting() : Boolean
        {
            return this._isRestarting;
        }// end function

        private function debugObjects() : void
        {
            this.objects.outputList();
            return;
        }// end function

        public function motiExplosion() : void
        {
            if (this.frameTime - this._explosionTime > 70)
            {
                this._explosionNum = 0;
            }
            var _loc_1:String = this;
            var _loc_2:* = this._explosionNum + 1;
            _loc_1._explosionNum = _loc_2;
            if (this.frameTime - this._explosionTime < 70 && this._explosionNum == 2)
            {
                ZG.playerGui.motivation(Motivation.MOTI_AWESOME_ACTION);
            }
            this._explosionTime = this.frameTime;
            return;
        }// end function

        public function respawn() : void
        {
            if (this._haveCheckpoint)
            {
                if (!this._spiritMode)
                {
                    this.takeControl();
                    this._playerSpirit = EffectCollectableItem.get();
                    this._playerSpirit.variety = ShopBox.ITEM_SPIRIT_PLAYER;
                    this._playerSpirit.init(this.playerBody.GetPosition().x * Universe.DRAW_SCALE, this.playerBody.GetPosition().y * Universe.DRAW_SCALE);
                    this._playerSpirit.angle = -45;
                    this._spiritMode = true;
                    this.objects.callAction(this._checkpointTarget, null, "Universe.respawn()");
                }
            }
            else
            {
                this.restartLevel();
            }
            return;
        }// end function

        public function clear() : void
        {
            ZG.saveBox.careful = 1;
            this.joints.clear();
            this.objects.clear();
            this.effects.clear();
            this.deads.clear();
            this.bodies.clear();
            this.items.clear();
            var _loc_1:* = this.physics.GetBodyList();
            while (_loc_1)
            {
                
                if (_loc_1.m_userData is IBasicObject)
                {
                    (_loc_1.m_userData as IBasicObject).free();
                }
                _loc_1 = _loc_1.m_next;
            }
            this.initPhysics();
            this.level.removeBitmaps();
            this._haveCheckpoint = false;
            this._spiritMode = false;
            return;
        }// end function

        private function debugGetCache() : void
        {
            var _loc_1:Array = [];
            this.cacheStorage.getList(_loc_1);
            this.$.trace("CacheManager contents: (" + _loc_1.length.toString() + ")", Console.FORMAT_DATA);
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                this.$.trace(_loc_1[_loc_2] + ": " + (this.cacheStorage.getCache(_loc_1[_loc_2]) as DefaultCache).size.toString(), Console.FORMAT_DATA);
                _loc_2++;
            }
            this.$.trace("", Console.FORMAT_DATA);
            return;
        }// end function

        public function spiritMakePlayer() : void
        {
            if (this._spiritMode)
            {
                this.player.init(this._checkpointPosition.x, this._checkpointPosition.y);
                this._spiritMode = false;
                this.giveControl();
            }
            return;
        }// end function

        public function motiSilentKill() : void
        {
            if (this.frameTime - this._silentKillTime > 70)
            {
                this._silentKillTime = this.frameTime;
                ZG.playerGui.motivation(Motivation.MOTI_SILENT_KILL);
            }
            return;
        }// end function

        public function start() : void
        {
            if (this._isStopped)
            {
                this._isStopped = false;
                this.updateScreenPosition();
                this._playTime = getTimer();
            }
            return;
        }// end function

        private function debugDraw() : void
        {
            if (!ZG.debugMode || ZG.console.enabled)
            {
                return;
            }
            if (contains(this._layerDebug))
            {
                removeChild(this._layerDebug);
                removeChild(this.layerDraws);
            }
            else
            {
                addChild(this._layerDebug);
                addChild(this.layerDraws);
            }
            return;
        }// end function

        private function debugAction(param1:String = "") : void
        {
            if (param1 != "")
            {
                this.objects.callAction(param1, null, "console");
            }
            else
            {
                this.$.trace("(!) must specify an alias", Console.FORMAT_ERROR);
            }
            return;
        }// end function

        public function process() : void
        {
            if (!this._isStopped)
            {
                var _loc_1:String = this;
                var _loc_2:* = this.frameTime + 1;
                _loc_1.frameTime = _loc_2;
                this._animProcessor.process();
                this.physics.Step(TIME_STEP, ITERATIONS);
                this.scroll();
                if (ZG.debugMode)
                {
                    this.layerDraws.graphics.clear();
                }
                this.gameStep();
                this.quakeProcess();
                if (ZG.key.isDown(KeyCode.SPACEBAR) && this.player.isDead)
                {
                    this.respawn();
                }
            }
            ZG.media.process();
            return;
        }// end function

        private function debugObject(param1:String = "") : void
        {
            if (param1 != "")
            {
                this.objects.outputInfo(param1);
            }
            else
            {
                this.$.trace("(!) must specify an alias", Console.FORMAT_ERROR);
            }
            return;
        }// end function

        public function getCheckpoint() : Avector
        {
            if (this._haveCheckpoint)
            {
                return this._checkpointPosition;
            }
            return null;
        }// end function

        public function setCheckpoint(param1:String, param2:String, param3:Avector) : void
        {
            this._haveCheckpoint = true;
            this._checkpointTarget = param2;
            this._checkpointPosition = param3;
            return;
        }// end function

        private function debugCoins(param1:uint = 0) : void
        {
            if (param1 > 100)
            {
                this.$.trace("Available maximum 100 coins.", Console.FORMAT_ERROR);
                return;
            }
            if (this.player.coins >= 500)
            {
                this.$.trace("You have reached the maximum amount of money", Console.FORMAT_ERROR);
                return;
            }
            this.player.coins = param1;
            ZG.console.close();
            return;
        }// end function

        public function remove(param1:DisplayObject, param2:int = 2) : void
        {
            switch(param2)
            {
                case LAYER_BG:
                {
                    this._layerBack.removeChild(param1);
                    break;
                }
                case LAYER_BG_OBJECTS:
                {
                    this._layerBackObjects.removeChild(param1);
                    break;
                }
                case LAYER_MAIN:
                {
                    this._layerMain.removeChild(param1);
                    break;
                }
                case LAYER_MAIN_FG:
                {
                    this._layerMainFg.removeChild(param1);
                    break;
                }
                case LAYER_EFFECTS:
                {
                    this._layerEffects.removeChild(param1);
                    break;
                }
                case LAYER_FG:
                {
                    this._layerFront.removeChild(param1);
                    break;
                }
                case LAYER_FG_EFFECTS:
                {
                    this._layerFrontEffects.removeChild(param1);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function debugEquip(param1:int) : void
        {
            var _loc_2:int = 0;
            var _loc_3:CollectableItem = null;
            switch(param1)
            {
                case 1:
                {
                    _loc_3 = CollectableItem.get();
                    _loc_3.variety = ShopBox.ITEM_SHOTGUN;
                    _loc_3.init(this.player.x, this.player.y - 50);
                    _loc_2 = 0;
                    while (_loc_2 < 10)
                    {
                        
                        _loc_3 = CollectableItem.get();
                        _loc_3.variety = ShopBox.ITEM_AMMO_SHOTGUN;
                        _loc_3.init(this.player.x, this.player.y - 50);
                        _loc_2++;
                    }
                    ZG.console.close();
                    break;
                }
                case 2:
                {
                    _loc_3 = CollectableItem.get();
                    _loc_3.variety = ShopBox.ITEM_GUN;
                    _loc_3.init(this.player.x, this.player.y - 50);
                    _loc_2 = 0;
                    while (_loc_2 < 5)
                    {
                        
                        _loc_3 = CollectableItem.get();
                        _loc_3.variety = ShopBox.ITEM_AMMO_GUN;
                        _loc_3.init(this.player.x, this.player.y - 50);
                        _loc_2++;
                    }
                    ZG.console.close();
                    break;
                }
                case 3:
                {
                    _loc_3 = CollectableItem.get();
                    _loc_3.variety = ShopBox.ITEM_GRENADEGUN;
                    _loc_3.init(this.player.x, this.player.y - 50);
                    _loc_2 = 0;
                    while (_loc_2 < 5)
                    {
                        
                        _loc_3 = CollectableItem.get();
                        _loc_3.variety = ShopBox.ITEM_AMMO_GRENADEGUN;
                        _loc_3.init(this.player.x, this.player.y - 50);
                        _loc_2++;
                    }
                    ZG.console.close();
                    break;
                }
                case 4:
                {
                    _loc_3 = CollectableItem.get();
                    _loc_3.variety = ShopBox.ITEM_MACHINEGUN;
                    _loc_3.init(this.player.x, this.player.y - 50);
                    _loc_2 = 0;
                    while (_loc_2 < 5)
                    {
                        
                        _loc_3 = CollectableItem.get();
                        _loc_3.variety = ShopBox.ITEM_AMMO_MACHINEGUN;
                        _loc_3.init(this.player.x, this.player.y - 50);
                        _loc_2++;
                    }
                    ZG.console.close();
                    break;
                }
                default:
                {
                    this.$.trace("Undefined equip type.", Console.FORMAT_ERROR);
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function add(param1:DisplayObject, param2:int = 2) : void
        {
            switch(param2)
            {
                case LAYER_BG:
                {
                    this._layerBack.addChild(param1);
                    break;
                }
                case LAYER_BG_OBJECTS:
                {
                    this._layerBackObjects.addChild(param1);
                    break;
                }
                case LAYER_MAIN:
                {
                    this._layerMain.addChild(param1);
                    break;
                }
                case LAYER_MAIN_FG:
                {
                    this._layerMainFg.addChild(param1);
                    break;
                }
                case LAYER_EFFECTS:
                {
                    this._layerEffects.addChild(param1);
                    break;
                }
                case LAYER_FG:
                {
                    this._layerFront.addChild(param1);
                    break;
                }
                case LAYER_FG_EFFECTS:
                {
                    this._layerFrontEffects.addChild(param1);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function restartLevel() : void
        {
            if (ZG.console.enabled)
            {
                return;
            }
            this._isRestarting = true;
            if (this.physics.m_lock)
            {
                this._tm.addInstantTask(this.restartLevel);
                return;
            }
            ZG.media.musicReset();
            ZG.game.rebuildMissions();
            this.takeControl();
            this.stop();
            this.clear();
            this.player.isDead = false;
            this.level.load(false);
            this.playerBody = this.player.body;
            this.player.resetMissions();
            this.updateScreenPosition();
            this.start();
            this.giveControl();
            this._isRestarting = false;
            return;
        }// end function

        private function quakeProcess() : void
        {
            if (this._quakeStarted)
            {
                var _loc_1:String = this;
                var _loc_2:* = this._quakeDelay + 1;
                _loc_1._quakeDelay = _loc_2;
                if (this._quakeDelay > 3)
                {
                    var _loc_1:String = this;
                    var _loc_2:* = this._quakeIndex + 1;
                    _loc_1._quakeIndex = _loc_2;
                    if (this._quakeIndex >= this._quakeList.length)
                    {
                        this._quakeStarted = false;
                    }
                    else
                    {
                        this._quakePos.x = this._quakeList[this._quakeIndex].x;
                        this._quakePos.y = this._quakeList[this._quakeIndex].y;
                    }
                    this._quakeDelay = 0;
                }
                this.x = Amath.lerp(this.x + this._quakePos.x, this.x, 0.5);
                this.y = Amath.lerp(this.y + this._quakePos.y, this.y, 0.5);
            }
            return;
        }// end function

        public function motiFoundSecret() : void
        {
            ZG.playerGui.motivation(Motivation.MOTI_FOUND_SECRET);
            return;
        }// end function

        public function completeLevel(param1:int, param2:String) : void
        {
            this.takeControl();
            dispatchEvent(new CompleteLevelEvent(param1, param2, CompleteLevelEvent.LEVEL_COMPLETE));
            return;
        }// end function

        private function scroll() : void
        {
            var _loc_1:Number = 0;
            var _loc_2:Number = 0;
            var _loc_3:* = this.x;
            var _loc_4:* = this.y;
            if (this._spiritMode)
            {
                _loc_1 = (this.x - (-this._playerSpirit.positionX + App.SCR_HALF_W - this._playerSpirit.velocityX)) / 6;
                _loc_2 = (this.y - (-this._playerSpirit.positionY + App.SCR_HALF_H - this._playerSpirit.velocityY)) / 6;
            }
            else
            {
                _loc_1 = (this.x - ((-DRAW_SCALE) * this.playerBody.GetWorldCenter().x + App.SCR_HALF_W - this.playerBody.GetLinearVelocity().x)) / 6;
                _loc_2 = (this.y - ((-DRAW_SCALE) * this.playerBody.GetWorldCenter().y + App.SCR_HALF_H - this.playerBody.GetLinearVelocity().y)) / 6;
            }
            _loc_3 = _loc_3 - _loc_1;
            _loc_4 = _loc_4 - _loc_2;
            if (_loc_3 > 0)
            {
                _loc_3 = 0;
                _loc_1 = 0;
            }
            else if (Math.abs(_loc_3) > this.level.width - App.SCR_W)
            {
                _loc_3 = -this.level.width + App.SCR_W;
                _loc_1 = 0;
            }
            if (_loc_4 > 0)
            {
                _loc_4 = 0;
                _loc_2 = 0;
            }
            else if (Math.abs(_loc_4) > this.level.height - App.SCR_H)
            {
                _loc_4 = -this.level.height + App.SCR_H;
                _loc_2 = 0;
            }
            this.background.move(_loc_1, _loc_2);
            this.level.updatePosition(this.x, this.y);
            this.x = _loc_3;
            this.y = _loc_4;
            this.w_mouseX = this.x * -1 + this.s_mouseX;
            this.w_mouseY = this.y * -1 + this.s_mouseY;
            return;
        }// end function

        public function takeControl() : void
        {
            if (this.player != null)
            {
                this.player.isControl = false;
            }
            return;
        }// end function

        public function quake(param1:int = 4) : void
        {
            this._quakeList.length = 0;
            var _loc_2:* = Math.random();
            var _loc_3:int = 3;
            while (_loc_3 > 0)
            {
                
                if (_loc_3 % 2 == 0)
                {
                    if (_loc_2 > 0.5)
                    {
                        this._quakeList[this._quakeList.length] = {x:(-param1) * _loc_3, y:param1 * _loc_3};
                    }
                    else
                    {
                        this._quakeList[this._quakeList.length] = {x:param1 * _loc_3, y:param1 * _loc_3};
                    }
                }
                else if (_loc_2 > 0.5)
                {
                    this._quakeList[this._quakeList.length] = {x:param1 * _loc_3, y:(-param1) * _loc_3};
                }
                else
                {
                    this._quakeList[this._quakeList.length] = {x:(-param1) * _loc_3, y:(-param1) * _loc_3};
                }
                _loc_3 = _loc_3 - 1;
            }
            var _loc_4:int = 0;
            this._quakeIndex = 0;
            this._quakeDelay = _loc_4;
            this._quakePos.x = this._quakeList[this._quakeIndex].x;
            this._quakePos.y = this._quakeList[this._quakeIndex].y;
            this._quakeStarted = true;
            return;
        }// end function

        private function gameStep() : void
        {
            var _loc_1:IBasicObject = null;
            this.joints.process();
            this.effects.process();
            this.deads.process();
            this.objects.process();
            this.items.process();
            var _loc_2:* = this.physics.GetBodyList();
            while (_loc_2)
            {
                
                if (_loc_2.m_userData != null)
                {
                    _loc_1 = _loc_2.m_userData as IBasicObject;
                    if (_loc_1.kind != Kind.GROUND)
                    {
                        _loc_1.process();
                        _loc_1.render();
                    }
                }
                _loc_2 = _loc_2.m_next;
            }
            if (this._currentMoti != this._lastKillNum && this._lastKillNum >= 2 && this.frameTime - this._lastKillTime <= 10)
            {
                this._currentMoti = this._lastKillNum;
                if (this._lastKillNum == 2)
                {
                    ZG.playerGui.motivation(Motivation.MOTI_DOUBLE_KILL);
                }
                else if (this._lastKillNum == 3)
                {
                    ZG.playerGui.motivation(Motivation.MOTI_TRIPLE_KILL);
                }
                else if (this._lastKillNum == 4)
                {
                    ZG.playerGui.motivation(Motivation.MOTI_MULTI_KILL);
                }
                else if (this._lastKillNum == 5)
                {
                    ZG.playerGui.motivation(Motivation.MOTI_MEGA_KILL);
                    if (ZG.playerGui.isHaveMission(LevelBase.MISSION_MEGAKILL))
                    {
                        var _loc_3:* = this.player;
                        var _loc_4:* = this.player.missionMegaKill + 1;
                        _loc_3.missionMegaKill = _loc_4;
                        ZG.playerGui.updateMission(LevelBase.MISSION_MEGAKILL, this.player.missionMegaKill);
                    }
                }
            }
            return;
        }// end function

        private function updateScreenPosition() : void
        {
            var _loc_1:* = (-DRAW_SCALE) * this.playerBody.GetWorldCenter().x + App.SCR_HALF_W;
            var _loc_2:* = (-DRAW_SCALE) * this.playerBody.GetWorldCenter().y + App.SCR_HALF_H;
            _loc_1 = _loc_1 > 0 ? (0) : (_loc_1);
            _loc_2 = _loc_2 > 0 ? (0) : (_loc_2);
            _loc_1 = Math.abs(_loc_1) > this.level.width - App.SCR_W ? (-this.level.width + App.SCR_W) : (_loc_1);
            _loc_2 = Math.abs(_loc_2) > this.level.height - App.SCR_H ? (-this.level.height + App.SCR_H) : (_loc_2);
            this.x = _loc_1;
            this.y = _loc_2;
            return;
        }// end function

        public function makeCollectableItem(param1:uint, param2:int, param3:int, param4:int, param5:int = 1) : CollectableItem
        {
            var _loc_6:CollectableItem = null;
            var _loc_7:int = 0;
            while (_loc_7 < param2)
            {
                
                _loc_6 = CollectableItem.get();
                _loc_6.variety = param1;
                _loc_6.init(param3 + Amath.random(-10, 10), param4 + Amath.random(-10, 10), 0, param5);
                _loc_7++;
            }
            return _loc_6;
        }// end function

        public function motiKillEnemy() : void
        {
            if (this.frameTime - this._lastKillTime > 70)
            {
                this._currentMoti = -1;
                this._lastKillNum = 0;
            }
            this._lastKillTime = this.frameTime;
            var _loc_1:String = this;
            var _loc_2:* = this._lastKillNum + 1;
            _loc_1._lastKillNum = _loc_2;
            return;
        }// end function

        public static function getInstance() : Universe
        {
            return _instance ? (_instance) : (new Universe);
        }// end function

    }
}
