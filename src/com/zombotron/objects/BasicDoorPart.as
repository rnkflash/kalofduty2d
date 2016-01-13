package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.managers.*;
    import com.zombotron.core.*;

    public class BasicDoorPart extends BasicObject
    {
        private var _callback:Function;
        private var _tm:TaskManager;
        private var _speed:Number;
        public var isOpen:Boolean;
        private var _endPos:Number;
        private var _isAction:Boolean;
        public static const TOP:uint = 1;
        public static const SPEED:Number = 0.07;
        public static const BOTTOM:uint = 2;

        public function BasicDoorPart()
        {
            _kind = Kind.DOOR_PART;
            _sprite = ZG.animCache.getAnimation(Art.DOOR);
            this.isOpen = false;
            this._tm = new TaskManager();
            return;
        }// end function

        public function get isDoorClosing() : Boolean
        {
            return this._isAction && this.isOpen ? (true) : (false);
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                this._tm.clear();
                _universe.physics.DestroyBody(_body);
                super.free();
            }
            return;
        }// end function

        public function action(param1:Function) : void
        {
            this._isAction = true;
            switch(_variety)
            {
                case TOP:
                {
                    this._endPos = _body.GetPosition().y;
                    this._endPos = this._endPos + (!this.isOpen ? (-2.1) : (2.1));
                    this._speed = !this.isOpen ? (-SPEED) : (SPEED);
                    break;
                }
                case BOTTOM:
                {
                    this._endPos = _body.GetPosition().y;
                    this._endPos = this._endPos + (!this.isOpen ? (2.1) : (-2.1));
                    this._speed = !this.isOpen ? (SPEED) : (-SPEED);
                    break;
                }
                default:
                {
                    break;
                }
            }
            this._callback = param1;
            this._tm.addTask(this.onAction);
            return;
        }// end function

        public function onAction() : Boolean
        {
            var _loc_1:Boolean = false;
            switch(_variety)
            {
                case TOP:
                {
                    _body.SetXForm(new b2Vec2(_body.GetPosition().x, _body.GetPosition().y + this._speed), 0);
                    if (!this.isOpen && _body.GetPosition().y <= this._endPos || this.isOpen && _body.GetPosition().y >= this._endPos)
                    {
                        _body.SetXForm(new b2Vec2(_body.GetPosition().x, this._endPos), 0);
                        this.isOpen = !this.isOpen;
                        _loc_1 = true;
                        this._isAction = false;
                        if (this._callback != null)
                        {
                            (this._callback as Function).apply(this);
                        }
                    }
                    break;
                }
                case BOTTOM:
                {
                    _body.SetXForm(new b2Vec2(_body.GetPosition().x, _body.GetPosition().y + this._speed), 0);
                    if (!this.isOpen && _body.GetPosition().y >= this._endPos || this.isOpen && _body.GetPosition().y <= this._endPos)
                    {
                        _body.SetXForm(new b2Vec2(_body.GetPosition().x, this._endPos), 0);
                        this.isOpen = !this.isOpen;
                        _loc_1 = true;
                        this._isAction = false;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_1;
        }// end function

        override public function render() : void
        {
            visibleCulling();
            if (_isVisible)
            {
                x = _body.GetPosition().x * Universe.DRAW_SCALE;
                y = _body.GetPosition().y * Universe.DRAW_SCALE;
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_7:Number = NaN;
            _sprite.smoothing = _universe.smoothing;
            _sprite.gotoAndStop(_variety);
            addChild(_sprite);
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_7 = 0;
            _loc_6.vertexCount = 4;
            switch(_variety)
            {
                case TOP:
                {
                    param2 = param2 - 32;
                    _loc_7 = -2.1;
                    _loc_6.vertices[0].Set(-21 / Universe.DRAW_SCALE, -42 / Universe.DRAW_SCALE);
                    _loc_6.vertices[1].Set(21 / Universe.DRAW_SCALE, -42 / Universe.DRAW_SCALE);
                    _loc_6.vertices[2].Set(21 / Universe.DRAW_SCALE, 21 / Universe.DRAW_SCALE);
                    _loc_6.vertices[3].Set(-21 / Universe.DRAW_SCALE, 42 / Universe.DRAW_SCALE);
                    break;
                }
                case BOTTOM:
                {
                    param2 = param2 + 32;
                    _loc_7 = 2.1;
                    _loc_6.vertices[0].Set(-21 / Universe.DRAW_SCALE, -21 / Universe.DRAW_SCALE);
                    _loc_6.vertices[1].Set(21 / Universe.DRAW_SCALE, -42 / Universe.DRAW_SCALE);
                    _loc_6.vertices[2].Set(21 / Universe.DRAW_SCALE, 42 / Universe.DRAW_SCALE);
                    _loc_6.vertices[3].Set(-21 / Universe.DRAW_SCALE, 42 / Universe.DRAW_SCALE);
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_6.density = 0.5;
            _loc_6.friction = 0.2;
            _loc_6.restitution = 0.1;
            _loc_6.filter.categoryBits = 4;
            _loc_5.userData = this;
            _loc_5.angle = param3 * (Math.PI / 180);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            if (this.isOpen)
            {
                _body.SetXForm(new b2Vec2(_body.GetPosition().x, _body.GetPosition().y + _loc_7), 0);
            }
            this._isAction = false;
            reset();
            show();
            return;
        }// end function

    }
}
