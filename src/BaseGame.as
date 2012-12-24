package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BaseGame 
	{
		
		public var displayContainer : MovieClip;
		//public var parent : MovieClip;
		
		
		// Game Loop
		private var gameLoop : GameLoop;
		
		// Untuk Rendering
		protected var screenWidth : int;
		protected var screenHeight : int;
		protected var canvasBD : BitmapData;
		protected var canvasBitmap : Bitmap;
		
		// Untuk Menghitung FPS
		protected var frameRate : int;
		private var frameCounter : int;
		private var timeFPSCount : Number;
		private var FPSlabel : TextField;
		public var Tlabel : TextField;
		protected var input : Input;
		
		// ----------------------------------------------------------
		// KONSTRUKTOR BEGIN
		public function BaseGame(displayContainer:MovieClip) {
			
			// ambil Height dan Width dari layar
			this.screenHeight = displayContainer.stage.stageHeight;
			this.screenWidth = displayContainer.stage.stageWidth;
			
			// buat tempat untuk gambar-gambaran
			//canvasBD = new BitmapData(screenWidth, screenHeight, false, 0x000000);
			canvasBitmap = new Images["bgmenu"];
			
			// buat label baru
			FPSlabel = new TextField();
			FPSlabel.autoSize = TextFieldAutoSize.RIGHT;
			FPSlabel.x = this.screenWidth - FPSlabel.width;
			FPSlabel.textColor = 0xFFFFFF;
			FPSlabel.background = true;
			FPSlabel.backgroundColor = 0x000000;
			
			//trace label
			Tlabel = new TextField();
			Tlabel.autoSize = TextFieldAutoSize.RIGHT;
			Tlabel.x = 0;
			Tlabel.y = 0;
			Tlabel.textColor = 0xFFFFFF;
			Tlabel.background = true;
			Tlabel.backgroundColor = 0x000000;
			
			this.displayContainer = displayContainer;//new MovieClip();
			//parent = displayContainer;
			this.displayContainer.addChild(canvasBitmap);
			//this.displayContainer.addChild(FPSlabel);
			this.displayContainer.addChild(Tlabel);			
			
			input = new Input();
			this.displayContainer.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed,false,0,true);
			this.displayContainer.addEventListener(KeyboardEvent.KEY_UP, keyReleased,false,0,true);
			this.displayContainer.addEventListener(MouseEvent.CLICK, mouseClick,false,0,true);
			this.displayContainer.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove,false,0,true);
			
			/*parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed,false,0,true);
			parent.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased,false,0,true);
			parent.stage.addEventListener(MouseEvent.CLICK, mouseClick,false,0,true);
			parent.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove,false,0,true);*/
			
			
			
		}
		// KONSTRUKTOR END
		// ----------------------------------------------------------
		
		// ----------------------------------------------------------
		// SELEKTOR BEGIN
		
		public function getScreenWidth():int {
			return screenWidth;
		}
		
		public function getScreenHeight():int {
			return screenHeight;
		}
		
		// SELEKTOR END
		// ----------------------------------------------------------
		
		// ----------------------------------------------------------
		// INITIALIZER BEGIN
		
		// inisialisasi untuk nilai-nilai frame
		public function Initialize():void {
			frameRate = 0;
			frameCounter = 0;
			timeFPSCount = 0;
			//parent.addChild(this.displayContainer);
		}
		
		public function dispose():void {
			/*parent.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			parent.stage.removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
			parent.stage.removeEventListener(MouseEvent.CLICK, mouseClick);
			parent.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);*/
			
			this.displayContainer.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			this.displayContainer.removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
			this.displayContainer.removeEventListener(MouseEvent.CLICK, mouseClick);
			this.displayContainer.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			
			//parent.removeChild(this.displayContainer);
			
			
		}
		
		// inisialisasi untuk game loop
		private function initGameLoop():void {
			gameLoop = new GameLoop(this);
			gameLoop.start();
		}
		
		// INITIALIZER END
		// ----------------------------------------------------------
		
		// ----------------------------------------------------------
		// LOADCONTENT, UPDATE, RENDER BEGIN
		
		public function loadContent():void {
			// override
			initGameLoop();
		}
		
		public function update(elapsedTime:Number):void {
			// override
		}
		
		public function render(elapsedTime:Number):void {
			// menghitung FPS dan label untuk FPS
			/*frameCounter++;
			timeFPSCount += elapsedTime;
			if (timeFPSCount >= 1) {
				timeFPSCount = 0;
				frameRate = frameCounter;
				frameCounter = 0;
			}
			FPSlabel.text = "" + frameRate + " FPS";
			*/
			// menggambar
			//canvasBD.lock();
			// masih kosong?
			//canvasBD.unlock();
		}
		
		// LOADCONTENT, UPDATE, RENDER END
		
		public function keyReleased(keyEvent : KeyboardEvent):void {
			//trace("lepas " + keyEvent.keyCode);
			input.keyReleased(keyEvent.keyCode);
		}
		
		
		public function keyPressed(keyEvent : KeyboardEvent):void {
			//trace("pencet " + keyEvent.keyCode);
			input.keyPressed(keyEvent.keyCode);
		}
		
		public function mouseClick(mouseEvent : MouseEvent) : Point {
			var mouseP : Point = new Point(mouseEvent.stageX, mouseEvent.stageY);
			//Tlabel.text = mouseEvent.stageX + ", " + mouseEvent.stageY;
			trace(mouseP)
			return mouseP;
		}
		
		public function mouseMove(mouseEvent : MouseEvent) : Point {
			var mouseP : Point = new Point(mouseEvent.stageX, mouseEvent.stageY);
			//Tlabel.text = mouseEvent.stageX + ", " + mouseEvent.stageY;
			return mouseP;
		}
		
		// ----------------------------------------------------------
	}

}