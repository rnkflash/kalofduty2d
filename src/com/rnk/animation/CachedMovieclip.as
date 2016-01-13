package com.rnk.animation
{
        import flash.display.Bitmap;
        import flash.display.BitmapData;
        import flash.display.MovieClip;
        import flash.display.Sprite;
        import flash.geom.Matrix;
        import flash.geom.Point;
        import flash.geom.Rectangle;
		import flash.utils.Dictionary;
		import flash.utils.getDefinitionByName;
        
        public class CachedMovieclip extends Sprite {
                private var clip:MovieClip;
                private var bmp:Bitmap;
                public var frames:Vector.<BitmapData>;
                public var offsets:Vector.<Point>;
                public var labels:Vector.<String>;
                public var currentFrame:int;
                
                public function CachedMovieclip() {
                        clip = null;
                        addChild(bmp = new Bitmap());
                        frames = new Vector.<BitmapData>();
                        offsets = new Vector.<Point>();
                        labels = new Vector.<String>();
                        currentFrame = 1;
                }
                public function free():void {
                        if (parent != null) parent.removeChild(this);
                        clip = null;
                        removeChild(bmp);
                        bmp = null;
                        frames = null;
                        offsets = null;
                        labels = null;
                }
                
                public function buildFromLibrary(Name:String):void {
                        var cls:Class = getDefinitionByName(Name) as Class;
                        if(cls != null) buildFromClip(new cls());
                }
                public function buildFromClip(Clip:MovieClip):void {
                        if (Clip == null) throw("Clip not found.");
                        if (clip != null) {
                                clip = null;
                                frames = new Vector.<BitmapData>();
                                offsets = new Vector.<Point>();
                        }
                        
                        clip = Clip;
						var child:MovieClip = clip.getChildAt(0) as MovieClip;
						
                        var r:Rectangle;
                        var bd:BitmapData;
                        var m:Matrix = new Matrix();
                        
                        var i:int;
                        var len:int = child.totalFrames;
                        for (i = 1; i <= len; ++i) {
							
                                child.gotoAndStop(i);
								r = clip.getBounds(clip);
								r.width *= clip.scaleX;
								r.height *= clip.scaleY;
								r.width = Math.ceil(r.width);
								r.height = Math.ceil(r.height);
								r.x = Math.floor(r.x);
								r.y = Math.floor(r.y);
                                bd = new BitmapData(Math.max(1, r.width), Math.max(1, r.height), true, 0x00000000);
                                m.identity();
                                m.translate(-r.x, -r.y);
                                m.scale(clip.scaleX, clip.scaleY);
                                bd.draw(clip, m);
                                frames.push(bd);
                                offsets.push(new Point(Math.floor(r.x * clip.scaleX), Math.floor(r.y * clip.scaleY)));
                                labels.push(clip.currentLabel);
                        }
                        
                        gotoAndStop(1);
                }
                
                public function get totalFrames():int {
                        return frames.length;
                }
                public function get currentLabel():String {
                        if(totalFrames == 0) return "";
                        return labels[currentFrame - 1];
                }
                
                
                public function gotoAndStop(frame:int):void {
                        if (totalFrames == 0) return;
                        currentFrame = Math.max(1, Math.min(totalFrames, frame));
                        bmp.bitmapData = frames[currentFrame - 1];
                        bmp.x = offsets[currentFrame - 1].x;
                        bmp.y = offsets[currentFrame - 1].y;
                }
                
                
                
                /* STATIC */
                static private var clips:Dictionary = new Dictionary();
                
                static public function getClip(mcClass:Class, customScale:Number=1.0):CachedMovieclip {
                        if(clips[mcClass] == null) {
                                var m:CachedMovieclip = new CachedMovieclip();
								var mc:MovieClip = new mcClass();
								mc.scaleX = mc.scaleY = customScale;
                                m.buildFromClip(mc);
                                clips[mcClass] = m;
                        }
                        
                        var clip:CachedMovieclip = new CachedMovieclip();
                        clip.frames = clips[mcClass].frames;
                        clip.offsets = clips[mcClass].offsets;
                        clip.labels = clips[mcClass].labels;
                        clip.gotoAndStop(1);
                        return clip;
                }
        }
}