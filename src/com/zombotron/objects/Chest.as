package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.anim.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.gui.*;
    import com.zombotron.helpers.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;

    public class Chest extends BasicObject implements IActiveObject
    {
        private var _procDrop:TaskManager;
        private var _aArrow:Animation;
        private var _lifeTime:int;
        private var _alias:String;
        private var _isAction:Boolean;
        private var _playerDir:int;
        private var _contents:Array;
        public var targetAlias:String;
        public static const CACHE_NAME:String = "Chests";
        public static const BRONZE:uint = 2;
        public static const GOLD:uint = 3;
        public static const IRON:uint = 1;

        public function Chest()
        {
            this.targetAlias = "null";
            this._alias = "";
            this._contents = [];
            _kind = Kind.CHEST;
            _variety = IRON;
            _sprite = ZG.animCache.getAnimation(Art.IRON_CHEST);
            this._aArrow = ZG.animCache.getAnimation(Art.ACTIVE_ELEMENT);
            _layer = Universe.LAYER_BG_OBJECTS;
            _allowContacts = true;
            this._procDrop = new TaskManager();
            return;
        }// end function

        public function changeState() : void
        {
            return;
        }// end function

        public function get alias() : String
        {
            return this._alias;
        }// end function

        public function setVariety(param1:String) : void
        {
            switch(param1)
            {
                case "gold":
                {
                    this.variety = GOLD;
                    break;
                }
                case "bronze":
                {
                    this.variety = BRONZE;
                    break;
                }
                default:
                {
                    this.variety = IRON;
                    break;
                    break;
                }
            }
            return;
        }// end function

        override public function set variety(param1:uint) : void
        {
            if (_variety != param1)
            {
                _variety = param1;
                switch(_variety)
                {
                    case IRON:
                    {
                        _sprite = $.animCache.getAnimation(Art.IRON_CHEST);
                        break;
                    }
                    case BRONZE:
                    {
                        _sprite = $.animCache.getAnimation(Art.BRONZE_CHEST);
                        break;
                    }
                    case GOLD:
                    {
                        _sprite = $.animCache.getAnimation(Art.GOLD_CHEST);
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

        public function addItem(param1:uint, param2:uint) : void
        {
            if (param1 != ShopBox.ITEM_UNDEFINED)
            {
                this._contents[this._contents.length] = {itemKind:param1, quantity:param2};
            }
            return;
        }// end function

        public function clearContents() : void
        {
            this._contents.length = 0;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_6:b2PolygonDef = null;
            _sprite.smoothing = _universe.smoothing;
            _sprite.gotoAndStop(1);
            _sprite.alpha = 1;
            this._aArrow.play();
            this._aArrow.y = -10;
            addChild(_sprite);
            addChild(this._aArrow);
            var _loc_5:* = new b2BodyDef();
            _loc_6 = new b2PolygonDef();
            _loc_6.density = 0.5;
            _loc_6.friction = 0.2;
            _loc_6.restitution = 0.1;
            _loc_6.filter.groupIndex = -2;
            _loc_5.userData = this;
            _loc_5.angle = param3 * (Math.PI / 180);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_6.SetAsOrientedBox(18 / Universe.DRAW_SCALE, 14 / Universe.DRAW_SCALE, new b2Vec2(), 0);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            this._lifeTime = 500;
            this._isAction = false;
            reset();
            _universe.objects.add(this);
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

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        override public function addContact(param1:b2ContactPoint) : Boolean
        {
            if (super.addContact(param1))
            {
                if (_body.GetLinearVelocity().Length() > 5)
                {
                    ZG.sound(SoundManager.CHEST_COLLISION, this, true);
                }
                return true;
            }
            return false;
        }// end function

        private function onOpened() : void
        {
            var _loc_1:Object = null;
            var _loc_4:uint = 0;
            this._playerDir = _universe.playerBody.GetPosition().x < _body.GetPosition().x ? (-1) : (1);
            var _loc_2:* = this._contents.length;
            var _loc_3:uint = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_1 = this._contents[_loc_3];
                if (_loc_1.quantity > 0)
                {
                    _loc_4 = 0;
                    while (_loc_4 < _loc_1.quantity)
                    {
                        
                        this._procDrop.addTask(this.onDropItem, [_loc_1.itemKind]);
                        this._procDrop.addPause(2);
                        _loc_4 = _loc_4 + 1;
                    }
                }
                _loc_3 = _loc_3 + 1;
            }
            _universe.objects.callAction(this.targetAlias, null, this._alias);
            return;
        }// end function

        public function get activateDistance() : int
        {
            return 2;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.objects.remove(this);
                _universe.physics.DestroyBody(_body);
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                if (contains(this._aArrow))
                {
                    this._aArrow.stop();
                    removeChild(this._aArrow);
                }
                super.free();
            }
            return;
        }// end function

        override public function process() : void
        {
            if (this._isAction)
            {
                if (_universe.frameTime - _birthTime >= this._lifeTime)
                {
                    _sprite.alpha = _sprite.alpha - 0.02;
                    if (_sprite.alpha <= 0)
                    {
                        _sprite.alpha = 0;
                        this.free();
                    }
                }
            }
            return;
        }// end function

        private function onDropItem(param1:uint) : Boolean
        {
            var _loc_4:Coin = null;
            var _loc_5:CollectableItem = null;
            var _loc_2:* = new b2Vec2(Amath.random(0, 4) / 20, (Amath.random(-3, -2) - Math.random()) / 10);
            var _loc_3:* = new Avector(this.x + Amath.random(-10, 10), this.y + Amath.random(0, 5));
            if (param1 == ShopBox.ITEM_COIN)
            {
                _loc_2.x = this._playerDir == 1 ? (-_loc_2.x) : (_loc_2.x);
                _loc_4 = Coin.get();
                _loc_4.init(_loc_3.x, _loc_3.y);
                _loc_4.body.ApplyImpulse(_loc_2, _loc_4.body.GetWorldCenter());
            }
            else
            {
                _loc_2.x = this._playerDir == 1 ? (-_loc_2.x) : (_loc_2.x);
                _loc_5 = _universe.makeCollectableItem(param1, 1, _loc_3.x, _loc_3.y);
                _loc_5.body.ApplyImpulse(_loc_2, _loc_5.body.GetWorldCenter());
            }
            return true;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector(_body.GetPosition().x, _body.GetPosition().y);
        }// end function

        public function action(param1:Function = null) : void
        {
            var _loc_2:EffectCollectableItem = null;
            if (!this._isAction)
            {
                _sprite.repeat = false;
                _sprite.onComplete = this.onOpened;
                _sprite.play();
                if (contains(this._aArrow))
                {
                    removeChild(this._aArrow);
                    this._aArrow.stop();
                }
                ZG.sound(SoundManager.ACTION_OPEN_CHEST, this, true);
                if (ZG.playerGui.isHaveMission(LevelBase.MISSION_CHEST))
                {
                    _loc_2 = EffectCollectableItem.get();
                    _loc_2.variety = ShopBox.ITEM_SPIRIT_CHEST;
                    _loc_2.init(this.x, this.y, this.rotation);
                    _loc_2.angle = -45;
                }
                if (_variety == BRONZE)
                {
                    if (!ZG.saveBox.isSecretFounded(this._alias))
                    {
                        var _loc_3:* = ZG.saveBox;
                        var _loc_4:* = ZG.saveBox.foundedSecrets + 1;
                        _loc_3.foundedSecrets = _loc_4;
                        ZG.saveBox.addSecret(this._alias);
                        _universe.checkAchievement(AchievementItem.TREASURE_HUNTER);
                        _universe.motiFoundSecret();
                    }
                }
                _birthTime = _universe.frameTime;
                this._isAction = true;
            }
            return;
        }// end function

        public static function get() : Chest
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as Chest;
        }// end function

    }
}
