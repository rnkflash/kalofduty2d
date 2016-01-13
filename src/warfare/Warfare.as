package warfare 
{
	import com.rnk.input.Input;
	import com.rnk.screenmanager.ScreenManager;
	import com.rnk.soundmanager.SoundManager;
	import flash.events.Event;
	/**
	 * ...
	 * @author me
	 */
	public class Warfare extends ScreenManager
	{
		private var input:Input;
		
		public function Warfare() 
		{
			
		}
		
		override public function Init(e:* = null):void 
		{
			super.Init(e);
			
			input = new Input(this);
			
			//load sounds
			SoundManager.init(Sounds.init);
			
			//first screen
			ShowScreen(Screens.LEVEL_SELECT);
		}
		
		override public function Die():void 
		{
			super.Die();
		}
		
		override public function Update(e:Event):void 
		{
			super.Update(e);
			Input.update();
			SoundManager.update();
		}
		
		
		
	}

}