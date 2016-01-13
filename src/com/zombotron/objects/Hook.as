package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class Hook extends BasicObject
    {

        public function Hook()
        {
            _kind = Kind.HOOK;
            _sprite = ZG.animCache.getAnimation(Art.TRAILER_HOOK);
            _layer = Universe.LAYER_MAIN_FG;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:b2BodyDef = null;
            var _loc_6:b2PolygonDef = null;
            _sprite.smoothing = _universe.smoothing;
            addChild(_sprite);
            _loc_5 = new b2BodyDef();
            _loc_6 = new b2PolygonDef();
            _loc_6.density = 0.5;
            _loc_6.friction = 0.8;
            _loc_6.restitution = 0;
            _loc_6.filter.groupIndex = -2;
            _loc_5.userData = this;
            switch(_kind)
            {
                case Kind.HOOK:
                {
                    _loc_6.SetAsBox(9 / Universe.DRAW_SCALE, 3 / Universe.DRAW_SCALE);
                    break;
                }
                case Kind.ROPE:
                {
                    _loc_6.SetAsBox(3 / Universe.DRAW_SCALE, 6 / Universe.DRAW_SCALE);
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_5.angle = Amath.toRadians(param3);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            reset();
            return;
        }// end function

        override public function set kind(param1:uint) : void
        {
            if (_kind != param1)
            {
                _kind = param1;
                switch(param1)
                {
                    case Kind.HOOK:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.TRAILER_HOOK);
                        _layer = Universe.LAYER_MAIN_FG;
                        break;
                    }
                    case Kind.ROPE:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.ROPE);
                        _layer = Universe.LAYER_MAIN;
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
