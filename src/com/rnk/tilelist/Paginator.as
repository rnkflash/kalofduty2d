package com.rnk.tilelist 
{
	import client.resourcemanager.ResourceManager;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Sulus Ltd.
	 */
	public class Paginator extends Sprite
	{
		public static const PAGE_SELECTED:String = "page_selected";
		
		private var tileList	:TileList;
		private var cellClass	:Class;
		private var sprite		:Sprite;
		private var w			:Number;
		private var offset		:Number = 32;
		private var btns		:Array = [];
		private var msk			:Sprite;
		
		public function Paginator(/*cellClass:Class*/) 
		{
			var cellClass:Class;
			cellClass = PaginatorCell;
			
			this.cellClass = cellClass;
			sprite = new Sprite();
			addChild(sprite);
			
			msk = new Sprite();
			addChild(msk);
			sprite.mask = msk;
		}
		
		public function SetTileList(tl:TileList):void 
		{
			tileList = tl;
			
			var pageBtn:PaginatorCell;
			//var offset:Number = w / tileList.maxPages;
			
			for (var i:int = 0; i < tileList.maxPages; i++ )
			{
				pageBtn = new cellClass();
				pageBtn.x = i * offset;
				pageBtn.Init(this, i + 1);
				sprite.addChild(pageBtn);
				btns.push(pageBtn);
			}
			
		}
		
		public function SetWidth(w:Number):void
		{
			this.w = w;
			msk.graphics.clear();
			msk.graphics.beginFill(0xffffff, 0.3);
			msk.graphics.drawRect(0, -10, w, 40);
			msk.graphics.endFill();
		}
		
		public function SetOffset(off:Number):void
		{
			this.offset = off;
		}
		
		public function PageSelected(pg:int):void
		{
			//TODO маску и скролл
			
			var visibleBtns:int = Math.floor(w / offset);
			var pos:int = (pg - Math.ceil(visibleBtns / 2));
			var minpos:int = -offset * (btns.length - visibleBtns);
			var maxpos:int = 0;
			if (w < sprite.width)
				sprite.x = Math.max(Math.min( -pos * offset, maxpos ), minpos);
			
			tileList.ToPage(pg - 1);
			
			for (var i:int = 0; i < btns.length; i++ )
				(btns[i] as PaginatorCell).Select(i + 1 == pg);
			
			dispatchEvent(new Event(PAGE_SELECTED));
		}
		
		public function Refresh():void
		{
			var pageBtn:PaginatorCell;
			var i:int;
			
			for (i = btns.length - 1; i >= 0; i-- )
			{
				pageBtn = btns[i];
				pageBtn.Die();
				sprite.removeChild(pageBtn);
				btns.splice(i, 1);
			}
			
			
			//var offset:Number = w / tileList.maxPages;
			
			for (i = 0; i < tileList.maxPages; i++ )
			{
				pageBtn = new cellClass();
				pageBtn.x = i * offset;
				pageBtn.Init(this, i + 1);
				sprite.addChild(pageBtn);
				btns.push(pageBtn);
			}
			
			for (i = 0; i < btns.length; i++ )
				(btns[i] as PaginatorCell).Select(i + 1 == tileList.currentPage + 1);
		}
		
		public function Die():void
		{
			for (var i:int = 0; i < btns.length; i++ )
			{
				(btns[i] as PaginatorCell).Die();
			}
			
			btns = [];
		}
		
		public function SetListeners(orly:Boolean): void
		{
			for (var i:int = 0; i < btns.length; i++ )
			{
				(btns[i] as PaginatorCell).SetListeners(orly);
			}
		}
	}

}