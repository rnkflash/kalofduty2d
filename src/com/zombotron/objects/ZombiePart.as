package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.helpers.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;

    public class ZombiePart extends BasicObject implements IItemObject
    {
        private var _isCollected:Boolean = false;
        private var _collectable:Boolean = false;
        private var _height:Number = 10;
        private var _width:Number = 10;
        private var _lifeTime:int;
        private var _tm:TaskManager;
        private var _color:int = 1;
        public static const HEAD:int = 3;
        public static const BODY:int = 0;
        public static const CACHE_NAME:String = "ZombieParts";
        public static const LEG_RIGHT:int = 6;
        public static const HAND_RIGHT:int = 15;
        public static const HELMET:int = 18;
        public static const LEG_LEFT:int = 9;
        public static const HAND_LEFT:int = 12;

        public function ZombiePart()
        {
            this._tm = new TaskManager();
            _kind = Kind.ZOMBIE_PART;
            _sprite = ZG.animCache.getAnimation(Art.ZOMBIE_PARTS);
            return;
        }// end function

        public function setSize(param1:Number, param2:Number) : void
        {
            this._width = param1 * 0.5;
            this._height = param2 * 0.5;
            return;
        }// end function

        override public function hitEffect(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
        {
            var _loc_5:EffectHitTo = null;
            if (_variety == HELMET)
            {
                _loc_5 = EffectHitTo.get();
                _loc_5.variety = EffectHitTo.METAL;
                _loc_5.init(param1, param2, param3, param4);
                ZG.sound(SoundManager.HIT_TO_ROBOT, this, true);
                return true;
            }
            return false;
        }// end function

        public function set color(param1:int) : void
        {
            this._color = param1;
            return;
        }// end function

        override public function jointDead(param1:b2RevoluteJoint = null) : void
        {
            var _loc_2:b2Vec2 = null;
            if (_variety == HEAD)
            {
                _loc_2 = _body.GetLinearVelocity();
                _loc_2.x = _loc_2.x * 0.02;
                _body.ApplyImpulse(new b2Vec2(_loc_2.x, -1), _body.GetWorldCenter());
                _body.SetAngularVelocity(_body.GetAngularVelocity() * 0.2);
                this.makeBloodFountain(_body, 3);
            }
            else
            {
                this.makeBloodFountain(_body, 1);
            }
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_6:b2PolygonDef = null;
            var _loc_5:* = new b2BodyDef();
            _loc_6 = new b2PolygonDef();
            _loc_6.density = 0.5;
            _loc_6.friction = 0.8;
            _loc_6.restitution = 0.1;
            _loc_6.filter.groupIndex = -2;
            _loc_5.userData = this;
            _loc_6.SetAsBox(this._width / Universe.DRAW_SCALE, this._height / Universe.DRAW_SCALE);
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_5.angle = Amath.toRadians(param3);
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _body.SetMassFromShapes();
            _sprite.gotoAndStop(_variety + this._color);
            _sprite.scaleX = param4;
            _sprite.smoothing = _universe.smoothing;
            _sprite.alpha = 1;
            addChild(_sprite);
            this._isCollected = false;
            reset();
            this._lifeTime = 250;
            this._tm.clear();
            if (ZG.playerGui.isHaveMission(LevelBase.MISSION_ZOMBIE) && variety == HEAD)
            {
                this._collectable = true;
                _universe.items.add(this);
            }
            else
            {
                this._collectable = false;
            }
            _universe.bodies.add(this);
            update();
            return;
        }// end function

        private function makeBloodFountain(param1:b2Body, param2:uint = 5) : void
        {
            var _loc_3:uint = 0;
            while (_loc_3 < param2)
            {
                
                this._tm.addTask(this.taskMakeBlood, [param1]);
                this._tm.addPause(2);
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        private function taskMakeBlood(param1:b2Body) : Boolean
        {
            var _loc_2:* = EffectBlood.get();
            _loc_2.init(param1.GetPosition().x * Universe.DRAW_SCALE, param1.GetPosition().y * Universe.DRAW_SCALE);
            return true;
        }// end function

        public function collect() : void
        {
            var _loc_1:EffectCollectableItem = null;
            if (!this._isCollected && ZG.playerGui.isHaveMission(LevelBase.MISSION_ZOMBIE))
            {
                _loc_1 = EffectCollectableItem.get();
                _loc_1.variety = ShopBox.ITEM_HEAD_ZOMBIE;
                _loc_1.init(this.x, this.y, this.rotation);
                _loc_1.angle = -45;
                _loc_1.color = this._color - 1;
                this._isCollected = true;
                this.free();
            }
            return;
        }// end function

        override public function process() : void
        {
            if (_universe.frameTime - _birthTime >= this._lifeTime)
            {
                _sprite.alpha = _sprite.alpha - 0.02;
                if (_sprite.alpha <= 0)
                {
                    _sprite.alpha = 0;
                    this.free();
                }
            }
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.bodies.remove(this);
                _universe.physics.DestroyBody(_body);
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                if (this._collectable)
                {
                    _universe.items.remove(this);
                }
                super.free();
            }
            return;
        }// end function

        public static function get() : ZombiePart
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as ZombiePart;
        }// end function

    }
}
