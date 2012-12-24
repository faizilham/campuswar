package  
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class GameLoop 
	{
		// FPS yang diinginkan
		public static const FRAME_RATE : int = 60;
		
		private var _period : Number = 1000 / FRAME_RATE; // waktu untuk 1 siklus
		private var _beforeTime : int = 0; // waktu sebelum siklus
		private var _afterTime : int = 0; // waktu setelah siklus
		private var _timeDiff : int = 0; // waktu untuk satu siklus
		private var _sleepTime : int = 0; // waktu yang disediakan untuk tidur
		
		private var lastUpdateTime : Number; // waktu terakhir update
		private var lastRenderTime : Number; // waktu terakhir render
		
		private var gameTimer : Timer;
		private var game : BaseGame;
		
		// KONSTRUKTOR
		public function GameLoop(game:BaseGame) {
			gameTimer = new Timer(_period);
			this.game = game;
			gameTimer.addEventListener(TimerEvent.TIMER, runGame,false,0,true);
		}
		
		// START DAN STOP
		public function start():void {
			gameTimer.start();
			lastUpdateTime = getTimer();
			lastRenderTime = getTimer();
		}
		public function stop():void {
			gameTimer.stop();
			gameTimer.removeEventListener(TimerEvent.TIMER, runGame);
		}
		
		// RUNGAME
		private function runGame(e:TimerEvent):void {
			
			// proses update dan render
			_beforeTime = getTimer(); // hitung waktu
			game.update((_beforeTime - lastUpdateTime) / 1000.0);
			game.render((_beforeTime - lastRenderTime) / 1000.0);
			e.updateAfterEvent(); // update semuanya
			_afterTime = getTimer(); // hitung waktu
			
			lastUpdateTime = _afterTime;
			lastRenderTime = _afterTime;
			_timeDiff = _afterTime - _beforeTime;
			_sleepTime = _period - _timeDiff;
			
			// ada waktu untuk tidur?
			if (_sleepTime >= 0) {
				gameTimer.delay = _sleepTime;
			}
			else {
				gameTimer.delay = 1;
			}
			
			// ternyata keberatan
			while (_sleepTime < 0) {
				game.update((getTimer() - lastUpdateTime) / 1000.0);
				lastUpdateTime = getTimer();
				_sleepTime += _period;
			}
			
			gameTimer.start();
		}
	}

}