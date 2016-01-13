package warfare.game.physics 
{
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.phys.Body;
	import nape.space.Space;
	/**
	 * ...
	 * @author me
	 */
	public class CollisionTypes
	{
		public static const HERO_TYPE:CbType = new CbType();
		public static const ENEMY_TYPE:CbType = new CbType();
		public static const BULLET_TYPE:CbType = new CbType();
		public static const BARREL_TYPE:CbType = new CbType();
		public static const STATIC_TYPE:CbType = new CbType();
		public static const RAGDOLL_TYPE:CbType = new CbType();
		
		//groups and masks
		public static const bodyGroup:int = 	0x000000001;
		public static const bodyMask:int =  	0x000010001;
			
		public static const headGroup:int = 	0x000000010;
		public static const headMask:int =  	0x000010001;
			
		public static const armsGroup:int = 	0x000000100;
		public static const armsMask:int =  	0x000010001;
			
		public static const legsGroup:int = 	0x000001000;
		public static const legsMask:int =  	0x000010001;
		
		public static const bulletGroup:int = 	0x111111111;
		public static const bulletMask:int =  	0x111111111;
		
	}

}