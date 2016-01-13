package com.rnk.tilelist 
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import fl.data.DataProvider;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sulus Ltd.
	 */
	public class TileList extends Sprite
	{
		public static const SCROLL_HORIZONTAL:int = 0;
		public static const SCROLL_VERTICAL:int = 1;
		
		public static const PAGE_MODE:int = 0;		// Постраничный скролл
		//public static const COLUMN_MODE:int = 1;	// Скролл по столбцам
		public static const POSITION_MODE:int = 2;	// Произвольный скролл
		
		protected var _spriteHolder:Sprite;
		protected var _direction:int = SCROLL_HORIZONTAL;
		protected var _offsetX:Number = 0;
		protected var _offsetY:Number = 0;
		protected var _scrollX:Number = 0;
		protected var _scrollY:Number = 0;
		protected var _cells:Vector.<TileCell> = new Vector.<TileCell>();
		protected var _rows:int = 3;
		protected var _columns:int = 3;
		protected var _page:int = 0;
		protected var _pages:int = 1;
		protected var _dataProvider:DataProvider = new DataProvider();
		protected var _tileCellClass:Class;
		protected var _scrollWidth:Number;
		protected var _scrollHeight:Number;
		protected var _offsetBetweenPages:Number = 0;
		protected var _smoothScroll:Number = 0;
		
		protected var paginator:Paginator;
		
		protected var mPos:int = 0;
		protected var mMaxPos:int = 0;
		protected var _scrollMode:int = PAGE_MODE;
		
		protected var mMultipleSelection:Boolean = false;
		protected var mSelectedIndices:Array = [];
		
		public var data:Object;
		
		public function TileList(
									cellClass:Class, 
									_rows:int = 3, 
									_columns:int = 3, 
									_offsetX:Number = 100,
									_offsetY:Number=100,
									_direction:int = SCROLL_HORIZONTAL,
									_scrollMode:int = PAGE_MODE
								) 
		{
			_tileCellClass = cellClass;
			_spriteHolder = new Sprite();
			addChild(_spriteHolder);
			
			this._rows = _rows;
			this._columns = _columns;
			this._direction = Math.min(_direction, SCROLL_VERTICAL);
			this._offsetX = _offsetX;
			this._offsetY = _offsetY;
			this._scrollMode = _scrollMode;
			
			addEventListener(Event.ADDED_TO_STAGE, OnAddedToStage, false, 0, true);
		}
		
		protected function OnAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, OnRemovedFromStage, false, 0, true);
			Refresh();
		}
		
		protected function OnRemovedFromStage(e:Event):void 
		{
			SetCellListeners(false);
			removeEventListener(Event.REMOVED_FROM_STAGE, OnRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, OnAddedToStage, false, 0, true);
			Clear();
		}
		
		public function NextPage():void
		{
			if (_scrollMode == PAGE_MODE)
				currentPage++;
			else
				SetPosition(Math.min(mPos + offsetX * columns, mMaxPos));
		}
		
		public function PrevPage():void
		{
			if (_scrollMode == PAGE_MODE)
				currentPage--;
			else
				SetPosition(Math.max(0, mPos - offsetX * columns));
		}
		
		public function FirstPage():void
		{
			if (_scrollMode == PAGE_MODE)
				currentPage = 0;
			else
				SetPosition(0);
		}
		
		public function LastPage():void
		{
			if (_scrollMode == PAGE_MODE)
				currentPage = maxPages;
			else
				SetPosition(mMaxPos);
		}
		
		public function ToPage(value:int):void
		{
			if (_scrollMode == PAGE_MODE)
				currentPage = value;
		}
		
		public function get maxPages():int
		{
			return _pages;
		}
		
		public function get currentPage():int
		{
			return _page;
		}
		
		public function set currentPage(value:int):void
		{
			HidePage();
			
			var elemcount:int = _rows * _columns;
			var offset:int = elemcount * _page;
			for (var i:int = Math.max(0,offset); i < Math.min(offset + elemcount, _cells.length); i++) 
			{
				if (_cells[i])
					_cells[i].OnHide();
			}
			
			_page = Math.max(0,Math.min(value, _pages - 1));
			
			if (_direction == SCROLL_VERTICAL)
			{
				scrollX = 0;
				if (_smoothScroll==0)
					scrollY = _page * (_scrollHeight + _offsetBetweenPages);
				else
					TweenLite.to(this, _smoothScroll, { ease:Quad.easeInOut,scrollY:_page * (_scrollHeight + _offsetBetweenPages) } );
			} else
			{
				if (_smoothScroll==0)
					scrollX = _page * (_scrollWidth + _offsetBetweenPages);
				else
					TweenLite.to(this, _smoothScroll, {  ease:Quad.easeInOut,scrollX:_page * (_scrollWidth + _offsetBetweenPages) } );
				scrollY = 0;
			}
			
			elemcount = _rows * _columns;
			offset = elemcount * _page;
			for (i = Math.max(0,offset); i < Math.min(offset + elemcount, _cells.length); i++) 
			{
				if (_cells[i])
					_cells[i].OnShow();
			}
			
			ShowPage();
		}
		
		public function get rows():int
		{
			return _rows;
		}
		public function set rows(value:int):void
		{
			_rows = Math.max(value, 1);
			Refresh();
		}
		
		public function get columns():int
		{
			return _columns;
		}
		public function set columns(value:int):void
		{
			_columns = Math.max(1,value);
			Refresh();
		}
		
		public function get direction():int 
		{ 
			return _direction; 
		}
		
		public function set direction(value:int):void 
		{
			_direction = value;
			Refresh();
		}
		
		public function get dataProvider():DataProvider 
		{ 
			return _dataProvider.clone(); 
		}
		
		public function set dataProvider(value:DataProvider):void 
		{
			//Clear();
			
			_dataProvider = value.clone();
			Refresh();
		}
		
		public function get scrollX():Number { return _scrollX; }
		
		public function set scrollX(value:Number):void 
		{
			_scrollX = value;
			_spriteHolder.x = -_scrollX;
			
		}
		
		public function get scrollY():Number { return _scrollY; }
		
		public function set scrollY(value:Number):void 
		{
			_scrollY = value;
			_spriteHolder.y = -_scrollY;
		}
		
		public function get scrollWidth():Number { return _scrollWidth; }
		
		public function get scrollHeight():Number { return _scrollHeight; }
		
		public function get offsetX():Number { return _offsetX; }
		
		public function set offsetX(value:Number):void 
		{
			_offsetX = value;
			Refresh();
		}
		
		public function get offsetY():Number { return _offsetY; }
		
		public function set offsetY(value:Number):void 
		{
			_offsetY = value;
			Refresh();
		}
		
		public function get offsetBetweenPages():Number { return _offsetBetweenPages; }
		
		public function set offsetBetweenPages(value:Number):void 
		{
			_offsetBetweenPages = value;
			Refresh();
		}
		
		public function get smoothScroll():Number { return _smoothScroll; }
		
		public function set smoothScroll(value:Number):void 
		{
			_smoothScroll = Math.max(0,value);
		}
		
		public function get cells():Vector.<TileCell> { return _cells.slice(); }
		
		protected function Refresh():void
		{
			Clear();
			
			mMaxPos = ( direction == SCROLL_HORIZONTAL ? _offsetX * _columns : _offsetY * _rows) * (Math.ceil(_dataProvider.length / (_columns * _rows) - 1 ));
			_pages = Math.ceil(_dataProvider.length / (_columns * _rows));
			_page = Math.min(_page, _pages);
			
			_scrollHeight = _offsetY * _rows;
			_scrollWidth = _offsetX * _columns;
			
			for (var i:int = 0; i < _dataProvider.length; i++) 
			{
				//var tilecell:TileCell = new _tileCellClass();
				//tilecell.SetData(_dataProvider.getItemAt(i));
				//tilecell.SetPapa(this);
				_cells.push(null);
			}
			
			/*for (var i:int = 0; i < _dataProvider.length; i++) 
			{
				var tilecell:TileCell = new _tileCellClass();
				tilecell.SetData(_dataProvider.getItemAt(i));
				tilecell.SetPapa(this);
				
				var ix:int, iy:int, locali:int,locali2:int;
				
				locali = Math.floor(i / (_columns * _rows));
				locali2 = i % (_columns * _rows);
				
				ix = locali2 % _columns;
				iy = Math.floor(locali2 / _columns);
				
				tilecell.x = ix * _offsetX + (_direction == SCROLL_HORIZONTAL?locali * (_offsetX * _columns+_offsetBetweenPages):0);
				tilecell.y = iy * _offsetY + (_direction == SCROLL_VERTICAL?locali * (_offsetY * _rows+_offsetBetweenPages):0);
				
				_spriteHolder.addChild(tilecell);
				_cells.push(tilecell);
				
				tilecell.Init();
				
				tilecell.addEventListener(TileCell.SELECTED, OnCellSelected);
				
			}*/
			
			currentPage = _page;
			
			if (paginator)	paginator.Refresh();
			
			
			SetCellListeners(true);
		}
		
		protected function Clear():void 
		{
			for (var i:int = 0; i < _cells.length; i++) 
			{
				if (_cells[i])
				{
					_cells[i].Die();
					if (_cells[i].parent)
						_spriteHolder.removeChild(_cells[i]);
					_cells[i].removeEventListener(TileCell.SELECTED, OnCellSelected);
				}
			}
			_cells = new Vector.<TileCell>();
		}
		
		protected function HidePage():void
		{
			if (_cells.length == 0) return;
			
			var starti:int;
			var endi:int;
			
			if (_scrollMode == PAGE_MODE)
				starti = _page * _columns * _rows;
			else
				starti = Math.floor(mPos / _offsetX);
			
			endi = Math.min(starti + _columns * _rows, _cells.length);
			
			//trace("hide:", "starti =", starti, "endi =", endi);
			
			for (var i:int = starti; i < endi; i++) 
			{
				if (_cells[i])
				{
					//_cells[i].Die();
					_spriteHolder.removeChild(_cells[i]);
					_cells[i].removeEventListener(TileCell.SELECTED, OnCellSelected);
					_cells[i].OnHide();
				}
			}
		}
		
		protected function ShowPage():void
		{
			if (_dataProvider.length == 0) return;
			
			var starti:int;
			var endi:int;
			
			if (_scrollMode == PAGE_MODE)
				starti = _page * _columns * _rows;
			else
				starti = Math.floor(mPos / _offsetX);
			
			endi = Math.min(starti + _columns * _rows, dataProvider.length);
			
			//trace("show:", "starti =", starti, "endi =", endi);
			
			for (var i:int = starti; i < endi; i++) 
			{
				var tilecell:TileCell = new _tileCellClass();
				tilecell.SetData(_dataProvider.getItemAt(i));
				tilecell.SetPapa(this);
				
				var ix:int, iy:int, locali:int,locali2:int;
				
				locali = Math.floor(i / (_columns * _rows));
				locali2 = i % (_columns * _rows);
				
				ix = locali2 % _columns;
				iy = Math.floor(locali2 / _columns);
				
				tilecell.x = ix * _offsetX + (_direction == SCROLL_HORIZONTAL?locali * (_offsetX * _columns+_offsetBetweenPages):0);
				tilecell.y = iy * _offsetY + (_direction == SCROLL_VERTICAL?locali * (_offsetY * _rows+_offsetBetweenPages):0);
				
				_spriteHolder.addChild(tilecell);
				_cells[i] = tilecell;// .splice(i, 0, tilecell); //.push(tilecell);
				
				tilecell.Init();
				
				tilecell.addEventListener(TileCell.SELECTED, OnCellSelected);
				
				tilecell.OnShow();
			}
			
			if (paginator)	paginator.Refresh();
		}
		
		public function SetPaginator(paginator:Paginator):void
		{
			if (_scrollMode == PAGE_MODE)
				this.paginator = paginator;
			paginator.PageSelected(currentPage + 1);
		}
		
		public function RemoveItemAt(index:int):void
		{
			_dataProvider.removeItemAt(index);
			Refresh();
		}
		
		public function RemoveItem(pcell:PaginatorCell):void
		{
			var index:int = _cells.indexOf(pcell);
			
			_dataProvider.removeItemAt(index);
			Refresh();
			
			//TODO mSelectedIndices
		}
		
		//TODO paginator и НЕстраничный режим НЕ могут использоваться одновременно
		
		public function NextColumn():void
		{
			if (_scrollMode == POSITION_MODE)
			{
				var off:int = (direction == SCROLL_HORIZONTAL ? offsetX : offsetY)
				SetPosition(Math.min(mMaxPos, mPos + off));
			}
		}
		
		public function PrevColumn():void
		{
			if (_scrollMode == POSITION_MODE)
			{
				var off:int = (direction == SCROLL_HORIZONTAL ? offsetX : offsetY)
				SetPosition(Math.max(0, mPos - off));
			}
		}
		
		public function SetPosition(newPos:int):void
		{
			HidePage();
			
			mPos = newPos;
			
			if (_direction == SCROLL_VERTICAL)
			{
				scrollX = 0;
				if (_smoothScroll==0)
					scrollY = mPos;
				else
					TweenLite.to(this, _smoothScroll, { ease:Quad.easeInOut,scrollY:mPos } );
			} else
			{
				if (_smoothScroll==0)
					scrollX = mPos;
				else
					TweenLite.to(this, _smoothScroll, {  ease:Quad.easeInOut,scrollX:mPos } );
				scrollY = 0;
			}
			
			var elemcount:int = _rows * _columns;
			var offset:int = Math.floor(mPos / _offsetX);
			
			for (var i:int = Math.max(0,offset); i < Math.min(offset + elemcount, _cells.length); i++) 
			{
				if (_cells[i])
					_cells[i].OnShow();
			}
			
			ShowPage();
		}
		
		public function get currentPos():int
		{
			return mPos;
		}
		
		protected function SetCellListeners(orly:Boolean):void
		{
			for (var i:int = 0; i < _cells.length; i++ )
			{
				if (_cells[i])
					(orly ? _cells[i].addEventListener : _cells[i].removeEventListener)(TileCell.SELECTED, OnCellSelected);
			}
		}
		
		protected function OnCellSelected(e:Event):void
		{
			// В зависимости от mMultipleSelection, mSelectedIndices 
			//		добавить/удалить индексы из mSelectedIndices ?
			//		переключить в ячейках режим "выделено/невыделено"
			
			var index:int = _cells.indexOf(e.currentTarget);
			
			if (!mMultipleSelection)
			{
				mSelectedIndices = [];
				for (var i:int = 0; i < _cells.length ; i++ )
				{
					if (_cells[i])
						_cells[i].Select(false);
				}
			}
			
			if (mSelectedIndices.indexOf(index) >= 0)
			{
				//deselect
				mSelectedIndices.splice(mSelectedIndices.indexOf(index), 1);
			}
			else
			{
				mSelectedIndices.push(index);
				_cells[index].Select(true);
			}
		}
		
		public function get selectedIndices(): Array
		{
			return mSelectedIndices;
		}
		
		public function GetPaginator():Paginator
		{
			return paginator;
		}
		
		public function ToFront(cell:TileCell):void
		{
			_spriteHolder.setChildIndex(cell, _spriteHolder.numChildren - 1);
		}
	}

}