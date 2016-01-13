package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;

    public class ZombieBombPart extends BasicObject
    {
        public var color:uint;
        private var _width:Number;
        private var _lifeTime:int;
        private var _height:Number;
        private var _tm:TaskManager;
        public static const BODY:uint = 0;
        public static const CACHE_NAME:String = "ZombieBombParts";
        public static const LEG_RIGHT:uint = 3;
        public static const HAND_RIGHT:uint = 9;
        public static const HAND_LEFT:uint = 12;
        public static const LEG_LEFT:uint = 6;

        public function ZombieBombPart()
        {
            _kind = Kind.ZOMBIE_BOMB_PART;
            _sprite = $.animCache.getAnimation(Art.ZOMBIE_BOMB_PARTS);
            this.color = 1;
            this._tm = new TaskManager();
            this._width = 10;
            this._height = 10;
            return;
        }// end function

        private function makeBloodFountain(param1:b2Body, param2:uint = 5) : void
        {
            var _loc_3:uint = 0;
            while (_loc_3 < param2)
            {
                
                this._tm.addTask(this.taskMakeBlood, [param1]);
                this._tm.addPause(2);
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        private function taskMakeBlood(param1:b2Body) : Boolean
        {
            var _loc_2:* = EffectBlood.get();
            _loc_2.init(param1.GetPosition().x * Universe.DRAW_SCALE, param1.GetPosition().y * Universe.DRAW_SCALE);
            return true;
        }// end function

        public function setSize(param1:Number, param2:Number) : void
        {
            this._width = param1 * 0.5;
            this._height = param2 * 0.5;
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.bodies.remove(this);
                _universe.physics.DestroyBody(_body);
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                super.free();
            }
            return;
        }// end function

        override public function process() : void
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
            return;
        }// end function

        override public function jointDead(param1:b2RevoluteJoint = null) : void
        {
            this.makeBloodFountain(_body, 2);
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_6.density = 0.5;
            _loc_6.friction = 0.8;
            _loc_6.restitution = 0.1;
            _loc_6.filter.groupIndex = -2;
            _loc_5.userData = this;
            _loc_6.SetAsBox(this._width / Universe.DRAW_SCALE, this._height / Universe.DRAW_SCALE);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_5.angle = Amath.toRadians(param3);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            _sprite.gotoAndStop(_variety + this.color);
            _sprite.scaleX = param4;
            _sprite.smoothing = _universe.smoothing;
            _sprite.alpha = 1;
            addChild(_sprite);
            reset();
            this._lifeTime = 250;
            this._tm.clear();
            _universe.bodies.add(this);
            update();
            return;
        }// end function

        public static function get() : ZombieBombPart
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as ZombieBombPart;
        }// end function

    }
}
