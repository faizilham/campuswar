package Components{
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	
	public class Gauge extends MovieClip
	{
		public var min : Number;
		public var max : Number;
		private var face : Rectangle;
		private var back : Rectangle;
		private var faceR :Sprite;
		private var backR :Sprite;
		public var faceColor:int , backColor : int;
		public var value : Number;
		
		public function Gauge(area : Rectangle = null, min : Number = 0, max : Number = 100, faceColor : int = 0x00FF00, backColor : int = 0xFF0000) 
		{
			//defaults
			if (area == null) area = new Rectangle(0, 0, 100, 20);
			
			//init var
			this.min = min; this.max = max; this.faceColor = faceColor; this.backColor = backColor;
			
			//bagian face
			face = area.clone();
			faceR = new Sprite();
			faceR.graphics.beginFill(faceColor);
			faceR.graphics.drawRect(area.x, area.y, area.width, area.height);
			faceR.graphics.endFill();
			
			//bagian back
			back = area.clone();
			backR = new Sprite();
			backR.graphics.beginFill(backColor);
			backR.graphics.drawRect(area.x, area.y, area.width, area.height);
			backR.graphics.endFill();
			this.value = max;
			
			//masukkin ke display
			addChild(backR);
			addChild(faceR);
			
		}
		
		public function drawGauge(val: Number, max:Number, min:Number = 0):void {
			this.max = max;
			this.min = min;
			value = val;
			
			removeChild(faceR);
			
			//update bagian face
			face.width = val / max * back.width;
			faceR.graphics.clear();
			faceR.graphics.beginFill(faceColor);
			faceR.graphics.drawRect(face.x, face.y, face.width, face.height);
			faceR.graphics.endFill();
			addChild(faceR);
		}
		
		public function changeValue(val : Number):void {
			
			//biar selalu dalam range
			if (val < min) val = min;
			else if (val > max) val = max;
			
			value = val;
			removeChild(faceR);
			
			//update bagian face
			face.width = val / max * back.width;
			faceR.graphics.clear();
			faceR.graphics.beginFill(faceColor);
			faceR.graphics.drawRect(face.x, face.y, face.width, face.height);
			faceR.graphics.endFill();
			addChild(faceR);
		}
		
		public function changeBy(delta : Number, percentage : Boolean = false):void {
			var x : Number;
			if (percentage) {
				x = delta / 100 * value;
			}else {
				x = delta;
			}
			
			changeValue(value + x);
		}
		
		public function Show():void {
			visible = true;
		}
		
		public function Hide():void {
			visible = false;
		}
	}

}