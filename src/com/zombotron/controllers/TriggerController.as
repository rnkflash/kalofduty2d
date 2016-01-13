package com.zombotron.controllers
{
    import com.antkarlov.lists.*;
    import com.antkarlov.math.*;
    import com.zombotron.objects.*;

    public class TriggerController extends BaseController
    {

        public function TriggerController()
        {
            return;
        }// end function

        public function bulletCollision(param1:Number, param2:Number) : void
        {
            var _loc_3:Avector = null;
            var _loc_4:Avector = null;
            var _loc_5:* = _list.firstNode;
            while (_loc_5)
            {
                
                _loc_3 = _loc_5.data.topLeft;
                _loc_4 = _loc_5.data.bottomRight;
                if (param1 >= _loc_3.x && param2 >= _loc_3.y && param1 <= _loc_4.x && param2 <= _loc_4.y)
                {
                    _loc_5.data.action();
                    return;
                }
                _loc_5 = _loc_5.next;
            }
            return;
        }// end function

        public function add(param1:TriggerBullet) : void
        {
            _list.push(param1);
            return;
        }// end function

        public function remove(param1:TriggerBullet) : void
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

        public function removeByTarget(param1:String) : void
        {
            var _loc_2:* = _list.firstNode;
            while (_loc_2)
            {
                
                if (_loc_2.data.targetAlias == param1)
                {
                    _loc_2.data.free();
                }
                _loc_2 = _loc_2.next;
            }
            return;
        }// end function

    }
}
