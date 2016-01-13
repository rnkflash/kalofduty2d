package com.rnk.animation  
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author rnk
	 */
	public class Animation extends Sprite
	{
		static public const START:String = "start";
		static public const STOP:String = "stop";
		static public const FINISH:String = "finish";
		
		private var cachedMovieclip:CachedMovieclip;
		public var currentFrame:int = 1;
		private var _animation_class:Class;
		private var _scale:Number;
		public var isPlaying:Boolean = false;
		public var isLooping:Boolean = false;
		
		private var frameListeners:Object = {};
		
		public function Animation(animation_class:Class, scale:Number = 1.0 ) 
		{
			super();
			_scale = scale;
			_animation_class = animation_class;
			cachedMovieclip = CachedMovieclip.getClip(animation_class, scale);
			addChild(cachedMovieclip);
			
		}
		
		public function play(loop:Boolean=true,startingFrame:int=1):void
		{
			isLooping = loop;
			isPlaying = true;
			currentFrame = startingFrame;
			addEventListener(Event.ENTER_FRAME, OnEnterFrame, false, 0, true);
			dispatchEvent(new Event(START));
		}
		
		public function stop(stopFrame:int = 0):void
		{
			isPlaying = false;
			removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
			if (stopFrame > 0)
			{
				currentFrame = stopFrame;
				cachedMovieclip.gotoAndStop(currentFrame);
			}
			dispatchEvent(new Event(STOP));
		}
		
		private function OnEnterFrame(e:Event):void 
		{
			cachedMovieclip.gotoAndStop(currentFrame);
			
			currentFrame++;
			
			if (currentFrame > cachedMovieclip.totalFrames)
			{
				if (isLooping)
					currentFrame = 1;
				else
				{
					dispatchEvent(new Event(FINISH));
					stop();
				}
			}
			
			if (frameListeners[currentFrame])
			{
				for each (var listener:Function in frameListeners[currentFrame]) 
				{
					listener();
				}
			}
			
		}
		
		public function get totalFrames():int 
		{
			return cachedMovieclip.totalFrames;
		}
		
		public function addFrameListener(frameNum:int,listener:Function):void
		{
			if (!frameListeners[frameNum]) frameListeners[frameNum] = [];
			frameListeners[frameNum].push(listener);
		}
		
		public function removeFrameListener(frameNum:int,listener:Function):void
		{
			frameListeners[frameNum].splice(frameListeners[frameNum].indexOf(listener), 1);
		}
		
		public function clone():Animation
		{
			return new Animation(_animation_class, _scale);
		}
	}

}