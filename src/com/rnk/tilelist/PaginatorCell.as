package com.rnk.tilelist 
{
	import client.resourcemanager.ResourceManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author Sulus Ltd.
	 */
	public class PaginatorCell extends Sprite
	{
		protected var pg:int;
		protected var papa:Paginator;
		protected var bg:MovieClip;
		
		public function PaginatorCell() 
		{
			bg = ResourceManager.GetInstance().GetAsset("gui", "paginator.page_btn");
			addChild(bg);
		}
		
		public function Init(papa:Paginator, pg:int):void
		{
			this.papa = papa;
			this.pg = pg;
			
			SetListeners(true);
			bg.mouseChildren = false;
			
			bg.page.text = pg;
			
		}
		
		public function Die():void
		{
			SetListeners(false);
		}
		
		public function SetListeners(orly:Boolean):void
		{
			(orly ? bg.addEventListener : bg.removeEventListener) (MouseEvent.MOUSE_OVER, 	OnMouseOver);
			(orly ? bg.addEventListener : bg.removeEventListener) (MouseEvent.MOUSE_OUT, 	OnMouseOut);
			(orly ? bg.addEventListener : bg.removeEventListener) (MouseEvent.MOUSE_UP, 	OnMouseUp);
			(orly ? bg.addEventListener : bg.removeEventListener) (MouseEvent.MOUSE_DOWN, 	OnMouseDown);
		}
		
		private function OnMouseOver(e:MouseEvent):void
		{
			//bg.gotoAndStop(2);
			//bg.page.text = pg;
			bg.filters = [new GlowFilter(0xffffff)];
		}
		
		private function OnMouseOut(e:MouseEvent):void
		{
			//bg.gotoAndStop(1);
			//bg.page.text = pg;
			bg.filters = [];
		}
		
		private function OnMouseUp(e:MouseEvent):void
		{
			bg.gotoAndStop(1);
			bg.page.text = pg;
			
			papa.PageSelected(pg);
		}
		
		private function OnMouseDown(e:MouseEvent):void
		{
			bg.gotoAndStop(3);
			bg.page.text = pg;
		}
		
		public function Select(orly:Boolean):void
		{
			bg.gotoAndStop(orly ? 3 : 1);
			bg.page.text = pg;
		}
	}

}