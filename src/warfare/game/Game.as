package warfare.game 
{
	import com.rnk.input.Input;
	import com.rnk.input.InputKeys;
	import com.rnk.screenmanager.Screen;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import nape.geom.Vec2;
	import warfare.game.gui.Gui;
	import warfare.game.objects.enemies.Enemy;
	import warfare.game.objects.ObjectManager;
	import warfare.game.parsers.MovieClipParser;
	import warfare.game.physics.PhysicalEngine;
	/**
	 * ...
	 * @author me
	 */
	public class Game extends Screen
	{
		private var level:int;
		public static var instance:Game;
		
		public var objectManager:ObjectManager;
		public var gui:Gui;
		public var physEngine:PhysicalEngine;
		public var bg:Sprite;
		public var debug:Sprite;
		public var screen:Sprite;
		
		public function Game() 
		{
			
		}
		
		override public function Init():void 
		{
			//instance
			instance = this;
			stage.focus = this;
			
			//create
			screen = new Sprite();
			gui = new Gui();
			objectManager = new ObjectManager();
			physEngine = new PhysicalEngine();
			bg = new Sprite();
			debug = new Sprite();
			
			//display order
			addChild(screen);
			screen.addChild(bg);
			screen.addChild(objectManager.spriteHolder);
			screen.addChild(gui);
			screen.addChild(debug);
			
			//inits
			gui.Init();
			physEngine.Init();
			debug.addChild(physEngine.debug.display);
			objectManager.Init();
			
			
			//load level
			var level:int = int(screenParams[0]);
			LoadLevel(level);
			
			
			//слишком громко мать вашу
			var kaktutvasheprogrammirovat:Boolean = false;
			
		}
		
		public function LoadLevel(level:int):void
		{
			this.level = level;
			//bg
			bg.addChild(new level1_bg());
			
			//parser
			new MovieClipParser(new level1(), physEngine.space, objectManager);
			
		}
		
		public function Restart():void
		{
			objectManager.Clear();
			physEngine.Clear();
			while (bg.numChildren) bg.removeChildAt(0);
			
			LoadLevel(level);
		}
		
		public function Finish(win:Boolean=false):void
		{
			
		}
		
		public function ShowDebugDraw(orly:Boolean):void
		{
			physEngine.DEBUG_DRAW = orly;
			physEngine.debug.clear();
			physEngine.debug.flush();
			
		}
		
		override public function Die():void 
		{
			objectManager.Die();
			physEngine.Die();
			instance = null;
		}
		
		override public function Update(e:Event = null):void 
		{
			//global keys
			if (Input.isKeyPressed(InputKeys.Z))
			{
				ShowDebugDraw(!physEngine.DEBUG_DRAW);
			}
			if (Input.isKeyPressed(InputKeys.R))
			{
				Restart();
			}
			if (Input.isKeyPressed(InputKeys.E))
			{
				var enemy:Enemy = objectManager.pool.GetObject(Enemy);
				enemy.CustomInit(stage.mouseX, stage.mouseY + 20);
				objectManager.Add(enemy);
			}
			if (Input.isKeyPressed(InputKeys.F))
			{
				objectManager.CreateRagdoll(stage.mouseX, stage.mouseY,new Vec2());
			}
			
			//updates
			
			physEngine.Update();
			objectManager.Update();
			objectManager.KillUpdate();
			
			
		}
		
	}

}