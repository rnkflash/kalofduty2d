package warfare 
{
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author me
	 */
	public class Sounds 
	{
		static private var singleSoundBase:Array;
		static private var singleSoundBaseGroupMark:Array;
		static private var musicBank:Array;
		
		//ПРИМЕР ИНИТ ФУНКЦИИ ДЛЯ SoundManager.Init
		//just copy this to your project
		
		//sound
		public static const SOUND_AK47_FIRE1:int = 0;
		public static const SOUND_AK47_FIRE2:int = 1;
		
		public static const SOUND_FAL_FIRE1:int = 2;
		public static const SOUND_FAL_FIRE2:int = 3;
		
		public static const SOUND_BODYHIT1:int = 4;
		public static const SOUND_BODYHIT2:int = 5;
		public static const SOUND_BODYHIT3:int = 6;
		public static const SOUND_BODYHIT4:int = 7;
		
		public static const SOUND_HUMANDIE1:int = 8;
		public static const SOUND_HUMANDIE2:int = 9;
		public static const SOUND_HUMANDIE3:int = 10;
		public static const SOUND_HUMANDIE4:int = 11;
		
		
		//music
		//public static const MUSIC_MENU:int = 0;
		
		
		
		public static function init(singleSoundBase:Array,singleSoundBaseGroupMark:Array,musicBank:Array):void
		{
			Sounds.musicBank = musicBank;
			Sounds.singleSoundBaseGroupMark = singleSoundBaseGroupMark;
			Sounds.singleSoundBase = singleSoundBase;
			
			//sounds
			MakeSound(SOUND_AK47_FIRE1, ak47_fire1,0.5);
			MakeSound(SOUND_AK47_FIRE2, ak47_fire2,0.5);
			
			MakeSound(SOUND_FAL_FIRE1, fal_fire1,0.5);
			MakeSound(SOUND_FAL_FIRE2, fal_fire2,0.5);
			
			MakeSound(SOUND_BODYHIT1 , sound_bodyhit1);
			MakeSound(SOUND_BODYHIT2 , sound_bodyhit2);
			MakeSound(SOUND_BODYHIT3 , sound_bodyhit3);
			MakeSound(SOUND_BODYHIT4 , sound_bodyhit4);
			
			MakeSound(SOUND_HUMANDIE1, sound_human_die1,1.5);
			MakeSound(SOUND_HUMANDIE2, sound_human_die2,1.5);
			MakeSound(SOUND_HUMANDIE3, sound_human_die3,1.5);
			MakeSound(SOUND_HUMANDIE4, sound_human_die4,1.5);
			
			
			
			//music
			
			//musicBank[MUSIC_MENU] = [new music1(), new SoundTransform(1, 0)];
			
		}
		
		public static function MakeSound(id:int,soundClass:Class,volume:Number=1.0):void
		{
			singleSoundBase[id] = [new soundClass(), new SoundTransform(volume, 0), 0.0];
            singleSoundBaseGroupMark[id] = false;
		}
		
	}

}