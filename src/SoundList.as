package  
{
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	public class SoundList 
	{
		
		
		//BGM - load
		public static const BGM_menu : String = "../assets/audio/Tsubasa Chronicle - Endlessly (BGM).mp3";
		public static const BGM_play : String = "../assets/audio/Tsubasa Chronicle - Prove Yourself.mp3";
		public static const BGM_win : String = "../assets/audio/Tsubasa Chronicle - Masquerade.mp3";
		
		//SFX - embed
		
		[Embed(source = "../assets/audio/click.mp3")]  public static const SFX_click : Class;
		[Embed(source = "../assets/audio/slash.mp3")]  public static const SFX_slash : Class;
		[Embed(source = "../assets/audio/zap.mp3")]  public static const SFX_gun : Class;
		[Embed(source = "../assets/audio/shot.mp3")]  public static const SFX_collision : Class;
				
		public function SoundList() 
		{
			
		}
		
	}

}