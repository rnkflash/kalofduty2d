package com.zombotron.effects
{
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.anim.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import flash.display.*;
    import flash.events.*;

    public class EffectBurn extends BasicEffect
    {
        private var _body:b2Body;
        private var _burnPoint:b2Vec2;
        private var _burnIndex:int;
        private var _isDead:Boolean;
        private var _smokeIndex:int;
        private var _delay:int;
        private var _smokeDelay:int;
        private var _aBurnList:Array;
        private var _dustIndex:int;
        private var _position:Avector;
        private var _layerDust:Sprite;
        private var _timeLife:int;
        private var _aSmokeList:Array;
        private var _initialized:Boolean;
        private var _fireDelay:int;
        private var _aDustList:Array;
        private var _layerSmoke:Sprite;
        private static const FIRE:uint = 1;
        private static const SMOKE:uint = 2;
        public static const CACHE_NAME:String = "EffectBurn";
        private static const DUST:uint = 3;
        private static const COUNT:uint = 5;

        public function EffectBurn(param1:String = "EffectBurn")
        {
            var _loc_5:Animation = null;
            var _loc_6:Animation = null;
            var _loc_7:Animation = null;
            this._delay = 0;
            this._aBurnList = [];
            this._aSmokeList = [];
            this._aDustList = [];
            this._burnIndex = 0;
            this._smokeIndex = 0;
            this._dustIndex = 0;
            this._layerSmoke = new Sprite();
            this._layerDust = new Sprite();
            this._fireDelay = 0;
            this._smokeDelay = 0;
            this._timeLife = 150;
            this._isDead = false;
            this._initialized = false;
            var _loc_2:* = Art.PARTICLE_FIRE;
            var _loc_3:* = Art.PARTICLE_SMOKE;
            var _loc_4:* = Art.PARTICLE_DUST;
            _cacheName = param1;
            if (_cacheName == EffectBurnSmall.CACHE_NAME)
            {
                _loc_2 = Art.PARTICLE_FIRE_SMALL;
                _loc_3 = Art.PARTICLE_SMOKE_SMALL;
                _loc_4 = Art.PARTICLE_DUST_SMALL;
            }
            addChild(this._layerDust);
            addChild(this._layerSmoke);
            var _loc_8:uint = 0;
            while (_loc_8 < COUNT)
            {
                
                _loc_5 = ZG.animCache.getAnimation(_loc_2);
                _loc_5.speed = 0.5;
                _loc_5.repeat = false;
                _loc_5.userTag = _loc_8;
                _loc_5.userDisplayIndex = FIRE;
                this._aBurnList[this._aBurnList.length] = {sprite:_loc_5, isFree:true};
                _loc_6 = ZG.animCache.getAnimation(_loc_3);
                _loc_6.speed = 0.5;
                _loc_6.repeat = false;
                _loc_6.userTag = _loc_8;
                _loc_6.userDisplayIndex = SMOKE;
                this._aSmokeList[this._aSmokeList.length] = {sprite:_loc_6, isFree:true};
                _loc_7 = ZG.animCache.getAnimation(_loc_4);
                _loc_7.speed = 0.5;
                _loc_7.repeat = false;
                _loc_7.userTag = _loc_8;
                _loc_7.userDisplayIndex = DUST;
                this._aDustList[this._aDustList.length] = {sprite:_loc_7, isFree:true};
                _loc_8 = _loc_8 + 1;
            }
            return;
        }// end function

        private function initParticle(param1:Animation) : void
        {
            param1.x = this._position.x + Amath.random(-5, 5);
            param1.y = this._position.y + Amath.random(-2, 2);
            param1.scaleX = Amath.random(0, 1) == 1 ? (-1) : (1);
            param1.gotoAndPlay(1);
            param1.addEventListener(Event.COMPLETE, this.completeHandler);
            switch(param1.userDisplayIndex)
            {
                case FIRE:
                {
                    addChild(param1);
                    break;
                }
                case SMOKE:
                {
                    this._layerSmoke.addChild(param1);
                    break;
                }
                case DUST:
                {
                    this._layerDust.addChild(param1);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function makeSmokeParticle() : Boolean
        {
            var _loc_1:* = this._aSmokeList[this._smokeIndex];
            if (_loc_1.isFree && !this._isDead)
            {
                this.initParticle(_loc_1.sprite);
                _loc_1.isFree = false;
            }
            this._smokeIndex = this._smokeIndex >= (this._aSmokeList.length - 1) ? (0) : ((this._smokeIndex + 1));
            return true;
        }// end function

        private function isFinished() : Boolean
        {
            var _loc_1:uint = 0;
            while (_loc_1 < COUNT)
            {
                
                if (!this._aBurnList[_loc_1].isFree || !this._aSmokeList[_loc_1].isFree || !this._aDustList[_loc_1].isFree)
                {
                    return false;
                }
                _loc_1 = _loc_1 + 1;
            }
            return true;
        }// end function

        override protected function completeHandler(event:Event) : void
        {
            var _loc_2:* = event.currentTarget as Animation;
            _loc_2.removeEventListener(Event.COMPLETE, this.completeHandler);
            switch(_loc_2.userDisplayIndex)
            {
                case FIRE:
                {
                    removeChild(_loc_2);
                    this._aBurnList[_loc_2.userTag].isFree = true;
                    break;
                }
                case SMOKE:
                {
                    this._layerSmoke.removeChild(_loc_2);
                    this._aSmokeList[_loc_2.userTag].isFree = true;
                    break;
                }
                case DUST:
                {
                    this._layerDust.removeChild(_loc_2);
                    this._aDustList[_loc_2.userTag].isFree = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this._isDead && this.isFinished())
            {
                this.free();
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            if (this._body == null)
            {
                $.trace("Warning: EffectBurn::init() - Call method setBody() before init().");
                return;
            }
            this._timeLife = this._timeLife <= 0 ? (150) : (this._timeLife);
            _isFree = false;
            _universe.add(this, _layer);
            _universe.effects.add(this);
            this._fireDelay = 0;
            this._smokeDelay = 0;
            return;
        }// end function

        public function timeLife(param1:int) : void
        {
            this._timeLife = param1;
            return;
        }// end function

        override public function process() : void
        {
            if (this._delay > 2)
            {
                this._position.set(this._burnPoint.x, this._burnPoint.y);
                this._position.rotateAround(new Avector(this._body.GetPosition().x * Universe.DRAW_SCALE, this._body.GetPosition().y * Universe.DRAW_SCALE), this._body.GetAngle());
                this._delay = 0;
            }
            var _loc_2:String = this;
            var _loc_3:* = this._delay + 1;
            _loc_2._delay = _loc_3;
            if (this._fireDelay >= 10)
            {
                this.makeFireParticle();
                this._fireDelay = 0;
            }
            if (this._smokeDelay >= 13)
            {
                this.makeSmokeParticle();
                this.makeDustParticle();
                this._smokeDelay = 0;
            }
            var _loc_2:String = this;
            var _loc_3:* = this._fireDelay + 1;
            _loc_2._fireDelay = _loc_3;
            var _loc_2:String = this;
            var _loc_3:* = this._smokeDelay + 1;
            _loc_2._smokeDelay = _loc_3;
            var _loc_1:uint = 0;
            while (_loc_1 < COUNT)
            {
                
                if (!this._aSmokeList[_loc_1].isFree)
                {
                    (this._aSmokeList[_loc_1].sprite.y - 1);
                }
                if (!this._aDustList[_loc_1].isFree)
                {
                    (this._aDustList[_loc_1].sprite.y - 1);
                }
                _loc_1 = _loc_1 + 1;
            }
            if (this._timeLife <= 0 && !this._isDead)
            {
                this._isDead = true;
            }
            else
            {
                var _loc_2:String = this;
                var _loc_3:* = this._timeLife - 1;
                _loc_2._timeLife = _loc_3;
            }
            return;
        }// end function

        private function makeDustParticle() : Boolean
        {
            var _loc_1:* = this._aDustList[this._dustIndex];
            if (_loc_1.isFree && !this._isDead)
            {
                this.initParticle(_loc_1.sprite);
                _loc_1.isFree = false;
            }
            this._dustIndex = this._dustIndex >= (this._aDustList.length - 1) ? (0) : ((this._dustIndex + 1));
            return true;
        }// end function

        private function makeFireParticle() : Boolean
        {
            var _loc_1:* = this._aBurnList[this._burnIndex];
            if (_loc_1.isFree && !this._isDead)
            {
                this.initParticle(_loc_1.sprite);
                _loc_1.isFree = false;
            }
            this._burnIndex = this._burnIndex >= (this._aBurnList.length - 1) ? (0) : ((this._burnIndex + 1));
            return true;
        }// end function

        override public function free() : void
        {
            var _loc_1:Object = null;
            var _loc_2:uint = 0;
            if (!_isFree)
            {
                this._isDead = false;
                _universe.remove(this, _layer);
                _universe.effects.remove(this);
                _universe.cacheStorage.setInstance(_cacheName, this);
                _loc_2 = 0;
                while (_loc_2 < COUNT)
                {
                    
                    _loc_1 = this._aBurnList[_loc_2];
                    _loc_1.sprite.stop();
                    _loc_1.isFree = true;
                    if (contains(_loc_1.sprite))
                    {
                        removeChild(_loc_1.sprite);
                    }
                    _loc_1 = this._aSmokeList[_loc_2];
                    _loc_1.sprite.stop();
                    _loc_1.isFree = true;
                    if (this._layerSmoke.contains(_loc_1.sprite))
                    {
                        this._layerSmoke.removeChild(_loc_1.sprite);
                    }
                    _loc_1 = this._aDustList[_loc_2];
                    _loc_1.sprite.stop();
                    _loc_1.isFree = true;
                    if (this._layerDust.contains(_loc_1.sprite))
                    {
                        this._layerDust.removeChild(_loc_1.sprite);
                    }
                    _loc_2 = _loc_2 + 1;
                }
                _isFree = true;
            }
            return;
        }// end function

        public function setBody(param1:b2Body, param2:b2Vec2) : void
        {
            this._body = param1;
            this._burnPoint = param2;
            this._position = new Avector();
            return;
        }// end function

        public static function get() : EffectBurn
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectBurn;
        }// end function

    }
}
