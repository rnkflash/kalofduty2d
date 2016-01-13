package com.zombotron.objects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.helpers.*;
    import com.zombotron.interfaces.*;

    public class ItemDrop extends BasicObject implements IActiveObject
    {
        private var _probability:int = 100;
        private var _alias:String = "nonameItemDrop";
        private var _itemKind:uint = 1;
        private static const ITEM_BARREL:uint = 4;
        private static const ITEM_NONE:uint = 1;
        private static const ITEM_RANDOM:uint = 6;
        private static const ITEM_STONE:uint = 2;
        private static const ITEM_SUPPLY_CHEST:uint = 5;
        private static const ITEM_BOX:uint = 3;

        public function ItemDrop()
        {
            _kind = Kind.ITEM_DROP;
            _isVisible = false;
            _visibleCulling = false;
            return;
        }// end function

        public function changeState() : void
        {
            return;
        }// end function

        public function set itemKind(param1:String) : void
        {
            switch(param1)
            {
                case "stone":
                {
                    this._itemKind = ITEM_STONE;
                    break;
                }
                case "box":
                {
                    this._itemKind = ITEM_BOX;
                    break;
                }
                case "barrel":
                {
                    this._itemKind = ITEM_BARREL;
                    break;
                }
                case "supplyChest":
                {
                    this._itemKind = ITEM_SUPPLY_CHEST;
                    break;
                }
                case "random":
                {
                    this._itemKind = ITEM_RANDOM;
                    break;
                }
                default:
                {
                    this._itemKind = ITEM_NONE;
                    break;
                    break;
                }
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            reset();
            this.x = param1;
            this.y = param2;
            _universe.objects.add(this);
            return;
        }// end function

        public function get activateDistance() : int
        {
            return -1;
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector();
        }// end function

        public function set probability(param1:int) : void
        {
            this._probability = param1;
            return;
        }// end function

        public function get alias() : String
        {
            return this._alias;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.objects.remove(this);
                super.free();
            }
            return;
        }// end function

        public function action(param1:Function = null) : void
        {
            var _loc_3:Stone = null;
            var _loc_4:Box = null;
            var _loc_5:Barrel = null;
            var _loc_6:Chest = null;
            var _loc_2:* = this._itemKind;
            if (this._itemKind == ITEM_RANDOM)
            {
                _loc_2 = Amath.random(ITEM_STONE, ITEM_SUPPLY_CHEST);
            }
            if (this._probability < 100)
            {
                if (Amath.random(0, 100) < this._probability)
                {
                    _loc_2 = ITEM_NONE;
                }
            }
            switch(_loc_2)
            {
                case ITEM_STONE:
                {
                    _loc_3 = Stone.get();
                    _loc_3.variety = Amath.random(1, 2);
                    _loc_3.init(this.x, this.y);
                    break;
                }
                case ITEM_BOX:
                {
                    _loc_4 = Box.get();
                    _loc_4.init(this.x, this.y);
                    break;
                }
                case ITEM_BARREL:
                {
                    _loc_5 = Barrel.get();
                    _loc_5.kind = Kind.BARREL;
                    _loc_5.init(this.x, this.y);
                    break;
                }
                case ITEM_SUPPLY_CHEST:
                {
                    _loc_6 = Chest.get();
                    _loc_6.alias = this.alias + "_chest";
                    _loc_6.targetAlias = "null";
                    _loc_6.setVariety("iron");
                    _loc_6.clearContents();
                    _loc_6.addItem(ShopBox.toKind("ammoPlayer"), 3);
                    _loc_6.init(this.x, this.y);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
