package 
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import warfare.Warfare;
	
	/**
	 * ...
	 * @author me
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			//шоб не скейлилось
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//сама игра
			addChild(new Warfare());
			
		}
		
	}
	
}