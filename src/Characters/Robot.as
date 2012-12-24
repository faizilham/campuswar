package Characters 
{
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	
	 import flash.geom.Point;
	 
	public class Robot extends BaseChar
	{
		
		public function Robot(position :Point, playerNo : int, index : int) 
		{
			super(position, 
				Images["robot_up" + playerNo.toString()], 
				Images["robot_left" + playerNo.toString()], 
				Images["robot_down" + playerNo.toString()], 
				Images["robot_right" + playerNo.toString()], 
				Images["robot_avatar" + playerNo.toString()], 
				(playerNo == 1),
				115, 20, 2, 3, playerNo*10 + index);
				//hp, atk, rng, mov
			charName = "El Robo";
			charID = 1;
			owner : playerNo;
			skillinfo = "<b>Skill: Electrocute</b><br/>Paralyzes an enemy in range.";
		}
		
	}

}