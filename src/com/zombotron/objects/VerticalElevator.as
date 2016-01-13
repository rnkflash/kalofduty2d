package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.anim.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.gui.*;
    import com.zombotron.interfaces.*;

    public class VerticalElevator extends BasicObject implements IActiveObject
    {
        private var _aGears:Animation;
        private var _delay:int;
        public var callbackAlias:String;
        private var _count:int = 0;
        private var _pJoint:b2PrismaticJoint;
        private var _aControl:Animation;
        private var _interval:int = 0;
        private var _aShadow:Animation;
        private var _sparksInterval:int = 0;
        private var _aArrow:Animation;
        private var _dir:uint;
        private var _alias:String;
        private var _upperLimit:Number;
        private var _lowerLimit:Number;
        private var _activatePoint:Avector;
        private static const DIR_DOWN:uint = 2;
        private static const SPEED:Number = 0.1;
        private static const DIR_UP:uint = 1;

        public function VerticalElevator()
        {
            _kind = Kind.VERTICAL_ELEVATOR;
            _sprite = ZG.animCache.getAnimation(Art.VERTICAL_ELEVATOR);
            this._aShadow = ZG.animCache.getAnimation(Art.ELEVATOR_SHADOW);
            this._aGears = ZG.animCache.getAnimation(Art.TWO_GEARS);
            this._aControl = ZG.animCache.getAnimation(Art.ELEVATOR_CONTROL1);
            _layer = Universe.LAYER_EFFECTS;
            this._aArrow = ZG.animCache.getAnimation(Art.ACTIVE_ELEMENT);
            this.callbackAlias = "null";
            this._alias = "nonameVerticalElevator";
            this._lowerLimit = 0;
            this._upperLimit = 0;
            this._dir = DIR_UP;
            this._delay = 0;
            this._count = 0;
            this._interval = 0;
            this._sparksInterval = 0;
            return;
        }// end function

        override public function show() : void
        {
            if (!_isVisible)
            {
                _universe.add(this, _layer);
                _universe.add(this._aShadow, Universe.LAYER_BG_OBJECTS);
                _isVisible = true;
                this._aArrow.play();
            }
            return;
        }// end function

        public function get activateDistance() : int
        {
            return 1;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            addChild(_sprite);
            this._aGears.x = 7;
            this._aGears.y = -10;
            this._aShadow.addChild(this._aGears);
            this._activatePoint = new Avector(-0.6, -1.6);
            this._aControl.x = this._activatePoint.x * Universe.DRAW_SCALE;
            this._aControl.y = this._activatePoint.y * Universe.DRAW_SCALE;
            this._aShadow.addChild(this._aControl);
            this._aControl.gotoAndStop(this._dir == DIR_UP ? (1) : (2));
            this._aControl.addChild(this._aArrow);
            this._aArrow.y = -45;
            this._aArrow.play();
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_6.density = 0.5;
            _loc_6.friction = 0.8;
            _loc_6.restitution = 0;
            _loc_6.filter.categoryBits = 4;
            _loc_5.userData = this;
            _loc_5.fixedRotation = true;
            _loc_6.SetAsBox(50 / Universe.DRAW_SCALE, 10 / Universe.DRAW_SCALE);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_5.angle = Amath.toRadians(param3);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            var _loc_7:* = _universe.physics.GetGroundBody();
            var _loc_8:* = new b2PrismaticJointDef();
            _loc_8.Initialize(_loc_7, _body, _body.GetWorldCenter(), new b2Vec2(Math.cos(Math.PI / 2), Math.sin(Math.PI / 2)));
            _loc_8.lowerTranslation = 0;
            _loc_8.upperTranslation = 0;
            if (this._lowerLimit < _body.GetPosition().y)
            {
                _loc_8.lowerTranslation = -(_body.GetPosition().y - this._lowerLimit);
            }
            if (this._upperLimit > _body.GetPosition().y)
            {
                _loc_8.upperTranslation = this._upperLimit - this._lowerLimit;
            }
            _loc_8.enableLimit = true;
            _loc_8.enableMotor = true;
            this._pJoint = _universe.physics.CreateJoint(_loc_8) as b2PrismaticJoint;
            this._pJoint.SetMaxMotorForce(80);
            _isFree = false;
            _isDead = false;
            _die = false;
            _universe.add(this, _layer);
            _universe.add(this._aShadow, Universe.LAYER_BG_OBJECTS);
            _universe.objects.add(this);
            return;
        }// end function

        public function set dir(param1:String) : void
        {
            switch(param1)
            {
                case "up":
                {
                    this._dir = DIR_UP;
                    break;
                }
                case "down":
                {
                    this._dir = DIR_DOWN;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override public function render() : void
        {
            var _loc_1:Avector = null;
            visibleCulling();
            x = _body.GetPosition().x * Universe.DRAW_SCALE;
            y = _body.GetPosition().y * Universe.DRAW_SCALE;
            if (_isVisible)
            {
                this._aShadow.x = this.x;
                this._aShadow.y = this.y + 20;
                if (_isDead)
                {
                    rotation = _body.GetAngle() / Math.PI * 180 % 360;
                    this._aShadow.rotation = rotation;
                    _loc_1 = Amath.rotatePointDeg(this._aShadow.x, this._aShadow.y, this.x, this.y, rotation);
                    this._aShadow.x = _loc_1.x;
                    this._aShadow.y = _loc_1.y;
                }
            }
            return;
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        private function makeDeadBody(param1:int, param2:int) : void
        {
            _universe.physics.DestroyJoint(this._pJoint);
            _universe.physics.DestroyBody(_body);
            _sprite.smoothing = _universe.smoothing;
            this._aGears.smoothing = _universe.smoothing;
            this._aControl.smoothing = _universe.smoothing;
            var _loc_3:* = new b2BodyDef();
            var _loc_4:* = new b2PolygonDef();
            _loc_4.density = 0.5;
            _loc_4.friction = 0.8;
            _loc_4.restitution = 0;
            _loc_4.filter.categoryBits = 4;
            _loc_3.userData = this;
            _loc_4.SetAsBox(50 / Universe.DRAW_SCALE, 10 / Universe.DRAW_SCALE);
            _loc_3.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _body = _universe.physics.CreateBody(_loc_3);
            _body.CreateShape(_loc_4);
            _body.SetMassFromShapes();
            var _loc_5:* = EffectExplosion.get();
            _loc_5.variety = EffectExplosion.OBJECT_EXPLOSION;
            _loc_5.init(param1 + 10, param2 + 18);
            ZG.sound(SoundManager.OBJECT_EXPLOSION, this);
            ZG.media.stop(SoundManager.ELEVATOR_MOVE);
            ZG.saveBox.exterminator = 1;
            _universe.checkAchievement(AchievementItem.EXTERMINATOR);
            _isDead = true;
            return;
        }// end function

        public function action(param1:Function = null) : void
        {
            if (_isDead)
            {
                return;
            }
            this._dir = this._dir == DIR_UP ? (DIR_DOWN) : (DIR_UP);
            this.changeState();
            ZG.sound(SoundManager.ACTION_PRESS_BUTTON, this, true);
            this._aGears.play();
            _body.WakeUp();
            ZG.media.stop(SoundManager.ELEVATOR_MOVE);
            ZG.sound(SoundManager.ELEVATOR_MOVE, this, true);
            if (param1 != null)
            {
                (param1 as Function).apply(this);
            }
            _universe.objects.callChangeState(this.callbackAlias, this._alias);
            if (_universe.frameTime - this._interval < 35)
            {
                var _loc_2:String = this;
                var _loc_3:* = this._count + 1;
                _loc_2._count = _loc_3;
                if (this._count == 8)
                {
                    this.makeDeadBody(this.x, this.y);
                }
            }
            this._interval = _universe.frameTime;
            return;
        }// end function

        public function changeState() : void
        {
            switch(this._dir)
            {
                case DIR_UP:
                {
                    this._aGears.reverse = false;
                    this._aControl.gotoAndStop(1);
                    this.makeSparks();
                    break;
                }
                case DIR_DOWN:
                {
                    this._aGears.reverse = true;
                    this._aControl.gotoAndStop(2);
                    this.makeSparks();
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
                _universe.remove(this._aShadow, Universe.LAYER_BG_OBJECTS);
                _isVisible = false;
                this._aArrow.stop();
            }
            return;
        }// end function

        override public function addContact(param1:b2ContactPoint) : Boolean
        {
            var _loc_2:BasicObject = null;
            var _loc_3:b2Vec2 = null;
            if (this._dir == DIR_DOWN)
            {
                if (param1.shape1.GetBody().GetUserData() as BasicObject != this)
                {
                    _loc_2 = param1.shape1.GetBody().GetUserData() as BasicObject;
                }
                else if (param1.shape2.GetBody().GetUserData() as BasicObject != this)
                {
                    _loc_2 = param1.shape2.GetBody().GetUserData() as BasicObject;
                }
                if (_loc_2 is Player)
                {
                    _loc_3 = _universe.playerBody.GetPosition();
                    if (_loc_3.y > _body.GetPosition().y && _loc_3.x > _body.GetPosition().x - 1.6 && _loc_3.x < _body.GetPosition().x + 1.6)
                    {
                        this.action();
                    }
                }
            }
            return super.addContact(param1);
        }// end function

        private function makeSparks() : void
        {
            var _loc_1:EffectSpark = null;
            var _loc_2:uint = 0;
            if (_universe.frameTime - this._sparksInterval > 15)
            {
                _loc_2 = 0;
                while (_loc_2 < 2)
                {
                    
                    _loc_1 = EffectSpark.get();
                    _loc_1.variety = Amath.random(1, 2);
                    _loc_1.speed = new Avector(Amath.random(-3, 3), Amath.random(-1, -2));
                    _loc_1.init(this.x + 10, this.y + 18);
                    _loc_2 = _loc_2 + 1;
                }
                this._sparksInterval = _universe.frameTime;
            }
            return;
        }// end function

        public function get alias() : String
        {
            return this._alias;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector(_body.GetPosition().x + this._activatePoint.x, _body.GetPosition().y + this._activatePoint.y);
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                this._aGears.stop();
                ZG.media.stop(SoundManager.ELEVATOR_MOVE);
                _universe.physics.DestroyBody(_body);
                _universe.objects.remove(this);
                this._aShadow.removeChild(this._aControl);
                this._aShadow.removeChild(this._aGears);
                this._aControl.removeChild(this._aArrow);
                this._aArrow.stop();
                super.free();
            }
            return;
        }// end function

        override public function process() : void
        {
            switch(this._dir)
            {
                case DIR_UP:
                {
                    this._pJoint.SetMotorSpeed(-3);
                    break;
                }
                case DIR_DOWN:
                {
                    this._pJoint.SetMotorSpeed(3);
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this._aGears.playing && Math.abs(_body.GetLinearVelocity().y) < 1)
            {
                var _loc_1:String = this;
                var _loc_2:* = this._delay + 1;
                _loc_1._delay = _loc_2;
                if (this._delay >= 4)
                {
                    this._delay = 0;
                    this._aGears.stop();
                    ZG.media.stop(SoundManager.ELEVATOR_MOVE);
                    this.makeSparks();
                }
            }
            else if (!this._aGears.playing && Math.abs(_body.GetLinearVelocity().y) > 2)
            {
                this._aGears.play();
                ZG.sound(SoundManager.ELEVATOR_MOVE, this);
                this.makeSparks();
            }
            return;
        }// end function

        public function set upperLimit(param1:Number) : void
        {
            this._upperLimit = param1 / Universe.DRAW_SCALE;
            return;
        }// end function

        public function set lowerLimit(param1:Number) : void
        {
            this._lowerLimit = param1 / Universe.DRAW_SCALE;
            return;
        }// end function

    }
}
