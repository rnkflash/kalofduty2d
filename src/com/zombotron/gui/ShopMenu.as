package com.zombotron.gui
{
    import com.zombotron.core.*;
    import com.zombotron.helpers.*;
    import flash.display.*;
    import flash.events.*;

    public class ShopMenu extends BasicMenu
    {
        private var _shopBg:MovieClip;
        public var cash:int = 0;
        public var purchased:Boolean;
        private var _borders:Sprite;
        public var box:ShopBox;
        private var _fadeBg:Sprite;
        private var _btnOff:SimpleButton;
        private var _console:ConsoleGui;
        public var cart:ShopBox;
        public var terminalNum:int = 0;
        private var _cartList:Array;
        private var _cart:ShopItem;
        private static var _instance:ShopMenu = null;

        public function ShopMenu()
        {
            this.box = new ShopBox();
            this.cart = new ShopBox();
            this._cartList = [];
            if (_instance != null)
            {
                throw "ShopMenu.as is a singleton class. Use ShopMenu.getInstance();";
            }
            _instance = this;
            this._fadeBg = new PixelsBg_mc();
            this._shopBg = new ShopBg_mc();
            this._shopBg.x = App.SCR_HALF_W;
            this._shopBg.y = App.SCR_H;
            this._shopBg.gotoAndStop(1);
            this._borders = new ShopBorders_mc();
            this._borders.x = App.SCR_HALF_W - 1;
            this._borders.y = App.SCR_HALF_H - 20;
            this._console = new ConsoleGui();
            this._console.x = 158;
            this._console.y = 308;
            return;
        }// end function

        override public function show() : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            addChild(this._fadeBg);
            addChild(this._shopBg);
            addChild(this._borders);
            this._borders.alpha = 0;
            addChild(this._console);
            this._console.alpha = 0;
            this.cart.copyItems(this.box);
            var _loc_1:* = this.cart.size;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                this.cart.setQuantity(_loc_2, 0);
                _loc_2++;
            }
            this.purchased = false;
            _tm.addTask(this.onShowFade);
            _tm.addTask(this.onPlayBg);
            _tm.addTask(this.onShowShopBg);
            _tm.addPause(13);
            _tm.addTask(this.onMakeLabel, [160, 110, Text.TXT_SHOP_TERMINAL + this.terminalNum.toString(), TextLabel.TEXT8]);
            _tm.addPause(15);
            _tm.addTask(this.onMakeLabel, [160, 122, "{cash}", TextLabel.TEXT16]);
            _tm.addPause(15);
            _tm.addTask(this.onMakeBasicButton, [469, 122, BasicButton.CLOSE, this.onClose]);
            _tm.addInstantTask(this.onMakeOffButton, [444, 397]);
            _loc_1 = this.box.size;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_1)
            {
                
                _loc_4 = 0;
                _loc_5 = 0;
                switch(_loc_3)
                {
                    case 0:
                    {
                        _loc_4 = 162;
                        _loc_5 = 147;
                        break;
                    }
                    case 1:
                    {
                        _loc_4 = 339;
                        _loc_5 = 147;
                        break;
                    }
                    case 2:
                    {
                        _loc_4 = 162;
                        _loc_5 = 224;
                        break;
                    }
                    case 3:
                    {
                        _loc_4 = 339;
                        _loc_5 = 224;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _tm.addTask(this.onMakeShopItem, [_loc_4, _loc_5, this.box.getItemKind(_loc_3), this.box.getItemQuantity(_loc_3), this.box.getItemPrice(_loc_3), _loc_3]);
                _loc_3++;
            }
            _tm.addTask(this.onMakeCart, [340, 307]);
            _tm.addPause(20);
            _tm.addTask(this.onShowBorders);
            _tm.addTask(this.onConsole, [true]);
            _tm.addPause(5);
            _tm.addTask(this.onLog, [Text.CON_PRESS_ADD_BUTTON]);
            _tm.addTask(this.onLog, [Text.CON_TO_ADD_ITEM_IN_YOUR]);
            _tm.addTask(this.onLog, [Text.CON_CART_FOR_BUYING]);
            return;
        }// end function

        private function onPlayBg() : Boolean
        {
            this._shopBg.play();
            return true;
        }// end function

        override public function hide() : void
        {
            removeChild(this._btnOff);
            var _loc_1:* = _elements.length;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                _tm.addTask(onHideElement, [_loc_2]);
                _loc_2++;
            }
            _tm.addTask(this.onConsole, [false]);
            _tm.addTask(this.onHideBorders);
            _tm.addTask(this.onPlayBg);
            _tm.addTask(this.onHideShopBg);
            _tm.addTask(this.onHideFade);
            _tm.addTask(onComplete);
            return;
        }// end function

        private function onHideBorders() : Boolean
        {
            this._borders.alpha = this._borders.alpha - 0.2;
            if (this._borders.alpha <= 0)
            {
                this._borders.alpha = 0;
                return true;
            }
            return false;
        }// end function

        override protected function onMakeLabel(param1:int, param2:int, param3:String, param4:uint) : Boolean
        {
            if (param3 == "{cash}")
            {
                this.cash = ZG.universe.player.coins;
                param3 = Text.TXT_CASH + this.cash.toString();
            }
            return super.onMakeLabel(param1, param2, param3, param4);
        }// end function

        private function onMakeBasicButton(param1:int, param2:int, param3:uint, param4:Function) : Boolean
        {
            var _loc_5:BasicButton = null;
            _loc_5 = new BasicButton(param3);
            _loc_5.x = param1;
            _loc_5.y = param2;
            _loc_5.onClick = param4;
            addChild(_loc_5);
            _loc_5.show();
            _elements[_elements.length] = _loc_5;
            return true;
        }// end function

        private function onClose(event:MouseEvent = null) : void
        {
            this._btnOff.removeEventListener(MouseEvent.CLICK, this.onClose);
            _game.nextScreen = Game.SCR_GAME;
            this.hide();
            return;
        }// end function

        private function onConsole(param1:Boolean) : Boolean
        {
            if (param1)
            {
                this._console.clear();
                this._console.show();
            }
            else
            {
                this._console.hide();
            }
            return true;
        }// end function

        private function onMakeOffButton(param1:int, param2:int) : void
        {
            if (this._btnOff == null)
            {
                this._btnOff = new ShopOff_btn();
                this._btnOff.x = param1;
                this._btnOff.y = param2;
                this._btnOff.addEventListener(MouseEvent.CLICK, this.onClose);
                addChild(this._btnOff);
            }
            this._btnOff.addEventListener(MouseEvent.CLICK, this.onClose);
            addChild(this._btnOff);
            return;
        }// end function

        private function onHideFade() : Boolean
        {
            this._fadeBg.alpha = this._fadeBg.alpha - 0.1;
            if (this._fadeBg.alpha <= 0)
            {
                this._fadeBg.alpha = 0;
                return true;
            }
            return false;
        }// end function

        private function onHideShopBg() : Boolean
        {
            if (this._shopBg.currentFrame == 25)
            {
                this._shopBg.stop();
                return true;
            }
            return false;
        }// end function

        private function onShowFade() : Boolean
        {
            this._fadeBg.alpha = this._fadeBg.alpha + 0.1;
            if (this._fadeBg.alpha >= 0.5)
            {
                this._fadeBg.alpha = 0.5;
                return true;
            }
            return false;
        }// end function

        private function onLog(param1:String) : Boolean
        {
            this._console.log(param1);
            return true;
        }// end function

        private function onBuy() : void
        {
            var _loc_1:int = 0;
            if (this._cart.quantity == 0)
            {
                ZG.sound(SoundManager.TERMINAL_ALARM);
                this._console.log(Text.TXT_CART_IS_EMPTY, false);
                return;
            }
            if (this._cart.price <= ZG.universe.player.coins)
            {
                ZG.universe.player.coins = ZG.universe.player.coins - this._cart.price;
                _loc_1 = 0;
                while (_loc_1 < this._cartList.length)
                {
                    
                    this.box.decQuantity(this._cartList[_loc_1]);
                    this.cart.incQuantity(this._cartList[_loc_1]);
                    _loc_1++;
                }
                this.purchased = true;
                this.onClose();
                ZG.sound(SoundManager.BUY_ITEMS);
            }
            else
            {
                ZG.sound(SoundManager.TERMINAL_ALARM);
                this._console.log(Text.TXT_DO_NOT_ENOUGH_MONEY, false);
            }
            return;
        }// end function

        private function onShowBorders() : Boolean
        {
            this._borders.alpha = this._borders.alpha + 0.2;
            if (this._borders.alpha >= 1)
            {
                this._borders.alpha = 1;
                return true;
            }
            return false;
        }// end function

        override public function free() : void
        {
            removeChild(this._fadeBg);
            removeChild(this._shopBg);
            removeChild(this._borders);
            this._cart = null;
            this._cartList.length = 0;
            super.free();
            return;
        }// end function

        private function onMakeCart(param1:int, param2:int) : Boolean
        {
            this._cart = new ShopItem(true);
            this._cart.x = param1;
            this._cart.y = param2;
            this._cart.onClickButton = this.onBuy;
            addChild(this._cart);
            this._cart.show();
            _elements[_elements.length] = this._cart;
            return true;
        }// end function

        private function onMakeShopItem(param1:int, param2:int, param3:uint, param4:int, param5:int, param6:int) : Boolean
        {
            var _loc_7:ShopItem = null;
            _loc_7 = new ShopItem();
            _loc_7.kind = param3;
            _loc_7.quantity = param4;
            _loc_7.price = param5;
            _loc_7.x = param1;
            _loc_7.y = param2;
            _loc_7.id = param6;
            _loc_7.onClickButton = this.addToCart;
            if (_loc_7.price > this.cash)
            {
                _loc_7.enable = false;
            }
            addChild(_loc_7);
            _loc_7.show();
            _elements[_elements.length] = _loc_7;
            return true;
        }// end function

        private function onShowShopBg() : Boolean
        {
            if (this._shopBg.currentFrame == 14)
            {
                this._shopBg.stop();
                return true;
            }
            return false;
        }// end function

        private function disableItems() : void
        {
            var _loc_1:ShopItem = null;
            var _loc_2:* = _elements.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (_elements[_loc_3] is ShopItem && !(_elements[_loc_3] as ShopItem).isCart)
                {
                    _loc_1 = _elements[_loc_3] as ShopItem;
                    if (this._cart.price + _loc_1.price > this.cash)
                    {
                        _loc_1.enable = false;
                    }
                }
                _loc_3++;
            }
            return;
        }// end function

        private function addToCart(param1:int) : Boolean
        {
            if (param1 > -1)
            {
                if (this._cart.price + this.box.getItemPrice(param1) > this.cash)
                {
                    ZG.sound(SoundManager.TERMINAL_ALARM);
                    this._console.log(Text.TXT_DO_NOT_ENOUGH_MONEY, false);
                }
                else
                {
                    var _loc_2:* = this._cart;
                    var _loc_3:* = this._cart.quantity + 1;
                    _loc_2.quantity = _loc_3;
                    this._cart.price = this._cart.price + this.box.getItemPrice(param1);
                    this._cartList[this._cartList.length] = param1;
                    if (this._cart.quantity == 1)
                    {
                        this._cart.showButton();
                    }
                    this.disableItems();
                    return true;
                }
            }
            else
            {
                ZG.sound(SoundManager.TERMINAL_ALARM);
                this._console.log(Text.TXT_NOT_AVAILABLE, false);
            }
            return false;
        }// end function

        public static function getInstance() : ShopMenu
        {
            return _instance == null ? (new ShopMenu) : (_instance);
        }// end function

    }
}
