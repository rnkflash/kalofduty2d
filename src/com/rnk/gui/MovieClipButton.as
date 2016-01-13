package com.rnk.gui 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class MovieClipButton extends Sprite
	{
		private var mc:MovieClip;
		private var onClickCallback:Function;
		private var onClickParams:Array;
		
		public function MovieClipButton(mc:MovieClip,OnClickCallback:Function,OnClickParams:Array=null) 
		{
			this.onClickCallback = OnClickCallback;
			this.onClickParams= OnClickParams;
			this.mc = mc;
			
			addChild(mc);
			
			addEventListener(MouseEvent.CLICK, OnMouseClick, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OVER, OnMouseOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, OnMouseUp, false, 0, true);
			
			mc.gotoAndStop(1);
			
			buttonMode = true;
			useHandCursor = true;
			
			mc.mouseChildren = false;
			mc.mouseEnabled = false;
		}
		
		private function OnMouseUp(e:MouseEvent):void 
		{
			mc.gotoAndStop(1);
		}
		
		private function OnMouseDown(e:MouseEvent):void 
		{
			mc.gotoAndStop(3);
		}
		
		private function OnMouseOut(e:MouseEvent):void 
		{
			mc.gotoAndStop(1);
		}
		
		private function OnMouseOver(e:MouseEvent):void 
		{
			mc.gotoAndStop(2);
		}
		
		private function OnMouseClick(e:MouseEvent):void 
		{
			if (Boolean(onClickCallback)) onClickCallback.apply(this,onClickParams);
		}
		
		
		
	}

}