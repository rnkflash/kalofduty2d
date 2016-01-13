package com.zombotron.gui
{
    import com.antkarlov.managers.*;
    import com.zombotron.core.*;
    import com.zombotron.helpers.*;
    import flash.display.*;

    public class ShopItem extends BasicElement
    {
        public var id:int = -1;
        private var _isCart:Boolean;
        private var _priceLabel:TextLabel;
        private var _button:TextButton;
        private var _elements:Array;
        private var _tm:TaskManager;
        private var _price:int = 0;
        private var _ico:MovieClip;
        private var _enable:Boolean;
        private var _quantity:int = 0;
        private var _quantityLabel:TextLabel;
        public var onClickButton:Function = null;
        public static const BASKET:uint = 2;
        public static const BASIC:uint = 1;

        public function ShopItem(param1:Boolean = false)
        {
            this._elements = [];
            this._tm = new TaskManager();
            this._isCart = param1;
            this._enable = true;
            return;
        }// end function

        override public function hide() : void
        {
            this._tm.addTask(this.onFadeOut);
            return;
        }// end function

        public function get enable() : Boolean
        {
            return this._enable;
        }// end function

        public function set enable(param1:Boolean) : void
        {
            this._enable = param1;
            var _loc_2:* = this._elements.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this._elements[_loc_3] is TextLabel)
                {
                    (this._elements[_loc_3] as TextLabel).setColor(this._enable ? (TextLabel.COLOR_LIME) : (TextLabel.COLOR_PINK));
                }
                else if (this._elements[_loc_3] is TextButton)
                {
                    (this._elements[_loc_3] as TextButton).setColor(this._enable ? (TextButton.COLOR_LIME) : (TextButton.COLOR_PINK));
                }
                _loc_3++;
            }
            if (this._ico != null)
            {
                this._ico.gotoAndStop(this._enable ? (_kind) : (_kind + this._ico.totalFrames * 0.5));
            }
            return;
        }// end function

        public function get quantity() : int
        {
            return this._quantity;
        }// end function

        override public function show() : void
        {
            if (this._isCart)
            {
                this.makeAsBasket();
            }
            else
            {
                this.makeAsBasic();
            }
            return;
        }// end function

        public function showButton() : void
        {
            if (!contains(this._button))
            {
                this._button.show();
                addChild(this._button);
            }
            return;
        }// end function

        public function get price() : int
        {
            return this._price;
        }// end function

        private function onFadeOut() : Boolean
        {
            this.alpha = this.alpha - 0.2;
            if (this.alpha <= 0)
            {
                this.alpha = 0;
                return true;
            }
            return false;
        }// end function

        private function makeAsBasic() : void
        {
            this._ico = new ShopIcons_mc();
            this._ico.gotoAndStop(this._enable ? (_kind) : (_kind + this._ico.totalFrames * 0.5));
            this._ico.y = 7;
            addChild(this._ico);
            this._ico.alpha = 0;
            if (this._quantity <= 0)
            {
                this.alpha = 0.5;
            }
            var _loc_1:Array = [];
            _loc_1.push(ShopBox.toName(_kind));
            _loc_1.push(Text.TXT_QUANTITY + this.quantity.toString());
            this._tm.addTask(this.onShowIco);
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                this._tm.addTask(this.onAddDesc, [-2, 42 + 10 * _loc_2, _loc_1[int(_loc_2)], _loc_2 == (_loc_1.length - 1) ? (true) : (false)]);
                this._tm.addPause(5);
                _loc_2++;
            }
            this._tm.addTask(this.onMakePrice, [40, 16, this.price.toString()]);
            this._tm.addTask(this.onMakeButton, [114, 46, Text.BTN_ADD, TextButton.BUY]);
            return;
        }// end function

        public function get isCart() : Boolean
        {
            return this._isCart;
        }// end function

        private function onMakePrice(param1:int, param2:int, param3:String) : Boolean
        {
            var _loc_4:* = new TextLabel(TextLabel.TEXT_PRICE);
            _loc_4.setText(param3);
            _loc_4.x = 114 - _loc_4.width * 0.5;
            _loc_4.y = param2;
            _loc_4.setAnim(TextLabel.ANIM_PRINT);
            _loc_4.setColor(this._enable ? (TextLabel.COLOR_LIME) : (TextLabel.COLOR_PINK));
            this._elements[int(this._elements.length)] = _loc_4;
            _loc_4.show();
            addChild(_loc_4);
            this._priceLabel = _loc_4;
            return true;
        }// end function

        public function set price(param1:int) : void
        {
            if (this._price != param1)
            {
                this._price = param1;
                if (this._priceLabel != null)
                {
                    this._priceLabel.setText(param1.toString());
                    this._priceLabel.x = 114 - this._priceLabel.width * 0.5;
                    this._priceLabel.show();
                }
            }
            return;
        }// end function

        private function onClickBuy() : void
        {
            if (this.onClickButton != null)
            {
                this.onClickButton();
            }
            return;
        }// end function

        override public function free() : void
        {
            var _loc_1:* = this._elements.length;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                this._elements[int(_loc_2)].free();
                this._elements[int(_loc_2)] = null;
                _loc_2++;
            }
            this._elements.length = 0;
            if (this._ico != null)
            {
                removeChild(this._ico);
                this._ico = null;
            }
            this._quantityLabel = null;
            this.onClickButton = null;
            return;
        }// end function

        private function makeAsBasket() : void
        {
            this._ico = new BasketIcon_mc();
            this._ico.gotoAndStop(1);
            addChild(this._ico);
            this._ico.alpha = 0;
            this.alpha = 0.5;
            var _loc_1:Array = [];
            _loc_1.push(Text.TXT_ITEMS_IN_YOUR);
            _loc_1.push(Text.TXT_CART + this.quantity.toString());
            this._tm.addTask(this.onShowIco);
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                this._tm.addTask(this.onAddDesc, [-2, 26 + 10 * _loc_2, _loc_1[int(_loc_2)], _loc_2 == (_loc_1.length - 1) ? (true) : (false)]);
                this._tm.addPause(5);
                _loc_2++;
            }
            this._tm.addTask(this.onMakePrice, [40, 6, this.price.toString()]);
            this._tm.addTask(this.onMakeButton, [114, 30, Text.BTN_BUY, TextButton.BUY]);
            return;
        }// end function

        public function set quantity(param1:int) : void
        {
            this._quantity = param1;
            this.alpha = this._quantity == 0 ? (0.25) : (1);
            if (this._ico != null && this._isCart)
            {
                if (this._quantity > 0)
                {
                    this._ico.gotoAndStop(this._quantity <= 5 ? ((this._quantity + 1)) : (6));
                }
                else
                {
                    this._ico.gotoAndStop(1);
                }
                if (this._quantityLabel != null)
                {
                    this._quantityLabel.setText(Text.TXT_CART + this._quantity.toString());
                    this._quantityLabel.show();
                }
            }
            return;
        }// end function

        private function onClickAdd() : void
        {
            if (this.onClickButton != null)
            {
                if (this.quantity > 0)
                {
                    if (this.onClickButton(this.id))
                    {
                        var _loc_1:String = this;
                        var _loc_2:* = this.quantity - 1;
                        _loc_1.quantity = _loc_2;
                        this._quantityLabel.setText(Text.TXT_QUANTITY + this.quantity.toString());
                        this._quantityLabel.show();
                        if (this.quantity <= 0)
                        {
                            this._button.hide();
                        }
                    }
                }
                else
                {
                    this.onClickButton(-1);
                }
            }
            return;
        }// end function

        private function onShowIco() : Boolean
        {
            this._ico.alpha = this._ico.alpha + 0.2;
            if (this._ico.alpha >= 1)
            {
                this._ico.alpha = 1;
                return true;
            }
            return false;
        }// end function

        private function onAddDesc(param1:int, param2:int, param3:String, param4:Boolean) : Boolean
        {
            var _loc_5:* = new TextLabel(TextLabel.TEXT8);
            _loc_5.x = param1;
            _loc_5.y = param2;
            _loc_5.setText(param3);
            _loc_5.setAnim(TextLabel.ANIM_PRINT);
            _loc_5.setColor(this._enable ? (TextLabel.COLOR_LIME) : (TextLabel.COLOR_PINK));
            if (param4)
            {
                this._quantityLabel = _loc_5;
            }
            this._elements[int(this._elements.length)] = _loc_5;
            _loc_5.show();
            addChild(_loc_5);
            return true;
        }// end function

        private function onMakeButton(param1:int, param2:int, param3:String, param4:uint) : Boolean
        {
            var _loc_5:* = new TextButton(param4);
            _loc_5.setText(param3);
            _loc_5.x = param1;
            _loc_5.y = param2;
            _loc_5.onClick = this._isCart ? (this.onClickBuy) : (this.onClickAdd);
            _loc_5.setColor(this._enable ? (TextButton.COLOR_LIME) : (TextButton.COLOR_PINK));
            this._elements[int(this._elements.length)] = _loc_5;
            if (!this._isCart && this._quantity != 0)
            {
                _loc_5.show();
                addChild(_loc_5);
            }
            this._button = _loc_5;
            return true;
        }// end function

    }
}
