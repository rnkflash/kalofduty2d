package com.zombotron.effects
{
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import flash.display.*;

    public class EffectHealth extends BasicEffect
    {
        private var _list:Array;
        public var targetSprite:Sprite;
        private var _particleProc:TaskManager;
        public static const CACHE_NAME:String = "EffectHealth";

        public function EffectHealth()
        {
            var _loc_1:Object = null;
            this._list = [];
            var _loc_2:int = 0;
            while (_loc_2 < 8)
            {
                
                _loc_1 = {started:false, particle:null, velocity:0, drag:0, show:true, lifeTime:10};
                _loc_1.particle = $.animCache.getAnimation(Art.PARTICLE_HEALTH);
                _loc_1.particle.gotoAndStop(Amath.random(1, 2));
                _loc_1.particle.alpha = 0;
                this._list[int(this._list.length)] = _loc_1;
                _loc_2++;
            }
            this._particleProc = new TaskManager();
            return;
        }// end function

        private function onStart(param1:uint) : Boolean
        {
            var _loc_2:* = this._list[param1];
            _loc_2.particle.alpha = 0;
            _loc_2.particle.x = this.targetSprite.x + Amath.random(-15, 15);
            _loc_2.particle.y = this.targetSprite.y + Amath.random(20, 40);
            _loc_2.velocity = Amath.random(-2, -3);
            _loc_2.angularVelocity = Amath.random(-20, 20);
            _loc_2.drag = 0.98;
            _loc_2.show = true;
            _loc_2.lifeTime = Amath.random(5, 25);
            _loc_2.started = true;
            addChild(_loc_2.particle);
            return true;
        }// end function

        override public function free() : void
        {
            var _loc_1:Object = null;
            var _loc_2:uint = 0;
            var _loc_3:int = 0;
            if (!_isFree)
            {
                _loc_2 = this._list.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_1 = this._list[int(_loc_3)];
                    if (contains(_loc_1.particle))
                    {
                        _loc_1.started = false;
                        removeChild(_loc_1.particle);
                    }
                    _loc_3++;
                }
                _universe.effects.remove(this);
                _universe.remove(this, _layer);
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                _isFree = true;
            }
            return;
        }// end function

        override public function process() : void
        {
            var _loc_2:Object = null;
            var _loc_1:Boolean = true;
            var _loc_3:* = this._list.length;
            var _loc_4:uint = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = this._list[int(_loc_4)];
                if (_loc_2.started)
                {
                    _loc_1 = false;
                    _loc_2.particle.y = _loc_2.particle.y + _loc_2.velocity;
                    _loc_2.particle.rotation = _loc_2.particle.rotation + _loc_2.angularVelocity;
                    _loc_2.velocity = _loc_2.velocity * _loc_2.drag;
                    if (_loc_2.show)
                    {
                        _loc_2.particle.alpha = _loc_2.particle.alpha + 0.1;
                        if (_loc_2.particle.alpha >= 1)
                        {
                            _loc_2.show = false;
                            _loc_2.particle.alpha = 1;
                        }
                    }
                    else
                    {
                        var _loc_5:* = _loc_2;
                        var _loc_6:* = _loc_2.lifeTime - 1;
                        _loc_5.lifeTime = _loc_6;
                        if (_loc_2.lifeTime <= 0)
                        {
                            _loc_2.lifeTime = 0;
                            _loc_2.particle.alpha = _loc_2.particle.alpha - 0.1;
                            var _loc_5:* = _loc_2.particle.scaleY - 0.1;
                            _loc_2.particle.scaleY = _loc_2.particle.scaleY - 0.1;
                            _loc_2.particle.scaleX = _loc_5;
                            if (_loc_2.particle.alpha <= 0)
                            {
                                _loc_2.particle.alpha = 0;
                                _loc_2.started = false;
                            }
                        }
                    }
                }
                else
                {
                }
                _loc_1 = false;
                _loc_4 = _loc_4 + 1;
            }
            if (_loc_1)
            {
                this.free();
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:Object = null;
            var _loc_6:* = this._list.length;
            var _loc_7:int = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_5 = this._list[int(_loc_7)];
                var _loc_8:int = 1;
                _loc_5.particle.scaleY = 1;
                _loc_5.particle.scaleX = _loc_8;
                _loc_5.particle.alpha = 0;
                _loc_5.particle.gotoAndStop(Amath.random(1, 2));
                _loc_5.particle.smoothing = _universe.smoothing;
                _loc_5.started = false;
                this._particleProc.addTask(this.onStart, [_loc_7]);
                this._particleProc.addPause(Amath.random(2, 5));
                _loc_7++;
            }
            _isFree = false;
            _universe.effects.add(this);
            _universe.add(this, _layer);
            return;
        }// end function

        public static function get() : EffectHealth
        {
            var _loc_1:* = Universe.getInstance();
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as EffectHealth;
        }// end function

    }
}
