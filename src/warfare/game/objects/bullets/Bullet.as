package warfare.game.objects.bullets
{
	import com.rnk.input.Input;
	import com.rnk.input.InputKeys;
	import com.rnk.math.Amath;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import nape.constraint.PivotJoint;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import warfare.game.objects.enemies.Enemy;
	import warfare.game.objects.GameObject;
	import warfare.game.objects.IPoolableObject;
	import warfare.game.objects.other.RagdollPart;
	import warfare.game.physics.CollisionTypes;
	/**
	 * ...
	 * @author me
	 */
	public class Bullet extends GameObject implements IPoolableObject
	{
		private var angle:Number;
		private var power:Number;
		public var pos:Vec2 = new Vec2();
		public var body:Body;
		
		public function Bullet() 
		{
			
		}
		
		public function CustomInit(x:Number,y:Number,angle:Number,power:Number):void
		{
			this.power = power;
			this.angle = angle;
			pos.x = x;
			pos.y = y;
			sprite.x = pos.x;
			sprite.y = pos.y;
			body.position.setxy(pos.x, pos.y);
		}
		
		override public function Init():void 
		{
			kill = false;
			body.rotation = angle;
			body.position.setxy(pos.x, pos.y);
			//body.applyLocalImpulse(new Vec2(power * Math.cos(angle), power * Math.sin(angle)));
			body.angularVel = 0;
			body.velocity.setxy(power * Math.cos(angle), power * Math.sin(angle));
			body.space = space;
			
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
		
		public function OnHit(who:*,shape:*=null):void
		{
			kill = true;
			
			if (who && who.userData.obj)
			{
				if (who.userData.obj is Enemy)
					who.userData.obj.Hit(Math.ceil(Math.random()*3));
					
				if (who.userData.obj is RagdollPart)
					who.userData.obj.Hit();
			}
		}
		
		/* INTERFACE warfare.game.objects.IPoolableObject */
		
		public function Create():void 
		{
			//graphics
			sprite = new bullet_mc();
			
			//body
			var bodyMaterial:Material = new Material(0, 1, 2, 7, 0.01);
			body = new Body(BodyType.DYNAMIC , new Vec2(pos.x, pos.y));
			body.gravMass = 0;
			body.cbTypes.add(CollisionTypes.BULLET_TYPE);
			body.shapes.add(new Polygon(Polygon.rect( -sprite.width / 2, -sprite.height / 2, sprite.width, sprite.height), 
				bodyMaterial,new InteractionFilter(CollisionTypes.bulletGroup,CollisionTypes.bulletMask)));
			body.userData.obj = this;
			
			
		}
		
		public function Destroy():void 
		{
			
		}
		
		public function GetClass():Class 
		{
			return Bullet;
		}
		
		
	}

}