package com.zombotron.objects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.interfaces.*;

    public class Respawn extends BasicObject implements IActiveObject
    {
        private var _isActive:Boolean = false;
        private var _alias:String = "nonameCheckpoint";
        public var targetAlias:String = "null";

        public function Respawn()
        {
            _kind = Kind.CHECKPOINT;
            _isVisible = false;
            _visibleCulling = false;
            return;
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        public function changeState() : void
        {
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector();
        }// end function

        public function get activateDistance() : int
        {
            return -1;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            reset();
            this._isActive = false;
            this.x = param1;
            this.y = param2;
            _universe.objects.add(this);
            return;
        }// end function

        public function get alias() : String
        {
            return this._alias;
        }// end function

        public function action(param1:Function = null) : void
        {
            if (!this._isActive)
            {
                _universe.setCheckpoint(this.alias, this.targetAlias, new Avector(this.x, this.y));
                this._isActive = true;
                this.free();
            }
            return;
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

    }
}
