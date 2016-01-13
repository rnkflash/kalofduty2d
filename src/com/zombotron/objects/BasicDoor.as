package com.zombotron.objects
{
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.interfaces.*;

    public class BasicDoor extends BasicObject implements IActiveObject
    {
        public var callbackAlias:String;
        private var _doorTop:BasicDoorPart;
        private var _alias:String;
        public var isOpen:Boolean;
        private var _doorBottom:BasicDoorPart;
        private var _callback:Function;
        private var _isAction:Boolean;
        private var _tm:TaskManager;

        public function BasicDoor()
        {
            this.isOpen = false;
            this.callbackAlias = "null";
            this._alias = "";
            _kind = Kind.DOOR;
            _sprite = ZG.animCache.getAnimation(Art.STATIC_FLASHER);
            _layer = Universe.LAYER_FG_EFFECTS;
            this._tm = new TaskManager();
            return;
        }// end function

        public function changeState() : void
        {
            return;
        }// end function

        override public function toString() : String
        {
            return "{BasicDoor [alias: " + this._alias + ", isOpen: " + this.isOpen.toString() + " , callbackAlias: " + this.callbackAlias + "]}";
        }// end function

        override public function render() : void
        {
            visibleCulling();
            return;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            this.x = param1;
            this.y = param2;
            _sprite.x = -1;
            _sprite.y = -64;
            this._doorTop = new BasicDoorPart();
            this._doorTop.isOpen = this.isOpen;
            this._doorTop.variety = BasicDoorPart.TOP;
            this._doorTop.init(param1, param2);
            this._doorBottom = new BasicDoorPart();
            this._doorBottom.isOpen = this.isOpen;
            this._doorBottom.variety = BasicDoorPart.BOTTOM;
            this._doorBottom.init(param1, param2);
            this._isAction = false;
            reset();
            show();
            _universe.objects.add(this);
            return;
        }// end function

        public function get activateDistance() : int
        {
            return -1;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                this._callback = null;
                this._tm.clear();
                _universe.objects.remove(this);
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
                    if (this._callback != null)
                    {
                        (this._callback as Function).apply(this);
                    }
                    this._isAction = false;
                    return true;
                }
            }
            return false;
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

        public function get activatePoint() : Avector
        {
            return new Avector();
        }// end function

        private function onEnd() : void
        {
            this.isOpen = this._doorTop.isOpen;
            if (this.isOpen)
            {
                log(Art.TXT_DOOR_IS_OPENED);
            }
            else
            {
                log(Art.TXT_DOOR_IS_CLOSED);
            }
            this._tm.addTask(this.onOffFlasher);
            return;
        }// end function

        public function action(param1:Function = null) : void
        {
            if (this._isAction)
            {
                return;
            }
            _sprite.speed = 0.5;
            addChild(_sprite);
            _sprite.play();
            this._doorTop.action(this.onEnd);
            this._doorBottom.action(null);
            ZG.media.stop(SoundManager.ACTION_OPEN_DOOR);
            ZG.sound(SoundManager.ACTION_OPEN_DOOR, this, true);
            this._callback = param1;
            this._isAction = true;
            _universe.objects.callAction(this.callbackAlias, null, this._alias);
            return;
        }// end function

    }
}
