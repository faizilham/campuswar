package GamePhase
{
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	
	 import flash.display.MovieClip;
	 import flash.display.Bitmap;
	 import flash.geom.Point;
	 import flash.geom.Rectangle;
	 import flash.system.fscommand;
	 import flash.text.TextField;
	 import flash.ui.Keyboard;
	 import flash.events.MouseEvent;
	 import Components.Button;
	 
	public class Menu extends BaseGame
	{
		
		private var button : Button;
		private var button2 : Button;
		private var button3 : Button;
		private var closeButton : Button;
		private var aboutButton : Button;
		private var dex : Dex;
		private var about : About;
		
		private var test : TextField;
		
		public function Menu(displayContainer:MovieClip) 
		{
			super(displayContainer);
			
		}
		
		override public function loadContent():void {
			super.loadContent();
			
			button = new Button(new Point(getScreenWidth() / 2 - 50, getScreenHeight()/2 + 90), new String("Play"));
			displayContainer.addChild(button);
			
			aboutButton = new Button(new Point(getScreenWidth() / 2 - 50, getScreenHeight()/2 + 180), new String("About"));
			displayContainer.addChild(aboutButton);
			
			button2 = new Button(new Point(getScreenWidth() / 2 - 50, getScreenHeight()/2 + 225), new String("Quit"));
			displayContainer.addChild(button2);
			
			closeButton = new Button(new Point(getScreenWidth() / 2 - 50, getScreenHeight() / 2 + 220), new String("Close"));
			closeButton.visible = false;
			displayContainer.addChild(closeButton);
			
			button3 = new Button(new Point(getScreenWidth() / 2 - 50, getScreenHeight()/2 + 135), new String("Story"));
			displayContainer.addChild(button3);
			
			dex = new Dex(getScreenWidth(), getScreenHeight());
			dex.visible = false;
			displayContainer.addChild(dex);
			
			about = new About(getScreenWidth(), getScreenHeight());
			displayContainer.addChild(about);
			
			/*BG = new GameSprite(new Background(), new Point(0, 0));
			player = new Player();
			player.playerSprite.position.x = (screenWidth - player.playerSprite.image.width) / 2;
			player.playerSprite.position.y = (screenHeight - player.playerSprite.image.height);
			enemy = new Enemy();
			enemy.enemySprite.position.x = (screenWidth - enemy.enemySprite.image.width) / 2; */
		}
		
		override public function render(elapsedTime:Number):void {
			super.render(elapsedTime);
			//canvasBD.copyPixels(BG.bitmapData, new Rectangle(0, 0, BG.width, BG.height), new Point( -350, -50));
			/*BG.render(canvasBD);
			player.playerSprite.render(canvasBD);
			enemy.enemySprite.render(canvasBD);*/
		}
		
		override public function update(elapsedTime:Number):void {
			super.update(elapsedTime);
			
			if (dex.downHold) {
				if (dex.infotext.scrollV < dex.infotext.maxScrollV) {
					dex.infotext.scrollV++;
				}else {
					dex.down.visible = false;
					dex.downHold = false;
				}
			}else if (dex.upHold){
				if (dex.infotext.scrollV > 1) {
					dex.infotext.scrollV--;
				}else {
					dex.up.visible = false;
					dex.upHold = false;
				}
			}
			
			/*updatePlayer(elapsedTime);
			updateEnemy(elapsedTime);
			updateCollision(elapsedTime);*/
		}
		
		override public function mouseClick(mouseEvent : MouseEvent) : Point {
			var mouseP : Point = new Point(mouseEvent.stageX, mouseEvent.stageY);
			
			
			Tlabel.text = "";
			if (button.checkMouse(mouseP) && button.visible) {
				//clear();
				
				Main.nextPhase();
			}
			
			if (button3.checkMouse(mouseP) && button3.visible) {
				
				dex.visible = true;
				closeButton.visible = true;
				aboutButton.visible = false;
				button.visible = false;
				button2.visible = false;
				button3.visible = false;
			}
			
			if (button2.checkMouse(mouseP) && button.visible) {
				fscommand("quit");
			}
			
			if (closeButton.checkMouse(mouseP) && closeButton.visible) {
				dex.visible = false;
				closeButton.visible = false;
				aboutButton.visible = true;
				button.visible = true;
				button2.visible = true;
				button3.visible = true;
			}
			
			if (about.visible) {
				about.visible = false;
				aboutButton.visible = true;
				button.visible = true;
				button2.visible = true;
				button3.visible = true;
			}else if (aboutButton.checkMouse(mouseP) && aboutButton.visible) {
				about.visible = true;
				aboutButton.visible = false;
				button.visible = false;
				button2.visible = false;
				button3.visible = false;
			}
			
			return mouseP;
		}
		
	}

}