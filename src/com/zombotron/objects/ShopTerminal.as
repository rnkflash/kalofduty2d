package com.zombotron.objects
{
    import com.antkarlov.anim.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.gui.*;
    import com.zombotron.helpers.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;
    import flash.events.*;

    public class ShopTerminal extends BasicObject implements IActiveObject
    {
        private var _arrow:Animation;
        public var box:ShopBox;
        private var _alias:String;
        private var _shopMenu:ShopMenu;
        private var _isAction:Boolean;
        public var terminalNum:int;
        public var targetAlias:String;

        public function ShopTerminal()
        {
            this.box = new ShopBox();
            _kind = Kind.SHOP_TERMINAL;
            _sprite = $.animCache.getAnimation(Art.SHOP_TERMINAL);
            this._arrow = $.animCache.getAnimation(Art.ACTIVE_ELEMENT);
            _layer = Universe.LAYER_BG_OBJECTS;
            this.box = new ShopBox();
            this.targetAlias = "null";
            this.terminalNum = 0;
            this._alias = "nonameShopTerminal";
            return;
        }// end function

        public function changeState() : void
        {
            return;
        }// end function

        override public function hide() : void
        {
            if (_isVisible)
            {
                _sprite.stop();
                _universe.remove(this, _layer);
                _isVisible = false;
            }
            return;
        }// end function

        override public function show() : void
        {
            if (!_isVisible)
            {
                _sprite.play();
                _universe.add(this, _layer);
                _isVisible = true;
            }
            return;
        }// end function

        public function action(param1:Function = null) : void
        {
            if (!this._isAction)
            {
                this._isAction = true;
                ZG.sound(SoundManager.ACTION_PRESS_BUTTON, this, true);
                this._shopMenu.addEventListener(Event.COMPLETE, this.shopCompleteHandler);
                this._shopMenu.terminalNum = this.terminalNum;
                this._shopMenu.box = this.box;
                ZG.game.nextScreen = Game.SCR_SHOP;
                ZG.game.makeNextScreen();
            }
            return;
        }// end function

        public function get activateDistance() : int
        {
            return 1;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            addChild(_sprite);
            _sprite.speed = 0.5;
            _sprite.play();
            this._arrow.y = -30;
            addChild(this._arrow);
            this._arrow.play();
            this._isAction = false;
            reset();
            this.show();
            this.x = param1;
            this.y = param2;
            this._shopMenu = ShopMenu.getInstance();
            _universe.objects.add(this);
            return;
        }// end function

        private function shopCompleteHandler(event:Event) : void
        {
            this._shopMenu.removeEventListener(Event.COMPLETE, this.shopCompleteHandler);
            if (this._shopMenu.purchased)
            {
                _universe.objects.callAction(this.targetAlias, this.getShopItems, this._alias);
            }
            this._isAction = false;
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector(this.x / Universe.DRAW_SCALE, this.y / Universe.DRAW_SCALE);
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
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
                this._arrow.stop();
                removeChild(this._arrow);
                super.free();
            }
            return;
        }// end function

        private function getShopItems() : ShopBox
        {
            return this._shopMenu.cart;
        }// end function

        override public function process() : void
        {
            _tileX = this.x / LevelBase.TILE_SIZE;
            _tileY = this.y / LevelBase.TILE_SIZE;
            if (_tileX >= _universe.level.tileX1 && _tileX < _universe.level.tileX2 && _tileY >= _universe.level.tileY1 && _tileY < _universe.level.tileY2)
            {
                this.show();
                this._arrow.play();
            }
            else
            {
                this.hide();
                this._arrow.stop();
            }
            return;
        }// end function

        override public function toString() : String
        {
            return "{ShopTerminal [alias: " + this._alias + ", targetAlias: " + this.targetAlias + "]}";
        }// end function

    }
}
