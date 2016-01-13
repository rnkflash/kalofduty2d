package com.zombotron.gui
{
    import com.antkarlov.managers.*;
    import com.zombotron.core.*;
    import flash.display.*;

    public class MissionIco extends Sprite
    {
        public var isCompleted:Boolean = false;
        private var _id:int = 0;
        private var _curLabel:TextLabel;
        private var _isFree:Boolean = true;
        private var _tm:TaskManager;
        private var _condition:uint = 0;
        private var _ico:MovieClip;
        private var _isHide:Boolean = false;
        private var _totalLabel:TextLabel;
        private var _value:int = 0;
        private var _isGreen:Boolean = false;

        public function MissionIco()
        {
            this._tm = new TaskManager();
            return;
        }// end function

        private function doGray() : void
        {
            this._curLabel.setColor(TextLabel.COLOR_GRAY);
            this._totalLabel.setColor(TextLabel.COLOR_GRAY);
            this._ico.gotoAndStop((this._condition + 1));
            return;
        }// end function

        public function init(param1:uint, param2:int, param3:int) : void
        {
            this._condition = param1;
            this._value = param2;
            this._id = param3;
            this._ico = new MissionIco_mc();
            this._ico.gotoAndStop((param1 + 1));
            addChild(this._ico);
            this._curLabel = new TextLabel(TextLabel.TEXT16);
            this._curLabel.setColor(TextLabel.COLOR_GRAY);
            this._curLabel.setText("0");
            this._curLabel.x = -12 - this._curLabel.getWidth();
            this._curLabel.y = -4;
            addChild(this._curLabel);
            this._curLabel.show();
            this._totalLabel = new TextLabel(TextLabel.TEXT_SMALL);
            this._totalLabel.setColor(TextLabel.COLOR_GRAY);
            this._totalLabel.setText(Text.TXT_OF + this._value.toString());
            this._totalLabel.x = -16;
            this._totalLabel.y = 6;
            addChild(this._totalLabel);
            this._totalLabel.show();
            this._isFree = false;
            return;
        }// end function

        public function hide() : void
        {
            if (!this._isHide)
            {
                this._tm.clear();
                this._tm.addTask(this.doHide);
                this._isHide = true;
            }
            return;
        }// end function

        public function get condition() : uint
        {
            return this._condition;
        }// end function

        public function get id() : int
        {
            return this._id;
        }// end function

        public function updateValue(param1:int, param2:Boolean) : void
        {
            if (!this._isFree)
            {
                this._curLabel.setText(param1.toString());
                this._curLabel.x = -12 - this._curLabel.getWidth();
                if (param2)
                {
                    this._tm.clear();
                    if (!this._isGreen)
                    {
                        this._tm.addInstantTask(this.doGreen);
                        this._tm.addPause(10);
                        this._tm.addInstantTask(this.doGray);
                    }
                    else
                    {
                        this._tm.addPause(10);
                        this._tm.addInstantTask(this.doGray);
                    }
                }
            }
            return;
        }// end function

        private function doHide() : Boolean
        {
            this.alpha = this.alpha - 0.1;
            if (this.alpha <= 0)
            {
                this.alpha = 0;
                this.free();
                return true;
            }
            return false;
        }// end function

        public function get value() : int
        {
            return this._value;
        }// end function

        public function get isFree() : Boolean
        {
            return this._isFree;
        }// end function

        public function free() : void
        {
            if (!this._isFree)
            {
                removeChild(this._ico);
                this._curLabel.free();
                this._totalLabel.free();
                this._tm.clear();
                if (this.parent != null)
                {
                    this.parent.removeChild(this);
                }
                this._isFree = true;
            }
            return;
        }// end function

        public function show() : void
        {
            return;
        }// end function

        private function doGreen() : void
        {
            this._curLabel.setColor(TextLabel.COLOR_LIME);
            this._totalLabel.setColor(TextLabel.COLOR_LIME);
            this._ico.gotoAndStop(this._condition);
            return;
        }// end function

    }
}
