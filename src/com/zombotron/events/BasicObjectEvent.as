package com.zombotron.events
{
    import flash.events.*;

    public class BasicObjectEvent extends Event
    {
        public var bulletDamage:Number;
        public static const BULLET_COLLISION:String = "BulletCollision";

        public function BasicObjectEvent(param1:String, param2:Number = 0, param3:Boolean = true, param4:Boolean = false)
        {
            this.bulletDamage = param2;
            super(param1, param3, param4);
            return;
        }// end function

    }
}
