package warfare.game.objects 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author me
	 */
	public class Pool 
	{
		public var objects:Dictionary;
		
		public function Pool() 
		{
			objects = new Dictionary();
			
		}
		
		public function CreateObjects(poolableClass:Class, count:int):void
		{
			if (objects[poolableClass] == undefined)
			{
				objects[poolableClass] = [];
			}
			
			for (var i:int = 0; i < count; i++) 
			{
				var obj:IPoolableObject = new poolableClass() as IPoolableObject;
				if (obj)
				{
					obj.Create();
					objects[poolableClass].push(obj);
				} else
					throw new Error("not poolable object");
			}
		}
		
		public function GetObject(poolableClass:Class):*
		{
			if (objects[poolableClass] && objects[poolableClass].length>0) 
			{
				return objects[poolableClass].shift();
			} else
			{
				CreateObjects(poolableClass, 1);
				return objects[poolableClass].shift();
			}
		}
		
		public function AddObject(obj:IPoolableObject):void
		{
			var poolableClass:Class = obj.GetClass();
			if (objects[poolableClass] == undefined)
			{
				objects[poolableClass] = [];
			}
			objects[poolableClass].push(obj);
		}
		
		public function Clear():void
		{
			for each (var items:Array in objects) 
			{
				for each (var item:IPoolableObject in items) 
				{
					item.Destroy();
				}
			}
			
			objects = new Dictionary();
		}
		
		
		
	}

}