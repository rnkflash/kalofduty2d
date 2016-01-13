package com.zombotron.objects
{
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.interfaces.*;

    public class ChainTriggerElectro extends BasicObject implements IActiveObject
    {
        public var delay:Number;
        private var _alias:String;
        private var _tm:TaskManager;
        private var _isAction:Boolean;
        private var _callback:Function;
        private var _isDone:Boolean;
        public var targetAlias:String;

        public function ChainTriggerElectro()
        {
            this.targetAlias = "null";
            this.delay = 0;
            this._callback = null;
            this._isDone = false;
            this._isAction = false;
            this._tm = new TaskManager();
            _kind = Kind.TRIGGER_ELECTRO;
            _isVisible = false;
            _visibleCulling = false;
            return;
        }// end function

        public function changeState() : void
        {
            var _loc_1:EffectElectroShock = null;
            if (!this._isDone)
            {
                ZG.sound(SoundManager.ELECTRO_SHOCK, this);
                _loc_1 = EffectElectroShock.get();
                _loc_1.init(x, y);
                this._isDone = true;
            }
            return;
        }// end function

        public function get activateDistance() : int
        {
            return -1;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            x = param1;
            y = param2;
            this._isDone = false;
            _universe.objects.add(this);
            this._tm.clear();
            reset();
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector();
        }// end function

        private function doAction() : Boolean
        {
            _universe.objects.callAction(this.targetAlias, this._callback, this._alias);
            this.changeState();
            this._isAction = false;
            return true;
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

        override public function toString() : String
        {
            return "{ChainTriggerElectro [alias: " + this._alias + ", targetAlias: " + this.targetAlias + ", delay: " + this.delay.toString() + "]}";
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
                this._callback = param1;
                this._isAction = true;
                if (this.delay > 0 && !this._isDone)
                {
                    this._tm.addPause(this.delay);
                    this._tm.addTask(this.doAction);
                }
                else
                {
                    this.doAction();
                }
            }
            return;
        }// end function

    }
}
