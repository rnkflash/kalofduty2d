package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.interfaces.*;

    public class Coin extends BasicObject implements IItemObject
    {
        private var _isCollected:Boolean;
        private var _coinPos:b2Vec2;
        private var _isSound:Boolean;
        public var isMagnetic:Boolean = false;
        private var _speed:Avector;
        private var _playerPos:b2Vec2;
        public static const CACHE_NAME:String = "Coins";

        public function Coin()
        {
            this._speed = new Avector();
            _kind = Kind.COIN;
            _sprite = ZG.animCache.getAnimation(Art.COIN);
            _layer = Universe.LAYER_MAIN_FG;
            _allowContacts = true;
            return;
        }// end function

        override public function addContact(param1:b2ContactPoint) : Boolean
        {
            var _loc_2:BasicObject = null;
            var _loc_3:BasicObject = null;
            if (super.addContact(param1))
            {
                if (!this._isSound)
                {
                    _loc_2 = param1.shape1.GetBody().GetUserData();
                    _loc_3 = param1.shape2.GetBody().GetUserData();
                    if (_loc_2.kind == Kind.GROUND || _loc_3.kind == Kind.GROUND)
                    {
                        ZG.sound(SoundManager.COIN_FALL, this);
                        this._isSound = true;
                    }
                }
                return true;
            }
            return false;
        }// end function

        public function collect() : void
        {
            var _loc_1:EffectCoin = null;
            if (!this._isCollected)
            {
                _loc_1 = EffectCoin.get();
                _loc_1.init(this.x, this.y);
                var _loc_2:* = ZG.saveBox;
                var _loc_3:* = ZG.saveBox.totalCoins + 1;
                _loc_2.totalCoins = _loc_3;
                this._isCollected = true;
                this.free();
            }
            return;
        }// end function

        override public function process() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            if (!_universe.player.isDead)
            {
                _loc_1 = 0;
                if (this.isMagnetic)
                {
                    _loc_1 = Amath.distance(this.x, this.y, _universe.player.x, _universe.player.y);
                    if (_loc_1 < 20)
                    {
                        this.collect();
                    }
                    else
                    {
                        _loc_2 = Amath.getAngle(this.x, this.y, _universe.player.x, _universe.player.y);
                        this._speed.asSpeed(10, _loc_2);
                        this.x = this.x + this._speed.x;
                        this.y = this.y + this._speed.y;
                    }
                }
                else
                {
                    this._playerPos = _universe.playerBody.GetPosition();
                    this._coinPos = _body.GetPosition();
                    _loc_1 = Amath.distance(this._coinPos.x, this._coinPos.y, this._playerPos.x, this._playerPos.y);
                    if (_loc_1 < 2.5)
                    {
                        _universe.physics.DestroyBody(_body);
                        this.isMagnetic = true;
                    }
                }
            }
            else if (_universe.player.isDead && this.isMagnetic)
            {
                _sprite.alpha = _sprite.alpha - 0.1;
                if (_sprite.alpha <= 0)
                {
                    this.free();
                }
            }
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                if (!this.isMagnetic)
                {
                    _universe.physics.DestroyBody(_body);
                }
                _universe.items.remove(this);
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                super.free();
            }
            return;
        }// end function

        override public function render() : void
        {
            if (!this.isMagnetic)
            {
                super.render();
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            addChild(_sprite);
            _sprite.alpha = 1;
            _sprite.playRandomFrame();
            var _loc_5:* = new b2CircleDef();
            var _loc_6:* = new b2BodyDef();
            _loc_6.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_6.userData = this;
            _loc_6.fixedRotation = true;
            _loc_5.radius = 0.15;
            _loc_5.density = 0.5;
            _loc_5.friction = 3;
            _loc_5.restitution = 0.2;
            _loc_5.filter.categoryBits = 2;
            _loc_5.filter.maskBits = 4;
            _loc_5.filter.groupIndex = -101;
            _body = _universe.physics.CreateBody(_loc_6);
            _body.CreateShape(_loc_5);
            _body.SetMassFromShapes();
            reset();
            this._isCollected = false;
            this._isSound = false;
            this.isMagnetic = false;
            _universe.items.add(this);
            this.render();
            return;
        }// end function

        public static function get() : Coin
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as Coin;
        }// end function

    }
}
