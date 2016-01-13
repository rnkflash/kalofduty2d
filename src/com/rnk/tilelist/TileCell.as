package com.rnk.tilelist 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Sulus Ltd.
	 */
	public class TileCell extends Sprite
	{
		public static const SELECTED:String = "selected";
		public var papa:TileList;
		public var data:Object;
		
		public function TileCell() 
		{
			
		}
		
		public function SetPapa(value:TileList):void
		{
			papa = value;
		}
		
		public function SetData(value:Object):void
		{
			data = value;
		}
		
		public function Init():void
		{
			
		}
		
		public function Die():void
		{
			SetListeners(false);
		}
		
		public function OnShow():void
		{
			
		}
		
		public function OnHide():void
		{
			
		}
		
		protected function SetListeners(orly:Boolean):void
		{
			(orly ? addEventListener : removeEventListener)(MouseEvent.CLICK, OnMouseClick);
		}
		
		protected function OnMouseClick(e:MouseEvent):void
		{
			dispatchEvent(new Event(SELECTED));
		}
		
		public function Select(orly:Boolean):void
		{
			
		}
	}

}