package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.zombotron.core.*;

    public class ShopStoragePart extends BasicObject
    {
        public static const LEFT_PART:uint = 1;
        public static const RIGHT_PART:uint = 2;

        public function ShopStoragePart()
        {
            _kind = Kind.SHOP_PART;
            _sprite = $.animCache.getAnimation(Art.SHOP_DOOR);
            _variety = LEFT_PART;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _sprite.smoothing = _universe.smoothing;
            addChild(_sprite);
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            var _loc_7:* = new b2Vec2();
            _loc_6.density = 0.1;
            _loc_6.friction = 0.01;
            _loc_6.restitution = 0.1;
            _loc_6.filter.categoryBits = 4;
            _loc_6.SetAsBox(16 / Universe.DRAW_SCALE, 4 / Universe.DRAW_SCALE);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_5.userData = this;
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            reset();
            show();
            return;
        }// end function

        override public function set variety(param1:uint) : void
        {
            if (_variety != param1)
            {
                _variety = param1;
                switch(_variety)
                {
                    case RIGHT_PART:
                    {
                        _sprite.scaleX = -1;
                        break;
                    }
                    default:
                    {
                        _sprite.scaleX = 1;
                        break;
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
