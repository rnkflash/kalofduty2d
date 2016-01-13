package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.zombotron.core.*;
    import com.zombotron.events.*;
    import com.zombotron.interfaces.*;

    public class TriggerPart extends BasicObject implements IPartOf, IEnemyObject
    {
        private var _height:int;
        private var _width:int;
        private var _hitPoint:b2Vec2;
        public var onDie:Function;
        public var partOf:BasicObject = null;
        public var allowDeath:Boolean;
        private var _hitForce:b2Vec2;

        public function TriggerPart()
        {
            this._hitForce = new b2Vec2();
            this._hitPoint = new b2Vec2();
            _kind = Kind.TRIGGER_PART;
            _isVisible = false;
            _visibleCulling = false;
            this.allowDeath = true;
            this.onDie = null;
            this._height = 10;
            this._width = 10;
            return;
        }// end function

        override public function die() : void
        {
            if (!_isDead)
            {
                if (this.onDie != null)
                {
                    (this.onDie as Function).apply(this, [this._hitForce, this._hitPoint]);
                }
                this.free();
                _isDead = true;
            }
            return;
        }// end function

        public function setSize(param1:int, param2:int) : void
        {
            this._width = param1;
            this._height = param2;
            return;
        }// end function

        public function get alertTime() : int
        {
            if (this.partOf != null && this.partOf is IEnemyObject)
            {
                return (this.partOf as IEnemyObject).alertTime;
            }
            return 0;
        }// end function

        override public function bulletCollision(param1:Bullet, param2:b2Vec2) : void
        {
            if (!_die)
            {
                this._hitPoint = new b2Vec2(param2.x, param2.y);
                this._hitForce = new b2Vec2(param1.body.GetLinearVelocity().x, param1.body.GetLinearVelocity().y);
                dispatchEvent(new BasicObjectEvent(BasicObjectEvent.BULLET_COLLISION, param1.damage));
                if (this.allowDeath)
                {
                    _universe.deads.add(this);
                    _die = true;
                }
            }
            return;
        }// end function

        public function get isAlert() : Boolean
        {
            if (this.partOf != null && this.partOf is IEnemyObject)
            {
                return (this.partOf as IEnemyObject).isAlert;
            }
            return false;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:* = new b2BodyDef();
            var _loc_6:* = new b2PolygonDef();
            _loc_6.density = 1;
            _loc_6.friction = 1;
            _loc_6.restitution = 0.1;
            _loc_6.filter.categoryBits = 2;
            _loc_6.filter.maskBits = 4;
            _loc_6.filter.groupIndex = 2;
            _loc_6.SetAsBox(this._width * 0.5 / Universe.DRAW_SCALE, this._height * 0.5 / Universe.DRAW_SCALE);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_5.userData = this;
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            reset();
            return;
        }// end function

        public function get alertId() : uint
        {
            if (this.partOf != null && this.partOf is IEnemyObject)
            {
                return (this.partOf as IEnemyObject).alertId;
            }
            return 0;
        }// end function

        override public function attacked(param1:b2Vec2, param2:b2Vec2, param3:Number = 1) : Boolean
        {
            if (!_die)
            {
                this._hitPoint = new b2Vec2(param1.x, param1.y);
                this._hitForce = new b2Vec2(param2.x, param2.y);
                dispatchEvent(new BasicObjectEvent(BasicObjectEvent.BULLET_COLLISION, param3));
                if (this.allowDeath)
                {
                    _universe.deads.add(this);
                    _die = true;
                }
            }
            return false;
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

        override public function addContact(param1:b2ContactPoint) : Boolean
        {
            if (_kind == Kind.ENEMY_BOSS && this.partOf != null)
            {
                return this.partOf.addContact(param1);
            }
            return super.addContact(param1);
        }// end function

    }
}
