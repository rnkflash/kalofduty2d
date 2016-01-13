package warfare.game.objects.other
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
	import warfare.Sounds;
	/**
	 * ...
	 * @author me
	 */
	public class RagdollPart extends GameObject
	{
		private var mc:MovieClip;
		private var destructable:Boolean;
		public var pos:Vec2 = new Vec2();
		public var body:Body;
		public var hp:int = 15;
		
		public function RagdollPart(x:Number, y:Number, mc:MovieClip, body:Body, destructable:Boolean = true ) 
		{
			this.destructable = destructable;
			this.body = body;
			this.mc = mc;
			pos.x = x;
			pos.y = y;
			
			body.userData.obj = this;
			
		}
		
		override public function Init():void 
		{
			//graphics
			sprite = mc;
			
		}
		
		override public function Die():void 
		{
			while(!body.constraints.empty()) body.constraints.at(0).space = null;
			body.space = null;
		}
		
		override public function Update():void 
		{
			
			pos.x = sprite.x = body.position.x;
			pos.y = sprite.y = body.position.y;
			sprite.rotation = body.rotation * 180 / Math.PI;
		}
		
		public function Hit():void
		{
			if (destructable)
			{
				if ( (hp-=Math.random()*5)<0 )
				while (!body.constraints.empty()) body.constraints.at(0).space = null;
			}
			
			var sounds:Array = [Sounds.SOUND_BODYHIT1, Sounds.SOUND_BODYHIT2, Sounds.SOUND_BODYHIT3, Sounds.SOUND_BODYHIT4];
				SoundManager.playSingleSound(sounds[Math.floor(Math.random() * 4)]);
			//kill = true;
		}
		
	}

}