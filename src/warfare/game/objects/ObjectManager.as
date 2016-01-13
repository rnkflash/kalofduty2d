package warfare.game.objects 
{
	import flash.display.Sprite;
	import nape.geom.Vec2;
	import warfare.game.Game;
	import warfare.game.parsers.RagdollMovieclipParser;
	/**
	 * ...
	 * @author me
	 */
	public class ObjectManager 
	{
		public var pool:Pool;
		public var objects:Array = [];
		public var spriteHolder:Sprite;
		
		public function ObjectManager() 
		{
			spriteHolder = new Sprite();
		}
		
		public function Init():void
		{
			pool = new Pool();
			
		}
		
		public function Die():void
		{
			Clear();
			pool.Clear();
		}
		
		public function Add(obj:GameObject):void
		{
			obj.objectManager = this;
			obj.space = Game.instance.physEngine.space;
			objects.push(obj);
			obj.Init();
			if (obj.sprite)
				spriteHolder.addChild(obj.sprite);
		}
		
		public function Remove(obj:GameObject):void
		{
			KillObject(obj);
			
			objects.splice(objects.indexOf(obj), 1);
		}
		
		public function Update():void
		{
			
			for each (var item:GameObject in objects) 
			{
				item.Update();
			}
			
			
		}
		
		public function KillUpdate():void
		{
			for (var i:int = objects.length-1; i >=0; i--) 
			{
				var item:GameObject = objects[i];
				if (item.kill)
				{
					KillObject(item);
					objects.splice(i, 1);
					
				}
				
			}
		}
		
		public function Clear():void 
		{
			for each (var item:GameObject in objects) 
			{
				KillObject(item);
			}
			objects = [];
			
			
		}
		
		private function KillObject(obj:GameObject):void 
		{
			obj.Die();
			
			if (obj.sprite)
				spriteHolder.removeChild(obj.sprite);
			
			//pool hack
			if (obj is IPoolableObject)
			{
				pool.AddObject(obj as IPoolableObject);
			}
		}
		
		public function CreateRagdoll(sx:Number,sy:Number,vel:Vec2):void 
		{
			RagdollMovieclipParser.objectManager = this;
			RagdollMovieclipParser.space = Game.instance.physEngine.space;
			RagdollMovieclipParser.CreateRagdoll(new soldier_ragdoll(), new Vec2(sx,sy),vel);
		}
		
	}

}