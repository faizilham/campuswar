package Effects 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.system.LoaderContext;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.display.Loader;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	public class Explosion extends MovieClip
	{
		[Embed(source = "../../assets/FX/explode.swf", mimeType="application/octet-stream")] private var fxExplode : Class;
		public var finish : Boolean;
		public var id : int = 2;
		public var pow : int;
		private var img : MovieClip;
		private var count : int;
		private var frame : int;
		private var start : Boolean;
		private var loader : Loader;
		public var position : Point;
		
		
		public function Explosion(position : Point) 
		{
			finish = false;
			start = false;
			this.position = position;
			
			
			
			frame = 1;
			count = 0;

			var context : LoaderContext = new LoaderContext (false, ApplicationDomain.currentDomain);
			context.allowCodeImport = true;
			loader = new Loader ();
			loader.loadBytes (new fxExplode() as ByteArray, context);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete,false,0,true);
		}
		
		
		private function loadComplete(e:Event):void {
			img = loader.content as MovieClip;
			img.x = position.x;
			img.y = position.y;
			img.gotoAndStop(1);
			start = true;
			addChild(img);
		}
		
		public function Animate(elapsedTime:Number):void {
			if(start){
				if (frame == img.totalFrames) {
					finish = true;
				}else {
					if (count < 2) {
						count++;
					}else {
						count = 0;
						frame++;
						img.gotoAndStop(frame);
					}
				}
			}
		}
		
	}

}