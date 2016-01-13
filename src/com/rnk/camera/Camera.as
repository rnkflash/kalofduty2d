package com.rnk.camera 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author me
	 */
	public class Camera 
	{
		private var screen:Object;
		private var size:Rectangle;
		private var center:Point;
		private var speed:Number;
		private var target:Object;
		private var dest:Point;
		private var following:Boolean = false;
		private var moving:Boolean = false;
		private var bounds:Rectangle;
		private var pos:Point;
		
		public function Camera() 
		{
			
		}
		
		public function Init(screen:Object, size:Rectangle, bounds:Rectangle, center:Point, speed:Number = 1.0):void
		{
			pos = new Point();
			this.bounds = bounds;
			this.speed = speed;
			this.center = center;
			this.size = size;
			this.screen = screen;
			
		}
		
		public function Update():void
		{
			if (following)
			{
				
			} else
			if (moving)
			{
				
			}
		}
		
		public function Die():void
		{
			
		}
		
		public function Stop():void
		{
			moving = false;
			following = false;
			target = null;
		}
		
		public function SetTo(destX:Number, destY:Number):void
		{
			Stop();
			pos.x = destX;
			pos.y = destY;
		}
		
		
		public function MoveTo(destX:Number, destY:Number):void
		{
			Stop();
			dest = new Point(destX,destY);
			moving = true;
			
		}
		
		public function Follow(target:Object):void
		{
			Stop();
			this.target = target;
			following = true;
			
		}
		
	}

}