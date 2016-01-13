package com.zombotron.controllers
{
    import com.zombotron.interfaces.*;

    public class BodyController extends BaseController
    {
        private static const MAX:int = 30;

        public function BodyController()
        {
            return;
        }// end function

        public function add(param1:IBasicObject) : void
        {
            if (!_list.contains(param1))
            {
                if (_list.size >= MAX)
                {
                    _list.firstNode.data.free();
                }
                _list.push(param1);
            }
            return;
        }// end function

        public function remove(param1:IBasicObject) : void
        {
            _list.remove(param1);
            return;
        }// end function

        public function clear() : void
        {
            _list.clear();
            return;
        }// end function

    }
}
