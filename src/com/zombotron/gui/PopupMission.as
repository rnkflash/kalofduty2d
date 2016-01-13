package com.zombotron.gui
{
    import com.antkarlov.managers.*;
    import com.zombotron.core.*;
    import flash.display.*;

    public class PopupMission extends Sprite
    {
        private var _missions:Array;
        private var _window:Sprite;
        private var _isFree:Boolean = true;
        private var _tm:TaskManager;
        private var _title2:TextLabel;
        private var _title1:TextLabel;

        public function PopupMission()
        {
            this._tm = new TaskManager();
            this._missions = [];
            return;
        }// end function

        public function hide() : void
        {
            this._tm.clear();
            this._tm.addTask(this.doHide);
            return;
        }// end function

        private function doShowLabel(param1:TextLabel) : void
        {
            param1.show();
            return;
        }// end function

        private function doShowWindow() : Boolean
        {
            this._window.alpha = this._window.alpha + 0.1;
            if (this._window.alpha >= 0.5)
            {
                this._window.alpha = 0.5;
                return true;
            }
            return false;
        }// end function

        private function doShowItem(param1:int) : void
        {
            (this._missions[param1] as MissionItem).show();
            return;
        }// end function

        public function addMission(param1:uint, param2:String, param3:String, param4:Boolean) : void
        {
            var _loc_5:* = new MissionItem();
            _loc_5.x = 27;
            _loc_5.init(param1, param2, param3, param4, (this._missions.length + 1));
            addChild(_loc_5);
            switch(this._missions.length)
            {
                case 0:
                {
                    _loc_5.y = 32;
                    break;
                }
                case 1:
                {
                    _loc_5.y = 79;
                    break;
                }
                case 2:
                {
                    _loc_5.y = 126;
                    break;
                }
                default:
                {
                    break;
                }
            }
            this._missions[this._missions.length] = _loc_5;
            return;
        }// end function

        private function doHide() : Boolean
        {
            this.alpha = this.alpha - 0.2;
            if (this.alpha <= 0)
            {
                this.alpha = 0;
                this.free();
                return true;
            }
            return false;
        }// end function

        public function free() : void
        {
            var _loc_1:int = 0;
            if (!this._isFree)
            {
                removeChild(this._window);
                this._window = null;
                this._title1.free();
                this._title2.free();
                _loc_1 = 0;
                while (_loc_1 < this._missions.length)
                {
                    
                    (this._missions[_loc_1] as MissionItem).free();
                    _loc_1++;
                }
                this._missions.length = 0;
                this._isFree = true;
            }
            return;
        }// end function

        public function show() : void
        {
            this._window = new PopupMission_mc();
            this._window.alpha = 0;
            addChild(this._window);
            this._title1 = new TextLabel(TextLabel.TEXT8);
            this._title1.setAnim(TextLabel.ANIM_PRINT);
            this._title1.setText(Text.TXT_ADITIONAL);
            this._title1.x = 13;
            this._title1.y = -8;
            addChild(this._title1);
            this._title2 = new TextLabel(TextLabel.TEXT16);
            this._title2.setAnim(TextLabel.ANIM_PRINT);
            this._title2.setText(Text.TXT_MISSIONS);
            this._title2.x = 13;
            this._title2.y = 2;
            addChild(this._title2);
            this._tm.addInstantTask(this.doShowLabel, [this._title1]);
            this._tm.addPause(8);
            this._tm.addInstantTask(this.doShowLabel, [this._title2]);
            this._tm.addPause(5);
            this._tm.addTask(this.doShowWindow);
            this._tm.addInstantTask(this.doShowItem, [0]);
            this._tm.addPause(10);
            this._tm.addInstantTask(this.doShowItem, [1]);
            this._tm.addPause(10);
            this._tm.addInstantTask(this.doShowItem, [2]);
            return;
        }// end function

    }
}
