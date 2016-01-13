package com.zombotron.effects
{
    import Box2D.Dynamics.*;
    import com.antkarlov.anim.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import flash.display.*;
    import flash.events.*;

    public class EffectBurnTiny extends BasicEffect
    {
        private var _body:b2Body;
        private var _burnPoint:Avector;
        private var _delay:int;
        private var _isDead:Boolean;
        private var _burnIndex:int;
        private var _initialized:Boolean;
        private var _aBurnList:Array;
        private var _dustIndex:int;
        private var _position:Avector;
        private var _isVisible:Boolean;
        private var _layerDust:Sprite;
        private var _fireDelay:int;
        private var _aDustList:Array;
        private static const FIRE:uint = 1;
        public static const CACHE_NAME:String = "EffectBurnTiny";
        private static const DUST:uint = 2;
        private static const COUNT:uint = 5;

        public function EffectBurnTiny(param1:String = "EffectBurnTiny")
        {
            var _loc_2:Animation = null;
            var _loc_3:Animation = null;
            var _loc_4:Animation = null;
            this._delay = 0;
            this._aBurnList = [];
            this._aDustList = [];
            this._burnIndex = 0;
            this._dustIndex = 0;
            this._layerDust = new Sprite();
            this._fireDelay = 0;
            this._isDead = false;
            this._isVisible = true;
            this._initialized = false;
            _cacheName = CACHE_NAME;
            addChild(this._layerDust);
            var _loc_5:uint = 0;
            while (_loc_5 < COUNT)
            {
                
                _loc_2 = ZG.animCache.getAnimation(Art.PARTICLE_FIRE_TINY);
                _loc_2.speed = 0.5;
                _loc_2.repeat = false;
                _loc_2.userTag = _loc_5;
                _loc_2.userDisplayIndex = FIRE;
                this._aBurnList[this._aBurnList.length] = {sprite:_loc_2, isFree:true};
                _loc_4 = ZG.animCache.getAnimation(Art.PARTICLE_DUST_TINY);
                _loc_4.speed = 0.5;
                _loc_4.repeat = false;
                _loc_4.userTag = _loc_5;
                _loc_4.userDisplayIndex = DUST;
                this._aDustList[this._aDustList.length] = {sprite:_loc_4, isFree:true};
                _loc_5 = _loc_5 + 1;
            }
            return;
        }// end function

        public function die() : void
        {
            if (!this._isDead)
            {
                this.hide();
                this._isDead = true;
            }
            return;
        }// end function

        private function isFinished() : Boolean
        {
            var _loc_1:uint = 0;
            while (_loc_1 < COUNT)
            {
                
                if (!this._aBurnList[_loc_1].isFree || !this._aDustList[_loc_1].isFree)
                {
                    return false;
                }
                _loc_1 = _loc_1 + 1;
            }
            return true;
        }// end function

        private function initParticle(param1:Animation) : void
        {
            param1.x = this._position.x + Amath.random(-2, 2);
            param1.y = this._position.y + Amath.random(-1, 1);
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
                $.trace("Warning: EffectBurnTiny::init() - Call method setBody() before init().");
                return;
            }
            _isFree = false;
            this._isVisible = false;
            this._isDead = false;
            this.show();
            this._fireDelay = 0;
            return;
        }// end function

        public function burnPoint(param1:Avector) : void
        {
            this._burnPoint = param1;
            return;
        }// end function

        public function hide() : void
        {
            if (this._isVisible)
            {
                _universe.remove(this, _layer);
                _universe.effects.remove(this);
                this._isVisible = false;
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

        override public function free() : void
        {
            var _loc_1:Object = null;
            var _loc_2:uint = 0;
            if (!_isFree)
            {
                this.hide();
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

        override public function process() : void
        {
            var _loc_2:Avector = null;
            if (this._delay > 2)
            {
                this._position.copy(this._burnPoint);
                _loc_2 = new Avector(this._body.GetPosition().x * Universe.DRAW_SCALE, this._body.GetPosition().y * Universe.DRAW_SCALE);
                this._position.rotateAround(_loc_2, this._body.GetAngle());
                this._delay = 0;
            }
            var _loc_3:String = this;
            var _loc_4:* = this._delay + 1;
            _loc_3._delay = _loc_4;
            if (this._fireDelay == 4)
            {
                this.makeFireParticle();
            }
            if (this._fireDelay == 8)
            {
                this.makeDustParticle();
                this._fireDelay = 0;
            }
            var _loc_3:String = this;
            var _loc_4:* = this._fireDelay + 1;
            _loc_3._fireDelay = _loc_4;
            var _loc_1:uint = 0;
            while (_loc_1 < COUNT)
            {
                
                if (!this._aDustList[_loc_1].isFree)
                {
                    (this._aDustList[_loc_1].sprite.y - 1);
                }
                _loc_1 = _loc_1 + 1;
            }
            return;
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

        public function setBody(param1:b2Body, param2:Avector) : void
        {
            this._body = param1;
            this._burnPoint = param2;
            this._position = new Avector();
            return;
        }// end function

        public function show() : void
        {
            if (!this._isVisible)
            {
                _universe.add(this, _layer);
                _universe.effects.add(this);
                this._isVisible = true;
            }
            return;
        }// end function

        public static function get() : EffectBurnTiny
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectBurnTiny;
        }// end function

    }
}
