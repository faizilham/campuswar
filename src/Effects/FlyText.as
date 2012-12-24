package Effects 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	public class FlyText extends MovieClip
	{
		public var info : TextField;
		public var id : int = 0;
		public var pow : int;
		private var finalY : Number;
		public var finish : Boolean;
		public function FlyText(infotext : String, red : Boolean, startPos : Point, finalY : Number) 
		{
			info = new TextField();
			//info.defaultTextFormat = format;
			if (red) info.defaultTextFormat = new TextFormat("Calibri", 25, 0xFF0000, true);
			else info.defaultTextFormat = new TextFormat("Calibri", 25, 0x00FF00, true);
			
			info.alpha = 1;
			info.autoSize = TextFieldAutoSize.CENTER;
			info.text = infotext;
			this.finalY = startPos.y - finalY;
			
			info.x = startPos.x;
			info.y = startPos.y
			finish = false;
			addChild(info);
		}
		
		public function Animate(elapsedTime:Number):void {
			if (info.y > finalY) {
				info.y -= 1.3;
				if (info.alpha>0) info.alpha -= 0.05;
			}else {
				finish = true;
			}
		}
		
	}

}