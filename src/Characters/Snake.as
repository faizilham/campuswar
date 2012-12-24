package Characters 
{
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	
	 import flash.geom.Point;
	 
	public class Snake extends BaseChar
	{
		
		public function Snake(position :Point, playerNo : int, index : int) 
		{
			super(position, 
				Images["snake_up" + playerNo.toString()], 
				Images["snake_left" + playerNo.toString()], 
				Images["snake_down" + playerNo.toString()], 
				Images["snake_right" + playerNo.toString()], 
				Images["snake_avatar" + playerNo.toString()], 
				(playerNo == 1), 
				75, 10, 4, 5, playerNo*10 + index);
				//hp, atk, rng, mov
			charName = "Hayate The Combat Snake";
			charID = 3;
			owner : playerNo;
			skillinfo = "<b>Skill: Heals</b><br/>Heals itself or an ally in range for 25 HP.";
		}
		
	}

}