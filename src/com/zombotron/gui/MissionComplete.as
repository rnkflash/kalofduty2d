package com.zombotron.gui
{
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import flash.display.*;

    public class MissionComplete extends Sprite
    {
        private var _descPos:Number;
        private var _tmDesc:TaskManager;
        private var _tmStar:TaskManager;
        private var _isFree:Boolean = true;
        private var _title:TextLabel;
        private var _bg:Sprite;
        private var _tmTitle:TaskManager;
        private var _desc:TextLabel;
        private var _star:Sprite;
        private var _titlePos:Number;

        public function MissionComplete()
        {
            this._bg = new MissionCompleteBg_mc();
            this._star = new BigStar_mc();
            this._star.x = App.SCR_HALF_W;
            this._star.y = 345;
            this._title = new TextLabel(TextLabel.TEXT16);
            this._title.setColor(TextLabel.COLOR_WHITE);
            this._desc = new TextLabel(TextLabel.TEXT8);
            this._desc.setColor(TextLabel.COLOR_WHITE);
            this._tmStar = new TaskManager();
            this._tmTitle = new TaskManager();
            this._tmDesc = new TaskManager();
            return;
        }// end function

        public function init(param1:String, param2:String) : void
        {
            this._bg.alpha = 0;
            this._bg.x = this._star.x;
            this._bg.y = this._star.y + 25;
            addChild(this._bg);
            this._star.alpha = 0;
            var _loc_3:int = 8;
            this._star.scaleY = 8;
            this._star.scaleX = _loc_3;
            addChild(this._star);
            this._title.setText(param1);
            this._title.x = App.SCR_HALF_W - this._title.getWidth() * 0.5;
            var _loc_3:int = 380;
            this._title.y = 380;
            this._titlePos = _loc_3;
            this._title.y = this._title.y - 20;
            this._title.alpha = 0;
            this._title.show();
            addChild(this._title);
            this._desc.setText(param2);
            this._desc.x = App.SCR_HALF_W - this._desc.getWidth() * 0.5;
            var _loc_3:int = 395;
            this._descPos = 395;
            this._desc.y = _loc_3;
            this._desc.y = this._desc.y - 20;
            this._desc.alpha = 0;
            this._desc.show();
            addChild(this._desc);
            this._tmStar.addTask(this.doShowStar);
            this._tmStar.addPause(140);
            this._tmStar.addTask(this.doHideStar);
            this._tmTitle.addPause(10);
            this._tmTitle.addTask(this.doShowText, [this._title, this._titlePos]);
            this._tmTitle.addPause(140);
            this._tmTitle.addTask(this.doHideText, [this._title, this._titlePos]);
            this._tmDesc.addPause(15);
            this._tmDesc.addTask(this.doShowText, [this._desc, this._descPos]);
            this._tmDesc.addPause(130);
            this._tmDesc.addTask(this.doHideText, [this._desc, this._descPos]);
            this._tmTitle.addPause(5);
            this._tmTitle.addInstantTask(this.free);
            this._isFree = false;
            return;
        }// end function

        private function doShowStar() : Boolean
        {
            var _loc_1:EffectPixel = null;
            var _loc_2:int = 0;
            this._star.alpha = this._star.alpha + 0.1;
            var _loc_3:* = Amath.lerp(this._star.scaleX, 1, 0.4);
            this._star.scaleY = Amath.lerp(this._star.scaleX, 1, 0.4);
            this._star.scaleX = _loc_3;
            if (this._star.scaleX <= 1.1)
            {
                var _loc_3:int = 1;
                this._star.scaleY = 1;
                this._star.scaleX = _loc_3;
                alpha = 1;
                _loc_2 = 0;
                while (_loc_2 < 8)
                {
                    
                    _loc_1 = EffectPixel.get();
                    _loc_1.speed.set(Amath.random(-6, 6), Amath.random(-6, -2));
                    _loc_1.init(Math.abs(ZG.universe.x) + this._star.x + Amath.random(-15, 15), Math.abs(ZG.universe.y) + this._star.y + Amath.random(-15, 15), 0, 1.2);
                    _loc_1.variety = EffectPixel.PIXEL_ORANGE;
                    _loc_1.fadeSpeed = 0.03;
                    _loc_2++;
                }
                return true;
            }
            if (this._bg.alpha < 1)
            {
                this._bg.alpha = this._bg.alpha + 0.1;
                if (this._bg.alpha >= 1)
                {
                    this._bg.alpha = 1;
                }
            }
            return false;
        }// end function

        private function doHideStar() : Boolean
        {
            this._star.alpha = this._star.alpha - 0.1;
            this._bg.alpha = this._star.alpha;
            var _loc_1:* = Amath.lerp(this._star.scaleX, 5, 0.1);
            this._star.scaleY = Amath.lerp(this._star.scaleX, 5, 0.1);
            this._star.scaleX = _loc_1;
            if (this._star.alpha <= 0)
            {
                this._star.alpha = 0;
                return true;
            }
            return false;
        }// end function

        public function free() : void
        {
            if (!this._isFree)
            {
                removeChild(this._bg);
                removeChild(this._star);
                removeChild(this._title);
                removeChild(this._desc);
                this._title.free();
                this._desc.free();
                this._tmStar.clear();
                this._tmTitle.clear();
                this._tmDesc.clear();
                if (this.parent != null)
                {
                    this.parent.removeChild(this);
                }
                this._isFree = true;
            }
            return;
        }// end function

        private function doShowText(param1:TextLabel, param2:Number) : Boolean
        {
            param1.alpha = param1.alpha + 0.1;
            param1.y = Amath.lerp(param1.y, param2, 0.4);
            if (param1.y >= param2 - 0.1)
            {
                param1.alpha = 1;
                param1.y = param2;
                return true;
            }
            return false;
        }// end function

        private function doHideText(param1:TextLabel, param2:Number) : Boolean
        {
            param1.alpha = param1.alpha - 0.2;
            param1.y = Amath.lerp(param1.y, param2 + 40, 0.1);
            if (param1.alpha <= 0)
            {
                param1.alpha = 0;
                return true;
            }
            return false;
        }// end function

    }
}
