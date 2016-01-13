package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;

    public class StonePart extends BasicObject
    {
        private var _height:Number = 10;
        private var _width:Number = 10;
        private var _lifeTime:int;
        public static const CACHE_NAME:String = "StoneParts";
        public static const STONE1_PART1:uint = 1;
        public static const STONE2_PART1:uint = 4;
        public static const STONE2_PART2:uint = 5;
        public static const STONE2_PART3:uint = 6;
        public static const STONE1_PART2:uint = 2;
        public static const STONE1_PART3:uint = 3;

        public function StonePart()
        {
            _kind = Kind.STONE_PART;
            _sprite = ZG.animCache.getAnimation(Art.STONE_PARTS);
            return;
        }// end function

        public function setSize(param1:Number, param2:Number) : void
        {
            this._width = param1 * 0.5;
            this._height = param2 * 0.5;
            return;
        }// end function

        override public function hitEffect(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
        {
            var _loc_5:* = EffectHitTo.get();
            _loc_5.variety = EffectHitTo.GROUND;
            _loc_5.init(param1, param2, param3, param4);
            ZG.sound(SoundManager.HIT_TO_GROUND, this, true);
            return true;
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

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_6:b2PolygonDef = null;
            var _loc_5:* = new b2BodyDef();
            _loc_6 = new b2PolygonDef();
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
            _sprite.gotoAndStop(_variety);
            _sprite.scaleX = param4;
            _sprite.smoothing = _universe.smoothing;
            _sprite.alpha = 1;
            addChild(_sprite);
            reset();
            this._lifeTime = 250;
            _universe.bodies.add(this);
            update();
            return;
        }// end function

        public static function get() : StonePart
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as StonePart;
        }// end function

    }
}
