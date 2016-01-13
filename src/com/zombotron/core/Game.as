package com.zombotron.core
{
    import com.antkarlov.*;
    import com.antkarlov.controllers.*;
    import com.antkarlov.debug.*;
    import com.antkarlov.events.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.repositories.*;
    import com.zombotron.events.*;
    import com.zombotron.gui.*;
    import com.zombotron.levels.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class Game extends Sprite
    {
        public var agi:Object;
        private var _authors:Sprite;
        private var _logo:ElectronBoard;
        private var _screen:BasicMenu;
        private var _taskProcessor:TaskProcessor;
        private var _tm:TaskManager;
        private var _screenFrame:Sprite;
        private var _menuBg:Sprite;
        private var $:Global;
        private var _fallPixels:FallPixels;
        private var _universe:Universe;
        public var nextEntry:String = "";
        public var nextStage:int = 1;
        public var curScreen:Object;
        public var nextScreen:uint = 0;
        public static const SCR_ACHIEVEMENT:uint = 7;
        public static const SCR_MAIN_MENU:uint = 1;
        public static const SCR_STAGE_LOADING:uint = 3;
        public static const SCR_GAME:uint = 4;
        public static const SCR_SHOP:uint = 5;
        private static var _instance:Game = null;
        public static const SCR_CONGRATS:uint = 8;
        public static const SCR_PAUSE:uint = 6;
        public static const SCR_SELECT_LEVEL:uint = 2;

        public function Game()
        {
            this.$ = Global.getInstance();
            this._tm = new TaskManager();
            if (_instance != null)
            {
                throw "Game.as is a singleton class. Use Game.getInstance();";
            }
            _instance = this;
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

        public function loadNextStage() : void
        {
            if (this._universe.level != null)
            {
                this._tm.addInstantTask(this.onClearLevel);
            }
            this._tm.addInstantTask(this.loadLevel, [this.nextStage, this.nextEntry]);
            return;
        }// end function

        private function onShowScreen() : Boolean
        {
            this.scrCompleteHandler();
            return true;
        }// end function

        private function onHideScreen() : Boolean
        {
            this._screen.hide();
            return true;
        }// end function

        private function init(event:Event = null) : void
        {
            var _loc_2:String = "http://agi.armorgames.com/assets/agi/AGI.swf";
            Security.allowDomain(_loc_2);
            var _loc_3:* = new URLRequest(_loc_2);
            var _loc_4:* = new Loader();
            _loc_4.contentLoaderInfo.addEventListener(Event.COMPLETE, this.agiLoadComplete);
            _loc_4.load(_loc_3);
            MochiBot.track(this, "23dfb03a");
            ZG.setData();
            ZG.saveBox.load();
            ZG.media.enableMusic = ZG.saveBox.enableMusic == 1 ? (true) : (false);
            ZG.media.enableSound = ZG.saveBox.enableSound == 1 ? (true) : (false);
            ZG.console.register(this.debugLoadLevel, "load", "[level] [entry] - loads level.");
            ZG.console.register(ZG.saveBox.clear, "clearSaves", "- remove game saved data.");
            ZG.console.register(this.debugCompleted, "completed", "[level] - set specified level as completed.");
            ZG.console.register(this.debugHardcoreMode, "hardcore", "[on/off] - enable/disable hardcore mode.");
            ZG.console.register(this.debugTestMode, "test_mode");
            this.$.console = ZG.console;
            this._universe = Universe.getInstance();
            ZG.universe = this._universe;
            this._universe.visible = false;
            this._universe.background = this.$.background;
            this._universe.smoothing = ZG.saveBox.enableQuality == 1 ? (true) : (false);
            addChild(this._universe.background);
            addChild(this._universe);
            var _loc_5:* = new ScreenFade_mc();
            addChild(_loc_5);
            addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this._universe.addEventListener(CompleteLevelEvent.LEVEL_COMPLETE, this.levelCompletedHandler);
            this._taskProcessor = TaskProcessor.getInstance();
            addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            removeEventListener(Event.ADDED_TO_STAGE, this.init);
            this._menuBg = new MenuBG_mc();
            addChild(this._menuBg);
            this._fallPixels = new FallPixels();
            this._fallPixels.start();
            addChild(this._fallPixels);
            this.nextScreen = SCR_MAIN_MENU;
            this.scrCompleteHandler();
            ZG.media.playTrack("track1", 90);
            stage.addEventListener(Event.DEACTIVATE, this.deactivateHandler);
            stage.addEventListener(Event.MOUSE_LEAVE, this.mouseLeaveHandler);
            stage.addEventListener(MouseEvent.MOUSE_OUT, this.mouseLeaveHandler);
            return;
        }// end function

        private function mouseUpHandler(event:Event) : void
        {
            this._universe.isMouseDown = false;
            return;
        }// end function

        private function enterFrameHandler(event:Event) : void
        {
            this._universe.process();
            this._taskProcessor.process();
            return;
        }// end function

        private function completeLoadHandler(event:ProcessEvent) : void
        {
            this._universe.level.removeEventListener(ProcessEvent.COMPLETE, this.completeLoadHandler);
            this._screen.addEventListener(MouseEvent.CLICK, this.startGame);
            this._menuBg.addEventListener(MouseEvent.CLICK, this.startGame);
            ZG.key.register(this.startGame, KeyCode.SPACEBAR);
            return;
        }// end function

        public function rebuildMissions() : void
        {
            var _loc_1:* = LevelBase.getMissions(this._universe.level.levelNum);
            ZG.playerGui.clearMissions();
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                if (!ZG.saveBox.isMissionCompleted(this._universe.level.levelNum, _loc_2))
                {
                    ZG.playerGui.addMission(_loc_1[_loc_2].condition, _loc_1[_loc_2].value, _loc_2);
                }
                _loc_2++;
            }
            return;
        }// end function

        private function levelCompletedHandler(event:CompleteLevelEvent) : void
        {
            this._universe.player.saveData();
            if (event.nextEntry == "completeGame" || ZG.testMode == true)
            {
                ZG.saveBox.justSave(!ZG.testMode ? (10) : (0));
                ZG.saveBox.haveData = false;
                this.nextScreen = SCR_CONGRATS;
                this.showMenu();
            }
            else
            {
                this.nextScreen = SCR_STAGE_LOADING;
                this.showMenu();
                this.nextStage = event.nextLevel;
                this.nextEntry = event.nextEntry;
            }
            this.$.trace("Stage completed. Next stage: " + this.nextStage.toString() + ", " + this.nextEntry);
            return;
        }// end function

        private function debugLoadLevel(param1:int = 1, param2:String = "") : void
        {
            var _loc_3:CompleteLevelEvent = null;
            if (this.curScreen == SCR_GAME)
            {
                ZG.console.close();
                _loc_3 = new CompleteLevelEvent(param1, param2, CompleteLevelEvent.LEVEL_COMPLETE);
                this.levelCompletedHandler(_loc_3);
            }
            else
            {
                this.$.trace("Level can be loaded only from another level.", Console.FORMAT_ERROR);
            }
            return;
        }// end function

        private function deactivateHandler(event:Event) : void
        {
            ZG.key.reset();
            this._universe.isMouseDown = false;
            return;
        }// end function

        private function debugCompleted(param1:int = 1) : void
        {
            ZG.saveBox.completedLevels = param1;
            this.$.trace("Level " + param1.toString() + " has been set as completed.", Console.FORMAT_RESULT);
            return;
        }// end function

        private function onPrepareLevel() : Boolean
        {
            this._universe.visible = true;
            this._universe.start();
            this._universe.giveControl();
            return true;
        }// end function

        private function loadLevel(param1:int = 1, param2:String = "") : void
        {
            switch(param1)
            {
                case 1:
                {
                    this._universe.level = new Level1();
                    break;
                }
                case 2:
                {
                    this._universe.level = new Level2();
                    break;
                }
                case 3:
                {
                    this._universe.level = new Level3();
                    break;
                }
                case 4:
                {
                    this._universe.level = new Level4();
                    break;
                }
                case 5:
                {
                    this._universe.level = new Level5();
                    break;
                }
                case 6:
                {
                    this._universe.level = new Level6();
                    break;
                }
                case 7:
                {
                    this._universe.level = new Level7();
                    break;
                }
                case 8:
                {
                    this._universe.level = new Level8();
                    break;
                }
                case 9:
                {
                    this._universe.level = new Level9();
                    break;
                }
                case 10:
                {
                    this._universe.level = new Level10();
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.rebuildMissions();
            this._universe.level.respawnAlias = param2;
            this._universe.level.addEventListener(ProcessEvent.COMPLETE, this.completeLoadHandler);
            this._universe.level.load();
            return;
        }// end function

        private function debugHardcoreMode(param1:String) : void
        {
            if (param1 == "on")
            {
                ZG.hardcoreMode = true;
                this.$.trace("Hardcore mode enabled.", Console.FORMAT_RESULT);
            }
            else if (param1 == "off")
            {
                ZG.hardcoreMode = false;
                this.$.trace("Hardcore mode disabled.", Console.FORMAT_RESULT);
            }
            else
            {
                this.$.trace("Wrong attributes.", Console.FORMAT_ERROR);
            }
            return;
        }// end function

        public function hideMenu() : void
        {
            this._tm.addTask(this.onHideBg);
            return;
        }// end function

        public function makeNextScreen() : void
        {
            if (this._screen != null)
            {
                this._screen.addEventListener(Event.COMPLETE, this.scrCompleteHandler);
                this._screen.hide();
            }
            else
            {
                this.scrCompleteHandler();
            }
            return;
        }// end function

        private function scrCompleteHandler(event:Event = null) : void
        {
            if (this._screen != null)
            {
                this._screen.removeEventListener(Event.COMPLETE, this.scrCompleteHandler);
                this._screen.free();
                removeChild(this._screen);
                this._screen = null;
            }
            switch(this.nextScreen)
            {
                case SCR_MAIN_MENU:
                {
                    this._screen = new MainMenu();
                    break;
                }
                case SCR_SELECT_LEVEL:
                {
                    this._screen = new SelectLevelMenu();
                    break;
                }
                case SCR_STAGE_LOADING:
                {
                    this._universe.takeControl();
                    this._screen = new LoadingScreen();
                    break;
                }
                case SCR_GAME:
                {
                    this._universe.start();
                    this._universe.giveControl();
                    this._screen = PlayerGui.getInstance();
                    break;
                }
                case SCR_PAUSE:
                {
                    this._universe.stop();
                    this._universe.takeControl();
                    this._screen = new PauseMenu();
                    break;
                }
                case SCR_SHOP:
                {
                    this._universe.stop();
                    this._universe.takeControl();
                    this._screen = ShopMenu.getInstance();
                    break;
                }
                case SCR_ACHIEVEMENT:
                {
                    this._screen = new AchievementMenu();
                    break;
                }
                case SCR_CONGRATS:
                {
                    this._screen = new CongratsMenu();
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this._screen != null)
            {
                this._screen.addEventListener(Event.COMPLETE, this.scrCompleteHandler);
                this._screen.show();
                addChild(this._screen);
            }
            this.curScreen = this.nextScreen;
            return;
        }// end function

        private function mouseMoveHandler(event:MouseEvent) : void
        {
            this._universe.s_mouseX = event.stageX;
            this._universe.s_mouseY = event.stageY;
            return;
        }// end function

        private function mouseLeaveHandler(event:Event) : void
        {
            ZG.key.reset();
            this._universe.isMouseDown = false;
            return;
        }// end function

        private function debugTestMode() : void
        {
            ZG.testMode = true;
            this.$.trace("Test mode enabled.", Console.FORMAT_RESULT);
            return;
        }// end function

        private function onShowBg() : Boolean
        {
            this._menuBg.alpha = this._menuBg.alpha + 0.1;
            this._fallPixels.alpha = this._menuBg.alpha;
            if (this._menuBg.alpha >= 1)
            {
                this._menuBg.alpha = 1;
                this._fallPixels.alpha = 1;
                this._fallPixels.start();
                return true;
            }
            return false;
        }// end function

        private function agiLoadComplete(event:Event) : void
        {
            this.agi = event.currentTarget.content;
            addChild(this.agi);
            var _loc_2:String = "29c0b7f9144e1df98cdffebb7b0f6698";
            var _loc_3:String = "zombotron";
            this.agi.init(_loc_2, _loc_3);
            return;
        }// end function

        private function mouseDownHandler(event:Event) : void
        {
            if (event.target is Sound_btn || event.target is Quality_btn || event.target is Menu_btn || event.target is Music_btn || event.target is Restart_btn)
            {
            }
            else
            {
                this._universe.isMouseDown = true;
            }
            return;
        }// end function

        private function onHideBg() : Boolean
        {
            this._menuBg.alpha = this._menuBg.alpha - 0.1;
            this._fallPixels.alpha = this._menuBg.alpha;
            if (this._menuBg.alpha <= 0)
            {
                this._menuBg.alpha = 0;
                if (contains(this._menuBg))
                {
                    removeChild(this._menuBg);
                }
                this._fallPixels.alpha = 0;
                if (contains(this._fallPixels))
                {
                    removeChild(this._fallPixels);
                }
                this._fallPixels.stop();
                return true;
            }
            return false;
        }// end function

        private function startGame(event:MouseEvent = null) : void
        {
            this._screen.removeEventListener(MouseEvent.CLICK, this.startGame);
            this._menuBg.removeEventListener(MouseEvent.CLICK, this.startGame);
            ZG.key.unregister(this.startGame);
            this.nextScreen = SCR_GAME;
            this._tm.addTask(this.onPrepareLevel);
            this._tm.addTask(this.onHideScreen);
            this.hideMenu();
            return;
        }// end function

        private function onClearLevel() : void
        {
            this._universe.takeControl();
            this._universe.stop();
            this._universe.clear();
            return;
        }// end function

        public function showMenu() : void
        {
            this._menuBg.alpha = 0;
            addChild(this._menuBg);
            this._fallPixels.alpha = 0;
            addChild(this._fallPixels);
            this._tm.addTask(this.onShowBg);
            this._tm.addTask(this.onShowScreen);
            return;
        }// end function

        public static function getInstance() : Game
        {
            return _instance == null ? (new Game) : (_instance);
        }// end function

    }
}
