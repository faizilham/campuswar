package 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import GamePhase.*;
	
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
		
	public class Main extends MovieClip
	{
		private static var phaseChange : Boolean;
		private var phase : int;
		private var game : BaseGame;
		public static var tlbl : TextField;
		public static var sel1 : Array;
		public static var sel2 : Array;
		public static var bgm : SoundHandler;
		public static var sfx : SoundHandler;	
		
		public function Main():void 
		{
			tlbl = new TextField();
			tlbl.x = -30;
			addChild(tlbl);
			bgm = new SoundHandler(SoundList.BGM_menu, null, -1);
			bgm.play();
			
			game = new Menu(this);
			phase = 0;
			
			game.Initialize();
			
			game.loadContent();
			
			
			phaseChange = false;
			
				
			var updater : Timer = new Timer(100);
			updater.addEventListener(TimerEvent.TIMER, loadPhase,false,0,true);
			updater.start();
		}
		
		public static function nextPhase():void {
			phaseChange = true;
		}
		
		private function loadPhase(e:TimerEvent):void {
			if (phaseChange) {
				
				phaseChange = false;
				
				while (game.displayContainer.numChildren > 0) {
					game.displayContainer.removeChildAt(0);
				}
				game.dispose()
				game =  null;
				phase += 1;
				if (phase == 3) phase = 0;
				
				switch (phase) {
					case 0:
						bgm.stop();
						bgm = null;
						bgm = new SoundHandler(SoundList.BGM_menu, null, -1);
						bgm.setVolume(1);
						bgm.play();
						game = new Menu(this);
						game.Initialize();
						game.loadContent();
					break;
					case 1:
						sel1 = null;
						sel1 = new Array();
						sel2 = null;
						sel2 = new Array();
						game = new SelectChar(this);
						game.Initialize();
						game.loadContent();	
					
					break;
					case 2:
						bgm.stop();
						bgm = null;
						bgm = new SoundHandler(SoundList.BGM_play, null, -1);
						bgm.setVolume(0.7);
						bgm.play();
						game = new InBattle(this);
						game.Initialize();
						game.loadContent();	
					break;
				}
			}
		}
		
	}
	
}