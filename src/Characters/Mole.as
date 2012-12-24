package Characters 
{
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	
	 import flash.geom.Point;
	 
	public class Mole extends BaseChar
	{
		
		public function Mole(position :Point, playerNo : int, index:int) 
		{
			super(position, 
				Images["mole_up" + playerNo.toString()], 
				Images["mole_left" + playerNo.toString()], 
				Images["mole_down" + playerNo.toString()], 
				Images["mole_right" + playerNo.toString()], 
				Images["mole_avatar" + playerNo.toString()], 
				(playerNo == 1), 
				95, 30, 1, 2, playerNo*10 + index);
				//hp, atk, rng, mov
			charName = "Moleman";
			charID = 2;
			owner : playerNo;
			skillinfo = "<b>Skill: Dig</b><br/>Dig and move through underground then attack<br/>an enemy on the field. Cannot move for 2 turns";
		}
		
	}

}