package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.*;
    import com.zombotron.core.*;

    public class ElevatorWheel extends BasicObject
    {

        public function ElevatorWheel()
        {
            _kind = Kind.ELEVATOR_WHEEL;
            _sprite = $.animCache.getAnimation(Art.ELEVATOR_WHEEL);
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:b2CircleDef = null;
            _sprite.smoothing = _universe.smoothing;
            _sprite.alpha = 1;
            addChild(_sprite);
            _loc_5 = new b2CircleDef();
            var _loc_6:* = new b2BodyDef();
            _loc_6.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_6.userData = this;
            _loc_5.radius = 0.5;
            _loc_5.density = 0.5;
            _loc_5.friction = 10;
            _loc_5.restitution = 0.2;
            _loc_5.filter.categoryBits = 2;
            _loc_5.filter.maskBits = 4;
            _loc_5.filter.groupIndex = -1;
            _body = _universe.physics.CreateBody(_loc_6);
            _body.CreateShape(_loc_5);
            _body.SetMassFromShapes();
            reset();
            show();
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
