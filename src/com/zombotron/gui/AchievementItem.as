package com.zombotron.gui
{
    import com.antkarlov.anim.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import flash.display.*;

    public class AchievementItem extends Sprite
    {
        private var _isCompleted:Boolean = false;
        private var _percent:TextLabel;
        private var _desc:TextLabel;
        private var _ico:MovieClip;
        private var _title:TextLabel;
        private var _progress:Animation;
        private var _tm:TaskManager;
        public static const BIG_MONEY:uint = 5;
        public static const BOMBERMAN:uint = 7;
        public static const UNDEAD_KILLER:uint = 8;
        public static const SECOND_BLOOD:uint = 1;
        public static const TASTE_IRON:uint = 3;
        public static const TREASURE_HUNTER:uint = 9;
        public static const EXTERMINATOR:uint = 12;
        public static const TINMAN:uint = 4;
        public static const CAREFUL:uint = 11;
        public static const BUTCHER:uint = 2;
        public static const SILENT_KILLER:uint = 6;
        public static const WINNER:uint = 10;

        public function AchievementItem()
        {
            this._tm = new TaskManager();
            return;
        }// end function

        private function doShowLabel(param1:TextLabel) : void
        {
            param1.show();
            return;
        }// end function

        public function hide() : void
        {
            this._tm.clear();
            this._tm.addTask(this.doHide);
            this._tm.addInstantTask(this.free);
            return;
        }// end function

        private function doShowIco() : Boolean
        {
            if (this._isCompleted)
            {
                this._ico.alpha = this._ico.alpha + 0.2;
                if (this._ico.alpha >= 1)
                {
                    this._ico.alpha = 1;
                    return true;
                }
            }
            else
            {
                this._progress.alpha = this._progress.alpha + 0.1;
                this._percent.alpha = this._progress.alpha;
                if (this._progress.alpha >= 0.2)
                {
                    var _loc_1:Number = 0.2;
                    this._percent.alpha = 0.2;
                    this._progress.alpha = _loc_1;
                    return true;
                }
            }
            return false;
        }// end function

        public function free() : void
        {
            this._title.free();
            this._desc.free();
            if (this._isCompleted)
            {
                removeChild(this._ico);
                this._ico = null;
            }
            else
            {
                this._percent.free();
                removeChild(this._progress);
            }
            if (this.parent != null)
            {
                this.parent.removeChild(this);
            }
            this._tm.clear();
            this._title = null;
            this._desc = null;
            this._percent = null;
            this._progress = null;
            this._ico = null;
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

        public function show(param1:uint, param2:Boolean, param3:int = 100) : void
        {
            this._isCompleted = param2;
            if (this._isCompleted)
            {
                this._ico = new AchievementIcon_mc();
                this._ico.alpha = 0;
                this._ico.gotoAndStop(param1);
                addChild(this._ico);
            }
            else
            {
                this._progress = ZG.animCache.getAnimation(Art.ACHIEVEMENT_PROGRESS);
                this._progress.alpha = 0;
                this._progress.gotoAndStop(Math.round(Amath.fromPercent(param3, this._progress.totalFrames)));
                addChild(this._progress);
                this._percent = new TextLabel(TextLabel.TEXT8);
                this._percent.alpha = 0;
                this._percent.setText(param3.toString() + "%");
                this._percent.x = Math.round(24 - this._percent.getWidth() * 0.5);
                this._percent.y = 23;
                addChild(this._percent);
                this._percent.show();
            }
            this._title = new TextLabel(TextLabel.TEXT16);
            this._title.setAnim(TextLabel.ANIM_PRINT);
            this._title.setText(getTitle(param1));
            this._title.alpha = this._isCompleted ? (1) : (0.2);
            this._title.x = 59;
            this._title.y = 17;
            addChild(this._title);
            this._desc = new TextLabel(TextLabel.TEXT8);
            this._desc.setAnim(TextLabel.ANIM_PRINT);
            this._desc.setText(getDesc(param1));
            this._desc.alpha = this._isCompleted ? (1) : (0.2);
            this._desc.x = 59;
            this._desc.y = 30;
            addChild(this._desc);
            this._tm.addTask(this.doShowIco);
            this._tm.addInstantTask(this.doShowLabel, [this._title]);
            this._tm.addPause(3);
            this._tm.addInstantTask(this.doShowLabel, [this._desc]);
            return;
        }// end function

        public static function getDesc(param1:uint) : String
        {
            switch(param1)
            {
                case SECOND_BLOOD:
                {
                    return Text.DESC_SECOND_BLOOD;
                }
                case BUTCHER:
                {
                    return Text.DESC_BUTCHER;
                }
                case TASTE_IRON:
                {
                    return Text.DESC_TASTE_IRON;
                }
                case TINMAN:
                {
                    return Text.DESC_TINMAN;
                }
                case BIG_MONEY:
                {
                    return Text.DESC_BIG_MONEY;
                }
                case SILENT_KILLER:
                {
                    return Text.DESC_SILENT_KILLER;
                }
                case BOMBERMAN:
                {
                    return Text.DESC_BOMBERMAN;
                }
                case UNDEAD_KILLER:
                {
                    return Text.DESC_UNDEAD_KILLER;
                }
                case TREASURE_HUNTER:
                {
                    return Text.DESC_TREASURE_HUNTER;
                }
                case CAREFUL:
                {
                    return Text.DESC_CAREFUL;
                }
                case WINNER:
                {
                    return Text.DESC_WINNER;
                }
                case EXTERMINATOR:
                {
                    return Text.DESC_EXTERMINATOR;
                }
                default:
                {
                    break;
                }
            }
            return "no desc";
        }// end function

        public static function getTitle(param1:uint) : String
        {
            switch(param1)
            {
                case SECOND_BLOOD:
                {
                    return Text.TITLE_SECOND_BLOOD;
                }
                case BUTCHER:
                {
                    return Text.TITLE_BUTCHER;
                }
                case TASTE_IRON:
                {
                    return Text.TITLE_TASTE_IRON;
                }
                case TINMAN:
                {
                    return Text.TITLE_TINMAN;
                }
                case BIG_MONEY:
                {
                    return Text.TITLE_BIG_MONEY;
                }
                case SILENT_KILLER:
                {
                    return Text.TITLE_SILENT_KILLER;
                }
                case BOMBERMAN:
                {
                    return Text.TITLE_BOMBERMAN;
                }
                case UNDEAD_KILLER:
                {
                    return Text.TITLE_UNDEAD_KILLER;
                }
                case TREASURE_HUNTER:
                {
                    return Text.TITLE_TREASURE_HUNTER;
                }
                case CAREFUL:
                {
                    return Text.TITLE_CAREFUL;
                }
                case WINNER:
                {
                    return Text.TITLE_WINNER;
                }
                case EXTERMINATOR:
                {
                    return Text.TITLE_EXTERMINATOR;
                }
                default:
                {
                    break;
                }
            }
            return "no title";
        }// end function

    }
}
