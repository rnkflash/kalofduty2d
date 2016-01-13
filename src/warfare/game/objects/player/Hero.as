package warfare.game.objects.player 
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
	import warfare.game.objects.bullets.Bullet;
	import warfare.game.objects.GameObject;
	import warfare.game.physics.CollisionTypes;
	import warfare.Sounds;
	/**
	 * ...
	 * @author me
	 */
	public class Hero extends GameObject
	{
		private var pivotJoint:PivotJoint;
		public var size:Rectangle = new Rectangle(0, 0, 20, 45);
		public var pos:Vec2 = new Vec2();
		public var velocity:Vec2 = new Vec2();
		public var body:Body;
		public var koleso:Body;
		public var heroAnimation:MovieClip;
		public var fireDelay:Number = 0;
		public var fireDelayMax:Number = 3;
		
		public var direction:Boolean = true;
		
		public function Hero(x:Number,y:Number) 
		{
			pos.x = x;
			pos.y = y;
		}
		
		override public function Init():void 
		{
			//graphics
			heroAnimation = new solder();
			sprite = heroAnimation;
			heroAnimation.gotoAndStop("stand");
			
			//body
			var bodyMaterial:Material = new Material(0, 0.01, 0.01, 0.5, 0.01);
			body = new Body(BodyType.DYNAMIC,new Vec2(pos.x,pos.y));
			body.cbTypes.add(CollisionTypes.HERO_TYPE);
			body.shapes.add(new Polygon(Polygon.rect( -size.width / 2, -size.height, size.width, size.height),bodyMaterial));
			body.space = space;
			body.allowRotation = false;
			
			//wheel
			var kolesoMaterial:Material = new Material(0, 2, 2, 1, 0.01);
			koleso = new Body(BodyType.DYNAMIC, new Vec2(pos.x, pos.y));
			koleso.cbTypes.add(CollisionTypes.HERO_TYPE);
			koleso.shapes.add(new Circle(size.width / 2-1, new Vec2(0, 0), kolesoMaterial));
			koleso.space = space;
			koleso.allowRotation = true;
			
			//joint
			pivotJoint = new PivotJoint(body, koleso, new Vec2(0,0), new Vec2(0,0));
			pivotJoint.ignore = true;
			pivotJoint.stiff = true;
			pivotJoint.breakUnderError = false;
			pivotJoint.maxError = 1;
			pivotJoint.space = space;
		}
		
		override public function Die():void 
		{
			pivotJoint.space = null;
			body.space = null;
			koleso.space = null;
			
		}
		
		override public function Update():void 
		{
			if (true)
			{
				if (Input.isKeyDown(InputKeys.RIGHT) || Input.isKeyDown(InputKeys.D))
				{
					koleso.velocity.x = 150;
					koleso.allowRotation = true;
					
					heroAnimation.gotoAndStop("walk");
					heroAnimation.model.legs.scaleX = -1.0;
					direction = false;
				} else
				if (Input.isKeyDown(InputKeys.LEFT) || Input.isKeyDown(InputKeys.A))
				{
					koleso.velocity.x = -150;
					koleso.allowRotation = true;
					heroAnimation.gotoAndStop("walk");
					heroAnimation.model.legs.scaleX = 1.0;
					direction = true;
				} else
				{
					koleso.allowRotation = false;
					koleso.angularVel = 0;
					koleso.velocity.x *=0.5;
					heroAnimation.gotoAndStop("stand");
					heroAnimation.model.legs.scaleX = direction?1.0: -1.0;
					
				}
				
				if (Input.isKeyPressed(InputKeys.UP) || Input.isKeyPressed(InputKeys.W))
				{
					koleso.velocity.y = -700;
					heroAnimation.gotoAndStop("attack");
				}
				
				if (Input.mouseDown)
				{
					Fire();
				}
			}
			
			if (fireDelay<fireDelayMax)
				fireDelay++;
			
			
			pos.x = heroAnimation.x = koleso.position.x;
			pos.y = heroAnimation.y = koleso.position.y - 20;
			
			AimToMouse();
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
		
		private function MinMax(value:Number,min:Number,max:Number):Number
		{
			return Math.min(max, Math.max(min, value));
		}
		
		private function Fire():void 
		{
			if (fireDelay < fireDelayMax)
				return;
			fireDelay = 0;
			
			var bulletSource:MovieClip = heroAnimation.model.weapon.bullet_source as MovieClip;
			var gp:Point = bulletSource.localToGlobal(new Point());
			
			var razbros:Number = Math.PI / 20;
			var an:Number = GetAngleToMouse() + Math.random()*razbros - razbros/2;
			var range:Number = 50;
			var bullet:Bullet = objectManager.pool.GetObject(Bullet) as Bullet;
			//bullet.CustomInit(pos.x + range * Math.cos(an), pos.y + (range) * Math.sin(an), an, 1000);
			bullet.CustomInit(gp.x, gp.y, an, 1000);
			objectManager.Add(bullet);
			
			var soundId:int = Math.random() > 0.5?Sounds.SOUND_AK47_FIRE1:Sounds.SOUND_AK47_FIRE2;
			//SoundManager.playSingleSound();
			
			SoundManager.playSingleSoundByPos(soundId,heroAnimation.x);
			
		}
		
	}

}