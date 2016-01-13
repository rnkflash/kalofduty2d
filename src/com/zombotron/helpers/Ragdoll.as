package com.zombotron.helpers
{
    import flash.display.*;
    import flash.utils.*;

    public class Ragdoll extends Object
    {
        private var _joints:Array;
        private var _bodies:Array;

        public function Ragdoll(param1:String = "")
        {
            this._bodies = [];
            this._joints = [];
            if (param1 != "")
            {
                this.makeFromClip(new getDefinitionByName(param1));
            }
            return;
        }// end function

        public function getJoint(param1:String) : RagdollPart
        {
            var _loc_2:RagdollPart = null;
            var _loc_3:* = this._joints.length;
            var _loc_4:uint = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = this._joints[_loc_4] as RagdollPart;
                if (_loc_2 != null && _loc_2.alias == param1)
                {
                    return _loc_2;
                }
                _loc_4 = _loc_4 + 1;
            }
            return null;
        }// end function

        public function makeFromClip(param1:MovieClip) : void
        {
            var _loc_2:Object = null;
            var _loc_3:RagdollPart = null;
            var _loc_5:Sprite = null;
            var _loc_4:* = param1.numChildren;
            var _loc_6:uint = 0;
            while (_loc_6 < _loc_4)
            {
                
                _loc_5 = param1.getChildAt(_loc_6) as Sprite;
                if (_loc_5 == null)
                {
                }
                else if (_loc_5 is RagdollBody_com)
                {
                    _loc_2 = _loc_5 as RagdollBody_com;
                    _loc_3 = new RagdollPart();
                    _loc_3.alias = _loc_2.alias;
                    _loc_3.kind = RagdollPart.BODY;
                    _loc_3.x = _loc_2.x;
                    _loc_3.y = _loc_2.y;
                    _loc_3.angle = _loc_2.rotation;
                    _loc_2.rotation = 0;
                    _loc_3.width = _loc_2.width;
                    _loc_3.height = _loc_2.height;
                    this._bodies[this._bodies.length] = _loc_3;
                }
                else if (_loc_5 is RagdollJoint_com)
                {
                    _loc_2 = _loc_5 as RagdollJoint_com;
                    _loc_3 = new RagdollPart();
                    _loc_3.alias = _loc_2.alias;
                    _loc_3.kind = RagdollPart.JOINT;
                    _loc_3.x = _loc_2.x;
                    _loc_3.y = _loc_2.y;
                    _loc_3.enableLimit = _loc_2.enableLimit;
                    _loc_3.lowerAngle = _loc_2.lowerAngle;
                    _loc_3.upperAngle = _loc_2.upperAngle;
                    this._joints[this._joints.length] = _loc_3;
                }
                _loc_6 = _loc_6 + 1;
            }
            return;
        }// end function

        public function getBody(param1:String) : RagdollPart
        {
            var _loc_2:RagdollPart = null;
            var _loc_3:* = this._bodies.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = this._bodies[_loc_4] as RagdollPart;
                if (_loc_2 != null && _loc_2.alias == param1)
                {
                    return _loc_2;
                }
                _loc_4++;
            }
            return null;
        }// end function

        public function free() : void
        {
            this._bodies.length = 0;
            this._joints.length = 0;
            return;
        }// end function

    }
}
