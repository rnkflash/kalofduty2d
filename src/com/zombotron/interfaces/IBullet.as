package com.zombotron.interfaces
{
    import Box2D.Common.Math.*;
    import com.zombotron.objects.*;

    public interface IBullet
    {

        public function IBullet();

        function collision(param1:b2Vec2, param2:BasicObject = null) : void;

    }
}
