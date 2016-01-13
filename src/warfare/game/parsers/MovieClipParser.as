package warfare.game.parsers
{
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	import warfare.game.objects.enemies.Enemy;
	import warfare.game.objects.ObjectManager;
	import warfare.game.objects.other.Barrel;
	import warfare.game.objects.player.Hero;
	import warfare.game.physics.CollisionTypes;
	/**
	 * ...
	 * @author me
	 */
	public class MovieClipParser 
	{
		public var border:Body;
		
		public function MovieClipParser(mc:MovieClip, space:Space, objectManager:ObjectManager) 
		{
			border = new Body(BodyType.STATIC);
			
			for (var i:int = 0; i < mc.numChildren; i++) 
			{
				var child:MovieClip = mc.getChildAt(i) as MovieClip;
				if (child)
				{
					var className:String = getQualifiedClassName(child);
					var args:Array = className.split("_");
					if (args[1] == "box")
					{
						var isStatic:Boolean = (args[0] == "static");
						var rotation:Number = child.rotation;
						var sizeX:Number = Number(args[2]);
						var sizeY:Number = Number(args[3]);
						
						if (isStatic)
						{
							border.shapes.add(new Polygon(GetRotatedRect(child.x,child.y,sizeX, sizeY, rotation * Math.PI / 180)));
						}
					} else
					if (args[0] == "hero")
					{
						rotation = child.rotation;
						var hero:Hero= new Hero(child.x,child.y+20);
						objectManager.Add(hero);
						
					} else
					if (args[0] == "barrel")
					{
						rotation = child.rotation;
						var barrel:Barrel = objectManager.pool.GetObject(Barrel);
						barrel.CustomInit(child.x, child.y, rotation * Math.PI / 180);
						objectManager.Add(barrel);
						
					} else
					if (args[0] == "enemy")
					{
						rotation = child.rotation;
						var enemy:Enemy = objectManager.pool.GetObject(Enemy);
						enemy.CustomInit(child.x, child.y + 20);
						objectManager.Add(enemy);
						
					}
					
				}
			}
			border.cbTypes.add(CollisionTypes.STATIC_TYPE);
			border.space = space;
		}
		
		private function GetRotatedRect(x:Number,y:Number,Width:Number, Height:Number, A:Number):Array 
		{
			var result:Array = [];
			result.push(new Vec2(x + ( Width / 2 ) * Math.cos(A) - ( Height / 2 ) * Math.sin(A) ,  y + ( Height / 2 ) * Math.cos(A)  + ( Width / 2 ) * Math.sin(A)));
			result.push(new Vec2(x - ( Width / 2 ) * Math.cos(A) - ( Height / 2 ) * Math.sin(A) ,  y + ( Height / 2 ) * Math.cos(A)  - ( Width / 2 ) * Math.sin(A)));
			result.push(new Vec2(x - ( Width / 2 ) * Math.cos(A) + ( Height / 2 ) * Math.sin(A) ,  y - ( Height / 2 ) * Math.cos(A)  - ( Width / 2 ) * Math.sin(A)));
			result.push(new Vec2(x + ( Width / 2 ) * Math.cos(A) + ( Height / 2 ) * Math.sin(A) ,  y - ( Height / 2 ) * Math.cos(A)  + ( Width / 2 ) * Math.sin(A)));
			return result;
		}
		
	}

}