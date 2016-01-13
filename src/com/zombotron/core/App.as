package com.zombotron.core
{
    import com.antkarlov.anim.*;
    import com.antkarlov.debug.*;
    import com.antkarlov.events.*;
    import com.antkarlov.math.*;
    import com.antkarlov.repositories.*;
    import com.antkarlov.visual.*;
    import com.zombotron.gui.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    public class App extends Sprite
    {
        private var _cacheTotal:int;
        private var _chargeAnim:MovieClip;
        private var _logo:ElectronBoard;
        private var _game:Game;
        private var _menuBg:Sprite;
        private var $:Global;
        private var _progressBar:ProgressBar;
        public static const SCR_W:int = 640;
        public static const APP_VER:String = "Version 1.1 - July 13, 2011 [exclusive]";
        public static const SCR_HALF_W:int = 320;
        public static const SCR_HALF_H:int = 240;
        public static const SCR_H:int = 480;

        public function App()
        {
            this.$ = Global.getInstance();
            if (stage)
            {
                this.init();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, this.init);
            }
            return;
        }// end function

        private function backgroundCompleteHandler(event:ProcessEvent) : void
        {
            this.$.background.removeEventListener(ProcessEvent.PROGRESS, this.backgroundProgressHandler);
            this.$.background.removeEventListener(ProcessEvent.COMPLETE, this.backgroundCompleteHandler);
            this._logo.hide();
            this._logo.addEventListener(Event.COMPLETE, this.startGameHandler);
            this._chargeAnim.addEventListener(Event.ENTER_FRAME, this.hideChargeHandler);
            return;
        }// end function

        private function init(event:Event = null) : void
        {
            this._menuBg = new MenuBG_mc();
            addChild(this._menuBg);
            var _loc_2:* = new GameBg_mc();
            addChild(_loc_2);
            this.mask = _loc_2;
            this._chargeAnim = new AGIntro_mc();
            this._chargeAnim.x = SCR_HALF_W;
            this._chargeAnim.y = SCR_HALF_H;
            addChild(this._chargeAnim);
            this._chargeAnim.addEventListener(Event.ENTER_FRAME, this.introHandler);
            this._chargeAnim.addEventListener(MouseEvent.CLICK, this.introClick);
            removeEventListener(Event.ADDED_TO_STAGE, this.init);
            return;
        }// end function

        private function backgroundProgressHandler(event:ProcessEvent) : void
        {
            var _loc_2:* = this._cacheTotal + this.$.background.queueTotal;
            var _loc_3:* = this._cacheTotal + this.$.background.queueCurrent;
            this._progressBar.percent(100 - Amath.toPercent(_loc_3, _loc_2));
            return;
        }// end function

        private function hideChargeHandler(event:Event) : void
        {
            if (this._chargeAnim.currentFrame == 1)
            {
                this._chargeAnim.visible = false;
                this._progressBar.alpha = this._progressBar.alpha - 0.1;
                if (this._progressBar.alpha <= 0)
                {
                    this._progressBar.alpha = 0;
                    this._chargeAnim.removeEventListener(Event.ENTER_FRAME, this.hideChargeHandler);
                }
            }
            else
            {
                this._chargeAnim.prevFrame();
            }
            return;
        }// end function

        private function completeBoardHandler(event:Event) : void
        {
            this._chargeAnim = new ChargeAnim_mc();
            this._chargeAnim.x = this._progressBar.x - 2;
            this._chargeAnim.y = this._progressBar.y + 10;
            this._chargeAnim.play();
            this._chargeAnim.addEventListener(Event.ENTER_FRAME, this.chargeAnimHandler);
            addChild(this._chargeAnim);
            this._logo.removeEventListener(Event.COMPLETE, this.completeBoardHandler);
            return;
        }// end function

        private function beginPrepare() : void
        {
            this._logo = new ElectronBoard();
            this._logo.kind = ElectronBoard.KIND_DEVELOPER;
            this._logo.x = SCR_HALF_W - this._logo.boardWidth * 0.5;
            this._logo.y = 200 - this._logo.boardHeight * 0.5;
            this._logo.start();
            this._logo.addEventListener(Event.COMPLETE, this.completeBoardHandler);
            addChild(this._logo);
            this.$.stage = stage;
            ZG.console = Console.getInstance();
            this.$.trace(APP_VER);
            this.$.background = new Background();
            this._progressBar = new ProgressBar_mc();
            this._progressBar.x = 293;
            this._progressBar.y = 336;
            this._progressBar.text = Text.TXT_LOW_BATTERY;
            this._progressBar.percent(100);
            addChild(this._progressBar);
            return;
        }// end function

        private function chargeAnimHandler(event:Event) : void
        {
            var _loc_2:AnimationCache = null;
            if (this._chargeAnim.currentFrame == this._chargeAnim.totalFrames)
            {
                this._chargeAnim.stop();
                this._chargeAnim.removeEventListener(Event.ENTER_FRAME, this.chargeAnimHandler);
                this._chargeAnim.removeEventListener(MouseEvent.CLICK, this.introClick);
                this._progressBar.text = Text.TXT_CHARGING;
                _loc_2 = AnimationCache.getInstance();
                this.$.animCache = _loc_2;
                _loc_2.addToQueue(Art.getListOfAnimations());
                _loc_2.addEventListener(ProcessEvent.PROGRESS, this.cacheProgressHandler);
                _loc_2.addEventListener(ProcessEvent.COMPLETE, this.cacheCompleteHandler);
                this._cacheTotal = _loc_2.cacheQueue.length;
                _loc_2.processQueue();
            }
            return;
        }// end function

        private function cacheCompleteHandler(event:ProcessEvent) : void
        {
            this.$.animCache.removeEventListener(ProcessEvent.COMPLETE, this.cacheCompleteHandler);
            this.$.animCache.removeEventListener(ProcessEvent.PROGRESS, this.cacheProgressHandler);
            this.$.background.addEventListener(ProcessEvent.PROGRESS, this.backgroundProgressHandler);
            this.$.background.addEventListener(ProcessEvent.COMPLETE, this.backgroundCompleteHandler);
            this.$.background.processQueue();
            return;
        }// end function

        private function startGameHandler(event:Event) : void
        {
            this._logo.removeEventListener(Event.COMPLETE, this.startGameHandler);
            removeChild(this._logo);
            this._logo = null;
            removeChild(this._chargeAnim);
            this._chargeAnim = null;
            this._progressBar.free();
            this._progressBar = null;
            this._game = new Game();
            addChild(this._game);
            removeChild(this._menuBg);
            this._menuBg = null;
            return;
        }// end function

        private function cacheProgressHandler(event:ProcessEvent) : void
        {
            var _loc_2:* = this._cacheTotal + this.$.background.queueTotal;
            this._progressBar.percent(100 - Amath.toPercent(this.$.animCache.curProcessingItem, _loc_2));
            return;
        }// end function

        private function introClick(event:MouseEvent) : void
        {
            var _loc_2:* = new URLRequest("http://www.armorgames.com/");
            navigateToURL(_loc_2, "_blank");
            return;
        }// end function

        private function introHandler(event:Event) : void
        {
            if (this._chargeAnim.currentFrame == this._chargeAnim.totalFrames)
            {
                this._chargeAnim.stop();
                this._chargeAnim.alpha = this._chargeAnim.alpha - 0.2;
                if (this._chargeAnim.alpha <= 0)
                {
                    this._chargeAnim.removeEventListener(Event.ENTER_FRAME, this.introHandler);
                    removeChild(this._chargeAnim);
                    this._chargeAnim = null;
                    this.beginPrepare();
                }
            }
            return;
        }// end function

    }
}
