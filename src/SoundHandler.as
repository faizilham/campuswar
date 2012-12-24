package  
{
	import flash.media.Sound;
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	 
	public class SoundHandler
	{
		
		private var soundObj : Sound;
		private var control : SoundChannel;
		public var playing : Boolean;
		private var loop : int;
		private var adjust : SoundTransform;
		
		public function SoundHandler(soundFile : String, embedSound: Class = null, loop : int = 0) 
		{
			if (soundFile != "") {
				var soundReq:URLRequest = new URLRequest(soundFile);
				soundObj = new Sound(soundReq);
			}else {
				soundObj = new embedSound;
			}
			control = new SoundChannel();
			adjust = new SoundTransform();
			if (loop < 0) {
				this.loop = int.MAX_VALUE;
			}else {
				this.loop = loop;
			}
			playing = false;
			setVolume(1);
		}
		
		public function play():void {
			playing = true;
			control = soundObj.play(0, this.loop)
			control.soundTransform = adjust;
		}
		
		public function stop():void {
			if (playing) {
				control.stop();
				playing = false;
			}
		}	
		
		public function setVolume(vol : Number) : void {
			if (vol >= 0 && vol <= 1) {
				adjust.volume = vol;
				control.soundTransform = adjust;
			}
		}
		
	}

}