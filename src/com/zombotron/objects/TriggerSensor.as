package com.zombotron.objects
{
    import com.antkarlov.debug.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.gui.*;
    import com.zombotron.interfaces.*;
    import com.zombotron.levels.*;

    public class TriggerSensor extends BasicObject implements IActiveObject
    {
        private var _bodyHeight:Number = 0;
        public var completeMission:String = "none";
        private var _interval:int = 0;
        public var musicTrack:String = "none";
        private var _isActive:Boolean = false;
        public var targetArea:String = "null";
        public var nextEntry:String = "null";
        private var _topLeft:Avector;
        private var _bodyWidth:Number = 0;
        public var targetAlias:String = "null";
        public var loops:int = 1;
        public var nextLevel:int = 0;
        private var _alias:String = "nonameTriggerSensor";
        private var _bottomRight:Avector;
        public var forceSwitch:Boolean = false;

        public function TriggerSensor()
        {
            this._topLeft = new Avector();
            this._bottomRight = new Avector();
            _kind = Kind.TRIGGER_SENSOR;
            _isVisible = false;
            _visibleCulling = false;
            return;
        }// end function

        public function get activateDistance() : int
        {
            return -1;
        }// end function

        override public function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void
        {
            this._topLeft.set(param1 / Universe.DRAW_SCALE - this._bodyWidth, param2 / Universe.DRAW_SCALE - this._bodyHeight);
            this._bottomRight.set(param1 / Universe.DRAW_SCALE + this._bodyWidth, param2 / Universe.DRAW_SCALE + this._bodyHeight);
            _universe.objects.add(this);
            reset();
            this._isActive = false;
            this.x = param1;
            this.y = param2;
            return;
        }// end function

        public function set alias(param1:String) : void
        {
            this._alias = param1;
            return;
        }// end function

        public function set bodyWidth(param1:Number) : void
        {
            this._bodyWidth = param1 * 0.5 / Universe.DRAW_SCALE;
            return;
        }// end function

        private function debugDraw() : void
        {
            if (ZG.debugMode)
            {
                _universe.layerDraws.graphics.lineStyle(1, _kind == Kind.TRIGGER_MUSIC ? (3394764) : (10470965), 0.8);
                _universe.layerDraws.graphics.beginFill(_kind == Kind.TRIGGER_MUSIC ? (3394764) : (10470965), 0.3);
                _universe.layerDraws.graphics.drawRect(this._topLeft.x * Universe.DRAW_SCALE, this._topLeft.y * Universe.DRAW_SCALE, (this._bottomRight.x - this._topLeft.x) * Universe.DRAW_SCALE, (this._bottomRight.y - this._topLeft.y) * Universe.DRAW_SCALE);
                _universe.layerDraws.graphics.endFill();
            }
            return;
        }// end function

        public function action(param1:Function = null) : void
        {
            if (!this._isActive)
            {
                switch(_kind)
                {
                    case Kind.TRIGGER_SENSOR:
                    {
                        _universe.objects.callAction(this.targetArea, null, this._alias);
                        _universe.objects.callAction(this.targetAlias, null, this._alias);
                        this.callCompleteMission(this.completeMission);
                        break;
                    }
                    case Kind.TRIGGER_EXIT:
                    {
                        if ($.domain != "armorgames.com")
                        {
                            $.trace("Error: can\'t load next level.", Console.FORMAT_ERROR);
                            return;
                        }
                        _universe.completeLevel(this.nextLevel, this.nextEntry);
                        break;
                    }
                    case Kind.TRIGGER_KILL:
                    {
                        _universe.player.fatalFall = true;
                        break;
                    }
                    case Kind.TRIGGER_MUSIC:
                    {
                        ZG.media.addMusicTrack(this.musicTrack, this.forceSwitch, this.loops);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this.free();
                this._isActive = true;
            }
            return;
        }// end function

        public function changeState() : void
        {
            return;
        }// end function

        public function set bodyHeight(param1:Number) : void
        {
            this._bodyHeight = param1 * 0.5 / Universe.DRAW_SCALE;
            return;
        }// end function

        public function callCompleteMission(param1:String) : void
        {
            if (param1 == "none")
            {
                return;
            }
            switch(param1)
            {
                case "missionTime":
                {
                    ZG.playerGui.missionComplete(LevelBase.MISSION_TIME);
                    break;
                }
                case "missionSilent":
                {
                    ZG.playerGui.missionComplete(LevelBase.MISSION_SILENT);
                    break;
                }
                case "missionZombie":
                {
                    _universe.checkAchievement(AchievementItem.CAREFUL);
                    break;
                }
                default:
                {
                    $.trace("Mission \"" + param1 + "\" not supported.");
                    break;
                    break;
                }
            }
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

        override public function toString() : String
        {
            return "{TriggerSensor [alias: " + this._alias + ", targetAlias: " + this.targetAlias + ", targetArea: " + this.targetArea + "]}";
        }// end function

        override public function process() : void
        {
            var _loc_1:Avector = null;
            if (!this._isActive)
            {
                if (this._interval > 5)
                {
                    _loc_1 = new Avector(_universe.playerBody.GetPosition().x, _universe.playerBody.GetPosition().y);
                    if (_loc_1.x > this._topLeft.x && _loc_1.y > this._topLeft.y && _loc_1.x < this._bottomRight.x && _loc_1.y < this._bottomRight.y)
                    {
                        this.action();
                    }
                    this._interval = 0;
                }
                var _loc_2:String = this;
                var _loc_3:* = this._interval + 1;
                _loc_2._interval = _loc_3;
                this.debugDraw();
            }
            return;
        }// end function

        override public function free() : void
        {
            if (!_isFree)
            {
                _universe.objects.remove(this);
                super.free();
            }
            return;
        }// end function

    }
}
