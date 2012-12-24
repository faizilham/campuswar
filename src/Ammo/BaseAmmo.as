package Ammo 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	public class BaseAmmo extends MovieClip
	{
		protected const speedDivider : Number = 25;
		protected var velocity : Point;
		public var area : Rectangle;
		public var finalPos : Point;
		protected var spr : Bitmap;
		public var power:Number;
		public var owner : int;
		
		public function BaseAmmo(start: Point, end:Point, img : Class, power:Number, owner:int) 
		{
			spr = new img;
			spr.x = start.x;
			spr.y = start.y;
			addChild(spr);
			area = new Rectangle(start.x, start.y, spr.width, spr.height);
			finalPos = end;
			this.power = power;
			velocity = new Point((end.x - start.x) / speedDivider, (end.y - start.y) / speedDivider);
			this.owner = owner;
		}
		
		public function Animate(elapsedTime : Number):void {
			//if (area.x >= finalPos.x && area.y >= finalPos.y) {
				area.x += velocity.x;
				area.y += velocity.y;
				spr.x += velocity.x;
				spr.y += velocity.y;
			//}
		}
		
	}

}