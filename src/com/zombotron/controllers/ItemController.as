package com.zombotron.controllers
{
    import Box2D.Common.Math.*;
    import com.antkarlov.lists.*;
    import com.antkarlov.math.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.objects.*;

    public class ItemController extends BaseController
    {

        public function ItemController()
        {
            return;
        }// end function

        public function add(param1:IItemObject) : void
        {
            _list.push(param1);
            return;
        }// end function

        public function remove(param1:IItemObject) : void
        {
            _list.remove(param1);
            return;
        }// end function

        public function clear() : void
        {
            _list.clear();
            return;
        }// end function

        override public function process() : void
        {
            var _loc_1:b2Vec2 = null;
            var _loc_2:b2Vec2 = null;
            var _loc_3:Anode = null;
            if (!_universe.player.isDead)
            {
                _loc_1 = _universe.playerBody.GetPosition();
                _loc_3 = _list.firstNode;
                while (_loc_3)
                {
                    
                    if (_loc_3.data is Coin)
                    {
                        if ((_loc_3.data as Coin).isMagnetic)
                        {
                            (_loc_3.data as Coin).process();
                        }
                    }
                    else
                    {
                        _loc_2 = _loc_3.data.body.GetPosition();
                        if (Amath.distance(_loc_1.x, _loc_1.y, _loc_2.x, _loc_2.y) < 1.1)
                        {
                            _loc_3.data.collect();
                        }
                    }
                    _loc_3 = _loc_3.next;
                }
            }
            return;
        }// end function

        public function contains(param1:IItemObject) : Boolean
        {
            return _list.contains(param1);
        }// end function

    }
}
