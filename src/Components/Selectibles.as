package Components{
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GamePhase.SelectChar;
	
	 
	public class Selectibles extends MovieClip
	{
		public var selSprite : Bitmap;
		private var area : Rectangle;	
		public var info : String;
		public var charno : int;
		
		public function Selectibles(position : Point, Face1 : Class, inf: String, charno : int):void {
						
			//sprites
			selSprite = new Face1;
			selSprite.x = position.x; selSprite.y = position.y;
			area = new Rectangle(selSprite.x, selSprite.y, selSprite.width, selSprite.height);
			
			info = inf;
			this.charno = charno;
			
			//listener hover
			addEventListener(MouseEvent.MOUSE_OVER, setHover,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT, setUp,false,0,true);
			
			addChild(selSprite);
			visible = true;
		}


		public function checkMouse(mouse : Point):Boolean {
			
			//klik di area button
			if (mouse.x > area.x && mouse.x<area.width + area.x && mouse.y > area.y && mouse.y<area.height + area.y) {
				return true;
			}else {
				return false;
				
			}
		}
			
		private function setUp(mouseEvent : MouseEvent):void {
			SelectChar.infotext.htmlText = "";
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		private function setHover(mouseEvent : MouseEvent):void {
			SelectChar.infotext.htmlText = info.valueOf();
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		public function setPos(p : Point):void {
			area.x = p.x;
			area.y = p.y;
			selSprite.x = p.x;
			selSprite.y = p.y;
		}
	}

}
