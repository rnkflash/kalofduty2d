package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;

    public class HeroPart extends BasicObject
    {
        private var _lifeTime:int;
        private var _tm:TaskManager;
        public static const HEAD:uint = 2;
        public static const BODY:uint = 1;
        public static const CACHE_NAME:String = "HeroPart";
        public static const LEG_RIGHT:uint = 6;
        public static const HAND_RIGHT:uint = 3;
        public static const WEAPON1:uint = 7;
        public static const HAND_LEFT:uint = 4;
        public static const LEG_LEFT:uint = 5;

        public function HeroPart()
        {
            this._tm = new TaskManager();
            _kind = Kind.HERO_PART;
            _sprite = $.animCache.getAnimation(Art.HERO_PARTS);
            return;
        }// end function

        private function taskMakeBlood(param1:b2Body) : Boolean
        {
            var _loc_2:* = EffectBlood.get();
            _loc_2.init(param1.GetPosition().x * Universe.DRAW_SCALE, param1.GetPosition().y * Universe.DRAW_SCALE);
            return true;
        }// end function

        override public function jointDead(param1:b2RevoluteJoint = null) : void
        {
            var _loc_2:int = 0;
            while (_loc_2 < 2)
            {
                
                this._tm.addTask(this.taskMakeBlood, [_body]);
                this._tm.addPause(2);
                _loc_2++;
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

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:Object = null;
            var _loc_8:b2PolygonDef = null;
            var _loc_6:int = 0;
            switch(_variety)
            {
                case BODY:
                {
                    _loc_5 = {w:8, h:10, x:0, y:0, a:0, r:0.1};
                    break;
                }
                case HEAD:
                {
                    _loc_5 = {w:8, h:10, x:0, y:-18, a:0, r:0.1};
                    break;
                }
                case LEG_RIGHT:
                {
                    _loc_6 = param4 == 1 ? (-5) : (5);
                    _loc_5 = {w:3, h:8, x:_loc_6, y:20, a:0, r:0.1};
                    break;
                }
                case LEG_LEFT:
                {
                    _loc_6 = param4 == 1 ? (5) : (-5);
                    _loc_5 = {w:3, h:8, x:_loc_6, y:20, a:0, r:0.1};
                    break;
                }
                case HAND_RIGHT:
                {
                    _loc_6 = param4 == 1 ? (2) : (-2);
                    _loc_5 = {w:10, h:3, x:_loc_6, y:-8, a:0, r:0.1};
                    break;
                }
                case HAND_LEFT:
                {
                    _loc_6 = param4 == 1 ? (12) : (-12);
                    _loc_5 = {w:10, h:3, x:_loc_6, y:-8, a:0, r:0.1};
                    break;
                }
                case WEAPON1:
                {
                    _loc_6 = param4 == 1 ? (12) : (-12);
                    _loc_5 = {w:15, h:3, x:_loc_6, y:-8, a:0, r:0.3};
                    break;
                }
                default:
                {
                    break;
                }
            }
            var _loc_7:* = new b2BodyDef();
            _loc_8 = new b2PolygonDef();
            _loc_8.density = 0.5;
            _loc_8.friction = 0.8;
            _loc_8.restitution = _loc_5.r;
            _loc_8.filter.groupIndex = -2;
            _loc_7.userData = this;
            _loc_8.SetAsBox(_loc_5.w / Universe.DRAW_SCALE, _loc_5.h / Universe.DRAW_SCALE);
            _loc_7.position.Set((param1 + _loc_5.x) / Universe.DRAW_SCALE, (param2 + _loc_5.y) / Universe.DRAW_SCALE);
            _loc_7.angle = Amath.toRadians(param3);
            _body = _universe.physics.CreateBody(_loc_7);
            _body.CreateShape(_loc_8);
            _body.SetMassFromShapes();
            _sprite.gotoAndStop(_variety);
            _sprite.smoothing = _universe.smoothing;
            _sprite.scaleX = param4;
            _sprite.alpha = 1;
            addChild(_sprite);
            this._lifeTime = 250;
            reset();
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.physics.DestroyBody(_body);
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                super.free();
            }
            return;
        }// end function

        public static function get() : HeroPart
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as HeroPart;
        }// end function

    }
}
