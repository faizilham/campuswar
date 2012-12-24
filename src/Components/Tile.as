package Components 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	public class Tile extends MovieClip
	{
		//tiles
		private var spr_def : Bitmap;
		private var spr_act : Bitmap;
		private var spr_atk : Bitmap;
		private var spr_spe : Bitmap;
		
		//
		private var curr_sprite : Bitmap;
		public var stat : int;
		public var mark : int;
		public var area : Rectangle
		
		public function Tile(position : Point) 
		{
			spr_def = new Images["tile_default"];
			spr_act = new Images["tile_active"];
			spr_atk = new Images["tile_attack"];
			spr_spe = new Images["tile_special"];
			curr_sprite = new Bitmap(spr_def.bitmapData);
			curr_sprite.x = position.x;
			curr_sprite.y = position.y;
			area = new Rectangle(curr_sprite.x, curr_sprite.y, curr_sprite.width, curr_sprite.height);
			
			addChild(curr_sprite);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut,false,0,true);
			stat = 0;
			mark = 0;
			
		}
		
		/* sprite functions
		public function setDefaultSprite():void {
			curr_sprite.bitmapData = spr_def.bitmapData;
		}
		
		public function setActiveSprite():void {
			curr_sprite.bitmapData = spr_act.bitmapData;
		}*/
		
		// mouse functions
		
		private function mouseOver(mouseEvent : MouseEvent):void {
			if (stat == 0) {
				Mouse.cursor = MouseCursor.ARROW;
			}else {
				Mouse.cursor = MouseCursor.BUTTON;
			}
		}
		
		private function mouseOut(mouseEvent : MouseEvent):void {
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		public function getPos():Point {
			return new Point(area.x, area.y);
		}
		
		public function setStat(n : int):void {
			stat = n;
			switch (stat) {
				case 0:
					curr_sprite.bitmapData = spr_def.bitmapData;
				break;
				case 1:
					curr_sprite.bitmapData = spr_act.bitmapData;
				break;
				case 2:
					curr_sprite.bitmapData = spr_atk.bitmapData;
				break;
				case 3:
					curr_sprite.bitmapData = spr_spe.bitmapData;
				break;
			}
		}
		
		public function checkMouse(mouse : Point):Boolean {
			//klik di area button
			if (mouse.x > area.x && mouse.x<area.width + area.x && mouse.y > area.y && mouse.y<area.height + area.y) {
				return true;
			}else {
				return false;
				
			}
		}
	}

}