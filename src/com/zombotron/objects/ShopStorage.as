package com.zombotron.objects
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.helpers.*;
    import com.zombotron.interfaces.*;

    public class ShopStorage extends BasicObject implements IActiveObject
    {
        public var callbackAlias:String = "null";
        private var _doorRight:b2Body;
        private var _alias:String = "nonameShopStorage";
        private var _tm:TaskManager;
        private var _isAction:Boolean;
        private var _jointRight:b2RevoluteJoint;
        private var _jointLeft:b2RevoluteJoint;
        private var _doorLeft:b2Body;

        public function ShopStorage()
        {
            _kind = Kind.SHOP_STORAGE;
            _sprite = ZG.animCache.getAnimation(Art.STATIC_FLASHER);
            _layer = Universe.LAYER_FG_EFFECTS;
            this._tm = new TaskManager();
            return;
        }// end function

        public function changeState() : void
        {
            return;
        }// end function

        private function onOpenGateway() : Boolean
        {
            ZG.sound(SoundManager.DROP_ITEMS, this, true);
            this._jointLeft.SetMotorSpeed(-5);
            this._jointRight.SetMotorSpeed(5);
            this._doorLeft.WakeUp();
            this._doorRight.WakeUp();
            return true;
        }// end function

        public function get alias() : String
        {
            return this._alias;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:b2BodyDef = null;
            var _loc_6:b2PolygonDef = null;
            var _loc_7:b2Vec2 = null;
            var _loc_10:ShopStoragePart = null;
            this.x = param1;
            this.y = param2;
            _loc_5 = new b2BodyDef();
            _loc_6 = new b2PolygonDef();
            _loc_7 = new b2Vec2();
            _loc_6.density = 0.8;
            _loc_6.friction = 0.01;
            _loc_6.restitution = 0.1;
            _loc_6.filter.categoryBits = 4;
            _loc_5.position.Set(param1 / Universe.DRAW_SCALE, param2 / Universe.DRAW_SCALE);
            _loc_7.x = -30 / Universe.DRAW_SCALE;
            _loc_7.y = 0;
            _loc_6.SetAsOrientedBox(4 / Universe.DRAW_SCALE, 35 / Universe.DRAW_SCALE, _loc_7, 0);
            _loc_5.userData = this;
            _body = _universe.physics.CreateBody(_loc_5);
            _body.CreateShape(_loc_6);
            _loc_7.x = 30 / Universe.DRAW_SCALE;
            _loc_6.SetAsOrientedBox(4 / Universe.DRAW_SCALE, 35 / Universe.DRAW_SCALE, _loc_7, 0);
            _body.CreateShape(_loc_6);
            var _loc_8:* = new ShopStoragePart();
            _loc_8.init(param1 - 16, param2 + 32);
            this._doorLeft = _loc_8.body;
            var _loc_9:* = new b2RevoluteJointDef();
            _loc_9.lowerAngle = Amath.toRadians(-100);
            _loc_9.upperAngle = Amath.toRadians(-25);
            _loc_9.enableLimit = true;
            _loc_9.enableMotor = true;
            _loc_9.maxMotorTorque = 10;
            _loc_9.motorSpeed = 10;
            _loc_7 = _loc_8.body.GetWorldCenter();
            _loc_7.x = _loc_7.x - 10 / Universe.DRAW_SCALE;
            _loc_9.Initialize(_loc_8.body, _body, _loc_7);
            this._jointLeft = _universe.physics.CreateJoint(_loc_9) as b2RevoluteJoint;
            _loc_10 = new ShopStoragePart();
            _loc_10.variety = ShopStoragePart.RIGHT_PART;
            _loc_10.init(param1 + 16, param2 + 32);
            this._doorRight = _loc_10.body;
            _loc_9.lowerAngle = Amath.toRadians(25);
            _loc_9.upperAngle = Amath.toRadians(100);
            _loc_9.motorSpeed = -10;
            _loc_7 = _loc_10.body.GetWorldCenter();
            _loc_7.x = _loc_7.x + 10 / Universe.DRAW_SCALE;
            _loc_9.Initialize(_loc_10.body, _body, _loc_7);
            this._jointRight = _universe.physics.CreateJoint(_loc_9) as b2RevoluteJoint;
            this._isAction = false;
            _isVisible = false;
            show();
            _universe.objects.add(this);
            return;
        }// end function

        override public function render() : void
        {
            visibleCulling();
            return;
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        public function get activateDistance() : int
        {
            return -1;
        }// end function

        private function onCloseGateway() : Boolean
        {
            this._jointLeft.SetMotorSpeed(5);
            this._jointRight.SetMotorSpeed(-5);
            this._doorLeft.WakeUp();
            this._doorRight.WakeUp();
            return true;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.objects.remove(this);
                _universe.physics.DestroyBody(_body);
                this._tm.clear();
                super.free();
            }
            return;
        }// end function

        private function onOffFlasher() : Boolean
        {
            if (contains(_sprite))
            {
                _sprite.alpha = _sprite.alpha - 0.2;
                if (_sprite.alpha <= 0)
                {
                    _sprite.stop();
                    removeChild(_sprite);
                    _sprite.alpha = 1;
                    this._isAction = false;
                    _universe.objects.callAction(this.callbackAlias, null, this._alias);
                    return true;
                }
            }
            return false;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector();
        }// end function

        public function action(param1:Function = null) : void
        {
            var _loc_2:ShopBox = null;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            if (!this._isAction)
            {
                _loc_2 = new ShopBox();
                if (param1 != null)
                {
                    _loc_2 = (param1 as Function).apply(this);
                    _loc_3 = _loc_2.size;
                    _loc_4 = 0;
                    while (_loc_4 < _loc_3)
                    {
                        
                        _universe.makeCollectableItem(_loc_2.getItemKind(_loc_4), _loc_2.getItemQuantity(_loc_4), this.x, this.y);
                        _loc_4 = _loc_4 + 1;
                    }
                }
                _sprite.speed = 0.5;
                addChild(_sprite);
                _sprite.play();
                this._tm.addPause(10);
                this._tm.addTask(this.onOpenGateway);
                this._tm.addPause(40);
                this._tm.addTask(this.onCloseGateway);
                this._tm.addPause(10);
                this._tm.addTask(this.onOffFlasher);
                this._isAction = true;
            }
            return;
        }// end function

    }
}
