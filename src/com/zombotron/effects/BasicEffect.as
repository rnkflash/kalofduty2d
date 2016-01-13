package com.zombotron.effects
{
    import com.antkarlov.anim.*;
    import com.antkarlov.repositories.*;
    import com.zombotron.core.*;
    import com.zombotron.interfaces.*;
    import flash.display.*;
    import flash.events.*;

    public class BasicEffect extends Sprite implements IBasicEffect
    {
        protected var _sprite:Animation;
        protected var _universe:Universe;
        protected var _smooth:Boolean;
        protected var _cacheName:String;
        protected var _layer:int;
        protected var $:Global;
        protected var _isFree:Boolean;

        public function BasicEffect()
        {
            this.$ = Global.getInstance();
            this._universe = Universe.getInstance();
            this._cacheName = "";
            this._smooth = true;
            this._isFree = true;
            this._layer = Universe.LAYER_EFFECTS;
            return;
        }// end function

        public function free() : void
        {
            if (!this._isFree)
            {
                if (this._cacheName == "")
                {
                    trace("BasicEffect::free() - Object don\'t have a _cacheName.");
                    return;
                }
                this._universe.remove(this, this._layer);
                this._universe.cacheStorage.setInstance(this._cacheName, this);
                this._sprite.removeEventListener(Event.COMPLETE, this.completeHandler);
                removeChild(this._sprite);
                this._sprite.stop();
                this._isFree = true;
            }
            return;
        }// end function

        public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            if (this._sprite)
            {
                this._sprite.smoothing = this._smooth ? (this._universe.smoothing) : (false);
                this._sprite.x = param1;
                this._sprite.y = param2;
                this._sprite.rotation = param3;
                this._sprite.scaleX = param4;
                this._sprite.play();
                addChild(this._sprite);
                this._universe.add(this, this._layer);
            }
            this._isFree = false;
            this._sprite.addEventListener(Event.COMPLETE, this.completeHandler);
            return;
        }// end function

        protected function completeHandler(event:Event) : void
        {
            this.free();
            return;
        }// end function

        public function process() : void
        {
            return;
        }// end function

    }
}
