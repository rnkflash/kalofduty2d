package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.lists.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.interfaces.*;

    public class SomeArea extends BasicObject implements IActiveObject
    {
        private var _x:Number = 0;
        private var _y:Number = 0;
        public var delay:Number = 0;
        private var _bodyWidth:Number = 0;
        private var _bodyHeight:Number = 0;
        private var _alias:String = "nonameSomeArea";
        private var _tm:TaskManager;
        private var _isAction:Boolean;
        private var _bottomRight:Avector;
        private var _topLeft:Avector;

        public function SomeArea()
        {
            _kind = Kind.SOME_AREA;
            _visibleCulling = false;
            _isVisible = false;
            this._topLeft = new Avector();
            this._bottomRight = new Avector();
            this._tm = new TaskManager();
            return;
        }// end function

        override public function toString() : String
        {
            return "{SomeArea [alias: " + this._alias + ", x1: " + this._topLeft.x.toString() + ", y1: " + this._topLeft.y.toString() + ", x2: " + this._bottomRight.x.toString() + ", y2: " + this._bottomRight.y.toString() + "]}";
        }// end function

        private function doDestroy() : void
        {
            var _loc_3:b2Body = null;
            var _loc_1:* = new b2AABB();
            _loc_1.lowerBound.Set(this._topLeft.x, this._topLeft.y);
            _loc_1.upperBound.Set(this._bottomRight.x, this._bottomRight.y);
            var _loc_2:Array = [];
            _universe.physics.Query(_loc_1, _loc_2, 100);
            var _loc_4:* = _loc_2.length;
            var _loc_5:* = new Alist();
            var _loc_6:uint = 0;
            while (_loc_6 < _loc_4)
            {
                
                _loc_3 = (_loc_2[_loc_6] as b2Shape).GetBody();
                if (_loc_3.m_userData is BasicObject)
                {
                    (_loc_3.m_userData as BasicObject).free();
                }
                _loc_6 = _loc_6 + 1;
            }
            return;
        }// end function

        public function action(param1:Function = null) : void
        {
            if (!this._isAction)
            {
                if (this.delay > 0)
                {
                    this._tm.addPause(this.delay);
                    this._tm.addTask(this.doAction);
                }
                else
                {
                    this.doAction();
                }
                this._isAction = true;
                this.free();
            }
            return;
        }// end function

        public function get activateDistance() : int
        {
            return -1;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            this._x = param1 / Universe.DRAW_SCALE;
            this._y = param2 / Universe.DRAW_SCALE;
            this._topLeft.set(this._x - this._bodyWidth, this._y - this._bodyHeight);
            this._bottomRight.set(this._x + this._bodyWidth, this._y + this._bodyHeight);
            this._isAction = false;
            reset();
            _universe.objects.add(this);
            return;
        }// end function

        public function set bodyHeight(param1:Number) : void
        {
            this._bodyHeight = param1 * 0.5 / Universe.DRAW_SCALE;
            return;
        }// end function

        public function changeState() : void
        {
            return;
        }// end function

        public function set bodyWidth(param1:Number) : void
        {
            this._bodyWidth = param1 * 0.5 / Universe.DRAW_SCALE;
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector();
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        private function doAction() : Boolean
        {
            switch(_kind)
            {
                case Kind.CREATE_AREA:
                {
                    this.doCreate();
                    break;
                }
                case Kind.DESTROY_AREA:
                {
                    this.doDestroy();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return true;
        }// end function

        private function doCreate() : void
        {
            _universe.level.makeFromArea(this._topLeft.x * Universe.DRAW_SCALE, this._topLeft.y * Universe.DRAW_SCALE, this._bottomRight.x * Universe.DRAW_SCALE, this._bottomRight.y * Universe.DRAW_SCALE);
            return;
        }// end function

        public function get alias() : String
        {
            return this._alias;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.objects.remove(this);
                super.free();
            }
            return;
        }// end function

        override public function process() : void
        {
            this.debugDraw();
            return;
        }// end function

        private function debugDraw() : void
        {
            if (ZG.debugMode)
            {
                _universe.layerDraws.graphics.lineStyle(1, 12744075, 0.8);
                _universe.layerDraws.graphics.beginFill(12744075, 0);
                _universe.layerDraws.graphics.drawRect(this._topLeft.x * Universe.DRAW_SCALE, this._topLeft.y * Universe.DRAW_SCALE, (this._bottomRight.x - this._topLeft.x) * Universe.DRAW_SCALE, (this._bottomRight.y - this._topLeft.y) * Universe.DRAW_SCALE);
                _universe.layerDraws.graphics.endFill();
            }
            return;
        }// end function

    }
}
