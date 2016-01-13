package com.zombotron.objects
{
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.interfaces.*;

    public class SomeAction extends BasicObject implements IActiveObject
    {
        public var targetJoint:b2RevoluteJoint = null;
        public var delay:int = 0;
        private var _alias:String;
        public var targetBody:b2Body = null;
        private var _tm:TaskManager;
        private var _isAction:Boolean;
        private var _x:Number;
        private var _y:Number;
        public static const DESTROY_JOINT:uint = 1;
        public static const DESTROY_BODY:uint = 2;

        public function SomeAction()
        {
            _kind = Kind.ACTION;
            _variety = DESTROY_JOINT;
            this._alias = "nonameSomeAction";
            this._tm = new TaskManager();
            this._x = 0;
            this._y = 0;
            return;
        }// end function

        public function changeState() : void
        {
            return;
        }// end function

        public function get activateDistance() : int
        {
            return -1;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            this._x = param1;
            this._y = param2;
            this._isAction = false;
            reset();
            _universe.objects.add(this);
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector();
        }// end function

        private function doAction() : void
        {
            switch(_variety)
            {
                case DESTROY_JOINT:
                {
                    if (this.targetJoint != null)
                    {
                        if ((this.targetJoint.GetBody1().GetUserData() as BasicObject).body != null && (this.targetJoint.GetBody2().GetUserData() as BasicObject).body != null)
                        {
                            _universe.joints.kill(this.targetJoint);
                        }
                        this.targetJoint = null;
                        this._isAction = true;
                    }
                    break;
                }
                case DESTROY_BODY:
                {
                    if (this.targetBody != null)
                    {
                        _universe.physics.DestroyBody(this.targetBody);
                        this.targetBody = null;
                        this._isAction = true;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this._isAction)
            {
                this.free();
            }
            return;
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
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

        public function action(param1:Function = null) : void
        {
            if (!this._isAction)
            {
                this._tm.clear();
                this._tm.addPause(this.delay);
                this._tm.addInstantTask(this.doAction);
                this._isAction = true;
                this.free();
            }
            return;
        }// end function

    }
}
