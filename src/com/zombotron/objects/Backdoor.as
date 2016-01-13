package com.zombotron.objects
{
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;
    import flash.events.*;

    public class Backdoor extends BasicObject implements IActiveObject
    {
        public var delay:int = 0;
        private var _alias:String;
        private var _tm:TaskManager;
        private var _isAction:Boolean;
        public var enemyCount2:int = 0;
        public var enemyCount1:int = 0;
        public var enemyKind1:String = "none";
        public var enemyKind2:String = "none";
        public var enemyKind3:String = "none";
        public var enemyCount3:int = 0;
        public static const CACHE_NAME:String = "Backdoor";

        public function Backdoor()
        {
            this.delay = 0;
            this.alias = "";
            this._isAction = false;
            this._tm = new TaskManager();
            _kind = Kind.BACK_DOOR1;
            _sprite = $.animCache.getAnimation(Art.BACK_DOOR1);
            _layer = Universe.LAYER_BG_OBJECTS;
            return;
        }// end function

        private function completeAnimHandler(event:Event) : void
        {
            var _loc_2:int = 0;
            _sprite.removeEventListener(Event.COMPLETE, this.completeAnimHandler);
            this._tm.clear();
            _loc_2 = 0;
            while (_loc_2 < this.enemyCount1)
            {
                
                this._tm.addTask(this.doMakeEnemy, [this.enemyKind1]);
                this._tm.addPause(35);
                _loc_2++;
            }
            _loc_2 = 0;
            while (_loc_2 < this.enemyCount2)
            {
                
                this._tm.addTask(this.doMakeEnemy, [this.enemyKind2]);
                this._tm.addPause(35);
                _loc_2++;
            }
            _loc_2 = 0;
            while (_loc_2 < this.enemyCount3)
            {
                
                this._tm.addTask(this.doMakeEnemy, [this.enemyKind3]);
                this._tm.addPause(35);
                _loc_2++;
            }
            return;
        }// end function

        public function changeState() : void
        {
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.objects.remove(this);
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                super.free();
            }
            return;
        }// end function

        public function get activateDistance() : int
        {
            return -1;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            _sprite.gotoAndStop(1);
            addChild(_sprite);
            this.x = param1;
            this.y = param2;
            reset();
            this._isAction = false;
            show();
            _universe.objects.add(this);
            return;
        }// end function

        private function doMakeEnemy(param1:String) : Boolean
        {
            var _loc_2:EnemyZombie = null;
            var _loc_3:EnemyZombieBomb = null;
            var _loc_4:EnemyZombieArmor = null;
            switch(param1)
            {
                case "zombie":
                {
                    _loc_2 = EnemyZombie.get();
                    _loc_2.fadeEff();
                    _loc_2.init(this.x, this.y + 10);
                    break;
                }
                case "zombieBomb":
                {
                    _loc_3 = EnemyZombieBomb.get();
                    _loc_3.fadeEff();
                    _loc_3.init(this.x, this.y + 10);
                    break;
                }
                case "zombieArmor":
                {
                    _loc_4 = EnemyZombieArmor.get();
                    _loc_4.fadeEff();
                    _loc_4.init(this.x, this.y + 10);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return true;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector();
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        override public function set kind(param1:uint) : void
        {
            if (_kind != param1)
            {
                _kind = param1;
                switch(_kind)
                {
                    case Kind.BACK_DOOR1:
                    {
                        _sprite = $.animCache.getAnimation(Art.BACK_DOOR1);
                        break;
                    }
                    case Kind.BACK_DOOR2:
                    {
                        _sprite = $.animCache.getAnimation(Art.BACK_DOOR2);
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

        override public function process() : void
        {
            _tileX = this.x / LevelBase.TILE_SIZE;
            _tileY = this.y / LevelBase.TILE_SIZE;
            if (_tileX >= _universe.level.tileX1 && _tileX < _universe.level.tileX2 && _tileY >= _universe.level.tileY1 && _tileY < _universe.level.tileY2)
            {
                show();
            }
            else
            {
                hide();
            }
            return;
        }// end function

        public function get alias() : String
        {
            return this._alias;
        }// end function

        private function doOpen() : Boolean
        {
            _sprite.addEventListener(Event.COMPLETE, this.completeAnimHandler);
            _sprite.repeat = false;
            _sprite.play();
            switch(_kind)
            {
                case Kind.BACK_DOOR1:
                {
                    ZG.sound(SoundManager.BACKDOOR1_OPEN, this, true);
                    break;
                }
                case Kind.BACK_DOOR2:
                {
                    ZG.sound(SoundManager.BACKDOOR2_OPEN, this, true);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return true;
        }// end function

        public function action(param1:Function = null) : void
        {
            if (!this._isAction)
            {
                if (this.delay > 0)
                {
                    this._tm.addPause(this.delay);
                    this._tm.addTask(this.doOpen);
                }
                else
                {
                    this.doOpen();
                }
                this._isAction = true;
            }
            return;
        }// end function

        public static function get() : Backdoor
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as Backdoor;
        }// end function

    }
}
