package com.zombotron.gui
{
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import flash.display.*;

    public class AchievementGui extends Sprite
    {
        private var _bg:Sprite;
        private var _kind:uint;
        private var _isFree:Boolean = false;
        private var _desc:TextLabel;
        private var _icon:MovieClip;
        private var _title:TextLabel;
        private var _tm:TaskManager;

        public function AchievementGui()
        {
            this._bg = new AchievementBg_mc();
            this._bg.alpha = 0;
            this._bg.y = this._bg.y - 9;
            addChild(this._bg);
            this._icon = new AchievementIcon_mc();
            this._icon.gotoAndStop(1);
            addChild(this._icon);
            this._title = new TextLabel(TextLabel.TEXT16);
            this._title.setAnim(TextLabel.ANIM_PRINT);
            this._title.x = 80;
            this._title.y = 24;
            addChild(this._title);
            this._desc = new TextLabel(TextLabel.TEXT8);
            this._desc.setAnim(TextLabel.ANIM_PRINT);
            this._desc.x = 80;
            this._desc.y = 40;
            addChild(this._desc);
            this.y = 400;
            this._tm = new TaskManager();
            return;
        }// end function

        private function doHideBg() : Boolean
        {
            this._bg.alpha = this._bg.alpha - 0.2;
            if (this._bg.alpha <= 0)
            {
                this._bg.alpha = 0;
                return true;
            }
            return false;
        }// end function

        private function doHideItem(param1:Sprite) : Boolean
        {
            param1.y = Amath.lerp(param1.y, 100, 0.1);
            param1.alpha = param1.alpha - 0.2;
            if (param1.alpha <= 0)
            {
                param1.alpha = 0;
                return true;
            }
            return false;
        }// end function

        public function free() : void
        {
            if (!this._isFree)
            {
                removeChild(this._bg);
                removeChild(this._icon);
                this._title.free();
                this._desc.free();
                this._tm.clear();
                if (this.parent != null)
                {
                    this.parent.removeChild(this);
                }
                this._bg = null;
                this._icon = null;
                this._title = null;
                this._desc = null;
                this._tm = null;
                this._isFree = true;
            }
            return;
        }// end function

        public function doShowIco() : Boolean
        {
            this._icon.x = Amath.lerp(this._icon.x, 23, 0.2);
            if (Amath.equal(this._icon.x, 23, 1))
            {
                this._icon.x = 23;
                return true;
            }
            if (this._bg.alpha != 1)
            {
                this._bg.alpha = this._bg.alpha + 0.2;
                if (this._bg.alpha >= 1)
                {
                    this._bg.alpha = 1;
                }
            }
            return false;
        }// end function

        public function set kind(param1:uint) : void
        {
            this._kind = param1;
            this._icon.gotoAndStop(this._kind);
            this._title.setText(AchievementItem.getTitle(this._kind));
            this._desc.setText(AchievementItem.getDesc(this._kind));
            return;
        }// end function

        public function show() : void
        {
            this._icon.x = -45;
            this._icon.y = 9;
            this._tm.addTask(this.doShowIco);
            this._tm.addTask(this.doShowLabel, [this._title]);
            this._tm.addPause(15);
            this._tm.addTask(this.doShowLabel, [this._desc]);
            this._tm.addPause(200);
            this._tm.addTask(this.doHideItem, [this._desc]);
            this._tm.addTask(this.doHideItem, [this._title]);
            this._tm.addTask(this.doHideItem, [this._icon]);
            this._tm.addTask(this.doHideBg);
            this._tm.addTask(this.free);
            ZG.sound(SoundManager.ACHIEVEMENT);
            return;
        }// end function

        private function doShowLabel(param1:TextLabel) : Boolean
        {
            param1.show();
            return true;
        }// end function

    }
}
