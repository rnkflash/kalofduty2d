package com.zombotron.controllers
{
    import com.antkarlov.lists.*;
    import com.zombotron.interfaces.*;

    public class DeadController extends BaseController
    {

        public function DeadController()
        {
            return;
        }// end function

        public function add(param1:IBasicObject) : void
        {
            _list.push(param1);
            return;
        }// end function

        public function clear() : void
        {
            _list.clear();
            return;
        }// end function

        override public function process() : void
        {
            var _loc_1:Anode = null;
            if (_list.size > 0)
            {
                _loc_1 = _list.firstNode;
                while (_loc_1)
                {
                    
                    _loc_1.data.die();
                    _loc_1 = _loc_1.next;
                }
                _list.clear();
            }
            return;
        }// end function

    }
}
