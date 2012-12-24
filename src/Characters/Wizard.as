package Characters 
{
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	
	 import flash.geom.Point;
	 
	public class Wizard extends BaseChar
	{
		
		public function Wizard(position :Point, playerNo : int, index:int) 
		{
			super(position, 
				Images["wizard_up" + playerNo.toString()], 
				Images["wizard_left" + playerNo.toString()], 
				Images["wizard_down" + playerNo.toString()], 
				Images["wizard_right" + playerNo.toString()], 
				Images["wizard_avatar" + playerNo.toString()], 
				(playerNo == 1), 
				80, 15, 5, 4, playerNo*10 + index);
				//hp, atk, rng, mov
			charName = "La Chemia";
			charID = 4;
			owner : playerNo;
			skillinfo = "<b>Skill: Toxic</b><br/>Poisons an enemy in range.";
		}
		
	}

}