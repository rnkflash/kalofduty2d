package com.zombotron.controllers
{
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.lists.*;
    import com.zombotron.objects.*;

    public class JointController extends BaseController
    {

        public function JointController()
        {
            return;
        }// end function

        public function add(param1:b2RevoluteJoint, param2:Number, param3:Function = null) : void
        {
            var _loc_4:Object = {joint:param1, strength:param2, callBack:param3};
            _list.push(_loc_4);
            return;
        }// end function

        public function clear() : void
        {
            _list.clear();
            return;
        }// end function

        public function kill(param1:b2RevoluteJoint) : void
        {
            var _loc_2:b2Body = null;
            var _loc_3:* = _list.firstNode;
            while (_loc_3)
            {
                
                if (_loc_3.data.joint == param1)
                {
                    _loc_2 = _loc_3.data.joint.GetBody1();
                    _loc_2.m_userData.jointDead(_loc_3.data.joint);
                    _loc_2 = _loc_3.data.joint.GetBody2();
                    _loc_2.m_userData.jointDead(_loc_3.data.joint);
                    if (_loc_3.data.joint.m_userData is SomeAction)
                    {
                        _universe.triggers.removeByTarget((_loc_3.data.joint.m_userData as SomeAction).alias);
                    }
                    _universe.physics.DestroyJoint(_loc_3.data.joint);
                    _list.destroy(_loc_3);
                    break;
                }
                _loc_3 = _loc_3.next;
            }
            return;
        }// end function

        override public function process() : void
        {
            var _loc_1:b2Body = null;
            var _loc_2:* = _list.firstNode;
            while (_loc_2)
            {
                
                if (_loc_2.data.joint.GetReactionForce().Length() >= _loc_2.data.strength)
                {
                    _loc_1 = _loc_2.data.joint.GetBody1();
                    _loc_1.m_userData.jointDead(_loc_2.data.joint);
                    _loc_1 = _loc_2.data.joint.GetBody2();
                    _loc_1.m_userData.jointDead(_loc_2.data.joint);
                    _universe.physics.DestroyJoint(_loc_2.data.joint);
                    _list.destroy(_loc_2);
                }
                _loc_2 = _loc_2.next;
            }
            return;
        }// end function

    }
}
