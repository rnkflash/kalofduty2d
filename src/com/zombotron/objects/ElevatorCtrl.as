package com.zombotron.objects
{
    import com.antkarlov.anim.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;

    public class ElevatorCtrl extends BasicObject implements IActiveObject
    {
        private var _arrow:Animation;
        private var _dir:uint;
        private var _alias:String;
        private var _isAction:Boolean;
        public var targetAlias:String;
        private static const DIR_DOWN:uint = 2;
        private static const DIR_LEFT:uint = 3;
        private static const DIR_RIGHT:uint = 4;
        private static const DIR_UP:uint = 1;

        public function ElevatorCtrl()
        {
            this.targetAlias = "null";
            this._alias = "nonameElevatorCtrl";
            this._dir = DIR_UP;
            _kind = Kind.VERTICAL_CONTROL;
            _layer = Universe.LAYER_BG_OBJECTS;
            _sprite = ZG.animCache.getAnimation(Art.ELEVATOR_CONTROL_SV);
            this._arrow = ZG.animCache.getAnimation(Art.ACTIVE_ELEMENT);
            return;
        }// end function

        public function changeState() : void
        {
            switch(_kind)
            {
                case Kind.VERTICAL_CONTROL:
                {
                    this._dir = this._dir == DIR_UP ? (DIR_DOWN) : (DIR_UP);
                    break;
                }
                case Kind.HORIZONTAL_CONTROL:
                {
                    this._dir = this._dir == DIR_LEFT ? (DIR_RIGHT) : (DIR_LEFT);
                    break;
                }
                default:
                {
                    break;
                }
            }
            switch(this._dir)
            {
                case DIR_UP:
                case DIR_LEFT:
                {
                    _sprite.gotoAndStop(1);
                    break;
                }
                case DIR_DOWN:
                case DIR_RIGHT:
                {
                    _sprite.gotoAndStop(2);
                    break;
                }
                default:
                {
                    break;
                }
            }
            this._isAction = false;
            return;
        }// end function

        public function action(param1:Function = null) : void
        {
            if (this.targetAlias != "" && !this._isAction)
            {
                this._isAction = true;
                ZG.sound(SoundManager.ACTION_PRESS_BUTTON, this, true);
                _universe.objects.callAction(this.targetAlias, null, this._alias);
            }
            return;
        }// end function

        public function get activateDistance() : int
        {
            return 1;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            switch(this._dir)
            {
                case DIR_UP:
                case DIR_LEFT:
                {
                    _sprite.gotoAndStop(1);
                    break;
                }
                case DIR_DOWN:
                case DIR_RIGHT:
                {
                    _sprite.gotoAndStop(2);
                    break;
                }
                default:
                {
                    break;
                }
            }
            addChild(_sprite);
            this._arrow.y = _kind == Kind.HORIZONTAL_CONTROL ? (-35) : (-45);
            addChild(this._arrow);
            this._arrow.play();
            _universe.objects.add(this);
            this._isAction = false;
            reset();
            show();
            this.x = param1;
            this.y = param2;
            return;
        }// end function

        public function set dir(param1:String) : void
        {
            switch(param1)
            {
                case "down":
                {
                    this._dir = DIR_DOWN;
                    break;
                }
                case "up":
                {
                    this._dir = DIR_UP;
                    break;
                }
                case "left":
                {
                    this._dir = DIR_LEFT;
                    break;
                }
                case "right":
                {
                    this._dir = DIR_RIGHT;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector(this.x / Universe.DRAW_SCALE, this.y / Universe.DRAW_SCALE);
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        override public function set kind(param1:uint) : void
        {
            if (_kind != param1)
            {
                _kind = param1;
                switch(_kind)
                {
                    case Kind.VERTICAL_CONTROL:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.ELEVATOR_CONTROL_SV);
                        break;
                    }
                    case Kind.HORIZONTAL_CONTROL:
                    {
                        _sprite = ZG.animCache.getAnimation(Art.ELEVATOR_CONTROL_SH);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        override public function toString() : String
        {
            var _loc_1:String = "undefined";
            switch(this._dir)
            {
                case DIR_UP:
                {
                    _loc_1 = "up";
                    break;
                }
                case DIR_DOWN:
                {
                    _loc_1 = "down";
                    break;
                }
                case DIR_LEFT:
                {
                    _loc_1 = "left";
                    break;
                }
                case DIR_RIGHT:
                {
                    _loc_1 = "right";
                    break;
                }
                default:
                {
                    break;
                }
            }
            return "{ElevatorCtrl [alias: " + this._alias + ", targetAlias: " + this.targetAlias + ", curDir: " + _loc_1 + "]}";
        }// end function

        override public function process() : void
        {
            _tileX = this.x / LevelBase.TILE_SIZE;
            _tileY = this.y / LevelBase.TILE_SIZE;
            if (_tileX >= _universe.level.tileX1 && _tileX < _universe.level.tileX2 && _tileY >= _universe.level.tileY1 && _tileY < _universe.level.tileY2)
            {
                show();
                this._arrow.play();
            }
            else
            {
                hide();
                this._arrow.stop();
            }
            return;
        }// end function

        public function get alias() : String
        {
            return this._alias;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.objects.remove(this);
                this._arrow.stop();
                removeChild(this._arrow);
                super.free();
            }
            return;
        }// end function

    }
}
