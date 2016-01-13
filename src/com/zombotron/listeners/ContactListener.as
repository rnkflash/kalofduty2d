package com.zombotron.listeners
{
    import Box2D.Collision.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Contacts.*;
    import com.zombotron.core.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.objects.*;

    public class ContactListener extends b2ContactListener
    {
        private var _universe:Universe;

        public function ContactListener()
        {
            this._universe = Universe.getInstance();
            return;
        }// end function

        override public function Add(param1:b2ContactPoint) : void
        {
            var _loc_4:EnemyWheel = null;
            var _loc_5:EnemyWheel = null;
            var _loc_2:* = param1.shape1.GetBody().GetUserData();
            var _loc_3:* = param1.shape2.GetBody().GetUserData();
            if (_loc_2 is EnemyWheel)
            {
                _loc_4 = _loc_2 as EnemyWheel;
                if (_loc_4.parentObj != null)
                {
                    if (_loc_3 != null && _loc_3.kind != Kind.TRAILER && _loc_2.kind != Kind.TRUCK)
                    {
                        _loc_4.parentObj.addContact(param1);
                    }
                }
            }
            if (_loc_3 is EnemyWheel)
            {
                _loc_5 = _loc_3 as EnemyWheel;
                if (_loc_5.parentObj != null)
                {
                    if (_loc_2 != null && _loc_2.kind != Kind.TRAILER && _loc_2.kind != Kind.TRUCK)
                    {
                        _loc_5.parentObj.addContact(param1);
                    }
                }
            }
            if (_loc_2 is BasicObject && !param1.shape1.IsSensor())
            {
                _loc_2.addContact(param1);
            }
            if (_loc_3 is BasicObject && !param1.shape2.IsSensor())
            {
                _loc_3.addContact(param1);
            }
            if (_loc_2 is Bullet && !param1.shape2.IsSensor())
            {
                if (!_loc_2.isDead && _loc_3 != null)
                {
                    _loc_3.bulletCollision(_loc_2 as Bullet, param1.position);
                    (_loc_2 as Bullet).collision(param1.position, _loc_3);
                }
                else
                {
                    (_loc_2 as Bullet).collision(param1.position);
                }
            }
            if (_loc_3 is Bullet && !param1.shape1.IsSensor())
            {
                if (!_loc_3.isDead && _loc_2 != null)
                {
                    _loc_2.bulletCollision(_loc_3 as Bullet, param1.position);
                    (_loc_3 as Bullet).collision(param1.position, _loc_2);
                }
                else
                {
                    (_loc_3 as Bullet).collision(param1.position);
                }
            }
            if (_loc_2 is IBullet && !param1.shape2.IsSensor())
            {
                if (_loc_3 is Barrel && (_loc_3 as Barrel).kind == Kind.BARREL_EXPLOSION)
                {
                    (_loc_3 as Barrel).bulletCollision(null, param1.position);
                }
                (_loc_2 as IBullet).collision(param1.position, _loc_3);
            }
            else if (_loc_3 is IBullet && !param1.shape1.IsSensor())
            {
                if (_loc_2 is Barrel && (_loc_2 as Barrel).kind == Kind.BARREL_EXPLOSION)
                {
                    (_loc_2 as Barrel).bulletCollision(null, param1.position);
                }
                (_loc_3 as IBullet).collision(param1.position, _loc_2);
            }
            return;
        }// end function

        override public function Remove(param1:b2ContactPoint) : void
        {
            var _loc_4:EnemyWheel = null;
            var _loc_5:EnemyWheel = null;
            var _loc_2:* = param1.shape1.GetBody().GetUserData();
            var _loc_3:* = param1.shape2.GetBody().GetUserData();
            if (_loc_2 is EnemyWheel)
            {
                _loc_4 = _loc_2 as EnemyWheel;
                if (_loc_4.parentObj != null)
                {
                    _loc_4.parentObj.removeContact(param1);
                }
            }
            if (_loc_3 is EnemyWheel)
            {
                _loc_5 = _loc_3 as EnemyWheel;
                if (_loc_5.parentObj != null)
                {
                    _loc_5.parentObj.removeContact(param1);
                }
            }
            if (_loc_2 is BasicObject)
            {
                _loc_2.removeContact(param1);
            }
            if (_loc_3 is BasicObject)
            {
                _loc_3.removeContact(param1);
            }
            return;
        }// end function

        override public function Persist(param1:b2ContactPoint) : void
        {
            var _loc_2:* = param1.shape1.GetBody().GetUserData();
            var _loc_3:* = param1.shape2.GetBody().GetUserData();
            if (_loc_2 is PlayerWheel && !param1.shape2.IsSensor() || _loc_3 is PlayerWheel && !param1.shape1.IsSensor())
            {
                this._universe.player.addContact(param1);
            }
            if (_loc_2 != null && _loc_3 != null)
            {
                if (param1.shape1.IsSensor())
                {
                    _loc_2.addSensorContact(_loc_3);
                }
                if (param1.shape2.IsSensor())
                {
                    _loc_3.addSensorContact(_loc_2);
                }
            }
            return;
        }// end function

        override public function Result(param1:b2ContactResult) : void
        {
            return;
        }// end function

    }
}
