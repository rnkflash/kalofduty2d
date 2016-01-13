package com.zombotron.helpers
{
    import com.antkarlov.repositories.*;

    public class ShopBox extends Object
    {
        private var _items:Array;
        public static const ITEM_GUN:uint = 3;
        public static const ITEM_UNDEFINED:uint = 0;
        public static const ITEM_HEALTH_INC:uint = 13;
        public static const ITEM_SPIRIT_BOX:uint = 52;
        public static const ITEM_SPIRIT_BARREL:uint = 51;
        public static const ITEM_SKULL:uint = 15;
        public static const ITEM_AMMO_GRENADEGUN:uint = 9;
        public static const ITEM_HEAD_SKELETON:uint = 23;
        public static const ITEM_AMMO_SHOTGUN:uint = 7;
        public static const ITEM_PISTOL:uint = 1;
        public static const ITEM_ACCURACY_INC:uint = 14;
        public static const ITEM_HEAD_ZOMBIE:uint = 18;
        public static const ITEM_SHOTGUN:uint = 2;
        public static const ITEM_COIN:uint = 60;
        public static const ITEM_SPIRIT_CHEST:uint = 53;
        public static const ITEM_BAG:uint = 24;
        public static const ITEM_MACHINEGUN:uint = 5;
        public static const ITEM_SPIRIT_PLAYER:uint = 54;
        public static const ITEM_AIDKIT:uint = 11;
        public static const ITEM_SPIRIT_BOOM:uint = 50;
        public static const ITEM_AMMO_PLAYER:uint = 61;
        public static const ITEM_HEAD_ROBOT:uint = 21;
        public static const ITEM_AMMO_GUN:uint = 8;
        public static const ITEM_AMMO_PISTOL:uint = 6;
        public static const ITEM_GRENADEGUN:uint = 4;
        public static const ITEM_BONE:uint = 17;
        public static const ITEM_ARMOR:uint = 12;
        public static const ITEM_RIBS:uint = 16;
        public static const ITEM_AMMO_MACHINEGUN:uint = 10;

        public function ShopBox()
        {
            this._items = [];
            return;
        }// end function

        public function getItemPrice(param1:int) : int
        {
            if (param1 >= 0 && param1 < this._items.length)
            {
                return this._items[int(param1)].price;
            }
            return -1;
        }// end function

        public function setQuantity(param1:int, param2:int) : void
        {
            if (param1 >= 0 && param1 < this._items.length)
            {
                this._items[int(param1)].quantity = param2;
            }
            return;
        }// end function

        public function get size() : int
        {
            return this._items.length;
        }// end function

        public function incQuantity(param1:int) : void
        {
            var _loc_2:Object = null;
            if (param1 >= 0 && param1 < this._items.length)
            {
                _loc_2 = this._items[int(param1)];
                var _loc_3:* = _loc_2;
                var _loc_4:* = _loc_2.quantity + 1;
                _loc_3.quantity = _loc_4;
            }
            return;
        }// end function

        public function copyItems(param1:ShopBox) : void
        {
            this.clear();
            var _loc_2:* = param1.size;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                this.addItem(param1.getItemKind(_loc_3), param1.getItemQuantity(_loc_3), param1.getItemPrice(_loc_3));
                _loc_3++;
            }
            return;
        }// end function

        public function decQuantity(param1:int) : void
        {
            var _loc_2:Object = null;
            if (param1 >= 0 && param1 < this._items.length)
            {
                _loc_2 = this._items[int(param1)];
                if (_loc_2.quantity > 0)
                {
                    var _loc_3:* = _loc_2;
                    var _loc_4:* = _loc_2.quantity - 1;
                    _loc_3.quantity = _loc_4;
                }
            }
            return;
        }// end function

        public function addItem(param1:uint, param2:int, param3:int) : void
        {
            var _loc_4:Global = null;
            if (this._items.length == 4)
            {
                _loc_4 = Global.getInstance();
                _loc_4.trace("Warning: Shop box can contain only 4 items.");
                return;
            }
            if (param1 != ITEM_UNDEFINED)
            {
                this._items[int(this._items.length)] = {kind:param1, quantity:param2, price:param3};
            }
            return;
        }// end function

        public function getItemQuantity(param1:int) : int
        {
            if (param1 >= 0 && param1 < this._items.length)
            {
                return this._items[int(param1)].quantity;
            }
            return -1;
        }// end function

        public function clear() : void
        {
            var _loc_1:* = this._items.length;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                this._items[int(_loc_2)] = null;
                _loc_2++;
            }
            this._items.length = 0;
            return;
        }// end function

        public function getItemKind(param1:int) : uint
        {
            if (param1 >= 0 && param1 < this._items.length)
            {
                return this._items[int(param1)].kind;
            }
            return 0;
        }// end function

        public static function toName(param1:uint) : String
        {
            var _loc_2:String = "noname";
            switch(param1)
            {
                case ITEM_PISTOL:
                {
                    return "pistol";
                }
                case ITEM_SHOTGUN:
                {
                    return "shotgun";
                }
                case ITEM_GUN:
                {
                    return "gun";
                }
                case ITEM_GRENADEGUN:
                {
                    return "grenade gun";
                }
                case ITEM_MACHINEGUN:
                {
                    return "machine gun";
                }
                case ITEM_AMMO_PISTOL:
                {
                    return "pistol ammo";
                }
                case ITEM_AMMO_SHOTGUN:
                {
                    return "shotgun ammo";
                }
                case ITEM_AMMO_GUN:
                {
                    return "gun ammo";
                }
                case ITEM_AMMO_GRENADEGUN:
                {
                    return "grenadegun ammo";
                }
                case ITEM_AMMO_MACHINEGUN:
                {
                    return "machinegun ammo";
                }
                case ITEM_AMMO_PLAYER:
                {
                    return "player ammo";
                }
                case ITEM_AIDKIT:
                {
                    return "aid-kit";
                }
                case ITEM_ARMOR:
                {
                    return "armor";
                }
                case ITEM_HEALTH_INC:
                {
                    return "health increment";
                }
                case ITEM_ACCURACY_INC:
                {
                    return "accuracy increment";
                }
                case ITEM_SKULL:
                {
                    return "skull";
                }
                case ITEM_RIBS:
                {
                    return "ribs";
                }
                case ITEM_BONE:
                {
                    return "bone";
                }
                case ITEM_COIN:
                {
                    return "coin";
                }
                default:
                {
                    return "undefined";
                    break;
                }
            }
        }// end function

        public static function toKind(param1:String) : uint
        {
            switch(param1)
            {
                case "pistol":
                {
                    return ITEM_PISTOL;
                }
                case "shotgun":
                {
                    return ITEM_SHOTGUN;
                }
                case "gun":
                {
                    return ITEM_GUN;
                }
                case "grenadegun":
                {
                    return ITEM_GRENADEGUN;
                }
                case "machinegun":
                {
                    return ITEM_MACHINEGUN;
                }
                case "ammoPistol":
                {
                    return ITEM_AMMO_PISTOL;
                }
                case "ammoShotgun":
                {
                    return ITEM_AMMO_SHOTGUN;
                }
                case "ammoGun":
                {
                    return ITEM_AMMO_GUN;
                }
                case "ammoGrenadegun":
                {
                    return ITEM_AMMO_GRENADEGUN;
                }
                case "ammoMachinegun":
                {
                    return ITEM_AMMO_MACHINEGUN;
                }
                case "ammoPlayer":
                {
                    return ITEM_AMMO_PLAYER;
                }
                case "aidkit":
                {
                    return ITEM_AIDKIT;
                }
                case "armor":
                {
                    return ITEM_ARMOR;
                }
                case "healthInc":
                {
                    return ITEM_HEALTH_INC;
                }
                case "accuracyInc":
                {
                    return ITEM_ACCURACY_INC;
                }
                case "skull":
                {
                    return ITEM_SKULL;
                }
                case "ribs":
                {
                    return ITEM_RIBS;
                }
                case "bone":
                {
                    return ITEM_BONE;
                }
                case "coin":
                {
                    return ITEM_COIN;
                }
                default:
                {
                    return ITEM_UNDEFINED;
                    break;
                }
            }
        }// end function

        public static function weaponKind(param1:uint) : uint
        {
            switch(param1)
            {
                case ITEM_AMMO_SHOTGUN:
                {
                    return ITEM_SHOTGUN;
                }
                case ITEM_AMMO_GUN:
                {
                    return ITEM_GUN;
                }
                case ITEM_AMMO_GRENADEGUN:
                {
                    return ITEM_GRENADEGUN;
                }
                case ITEM_AMMO_MACHINEGUN:
                {
                    return ITEM_MACHINEGUN;
                }
                default:
                {
                    return ITEM_PISTOL;
                    break;
                }
            }
        }// end function

    }
}
