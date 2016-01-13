package com.zombotron.objects
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.gui.*;
    import com.zombotron.interfaces.*;
    import flash.display.*;
    import flash.text.*;

    public class BasicEnemy extends BasicObject
    {
        protected var _visionList:Array;
        protected var _profiler:Sprite;
        protected var _profilerText:TextField;
        protected var _hitPoint:b2Vec2;
        protected var _raycastList:Array;
        protected var _curAnim:String = "";
        protected var _hitForce:b2Vec2;
        protected var _dustTime:int;

        public function BasicEnemy()
        {
            this._visionList = [];
            this._raycastList = [];
            this._hitPoint = new b2Vec2();
            this._hitForce = new b2Vec2();
            return;
        }// end function

        protected function seeToPoint(param1:b2Vec2, param2:Number = 0, param3:Number = 0.5) : BasicObject
        {
            var _loc_8:b2Body = null;
            var _loc_4:* = new b2Segment();
            _loc_4.p1 = new b2Vec2(_body.GetPosition().x + param2, _body.GetPosition().y - param3);
            _loc_4.p2 = param1;
            var _loc_5:Array = [1];
            var _loc_6:* = new b2Vec2();
            var _loc_7:* = _universe.physics.RaycastOne(_loc_4, _loc_5, _loc_6, false, null);
            if (_loc_7)
            {
                _loc_8 = _loc_7.GetBody();
                if (_loc_8.m_userData is BasicObject)
                {
                    return _loc_8.m_userData as BasicObject;
                }
            }
            return null;
        }// end function

        override public function addContact(param1:b2ContactPoint) : Boolean
        {
            var _loc_2:BasicObject = null;
            var _loc_3:EffectBlow = null;
            var _loc_4:EffectDust = null;
            if (super.addContact(param1))
            {
                if (param1.shape1.GetBody().GetUserData() as BasicObject != this)
                {
                    _loc_2 = param1.shape1.GetBody().GetUserData() as BasicObject;
                }
                else if (param1.shape2.GetBody().GetUserData() as BasicObject != this)
                {
                    _loc_2 = param1.shape2.GetBody().GetUserData() as BasicObject;
                }
                this._hitPoint = new b2Vec2(_body.GetPosition().x, _body.GetPosition().y);
                this._hitForce = new b2Vec2(_body.GetLinearVelocity().x * 5, _body.GetLinearVelocity().y * 5);
                if (_loc_2 != null && (_loc_2.kind == Kind.TRUCK || _loc_2.kind == Kind.TRAILER))
                {
                    if (_loc_2.body.GetLinearVelocity().Length() > 1)
                    {
                        if (_isVisible)
                        {
                            _universe.motiSilentKill();
                        }
                        this._hitForce.x = _loc_2.body.GetLinearVelocity().x * 15;
                        this._hitForce.y = _loc_2.body.GetLinearVelocity().y * 15;
                        _universe.deads.add(this);
                        _die = true;
                        _loc_3 = EffectBlow.get();
                        _loc_3.init(param1.position.x * Universe.DRAW_SCALE, param1.position.y * Universe.DRAW_SCALE);
                        return true;
                    }
                }
                if (_loc_2 != null && _loc_2.body.GetPosition().y < _body.GetPosition().y - 0.5)
                {
                    switch(_loc_2.kind)
                    {
                        case Kind.BARREL:
                        case Kind.BARREL_EXPLOSION:
                        case Kind.BOX:
                        case Kind.WOOD_PLANK:
                        case Kind.CART:
                        case Kind.TRAILER:
                        {
                            if (_loc_2.body.GetLinearVelocity().y > 1)
                            {
                                if (_isVisible)
                                {
                                    _universe.motiSilentKill();
                                    var _loc_5:* = ZG.saveBox;
                                    var _loc_6:* = ZG.saveBox.silentKills + 1;
                                    _loc_5.silentKills = _loc_6;
                                    _universe.checkAchievement(AchievementItem.SILENT_KILLER);
                                }
                                _universe.deads.add(this);
                                _die = true;
                                _loc_3 = EffectBlow.get();
                                _loc_3.init(param1.position.x * Universe.DRAW_SCALE, param1.position.y * Universe.DRAW_SCALE);
                                return true;
                            }
                            break;
                        }
                        case Kind.VERTICAL_ELEVATOR:
                        {
                            if (_loc_2.body.GetLinearVelocity().y > 0.5)
                            {
                                if (_isVisible)
                                {
                                    _universe.motiSilentKill();
                                    var _loc_5:* = ZG.saveBox;
                                    var _loc_6:* = ZG.saveBox.silentKills + 1;
                                    _loc_5.silentKills = _loc_6;
                                    _universe.checkAchievement(AchievementItem.SILENT_KILLER);
                                }
                                _universe.deads.add(this);
                                _die = true;
                                _loc_3 = EffectBlow.get();
                                _loc_3.init(param1.position.x * Universe.DRAW_SCALE, param1.position.y * Universe.DRAW_SCALE);
                                return true;
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                if (_loc_2 != null && _loc_2.kind == Kind.DOOR_PART)
                {
                    if (_loc_2.variety == BasicDoorPart.TOP && (_loc_2 as BasicDoorPart).isDoorClosing)
                    {
                        if (_isVisible)
                        {
                            _universe.motiSilentKill();
                            var _loc_5:* = ZG.saveBox;
                            var _loc_6:* = ZG.saveBox.silentKills + 1;
                            _loc_5.silentKills = _loc_6;
                            _universe.checkAchievement(AchievementItem.SILENT_KILLER);
                        }
                        this._hitForce = new b2Vec2(_body.GetLinearVelocity().x, _body.GetLinearVelocity().y + 90);
                        _universe.deads.add(this);
                        _die = true;
                        return true;
                    }
                }
                if (_body.GetLinearVelocity().y > 15)
                {
                    this._hitForce.y = 100;
                    _universe.deads.add(this);
                    _die = true;
                }
                if (_isVisible && _body.GetLinearVelocity().y > 3 && _universe.frameTime - this._dustTime > 10)
                {
                    _loc_4 = EffectDust.get();
                    _loc_4.init(_position.x - 10, _position.y + 28);
                    _loc_4 = EffectDust.get();
                    _loc_4.init(_position.x + 10, _position.y + 28, 0, -1);
                    this._dustTime = _universe.frameTime;
                }
                return true;
            }
            return false;
        }// end function

        protected function getObjectsAround(param1:uint, param2:int, param3:int = 10) : void
        {
            var _loc_6:b2Body = null;
            var _loc_7:BasicObject = null;
            var _loc_9:IEnemyObject = null;
            var _loc_4:* = new b2AABB();
            _loc_4.lowerBound.Set(_body.GetWorldCenter().x - param3, _body.GetWorldCenter().y - param3);
            _loc_4.upperBound.Set(_body.GetWorldCenter().x + param3, _body.GetWorldCenter().y + param3);
            var _loc_5:Array = [];
            _universe.physics.Query(_loc_4, _loc_5, 40);
            var _loc_8:* = _loc_5.length;
            this._visionList.length = 0;
            var _loc_10:uint = 0;
            while (_loc_10 < _loc_8)
            {
                
                _loc_6 = (_loc_5[_loc_10] as b2Shape).GetBody();
                if (_loc_6.m_userData is BasicObject)
                {
                    _loc_7 = _loc_6.m_userData as BasicObject;
                    if (_loc_7.group != param1)
                    {
                        this._visionList[this._visionList.length] = {obj:_loc_7, priority:101};
                    }
                    else if (_loc_7.group == param1)
                    {
                        _loc_9 = _loc_7 as IEnemyObject;
                        if (_loc_9 != null && param2 != _loc_9.alertId && _loc_9.alertId > 0)
                        {
                            this._visionList[this._visionList.length] = {obj:_loc_7, priority:_loc_9.alertId};
                        }
                    }
                }
                _loc_10 = _loc_10 + 1;
            }
            this._visionList.sortOn("priority", Array.DESCENDING | Array.NUMERIC);
            return;
        }// end function

        protected function renderVision() : void
        {
            var _loc_1:Avector = null;
            var _loc_2:Avector = null;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            if (ZG.debugMode && _body != null)
            {
                _universe.layerDraws.graphics.lineStyle(1, 10470965, 0.8);
                _universe.layerDraws.graphics.beginFill(10470965, 0.5);
                _loc_3 = this._raycastList.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_1 = this._raycastList[_loc_4].point1;
                    _loc_2 = this._raycastList[_loc_4].point2;
                    _universe.layerDraws.graphics.moveTo(_loc_1.x * Universe.DRAW_SCALE, _loc_1.y * Universe.DRAW_SCALE);
                    _universe.layerDraws.graphics.lineTo(_loc_2.x * Universe.DRAW_SCALE, _loc_2.y * Universe.DRAW_SCALE);
                    _loc_4++;
                }
                _universe.layerDraws.graphics.endFill();
            }
            return;
        }// end function

        protected function switchAnim(param1:String, param2:Boolean = true) : void
        {
            var _loc_3:int = 0;
            if (param1 != this._curAnim)
            {
                this._curAnim = param1;
                _loc_3 = 1;
                if (_sprite != null)
                {
                    _loc_3 = _sprite.scaleX;
                    if (contains(_sprite))
                    {
                        removeChild(_sprite);
                    }
                }
                _sprite = ZG.animCache.getAnimation(this._curAnim);
                if (param2)
                {
                    _sprite.playRandomFrame();
                }
                else
                {
                    _sprite.play();
                }
                _sprite.scaleX = _loc_3;
                addChild(_sprite);
            }
            return;
        }// end function

        protected function addRaycastPoint(param1:b2Vec2, param2:b2Vec2, param3:Number = 0, param4:Number = 0) : void
        {
            if (ZG.debugMode)
            {
                this._raycastList[this._raycastList.length] = {point1:new Avector(param1.x + param3, param1.y + param4), point2:new Avector(param2.x, param2.y)};
            }
            return;
        }// end function

        protected function profiler(param1:uint, param2:Conditions, param3:int) : void
        {
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:uint = 0;
            var _loc_7:uint = 0;
            if (ZG.debugMode)
            {
                _loc_4 = "?";
                _loc_5 = "";
                switch(param1)
                {
                    case 0:
                    {
                        _loc_4 = "stay";
                        break;
                    }
                    case 1:
                    {
                        _loc_4 = "walk";
                        break;
                    }
                    case 2:
                    {
                        _loc_4 = "attack";
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_6 = param2.size;
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    switch(param2.getValue(_loc_7))
                    {
                        case 0:
                        {
                            _loc_5 = _loc_5 + "stay, ";
                            break;
                        }
                        case 1:
                        {
                            _loc_5 = _loc_5 + "walk, ";
                            break;
                        }
                        case 2:
                        {
                            _loc_5 = _loc_5 + "can attack, ";
                            break;
                        }
                        case 3:
                        {
                            _loc_5 = _loc_5 + "obstacle, ";
                            break;
                        }
                        case 4:
                        {
                            _loc_5 = _loc_5 + "see enemy, ";
                            break;
                        }
                        case 5:
                        {
                            _loc_5 = _loc_5 + "can break, ";
                            break;
                        }
                        default:
                        {
                            _loc_5 = _loc_5 + "?";
                            break;
                            break;
                        }
                    }
                    _loc_7 = _loc_7 + 1;
                }
                this._profilerText.text = "alert: " + param3.toString() + "\nstate: " + _loc_4 + "\nconditions: " + _loc_5;
            }
            return;
        }// end function

        protected function distToUnit(param1:BasicObject) : int
        {
            if (param1.body != null)
            {
                return int(Amath.distance(param1.body.GetPosition().x, param1.body.GetPosition().y, _body.GetPosition().x, _body.GetPosition().y));
            }
            return -1;
        }// end function

    }
}
