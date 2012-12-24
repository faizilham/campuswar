package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	public class About extends MovieClip
	{
		
		private var info : TextField;
		private var back : Sprite;
		
		public function About(screenW : Number, screenH : Number) 
		{
			visible = false;
			info = new TextField();
			info.multiline = true;
			info.defaultTextFormat = new TextFormat("Arial", 16, 0x000000);
			
			info.autoSize = TextFieldAutoSize.CENTER;
			info.htmlText = "<b>About Campus War</b><br/>by Studio Tubuh Hangat<br/>Game Concept : Pandu Kartika Putra<br/>Game Builder   : Faiz Ilham<br/>Artwork             : Yodi Pramudito<br/><br/>Disclaimer<br/>BGM taken from Tsubasa Chronicle OST Album by Kajiura Yuki";
			
			back = new Sprite();
			back.graphics.beginFill(0xFFFFFF, 0.6);
			back.graphics.drawRect(screenW / 2 - info.width / 2 - 10, screenH / 2 - info.height / 2 - 10, info.width + 20, info.height + 20);
			back.graphics.endFill();
			
			info.x = screenW / 2 - info.width / 2;
			info.y = screenH / 2 - info.height /2;
			
			addChild(back);
			addChild(info);
			
		}
		
	}

}