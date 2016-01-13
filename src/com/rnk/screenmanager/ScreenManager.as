package com.rnk.screenmanager 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class ScreenManager extends Sprite
	{
		public var currentScreen:Screen;
		
		public function ScreenManager() 
		{
			if (!stage)
				addEventListener(Event.ADDED_TO_STAGE, Init);
			else
				Init();
			
		}
		
		public function Init(e:*=null):void
		{
			addEventListener(Event.ENTER_FRAME, Update);
		}
		
		public function Die():void
		{
			removeEventListener(Event.ENTER_FRAME, Update);
		}
		
		public function ShowScreen(screenClass:Class,screenParams:Array=null):void
		{
			if (currentScreen)
			{
				currentScreen.Die();
				currentScreen.screenManager = null;
				currentScreen.screenParams = null;
				removeChild(currentScreen);
				currentScreen = null;
			}
			
			currentScreen = new screenClass();
			currentScreen.screenManager = this;
			currentScreen.screenParams = screenParams;
			addChild(currentScreen);
			currentScreen.Init();
			
		}
		
		public function Update(e:Event):void
		{
			if (currentScreen)
				currentScreen.Update();
		}
		
	}

}