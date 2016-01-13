package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.zombotron.core.*;
    import com.zombotron.helpers.*;

    public class Trailer extends BasicObject
    {
        private var _ragdoll:Ragdoll;
        private var _wheelA:CartWheel;
        private var _wheelB:CartWheel;
        private var _jointA:b2RevoluteJoint;
        private var _jointB:b2RevoluteJoint;
        public static const STRENGTH_OF_JOINT:Number = 350;
        public static const RAGDOLL_NAME:String = "Trailer";
        public static const WOOD:uint = 2;
        public static const BASIC:uint = 1;

        public function Trailer()
        {
            _kind = Kind.TRAILER;
            _sprite = ZG.animCache.getAnimation(Art.TRAILER_BODY);
            this._ragdoll = _universe.ragdollStorage.getValue(RAGDOLL_NAME);
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _sprite.smoothing = _universe.smoothing;
            _sprite.gotoAndStop(_variety);
            addChild(_sprite);
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_6.density = 0.5;
            _loc_6.friction = 0.8;
            _loc_6.restitution = 0;
            _loc_6.filter.categoryBits = 4;
            _loc_6.filter.groupIndex = -2;
            _loc_5.userData = this;
            var _loc_7:* = this._ragdoll.getBody("body1");
            _loc_7.scaleX = _sprite.scaleX;
            _loc_6.SetAsOrientedBox(_loc_7.width * 0.5 / Universe.DRAW_SCALE, _loc_7.height * 0.5 / Universe.DRAW_SCALE, new b2Vec2(_loc_7.x / Universe.DRAW_SCALE, _loc_7.y / Universe.DRAW_SCALE), 0);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            if (_variety == BASIC)
            {
                _loc_7 = this._ragdoll.getBody("body2");
                _loc_7.scaleX = _sprite.scaleX;
                _loc_6.SetAsOrientedBox(_loc_7.width * 0.5 / Universe.DRAW_SCALE, _loc_7.height * 0.5 / Universe.DRAW_SCALE, new b2Vec2(_loc_7.x / Universe.DRAW_SCALE, _loc_7.y / Universe.DRAW_SCALE), 0);
                _body.CreateShape(_loc_6);
                _loc_7 = this._ragdoll.getBody("body3");
                _loc_7.scaleX = _sprite.scaleX;
                _loc_6.SetAsOrientedBox(_loc_7.width * 0.5 / Universe.DRAW_SCALE, _loc_7.height * 0.5 / Universe.DRAW_SCALE, new b2Vec2(_loc_7.x / Universe.DRAW_SCALE, _loc_7.y / Universe.DRAW_SCALE), 0);
                _body.CreateShape(_loc_6);
            }
            _body.SetMassFromShapes();
            _loc_7 = this._ragdoll.getBody("wheel1");
            _loc_7.scaleX = _sprite.scaleX;
            this._wheelA = CartWheel.get();
            this._wheelA.kind = Kind.CART_WHEEL;
            this._wheelA.init(param1 + _loc_7.x, param2 + _loc_7.y);
            var _loc_8:* = new b2RevoluteJointDef();
            var _loc_9:* = new b2Vec2();
            var _loc_10:* = new b2Vec2(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_7 = this._ragdoll.getJoint("jointWheel1");
            _loc_7.scaleX = _sprite.scaleX;
            _loc_7.addOffset(_loc_10, _loc_9);
            _loc_8.Initialize(_body, this._wheelA.body, _loc_9);
            this._jointA = _universe.physics.CreateJoint(_loc_8) as b2RevoluteJoint;
            _universe.joints.add(this._jointA, STRENGTH_OF_JOINT);
            _loc_7 = this._ragdoll.getBody("wheel2");
            _loc_7.scaleX = _sprite.scaleX;
            this._wheelB = CartWheel.get();
            this._wheelB.kind = Kind.CART_WHEEL;
            this._wheelB.init(param1 + _loc_7.x, param2 + _loc_7.y);
            _loc_7 = this._ragdoll.getJoint("jointWheel2");
            _loc_7.scaleX = _sprite.scaleX;
            _loc_7.addOffset(_loc_10, _loc_9);
            _loc_8.Initialize(_body, this._wheelB.body, _loc_9);
            this._jointB = _universe.physics.CreateJoint(_loc_8) as b2RevoluteJoint;
            _universe.joints.add(this._jointB, STRENGTH_OF_JOINT);
            reset();
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                this._wheelA.free();
                this._wheelB.free();
                _universe.physics.DestroyBody(_body);
                super.free();
            }
            return;
        }// end function

    }
}
