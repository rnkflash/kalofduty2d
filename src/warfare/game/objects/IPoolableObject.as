package warfare.game.objects 
{
	
	/**
	 * ...
	 * @author me
	 */
	public interface IPoolableObject 
	{
		function Create():void;
		function Destroy():void;
		function GetClass():Class;
	}
	
}