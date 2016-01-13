package com.zombotron.gui
{
    import com.antkarlov.anim.*;
    import com.antkarlov.controllers.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.helpers.*;
    import com.zombotron.levels.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class PlayerGui extends BasicMenu
    {
        private var _totalHealth:Number = 0;
        private var _coins:TextField;
        public var gameConsole:ConsoleGui;
        private var _supply:TextField;
        private var _motivators:Array;
        private var _healthSprite:Animation;
        private var _armorSprite:Animation;
        private var _bossBar:MovieClip;
        private var _healthLabel:TextField;
        private var _aidkitLabel:TextField;
        private var _armor:Number = 0;
        private var _healthPercent:Sprite;
        private var _weaponIcon:MovieClip;
        private var _fadeProc:TaskManager;
        private var _aidkit:int = 0;
        private var _aidkitSprite:Sprite;
        private var _totalBossHealth:Number = 0;
        private var _btnSound:SimpleButton;
        private var _isAnim:Boolean = false;
        private var _health:Number = 0;
        private var _motiCount:int = 0;
        private var _decHealth:Number = 0;
        private var _btnMusic:SimpleButton;
        private var _weaponLabel:Sprite;
        private var _armorLabel:TextField;
        private var _btnMenu:SimpleButton;
        private var _btnQuality:SimpleButton;
        private var _universe:Universe;
        private var _screenFade:MovieClip;
        private var _isPause:Boolean = false;
        private var _coinsSprite:Sprite;
        private var _btnRestart:SimpleButton;
        private var _isHotkeys:Boolean = false;
        private var _bossProc:TaskManager;
        private var _decArmor:Number = 0;
        private var _missions:Array;
        private var _bossHealth:Number = 0;
        private var _decBossHealth:Number = 0;
        private var _barProc:TaskManager;
        private var _armorPercent:Sprite;
        private var _guiProc:TaskManager;
        private var _totalArmor:Number = 0;
        private var _charger:TextField;
        private static var _instance:PlayerGui = null;

        public function PlayerGui()
        {
            var _loc_1:Sprite = null;
            this._motivators = [];
            this._missions = [];
            this._fadeProc = new TaskManager();
            this._barProc = new TaskManager();
            this._guiProc = new TaskManager();
            this._bossProc = new TaskManager();
            if (_instance != null)
            {
                throw "PlayerGui.as is a singleton class. Use PlayerGui.getInstance();";
            }
            _instance = this;
            this._universe = Universe.getInstance();
            this._screenFade = new ScreenFadeDamage_mc();
            this.gameConsole = new ConsoleGui();
            this.gameConsole.x = 6;
            this.gameConsole.y = 64;
            this.gameConsole.log(Art.TXT_GAME_CONSOLE);
            this._btnMusic = new Music_btn();
            this._btnMusic.x = App.SCR_W - 83;
            this._btnMusic.y = App.SCR_H - this._btnMusic.height - 10;
            this._btnMusic.alpha = ZG.media.enableMusic ? (1) : (0.5);
            this._btnMusic.addEventListener(MouseEvent.CLICK, this.musicEnableHandler);
            this._btnSound = new Sound_btn();
            this._btnSound.x = App.SCR_W - 68;
            this._btnSound.y = App.SCR_H - this._btnMusic.height - 10;
            this._btnSound.alpha = ZG.media.enableSound ? (1) : (0.5);
            this._btnSound.addEventListener(MouseEvent.CLICK, this.soundEnableHandler);
            this._btnQuality = new Quality_btn();
            this._btnQuality.x = App.SCR_W - 53;
            this._btnQuality.y = App.SCR_H - this._btnQuality.height - 10;
            this._btnQuality.addEventListener(MouseEvent.CLICK, this.qualityHandler);
            this._btnMenu = new Menu_btn();
            this._btnMenu.x = App.SCR_W - 38;
            this._btnMenu.y = App.SCR_H - this._btnMenu.height - 10;
            this._btnMenu.addEventListener(MouseEvent.CLICK, this.menuHandler);
            this._btnRestart = new Restart_btn();
            this._btnRestart.x = App.SCR_W - 23;
            this._btnRestart.y = App.SCR_H - this._btnMusic.height - 10;
            this._btnRestart.addEventListener(MouseEvent.CLICK, this.restartLevelHandler);
            this._weaponIcon = new IcoWeapon_mc();
            this._weaponIcon.x = 10;
            this._weaponIcon.y = 10;
            this._weaponLabel = new WeaponCharger_mc();
            this._weaponLabel.x = 44;
            this._weaponLabel.y = 34;
            if (this._weaponLabel["current"])
            {
                this._charger = this._weaponLabel["current"] as TextField;
            }
            if (this._weaponLabel["total"])
            {
                this._supply = this._weaponLabel["total"] as TextField;
            }
            this._coinsSprite = new CoinsLabel_mc();
            this._coinsSprite.y = 10;
            if (this._coinsSprite["label"])
            {
                this._coins = this._coinsSprite["label"] as TextField;
                this._coins.autoSize = TextFieldAutoSize.LEFT;
            }
            this._healthSprite = ZG.animCache.getAnimation(Art.HEALTH_BAR);
            this._healthSprite.x = App.SCR_W - 10;
            this._healthSprite.y = 10;
            this._healthSprite.stop();
            this._healthPercent = new PercentLabel_mc();
            this._healthPercent.y = 8;
            this._healthPercent.x = -103;
            this._healthPercent.alpha = 0;
            this._healthSprite.addChild(this._healthPercent);
            if (this._healthPercent["label"])
            {
                this._healthLabel = this._healthPercent["label"] as TextField;
            }
            this._armorSprite = ZG.animCache.getAnimation(Art.ARMOR_BAR);
            this._armorSprite.x = App.SCR_W - 10;
            this._armorSprite.y = 32;
            this._armorSprite.stop();
            this._armorPercent = new PercentLabel_mc();
            this._armorPercent.y = 8;
            this._armorPercent.x = -103;
            this._armorPercent.alpha = 0;
            this._armorSprite.addChild(this._armorPercent);
            if (this._armorPercent["label"])
            {
                this._armorLabel = this._armorPercent["label"] as TextField;
            }
            this._aidkitSprite = new AidkitBar_mc();
            this._aidkitSprite.x = App.SCR_W - 10;
            this._aidkitSprite.y = 56;
            this._aidkitSprite.alpha = 0;
            if (this._aidkitSprite["label"])
            {
                this._aidkitLabel = this._aidkitSprite["label"] as TextField;
            }
            _loc_1 = new ScreenCornLight_mc();
            addChild(_loc_1);
            _loc_1 = new ScreenCornLight_mc();
            _loc_1.x = App.SCR_W;
            _loc_1.scaleX = -1;
            addChild(_loc_1);
            this._screenFade.alpha = 0;
            addChild(this._screenFade);
            addChild(this.gameConsole);
            addChild(this._btnMusic);
            addChild(this._btnSound);
            addChild(this._btnQuality);
            addChild(this._btnMenu);
            addChild(this._btnRestart);
            addChild(this._weaponIcon);
            addChild(this._weaponLabel);
            addChild(this._healthSprite);
            addChild(this._armorSprite);
            addChild(this._aidkitSprite);
            addChild(this._coinsSprite);
            return;
        }// end function

        private function onShowScreen() : Boolean
        {
            this.alpha = this.alpha + 0.2;
            if (this.alpha >= 1)
            {
                this.alpha = 1;
                return true;
            }
            return false;
        }// end function

        public function coins(param1:int) : void
        {
            this._coins.text = param1.toString();
            this._coinsSprite.x = int(App.SCR_HALF_W - this._coinsSprite.width * 0.5);
            return;
        }// end function

        public function getArmorPos() : Avector
        {
            return new Avector(this._armorSprite.x - 20, this._armorSprite.y + 20);
        }// end function

        public function makeMissionComplete(param1:uint) : void
        {
            var _loc_3:int = 0;
            var _loc_4:MissionComplete = null;
            var _loc_2:* = LevelBase.getMissions(this._universe.level.levelNum);
            if (_loc_2 != null)
            {
                _loc_3 = 0;
                while (_loc_3 < _loc_2.length)
                {
                    
                    if (_loc_2[_loc_3].condition == param1)
                    {
                        _loc_4 = new MissionComplete();
                        _loc_4.init(Text.TXT_MISSION_COMPLETED, _loc_2[_loc_3].desc);
                        addChild(_loc_4);
                        break;
                    }
                    _loc_3++;
                }
            }
            return;
        }// end function

        public function justShow() : void
        {
            this.alpha = 0;
            this._fadeProc.addTask(this.onShowScreen);
            this._fadeProc.addInstantTask(this.addHotkeys);
            return;
        }// end function

        public function aidkit(param1:int) : void
        {
            if (param1 > 0)
            {
                this._guiProc.addTask(this.onShow, [this._aidkitSprite]);
            }
            else if (param1 <= 0)
            {
                this._guiProc.addTask(this.onHide, [this._aidkitSprite]);
            }
            this._aidkit = param1;
            this._aidkitLabel.text = this._aidkit.toString();
            return;
        }// end function

        private function musicEnableHandler(event:MouseEvent) : void
        {
            ZG.media.enableMusic = !ZG.media.enableMusic;
            (event.currentTarget as SimpleButton).alpha = ZG.media.enableMusic ? (1) : (0.5);
            ZG.saveBox.enableMusic = ZG.media.enableMusic ? (1) : (0);
            return;
        }// end function

        public function getAidkitPos() : Avector
        {
            return new Avector(this._aidkitSprite.x - 20, this._aidkitSprite.y + 20);
        }// end function

        public function bossHealth(param1:Number) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:int = 0;
            if (param1 < this._bossHealth)
            {
                this._decBossHealth = param1;
                this._bossProc.clear();
                this._bossProc.addTask(this.onDecBossHealth);
            }
            else if (param1 >= this._bossHealth)
            {
                this._bossHealth = param1;
                _loc_2 = Amath.toPercent(this._bossHealth, this._totalBossHealth);
                _loc_3 = int(Amath.fromPercent(_loc_2, this._bossBar.totalFrames));
                this._bossBar.gotoAndStop(_loc_3 <= 0 ? (1) : (_loc_3));
                this._bossProc.clear();
            }
            return;
        }// end function

        private function onDecBossHealth() : Boolean
        {
            var _loc_1:Number = NaN;
            var _loc_2:int = 0;
            if (this._bossHealth > this._decBossHealth)
            {
                this._bossHealth = Amath.lerp(this._bossHealth, this._decBossHealth, 0.2);
                _loc_1 = Amath.toPercent(this._bossHealth, this._totalBossHealth);
                _loc_2 = int(Amath.fromPercent(_loc_1, this._bossBar.totalFrames));
                this._bossBar.gotoAndStop(_loc_2 <= 0 ? (1) : (_loc_2));
                if (Amath.equal(this._bossHealth, this._decBossHealth, 0.01))
                {
                    this._bossHealth = this._decBossHealth;
                    return true;
                }
            }
            return false;
        }// end function

        private function doColorPink(param1:TextField) : void
        {
            param1.textColor = 16270258;
            return;
        }// end function

        public function achievement(param1:uint) : void
        {
            var _loc_2:* = new AchievementGui();
            _loc_2.kind = param1;
            _loc_2.show();
            addChild(_loc_2);
            ZG.saveBox.addAchievement(param1);
            return;
        }// end function

        private function menuHandler(event:MouseEvent) : void
        {
            this.makePause();
            return;
        }// end function

        public function charger(param1:int) : void
        {
            this._charger.text = param1.toString();
            return;
        }// end function

        public function armor(param1:Number) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:int = 0;
            if (param1 == 0)
            {
                this._armor = param1;
                this._guiProc.addTask(this.onHide, [this._armorSprite]);
                return;
            }
            if (param1 < this._armor)
            {
                _loc_2 = 100 - Amath.toPercent(param1, this._totalArmor);
                this._screenFade.gotoAndStop(2);
                this._screenFade.alpha = this._screenFade.alpha + Amath.fromPercent(_loc_2, 1);
                this._screenFade.alpha = this._screenFade.alpha > 1 ? (1) : (this._screenFade.alpha);
                this._fadeProc.addTask(this.onScreenFade);
                this._decArmor = param1;
                this._barProc.addTask(this.onDecArmor);
            }
            else if (param1 >= this._armor)
            {
                this._armor = param1;
                if (this._armor > 0 && this._armorSprite.alpha < 1)
                {
                    this._guiProc.addTask(this.onShow, [this._armorSprite]);
                }
                _loc_3 = Amath.toPercent(this._armor, this._totalArmor);
                _loc_4 = int(Amath.fromPercent(_loc_3, this._armorSprite.totalFrames));
                this._armorSprite.gotoAndStop(_loc_4 <= 0 ? (1) : (_loc_4));
                this._armorLabel.text = Math.floor(_loc_3).toString() + "/100";
                this._armorPercent.alpha = 1 - _loc_3 / 100;
                this._barProc.clear();
            }
            return;
        }// end function

        override public function hide() : void
        {
            this.alpha = 1;
            this.removeHotkeys();
            this._fadeProc.addTask(this.onHideScreen);
            this._fadeProc.addTask(onComplete);
            return;
        }// end function

        private function qualityHandler(event:MouseEvent) : void
        {
            this._universe.smoothing = !this._universe.smoothing;
            (event.currentTarget as SimpleButton).alpha = this._universe.smoothing ? (1) : (0.5);
            ZG.saveBox.enableQuality = this._universe.smoothing ? (1) : (0);
            var _loc_2:* = ZG.divideString(Text.CON_QUALITY_WILL_BE_CHANGED, 25);
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                this.gameConsole.log(_loc_2[_loc_3]);
                _loc_3++;
            }
            return;
        }// end function

        public function justHide() : void
        {
            this.alpha = 1;
            this.removeHotkeys();
            this._fadeProc.addTask(this.onHideScreen);
            return;
        }// end function

        public function removeMoti(param1:Motivation) : void
        {
            var _loc_2:* = this._motivators.indexOf(param1);
            if (_loc_2 > -1)
            {
                this._motivators[_loc_2] = null;
                this._motivators.splice(_loc_2, 1);
            }
            this._motiCount = this._motivators.length == 0 ? (0) : (this._motiCount);
            return;
        }// end function

        private function onScreenFade() : Boolean
        {
            this._screenFade.alpha = this._screenFade.alpha - 0.01;
            if (this._screenFade.alpha <= 0)
            {
                this._screenFade.alpha = 0;
                return true;
            }
            return false;
        }// end function

        public function health(param1:Number) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:int = 0;
            if (param1 < this._health)
            {
                _loc_2 = 100 - Amath.toPercent(param1, this._health);
                this._screenFade.gotoAndStop(1);
                this._screenFade.alpha = this._screenFade.alpha + Amath.fromPercent(_loc_2, 1);
                this._screenFade.alpha = this._screenFade.alpha > 1 ? (1) : (this._screenFade.alpha);
                this._fadeProc.addTask(this.onScreenFade);
                if (this._armorSprite.alpha != 0)
                {
                    this._guiProc.addTask(this.onHide, [this._armorSprite]);
                }
                this._decHealth = param1;
                this._barProc.clear();
                this._barProc.addTask(this.onDecHealth);
            }
            else if (param1 >= this._health)
            {
                this._health = param1;
                _loc_3 = Amath.toPercent(this._health, this._totalHealth);
                _loc_4 = int(Amath.fromPercent(_loc_3, this._healthSprite.totalFrames));
                this._healthSprite.gotoAndStop(_loc_4 <= 0 ? (1) : (_loc_4));
                this._healthLabel.text = Math.floor(_loc_3).toString() + "/100";
                this._healthPercent.alpha = 1 - _loc_3 / 100;
                this._barProc.clear();
            }
            return;
        }// end function

        public function totalArmor(param1:Number) : void
        {
            this._totalArmor = param1;
            return;
        }// end function

        private function onDecArmor() : Boolean
        {
            var _loc_1:Number = NaN;
            var _loc_2:int = 0;
            if (this._armor > this._decArmor)
            {
                this._armor = Amath.lerp(this._armor, this._decArmor, 0.2);
                _loc_1 = Amath.toPercent(this._armor, this._totalArmor);
                _loc_2 = int(Amath.fromPercent(_loc_1, this._armorSprite.totalFrames));
                this._armorSprite.gotoAndStop(_loc_2 <= 0 ? (1) : (_loc_2));
                this._armorLabel.text = Math.floor(_loc_1).toString() + "/100";
                this._armorPercent.alpha = 1 - _loc_1 / 100;
                if (Amath.equal(this._armor, this._decArmor, 0.01))
                {
                    this._armor = this._decArmor;
                    if (this._armor <= 0)
                    {
                        this._guiProc.addTask(this.onHide, [this._armorSprite]);
                    }
                    return true;
                }
            }
            return false;
        }// end function

        public function getCoinsPos() : Avector
        {
            return new Avector(this._coinsSprite.x + this._coinsSprite.width * 0.5, this._coinsSprite.y);
        }// end function

        public function getAmmoPos() : Avector
        {
            return new Avector(this._weaponLabel.x + 50, this._weaponLabel.y + 10);
        }// end function

        private function onShow(param1:Sprite) : Boolean
        {
            param1.alpha = param1.alpha + 0.2;
            if (param1.alpha >= 1)
            {
                param1.alpha = 1;
                return true;
            }
            return false;
        }// end function

        public function updateMission(param1:uint, param2:int, param3:Boolean = true, param4:Boolean = true) : void
        {
            var _loc_5:MissionIco = null;
            var _loc_6:* = this._missions.length;
            var _loc_7:int = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_5 = this._missions[_loc_7] as MissionIco;
                if (_loc_5 != null && !_loc_5.isCompleted && _loc_5.condition == param1)
                {
                    _loc_5.updateValue(param2, param4);
                    if (param3)
                    {
                        this.missionComplete(param1);
                    }
                    break;
                }
                _loc_7++;
            }
            return;
        }// end function

        public function getMissionTarget(param1:uint) : Avector
        {
            var _loc_2:MissionIco = null;
            var _loc_3:* = this._missions.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = this._missions[_loc_4] as MissionIco;
                if (_loc_2 != null && !_loc_2.isFree && _loc_2.condition == param1)
                {
                    return new Avector(_loc_2.x, _loc_2.y);
                }
                _loc_4++;
            }
            return new Avector();
        }// end function

        public function isHaveMission(param1:uint) : Boolean
        {
            var _loc_2:MissionIco = null;
            var _loc_3:* = this._missions.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = this._missions[_loc_4] as MissionIco;
                if (_loc_2 != null && !_loc_2.isCompleted && _loc_2.condition == param1)
                {
                    return true;
                }
                _loc_4++;
            }
            return false;
        }// end function

        public function totalBossHealth(param1:Number) : void
        {
            this._totalBossHealth = param1;
            return;
        }// end function

        public function motivation(param1:uint) : void
        {
            var _loc_2:* = new Motivation();
            _loc_2.kind = param1;
            _loc_2.start();
            _loc_2.y = _loc_2.y - 20 * this._motiCount;
            var _loc_3:String = this;
            var _loc_4:* = this._motiCount + 1;
            _loc_3._motiCount = _loc_4;
            this._motivators[this._motivators.length] = _loc_2;
            addChild(_loc_2);
            return;
        }// end function

        private function soundEnableHandler(event:MouseEvent) : void
        {
            ZG.media.enableSound = !ZG.media.enableSound;
            (event.currentTarget as SimpleButton).alpha = ZG.media.enableSound ? (1) : (0.5);
            ZG.saveBox.enableSound = ZG.media.enableSound ? (1) : (0);
            return;
        }// end function

        public function removeHotkeys() : void
        {
            if (this._isHotkeys)
            {
                ZG.key.unregister(KeyCode.ESC);
                ZG.key.unregister(KeyCode.P);
                this._isHotkeys = false;
            }
            return;
        }// end function

        private function doColorLime(param1:TextField) : void
        {
            param1.textColor = 12254233;
            return;
        }// end function

        public function showBossBar() : void
        {
            if (this._bossBar == null)
            {
                this._bossBar = new BossBar_mc();
            }
            this._bossBar.alpha = 0;
            this._bossBar.x = App.SCR_HALF_W;
            this._bossBar.y = 40;
            addChild(this._bossBar);
            this._fadeProc.addTask(this.onShow, [this._bossBar]);
            return;
        }// end function

        private function makePause() : void
        {
            if (!this._isPause && !ZG.console.enabled)
            {
                ZG.game.nextScreen = Game.SCR_PAUSE;
                ZG.game.showMenu();
                this.removeHotkeys();
                this._isPause = true;
            }
            return;
        }// end function

        public function addMission(param1:uint, param2:int, param3:int) : void
        {
            var _loc_4:* = new MissionIco();
            _loc_4.init(param1, param2, param3);
            _loc_4.x = App.SCR_W - 21;
            _loc_4.y = App.SCR_H - 56 - this._missions.length * 30;
            addChild(_loc_4);
            this._missions[this._missions.length] = _loc_4;
            return;
        }// end function

        public function getMissionValue(param1:uint) : int
        {
            var _loc_2:MissionIco = null;
            var _loc_3:* = this._missions.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = this._missions[_loc_4] as MissionIco;
                if (_loc_2 != null && !_loc_2.isFree && _loc_2.condition == param1)
                {
                    return _loc_2.value;
                }
                _loc_4++;
            }
            return 0;
        }// end function

        public function chargerBlink() : void
        {
            _tm.clear();
            var _loc_1:int = 0;
            while (_loc_1 < 6)
            {
                
                if (_loc_1 % 2 == 0)
                {
                    _tm.addInstantTask(this.doColorPink, [this._charger]);
                }
                else
                {
                    _tm.addInstantTask(this.doColorLime, [this._charger]);
                }
                _tm.addPause(3);
                _loc_1++;
            }
            return;
        }// end function

        public function totalHealth(param1:Number) : void
        {
            this._totalHealth = param1;
            return;
        }// end function

        private function onHide(param1:Sprite) : Boolean
        {
            param1.alpha = param1.alpha - 0.2;
            if (param1.alpha <= 0)
            {
                param1.alpha = 0;
                return true;
            }
            return false;
        }// end function

        public function hideBossBar() : void
        {
            this._fadeProc.addTask(this.onHide, [this._bossBar]);
            return;
        }// end function

        private function onHideScreen() : Boolean
        {
            this.alpha = this.alpha - 0.2;
            if (this.alpha <= 0)
            {
                this.alpha = 0;
                return true;
            }
            return false;
        }// end function

        public function clearMissions() : void
        {
            var _loc_1:* = this._missions.length;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                (this._missions[_loc_2] as MissionIco).free();
                this._missions[_loc_2] = null;
                _loc_2++;
            }
            this._missions.length = 0;
            return;
        }// end function

        private function restartLevelHandler(event:MouseEvent) : void
        {
            if (!this._universe.isRestarting)
            {
                this._universe.restartLevel();
            }
            return;
        }// end function

        private function onDecHealth() : Boolean
        {
            var _loc_1:Number = NaN;
            var _loc_2:int = 0;
            if (this._health > this._decHealth)
            {
                this._health = Amath.lerp(this._health, this._decHealth, 0.2);
                _loc_1 = Amath.toPercent(this._health, this._totalHealth);
                _loc_2 = int(Amath.fromPercent(_loc_1, this._healthSprite.totalFrames));
                this._healthSprite.gotoAndStop(_loc_2 <= 0 ? (1) : (_loc_2));
                this._healthLabel.text = Math.floor(_loc_1).toString() + "/100";
                this._healthPercent.alpha = 1 - _loc_1 / 100;
                if (Amath.equal(this._health, this._decHealth, 0.01))
                {
                    this._health = this._decHealth;
                    return true;
                }
            }
            return false;
        }// end function

        private function addHotkeys() : void
        {
            if (!this._isHotkeys)
            {
                ZG.key.register(this.makePause, KeyCode.ESC);
                ZG.key.register(this.makePause, KeyCode.P);
                this._isHotkeys = true;
            }
            return;
        }// end function

        public function missionComplete(param1:uint) : void
        {
            var _loc_2:MissionIco = null;
            var _loc_3:* = this._missions.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = this._missions[_loc_4] as MissionIco;
                if (_loc_2.isCompleted)
                {
                }
                else
                {
                    if (_loc_2.condition == param1)
                    {
                        switch(_loc_2.condition)
                        {
                            case LevelBase.MISSION_TIME:
                            {
                                if (this._universe.player.missionTime > 0)
                                {
                                    _loc_2.isCompleted = true;
                                }
                                break;
                            }
                            case LevelBase.MISSION_COIN:
                            {
                                if (this._universe.player.missionCoin >= _loc_2.value)
                                {
                                    _loc_2.isCompleted = true;
                                }
                                break;
                            }
                            case LevelBase.MISSION_ZOMBIE:
                            {
                                if (this._universe.player.missionZombie >= _loc_2.value)
                                {
                                    _loc_2.isCompleted = true;
                                }
                                break;
                            }
                            case LevelBase.MISSION_ROBOT:
                            {
                                if (this._universe.player.missionRobot >= _loc_2.value)
                                {
                                    _loc_2.isCompleted = true;
                                }
                                break;
                            }
                            case LevelBase.MISSION_BOOM:
                            {
                                if (this._universe.player.missionBoom >= _loc_2.value)
                                {
                                    _loc_2.isCompleted = true;
                                }
                                break;
                            }
                            case LevelBase.MISSION_SHOPING:
                            {
                                if (this._universe.player.missionShoping >= _loc_2.value)
                                {
                                    _loc_2.isCompleted = true;
                                }
                                break;
                            }
                            case LevelBase.MISSION_BARREL:
                            {
                                if (this._universe.player.missionBarrel >= _loc_2.value)
                                {
                                    _loc_2.isCompleted = true;
                                }
                                break;
                            }
                            case LevelBase.MISSION_MEGAKILL:
                            {
                                if (this._universe.player.missionMegaKill >= _loc_2.value)
                                {
                                    _loc_2.isCompleted = true;
                                }
                                break;
                            }
                            case LevelBase.MISSION_SILENT:
                            {
                                if (this._universe.player.missionShot < _loc_2.value)
                                {
                                    _loc_2.isCompleted = true;
                                }
                                break;
                            }
                            case LevelBase.MISSION_CHEST:
                            {
                                if (this._universe.player.missionChest >= _loc_2.value)
                                {
                                    _loc_2.isCompleted = true;
                                }
                                break;
                            }
                            case LevelBase.MISSION_BOX:
                            {
                                if (this._universe.player.missionBox >= _loc_2.value)
                                {
                                    _loc_2.isCompleted = true;
                                }
                                break;
                            }
                            case LevelBase.MISSION_SKELETON:
                            {
                                if (this._universe.player.missionSkeleton >= _loc_2.value)
                                {
                                    _loc_2.isCompleted = true;
                                }
                                break;
                            }
                            case LevelBase.MISSION_BAG:
                            {
                                if (this._universe.player.missionBag >= _loc_2.value)
                                {
                                    _loc_2.isCompleted = true;
                                }
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                    }
                    if (_loc_2.isCompleted)
                    {
                        _loc_2.hide();
                        this.makeMissionComplete(param1);
                        this.gameConsole.log(Text.TXT_MISSION_COMPLETED + "...");
                        ZG.sound(SoundManager.MISSION_COMPLETE);
                        ZG.saveBox.missionComplete((this._universe.level.levelNum - 1), _loc_2.id);
                    }
                }
                _loc_4++;
            }
            return;
        }// end function

        public function supply(param1:int) : void
        {
            this._supply.text = "/" + param1.toString();
            return;
        }// end function

        public function currentWeapon(param1:uint) : void
        {
            this._weaponIcon.gotoAndStop(param1);
            switch(param1)
            {
                case ShopBox.ITEM_PISTOL:
                {
                    this._weaponLabel.x = 13;
                    this._weaponLabel.y = 29;
                    this.charger(8);
                    break;
                }
                case ShopBox.ITEM_SHOTGUN:
                {
                    this._weaponLabel.x = 28;
                    this._weaponLabel.y = 31;
                    this.charger(2);
                    break;
                }
                case ShopBox.ITEM_GUN:
                {
                    this._weaponLabel.x = 41;
                    this._weaponLabel.y = 38;
                    this.charger(12);
                    break;
                }
                case ShopBox.ITEM_GRENADEGUN:
                {
                    this._weaponLabel.x = 32;
                    this._weaponLabel.y = 40;
                    this.charger(3);
                    break;
                }
                case ShopBox.ITEM_MACHINEGUN:
                {
                    this._weaponLabel.x = 56;
                    this._weaponLabel.y = 48;
                    this.charger(50);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override public function show() : void
        {
            this._btnMusic.alpha = ZG.media.enableMusic ? (1) : (0.5);
            this._btnSound.alpha = ZG.media.enableSound ? (1) : (0.5);
            this._btnQuality.alpha = this._universe.smoothing ? (1) : (0.5);
            this._isPause = false;
            this.alpha = 0;
            this._fadeProc.addTask(this.onShowScreen);
            this._fadeProc.addInstantTask(this.addHotkeys);
            return;
        }// end function

        public static function getInstance() : PlayerGui
        {
            return _instance == null ? (new PlayerGui) : (_instance);
        }// end function

    }
}
