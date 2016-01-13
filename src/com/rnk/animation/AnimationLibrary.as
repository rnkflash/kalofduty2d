package com.rnk.animation
{
	/**
	 * ...
	 * @author rnk
	 */
	public class AnimationLibrary 
	{
		static private var animations:Object = {};
		
		public static function AddAnimation(name:String, anim:Animation):void
		{
			animations[name] = anim;
		}
		
		public static function GetAnimation(name:String):Animation
		{
			if (animations[name])
			{
				return animations[name].clone();
			}
			return null;
		}
		
	}

}