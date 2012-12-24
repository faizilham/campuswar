package  
{
	/**
	 * ...
	 * @author ...
	 */
	public class Input 
	{
		public var inputs : Array;
		
		public function Input() 
		{
			inputs = new Array();
		}
		
		public function keyPressed(keyCode : int):void {
			inputs[keyCode] = true;
		}
		
		public function keyReleased(keyCode : int):void {
			inputs[keyCode] = false;
		}
		
		public function isPressed(keyCode : int) : Boolean {
			return inputs[keyCode];
		}
	}

}