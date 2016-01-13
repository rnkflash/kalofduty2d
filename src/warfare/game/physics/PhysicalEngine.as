package warfare.game.physics 
{
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import warfare.Config;
	import warfare.game.objects.bullets.Bullet;
	/**
	 * ...
	 * @author me
	 */
	public class PhysicalEngine 
	{
		
		public var DEBUG_DRAW:Boolean = false;
		public var debug:BitmapDebug;
		public var space:Space;
		private var dt:Number;
		
		public function PhysicalEngine() 
		{
			dt = Config.DT;
		}
		
		public function Init():void
		{
			space = new Space(new Vec2(0, 400));
			debug = new BitmapDebug(Config.SCREEN_WIDTH, Config.SCREEN_HEIGHT, 0x333333, true);
			
			
			//collisions register
			space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, 
				CollisionTypes.BULLET_TYPE, CollisionTypes.BARREL_TYPE, BeginBulletBarrelCollision));
			space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, 
				CollisionTypes.BULLET_TYPE, CollisionTypes.STATIC_TYPE, BeginBulletBarrelCollision));
			space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, 
				CollisionTypes.BULLET_TYPE, CollisionTypes.ENEMY_TYPE, BeginBulletBarrelCollision));
			space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, 
				CollisionTypes.BULLET_TYPE, CollisionTypes.RAGDOLL_TYPE, BeginBulletBarrelCollision));
			
		}
		
		public function Die():void
		{
			Clear();
			
			space.listeners.clear();
		}
		
		private function BeginBulletBarrelCollision(cb:InteractionCallback):void 
		{
			var bulletBody:Body = cb.int1.castBody;
			var bullet:Bullet = bulletBody.userData.obj as Bullet;
			bullet.OnHit(cb.int2.castBody, cb.int2.castShape);
			
		}
		
		public function Update():void
		{
			//debug draw
			if (DEBUG_DRAW)
				debug.clear();
				
			//physics update
			//space.step(dt / 2, 5, 5);
			space.step(dt, 10, 10);
			//space.step(dt / 2, 5, 5);
			
			//debug draw
			if (DEBUG_DRAW)
			{
				debug.draw(space);
				debug.flush();
			}
		}
		
		public function Clear():void 
		{
			space.constraints.clear();
			space.bodies.clear();
			
		}
		
	}

}