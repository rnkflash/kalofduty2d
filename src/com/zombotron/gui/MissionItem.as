package com.zombotron.gui
{
    import com.antkarlov.managers.*;
    import com.zombotron.core.*;
    import flash.display.*;

    public class MissionItem extends Sprite
    {
        private var _line3:TextLabel;
        private var _isCompleted:Boolean = false;
        private var _line1:TextLabel;
        private var _line2:TextLabel;
        private var _isFree:Boolean = true;
        private var _icon:MovieClip;
        private var _title:TextLabel;
        private var _tm:TaskManager;

        public function MissionItem()
        {
            this._tm = new TaskManager();
            this._icon = new MissionIco_mc();
            return;
        }// end function

        private function doShowIcon() : Boolean
        {
            this._icon.alpha = this._icon.alpha + 0.2;
            if (this._icon.alpha >= 1)
            {
                this._icon.alpha = 1;
                return true;
            }
            return false;
        }// end function

        public function init(param1:uint, param2:String, param3:String, param4:Boolean, param5:int = 0) : void
        {
            var _loc_6:* = param4 ? (ZG.divideString(param3, 20)) : (ZG.divideString(param2, 20));
            this._line1 = new TextLabel(TextLabel.TEXT8);
            this._line1.setAnim(TextLabel.ANIM_PRINT);
            if (_loc_6.length >= 1)
            {
                this._line1.setText(_loc_6[0]);
            }
            this._line2 = new TextLabel(TextLabel.TEXT8);
            this._line2.setAnim(TextLabel.ANIM_PRINT);
            if (_loc_6.length >= 2)
            {
                this._line2.setText(_loc_6[1]);
            }
            this._line3 = new TextLabel(TextLabel.TEXT8);
            this._line3.setAnim(TextLabel.ANIM_PRINT);
            if (_loc_6.length >= 3)
            {
                this._line3.setText(_loc_6[2]);
            }
            var _loc_7:int = 17;
            this._line3.x = 17;
            var _loc_7:* = _loc_7;
            this._line2.x = _loc_7;
            this._line1.x = _loc_7;
            this._line1.y = -3;
            this._line2.y = 6;
            this._line3.y = 15;
            this._isCompleted = param4;
            if (this._isCompleted)
            {
                this._icon = new SmallStar_mc();
                this._icon.gotoAndStop(param5);
                this._title = new TextLabel(TextLabel.TEXT16);
                this._title.setAnim(TextLabel.ANIM_PRINT);
                this._title.setText(Text.TXT_COMPLETED);
                this._title.setColor(TextLabel.COLOR_ORANGE);
                this._title.x = 17;
                this._title.y = -5;
                addChild(this._title);
                this._line1.y = this._line1.y + 12;
                this._line2.y = this._line2.y + 12;
                this._line3.y = this._line3.y + 12;
                var _loc_7:Number = 0.5;
                this._line3.alpha = 0.5;
                var _loc_7:* = _loc_7;
                this._line2.alpha = _loc_7;
                this._line1.alpha = _loc_7;
            }
            else
            {
                this._icon = new MissionIco_mc();
                this._icon.gotoAndStop(param1);
            }
            this._icon.alpha = 0;
            addChild(this._line1);
            addChild(this._line2);
            addChild(this._line3);
            addChild(this._icon);
            this._isFree = false;
            visible = false;
            return;
        }// end function

        public function hide() : void
        {
            this._tm.addTask(this.doHide);
            return;
        }// end function

        public function free() : void
        {
            if (!this._isFree)
            {
                this._line1.free();
                this._line2.free();
                this._line3.free();
                if (this._isCompleted)
                {
                    this._title.free();
                }
                removeChild(this._icon);
                this._icon = null;
                this._line1 = null;
                this._line2 = null;
                this._line3 = null;
                this._title = null;
                if (this.parent != null)
                {
                    this.parent.removeChild(this);
                }
                this._tm.clear();
                this._isFree = true;
            }
            return;
        }// end function

        private function doHide() : Boolean
        {
            this.alpha = this.alpha - 0.2;
            if (this.alpha <= 0)
            {
                this.alpha = 0;
                return true;
            }
            return false;
        }// end function

        private function doShowLabel(param1:TextLabel) : void
        {
            param1.show();
            return;
        }// end function

        public function show() : void
        {
            this._tm.addTask(this.doShowIcon);
            if (this._isCompleted)
            {
                this._tm.addInstantTask(this.doShowLabel, [this._title]);
                this._tm.addPause(5);
            }
            this._tm.addInstantTask(this.doShowLabel, [this._line1]);
            this._tm.addPause(5);
            this._tm.addInstantTask(this.doShowLabel, [this._line2]);
            this._tm.addPause(5);
            this._tm.addInstantTask(this.doShowLabel, [this._line3]);
            visible = true;
            return;
        }// end function

    }
}
