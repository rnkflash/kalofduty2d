package warfare.game.objects.enemies
{
	import com.rnk.input.Input;
	import com.rnk.input.InputKeys;
	import com.rnk.math.Amath;
	import com.rnk.soundmanager.SoundManager;
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
	import warfare.Sounds;
	/**
	 * ...
	 * @author me
	 */
	public class Enemy extends GameObject implements IPoolableObject
	{
		private var pivotJoint:PivotJoint;
		public var size:Rectangle = new Rectangle(0, 0, 20, 45);
		public var pos:Vec2 = new Vec2();
		public var velocity:Vec2 = new Vec2();
		public var body:Body;
		public var koleso:Body;
		public var heroAnimation:MovieClip;
		public var hp:int = 3;
		public var direction:Boolean = true;
		
		public function Enemy() 
		{
			
		}
		
		public function CustomInit(x:Number,y:Number):void
		{
			pos.x = x;
			pos.y = y;
		}
		
		override public function Init():void 
		{
			kill = false;
			body.space = space;
			body.angularVel = 0;
			body.velocity.setxy(0, 0);
			body.position.setxy(pos.x, pos.y);
			
			koleso.space = space;
			koleso.angularVel = 0;
			koleso.velocity.setxy(0, 0);
			koleso.position.setxy(pos.x, pos.y);
			
			pivotJoint.space = space;
			
			heroAnimation.gotoAndStop("stand");
			heroAnimation.x = koleso.position.x;
			heroAnimation.y = koleso.position.y - 20;
		}
		
		override public function Die():void 
		{
			//while(!body.constraints.empty()) body.constraints.at(0).space = null;
			pivotJoint.space = null;
			body.space = null;
			koleso.space = null;
		}
		
		override public function Update():void 
		{
			
			pos.x = heroAnimation.x = koleso.position.x;
			pos.y = heroAnimation.y = koleso.position.y - 20;
			
			//AimToMouse();
			//AimTo();
		}
		
		private function GetAngleToMouse():Number
		{
			var p:Point = heroAnimation.model.localToGlobal(new Point(heroAnimation.model.arm1.x, heroAnimation.model.arm1.y));
			var dx:Number = sprite.stage.mouseX;
			var dy:Number = sprite.stage.mouseY;
			return Amath.getAngle(p.x, p.y, dx, dy);
		}
		
		public function AimToMouse():void
		{
			if (!sprite.stage) return;
			heroAnimation.localToGlobal(new Point());
			var p:Point = heroAnimation.model.localToGlobal(new Point(heroAnimation.model.arm1.x, heroAnimation.model.arm1.y));
			var dx:Number = sprite.stage.mouseX;
			var dy:Number = sprite.stage.mouseY;
			var angle:Number = Amath.getAngle(p.x, p.y, dx, dy);
			var degAngle:Number = angle * 180 / Math.PI;
			var dir:Boolean = true;
			if (degAngle<90 || degAngle>270)
			{
				heroAnimation.model.head.scaleX = -1.0;
				heroAnimation.model.arm1.scaleX = -1.0;
				heroAnimation.model.arm2.scaleX = -1.0;
				heroAnimation.model.body.scaleX = -1.0;
				heroAnimation.model.weapon.scaleX = -1.0;
				
				heroAnimation.model.head.x = -Math.abs(heroAnimation.model.head.x);
				heroAnimation.model.arm1.x = -Math.abs(heroAnimation.model.arm1.x);
				heroAnimation.model.arm2.x = -Math.abs(heroAnimation.model.arm2.x);
				heroAnimation.model.body.x = -Math.abs(heroAnimation.model.body.x);
				heroAnimation.model.weapon.x = -Math.abs(heroAnimation.model.weapon.x);
				
				dir = false;
				
			} else
			{
				heroAnimation.model.head.scaleX = 1.0;
				heroAnimation.model.arm1.scaleX = 1.0;
				heroAnimation.model.arm2.scaleX = 1.0;
				heroAnimation.model.body.scaleX = 1.0;
				heroAnimation.model.weapon.scaleX = 1.0;
				
				heroAnimation.model.head.x = Math.abs(heroAnimation.model.head.x);
				heroAnimation.model.arm1.x = Math.abs(heroAnimation.model.arm1.x);
				heroAnimation.model.arm2.x = Math.abs(heroAnimation.model.arm2.x);
				heroAnimation.model.body.x = Math.abs(heroAnimation.model.body.x);
				heroAnimation.model.weapon.x = Math.abs(heroAnimation.model.weapon.x);
			}
			
			p = heroAnimation.model.localToGlobal(new Point(heroAnimation.model.weapon.x, heroAnimation.model.weapon.y));
			angle = Amath.getAngle(p.x, p.y, dx, dy);
			degAngle = angle * 180 / Math.PI;
			heroAnimation.model.weapon.rotation = dir?degAngle-180:degAngle;
			heroAnimation.model.arm1.rotation = dir?degAngle-180:degAngle;
			heroAnimation.model.arm2.rotation = dir?degAngle-180:degAngle;
			heroAnimation.model.head.rotation = dir?degAngle-180:degAngle;
			if (!dir)
				heroAnimation.model.head.rotation = MinMax(heroAnimation.model.head.rotation, -90, 50);
			else
				heroAnimation.model.head.rotation = MinMax(heroAnimation.model.head.rotation,-50, 90);
			
			
		}
		
		public function Hit(hitData:*):void
		{
			if ((hp-=hitData)>0)
			{
				var sounds:Array = [Sounds.SOUND_BODYHIT1, Sounds.SOUND_BODYHIT2, Sounds.SOUND_BODYHIT3, Sounds.SOUND_BODYHIT4];
				SoundManager.playSingleSound(sounds[Math.floor(Math.random() * 4)]);
				return;
			}
			
			if (!kill)
			{
				objectManager.CreateRagdoll(pos.x, pos.y, new Vec2(body.velocity.x, body.velocity.y));
				
				sounds = [Sounds.SOUND_HUMANDIE1, Sounds.SOUND_HUMANDIE2, Sounds.SOUND_HUMANDIE3, Sounds.SOUND_HUMANDIE4];
				SoundManager.playSingleSound(sounds[Math.floor(Math.random() * 4)]);
			}
			
			kill = true;
			
			
		}
		
		/* INTERFACE warfare.game.objects.IPoolableObject */
		
		public function Create():void 
		{
			//graphics
			heroAnimation = new solder();
			sprite = heroAnimation;
			heroAnimation.gotoAndStop("stand");
			
			//body
			var bodyMaterial:Material = new Material(0, 0.01, 0.01, 0.5, 0.01);
			body = new Body(BodyType.DYNAMIC,new Vec2(pos.x,pos.y));
			body.cbTypes.add(CollisionTypes.ENEMY_TYPE);
			body.shapes.add(new Polygon(Polygon.rect( -size.width / 2, -size.height, size.width, size.height),bodyMaterial));
			body.allowRotation = false;
			body.userData.obj = this;
			
			//wheel
			var kolesoMaterial:Material = new Material(0, 2, 2, 1, 0.01);
			koleso = new Body(BodyType.DYNAMIC, new Vec2(pos.x, pos.y));
			koleso.cbTypes.add(CollisionTypes.ENEMY_TYPE);
			koleso.shapes.add(new Circle(size.width / 2-1, new Vec2(0, 0), kolesoMaterial));
			koleso.allowRotation = false;
			koleso.userData.obj = this;
			
			//joint
			pivotJoint = new PivotJoint(body, koleso, new Vec2(0,0), new Vec2(0,0));
			pivotJoint.ignore = true;
			pivotJoint.stiff = true;
			pivotJoint.breakUnderError = false;
			pivotJoint.maxError = 1;
			
		}
		
		public function Destroy():void 
		{
			
		}
		
		public function GetClass():Class 
		{
			return Enemy;
		}
		
		private function MinMax(value:Number,min:Number,max:Number):Number
		{
			return Math.min(max,Math.max(min,value));
		}
		
	}

}