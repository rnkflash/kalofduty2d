package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.zombotron.core.*;
    import com.zombotron.interfaces.*;

    public class EnemyWheel extends BasicObject implements IPartOf
    {
        public var parentObj:IBasicObject = null;
        public static const BOSS:uint = 2;
        public static const BASIC:uint = 1;

        public function EnemyWheel()
        {
            _kind = Kind.ENEMY_WHEEL;
            _variety = BASIC;
            _isVisible = false;
            _visibleCulling = false;
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_6:b2CircleDef = null;
            var _loc_5:* = new b2BodyDef();
            _loc_6 = new b2CircleDef();
            _loc_6.radius = _variety == BOSS ? (1.05) : (0.4);
            _loc_6.density = 0.5;
            _loc_6.friction = 10;
            _loc_6.restitution = 0;
            _loc_6.filter.categoryBits = 2;
            _loc_6.filter.maskBits = 4;
            _loc_6.filter.groupIndex = 2;
            _loc_5 = new b2BodyDef();
            _loc_5.userData = this;
            _loc_5.allowSleep = false;
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            _isFree = false;
            return;
        }// end function

        public function SetAsSensor(param1:Boolean) : void
        {
            var _loc_2:* = _body.m_shapeList;
            while (_loc_2)
            {
                
                _loc_2.m_isSensor = param1;
                _loc_2 = _loc_2.m_next;
            }
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.physics.DestroyBody(_body);
                super.free();
            }
            return;
        }// end function

        override public function attacked(param1:b2Vec2, param2:b2Vec2, param3:Number = 1) : Boolean
        {
            return this.parentObj != null ? (this.parentObj.attacked(param1, param2, param3)) : (false);
        }// end function

        override public function bulletCollision(param1:Bullet, param2:b2Vec2) : void
        {
            if (this.parentObj != null)
            {
                this.parentObj.bulletCollision(param1, param2);
            }
            return;
        }// end function

    }
}
