package Ammo 
{
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	import flash.geom.Point;
	
	public class testammo extends BaseAmmo
	{
		
		public function testammo(power:Number, owner:int, start: Point, end:Point) 
		{
			super(start, end, Images["test_ammo"], power, owner);
			
		}
		
	}

}