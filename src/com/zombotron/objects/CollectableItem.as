package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.anim.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.helpers.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;

    public class CollectableItem extends BasicObject implements IItemObject, IActiveObject
    {
        private var _isCollected:Boolean;
        private var _collectable:Boolean = true;
        private var _isSound:Boolean;
        private var _aArrow:Animation;
        private var _lifeTime:int;
        private var _alias:String;
        private var _aLight:Animation;
        public var ammoSupply:int;
        private var _isAction:Boolean;
        public static const CACHE_NAME:String = "CollectableItem";
        private static var _lastCollectTime:uint;

        public function CollectableItem()
        {
            this.ammoSupply = 0;
            _kind = Kind.COLLECTABLE_ITEMS;
            _sprite = ZG.animCache.getAnimation(Art.COLLECTABLE_ITEM);
            this._aLight = ZG.animCache.getAnimation(Art.EFFECT_ITEM_LIGHT);
            this._aArrow = ZG.animCache.getAnimation(Art.ACTIVE_ELEMENT);
            _layer = Universe.LAYER_MAIN_FG;
            _allowContacts = true;
            return;
        }// end function

        public function changeState() : void
        {
            return;
        }// end function

        override public function render() : void
        {
            visibleCulling();
            if (_isVisible)
            {
                x = _body.GetPosition().x * Universe.DRAW_SCALE;
                y = _body.GetPosition().y * Universe.DRAW_SCALE;
                _sprite.rotation = _body.GetAngle() / Math.PI * 180 % 360;
            }
            return;
        }// end function

        public function get activateDistance() : int
        {
            return 2;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:Object = null;
            var _loc_7:b2PolygonDef = null;
            if (_variety == ShopBox.ITEM_AMMO_PLAYER)
            {
                _variety = _universe.player.weaponAmmo(true);
            }
            _sprite.gotoAndStop(_variety);
            _sprite.scaleX = param4;
            _sprite.smoothing = _universe.smoothing;
            this.ammoSupply = 0;
            switch(_variety)
            {
                case ShopBox.ITEM_PISTOL:
                {
                    _loc_5 = {w:10, h:3, r:0.3, d:0.5};
                    this.ammoSupply = 6;
                    break;
                }
                case ShopBox.ITEM_SHOTGUN:
                {
                    _loc_5 = {w:18, h:3, r:0.3, d:0.5};
                    this.ammoSupply = 2;
                    break;
                }
                case ShopBox.ITEM_GUN:
                {
                    _loc_5 = {w:15, h:3, r:0.3, d:0.5};
                    this.ammoSupply = 16;
                    break;
                }
                case ShopBox.ITEM_GRENADEGUN:
                {
                    _loc_5 = {w:12, h:5, r:0.3, d:0.5};
                    this.ammoSupply = 4;
                    break;
                }
                case ShopBox.ITEM_MACHINEGUN:
                {
                    _loc_5 = {w:15, h:5, r:0.3, d:0.5};
                    this.ammoSupply = 60;
                    break;
                }
                case ShopBox.ITEM_AMMO_PISTOL:
                {
                    _loc_5 = {w:8, h:2, r:0.3, d:0.5};
                    addChild(this._aLight);
                    this._aLight.play();
                    break;
                }
                case ShopBox.ITEM_AMMO_SHOTGUN:
                {
                    _loc_5 = {w:8, h:3, r:0.3, d:0.5};
                    addChild(this._aLight);
                    this._aLight.play();
                    break;
                }
                case ShopBox.ITEM_AMMO_GUN:
                {
                    _loc_5 = {w:6, h:3, r:0.3, d:0.5};
                    addChild(this._aLight);
                    this._aLight.play();
                    break;
                }
                case ShopBox.ITEM_AMMO_GRENADEGUN:
                {
                    _loc_5 = {w:6, h:4, r:0.3, d:0.5};
                    addChild(this._aLight);
                    this._aLight.play();
                    break;
                }
                case ShopBox.ITEM_AMMO_MACHINEGUN:
                {
                    _loc_5 = {w:6, h:5, r:0.3, d:0.5};
                    addChild(this._aLight);
                    this._aLight.play();
                    break;
                }
                case ShopBox.ITEM_AIDKIT:
                {
                    _loc_5 = {w:10, h:8, r:0.3, d:0.5};
                    break;
                }
                case ShopBox.ITEM_ARMOR:
                {
                    _loc_5 = {w:10, h:10, r:0.3, d:0.5};
                    break;
                }
                case ShopBox.ITEM_HEALTH_INC:
                {
                    _loc_5 = {w:4, h:3, r:0.3, d:0.5};
                    break;
                }
                case ShopBox.ITEM_ACCURACY_INC:
                {
                    _loc_5 = {w:4, h:3, r:0.3, d:0.5};
                    break;
                }
                case ShopBox.ITEM_SKULL:
                {
                    _loc_5 = {w:6, h:6, r:0.3, d:0.5};
                    break;
                }
                case ShopBox.ITEM_RIBS:
                {
                    _loc_5 = {w:7, h:7, r:0.3, d:0.5};
                    break;
                }
                case ShopBox.ITEM_BONE:
                {
                    _loc_5 = {w:7, h:1, r:0.3, d:1};
                    break;
                }
                default:
                {
                    break;
                }
            }
            addChild(_sprite);
            var _loc_6:* = new b2BodyDef();
            _loc_7 = new b2PolygonDef();
            _loc_7.density = _loc_5.d;
            _loc_7.friction = 0.8;
            _loc_7.restitution = _loc_5.r;
            _loc_7.filter.groupIndex = -2;
            _loc_6.userData = this;
            _loc_7.SetAsBox(_loc_5.w / Universe.DRAW_SCALE, _loc_5.h / Universe.DRAW_SCALE);
            _loc_6.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_6.angle = Amath.toRadians(param3);
            _body = _universe.physics.CreateBody(_loc_6);
            _body.CreateShape(_loc_7);
            _body.SetMassFromShapes();
            _body.SetAngularVelocity(Amath.random(-2, 2));
            x = _body.GetPosition().x * Universe.DRAW_SCALE;
            y = _body.GetPosition().y * Universe.DRAW_SCALE;
            _sprite.rotation = _body.GetAngle() / Math.PI * 180 % 360;
            var _loc_8:int = 1;
            this._aArrow.alpha = 1;
            _sprite.alpha = _loc_8;
            this._isSound = false;
            this._isAction = false;
            this._isCollected = false;
            this._lifeTime = 150;
            reset();
            switch(_variety)
            {
                case ShopBox.ITEM_PISTOL:
                case ShopBox.ITEM_SHOTGUN:
                case ShopBox.ITEM_GUN:
                case ShopBox.ITEM_GRENADEGUN:
                case ShopBox.ITEM_MACHINEGUN:
                {
                    if (this._collectable)
                    {
                        this._alias = _universe.objects.getUniqueAlias(ShopBox.toName(_variety));
                        _universe.objects.add(this);
                        addChild(this._aArrow);
                        this._aArrow.y = -5;
                        this._aArrow.play();
                    }
                    break;
                }
                case ShopBox.ITEM_AMMO_PISTOL:
                case ShopBox.ITEM_AMMO_SHOTGUN:
                case ShopBox.ITEM_AMMO_GUN:
                case ShopBox.ITEM_AMMO_GRENADEGUN:
                case ShopBox.ITEM_AMMO_MACHINEGUN:
                case ShopBox.ITEM_AIDKIT:
                case ShopBox.ITEM_ARMOR:
                case ShopBox.ITEM_HEALTH_INC:
                case ShopBox.ITEM_ACCURACY_INC:
                {
                    _universe.items.add(this);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function set collectable(param1:Boolean) : void
        {
            this._collectable = param1;
            return;
        }// end function

        public function get alias() : String
        {
            return this._alias;
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        public function collect() : void
        {
            var _loc_1:EffectCollectableItem = null;
            var _loc_2:uint = 0;
            if (!this._isCollected)
            {
                if (_variety == ShopBox.ITEM_AMMO_PISTOL && !_universe.player.haveWeapon(ShopBox.ITEM_PISTOL) || _variety == ShopBox.ITEM_AMMO_SHOTGUN && !_universe.player.haveWeapon(ShopBox.ITEM_SHOTGUN) || _variety == ShopBox.ITEM_AMMO_GUN && !_universe.player.haveWeapon(ShopBox.ITEM_GUN) || _variety == ShopBox.ITEM_AMMO_GRENADEGUN && !_universe.player.haveWeapon(ShopBox.ITEM_GRENADEGUN) || _variety == ShopBox.ITEM_AMMO_MACHINEGUN && !_universe.player.haveWeapon(ShopBox.ITEM_MACHINEGUN))
                {
                    if (_universe.frameTime - _lastCollectTime > 100)
                    {
                        _lastCollectTime = _universe.frameTime;
                        if (Math.random() > 0.5)
                        {
                            log(Text.CON_CANT_PICK_UP_AMMO1);
                        }
                        else
                        {
                            _loc_2 = ShopBox.weaponKind(_variety);
                            log(Text.CON_CANT_PICK_UP_AMMO2 + ShopBox.toName(_loc_2) + ".");
                        }
                    }
                    return;
                }
                _loc_1 = EffectCollectableItem.get();
                _loc_1.variety = _variety;
                _loc_1.init(this.x, this.y, this.rotation);
                this._isCollected = true;
                this.free();
            }
            return;
        }// end function

        override public function process() : void
        {
            if (!this._collectable)
            {
                if (_universe.frameTime - _birthTime >= this._lifeTime)
                {
                    _sprite.alpha = _sprite.alpha - 0.02;
                    this._aArrow.alpha = _sprite.alpha;
                    if (_sprite.alpha <= 0)
                    {
                        var _loc_1:int = 0;
                        this._aArrow.alpha = 0;
                        _sprite.alpha = _loc_1;
                        this.free();
                    }
                }
            }
            return;
        }// end function

        override public function set variety(param1:uint) : void
        {
            _variety = param1;
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector(_body.GetPosition().x, _body.GetPosition().y);
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                this._collectable = true;
                if (_universe.objects.contains(this))
                {
                    _universe.objects.remove(this);
                }
                if (_universe.items.contains(this))
                {
                    _universe.items.remove(this);
                }
                if (contains(this._aArrow))
                {
                    removeChild(this._aArrow);
                    this._aArrow.stop();
                }
                if (contains(this._aLight))
                {
                    removeChild(this._aLight);
                    this._aLight.stop();
                }
                _universe.physics.DestroyBody(_body);
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                super.free();
            }
            return;
        }// end function

        public function action(param1:Function = null) : void
        {
            if (!this._isAction)
            {
                if (ZG.playerGui.isHaveMission(LevelBase.MISSION_SHOPING))
                {
                    var _loc_2:* = _universe.player;
                    var _loc_3:* = _universe.player.missionShoping + 1;
                    _loc_2.missionShoping = _loc_3;
                    ZG.playerGui.updateMission(LevelBase.MISSION_SHOPING, _universe.player.missionShoping);
                }
                _universe.player.pickupWeapon(_variety, this.ammoSupply);
                this._isAction = true;
                this.free();
            }
            return;
        }// end function

        override public function addContact(param1:b2ContactPoint) : Boolean
        {
            var _loc_2:BasicObject = null;
            var _loc_3:BasicObject = null;
            if (super.addContact(param1))
            {
                if (!this._isSound && (_variety == ShopBox.ITEM_PISTOL || _variety == ShopBox.ITEM_SHOTGUN || _variety == ShopBox.ITEM_GUN || _variety == ShopBox.ITEM_GRENADEGUN || _variety == ShopBox.ITEM_MACHINEGUN))
                {
                    _loc_2 = param1.shape1.GetBody().GetUserData();
                    _loc_3 = param1.shape2.GetBody().GetUserData();
                    if (_loc_2.kind == Kind.GROUND || _loc_3.kind == Kind.GROUND)
                    {
                        ZG.sound(SoundManager.WEAPON_FALL, this);
                        this._isSound = true;
                    }
                }
                return true;
            }
            return false;
        }// end function

        public static function get() : CollectableItem
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as CollectableItem;
        }// end function

    }
}
