package com.zombotron.listeners
{
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.zombotron.core.*;
    import com.zombotron.objects.*;

    public class DestructionListener extends b2DestructionListener
    {

        public function DestructionListener()
        {
            return;
        }// end function

        override public function SayGoodbyeJoint(param1:b2Joint) : void
        {
            if (param1.m_userData != null && param1.m_userData is SomeAction)
            {
                ZG.universe.triggers.removeByTarget((param1.m_userData as SomeAction).alias);
                param1.m_userData = null;
            }
            return;
        }// end function

    }
}
