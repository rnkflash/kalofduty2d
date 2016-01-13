package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;

    public class BossPart extends BasicObject
    {
        private var _height:Number = 10;
        private var _width:Number = 10;
        private var _lifeTime:int;
        private var _tmCoins:TaskManager;
        private var _tm:TaskManager;
        public static const HEAD:int = 2;
        public static const BODY:int = 1;
        public static const LEG_RIGHT:int = 3;
        public static const HAND_RIGHT:int = 7;
        public static const LEG_LEFT:int = 4;
        public static const HAND_LEFT1:int = 5;
        public static const HAND_LEFT2:int = 6;

        public function BossPart()
        {
            this._tm = new TaskManager();
            this._tmCoins = new TaskManager();
            _kind = Kind.BOSS_PART;
            _sprite = ZG.animCache.getAnimation(Art.BOSS_PARTS);
            _visibleCulling = false;
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

        public function setSize(param1:Number, param2:Number) : void
        {
            this._width = param1 * 0.5;
            this._height = param2 * 0.5;
            return;
        }// end function

        private function taskMakeBlood(param1:b2Body) : Boolean
        {
            var _loc_2:* = EffectBlood.get();
            _loc_2.init(param1.GetPosition().x * Universe.DRAW_SCALE, param1.GetPosition().y * Universe.DRAW_SCALE);
            return true;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.bodies.remove(this);
                _universe.physics.DestroyBody(_body);
                super.free();
            }
            return;
        }// end function

        override public function process() : void
        {
            return;
        }// end function

        override public function jointDead(param1:b2RevoluteJoint = null) : void
        {
            var _loc_2:b2Vec2 = null;
            if (_variety == HEAD)
            {
                _loc_2 = _body.GetLinearVelocity();
                _loc_2.x = _loc_2.x * 0.02;
                _body.ApplyImpulse(new b2Vec2(_loc_2.x, -1), _body.GetWorldCenter());
                _body.SetAngularVelocity(_body.GetAngularVelocity() * 0.2);
                this.makeBloodFountain(_body, 13);
            }
            else
            {
                this.makeBloodFountain(_body, 5);
            }
            return;
        }// end function

        private function onMakeCoin() : void
        {
            var _loc_1:* = new b2Vec2(Amath.random(-3, 3) / 20, (Amath.random(-3, -2) - Math.random()) / 10);
            var _loc_2:* = Coin.get();
            _loc_2.init(this.x + Amath.random(-5, 5), this.y + Amath.random(-5, 5));
            _loc_2.body.ApplyImpulse(_loc_1, _loc_2.body.GetWorldCenter());
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_6:b2PolygonDef = null;
            var _loc_7:int = 0;
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
            if (_variety == BODY)
            {
                _loc_7 = 0;
                while (_loc_7 < 20)
                {
                    
                    this._tmCoins.addInstantTask(this.onMakeCoin);
                    this._tmCoins.addPause(Amath.random(1, 2));
                    _loc_7++;
                }
            }
            reset();
            this._lifeTime = 250;
            this._tm.clear();
            _universe.bodies.add(this);
            update();
            return;
        }// end function

    }
}
