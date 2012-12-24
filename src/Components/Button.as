package Components{		
	
	
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	
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
	
  public class Button extends MovieClip
  {		
	
	private var buttonSprite : Bitmap;
	private var up : Bitmap;
	private var hover : Bitmap;
	private var area : Rectangle;
	public var ButtonText : TextField;
	public var formatUp:TextFormat, formatHover : TextFormat;
	
    public function Button(position : Point = null, btext : String = null):void {
		
		//defaults
		if (position == null) position = new Point(0, 0);
		if (btext == null) btext = new String("");
		
		//sprites
		up = new Images["buttonUp"];
		hover = new Images["buttonHover"];
		
		buttonSprite = new Bitmap(up.bitmapData);
		buttonSprite.x = position.x; buttonSprite.y = position.y;
		area = new Rectangle(buttonSprite.x, buttonSprite.y, buttonSprite.width, buttonSprite.height);
		
		//format text
		formatUp = new TextFormat("Arial",16,0xFFFFFF,true,null,null,null,null,"center");
		formatHover = new TextFormat("Arial",16,0x000000,true,null,null,null,null,"center");
		
		//button text
		ButtonText = new TextField();
		ButtonText.width = area.width;
		ButtonText.height = area.height;
		
		ButtonText.x = position.x ;
		ButtonText.y = position.y + 4;
		
		ButtonText.defaultTextFormat = formatUp;
		ButtonText.background = false;
		ButtonText.text = btext;
		ButtonText.selectable = false;
		
		//listener hover
		addEventListener(MouseEvent.MOUSE_OVER, setHover,false,0,true);
		addEventListener(MouseEvent.MOUSE_OUT, setUp,false,0,true);
		addEventListener(MouseEvent.CLICK, mouseClick,false,0,true);
		
		addChild(buttonSprite);
		addChild(ButtonText);
		
		
		visible = true;
		
    }
	
	private function mouseClick(mouseEvent : MouseEvent):void {
		Main.sfx = new SoundHandler("", SoundList.SFX_click);
		Main.sfx.play();
	}
	
	private function setUp(mouseEvent : MouseEvent):void {
		buttonSprite.bitmapData = up.bitmapData;
		Mouse.cursor = MouseCursor.ARROW;
		ButtonText.setTextFormat(formatUp);
	}
	private function setHover(mouseEvent : MouseEvent):void {
		buttonSprite.bitmapData = hover.bitmapData;
		Mouse.cursor = MouseCursor.BUTTON;
		ButtonText.setTextFormat(formatHover);
	}
	/*
	private function setMask(Face1 : Class, Face2 : Class) {
		up = new GameSprite(new Face1, area.x);
		hover = new GameSprite(new Face2, area.y);
		buttonSprite = up;
	}*/
	
    public function checkMouse(mouse : Point):Boolean {
		
		//klik di area button
		if (mouse.x > area.x && mouse.x<area.width + area.x && mouse.y > area.y && mouse.y<area.height + area.y) {
			return true;
		}else {
			return false;
			
		}
    }
	
	public function setVisible():void {
		visible = !visible;
	}
	
}
}