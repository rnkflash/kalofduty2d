package com.zombotron.controllers
{
    import com.antkarlov.lists.*;
    import com.zombotron.effects.*;

    public class EffectController extends BaseController
    {

        public function EffectController()
        {
            return;
        }// end function

        public function add(param1:BasicEffect) : void
        {
            _list.push(param1);
            return;
        }// end function

        public function remove(param1:BasicEffect) : void
        {
            _list.remove(param1);
            return;
        }// end function

        public function clear() : void
        {
            var _loc_1:* = _list.lastNode;
            while (_loc_1)
            {
                
                _loc_1.data.free();
                _loc_1 = _loc_1.prev;
            }
            _list.clear();
            return;
        }// end function

        override public function process() : void
        {
            var _loc_1:* = _list.firstNode;
            while (_loc_1)
            {
                
                _loc_1.data.process();
                _loc_1 = _loc_1.next;
            }
            return;
        }// end function

    }
}
