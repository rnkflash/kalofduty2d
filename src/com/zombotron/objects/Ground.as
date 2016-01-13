package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class Ground extends BasicObject
    {
        private var _height:int = 0;
        private var _width:int = 0;
        public var connectPlace:Boolean = false;
        public static const SPHERE:uint = 1;
        public static const RECTANGLE:uint = 0;

        public function Ground()
        {
            _kind = Kind.GROUND;
            _visibleCulling = false;
            _isVisible = false;
            _variety = RECTANGLE;
            return;
        }// end function

        public function set bodyWidth(param1:int) : void
        {
            this._width = param1 / 2;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            var _loc_7:* = new b2CircleDef();
            switch(_variety)
            {
                case SPHERE:
                {
                    _loc_7.radius = this._width / Universe.DRAW_SCALE;
                    _loc_7.density = 0.5;
                    _loc_7.friction = 0.5;
                    _loc_7.restitution = 0;
                    _loc_7.filter.categoryBits = 4;
                    if (this.connectPlace)
                    {
                        _loc_7.filter.groupIndex = -100;
                    }
                    _loc_5.userData = this;
                    _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
                    _body = _universe.physics.CreateBody(_loc_5);
                    _body.CreateShape(_loc_7);
                    break;
                }
                default:
                {
                    _loc_6.density = 1;
                    _loc_6.friction = 0.5;
                    _loc_6.restitution = 0.1;
                    _loc_6.filter.categoryBits = 4;
                    if (this.connectPlace)
                    {
                        _loc_7.filter.groupIndex = -100;
                    }
                    _loc_5.userData = this;
                    _loc_5.angle = Amath.toRadians(param3);
                    _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
                    _loc_6.SetAsBox(this._width / Universe.DRAW_SCALE, this._height / Universe.DRAW_SCALE);
                    _body = _universe.physics.CreateBody(_loc_5);
                    _body.CreateShape(_loc_6);
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function set bodyHeight(param1:int) : void
        {
            this._height = param1 / 2;
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.physics.DestroyBody(_body);
                super.free();
            }
            return;
        }// end function

    }
}
