package com.zombotron.gui
{
    import com.antkarlov.managers.*;
    import com.antkarlov.repositories.*;
    import com.zombotron.core.*;
    import flash.display.*;

    public class Motivation extends Sprite
    {
        private var _speed:Number = 1;
        private var _text:String = "";
        private var _isFree:Boolean = false;
        private var _tm:TaskManager;
        private var _universe:Universe;
        private var $:Global;
        private var _label:TextLabel;
        private var _isStarted:Boolean = false;
        private var _kind:uint = 0;
        private var _time:int;
        public static const MOTI_SILENT_KILL:uint = 5;
        public static const MOTI_AWESOME_ACTION:uint = 7;
        public static const MOTI_MEGA_KILL:uint = 4;
        public static const MOTI_DOUBLE_KILL:uint = 1;
        public static const MOTI_MULTI_KILL:uint = 3;
        public static const MOTI_CRAZY_SELFKILLER:uint = 6;
        public static const MOTI_RESPAWN:uint = 8;
        public static const MOTI_FOUND_SECRET:uint = 9;
        public static const MOTI_TRIPLE_KILL:uint = 2;

        public function Motivation()
        {
            this.$ = Global.getInstance();
            this._tm = new TaskManager();
            this._universe = Universe.getInstance();
            return;
        }// end function

        public function start() : void
        {
            if (!this._isStarted)
            {
                this._label = new TextLabel(TextLabel.TEXT16);
                this._label.setText(this._text);
                this._label.setAnim(TextLabel.ANIM_PRINT);
                this._label.show();
                addChild(this._label);
                this.x = 20;
                this.y = App.SCR_H - 90;
                this._time = this._universe.frameTime;
                this._tm.addTask(this.doMove);
                this._tm.addTask(this.doHide);
                this._isStarted = true;
            }
            return;
        }// end function

        public function set kind(param1:uint) : void
        {
            this._kind = param1;
            switch(this._kind)
            {
                case MOTI_DOUBLE_KILL:
                {
                    this._text = Text.TXT_DOUBLE_KILL;
                    ZG.sound(SoundManager.MOTI_DOUBLE_KILL);
                    break;
                }
                case MOTI_TRIPLE_KILL:
                {
                    this._text = Text.TXT_TRIPLE_KILL;
                    ZG.sound(SoundManager.MOTI_TRIPLE_KILL);
                    break;
                }
                case MOTI_MULTI_KILL:
                {
                    this._text = Text.TXT_MULTI_KILL;
                    ZG.sound(SoundManager.MOTI_MULTI_KILL);
                    break;
                }
                case MOTI_MEGA_KILL:
                {
                    this._text = Text.TXT_MEGA_KILL;
                    ZG.sound(SoundManager.MOTI_MEGA_KILL);
                    break;
                }
                case MOTI_SILENT_KILL:
                {
                    this._text = Text.TXT_SILENT_KILL;
                    ZG.sound(SoundManager.MOTI_SILENT_KILL);
                    break;
                }
                case MOTI_CRAZY_SELFKILLER:
                {
                    this._text = Text.TXT_CRAZY_SELFKILLER;
                    break;
                }
                case MOTI_AWESOME_ACTION:
                {
                    this._text = Text.TXT_AWESOME_ACTION;
                    break;
                }
                case MOTI_RESPAWN:
                {
                    this._text = Text.CON_PRESS_SPACEBAR_TO_RESPAWN;
                    break;
                }
                case MOTI_FOUND_SECRET:
                {
                    this._text = Text.TXT_FOUND_SECRET + ZG.saveBox.foundedSecrets.toString() + " of 25";
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function free() : void
        {
            if (!this._isFree)
            {
                removeChild(this._label);
                this._label.free();
                this._label = null;
                if (this.parent != null)
                {
                    this.parent.removeChild(this);
                }
                ZG.playerGui.removeMoti(this);
                this._isFree = true;
            }
            return;
        }// end function

        private function doHide() : Boolean
        {
            this._speed = this._speed * 0.95;
            this.x = this.x + this._speed;
            this.alpha = this.alpha - 0.1;
            if (this.alpha <= 0)
            {
                this.free();
                return true;
            }
            return false;
        }// end function

        private function doMove() : Boolean
        {
            this.x = this.x + this._speed;
            if (this._universe.frameTime - this._time > 90)
            {
                return true;
            }
            return false;
        }// end function

    }
}
