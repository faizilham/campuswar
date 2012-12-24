package Characters 
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	public class BaseChar extends MovieClip
	{
		//stats
		public var HP : Number;
		public var Max_HP : Number;
		public var Attack : Number;
		public var Range : int;
		public var Movement : int;
		public var availableMove : int;
		public var charName : String;
		public var charID : int;
		public var uniqueID: int;
		public var owner : int;
		public var attacking : Boolean;
		public var playerstat : Array;
		public var cooldown : int;
		public var skillinfo : String;
		
		//positions
		public var InTile : int;
		public var area : Rectangle;
		
		//sprites
		protected var spr_up : Bitmap;
		protected var spr_left : Bitmap;
		protected var spr_down : Bitmap;
		protected var spr_right : Bitmap;
		public var spr_avatar : Bitmap;
		protected var curr_spr : Bitmap;
		
		//selections
		protected var sel : Bitmap;
		protected var curr_sel : Bitmap;
		
		//animation vars
		public var target_pos : Array;
		protected var selectable : Boolean;
		public var velocity : Point;
		
		public function BaseChar(position : Point, up :Class, left:Class, down:Class, right:Class, avatar:Class, rightDefault:Boolean, maxHP:Number, atk:Number, rng:int, move:int, uniqueID:int)
		
		{
			var i : int;
			Attack = atk;
			Max_HP = maxHP;
			HP = maxHP;
			Range = rng;
			Movement = move;
			availableMove = move;
			this.uniqueID = uniqueID;
			
			sel = new Images["char_sel"];
			curr_sel = new Bitmap();
			curr_sel.x = position.x;
			curr_sel.y = position.y;
			addChild(curr_sel);
			
			spr_up = new up;
			spr_down = new down;
			spr_left = new left;
			spr_right = new right;
			spr_avatar = new avatar;
			
			if (!rightDefault) {
				curr_spr = new Bitmap(spr_left.bitmapData);
			}else {
				curr_spr = new Bitmap(spr_right.bitmapData);
			}
			
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut,false,0,true);
			
			curr_spr.x = position.x;
			curr_spr.y = position.y;
			area = new Rectangle(curr_spr.x, curr_spr.y, curr_spr.width, curr_spr.height);
			addChild(curr_spr);
			
			target_pos = new Array();
			velocity = new Point();
			selectable = true;
			attacking = false;
			cooldown = 0;
			
			playerstat = new Array();
			
			for (i = 0; i <= 7; i++) {
				playerstat.push(0);
			}
		}
		
		public function getInfoText():String {
			var str : String = new String();
			str = "<b>" + charName + "</b><br/>HP: " +  HP.toString() + "/" + Max_HP.toString() +  "   Atk: " + Attack.toString() +  "   Range: " + Range.toString() +"   Move(s) left: " +  availableMove.toString() + "/" + Movement.toString() + "<br/>";
			
			if (playerstat[1] > 0) str += "PARALYZED! ["+playerstat[1].toString()+"] ";
			if (playerstat[2] > 0) str += "POISONED! ";
			if (playerstat[6] > 0) str += "INVULNERABLE! ["+playerstat[6].toString()+"] ";
			if (playerstat[7] > 0) str += "DIGGING COOLDOWN ["+playerstat[7].toString()+"] ";
			
			return str;
		}
		
		public function getInfoEnemy():String {
			var str : String = new String();
			str = "<b>" + charName + "</b><br/>";
			
			if (playerstat[1] > 0) str += "PARALYZED! ["+playerstat[1].toString()+"] ";
			if (playerstat[2] > 0) str += "POISONED! ";
			if (playerstat[6] > 0) str += "INVULNERABLE! ["+playerstat[6].toString()+"] ";
			if (playerstat[7] > 0) str += "DIGGING COOLDOWN [" + playerstat[7].toString() + "] ";
			
			return str;
		}
		
		public function setHP(value : Number):void {
			if (value > Max_HP) value = Max_HP;
			else if (value < 0) value = 0;
			
			HP = value;
		}
		
		public function changeHP(delta : Number, percentage : Boolean = false):void {
			var x : Number;
			if (percentage) {
				x = delta / 100 * HP;
			}else {
				x = delta;
			}
			
			setHP(HP + x);
		}
		
		public function update(elapsedTime : Number):void {
			if (target_pos.length != 0) {
				var p : Point;
				p = target_pos[0];
				target_pos.splice(0, 1);
				
				if (p.x > 0) {
					curr_spr.bitmapData = spr_right.bitmapData;
				}else if (p.x < 0) {
					curr_spr.bitmapData = spr_left.bitmapData;
				}else if (p.y > 0) {
					curr_spr.bitmapData = spr_down.bitmapData;
				}else if (p.y < 0) {
					curr_spr.bitmapData = spr_up.bitmapData;
				}
				
				area.x += p.x;
				area.y += p.y;
				curr_spr.x += p.x;
				curr_spr.y += p.y;
				curr_sel.x += p.x;
				curr_sel.y += p.y;
				
				selectable = false;
			}else {
				selectable = true;
			}
			
		}
		
		public function setSpr(num : int):void {
			switch(num){
				case 0: curr_spr.bitmapData = spr_up.bitmapData; break;
				case 1: curr_spr.bitmapData = spr_right.bitmapData; break;
				case 2: curr_spr.bitmapData = spr_down.bitmapData; break;
				case 3: curr_spr.bitmapData = spr_left.bitmapData; break;
			}
		}
		
		private function mouseOver(mouseEvent : MouseEvent):void {
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		private function mouseOut(mouseEvent : MouseEvent):void {
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		public function checkMouse(mouse : Point):Boolean {
			//klik di area button
			if (mouse.x > area.x && mouse.x<area.width + area.x && mouse.y > area.y && mouse.y<area.height + area.y) {
				return true;
			}else {
				return false;
			}
		}
		
		public function select():void {
			curr_sel.bitmapData = sel.bitmapData;
		}
		
		public function unselect():void {
			curr_sel.bitmapData = null;
		}
	}

}