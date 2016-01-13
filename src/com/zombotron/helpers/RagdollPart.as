package com.zombotron.helpers
{
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;

    public class RagdollPart extends Object
    {
        public var width:Number;
        public var scaleY:int;
        public var alias:String;
        public var upperAngle:Number;
        public var lowerAngle:Number;
        public var angle:Number;
        public var kind:uint;
        public var scaleX:int;
        public var height:Number;
        public var enableLimit:Boolean;
        private var _x:Number;
        private var _y:Number;
        public static const BODY:uint = 1;
        public static const JOINT:uint = 2;

        public function RagdollPart()
        {
            this.alias = "none";
            this.kind = BODY;
            this.width = 0;
            this.height = 0;
            this.angle = 0;
            this.scaleX = 1;
            this.scaleY = 1;
            this.enableLimit = false;
            this.lowerAngle = 0;
            this.upperAngle = 0;
            this._x = 0;
            this._y = 0;
            return;
        }// end function

        public function get y() : Number
        {
            return this._y * this.scaleY;
        }// end function

        public function set y(param1:Number) : void
        {
            this._y = param1;
            return;
        }// end function

        public function setLimits(param1:b2RevoluteJointDef) : void
        {
            var _loc_2:* = this.lowerAngle * this.scaleX;
            var _loc_3:* = this.upperAngle * this.scaleX;
            param1.enableLimit = this.enableLimit;
            param1.lowerAngle = Amath.toRadians(_loc_2 < _loc_3 ? (_loc_2) : (_loc_3));
            param1.upperAngle = Amath.toRadians(_loc_3 > _loc_2 ? (_loc_3) : (_loc_2));
            return;
        }// end function

        public function addOffset(param1:b2Vec2, param2:b2Vec2) : void
        {
            param2.x = param1.x + this.x / Universe.DRAW_SCALE;
            param2.y = param1.y + this.y / Universe.DRAW_SCALE;
            return;
        }// end function

        public function set x(param1:Number) : void
        {
            this._x = param1;
            return;
        }// end function

        public function get x() : Number
        {
            return this._x * this.scaleX;
        }// end function

    }
}
