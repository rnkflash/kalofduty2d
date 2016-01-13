package com.zombotron.helpers
{
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.antkarlov.utils.*;
    import com.zombotron.core.*;

    public class SaveBox extends Object
    {
        private var _oldSecretsLength:int = -1;
        public var coins:uint = 0;
        public var explodedEnemies:int = 0;
        private var _tm:TaskManager;
        public var totalCoins:int = 0;
        public var playTime:int = 0;
        public var achievements:Array;
        public var robotsKilled:int = 0;
        public var secondCharger:int = 0;
        public var armor:Number = 0;
        public var accuracyShots:int = 0;
        public var bossKilled:int = 0;
        public var isHaveSave:int = 0;
        public var shotgunShots:int = 0;
        public var gunShots:int = 0;
        public var exterminator:int = 0;
        public var enableSound:int = 0;
        public var health:Number = 0;
        public var enableMusic:int = 0;
        public var missions:Array;
        public var firstCharger:int = 0;
        public var deaths:int = 0;
        public var pistolShots:int = 0;
        public var secondSupply:int = 0;
        public var silentKills:int = 0;
        private var _haveData:Boolean;
        public var completedLevels:int = 1;
        public var machinegunShots:int = 0;
        public var grenadegunShots:int = 0;
        public var coveredDistance:Number = 0;
        public var secondWeapon:uint = 0;
        public var destroyedObjects:int = 0;
        public var firstSupply:int = 0;
        public var secrets:Array;
        public var careful:int = 0;
        public var skeletonsKilled:int = 0;
        public var foundedSecrets:int = 0;
        public var zombiesKilled:int = 0;
        public var firstWeapon:uint = 0;
        private var _oldAchiLength:int = -1;
        public var aidKit:uint = 0;
        public var enableQuality:int = 0;
        private static const KEY_SECRETS:String = "zbt_secrets";
        private static const KEY_ACHIEVEMENTS:String = "zbt_achievements";
        private static const KEY_MISSIONS:String = "zbt_missions";
        private static const KEY_PREF:String = "zbt_pref";
        private static const KEY_LEVEL:String = "zbt_level";
        private static const KEY_STATISTIC:String = "zbt_statistics";

        public function SaveBox()
        {
            this.achievements = [];
            this.missions = [];
            this.secrets = [];
            this._tm = new TaskManager();
            this._haveData = false;
            this.clearMissions();
            return;
        }// end function

        private function saveMissions(param1:int) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:* = new Cookies(KEY_MISSIONS, false);
            _loc_2 = this.missions.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4.setValue("l" + _loc_3.toString(), this.missions[_loc_3]);
                _loc_3++;
            }
            _loc_4.flush();
            return;
        }// end function

        public function isHaveAchievement(param1) : Boolean
        {
            return this.achievements.indexOf(param1) > -1 ? (true) : (false);
        }// end function

        private function loadPref() : void
        {
            var _loc_1:* = new Cookies(KEY_PREF, false);
            if (!_loc_1.isEmpty())
            {
                this.enableMusic = int(_loc_1.getValue("em"));
                this.enableSound = int(_loc_1.getValue("es"));
                this.enableQuality = int(_loc_1.getValue("eq"));
                this.isHaveSave = int(_loc_1.getValue("hs"));
            }
            else
            {
                this.enableMusic = 1;
                this.enableSound = 1;
                this.enableQuality = 1;
                this.isHaveSave = 0;
            }
            return;
        }// end function

        private function loadAchievements() : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_1:* = new Cookies(KEY_ACHIEVEMENTS, false);
            if (!_loc_1.isEmpty())
            {
                this.achievements.length = 0;
                _loc_2 = int(_loc_1.getValue("c"));
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    this.addAchievement(int(_loc_1.getValue("a" + _loc_3.toString())));
                    _loc_3++;
                }
                this._oldAchiLength = this.achievements.length;
            }
            return;
        }// end function

        public function get haveData() : Boolean
        {
            return this._haveData;
        }// end function

        private function saveAchievements() : void
        {
            var _loc_1:Cookies = null;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (this._oldAchiLength != this.achievements.length)
            {
                _loc_1 = new Cookies(KEY_ACHIEVEMENTS, false);
                _loc_2 = this.achievements.length;
                _loc_1.setValue("c", _loc_2);
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_1.setValue("a" + _loc_3.toString(), this.achievements[_loc_3]);
                    _loc_3++;
                }
                _loc_1.flush();
                this._oldAchiLength = this.achievements.length;
            }
            return;
        }// end function

        public function clear() : void
        {
            var _loc_1:* = new Cookies(KEY_MISSIONS);
            _loc_1.removeData();
            _loc_1 = new Cookies(KEY_ACHIEVEMENTS);
            _loc_1.removeData();
            _loc_1 = new Cookies(KEY_SECRETS);
            _loc_1.removeData();
            _loc_1 = new Cookies(KEY_STATISTIC);
            _loc_1.removeData();
            var _loc_2:int = 1;
            while (_loc_2 <= 10)
            {
                
                _loc_1 = new Cookies(KEY_LEVEL + _loc_2.toString());
                _loc_1.removeData();
                _loc_2++;
            }
            this.reset();
            ZG.console.trace("Saves has been removed.");
            return;
        }// end function

        private function savePref() : void
        {
            var _loc_1:* = new Cookies(KEY_PREF, false);
            _loc_1.setValue("em", this.enableMusic);
            _loc_1.setValue("es", this.enableSound);
            _loc_1.setValue("eq", this.enableQuality);
            _loc_1.setValue("hs", 1);
            _loc_1.flush();
            return;
        }// end function

        public function reset() : void
        {
            this.deaths = 0;
            this.playTime = 0;
            this.pistolShots = 0;
            this.shotgunShots = 0;
            this.gunShots = 0;
            this.grenadegunShots = 0;
            this.machinegunShots = 0;
            this.coveredDistance = 0;
            this.totalCoins = 0;
            this.accuracyShots = 0;
            this.zombiesKilled = 0;
            this.robotsKilled = 0;
            this.skeletonsKilled = 0;
            this.completedLevels = 1;
            this.destroyedObjects = 0;
            this.explodedEnemies = 0;
            this.foundedSecrets = 0;
            this.silentKills = 0;
            this.exterminator = 0;
            this.bossKilled = 0;
            this.careful = 0;
            this.enableMusic = 1;
            this.enableSound = 1;
            this.enableQuality = 1;
            this.isHaveSave = 0;
            this._oldAchiLength = -1;
            this._oldSecretsLength = -1;
            this.achievements.length = 0;
            this.secrets.length = 0;
            this.clearMissions();
            this._haveData = false;
            return;
        }// end function

        public function set haveData(param1:Boolean) : void
        {
            this._haveData = param1;
            return;
        }// end function

        public function isLevelEnabled(param1:int) : int
        {
            return this.completedLevels >= param1 ? (param1) : (-1);
        }// end function

        public function isMissionCompleted(param1:int, param2:int) : Boolean
        {
            if ((param1 - 1) >= 0 && (param1 - 1) < this.missions.length)
            {
                switch(param2)
                {
                    case 0:
                    {
                        return this.missions[(param1 - 1)].mission1;
                    }
                    case 1:
                    {
                        return this.missions[(param1 - 1)].mission2;
                    }
                    case 2:
                    {
                        return this.missions[(param1 - 1)].mission3;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return false;
        }// end function

        public function statisticShot(param1:uint) : void
        {
            switch(param1)
            {
                case ShopBox.ITEM_PISTOL:
                {
                    var _loc_2:String = this;
                    var _loc_3:* = this.pistolShots + 1;
                    _loc_2.pistolShots = _loc_3;
                    break;
                }
                case ShopBox.ITEM_SHOTGUN:
                {
                    var _loc_2:String = this;
                    var _loc_3:* = this.shotgunShots + 1;
                    _loc_2.shotgunShots = _loc_3;
                    break;
                }
                case ShopBox.ITEM_GUN:
                {
                    var _loc_2:String = this;
                    var _loc_3:* = this.gunShots + 1;
                    _loc_2.gunShots = _loc_3;
                    break;
                }
                case ShopBox.ITEM_GRENADEGUN:
                {
                    var _loc_2:String = this;
                    var _loc_3:* = this.grenadegunShots + 1;
                    _loc_2.grenadegunShots = _loc_3;
                    break;
                }
                case ShopBox.ITEM_MACHINEGUN:
                {
                    var _loc_2:String = this;
                    var _loc_3:* = this.machinegunShots + 1;
                    _loc_2.machinegunShots = _loc_3;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function loadMissions() : void
        {
            var _loc_2:int = 0;
            var _loc_1:* = new Cookies(KEY_MISSIONS);
            if (!_loc_1.isEmpty())
            {
                _loc_2 = 0;
                while (_loc_2 < 10)
                {
                    
                    this.missions[_loc_2] = _loc_1.getValue("l" + _loc_2.toString());
                    if (this.missions[_loc_2] == null)
                    {
                        this.missions[_loc_2] = {mission1:false, mission2:false, mission3:false};
                    }
                    _loc_2++;
                }
            }
            return;
        }// end function

        public function getAccuracy() : int
        {
            var _loc_1:* = this.pistolShots + this.shotgunShots + this.gunShots + this.grenadegunShots + this.machinegunShots;
            return Amath.toPercent(this.accuracyShots, _loc_1);
        }// end function

        public function loadPlayer(param1:int) : Boolean
        {
            var _loc_2:* = new Cookies(KEY_LEVEL + param1.toString());
            if (!_loc_2.isEmpty())
            {
                this.firstWeapon = int(_loc_2.getValue("fw"));
                this.firstCharger = int(_loc_2.getValue("fc"));
                this.firstSupply = int(_loc_2.getValue("fs"));
                this.secondWeapon = int(_loc_2.getValue("sw"));
                this.secondCharger = int(_loc_2.getValue("sc"));
                this.secondSupply = int(_loc_2.getValue("ss"));
                this.health = Number(_loc_2.getValue("ph"));
                this.armor = Number(_loc_2.getValue("pa"));
                this.aidKit = int(_loc_2.getValue("ak"));
                this.coins = int(_loc_2.getValue("pc"));
                this._haveData = true;
                return true;
            }
            this._haveData = false;
            return false;
        }// end function

        public function getCoveredDistance() : String
        {
            var _loc_1:* = this.coveredDistance / 40 / 1600;
            return _loc_1.toFixed(1);
        }// end function

        public function save(param1:int) : void
        {
            if (param1 > this.completedLevels)
            {
                this.completedLevels = param1;
            }
            this._tm.clear();
            this._tm.addInstantTask(this.savePlayer, [param1]);
            this._tm.addInstantTask(this.saveMissions, [param1]);
            this._tm.addInstantTask(this.saveAchievements);
            this._tm.addInstantTask(this.saveSecrets);
            this._tm.addInstantTask(this.saveStatistics);
            this._tm.addInstantTask(this.savePref);
            this._tm.addInstantTask(ZG.console.trace, ["Game progress saved."]);
            return;
        }// end function

        public function justSave(param1:int = 0) : void
        {
            this._tm.clear();
            if (param1 != 0)
            {
                this._tm.addInstantTask(this.saveMissions, [param1]);
            }
            this._tm.addInstantTask(this.saveAchievements);
            this._tm.addInstantTask(this.saveSecrets);
            this._tm.addInstantTask(this.saveStatistics);
            this._tm.addInstantTask(this.savePref);
            this._tm.addInstantTask(ZG.console.trace, ["Game progress saved."]);
            return;
        }// end function

        private function saveSecrets() : void
        {
            var _loc_1:Cookies = null;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (this._oldSecretsLength != this.secrets.length)
            {
                _loc_1 = new Cookies(KEY_SECRETS, false);
                _loc_2 = this.secrets.length;
                _loc_1.setValue("c", _loc_2);
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_1.setValue("s" + _loc_3.toString(), this.secrets[_loc_3]);
                    _loc_3++;
                }
                _loc_1.flush();
                this._oldSecretsLength = this.secrets.length;
            }
            return;
        }// end function

        private function saveStatistics() : void
        {
            var _loc_1:* = new Cookies(KEY_STATISTIC, false);
            _loc_1.setValue("pd", this.deaths);
            _loc_1.setValue("pt", this.playTime);
            _loc_1.setValue("ps", this.pistolShots);
            _loc_1.setValue("ss", this.shotgunShots);
            _loc_1.setValue("gs", this.gunShots);
            _loc_1.setValue("ggs", this.grenadegunShots);
            _loc_1.setValue("ms", this.machinegunShots);
            _loc_1.setValue("cd", this.coveredDistance);
            _loc_1.setValue("tc", this.totalCoins);
            _loc_1.setValue("as", this.accuracyShots);
            _loc_1.setValue("zk", this.zombiesKilled);
            _loc_1.setValue("rk", this.robotsKilled);
            _loc_1.setValue("sk", this.skeletonsKilled);
            _loc_1.setValue("lc", this.completedLevels);
            _loc_1.setValue("do", this.destroyedObjects);
            _loc_1.setValue("aee", this.explodedEnemies);
            _loc_1.setValue("afs", this.foundedSecrets);
            _loc_1.setValue("ask", this.silentKills);
            _loc_1.flush();
            return;
        }// end function

        public function getPlayTime() : String
        {
            return Amath.formatTime(this.playTime);
        }// end function

        public function calcFinalResult() : int
        {
            var _loc_1:* = this.missions.length == 0 ? (1) : (this.missions.length);
            return this.getTotalKilled() + this.totalCoins + this.destroyedObjects + this.getTotalShots() * _loc_1;
        }// end function

        private function loadStatistics() : void
        {
            var _loc_1:* = new Cookies(KEY_STATISTIC, false);
            if (!_loc_1.isEmpty())
            {
                this.deaths = int(_loc_1.getValue("pd"));
                this.playTime = int(_loc_1.getValue("pt"));
                this.pistolShots = int(_loc_1.getValue("ps"));
                this.shotgunShots = int(_loc_1.getValue("ss"));
                this.gunShots = int(_loc_1.getValue("gs"));
                this.grenadegunShots = int(_loc_1.getValue("gg"));
                this.machinegunShots = int(_loc_1.getValue("ms"));
                this.coveredDistance = Number(_loc_1.getValue("cd"));
                this.totalCoins = int(_loc_1.getValue("tc"));
                this.accuracyShots = int(_loc_1.getValue("as"));
                this.zombiesKilled = int(_loc_1.getValue("zk"));
                this.robotsKilled = int(_loc_1.getValue("rk"));
                this.skeletonsKilled = int(_loc_1.getValue("sk"));
                this.completedLevels = int(_loc_1.getValue("lc"));
                if (this.completedLevels <= 0)
                {
                    this.completedLevels = 1;
                }
                this.destroyedObjects = int(_loc_1.getValue("do"));
                this.explodedEnemies = int(_loc_1.getValue("aee"));
                this.foundedSecrets = int(_loc_1.getValue("afs"));
                this.silentKills = int(_loc_1.getValue("ask"));
            }
            return;
        }// end function

        public function addSecret(param1:String) : void
        {
            var _loc_2:* = this.secrets.indexOf(param1);
            if (_loc_2 == -1)
            {
                this.secrets[this.secrets.length] = param1;
            }
            return;
        }// end function

        public function getTotalKilled() : int
        {
            return this.zombiesKilled + this.robotsKilled + this.skeletonsKilled;
        }// end function

        private function savePlayer(param1:int) : void
        {
            var _loc_2:* = new Cookies(KEY_LEVEL + param1.toString(), false);
            _loc_2.setValue("fw", this.firstWeapon);
            _loc_2.setValue("fc", this.firstCharger);
            _loc_2.setValue("fs", this.firstSupply);
            _loc_2.setValue("sw", this.secondWeapon);
            _loc_2.setValue("sc", this.secondCharger);
            _loc_2.setValue("ss", this.secondSupply);
            _loc_2.setValue("ph", this.health);
            _loc_2.setValue("pa", this.armor);
            _loc_2.setValue("ak", this.aidKit);
            _loc_2.setValue("pc", this.coins);
            _loc_2.flush();
            return;
        }// end function

        public function isSecretFounded(param1:String) : Boolean
        {
            return this.secrets.indexOf(param1) > -1 ? (true) : (false);
        }// end function

        public function getTotalShots() : int
        {
            return this.pistolShots + this.shotgunShots + this.gunShots + this.grenadegunShots + this.machinegunShots;
        }// end function

        public function addAchievement(param1:uint) : void
        {
            var _loc_2:* = this.achievements.indexOf(param1);
            if (_loc_2 == -1)
            {
                this.achievements[this.achievements.length] = param1;
            }
            return;
        }// end function

        private function clearMissions() : void
        {
            this.missions.length = 0;
            var _loc_1:int = 0;
            while (_loc_1 < 10)
            {
                
                this.missions[this.missions.length] = {mission1:false, mission2:false, mission3:false};
                _loc_1++;
            }
            return;
        }// end function

        public function statisticKill(param1:uint) : void
        {
            switch(param1)
            {
                case Kind.GROUP_ROBOT:
                {
                    var _loc_2:String = this;
                    var _loc_3:* = this.robotsKilled + 1;
                    _loc_2.robotsKilled = _loc_3;
                    break;
                }
                case Kind.GROUP_SKELETON:
                {
                    var _loc_2:String = this;
                    var _loc_3:* = this.skeletonsKilled + 1;
                    _loc_2.skeletonsKilled = _loc_3;
                    break;
                }
                case Kind.GROUP_ZOMBIE:
                {
                    var _loc_2:String = this;
                    var _loc_3:* = this.zombiesKilled + 1;
                    _loc_2.zombiesKilled = _loc_3;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function missionComplete(param1:int, param2:int) : void
        {
            if (param1 >= 0 && param1 < this.missions.length)
            {
                switch(param2)
                {
                    case 0:
                    {
                        this.missions[param1].mission1 = true;
                        break;
                    }
                    case 1:
                    {
                        this.missions[param1].mission2 = true;
                        break;
                    }
                    case 2:
                    {
                        this.missions[param1].mission3 = true;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        public function load() : void
        {
            this.loadPref();
            this._tm.clear();
            this._tm.addInstantTask(this.loadMissions);
            this._tm.addInstantTask(this.loadAchievements);
            this._tm.addInstantTask(this.loadSecrets);
            this._tm.addInstantTask(this.loadStatistics);
            this._tm.addInstantTask(ZG.console.trace, ["Game progress loaded."]);
            return;
        }// end function

        public function getFavouriteWeapon() : int
        {
            var _loc_1:Array = [{num:this.pistolShots, kind:ShopBox.ITEM_PISTOL}, {num:this.shotgunShots, kind:ShopBox.ITEM_SHOTGUN}, {num:this.gunShots, kind:ShopBox.ITEM_GUN}, {num:this.grenadegunShots, kind:ShopBox.ITEM_GRENADEGUN}, {num:this.machinegunShots, kind:ShopBox.ITEM_MACHINEGUN}];
            _loc_1.sortOn("num", Array.DESCENDING | Array.NUMERIC);
            return _loc_1[0].kind;
        }// end function

        private function loadSecrets() : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_1:* = new Cookies(KEY_SECRETS, false);
            if (!_loc_1.isEmpty())
            {
                this.secrets.length = 0;
                _loc_2 = int(_loc_1.getValue("c"));
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    this.addSecret(_loc_1.getValue("s" + _loc_3.toString()).toString());
                    _loc_3++;
                }
                this._oldSecretsLength = this.secrets.length;
            }
            return;
        }// end function

    }
}
