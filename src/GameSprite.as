package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class GameSprite 
	{
		public var image : BitmapData;
		public var position : Point;
		public var origin : Point;
		private var hitArea : Rectangle;
		
		public function GameSprite(image : Bitmap, position : Point, origin : Point = null) 
		{
			this.image = image.bitmapData;
			this.position = position;
			if(origin == null){
				this.origin = new Point(0, 0);
			}else {
				this.origin = origin;
			}
			hitArea = new Rectangle(0, 0, this.image.width, this.image.height);
		}
		
		public function render(canvas : BitmapData) {
			canvas.copyPixels(image, new Rectangle(0, 0, image.width, image.height), position.subtract(origin));
		}
		
		public function intersect (anotherSprite : GameSprite) : Boolean {
			hitArea.x = position.x;
			hitArea.y = position.y;
			return hitArea.intersects(anotherSprite.getHitArea());
		}
		
		public function getHitArea() : Rectangle {
			hitArea.x = position.x;
			hitArea.y = position.y;
			return hitArea;
		}
	}

}