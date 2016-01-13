package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.anim.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;

    public class HorizontalElevator extends BasicObject implements IActiveObject
    {
        public var callbackAlias:String;
        private var _aControl:Animation;
        private var _isMove:Boolean;
        private var _actionPoint:Avector;
        private var _aArrow:Animation;
        private var _dir:uint;
        private var _alias:String;
        private var _upperLimit:Number;
        private var _lowerLimit:Number;
        private var _wheel:ElevatorWheel;
        private var _sparksInterval:int;
        private var _aBack:Animation;
        private var _motor:b2RevoluteJoint;
        private static const DIR_LEFT:uint = 1;
        private static const DIR_RIGHT:uint = 2;

        public function HorizontalElevator()
        {
            this.callbackAlias = "null";
            this._alias = "nonameHorizontalElevator";
            this._dir = DIR_LEFT;
            this._lowerLimit = 0;
            this._upperLimit = 0;
            this._actionPoint = new Avector();
            this._isMove = false;
            this._sparksInterval = 0;
            _kind = Kind.HORIZONTAL_ELEVATOR;
            _sprite = ZG.animCache.getAnimation(Art.HORIZONTAL_ELEVATOR);
            this._aBack = ZG.animCache.getAnimation(Art.HORIZONTAL_ELEVATOR_BG);
            this._aControl = ZG.animCache.getAnimation(Art.ELEVATOR_CONTROL2);
            this._aArrow = ZG.animCache.getAnimation(Art.ACTIVE_ELEMENT);
            _layer = Universe.LAYER_FG;
            return;
        }// end function

        public function get activateDistance() : int
        {
            return 1;
        }// end function

        public function set lowerLimit(param1:Number) : void
        {
            this._lowerLimit = param1 / Universe.DRAW_SCALE;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_6:b2PolygonDef = null;
            this._wheel = new ElevatorWheel();
            this._wheel.init(param1, param2);
            var _loc_5:* = new b2BodyDef();
            _loc_6 = new b2PolygonDef();
            _loc_6.density = 0.5;
            _loc_6.friction = 0.8;
            _loc_6.restitution = 0;
            _loc_6.filter.categoryBits = 4;
            _loc_5.userData = this;
            _loc_6.SetAsOrientedBox(40 / Universe.DRAW_SCALE, 2 / Universe.DRAW_SCALE, new b2Vec2(0, 1.3), 0);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_5.angle = Amath.toRadians(param3);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _loc_6.SetAsOrientedBox(50 / Universe.DRAW_SCALE, 6 / Universe.DRAW_SCALE, new b2Vec2(0, 4.3), 0);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            this._aControl.smoothing = _universe.smoothing;
            this._aControl.x = -16;
            this._aControl.y = 108;
            this._aControl.gotoAndStop(this._dir == DIR_LEFT ? (1) : (2));
            this._actionPoint.x = -16 / Universe.DRAW_SCALE;
            this._actionPoint.y = 108 / Universe.DRAW_SCALE;
            this._aControl.addChild(this._aArrow);
            this._aArrow.y = -30;
            this._aArrow.play();
            this._aBack.smoothing = _universe.smoothing;
            this._aBack.addChild(this._aControl);
            _sprite.smoothing = _universe.smoothing;
            addChild(_sprite);
            var _loc_7:* = new b2RevoluteJointDef();
            _loc_7.enableMotor = true;
            _loc_7.Initialize(_body, this._wheel.body, this._wheel.body.GetWorldCenter());
            this._motor = _universe.physics.CreateJoint(_loc_7) as b2RevoluteJoint;
            this._motor.SetMaxMotorTorque(40);
            reset();
            this.show();
            _universe.objects.add(this);
            return;
        }// end function

        override public function render() : void
        {
            this.visibleCulling();
            if (_isVisible)
            {
                x = _body.GetPosition().x * Universe.DRAW_SCALE;
                y = _body.GetPosition().y * Universe.DRAW_SCALE;
                rotation = _body.GetAngle() / Math.PI * 180 % 360;
                this._aBack.x = x;
                this._aBack.y = y;
                this._aBack.rotation = rotation;
            }
            return;
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        public function action(param1:Function = null) : void
        {
            this.makeSparks();
            this._dir = this._dir == DIR_LEFT ? (DIR_RIGHT) : (DIR_LEFT);
            _body.WakeUp();
            switch(this._dir)
            {
                case DIR_LEFT:
                {
                    this._motor.SetMotorSpeed(-5);
                    break;
                }
                case DIR_RIGHT:
                {
                    this._motor.SetMotorSpeed(5);
                    break;
                }
                default:
                {
                    break;
                }
            }
            _universe.objects.callChangeState(this.callbackAlias);
            this._isMove = true;
            this.changeState();
            ZG.sound(SoundManager.ELEVATOR_MOVE, this, true);
            ZG.sound(SoundManager.ACTION_PRESS_BUTTON, this, true);
            return;
        }// end function

        public function changeState() : void
        {
            switch(this._dir)
            {
                case DIR_LEFT:
                {
                    this._aControl.gotoAndStop(1);
                    break;
                }
                case DIR_RIGHT:
                {
                    this._aControl.gotoAndStop(2);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override public function hide() : void
        {
            if (_isVisible)
            {
                _universe.remove(this, _layer);
                _universe.remove(this._aBack, Universe.LAYER_BG_OBJECTS);
                this._aArrow.stop();
                _isVisible = false;
            }
            return;
        }// end function

        private function makeSparks() : void
        {
            var _loc_1:EffectSpark = null;
            var _loc_2:int = 0;
            var _loc_3:uint = 0;
            if (_universe.frameTime - this._sparksInterval > 15)
            {
                _loc_3 = 0;
                while (_loc_3 < 2)
                {
                    
                    _loc_1 = EffectSpark.get();
                    _loc_1.variety = Amath.random(1, 2);
                    _loc_2 = this._dir == DIR_LEFT ? (Amath.random(-4, -1)) : (Amath.random(1, 4));
                    _loc_1.speed = new Avector(_loc_2, Amath.random(-1, -2));
                    _loc_1.init(this._wheel.x, this._wheel.y + 18);
                    _loc_3 = _loc_3 + 1;
                }
                this._sparksInterval = _universe.frameTime;
            }
            return;
        }// end function

        private function offMotor() : void
        {
            this._motor.SetMotorSpeed(0);
            ZG.media.stop(SoundManager.ELEVATOR_MOVE);
            this.makeSparks();
            this._isMove = false;
            return;
        }// end function

        public function get alias() : String
        {
            return this._alias;
        }// end function

        public function set curDir(param1:String) : void
        {
            switch(param1)
            {
                case "right":
                {
                    this._dir = DIR_RIGHT;
                    break;
                }
                default:
                {
                    this._dir = DIR_LEFT;
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            var _loc_1:* = new Avector(_body.GetPosition().x, _body.GetPosition().y);
            _loc_1 = Amath.rotatePointDeg(_loc_1.x + this._actionPoint.x, _loc_1.y + this._actionPoint.y, _body.GetPosition().x, _body.GetPosition().y, Amath.toDegrees(_body.GetAngle()));
            return _loc_1;
        }// end function

        override public function visibleCulling() : void
        {
            if (_visibleCulling)
            {
                _tileX = _body.GetPosition().x * Universe.DRAW_SCALE / LevelBase.TILE_SIZE;
                _tileY = (_body.GetPosition().y * Universe.DRAW_SCALE + 100) / LevelBase.TILE_SIZE;
                if (_tileX >= _universe.level.tileX1 && _tileX < _universe.level.tileX2 && _tileY >= _universe.level.tileY1 && _tileY < _universe.level.tileY2)
                {
                    this.show();
                }
                else
                {
                    this.hide();
                }
            }
            return;
        }// end function

        override public function toString() : String
        {
            return "{HorizontalElevator [alias: " + this._alias + ", callbackAlias: " + this.callbackAlias + "}";
        }// end function

        override public function process() : void
        {
            if (this._isMove)
            {
                switch(this._dir)
                {
                    case DIR_LEFT:
                    {
                        if (_body.GetPosition().x <= this._lowerLimit)
                        {
                            this.offMotor();
                        }
                        break;
                    }
                    case DIR_RIGHT:
                    {
                        if (_body.GetPosition().x >= this._upperLimit)
                        {
                            this.offMotor();
                        }
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

        public function set upperLimit(param1:Number) : void
        {
            this._upperLimit = param1 / Universe.DRAW_SCALE;
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                this.offMotor();
                _universe.objects.remove(this);
                _universe.physics.DestroyBody(_body);
                this._aBack.removeChild(this._aControl);
                this._aArrow.stop();
                this._aControl.removeChild(this._aArrow);
                super.free();
            }
            return;
        }// end function

        override public function show() : void
        {
            if (!_isVisible)
            {
                _universe.add(this._aBack, Universe.LAYER_BG_OBJECTS);
                _universe.add(this, _layer);
                this._aArrow.play();
                _isVisible = true;
            }
            return;
        }// end function

    }
}
