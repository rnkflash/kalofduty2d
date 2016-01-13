package com.zombotron.gui
{
    import com.antkarlov.managers.*;
    import com.zombotron.core.*;
    import flash.display.*;
    import flash.events.*;

    public class BasicMenu extends Sprite
    {
        protected var _game:Game;
        protected var _elements:Array;
        protected var _tm:TaskManager;

        public function BasicMenu()
        {
            this._game = Game.getInstance();
            this._elements = [];
            this._tm = new TaskManager();
            return;
        }// end function

        protected function onMakeLabel(param1:int, param2:int, param3:String, param4:uint) : Boolean
        {
            var _loc_5:TextLabel = null;
            _loc_5 = new TextLabel(param4);
            _loc_5.setAnim(TextLabel.ANIM_PRINT);
            _loc_5.setText(param3);
            _loc_5.x = param1;
            _loc_5.y = param2;
            _loc_5.show();
            addChild(_loc_5);
            this._elements[this._elements.length] = _loc_5;
            return true;
        }// end function

        public function hide() : void
        {
            return;
        }// end function

        protected function onHideElement(param1:int) : Boolean
        {
            if (param1 >= 0 && param1 < this._elements.length)
            {
                (this._elements[param1] as BasicElement).hide();
            }
            return true;
        }// end function

        public function free() : void
        {
            var _loc_1:* = this._elements.length;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                (this._elements[_loc_2] as BasicElement).free();
                this._elements[_loc_2] = null;
                _loc_2++;
            }
            this._elements.length = 0;
            this._tm.clear();
            return;
        }// end function

        protected function onComplete() : Boolean
        {
            dispatchEvent(new Event(Event.COMPLETE));
            return true;
        }// end function

        public function show() : void
        {
            return;
        }// end function

        protected function onMakeButton(param1:int, param2:int, param3:String, param4:uint, param5:Function, param6:int = 0) : Boolean
        {
            var _loc_7:* = new TextButton(param4);
            _loc_7.setText(param3);
            _loc_7.x = param1;
            _loc_7.y = param2;
            _loc_7.onClick = param5;
            _loc_7.tag = param6;
            _loc_7.enable = param6 < 0 ? (false) : (true);
            _loc_7.show();
            addChild(_loc_7);
            this._elements[this._elements.length] = _loc_7;
            return true;
        }// end function

    }
}
