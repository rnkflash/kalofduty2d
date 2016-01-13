package com.zombotron.objects
{
    import com.antkarlov.anim.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;

    public class DoorButton extends BasicObject implements IActiveObject
    {
        private var _arrow:Animation;
        private var _alias:String;
        private var _isAction:Boolean = false;
        private var _isPushed:Boolean = false;
        public var targetAlias:String;
        public static const CACHE_NAME:String = "DoorButtons";

        public function DoorButton()
        {
            this.targetAlias = "null";
            this._alias = "nonameBasicDoor";
            _kind = Kind.BUTTON;
            _layer = Universe.LAYER_BG_OBJECTS;
            _sprite = $.animCache.getAnimation(Art.BUTTON);
            this._arrow = $.animCache.getAnimation(Art.ACTIVE_ELEMENT);
            return;
        }// end function

        public function changeState() : void
        {
            this._isPushed = !this._isPushed;
            if (this._isPushed)
            {
                _sprite.gotoAndStop(2);
            }
            else
            {
                _sprite.gotoAndStop(1);
            }
            return;
        }// end function

        public function set isPushed(param1:Boolean) : void
        {
            this._isPushed = param1;
            return;
        }// end function

        public function get activateDistance() : int
        {
            return 2;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            if (this._isPushed)
            {
                _sprite.gotoAndStop(2);
            }
            else
            {
                _sprite.gotoAndStop(1);
            }
            addChild(_sprite);
            _universe.objects.add(this);
            this._arrow.x = -1;
            this._arrow.y = -35;
            addChild(this._arrow);
            this._arrow.play();
            this._isAction = false;
            reset();
            show();
            x = param1;
            y = param2;
            return;
        }// end function

        private function onCallBack() : void
        {
            this._isAction = false;
            addChild(this._arrow);
            return;
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
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
                _universe.cacheStorage.setInstance(CACHE_NAME, this);
                _universe.objects.remove(this);
                this._arrow.stop();
                if (contains(this._arrow))
                {
                    removeChild(this._arrow);
                }
                super.free();
            }
            return;
        }// end function

        override public function process() : void
        {
            _tileX = this.x / LevelBase.TILE_SIZE;
            _tileY = this.y / LevelBase.TILE_SIZE;
            if (_tileX >= _universe.level.tileX1 && _tileX < _universe.level.tileX2 && _tileY >= _universe.level.tileY1 && _tileY < _universe.level.tileY2)
            {
                show();
            }
            else
            {
                hide();
            }
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector(x / Universe.DRAW_SCALE, y / Universe.DRAW_SCALE);
        }// end function

        override public function toString() : String
        {
            return "{DoorButton [alias: " + this._alias + ", targetAlias: " + this.targetAlias + ", isPushed: " + this._isPushed.toString() + "]}";
        }// end function

        public function action(param1:Function = null) : void
        {
            if (this.targetAlias != "" && !this._isAction)
            {
                this._isAction = true;
                removeChild(this._arrow);
                _universe.objects.callAction(this.targetAlias, this.onCallBack, this._alias);
                ZG.sound(SoundManager.ACTION_PRESS_BUTTON, this, true);
                this.changeState();
            }
            return;
        }// end function

        public static function get() : DoorButton
        {
            return ZG.universe.cacheStorage.getInstance(CACHE_NAME) as DoorButton;
        }// end function

    }
}
