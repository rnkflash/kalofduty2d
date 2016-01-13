package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class BoxPart extends BasicObject
    {
        private var _lifeTime:int = 0;
        public static const PLANK_BOTTOM:int = 6;
        public static const PLANK_LEFT:int = 7;
        public static const CACHE_NAME:String = "BoxParts";
        public static const PLANK_CENTER:int = 8;
        public static const PLANK_TOP:int = 4;
        public static const PLANK_RIGHT:int = 5;

        public function BoxPart()
        {
            _kind = Kind.BOX_PLANK;
            _sprite = $.animCache.getAnimation(Art.BOX);
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:Object = null;
            var _loc_7:b2PolygonDef = null;
            reset();
            this._lifeTime = Amath.random(100, 250);
            switch(_variety)
            {
                case PLANK_TOP:
                {
                    _loc_5 = {w:15, h:4, x:0, y:-14};
                    break;
                }
                case PLANK_RIGHT:
                {
                    _loc_5 = {w:4, h:15, x:14, y:0};
                    break;
                }
                case PLANK_BOTTOM:
                {
                    _loc_5 = {w:15, h:4, x:0, y:14};
                    break;
                }
                case PLANK_LEFT:
                {
                    _loc_5 = {w:4, h:15, x:-14, y:0};
                    break;
                }
                case PLANK_CENTER:
                {
                }
                default:
                {
                    _loc_5 = {w:6, h:16, x:0, y:0};
                    param3 = 45;
                    break;
                    break;
                }
            }
            var _loc_6:* = new b2BodyDef();
            _loc_7 = new b2PolygonDef();
            _loc_7.density = 0.5;
            _loc_7.friction = 0.8;
            _loc_7.restitution = 0.1;
            _loc_7.filter.groupIndex = -2;
            _loc_6.userData = this;
            _loc_7.SetAsBox(_loc_5.w / Universe.DRAW_SCALE, _loc_5.h / Universe.DRAW_SCALE);
            _loc_6.position.Set((param1 + _loc_5.x) / Universe.DRAW_SCALE, (param2 + _loc_5.y) / Universe.DRAW_SCALE);
            _loc_6.angle = Amath.toRadians(param3);
            _body = _universe.physics.CreateBody(_loc_6);
            _body.CreateShape(_loc_7);
            _body.SetMassFromShapes();
            _sprite.alpha = 1;
            _sprite.smoothing = _universe.smoothing;
            _sprite.gotoAndStop(_variety);
            addChild(_sprite);
            _universe.add(this, _layer);
            _universe.bodies.add(this);
            update();
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

        public static function get() : BoxPart
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as BoxPart;
        }// end function

    }
}
