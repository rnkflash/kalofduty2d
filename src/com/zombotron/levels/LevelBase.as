package com.zombotron.levels
{
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.events.*;
    import com.antkarlov.math.*;
    import com.antkarlov.repositories.*;
    import com.zombotron.core.*;
    import com.zombotron.helpers.*;
    import com.zombotron.objects.*;
    import flash.display.*;
    import flash.geom.*;

    public class LevelBase extends Sprite
    {
        protected var _container:MovieClip;
        public var tileX1:int;
        public var tileX2:int;
        private var _actionList:Array;
        private var _tileHeight:int;
        private var _objectList:Array;
        protected var $:Global;
        public var tileY1:int;
        public var tileY2:int;
        protected var _universe:Universe;
        private var _respawnPoints:Array;
        private var _isLevelCreated:Boolean;
        private var _tileWidth:int;
        private var _storage:Array;
        private var _height:Number;
        private var _width:Number;
        private var _jointList:Array;
        protected var _background:MovieClip;
        private var _worldBody:b2Body;
        public var levelNum:int = -1;
        private var _bitmaps:Array;
        private var _respawnAlias:String;
        private static const CLIP_JOINT_STATIC:String = "joint_static";
        private static const CLIP_JOINT_WEAK:String = "joint_weak";
        public static const MISSION_COIN:uint = 11;
        private static const CLIP_CONNECT_PLACE_SPHERE:String = "connect_place_sphere";
        private static const CLIP_JOINT_BASIC:String = "joint_basic";
        private static const JOINT_STRONG:uint = 3;
        public static const MISSION_SILENT:uint = 19;
        private static const CLIP_BAG:String = "bag";
        public static const MISSION_BAG:uint = 1;
        private static const CLIP_JOINT_TRAILER:String = "joint_trailer";
        private static const CLIP_JOINT_STRONG:String = "joint_strong";
        private static const CLIP_SPHERE:String = "sphere";
        private static const CLIP_BOX_SMALL:String = "box_small";
        private static const CLIP_CONNECT_PLACE:String = "connect_place";
        private static const JOINT_BASIC:uint = 1;
        private static const CLIP_BARREL_EXPLOSION:String = "barrel_explosion";
        private static const JOINT_WEAK:uint = 4;
        private static const CLIP_ROPE:String = "rope";
        private static const CLIP_CART:String = "cart";
        private static const CLIP_TRAILER:String = "trailer";
        public static const MISSION_ROBOT:uint = 15;
        private static const CLIP_BOX:String = "box";
        private static const JOINT_TRAILER:uint = 5;
        private static const CLIP_PLAYER:String = "player";
        public static const MISSION_SKELETON:uint = 21;
        private static const CLIP_HOOK:String = "hook";
        public static const MISSION_MEGAKILL:uint = 13;
        public static const MISSION_TIME:uint = 23;
        private static const CLIP_SCREEN_FRAME:String = "screen_frame";
        public static const MISSION_CHEST:uint = 9;
        public static const MISSION_SHOPING:uint = 17;
        public static const MISSION_BOX:uint = 7;
        public static const MISSION_BARREL:uint = 3;
        public static const MISSION_BOOM:uint = 5;
        private static const CLIP_BRIDGE:String = "bridge";
        public static const MISSION_ZOMBIE:uint = 25;
        private static const JOINT_STATIC:uint = 2;
        public static const TILE_SIZE:int = 172;
        private static const CLIP_ZOMBIE:String = "zombie";
        private static const CLIP_BARREL:String = "barrel";
        private static const CLIP_WOOD_PLANK:String = "wood";

        public function LevelBase()
        {
            var _loc_1:int = 0;
            this.tileY1 = 0;
            this.tileX1 = _loc_1;
            var _loc_1:int = 0;
            this.tileY2 = 0;
            this.tileX2 = _loc_1;
            this.$ = Global.getInstance();
            this._universe = Universe.getInstance();
            this._container = null;
            this._background = null;
            this._tileWidth = 14;
            this._tileHeight = 8;
            this._width = 0;
            this._height = 0;
            this._jointList = [];
            this._objectList = [];
            this._actionList = [];
            this._respawnPoints = [];
            this._respawnAlias = "";
            this._isLevelCreated = false;
            return;
        }// end function

        public function removeBitmaps() : void
        {
            var _loc_1:uint = 0;
            var _loc_2:uint = 0;
            if (this._isLevelCreated)
            {
                _loc_1 = 0;
                while (_loc_1 < this._tileHeight)
                {
                    
                    _loc_2 = 0;
                    while (_loc_2 < this._tileWidth)
                    {
                        
                        if (this._bitmaps[_loc_1][_loc_2].visible)
                        {
                            this._bitmaps[_loc_1][_loc_2].visible = false;
                            this._universe.remove(this._bitmaps[_loc_1][_loc_2].frontBitmap, Universe.LAYER_FG);
                            this._universe.remove(this._bitmaps[_loc_1][_loc_2].backBitmap, Universe.LAYER_BG);
                        }
                        _loc_2 = _loc_2 + 1;
                    }
                    _loc_1 = _loc_1 + 1;
                }
            }
            return;
        }// end function

        private function makeObjectFromClip(param1:Sprite) : Boolean
        {
            var _loc_2:Boolean = true;
            var _loc_3:* = param1.x / TILE_SIZE;
            var _loc_4:* = param1.y / TILE_SIZE;
            var _loc_5:* = param1.name;
            var _loc_6:String = "";
            if (param1.name.indexOf(CLIP_WOOD_PLANK) > -1)
            {
                _loc_6 = _loc_5.substr(4, 1);
                _loc_5 = CLIP_WOOD_PLANK;
            }
            if (param1.name.indexOf(CLIP_TRAILER) > -1)
            {
                _loc_6 = _loc_5.substr(7, 1);
                _loc_5 = CLIP_TRAILER;
            }
            switch(_loc_5)
            {
                case CLIP_BOX:
                {
                    this.addToStorage(_loc_3, _loc_4, Kind.BOX, param1);
                    break;
                }
                case CLIP_BOX_SMALL:
                {
                    this.addToStorage(_loc_3, _loc_4, Kind.BOX_SMALL, param1);
                    break;
                }
                case CLIP_BARREL:
                {
                    this.addToStorage(_loc_3, _loc_4, Kind.BARREL, param1);
                    break;
                }
                case CLIP_BARREL_EXPLOSION:
                {
                    this.addToStorage(_loc_3, _loc_4, Kind.BARREL_EXPLOSION, param1);
                    break;
                }
                case CLIP_CART:
                {
                    this.addToStorage(_loc_3, _loc_4, Kind.CART, param1);
                    break;
                }
                case CLIP_WOOD_PLANK:
                {
                    this.addToStorage(_loc_3, _loc_4, Kind.WOOD_PLANK, param1, {variety:int(_loc_6)}, true);
                    break;
                }
                case CLIP_BRIDGE:
                {
                    this.addToStorage(_loc_3, _loc_4, Kind.BRIDGE, param1, {}, true);
                    break;
                }
                case CLIP_TRAILER:
                {
                    this.addToStorage(_loc_3, _loc_4, Kind.TRAILER, param1, {variety:int(_loc_6)}, true);
                    break;
                }
                case CLIP_HOOK:
                {
                    this.addToStorage(_loc_3, _loc_4, Kind.HOOK, param1, {}, true);
                    break;
                }
                case CLIP_ROPE:
                {
                    this.addToStorage(_loc_3, _loc_4, Kind.ROPE, param1, {}, true);
                    break;
                }
                case CLIP_BAG:
                {
                    this.addToStorage(_loc_3, _loc_4, Kind.BAG, param1, {}, true);
                    break;
                }
                default:
                {
                    _loc_2 = false;
                    break;
                    break;
                }
            }
            return _loc_2;
        }// end function

        private function clearBitmaps() : void
        {
            var _loc_1:Array = null;
            var _loc_3:int = 0;
            this.removeBitmaps();
            this._bitmaps = [];
            var _loc_2:int = 0;
            while (_loc_2 < this._tileHeight)
            {
                
                _loc_1 = [];
                _loc_3 = 0;
                while (_loc_3 < this._tileWidth)
                {
                    
                    _loc_1[_loc_1.length] = {frontBitmap:null, visible:false};
                    _loc_3++;
                }
                this._bitmaps[this._bitmaps.length] = _loc_1;
                _loc_2++;
            }
            this._isLevelCreated = false;
            return;
        }// end function

        public function updatePosition(param1:Number, param2:Number, param3:Boolean = false) : void
        {
            var _loc_4:Object = null;
            var _loc_6:int = 0;
            this.tileX1 = Math.abs(param1) / TILE_SIZE;
            this.tileY1 = Math.abs(param2) / TILE_SIZE;
            this.tileX2 = (Math.abs(param1) + App.SCR_W + TILE_SIZE * 2) / TILE_SIZE;
            this.tileY2 = (Math.abs(param2) + App.SCR_H + TILE_SIZE * 2) / TILE_SIZE;
            var _loc_5:* = this.tileY1 - 1;
            while (_loc_5 < (this.tileY2 + 1))
            {
                
                _loc_6 = this.tileX1 - 1;
                while (_loc_6 < (this.tileX2 + 1))
                {
                    
                    if (_loc_6 >= 0 && _loc_6 < this._tileWidth && _loc_5 >= 0 && _loc_5 < this._tileHeight)
                    {
                        _loc_4 = this._bitmaps[_loc_5][_loc_6];
                        if (_loc_6 < this.tileX1 || _loc_6 == this.tileX2 || _loc_5 < this.tileY1 || _loc_5 == this.tileY2)
                        {
                            if (_loc_4.visible)
                            {
                                _loc_4.visible = false;
                                this._universe.remove(_loc_4.frontBitmap, Universe.LAYER_FG);
                                this._universe.remove(_loc_4.backBitmap, Universe.LAYER_BG);
                            }
                        }
                        else
                        {
                            if (!_loc_4.visible)
                            {
                                _loc_4.visible = true;
                                this._universe.add(_loc_4.frontBitmap, Universe.LAYER_FG);
                                this._universe.add(_loc_4.backBitmap, Universe.LAYER_BG);
                            }
                            if (!this._storage[_loc_5][_loc_6].created)
                            {
                                this.makeFromStorage(_loc_6, _loc_5);
                            }
                        }
                    }
                    _loc_6++;
                }
                _loc_5++;
            }
            return;
        }// end function

        public function set respawnAlias(param1:String) : void
        {
            this._respawnAlias = param1;
            return;
        }// end function

        protected function makeCacheQuick() : void
        {
            var _loc_1:Sprite = null;
            var _loc_4:BitmapData = null;
            var _loc_5:Bitmap = null;
            var _loc_6:Bitmap = null;
            var _loc_7:Rectangle = null;
            var _loc_8:Matrix = null;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_9:* = this._container.numChildren;
            var _loc_10:int = 0;
            while (_loc_10 < _loc_9)
            {
                
                if (this._container.getChildAt(_loc_10) is Sprite && (this._container.getChildAt(_loc_10) as Sprite).name == CLIP_SCREEN_FRAME)
                {
                    _loc_1 = this._container.getChildAt(_loc_10) as Sprite;
                    _loc_2 = Math.round(_loc_1.x / TILE_SIZE);
                    _loc_3 = Math.round(_loc_1.y / TILE_SIZE);
                    _loc_7 = new Rectangle(_loc_1.x, _loc_1.y, _loc_1.width, _loc_1.height);
                    _loc_1.visible = false;
                    _loc_4 = new BitmapData(_loc_7.width, _loc_7.height, true, 0);
                    _loc_8 = new Matrix();
                    _loc_8.translate(-_loc_7.x, -_loc_7.y);
                    _loc_4.draw(this._container, _loc_8);
                    _loc_5 = new Bitmap();
                    _loc_5.bitmapData = _loc_4;
                    _loc_5.x = _loc_1.x;
                    _loc_5.y = _loc_1.y;
                    _loc_4 = new BitmapData(_loc_7.width, _loc_7.height, true, 0);
                    _loc_8 = new Matrix();
                    _loc_8.translate(-_loc_7.x, -_loc_7.y);
                    _loc_4.draw(this._background, _loc_8);
                    _loc_6 = new Bitmap();
                    _loc_6.bitmapData = _loc_4;
                    _loc_6.x = _loc_1.x;
                    _loc_6.y = _loc_1.y;
                    if (_loc_2 >= 0 && _loc_3 >= 0 && _loc_2 < this._tileWidth && _loc_3 < this._tileHeight)
                    {
                        this._bitmaps[_loc_3][_loc_2] = {frontBitmap:_loc_5, backBitmap:_loc_6, visible:false};
                    }
                }
                _loc_10++;
            }
            dispatchEvent(new ProcessEvent(ProcessEvent.COMPLETE));
            return;
        }// end function

        private function makeFromStorage(param1:int, param2:int) : void
        {
            var _loc_3:Object = null;
            var _loc_4:* = this._storage[param2][param1];
            var _loc_5:* = _loc_4.list.length;
            var _loc_6:int = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_3 = _loc_4.list[_loc_6];
                this.makeObject(_loc_3);
                _loc_6++;
            }
            _loc_4.created = true;
            return;
        }// end function

        override public function get height() : Number
        {
            return this._height;
        }// end function

        private function makeObjectFromComponent(param1:Sprite) : Boolean
        {
            var _loc_3:Object = null;
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            var _loc_2:Boolean = true;
            var _loc_6:* = param1.x / TILE_SIZE;
            var _loc_7:* = param1.y / TILE_SIZE;
            if (param1 is Player_com)
            {
                _loc_3 = param1 as Player_com;
                this._respawnPoints[this._respawnPoints.length] = {alias:_loc_3.alias, x:param1.x, y:param1.y};
            }
            else if (param1 is EnemyZombie_com)
            {
                _loc_3 = param1 as EnemyZombie_com;
                if (ZG.hardcoreMode || !ZG.hardcoreMode && ZG.hardcoreMode == Boolean(_loc_3.hardcore))
                {
                    _loc_4 = {enableLimit:_loc_3.enableLimit, lowerLimit:_loc_3.lowerLimit, upperLimit:_loc_3.upperLimit};
                    this.addToStorage(_loc_6, _loc_7, Kind.ENEMY_ZOMBIE, param1, _loc_4);
                }
            }
            else if (param1 is EnemyZombieBomb_com)
            {
                _loc_3 = param1 as EnemyZombieBomb_com;
                _loc_4 = {enableLimit:_loc_3.enableLimit, lowerLimit:_loc_3.lowerLimit, upperLimit:_loc_3.upperLimit};
                this.addToStorage(_loc_6, _loc_7, Kind.ENEMY_ZOMBIE_BOMB, param1, _loc_4);
            }
            else if (param1 is EnemyZombieArmor_com)
            {
                _loc_3 = param1 as EnemyZombieArmor_com;
                _loc_4 = {enableLimit:_loc_3.enableLimit, lowerLimit:_loc_3.lowerLimit, upperLimit:_loc_3.upperLimit};
                this.addToStorage(_loc_6, _loc_7, Kind.ENEMY_ZOMBIE_ARMOR, param1, _loc_4);
            }
            else if (param1 is EnemyTurret_com)
            {
                _loc_3 = param1 as EnemyTurret_com;
                _loc_4 = {alias:_loc_3.alias, dir:_loc_3.dir};
                this.addToStorage(_loc_6, _loc_7, Kind.ENEMY_TURRET, param1, _loc_4);
            }
            else if (param1 is EnemyRobotSpade_com)
            {
                _loc_3 = param1 as EnemyRobotSpade_com;
                _loc_4 = {enableLimit:_loc_3.enableLimit, lowerLimit:_loc_3.lowerLimit, upperLimit:_loc_3.upperLimit, hardcore:_loc_3.hardcore};
                this.addToStorage(_loc_6, _loc_7, Kind.ENEMY_ROBOT_SPADE, param1, _loc_4);
            }
            else if (param1 is EnemyRobotPick_com)
            {
                _loc_3 = param1 as EnemyRobotPick_com;
                _loc_4 = {enableLimit:_loc_3.enableLimit, lowerLimit:_loc_3.lowerLimit, upperLimit:_loc_3.upperLimit};
                this.addToStorage(_loc_6, _loc_7, Kind.ENEMY_ROBOT_PICK, param1, _loc_4);
            }
            else if (param1 is Door_com)
            {
                _loc_3 = param1 as Door_com;
                _loc_4 = {alias:_loc_3.alias, isOpen:_loc_3.isOpen, callbackAlias:_loc_3.callbackAlias};
                this.addToStorage(_loc_6, _loc_7, Kind.DOOR, param1, _loc_4);
                _loc_2 = false;
            }
            else if (param1 is Backdoor1_com)
            {
                _loc_3 = param1 as Backdoor1_com;
                _loc_4 = {alias:_loc_3.alias, delay:_loc_3.delay, enemyKind1:_loc_3.enemyKind1, enemyCount1:_loc_3.enemyCount1, enemyKind2:_loc_3.enemyKind2, enemyCount2:_loc_3.enemyCount2, enemyKind3:_loc_3.enemyKind3, enemyCount3:_loc_3.enemyCount3};
                this.addToStorage(_loc_6, _loc_7, Kind.BACK_DOOR1, param1, _loc_4);
            }
            else if (param1 is Backdoor2_com)
            {
                _loc_3 = param1 as Backdoor2_com;
                _loc_4 = {alias:_loc_3.alias, delay:_loc_3.delay, enemyKind1:_loc_3.enemyKind1, enemyCount1:_loc_3.enemyCount1, enemyKind2:_loc_3.enemyKind2, enemyCount2:_loc_3.enemyCount2, enemyKind3:_loc_3.enemyKind3, enemyCount3:_loc_3.enemyCount3};
                this.addToStorage(_loc_6, _loc_7, Kind.BACK_DOOR2, param1, _loc_4);
            }
            else if (param1 is Button_com)
            {
                _loc_3 = param1 as Button_com;
                _loc_4 = {alias:_loc_3.alias, isPushed:_loc_3.isPushed, targetAlias:_loc_3.targetAlias};
                this.addToStorage(_loc_6, _loc_7, Kind.BUTTON, param1, _loc_4);
            }
            else if (param1 is VerticalElevator_com)
            {
                _loc_3 = param1 as VerticalElevator_com;
                _loc_4 = {alias:_loc_3.alias, upperLimit:_loc_3.upperLimit, lowerLimit:_loc_3.lowerLimit, curDir:_loc_3.curDir, callbackAlias:_loc_3.callbackAlias};
                this.addToStorage(_loc_6, _loc_7, Kind.VERTICAL_ELEVATOR, param1, _loc_4);
            }
            else if (param1 is HorizontalElevator_com)
            {
                _loc_3 = param1 as HorizontalElevator_com;
                _loc_4 = {alias:_loc_3.alias, curDir:_loc_3.curDir, lowerLimit:_loc_3.lowerLimit, upperLimit:_loc_3.upperLimit, callbackAlias:_loc_3.callbackAlias};
                this.addToStorage(_loc_6, _loc_7, Kind.HORIZONTAL_ELEVATOR, param1, _loc_4);
            }
            else if (param1 is VelevatorControl_com)
            {
                _loc_3 = param1 as VelevatorControl_com;
                _loc_4 = {alias:_loc_3.alias, targetAlias:_loc_3.targetAlias, curDir:_loc_3.curDir};
                this.addToStorage(_loc_6, _loc_7, Kind.VERTICAL_CONTROL, param1, _loc_4);
            }
            else if (param1 is HelevatorControl_com)
            {
                _loc_3 = param1 as HelevatorControl_com;
                _loc_4 = {alias:_loc_3.alias, targetAlias:_loc_3.targetAlias, curDir:_loc_3.curDir};
                this.addToStorage(_loc_6, _loc_7, Kind.HORIZONTAL_CONTROL, param1, _loc_4);
            }
            else if (param1 is ChainTriggerElectro_com)
            {
                _loc_3 = param1 as ChainTriggerElectro_com;
                _loc_4 = {alias:_loc_3.alias, targetAlias:_loc_3.targetAlias, delay:_loc_3.delay};
                _loc_5 = {kind:Kind.TRIGGER_ELECTRO, x:param1.x, y:param1.y, rotation:param1.rotation, attr:_loc_4};
                this.makeObject(_loc_5);
            }
            else if (param1 is Trigger_com)
            {
                _loc_3 = param1 as Trigger_com;
                _loc_4 = {alias:_loc_3.alias, targetAlias:_loc_3.targetAlias, targetArea:_loc_3.targetArea, completeMission:_loc_3.completeMission};
                this.addToStorage(_loc_6, _loc_7, Kind.TRIGGER_SENSOR, param1, _loc_4);
            }
            else if (param1 is Killer_com)
            {
                _loc_3 = param1 as Killer_com;
                _loc_4 = {alias:_loc_3.alias};
                this.addToStorage(_loc_6, _loc_7, Kind.TRIGGER_KILL, param1, _loc_4);
            }
            else if (param1 is CreateArea_com)
            {
                _loc_3 = param1 as CreateArea_com;
                _loc_4 = {alias:_loc_3.alias, delay:_loc_3.delay};
                _loc_5 = {kind:Kind.CREATE_AREA, x:param1.x, y:param1.y, width:param1.width, height:param1.height, attr:_loc_4};
                this.makeObject(_loc_5);
            }
            else if (param1 is DestroyArea_com)
            {
                _loc_3 = param1 as DestroyArea_com;
                _loc_4 = {alias:_loc_3.alias, delay:_loc_3.delay};
                _loc_5 = {kind:Kind.DESTROY_AREA, x:param1.x, y:param1.y, width:param1.width, height:param1.height, attr:_loc_4};
                this.makeObject(_loc_5);
            }
            else if (param1 is Exit_com)
            {
                _loc_3 = param1 as Exit_com;
                _loc_4 = {alias:_loc_3.alias, nextLevel:_loc_3.nextLevel, nextEntry:_loc_3.nextEntry};
                _loc_5 = {kind:Kind.TRIGGER_EXIT, x:param1.x, y:param1.y, width:param1.width, height:param1.height, attr:_loc_4};
                this.makeObject(_loc_5);
            }
            else if (param1 is Music_com)
            {
                _loc_3 = param1 as Music_com;
                _loc_4 = {alias:_loc_3.alias, musicTrack:_loc_3.musicTrack, forceSwitch:_loc_3.forceSwitch, loops:_loc_3.loops};
                this.addToStorage(_loc_6, _loc_7, Kind.TRIGGER_MUSIC, param1, _loc_4);
            }
            else if (param1 is BulletTrigger_com)
            {
                _loc_3 = param1 as BulletTrigger_com;
                _loc_4 = {alias:_loc_3.alias, targetAlias:_loc_3.targetAlias};
                this.addToStorage(_loc_6, _loc_7, Kind.TRIGGER_BULLET, param1, _loc_4);
            }
            else if (param1 is ShopTerminal_com)
            {
                _loc_3 = param1 as ShopTerminal_com;
                _loc_4 = {alias:_loc_3.alias, targetAlias:_loc_3.targetAlias, terminalNum:_loc_3.terminalNum, itemName1:_loc_3.itemName1, itemQuantity1:_loc_3.itemQuantity1, itemPrice1:_loc_3.itemPrice1, itemName2:_loc_3.itemName2, itemQuantity2:_loc_3.itemQuantity2, itemPrice2:_loc_3.itemPrice2, itemName3:_loc_3.itemName3, itemQuantity3:_loc_3.itemQuantity3, itemPrice3:_loc_3.itemPrice3, itemName4:_loc_3.itemName4, itemQuantity4:_loc_3.itemQuantity4, itemPrice4:_loc_3.itemPrice4};
                _loc_5 = {kind:Kind.SHOP_TERMINAL, x:param1.x, y:param1.y, width:param1.width, height:param1.height, attr:_loc_4};
                this.makeObject(_loc_5);
            }
            else if (param1 is ShopStorage_com)
            {
                _loc_3 = param1 as ShopStorage_com;
                _loc_4 = {alias:_loc_3.alias, callbackAlias:_loc_3.callbackAlias};
                this.addToStorage(_loc_6, _loc_7, Kind.SHOP_STORAGE, param1, _loc_4);
                _loc_2 = false;
            }
            else if (param1 is Chest_com)
            {
                _loc_3 = param1 as Chest_com;
                _loc_4 = {alias:_loc_3.alias, targetAlias:_loc_3.targetAlias, variety:_loc_3.variety, itemName1:_loc_3.itemName1, itemQuantity1:_loc_3.itemQuantity1, itemName2:_loc_3.itemName2, itemQuantity2:_loc_3.itemQuantity2, itemName3:_loc_3.itemName3, itemQuantity3:_loc_3.itemQuantity3, itemName4:_loc_3.itemName4, itemQuantity4:_loc_3.itemQuantity4};
                this.addToStorage(_loc_6, _loc_7, Kind.CHEST, param1, _loc_4);
            }
            else if (param1 is Insects_com)
            {
                _loc_3 = param1 as Insects_com;
                _loc_4 = {alias:_loc_3.alias, numInsects:_loc_3.numInsects, color:_loc_3.color};
                this.addToStorage(_loc_6, _loc_7, Kind.INSECTS, param1, _loc_4);
            }
            else if (param1 is Truck_com)
            {
                _loc_3 = param1 as Truck_com;
                _loc_4 = {alias:_loc_3.alias, curDir:_loc_3.curDir, enableLimit:_loc_3.enableLimit, lowerLimit:_loc_3.lowerLimit, upperLimit:_loc_3.upperLimit};
                this.addToStorage(_loc_6, _loc_7, Kind.TRUCK, param1, _loc_4, true);
            }
            else if (param1 is EnemySkeletonBasic_com)
            {
                _loc_3 = param1 as EnemySkeletonBasic_com;
                _loc_4 = {enableLimit:_loc_3.enableLimit, lowerLimit:_loc_3.lowerLimit, upperLimit:_loc_3.upperLimit, variety:EnemySkeleton.SKELETON_BASIC};
                this.addToStorage(_loc_6, _loc_7, Kind.ENEMY_SKELETON, param1, _loc_4);
            }
            else if (param1 is EnemySkeletonHelmet_com)
            {
                _loc_3 = param1 as EnemySkeletonHelmet_com;
                _loc_4 = {enableLimit:_loc_3.enableLimit, lowerLimit:_loc_3.lowerLimit, upperLimit:_loc_3.upperLimit, variety:EnemySkeleton.SKELETON_HELMET};
                this.addToStorage(_loc_6, _loc_7, Kind.ENEMY_SKELETON, param1, _loc_4);
            }
            else if (param1 is EnemySkeletonSheild_com)
            {
                _loc_3 = param1 as EnemySkeletonSheild_com;
                _loc_4 = {enableLimit:_loc_3.enableLimit, lowerLimit:_loc_3.lowerLimit, upperLimit:_loc_3.upperLimit, variety:EnemySkeleton.SKELETON_SHEILD};
                this.addToStorage(_loc_6, _loc_7, Kind.ENEMY_SKELETON, param1, _loc_4);
            }
            else if (param1 is EnemySkeletonArmor_com)
            {
                _loc_3 = param1 as EnemySkeletonArmor_com;
                _loc_4 = {enableLimit:_loc_3.enableLimit, lowerLimit:_loc_3.lowerLimit, upperLimit:_loc_3.upperLimit, variety:EnemySkeleton.SKELETON_ARMOR};
                this.addToStorage(_loc_6, _loc_7, Kind.ENEMY_SKELETON, param1, _loc_4);
            }
            else if (param1 is Respawn_com)
            {
                _loc_3 = param1 as Respawn_com;
                _loc_4 = {alias:_loc_3.alias, targetAlias:_loc_3.targetAlias};
                this.addToStorage(_loc_6, _loc_7, Kind.CHECKPOINT, param1, _loc_4);
            }
            else if (param1 is SupplyChest_com)
            {
                _loc_3 = param1 as SupplyChest_com;
                _loc_4 = {alias:_loc_3.alias};
                this.addToStorage(_loc_6, _loc_7, Kind.SUPPLY_CHEST, param1, _loc_4);
            }
            else if (param1 is ItemDrop_com)
            {
                _loc_3 = param1 as ItemDrop_com;
                _loc_4 = {alias:_loc_3.alias, itemKind:_loc_3.itemKind, probability:_loc_3.probability};
                this.addToStorage(_loc_6, _loc_7, Kind.ITEM_DROP, param1, _loc_4);
            }
            else if (param1 is Boss_com)
            {
                _loc_3 = param1 as Boss_com;
                _loc_4 = {alias:_loc_3.alias, callbackJump:_loc_3.callbackJump, callbackDie:_loc_3.callbackDie};
                this.addToStorage(_loc_6, _loc_7, Kind.ENEMY_BOSS, param1, _loc_4);
            }
            else
            {
                _loc_2 = false;
            }
            return _loc_2;
        }// end function

        private function makeJoint(param1:uint, param2:Avector, param3:b2Body, param4:b2Body) : b2RevoluteJoint
        {
            var _loc_6:b2RevoluteJoint = null;
            var _loc_5:* = new b2RevoluteJointDef();
            var _loc_7:* = new b2Vec2(param2.x / Universe.DRAW_SCALE, param2.y / Universe.DRAW_SCALE);
            var _loc_8:int = 0;
            switch(param1)
            {
                case JOINT_BASIC:
                {
                    _loc_8 = 350;
                    break;
                }
                case JOINT_STATIC:
                {
                    _loc_5.enableLimit = true;
                    _loc_8 = 350;
                    break;
                }
                case JOINT_STRONG:
                {
                    _loc_8 = 0;
                    break;
                }
                case JOINT_WEAK:
                {
                    _loc_8 = 50;
                    break;
                }
                case JOINT_TRAILER:
                {
                    _loc_8 = 100;
                    _loc_5.lowerAngle = -0.25 * Math.PI;
                    _loc_5.upperAngle = 0.25 * Math.PI;
                    _loc_5.enableLimit = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_5.Initialize(param3, param4, _loc_7);
            _loc_6 = this._universe.physics.CreateJoint(_loc_5) as b2RevoluteJoint;
            if (_loc_8 > 0)
            {
                this._universe.joints.add(_loc_6, _loc_8);
            }
            return _loc_6;
        }// end function

        private function makeAction(param1:Object, param2:b2RevoluteJoint, param3:b2Body) : void
        {
            var _loc_4:* = new SomeAction();
            _loc_4.alias = param1.alias;
            _loc_4.delay = param1.delay;
            _loc_4.kind = param1.kind;
            _loc_4.variety = param1.variety;
            _loc_4.targetJoint = param2;
            _loc_4.targetBody = param3;
            _loc_4.init(param1.x, param1.y);
            if (param2 != null)
            {
                param2.m_userData = _loc_4;
            }
            return;
        }// end function

        private function makeObject(param1:Object) : void
        {
            var _loc_2:Box = null;
            var _loc_3:Barrel = null;
            var _loc_4:Barrel = null;
            var _loc_5:Cart = null;
            var _loc_6:EnemyZombie = null;
            var _loc_7:EnemyZombieBomb = null;
            var _loc_8:EnemyZombieArmor = null;
            var _loc_9:EnemyRobotSpade = null;
            var _loc_10:EnemyRobotPick = null;
            var _loc_11:EnemyTurret = null;
            var _loc_12:BasicDoor = null;
            var _loc_13:DoorButton = null;
            var _loc_14:VerticalElevator = null;
            var _loc_15:ElevatorCtrl = null;
            var _loc_16:ChainTriggerElectro = null;
            var _loc_17:Backdoor = null;
            var _loc_18:TriggerSensor = null;
            var _loc_19:TriggerSensor = null;
            var _loc_20:TriggerSensor = null;
            var _loc_21:SomeArea = null;
            var _loc_22:TriggerSensor = null;
            var _loc_23:TriggerBullet = null;
            var _loc_24:HorizontalElevator = null;
            var _loc_25:WoodPlank = null;
            var _loc_26:Bridge = null;
            var _loc_27:Trailer = null;
            var _loc_28:ShopTerminal = null;
            var _loc_29:ShopStorage = null;
            var _loc_30:Chest = null;
            var _loc_31:Insects = null;
            var _loc_32:Truck = null;
            var _loc_33:Hook = null;
            var _loc_34:EnemySkeleton = null;
            var _loc_35:Respawn = null;
            var _loc_36:SupplyChest = null;
            var _loc_37:ItemDrop = null;
            var _loc_38:Boss = null;
            var _loc_39:Bag = null;
            var _loc_40:Hook = null;
            switch(param1.kind)
            {
                case Kind.BOX:
                {
                    _loc_2 = Box.get();
                    _loc_2.init(param1.x, param1.y, param1.rotation);
                    break;
                }
                case Kind.BOX_SMALL:
                {
                    break;
                }
                case Kind.BARREL:
                {
                    _loc_3 = Barrel.get();
                    _loc_3.kind = Kind.BARREL;
                    _loc_3.init(param1.x, param1.y, param1.rotation);
                    break;
                }
                case Kind.BARREL_EXPLOSION:
                {
                    _loc_4 = Barrel.get();
                    _loc_4.kind = Kind.BARREL_EXPLOSION;
                    _loc_4.init(param1.x, param1.y, param1.rotation);
                    break;
                }
                case Kind.CART:
                {
                    _loc_5 = new Cart();
                    _loc_5.init(param1.x, param1.y, param1.rotation);
                    break;
                }
                case Kind.ENEMY_ZOMBIE:
                {
                    _loc_6 = EnemyZombie.get();
                    _loc_6.enableLimit = param1.attr.enableLimit;
                    _loc_6.lowerLimit = param1.attr.lowerLimit;
                    _loc_6.upperLimit = param1.attr.upperLimit;
                    _loc_6.init(param1.x, param1.y);
                    break;
                }
                case Kind.ENEMY_ZOMBIE_BOMB:
                {
                    _loc_7 = EnemyZombieBomb.get();
                    _loc_7.enableLimit = param1.attr.enableLimit;
                    _loc_7.lowerLimit = param1.attr.lowerLimit;
                    _loc_7.upperLimit = param1.attr.upperLimit;
                    _loc_7.init(param1.x, param1.y);
                    break;
                }
                case Kind.ENEMY_ZOMBIE_ARMOR:
                {
                    _loc_8 = EnemyZombieArmor.get();
                    _loc_8.enableLimit = param1.attr.enableLimit;
                    _loc_8.lowerLimit = param1.attr.lowerLimit;
                    _loc_8.upperLimit = param1.attr.upperLimit;
                    _loc_8.init(param1.x, param1.y);
                    break;
                }
                case Kind.ENEMY_ROBOT_SPADE:
                {
                    _loc_9 = EnemyRobotSpade.get();
                    _loc_9.enableLimit = param1.attr.enableLimit;
                    _loc_9.lowerLimit = param1.attr.lowerLimit;
                    _loc_9.upperLimit = param1.attr.upperLimit;
                    _loc_9.init(param1.x, param1.y);
                    break;
                }
                case Kind.ENEMY_ROBOT_PICK:
                {
                    _loc_10 = EnemyRobotPick.get();
                    _loc_10.enableLimit = param1.attr.enableLimit;
                    _loc_10.lowerLimit = param1.attr.lowerLimit;
                    _loc_10.upperLimit = param1.attr.upperLimit;
                    _loc_10.init(param1.x, param1.y);
                    break;
                }
                case Kind.ENEMY_TURRET:
                {
                    _loc_11 = new EnemyTurret();
                    _loc_11.alias = param1.attr.alias;
                    _loc_11.dir = param1.attr.dir;
                    _loc_11.init(param1.x, param1.y);
                    break;
                }
                case Kind.DOOR:
                {
                    _loc_12 = new BasicDoor();
                    _loc_12.isOpen = param1.attr.isOpen;
                    _loc_12.alias = param1.attr.alias;
                    _loc_12.callbackAlias = param1.attr.callbackAlias;
                    _loc_12.init(param1.x, param1.y);
                    break;
                }
                case Kind.BUTTON:
                {
                    _loc_13 = DoorButton.get();
                    _loc_13.isPushed = param1.attr.isPushed as Boolean;
                    _loc_13.alias = param1.attr.alias as String;
                    _loc_13.targetAlias = param1.attr.targetAlias as String;
                    _loc_13.init(param1.x, param1.y);
                    break;
                }
                case Kind.VERTICAL_ELEVATOR:
                {
                    _loc_14 = new VerticalElevator();
                    _loc_14.alias = param1.attr.alias;
                    _loc_14.upperLimit = param1.attr.upperLimit;
                    _loc_14.lowerLimit = param1.attr.lowerLimit;
                    _loc_14.dir = param1.attr.curDir;
                    _loc_14.callbackAlias = param1.attr.callbackAlias;
                    _loc_14.init(param1.x, param1.y);
                    break;
                }
                case Kind.VERTICAL_CONTROL:
                case Kind.HORIZONTAL_CONTROL:
                {
                    _loc_15 = new ElevatorCtrl();
                    _loc_15.kind = param1.kind;
                    _loc_15.alias = param1.attr.alias;
                    _loc_15.targetAlias = param1.attr.targetAlias;
                    _loc_15.dir = param1.attr.curDir;
                    _loc_15.init(param1.x, param1.y);
                    break;
                }
                case Kind.TRIGGER_ELECTRO:
                {
                    _loc_16 = new ChainTriggerElectro();
                    _loc_16.alias = param1.attr.alias;
                    _loc_16.targetAlias = param1.attr.targetAlias;
                    _loc_16.delay = param1.attr.delay;
                    _loc_16.init(param1.x, param1.y);
                    break;
                }
                case Kind.BACK_DOOR1:
                case Kind.BACK_DOOR2:
                {
                    _loc_17 = new Backdoor();
                    _loc_17.kind = param1.kind;
                    _loc_17.alias = param1.attr.alias;
                    _loc_17.delay = param1.attr.delay;
                    _loc_17.enemyKind1 = param1.attr.enemyKind1;
                    _loc_17.enemyCount1 = param1.attr.enemyCount1;
                    _loc_17.enemyKind2 = param1.attr.enemyKind2;
                    _loc_17.enemyCount2 = param1.attr.enemyCount2;
                    _loc_17.enemyKind3 = param1.attr.enemyKind3;
                    _loc_17.enemyCount3 = param1.attr.enemyCount3;
                    _loc_17.init(param1.x, param1.y);
                    break;
                }
                case Kind.TRIGGER_SENSOR:
                {
                    _loc_18 = new TriggerSensor();
                    _loc_18.bodyWidth = param1.width;
                    _loc_18.bodyHeight = param1.height;
                    _loc_18.alias = param1.attr.alias;
                    _loc_18.targetAlias = param1.attr.targetAlias;
                    _loc_18.targetArea = param1.attr.targetArea;
                    _loc_18.completeMission = param1.attr.completeMission;
                    _loc_18.init(param1.x, param1.y);
                    break;
                }
                case Kind.TRIGGER_KILL:
                {
                    _loc_19 = new TriggerSensor();
                    _loc_19.kind = param1.kind;
                    _loc_19.bodyWidth = param1.width;
                    _loc_19.bodyHeight = param1.height;
                    _loc_19.alias = param1.attr.alias;
                    _loc_19.init(param1.x, param1.y);
                    break;
                }
                case Kind.TRIGGER_MUSIC:
                {
                    _loc_20 = new TriggerSensor();
                    _loc_20.kind = param1.kind;
                    _loc_20.bodyWidth = param1.width;
                    _loc_20.bodyHeight = param1.height;
                    _loc_20.alias = param1.attr.alias;
                    _loc_20.musicTrack = param1.attr.musicTrack;
                    _loc_20.forceSwitch = param1.attr.forceSwitch;
                    _loc_20.loops = 999;
                    _loc_20.init(param1.x, param1.y);
                    break;
                }
                case Kind.CREATE_AREA:
                case Kind.DESTROY_AREA:
                {
                    _loc_21 = new SomeArea();
                    _loc_21.kind = param1.kind;
                    _loc_21.bodyWidth = param1.width;
                    _loc_21.bodyHeight = param1.height;
                    _loc_21.delay = param1.attr.delay;
                    _loc_21.alias = param1.attr.alias;
                    _loc_21.init(param1.x, param1.y);
                    break;
                }
                case Kind.TRIGGER_EXIT:
                {
                    _loc_22 = new TriggerSensor();
                    _loc_22.kind = param1.kind;
                    _loc_22.bodyWidth = param1.width;
                    _loc_22.bodyHeight = param1.height;
                    _loc_22.nextLevel = int(param1.attr.nextLevel);
                    _loc_22.nextEntry = param1.attr.nextEntry;
                    _loc_22.alias = param1.attr.alias;
                    _loc_22.init(param1.x, param1.y);
                    break;
                }
                case Kind.TRIGGER_BULLET:
                {
                    _loc_23 = new TriggerBullet();
                    _loc_23.bodyWidth = param1.width;
                    _loc_23.bodyHeight = param1.height;
                    _loc_23.alias = param1.attr.alias;
                    _loc_23.targetAlias = param1.attr.targetAlias;
                    _loc_23.init(param1.x, param1.y);
                    break;
                }
                case Kind.HORIZONTAL_ELEVATOR:
                {
                    _loc_24 = new HorizontalElevator();
                    _loc_24.alias = param1.attr.alias;
                    _loc_24.curDir = param1.attr.curDir;
                    _loc_24.lowerLimit = param1.attr.lowerLimit;
                    _loc_24.upperLimit = param1.attr.upperLimit;
                    _loc_24.callbackAlias = param1.attr.callbackAlias;
                    _loc_24.init(param1.x, param1.y);
                    break;
                }
                case Kind.WOOD_PLANK:
                {
                    _loc_25 = WoodPlank.get();
                    _loc_25.variety = param1.attr.variety;
                    _loc_25.init(param1.x, param1.y, param1.rotation);
                    if (param1.jointInd != -1)
                    {
                        this._objectList[param1.jointInd].body = _loc_25.body;
                    }
                    break;
                }
                case Kind.BRIDGE:
                {
                    _loc_26 = Bridge.get();
                    _loc_26.init(param1.x, param1.y, param1.rotation);
                    if (param1.jointInd != -1)
                    {
                        this._objectList[param1.jointInd].body = _loc_26.body;
                    }
                    break;
                }
                case Kind.TRAILER:
                {
                    _loc_27 = new Trailer();
                    _loc_27.variety = param1.attr.variety;
                    _loc_27.init(param1.x, param1.y);
                    if (param1.jointInd != -1)
                    {
                        this._objectList[param1.jointInd].body = _loc_27.body;
                    }
                    break;
                }
                case Kind.SHOP_TERMINAL:
                {
                    _loc_28 = new ShopTerminal();
                    _loc_28.alias = param1.attr.alias;
                    _loc_28.targetAlias = param1.attr.targetAlias;
                    _loc_28.terminalNum = param1.attr.terminalNum;
                    _loc_28.box.addItem(ShopBox.toKind(param1.attr.itemName1), param1.attr.itemQuantity1, param1.attr.itemPrice1);
                    _loc_28.box.addItem(ShopBox.toKind(param1.attr.itemName2), param1.attr.itemQuantity2, param1.attr.itemPrice2);
                    _loc_28.box.addItem(ShopBox.toKind(param1.attr.itemName3), param1.attr.itemQuantity3, param1.attr.itemPrice3);
                    _loc_28.box.addItem(ShopBox.toKind(param1.attr.itemName4), param1.attr.itemQuantity4, param1.attr.itemPrice4);
                    _loc_28.init(param1.x, param1.y);
                    break;
                }
                case Kind.SHOP_STORAGE:
                {
                    _loc_29 = new ShopStorage();
                    _loc_29.alias = param1.attr.alias;
                    _loc_29.callbackAlias = param1.attr.callbackAlias;
                    _loc_29.init(param1.x, param1.y);
                    break;
                }
                case Kind.CHEST:
                {
                    _loc_30 = Chest.get();
                    _loc_30.alias = param1.attr.alias;
                    _loc_30.targetAlias = param1.attr.targetAlias;
                    _loc_30.setVariety(param1.attr.variety);
                    _loc_30.clearContents();
                    _loc_30.addItem(ShopBox.toKind(param1.attr.itemName1), param1.attr.itemQuantity1);
                    _loc_30.addItem(ShopBox.toKind(param1.attr.itemName2), param1.attr.itemQuantity2);
                    _loc_30.addItem(ShopBox.toKind(param1.attr.itemName3), param1.attr.itemQuantity3);
                    _loc_30.addItem(ShopBox.toKind(param1.attr.itemName4), param1.attr.itemQuantity4);
                    _loc_30.init(param1.x, param1.y, param1.rotation);
                    break;
                }
                case Kind.INSECTS:
                {
                    _loc_31 = new Insects();
                    _loc_31.areaWidth = param1.width;
                    _loc_31.areaHeight = param1.height;
                    _loc_31.numInsects = param1.attr.numInsects;
                    _loc_31.color = param1.attr.color;
                    _loc_31.init(param1.x, param1.y);
                    break;
                }
                case Kind.TRUCK:
                {
                    _loc_32 = new Truck();
                    _loc_32.alias = param1.attr.alias;
                    _loc_32.dir = param1.attr.curDir;
                    _loc_32.enableLimit = param1.attr.enableLimit;
                    _loc_32.lowerLimit = param1.attr.lowerLimit;
                    _loc_32.upperLimit = param1.attr.upperLimit;
                    _loc_32.init(param1.x, param1.y);
                    if (param1.jointInd != -1)
                    {
                        this._objectList[param1.jointInd].body = _loc_32.body;
                    }
                    break;
                }
                case Kind.HOOK:
                {
                    _loc_33 = new Hook();
                    _loc_33.kind = Kind.HOOK;
                    _loc_33.init(param1.x, param1.y, param1.rotation);
                    if (param1.jointInd != -1)
                    {
                        this._objectList[param1.jointInd].body = _loc_33.body;
                    }
                    break;
                }
                case Kind.ENEMY_SKELETON:
                {
                    _loc_34 = EnemySkeleton.get();
                    _loc_34.enableLimit = param1.attr.enableLimit;
                    _loc_34.lowerLimit = param1.attr.lowerLimit;
                    _loc_34.upperLimit = param1.attr.upperLimit;
                    _loc_34.variety = param1.attr.variety;
                    _loc_34.init(param1.x, param1.y);
                    break;
                }
                case Kind.CHECKPOINT:
                {
                    _loc_35 = new Respawn();
                    _loc_35.alias = param1.attr.alias;
                    _loc_35.targetAlias = param1.attr.targetAlias;
                    _loc_35.init(param1.x, param1.y);
                    break;
                }
                case Kind.SUPPLY_CHEST:
                {
                    _loc_36 = new SupplyChest();
                    _loc_36.alias = param1.attr.alias;
                    _loc_36.init(param1.x, param1.y);
                    break;
                }
                case Kind.ITEM_DROP:
                {
                    _loc_37 = new ItemDrop();
                    _loc_37.alias = param1.attr.alias;
                    _loc_37.itemKind = param1.attr.itemKind;
                    _loc_37.probability = param1.attr.probability;
                    _loc_37.init(param1.x, param1.y);
                    break;
                }
                case Kind.ENEMY_BOSS:
                {
                    _loc_38 = new Boss();
                    _loc_38.callbackJump = param1.attr.callbackJump;
                    _loc_38.callbackDie = param1.attr.callbackDie;
                    _loc_38.init(param1.x, param1.y);
                    break;
                }
                case Kind.BAG:
                {
                    _loc_39 = new Bag();
                    _loc_39.init(param1.x, param1.y, param1.rotation);
                    if (param1.jointInd != -1)
                    {
                        this._objectList[param1.jointInd].body = _loc_39.body;
                    }
                    break;
                }
                case Kind.ROPE:
                {
                    _loc_40 = new Hook();
                    _loc_40.kind = Kind.ROPE;
                    _loc_40.init(param1.x, param1.y, param1.rotation);
                    if (param1.jointInd != -1)
                    {
                        this._objectList[param1.jointInd].body = _loc_40.body;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override public function get width() : Number
        {
            return this._width;
        }// end function

        private function addToStorage(param1:int, param2:int, param3:int, param4:Sprite, param5:Object = null, param6:Boolean = false) : void
        {
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Apolygon = null;
            var _loc_7:* = param4.rotation;
            param4.rotation = 0;
            var _loc_8:Object = {kind:param3, x:param4.x, y:param4.y, width:param4.width, height:param4.height, rotation:_loc_7, attr:param5, jointInd:-1};
            if (param6)
            {
                _loc_9 = param4.width * 0.5;
                _loc_10 = param4.height * 0.5;
                _loc_11 = new Apolygon(_loc_8.x, _loc_8.y);
                _loc_11.addVertex(-_loc_9, -_loc_10);
                _loc_11.addVertex(_loc_9, -_loc_10);
                _loc_11.addVertex(_loc_9, _loc_10);
                _loc_11.addVertex(-_loc_9, _loc_10);
                _loc_11.rotation = Amath.toRadians(_loc_8.rotation);
                this._objectList[this._objectList.length] = {shape:_loc_11, body:null};
                _loc_8.jointInd = this._objectList.length - 1;
            }
            this._storage[param2][param1].list.push(_loc_8);
            return;
        }// end function

        public function setLevelSize(param1:int, param2:int) : void
        {
            this._tileWidth = param1;
            this._tileHeight = param2;
            this._width = this._tileWidth * TILE_SIZE;
            this._height = this._tileHeight * TILE_SIZE;
            return;
        }// end function

        public function load(param1:Boolean = true) : void
        {
            var _loc_2:int = 0;
            var _loc_3:Object = null;
            this._jointList.length = 0;
            this._objectList.length = 0;
            this._actionList.length = 0;
            this.clearStorage();
            this.makeLevelDynamics();
            this.makeLevelBody();
            if (param1)
            {
                this.clearBitmaps();
                this.makeCacheQuick();
            }
            this._container = null;
            this._background = null;
            if (this._respawnPoints.length > 0)
            {
                if (this._respawnAlias != "")
                {
                    _loc_2 = 0;
                    while (_loc_2 < this._respawnPoints.length)
                    {
                        
                        if (this._respawnPoints[_loc_2].alias == this._respawnAlias)
                        {
                            _loc_3 = this._respawnPoints[_loc_2];
                            break;
                        }
                        _loc_2++;
                    }
                }
                else
                {
                    _loc_3 = this._respawnPoints[0];
                }
                if (this._universe.player == null)
                {
                    this._universe.player = new Player(_loc_3.x, _loc_3.y);
                }
                else
                {
                    this._universe.player.init(_loc_3.x, _loc_3.y);
                }
                this._universe.background.reset(Amath.toPercent(_loc_3.x, this._width), Amath.toPercent(_loc_3.y, this._height));
            }
            else
            {
                this.$.trace("LevelBase::load() - not found respawn point for the player.");
            }
            this._isLevelCreated = true;
            return;
        }// end function

        protected function makeLevelDynamics() : void
        {
            var _loc_1:Sprite = null;
            if (this._container == null)
            {
                return;
            }
            var _loc_2:* = this._container.numChildren;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_1 = this._container.getChildAt(_loc_3) as Sprite;
                if (this._container.getChildAt(_loc_3) is Sprite)
                {
                    if (_loc_1.visible && _loc_1.name != "")
                    {
                        if (this.makeJointFromClip(_loc_1))
                        {
                            _loc_1.visible = false;
                        }
                        else if (this.makeActionFromClip(_loc_1))
                        {
                            _loc_1.visible = false;
                        }
                    }
                }
                _loc_3++;
            }
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this._container.getChildAt(_loc_3) is Sprite)
                {
                    _loc_1 = this._container.getChildAt(_loc_3) as Sprite;
                    if (_loc_1.visible && _loc_1.name != "")
                    {
                        if (this.makeObjectFromClip(_loc_1))
                        {
                            _loc_1.visible = false;
                        }
                        else if (this.makeObjectFromComponent(_loc_1))
                        {
                            _loc_1.visible = false;
                        }
                    }
                }
                _loc_3++;
            }
            return;
        }// end function

        public function makeFromArea(param1:Number, param2:Number, param3:Number, param4:Number) : void
        {
            var _loc_5:Object = null;
            var _loc_10:Object = null;
            var _loc_11:int = 0;
            var _loc_12:int = 0;
            var _loc_13:b2Body = null;
            var _loc_14:b2Body = null;
            var _loc_15:Object = null;
            var _loc_16:Object = null;
            var _loc_17:int = 0;
            var _loc_18:int = 0;
            var _loc_19:int = 0;
            var _loc_20:int = 0;
            var _loc_6:* = int(param1 / TILE_SIZE);
            var _loc_7:* = int(param2 / TILE_SIZE);
            var _loc_8:* = int(param3 / TILE_SIZE);
            var _loc_9:* = int(param4 / TILE_SIZE);
            if (_loc_6 >= 0 && _loc_7 >= 0 && _loc_8 < this._tileWidth && _loc_9 < this._tileHeight)
            {
                _loc_11 = 0;
                _loc_12 = _loc_7;
                while (_loc_12 <= _loc_9)
                {
                    
                    _loc_17 = _loc_6;
                    while (_loc_17 <= _loc_8)
                    {
                        
                        _loc_10 = this._storage[_loc_12][_loc_17];
                        _loc_11 = _loc_10.list.length;
                        _loc_18 = 0;
                        while (_loc_18 < _loc_11)
                        {
                            
                            _loc_5 = _loc_10.list[_loc_18];
                            this.makeObject(_loc_5);
                            _loc_18++;
                        }
                        _loc_10.created = true;
                        _loc_17++;
                    }
                    _loc_12++;
                }
                _loc_11 = this._jointList.length;
                _loc_18 = 0;
                while (_loc_18 < _loc_11)
                {
                    
                    _loc_13 = null;
                    _loc_13 = null;
                    _loc_15 = this._jointList[_loc_18];
                    if (_loc_15.isCreate)
                    {
                    }
                    else
                    {
                        _loc_19 = this._objectList.length;
                        _loc_20 = 0;
                        while (_loc_20 < _loc_19)
                        {
                            
                            _loc_5 = this._objectList[_loc_20];
                            if (_loc_5.body != null && _loc_5.shape.isPointCollision(_loc_15.vec))
                            {
                                if (_loc_13 == null)
                                {
                                    _loc_13 = _loc_5.body;
                                }
                                else if (_loc_14 == null)
                                {
                                    _loc_14 = _loc_5.body;
                                }
                            }
                            _loc_20++;
                        }
                        if (_loc_13 != null && _loc_14 != null)
                        {
                            _loc_15.joint = this.makeJoint(_loc_15.kind, _loc_15.vec, _loc_13, _loc_14);
                            _loc_15.isCreate = true;
                            _loc_13 = null;
                            _loc_14 = null;
                        }
                    }
                    _loc_18++;
                }
                _loc_18 = 0;
                while (_loc_18 < this._actionList.length)
                {
                    
                    _loc_16 = this._actionList[_loc_18];
                    if (_loc_16.isCreate)
                    {
                    }
                    else
                    {
                        switch(_loc_16.variety)
                        {
                            case SomeAction.DESTROY_JOINT:
                            {
                                _loc_20 = 0;
                                while (_loc_20 < this._jointList.length)
                                {
                                    
                                    _loc_15 = this._jointList[_loc_20];
                                    if (_loc_15.isCreate && Amath.distance(_loc_16.x, _loc_16.y, _loc_15.vec.x, _loc_15.vec.y) <= 5)
                                    {
                                        this.makeAction(_loc_16, _loc_15.joint, null);
                                        _loc_16.isCreate = true;
                                    }
                                    _loc_20++;
                                }
                                break;
                            }
                            case SomeAction.DESTROY_BODY:
                            {
                                _loc_20 = 0;
                                while (_loc_20 < this._objectList.length)
                                {
                                    
                                    _loc_5 = this._objectList[_loc_20];
                                    if (_loc_5.body != null && _loc_5.shape.isPointCollision(new Avector(_loc_16.x, _loc_16.y)))
                                    {
                                        this.makeAction(_loc_16, null, _loc_5.body);
                                        _loc_16.isCreate = true;
                                    }
                                    _loc_20++;
                                }
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                    }
                    _loc_18++;
                }
            }
            else
            {
                this.$.trace("LevelBase::makeFromArea() - Out of game map bounds.");
            }
            return;
        }// end function

        private function clearStorage() : void
        {
            var _loc_3:int = 0;
            this.removeBitmaps();
            var _loc_1:Array = [];
            this._storage = [];
            var _loc_2:int = 0;
            while (_loc_2 < this._tileHeight)
            {
                
                _loc_1 = [];
                _loc_3 = 0;
                while (_loc_3 < this._tileWidth)
                {
                    
                    _loc_1[_loc_1.length] = {list:[], created:false};
                    _loc_3++;
                }
                this._storage[this._storage.length] = _loc_1;
                _loc_2++;
            }
            return;
        }// end function

        private function makeJointFromClip(param1:Sprite) : Boolean
        {
            var _loc_4:Avector = null;
            var _loc_2:Boolean = true;
            var _loc_3:uint = 0;
            switch(param1.name)
            {
                case CLIP_JOINT_BASIC:
                {
                    _loc_3 = JOINT_BASIC;
                    break;
                }
                case CLIP_JOINT_STATIC:
                {
                    _loc_3 = JOINT_STATIC;
                    break;
                }
                case CLIP_JOINT_STRONG:
                {
                    _loc_3 = JOINT_STRONG;
                    break;
                }
                case CLIP_JOINT_WEAK:
                {
                    _loc_3 = JOINT_WEAK;
                    break;
                }
                case CLIP_JOINT_TRAILER:
                {
                    _loc_3 = JOINT_TRAILER;
                    break;
                }
                default:
                {
                    _loc_2 = false;
                    break;
                    break;
                }
            }
            if (_loc_2)
            {
                _loc_4 = new Avector(param1.x, param1.y);
                this._jointList[this._jointList.length] = {kind:_loc_3, vec:_loc_4, joint:null, isCreate:false};
            }
            return _loc_2;
        }// end function

        private function makeActionFromClip(param1:Sprite) : Boolean
        {
            var _loc_3:Object = null;
            var _loc_4:Object = null;
            var _loc_2:Boolean = true;
            if (param1 is DestroyJoint_com)
            {
                _loc_3 = param1 as DestroyJoint_com;
                _loc_4 = {kind:Kind.ACTION, variety:SomeAction.DESTROY_JOINT, alias:_loc_3.alias, delay:_loc_3.delay, x:param1.x, y:param1.y, isCreate:false};
            }
            else if (param1 is DestroyBody_com)
            {
                _loc_3 = param1 as DestroyBody_com;
                _loc_4 = {kind:Kind.ACTION, variety:SomeAction.DESTROY_BODY, alias:_loc_3.alias, delay:_loc_3.delay, x:param1.x, y:param1.y, isCreate:false};
            }
            else
            {
                _loc_2 = false;
            }
            if (_loc_2)
            {
                this._actionList[this._actionList.length] = _loc_4;
            }
            return _loc_2;
        }// end function

        protected function makeLevelBody() : void
        {
            var _loc_1:Sprite = null;
            var _loc_4:Ground = null;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Apolygon = null;
            if (this._container == null)
            {
                return;
            }
            var _loc_2:* = this._container.numChildren;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this._container.getChildAt(_loc_3) is Sprite && (this._container.getChildAt(_loc_3) as Sprite).visible)
                {
                    if (this._container.getChildAt(_loc_3) is Door_com || this._container.getChildAt(_loc_3) is ShopStorage_com || this._container.getChildAt(_loc_3).name == CLIP_SCREEN_FRAME)
                    {
                    }
                    else
                    {
                        _loc_1 = this._container.getChildAt(_loc_3) as Sprite;
                        _loc_4 = new Ground();
                        _loc_5 = _loc_1.rotation;
                        _loc_1.rotation = 0;
                        if (_loc_1.name == CLIP_SPHERE || _loc_1.name == CLIP_CONNECT_PLACE_SPHERE)
                        {
                            _loc_4.variety = Ground.SPHERE;
                        }
                        if (_loc_1.name == CLIP_CONNECT_PLACE || _loc_1.name == CLIP_CONNECT_PLACE_SPHERE)
                        {
                            _loc_6 = _loc_1.width * 0.5;
                            _loc_7 = _loc_1.height * 0.5;
                            _loc_8 = new Apolygon(_loc_1.x, _loc_1.y);
                            _loc_8.addVertex(-_loc_6, -_loc_7);
                            _loc_8.addVertex(_loc_6, -_loc_7);
                            _loc_8.addVertex(_loc_6, _loc_7);
                            _loc_8.addVertex(-_loc_6, _loc_7);
                            _loc_8.rotation = Amath.toRadians(_loc_5);
                            this._objectList[this._objectList.length] = {shape:_loc_8, body:null};
                            _loc_4.connectPlace = true;
                        }
                        _loc_4.bodyWidth = _loc_1.width;
                        _loc_4.bodyHeight = _loc_1.height;
                        _loc_4.init(_loc_1.x, _loc_1.y, _loc_5);
                        _loc_1.visible = false;
                        if (_loc_4.connectPlace)
                        {
                            this._objectList[(this._objectList.length - 1)].body = _loc_4.body;
                        }
                    }
                }
                _loc_3++;
            }
            return;
        }// end function

        public static function getMissions(param1:int) : Array
        {
            switch(param1)
            {
                case 1:
                {
                    return Level1.MISSION_INFO;
                }
                case 2:
                {
                    return Level2.MISSION_INFO;
                }
                case 3:
                {
                    return Level3.MISSION_INFO;
                }
                case 4:
                {
                    return Level4.MISSION_INFO;
                }
                case 5:
                {
                    return Level5.MISSION_INFO;
                }
                case 6:
                {
                    return Level6.MISSION_INFO;
                }
                case 7:
                {
                    return Level7.MISSION_INFO;
                }
                case 8:
                {
                    return Level8.MISSION_INFO;
                }
                case 9:
                {
                    return Level9.MISSION_INFO;
                }
                case 10:
                {
                    return Level10.MISSION_INFO;
                }
                default:
                {
                    break;
                }
            }
            return null;
        }// end function

    }
}
