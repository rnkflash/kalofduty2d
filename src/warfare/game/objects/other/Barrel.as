package warfare.game.objects.other
{
	import com.rnk.input.Input;
	import com.rnk.input.InputKeys;
	import com.rnk.math.Amath;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import warfare.game.objects.GameObject;
	import warfare.game.objects.IPoolableObject;
	import warfare.game.physics.CollisionTypes;
	/**
	 * ...
	 * @author me
	 */
	public class Barrel extends GameObject implements IPoolableObject
	{
		public var rot:Number = 0;
		public var pos:Vec2 = new Vec2();
		public var body:Body;
		
		public function Barrel() 
		{
			
		}
		
		public function CustomInit(x:Number,y:Number,rot:Number=0):void
		{
			this.rot = rot;
			pos.x = x;
			pos.y = y;
		}
		
		override public function Init():void 
		{
			kill = false;
			body.space = space;
			body.angularVel = 0;
			body.rotation = rot;
			body.velocity.setxy(0, 0);
			body.position.setxy(pos.x,pos.y);
			sprite.x = body.position.x;
			sprite.y = body.position.y;
			sprite.rotation = body.rotation * 180 / Math.PI;
			
		}
		
		override public function Die():void 
		{
			body.space = null;
		}
		
		override public function Update():void 
		{
			
			pos.x = sprite.x = body.position.x;
			pos.y = sprite.y = body.position.y;
			sprite.rotation = body.rotation * 180 / Math.PI;
		}
		
		/* INTERFACE warfare.game.objects.IPoolableObject */
		
		public function Create():void 
		{
			//graphics
			sprite = new barrel_mc();
			
			//body
			var bodyMaterial:Material = new Material(0, 1, 2, 1, 0.01);
			body = new Body(BodyType.DYNAMIC,new Vec2(pos.x,pos.y));
			body.cbTypes.add(CollisionTypes.BARREL_TYPE);
			body.shapes.add(new Polygon(Polygon.rect( -sprite.width / 2, -sprite.height / 2, sprite.width, sprite.height), 
				bodyMaterial));
			
		}
		
		public function Destroy():void 
		{
			
		}
		
		public function GetClass():Class 
		{
			return Barrel;
		}
		
		
	}

}