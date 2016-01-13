package com.zombotron.effects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.helpers.*;
    import com.zombotron.levels.*;

    public class EffectCollectableItem extends BasicEffect
    {
        private var _sparkInterval:int = 0;
        private var _pixel:EffectPixel;
        private var _variety:uint = 0;
        private var _speed:Avector;
        private var _enableAnim:Boolean = false;
        private var _angle:Number = 45;
        private var _pos:Avector;
        private var _angularVelocity:int = 10;
        private var _color:int = 0;
        private var _target:Avector;
        private var _rotationSpeed:int = 10;
        private var _curAnim:String = "";
        public static const CACHE_NAME:String = "EffectCollectableItem";

        public function EffectCollectableItem()
        {
            this._speed = new Avector();
            this._pos = new Avector();
            _cacheName = CACHE_NAME;
            this.updateSprite(Art.COLLECTABLE_ITEM);
            _layer = Universe.LAYER_FG_EFFECTS;
            return;
        }// end function

        private function giveItem() : void
        {
            switch(this._variety)
            {
                case ShopBox.ITEM_AIDKIT:
                {
                    _universe.player.giveAidkit();
                    break;
                }
                case ShopBox.ITEM_ARMOR:
                {
                    _universe.player.armor = 1;
                    break;
                }
                case ShopBox.ITEM_AMMO_PISTOL:
                case ShopBox.ITEM_AMMO_SHOTGUN:
                case ShopBox.ITEM_AMMO_GUN:
                case ShopBox.ITEM_AMMO_GRENADEGUN:
                case ShopBox.ITEM_AMMO_MACHINEGUN:
                {
                    _universe.player.giveAmmo(this._variety);
                    break;
                }
                case ShopBox.ITEM_HEAD_ZOMBIE:
                {
                    var _loc_1:* = _universe.player;
                    var _loc_2:* = _universe.player.missionZombie + 1;
                    _loc_1.missionZombie = _loc_2;
                    ZG.playerGui.updateMission(LevelBase.MISSION_ZOMBIE, _universe.player.missionZombie);
                    break;
                }
                case ShopBox.ITEM_HEAD_ROBOT:
                {
                    var _loc_1:* = _universe.player;
                    var _loc_2:* = _universe.player.missionRobot + 1;
                    _loc_1.missionRobot = _loc_2;
                    ZG.playerGui.updateMission(LevelBase.MISSION_ROBOT, _universe.player.missionRobot);
                    break;
                }
                case ShopBox.ITEM_SPIRIT_BOOM:
                {
                    var _loc_1:* = _universe.player;
                    var _loc_2:* = _universe.player.missionBoom + 1;
                    _loc_1.missionBoom = _loc_2;
                    ZG.playerGui.updateMission(LevelBase.MISSION_BOOM, _universe.player.missionBoom);
                    break;
                }
                case ShopBox.ITEM_SPIRIT_BARREL:
                {
                    var _loc_1:* = _universe.player;
                    var _loc_2:* = _universe.player.missionBarrel + 1;
                    _loc_1.missionBarrel = _loc_2;
                    ZG.playerGui.updateMission(LevelBase.MISSION_BARREL, _universe.player.missionBarrel);
                    break;
                }
                case ShopBox.ITEM_SPIRIT_BOX:
                {
                    var _loc_1:* = _universe.player;
                    var _loc_2:* = _universe.player.missionBox + 1;
                    _loc_1.missionBox = _loc_2;
                    ZG.playerGui.updateMission(LevelBase.MISSION_BOX, _universe.player.missionBox);
                    break;
                }
                case ShopBox.ITEM_SPIRIT_CHEST:
                {
                    var _loc_1:* = _universe.player;
                    var _loc_2:* = _universe.player.missionChest + 1;
                    _loc_1.missionChest = _loc_2;
                    ZG.playerGui.updateMission(LevelBase.MISSION_CHEST, _universe.player.missionChest);
                    break;
                }
                case ShopBox.ITEM_HEAD_SKELETON:
                {
                    var _loc_1:* = _universe.player;
                    var _loc_2:* = _universe.player.missionSkeleton + 1;
                    _loc_1.missionSkeleton = _loc_2;
                    ZG.playerGui.updateMission(LevelBase.MISSION_SKELETON, _universe.player.missionSkeleton);
                    break;
                }
                case ShopBox.ITEM_SPIRIT_PLAYER:
                {
                    _universe.spiritMakePlayer();
                    break;
                }
                case ShopBox.ITEM_BAG:
                {
                    var _loc_1:* = _universe.player;
                    var _loc_2:* = _universe.player.missionBag + 1;
                    _loc_1.missionBag = _loc_2;
                    ZG.playerGui.updateMission(LevelBase.MISSION_BAG, _universe.player.missionBag);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function set color(param1:int) : void
        {
            if (this._color != param1)
            {
                this._color = param1;
                _sprite.gotoAndStop(this._variety + this._color);
            }
            return;
        }// end function

        public function get positionX() : Number
        {
            return _sprite.x;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            this._target = ZG.playerGui.getCoinsPos();
            this._enableAnim = false;
            this._rotationSpeed = 10;
            this._angle = 45;
            switch(this._variety)
            {
                case ShopBox.ITEM_AIDKIT:
                {
                    this._target = ZG.playerGui.getAidkitPos();
                    ZG.sound(SoundManager.ITEM_COLLECT);
                    this.updateSprite(Art.COLLECTABLE_ITEM);
                    break;
                }
                case ShopBox.ITEM_ARMOR:
                {
                    this._target = ZG.playerGui.getArmorPos();
                    ZG.sound(SoundManager.ITEM_COLLECT);
                    this.updateSprite(Art.COLLECTABLE_ITEM);
                    break;
                }
                case ShopBox.ITEM_AMMO_PISTOL:
                case ShopBox.ITEM_AMMO_SHOTGUN:
                case ShopBox.ITEM_AMMO_GUN:
                case ShopBox.ITEM_AMMO_GRENADEGUN:
                case ShopBox.ITEM_AMMO_MACHINEGUN:
                {
                    this._target = ZG.playerGui.getAmmoPos();
                    ZG.sound(SoundManager.AMMO_COLLECT);
                    this.updateSprite(Art.COLLECTABLE_ITEM);
                    break;
                }
                case ShopBox.ITEM_HEAD_ZOMBIE:
                {
                    this._target = ZG.playerGui.getMissionTarget(LevelBase.MISSION_ZOMBIE);
                    ZG.sound(SoundManager.ITEM_COLLECT);
                    this.updateSprite(Art.COLLECTABLE_ITEM);
                    break;
                }
                case ShopBox.ITEM_HEAD_ROBOT:
                {
                    this._target = ZG.playerGui.getMissionTarget(LevelBase.MISSION_ROBOT);
                    ZG.sound(SoundManager.ITEM_COLLECT);
                    this.updateSprite(Art.COLLECTABLE_ITEM);
                    break;
                }
                case ShopBox.ITEM_SPIRIT_BOOM:
                {
                    this._target = ZG.playerGui.getMissionTarget(LevelBase.MISSION_BOOM);
                    this.updateSprite(Art.EFFECT_ITEM_LIGHT);
                    this._enableAnim = true;
                    break;
                }
                case ShopBox.ITEM_SPIRIT_BARREL:
                {
                    this._target = ZG.playerGui.getMissionTarget(LevelBase.MISSION_BARREL);
                    this.updateSprite(Art.EFFECT_ITEM_LIGHT);
                    this._enableAnim = true;
                    break;
                }
                case ShopBox.ITEM_SPIRIT_BOX:
                {
                    this._target = ZG.playerGui.getMissionTarget(LevelBase.MISSION_BOX);
                    this.updateSprite(Art.EFFECT_ITEM_LIGHT);
                    this._enableAnim = true;
                    break;
                }
                case ShopBox.ITEM_SPIRIT_CHEST:
                {
                    this._target = ZG.playerGui.getMissionTarget(LevelBase.MISSION_CHEST);
                    this.updateSprite(Art.EFFECT_ITEM_LIGHT);
                    this._enableAnim = true;
                    break;
                }
                case ShopBox.ITEM_HEAD_SKELETON:
                {
                    this._target = ZG.playerGui.getMissionTarget(LevelBase.MISSION_SKELETON);
                    ZG.sound(SoundManager.ITEM_COLLECT);
                    this.updateSprite(Art.COLLECTABLE_ITEM);
                    break;
                }
                case ShopBox.ITEM_SPIRIT_PLAYER:
                {
                    this._target = _universe.getCheckpoint();
                    this._angle = this._target.y > param2 ? (-45) : (45);
                    this.updateSprite(Art.EFFECT_ITEM_LIGHT);
                    this._enableAnim = true;
                    this._rotationSpeed = 10;
                    break;
                }
                case ShopBox.ITEM_BAG:
                {
                    this._target = ZG.playerGui.getMissionTarget(LevelBase.MISSION_BAG);
                    ZG.sound(SoundManager.ITEM_COLLECT);
                    this.updateSprite(Art.COLLECTABLE_ITEM);
                    break;
                }
                default:
                {
                    break;
                }
            }
            _sprite.x = param1;
            _sprite.y = param2;
            _sprite.smoothing = _universe.smoothing;
            if (this._enableAnim)
            {
                _sprite.play();
            }
            else
            {
                _sprite.gotoAndStop(this._variety);
            }
            _sprite.rotation = param3;
            this._angularVelocity = Amath.random(-10, 10);
            addChild(_sprite);
            _universe.add(this, _layer);
            _universe.effects.add(this);
            _isFree = false;
            this._color = 0;
            return;
        }// end function

        public function get velocityY() : Number
        {
            return this._speed.y;
        }// end function

        public function get velocityX() : Number
        {
            return this._speed.x;
        }// end function

        override public function free() : void
        {
            this._pixel = null;
            _sprite.stop();
            _universe.effects.remove(this);
            super.free();
            return;
        }// end function

        public function set angle(param1:Number) : void
        {
            this._angle = param1;
            return;
        }// end function

        private function updateSprite(param1:String) : void
        {
            if (this._curAnim != param1)
            {
                _sprite = ZG.animCache.getAnimation(param1);
                this._curAnim = param1;
            }
            return;
        }// end function

        override public function process() : void
        {
            var _loc_3:int = 0;
            if (this._variety != ShopBox.ITEM_SPIRIT_PLAYER)
            {
                this._pos.x = _sprite.x + _universe.x;
                this._pos.y = _sprite.y + _universe.y;
            }
            else
            {
                this._pos.x = _sprite.x;
                this._pos.y = _sprite.y;
            }
            var _loc_1:* = Amath.getAngleDeg(this._pos.x, this._pos.y, this._target.x, this._target.y);
            var _loc_2:* = this._angle - _loc_1;
            if (_loc_2 > 180)
            {
                _loc_2 = -360 + _loc_2;
            }
            else if (_loc_2 < -180)
            {
                _loc_2 = 360 + _loc_2;
            }
            if (Math.abs(_loc_2) < this._rotationSpeed)
            {
                this._angle = this._angle - _loc_2;
            }
            else if (_loc_2 > 0)
            {
                this._angle = this._angle - this._rotationSpeed;
            }
            else
            {
                this._angle = this._angle + this._rotationSpeed;
            }
            this._speed.asSpeed(10, Amath.toRadians(this._angle));
            _sprite.x = _sprite.x + this._speed.x;
            _sprite.y = _sprite.y + this._speed.y;
            _sprite.rotation = _sprite.rotation + this._angularVelocity;
            var _loc_4:String = this;
            var _loc_5:* = this._sparkInterval - 1;
            _loc_4._sparkInterval = _loc_5;
            if (this._sparkInterval <= 0)
            {
                this._pixel = EffectPixel.get();
                this._pixel.speed.set(this._speed.x * 0.6 + Amath.random(-2, 2), this._speed.y * 0.6 + Amath.random(-2, -2));
                this._pixel.init(_sprite.x + Amath.random(-3, 3), _sprite.y + Amath.random(-3, 3), 0, 0.6);
                this._sparkInterval = Amath.random(2, 6);
            }
            if (Amath.distance(this._pos.x, this._pos.y, this._target.x, this._target.y) < 25)
            {
                this.giveItem();
                _loc_3 = 0;
                while (_loc_3 < 3)
                {
                    
                    this._pixel = EffectPixel.get();
                    this._pixel.speed.set(Amath.random(-3, 3), Amath.random(-2, -1));
                    this._pixel.init(_sprite.x, _sprite.y);
                    _loc_3++;
                }
                this.free();
            }
            return;
        }// end function

        public function get positionY() : Number
        {
            return _sprite.y;
        }// end function

        public function set variety(param1:uint) : void
        {
            this._variety = param1;
            return;
        }// end function

        public static function get() : EffectCollectableItem
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectCollectableItem;
        }// end function

    }
}
