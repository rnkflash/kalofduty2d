package com.zombotron.interfaces
{
    import Box2D.Collision.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.antkarlov.anim.*;
    import com.zombotron.objects.*;

    public interface IBasicObject
    {

        public function IBasicObject();

        function die() : void;

        function hide() : void;

        function get sprite() : Animation;

        function get variety() : uint;

        function jointDead(param1:b2RevoluteJoint = null) : void;

        function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void;

        function set parentObject(param1:BasicObject) : void;

        function get kind() : uint;

        function render() : void;

        function set variety(param1:uint) : void;

        function visibleCulling() : void;

        function bulletCollision(param1:Bullet, param2:b2Vec2) : void;

        function explode(param1:BasicObject, param2:b2Vec2, param3:b2Vec2) : Boolean;

        function removeSensorContact(param1:BasicObject) : Boolean;

        function addSensorContact(param1:BasicObject) : Boolean;

        function attacked(param1:b2Vec2, param2:b2Vec2, param3:Number = 1) : Boolean;

        function set kind(param1:uint) : void;

        function get body() : b2Body;

        function free() : void;

        function get isDead() : Boolean;

        function get damage() : Number;

        function process() : void;

        function removeContact(param1:b2ContactPoint) : Boolean;

        function show() : void;

        function addContact(param1:b2ContactPoint) : Boolean;

    }
}
