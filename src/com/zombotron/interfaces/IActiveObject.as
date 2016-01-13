package com.zombotron.interfaces
{
    import com.antkarlov.math.*;

    public interface IActiveObject
    {

        public function IActiveObject();

        function get alias() : String;

        function changeState() : void;

        function action(param1:Function = null) : void;

        function set alias(param1:String) : void;

        function get activateDistance() : int;

        function get activatePoint() : Avector;

    }
}
