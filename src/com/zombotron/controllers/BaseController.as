package com.zombotron.controllers
{
    import com.antkarlov.lists.*;
    import com.antkarlov.repositories.*;
    import com.zombotron.core.*;

    public class BaseController extends Object
    {
        protected var _universe:Universe;
        protected var $:Global;
        protected var _list:Alist;

        public function BaseController()
        {
            this.$ = Global.getInstance();
            this._universe = Universe.getInstance();
            this._list = new Alist();
            return;
        }// end function

        public function process() : void
        {
            return;
        }// end function

    }
}
