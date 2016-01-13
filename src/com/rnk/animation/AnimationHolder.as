package com.rnk.animation  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author rnk
	 */
	public class AnimationHolder extends Sprite
	{
		private var animations:Object = { };
		private var currentAnimation:Animation;
		public var currentAnimationName:String;
		public var isPlaying:Boolean = false;
		
		public function AnimationHolder() 
		{
			currentAnimationName = "";
			currentAnimation = null;
		}
		
		public function AddAnimation(animName:String,anim:Animation):void
		{
			animations[animName] = anim;
			if (!currentAnimation)
			play(animName);
			stop();
		}
		
		public function play(animName:String, loop:Boolean=true,startFrame:int = 0):void
		{
			isPlaying = true;
			SwitchAnimation(animName);
			if (currentAnimation)
				currentAnimation.play(loop,startFrame);
			
		}
		
		public function stop(stopFrame:int = -1):void
		{
			isPlaying = false;
			if (currentAnimation)
				currentAnimation.stop(stopFrame);
			
		}
		
		public function gotoAndStop(animName:String, startFrame:int = 0):void
		{
			isPlaying = false;
			SwitchAnimation(animName);
			if (currentAnimation)
				currentAnimation.stop(startFrame);
			
		}
		
		private function SwitchAnimation(animName:String):void 
		{
			if (currentAnimationName == animName || !animations[animName]) return;
			currentAnimationName = animName;
			if (currentAnimation)
			{
				currentAnimation.stop();
				removeChild(currentAnimation);
			}
			
			currentAnimation = animations[animName];
			addChild(currentAnimation);
			
		}
		

		
	}

}