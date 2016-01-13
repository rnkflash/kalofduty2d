package warfare.levelselect 
{
	import com.rnk.screenmanager.Screen;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import warfare.Screens;
	/**
	 * ...
	 * @author me
	 */
	public class LevelSelect extends Screen
	{
		private var bg:MovieClip;
		
		public function LevelSelect() 
		{
			
		}
		
		override public function Init():void 
		{
			bg = new level_select_bg();
			addChild(bg);
			
			SetListeners(true);
			
		}
		
		override public function Die():void 
		{
			SetListeners(false);
		}
		
		public function SetListeners(orly:Boolean):void 
		{
			var buttons:Array = [bg.button];
			for each (var item:EventDispatcher in buttons) 
			{
				(item as MovieClip).useHandCursor = (item as MovieClip).buttonMode = true;
				(item as MovieClip).mouseChildren = false;
				(orly?item.addEventListener:item.removeEventListener)(MouseEvent.CLICK, OnButtonClick);
			}
			
		}
		
		private function OnButtonClick(e:MouseEvent):void 
		{
			switch (e.target) 
			{
				case bg.button:
					screenManager.ShowScreen(Screens.GAME, [1]);
				break;
				
			}
		}
		
		override public function Update(e:Event = null):void 
		{
			
		}
		
	}

}