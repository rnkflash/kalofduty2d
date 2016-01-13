package com.zombotron.controllers
{
    import com.antkarlov.debug.*;
    import com.antkarlov.lists.*;
    import com.antkarlov.math.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.objects.*;

    public class ObjectController extends BaseController
    {

        public function ObjectController()
        {
            return;
        }// end function

        public function add(param1:IActiveObject) : void
        {
            if (!_list.contains(param1))
            {
                _list.push(param1);
            }
            return;
        }// end function

        public function callChangeState(param1:String, param2:String = "no") : void
        {
            if (param1 == "null")
            {
                return;
            }
            var _loc_3:Boolean = false;
            var _loc_4:* = _list.firstNode;
            while (_loc_4)
            {
                
                if (_loc_4.data.alias == param1)
                {
                    _loc_4.data.changeState();
                    _loc_3 = true;
                }
                _loc_4 = _loc_4.next;
            }
            if (!_loc_3)
            {
                $.trace(param2 + ".callChangeState(): Object with a alias \"" + param1 + "\" not found.", Console.FORMAT_RESULT);
            }
            return;
        }// end function

        public function remove(param1:IActiveObject) : void
        {
            _list.remove(param1);
            return;
        }// end function

        public function outputList() : void
        {
            $.trace("List of objects (" + _list.size.toString() + ")", Console.FORMAT_DATA);
            var _loc_1:* = _list.firstNode;
            while (_loc_1)
            {
                
                $.trace("\"" + _loc_1.data.alias + "\" " + _loc_1.data.toString(), Console.FORMAT_DATA);
                _loc_1 = _loc_1.next;
            }
            $.trace("", Console.FORMAT_DATA);
            return;
        }// end function

        public function callDistanceAction(param1:Number, param2:Number, param3:Function = null, param4:Boolean = true) : void
        {
            var _loc_5:Avector = null;
            var _loc_6:int = 0;
            var _loc_7:Number = 0;
            var _loc_8:* = _list.firstNode;
            while (_loc_8)
            {
                
                _loc_5 = _loc_8.data.activatePoint;
                _loc_6 = _loc_8.data.activateDistance;
                if (_loc_6 == -1)
                {
                }
                else
                {
                    _loc_7 = Amath.distance(param1, param2, _loc_5.x, _loc_5.y);
                    if (_loc_7 <= _loc_6)
                    {
                        _loc_8.data.action(param3);
                        if (_loc_8.data is CollectableItem)
                        {
                            return;
                        }
                        if (param4)
                        {
                            return;
                        }
                    }
                }
                _loc_8 = _loc_8.next;
            }
            return;
        }// end function

        public function aliasExists(param1:String) : Boolean
        {
            var _loc_2:* = _list.firstNode;
            while (_loc_2)
            {
                
                if (_loc_2.data.alias == param1)
                {
                    return true;
                }
                _loc_2 = _loc_2.next;
            }
            return false;
        }// end function

        public function clear() : void
        {
            var _loc_1:* = _list.firstNode;
            while (_loc_1)
            {
                
                _loc_1.data.free();
                _loc_1 = _loc_1.next;
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

        public function getUniqueAlias(param1:String) : String
        {
            var _loc_2:* = param1;
            var _loc_3:uint = 1;
            while (this.aliasExists(_loc_2))
            {
                
                _loc_2 = param1 + _loc_3.toString();
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

        public function callAction(param1:String, param2:Function = null, param3:String = "noname") : void
        {
            if (param1 == "null")
            {
                return;
            }
            var _loc_4:Boolean = false;
            var _loc_5:* = _list.firstNode;
            while (_loc_5)
            {
                
                if (_loc_5.data.alias == param1)
                {
                    _loc_5.data.action(param2);
                    _loc_4 = true;
                }
                _loc_5 = _loc_5.next;
            }
            if (!_loc_4)
            {
                $.trace(param3 + ".callAction(): Object with a alias \"" + param1 + "\" not found.");
            }
            return;
        }// end function

        public function outputInfo(param1:String) : void
        {
            var _loc_2:Boolean = false;
            var _loc_3:* = _list.firstNode;
            while (_loc_3)
            {
                
                if (_loc_3.data.alias == param1)
                {
                    $.trace(_loc_3.data.toString(), Console.FORMAT_DATA);
                    _loc_2 = true;
                }
                _loc_3 = _loc_3.next;
            }
            if (!_loc_2)
            {
                $.trace("Object with a alias \"" + param1 + "\" not found.", Console.FORMAT_RESULT);
            }
            return;
        }// end function

        public function contains(param1:IActiveObject) : Boolean
        {
            return _list.contains(param1);
        }// end function

    }
}
