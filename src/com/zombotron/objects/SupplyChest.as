package com.zombotron.objects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.helpers.*;
    import com.zombotron.interfaces.*;

    public class SupplyChest extends BasicObject implements IActiveObject
    {
        private var _alias:String = "nonameSupply";

        public function SupplyChest()
        {
            _kind = Kind.SUPPLY_CHEST;
            _isVisible = false;
            _visibleCulling = false;
            return;
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        public function changeState() : void
        {
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector();
        }// end function

        public function get activateDistance() : int
        {
            return -1;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            reset();
            this.x = param1;
            this.y = param2;
            _universe.objects.add(this);
            return;
        }// end function

        public function action(param1:Function = null) : void
        {
            var _loc_2:Chest = null;
            if (_universe.player.isNeedAmmo())
            {
                _loc_2 = Chest.get();
                _loc_2.alias = this.alias + "_chest";
                _loc_2.targetAlias = "null";
                _loc_2.setVariety("iron");
                _loc_2.clearContents();
                _loc_2.addItem(ShopBox.toKind("ammoPlayer"), 3);
                _loc_2.init(this.x, this.y);
            }
            return;
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

        public function get alias() : String
        {
            return this._alias;
        }// end function

    }
}
