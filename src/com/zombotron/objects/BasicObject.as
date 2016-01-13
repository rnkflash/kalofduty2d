package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.anim.*;
    import com.antkarlov.math.*;
    import com.antkarlov.repositories.*;
    import com.zombotron.core.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;
    import flash.display.*;

    public class BasicObject extends Sprite implements IBasicObject
    {
        protected var _variety:uint = 0;
        protected var _senseContacts:Array;
        public var oldVelocity:b2Vec2;
        protected var _uniqueId:int = 0;
        protected var $:Global;
        protected var _allowSensing:Boolean = false;
        protected var _layer:int = 2;
        protected var _isVisible:Boolean = true;
        protected var _tileX:int = 0;
        protected var _tileY:int = 0;
        protected var _visibleCulling:Boolean = true;
        public var group:uint = 1000;
        protected var _body:b2Body;
        protected var _position:Avector;
        protected var _health:Number = 1;
        protected var _kind:uint = 0;
        protected var _damage:Number = 0.4;
        protected var _universe:Universe;
        protected var _birthTime:int = 0;
        protected var _contacts:Array;
        protected var _allowContacts:Boolean = false;
        protected var _die:Boolean = false;
        protected var _isDead:Boolean = false;
        protected var _isFree:Boolean = false;
        protected var _sprite:Animation;
        static var _id:int = 1;

        public function BasicObject()
        {
            this.$ = Global.getInstance();
            this._universe = Universe.getInstance();
            this._position = new Avector();
            this._contacts = [];
            this._senseContacts = [];
            this._birthTime = this._universe.frameTime;
            this._uniqueId = _id;
            var _loc_2:* = _id + 1;
            _id = _loc_2;
            return;
        }// end function

        public function hitEffect(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
        {
            return false;
        }// end function

        public function jointDead(param1:b2RevoluteJoint = null) : void
        {
            return;
        }// end function

        public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            return;
        }// end function

        public function set parentObject(param1:BasicObject) : void
        {
            return;
        }// end function

        public function set kind(param1:uint) : void
        {
            this._kind = param1;
            return;
        }// end function

        public function addContact(param1:b2ContactPoint) : Boolean
        {
            if (this._allowContacts)
            {
                if (this._contacts.indexOf(param1) == -1)
                {
                    this._contacts[this._contacts.length] = param1;
                    return true;
                }
            }
            return false;
        }// end function

        public function hide() : void
        {
            if (this._isVisible)
            {
                this._universe.remove(this, this._layer);
                this._isVisible = false;
            }
            return;
        }// end function

        protected function log(param1:String) : void
        {
            ZG.playerGui.gameConsole.log(param1);
            return;
        }// end function

        protected function reset() : void
        {
            this._contacts.length = 0;
            this._senseContacts.length = 0;
            this._birthTime = this._universe.frameTime;
            this._isVisible = false;
            this._isFree = false;
            this._isDead = false;
            this._die = false;
            return;
        }// end function

        public function bulletCollision(param1:Bullet, param2:b2Vec2) : void
        {
            return;
        }// end function

        public function set isDead(param1:Boolean) : void
        {
            this._isDead = param1;
            return;
        }// end function

        public function visibleCulling() : void
        {
            if (this._visibleCulling && this._body != null)
            {
                this._tileX = this._body.GetPosition().x * Universe.DRAW_SCALE / LevelBase.TILE_SIZE;
                this._tileY = this._body.GetPosition().y * Universe.DRAW_SCALE / LevelBase.TILE_SIZE;
                if (this._tileX >= this._universe.level.tileX1 && this._tileX < this._universe.level.tileX2 && this._tileY >= this._universe.level.tileY1 && this._tileY < this._universe.level.tileY2)
                {
                    this.show();
                }
                else
                {
                    this.hide();
                }
            }
            return;
        }// end function

        public function get variety() : uint
        {
            return this._variety;
        }// end function

        public function free() : void
        {
            if (this._sprite != null)
            {
                if (this._sprite.playing)
                {
                    this._sprite.stop();
                }
                if (contains(this._sprite))
                {
                    removeChild(this._sprite);
                }
            }
            this.hide();
            this._isFree = true;
            return;
        }// end function

        public function process() : void
        {
            if (this._body != null)
            {
                this._position.x = this._body.GetPosition().x * Universe.DRAW_SCALE;
                this._position.y = this._body.GetPosition().y * Universe.DRAW_SCALE;
            }
            return;
        }// end function

        public function get damage() : Number
        {
            return 0;
        }// end function

        public function die() : void
        {
            return;
        }// end function

        public function fatalDamage(param1:b2Vec2, param2:b2Vec2) : void
        {
            return;
        }// end function

        public function get kind() : uint
        {
            return this._kind;
        }// end function

        public function render() : void
        {
            this.visibleCulling();
            if (this._isVisible)
            {
                this.update();
            }
            return;
        }// end function

        public function set variety(param1:uint) : void
        {
            this._variety = param1;
            return;
        }// end function

        public function get body() : b2Body
        {
            return this._body;
        }// end function

        public function get isDead() : Boolean
        {
            return this._isDead;
        }// end function

        public function get sprite() : Animation
        {
            return this._sprite;
        }// end function

        protected function update() : void
        {
            x = this._body.GetPosition().x * Universe.DRAW_SCALE;
            y = this._body.GetPosition().y * Universe.DRAW_SCALE;
            rotation = this._body.GetAngle() / Math.PI * 180 % 360;
            return;
        }// end function

        public function get uniqueId() : int
        {
            return this._uniqueId;
        }// end function

        public function explode(param1:BasicObject, param2:b2Vec2, param3:b2Vec2) : Boolean
        {
            return false;
        }// end function

        public function removeSensorContact(param1:BasicObject) : Boolean
        {
            var _loc_2:int = 0;
            if (this._allowSensing && param1 != null)
            {
                _loc_2 = this._senseContacts.indexOf(param1);
                if (_loc_2 > -1)
                {
                    this._senseContacts[_loc_2] = null;
                    this._senseContacts.splice(_loc_2, 1);
                    return true;
                }
            }
            return false;
        }// end function

        public function attacked(param1:b2Vec2, param2:b2Vec2, param3:Number = 1) : Boolean
        {
            return false;
        }// end function

        public function addSensorContact(param1:BasicObject) : Boolean
        {
            if (this._allowSensing && param1 != null)
            {
                if (this._senseContacts.indexOf(param1) == -1)
                {
                    this._senseContacts[this._senseContacts.length] = param1;
                    return true;
                }
            }
            return false;
        }// end function

        public function removeContact(param1:b2ContactPoint) : Boolean
        {
            var _loc_2:int = 0;
            if (this._allowContacts)
            {
                _loc_2 = this._contacts.indexOf(param1);
                if (_loc_2 > -1)
                {
                    this._contacts[_loc_2] = null;
                    this._contacts.splice(_loc_2, 1);
                    return true;
                }
            }
            return false;
        }// end function

        public function show() : void
        {
            if (!this._isVisible)
            {
                this._universe.add(this, this._layer);
                this._isVisible = true;
            }
            return;
        }// end function

    }
}
