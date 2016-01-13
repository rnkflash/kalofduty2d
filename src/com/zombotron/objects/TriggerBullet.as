package com.zombotron.objects
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;

    public class TriggerBullet extends BasicObject implements IActiveObject
    {
        private var _topLeft:Avector;
        private var _bodyWidth:Number;
        private var _isActive:Boolean;
        private var _bodyHeight:Number;
        private var _alias:String;
        private var _bottomRight:Avector;
        public var targetAlias:String;

        public function TriggerBullet()
        {
            _kind = Kind.TRIGGER_BULLET;
            _sprite = $.animCache.getAnimation(Art.ATTACK_HINT);
            _layer = Universe.LAYER_MAIN_FG;
            _visibleCulling = false;
            this.targetAlias = "null";
            this._alias = "nonameTriggerBullet";
            this._bodyWidth = 0;
            this._bodyHeight = 0;
            this._topLeft = new Avector();
            this._bottomRight = new Avector();
            return;
        }// end function

        public function changeState() : void
        {
            return;
        }// end function

        public function set bodyWidth(param1:Number) : void
        {
            this._bodyWidth = param1 * 0.5 / Universe.DRAW_SCALE;
            return;
        }// end function

        public function get activateDistance() : int
        {
            return -1;
        }// end function

        public function set bodyHeight(param1:Number) : void
        {
            this._bodyHeight = param1 * 0.5 / Universe.DRAW_SCALE;
            return;
        }// end function

        override public function process() : void
        {
            _tileX = this.x / LevelBase.TILE_SIZE;
            _tileY = this.y / LevelBase.TILE_SIZE;
            if (_tileX >= _universe.level.tileX1 && _tileX < _universe.level.tileX2 && _tileY >= _universe.level.tileY1 && _tileY < _universe.level.tileY2)
            {
                _sprite.play();
                show();
            }
            else
            {
                _sprite.stop();
                hide();
            }
            this.debugDraw();
            return;
        }// end function

        public function get activatePoint() : Avector
        {
            return new Avector();
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            this._topLeft.set(param1 / Universe.DRAW_SCALE - this._bodyWidth, param2 / Universe.DRAW_SCALE - this._bodyHeight);
            this._bottomRight.set(param1 / Universe.DRAW_SCALE + this._bodyWidth, param2 / Universe.DRAW_SCALE + this._bodyHeight);
            reset();
            show();
            this.x = param1;
            this.y = param2;
            addChild(_sprite);
            _sprite.play();
            _universe.triggers.add(this);
            _universe.objects.add(this);
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
                _universe.triggers.remove(this);
                _universe.objects.remove(this);
                super.free();
            }
            return;
        }// end function

        public function get bottomRight() : Avector
        {
            return this._bottomRight;
        }// end function

        public function action(param1:Function = null) : void
        {
            if (!this._isActive)
            {
                _universe.objects.callAction(this.targetAlias, null, this._alias);
                this._isActive = true;
                this.free();
            }
            return;
        }// end function

        private function debugDraw() : void
        {
            if (ZG.debugMode)
            {
                _universe.layerDraws.graphics.lineStyle(1, 10470965, 0.8);
                _universe.layerDraws.graphics.beginFill(10470965, 0.3);
                _universe.layerDraws.graphics.drawRect(this._topLeft.x * Universe.DRAW_SCALE, this._topLeft.y * Universe.DRAW_SCALE, (this._bottomRight.x - this._topLeft.x) * Universe.DRAW_SCALE, (this._bottomRight.y - this._topLeft.y) * Universe.DRAW_SCALE);
                _universe.layerDraws.graphics.endFill();
            }
            return;
        }// end function

        public function get topLeft() : Avector
        {
            return this._topLeft;
        }// end function

    }
}
