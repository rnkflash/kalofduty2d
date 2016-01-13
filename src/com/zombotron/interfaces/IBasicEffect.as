package com.zombotron.interfaces
{

    public interface IBasicEffect
    {

        public function IBasicEffect();

        function init(param1:Number, param2:Number, param3:Number = 0, param4:Number = 1) : void;

        function free() : void;

        function process() : void;

    }
}
