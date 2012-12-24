package Characters 
{
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	
	 import flash.geom.Point;
	 
	public class Digisquid extends BaseChar
	{
		
		public function Digisquid(position :Point, playerNo : int,index : int) 
		{
			super(position, 
				Images["squid_up" + playerNo.toString()], 
				Images["squid_left" + playerNo.toString()], 
				Images["squid_down" + playerNo.toString()], 
				Images["squid_right" + playerNo.toString()], 
				Images["squid_avatar" + playerNo.toString()], 
				(playerNo == 1), 
				100, 25, 1, 5, playerNo*10 + index);
				//hp, atk, rng, mov
			charName = "Squidtron";
			charID = 0;
			owner : playerNo;
			skillinfo = "<b>Skill: Firewall</b><br/>Makes one ally in range become<br/>invulnerable for 1 turn.";
		}
		
	}

}