package GamePhase
{
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	
	 import flash.display.MovieClip;
	 import flash.display.Bitmap;
	 import flash.geom.Point;
	 import flash.geom.Rectangle;
	 import flash.text.TextField;
	 import flash.text.TextFormat;
	 import flash.text.TextFormatAlign;
	 import flash.text.TextFieldAutoSize;
	 import flash.ui.Keyboard;
	 import flash.events.MouseEvent
	 import Components.Button;
	 import Components.Selectibles;
	 
	 
	public class SelectChar extends BaseGame
	{
		private const max_selection : int = 5;
		private var curr_sel : int;
		private var selections : Array;
		private var next : Button;
		private var selected : int, i : int;
		public static var infotext : TextField
		public var title : TextField
		private var selInfo : Array;
		private var player1 : Array, player2: Array;
		private var p1:Point, p2:Point;
		
		
		public function SelectChar(displayContainer:MovieClip) 
		{
			super(displayContainer);
			
			selInfo = new Array();
			selInfo.push(new String("<b>Squidtron</b><br/>HP: 100 Atk: 25 Range: 1 Move: 5<br/>Firewall - Makes one ally in range become invulnerable for 1 turn."));
			selInfo.push(new String("<b>El Robo</b><br/>HP: 115 Atk: 20 Range: 2 Move: 3<br/>Electrocute - Paralyzes an enemy in range."));
			selInfo.push(new String("<b>Moleman</b><br/>HP: 95 Atk: 30 Range: 1 Move: 2<br/>Dig - Dig and move through underground then attack<br/>an enemy on the field. Cannot move for 2 turns"));
			selInfo.push(new String("<b>Hayate The Combat Snake</b><br/>HP: 75 Atk: 10 Range: 4  Move: 5<br/>Heals - Heals itself or an ally in range for 25 HP."));
			selInfo.push(new String("<b>La Chemia</b><br/>HP: 80 Atk: 15 Range: 5 Move: 4<br/>Toxic - Poisons an enemy in range."));
			player1 = new Array();
			player2 = new Array();
			p1 = new Point(100, 120);
			p2 = new Point(640, 120);
		}
		
		override public function loadContent():void {
			super.loadContent();
			
			selected = 0;
			curr_sel = 1;
			
			infotext = new TextField();
			infotext.x = 360;
			infotext.y = 370;
			infotext.defaultTextFormat = new TextFormat("Arial", 14, 0x000000);
			infotext.autoSize = TextFieldAutoSize.CENTER;
			infotext.multiline = true;
			displayContainer.addChild(infotext);
			
			title = new TextField();
			title.x = 360;
			title.y = 130;
			title.defaultTextFormat = new TextFormat("Arial", 20, 0xFFFFFF, true,null,null,null,null,TextFormatAlign.CENTER);
			
			title.autoSize = TextFieldAutoSize.CENTER;
			title.multiline = true;
			title.htmlText= "Player 1, Select Your Heroes!";
			displayContainer.addChild(title);
			
			selections = new Array();
			
			for (i = 0; i < 5; i++) {
				selections.push(new Selectibles(new Point(223 + i*75, 197), Images["sel_"  + (i+1).toString() + "1"], selInfo[i],i));
				displayContainer.addChild(selections[i]);
			}
			
			next = new Button(new Point(360, 300), "(5 more)");
			displayContainer.addChild(next);
			//next.setVisible();
		}
		
		override public function render(elapsedTime:Number):void {
			super.render(elapsedTime);
		}
		
		override public function update(elapsedTime:Number):void {
			super.update(elapsedTime);
		}
		
		override public function mouseClick(mouseEvent : MouseEvent) : Point {
			var mouseP : Point = new Point(mouseEvent.stageX, mouseEvent.stageY);			
			var i : int;
			
			for (i = 0; i < 5; i++) {
				if (selections[i].checkMouse(mouseP)) {
					if (selected < max_selection) {
						selected++;
						if (curr_sel == 1) {
							Main.sel1.push(i);
							player1.push(new Selectibles(p1.clone(), Images["sel_"  +  (i+1).toString() + "1"], "", i));
							displayContainer.addChild(player1[player1.length - 1]);
							p1.y += 75;
						}
						else {
							Main.sel2.push(i);
							player2.push(new Selectibles(p2.clone(), Images["sel_"  +  (i+1).toString() + "2"], "", i));
							displayContainer.addChild(player2[player2.length - 1]);
							p2.y += 75;
						}
					}
				}
			}
			var curr_array : Array, curr_p : Point;
			if (curr_sel == 1) {
				curr_array = player1;
				curr_p = p1;
			}else {
				curr_array = player2;
				curr_p = p2;
			}
			var k :int; var j : int;
			
			for (i = 0; i < curr_array.length; i++) {
				if (curr_array[i].checkMouse(mouseP)) {
					k = curr_array[i].charno;
					displayContainer.removeChild(curr_array[i]);
					curr_array.splice(i, 1);
					selected--;
					curr_p.y = 120;
					
					for (j = 0; j < curr_array.length; j++) {
						curr_array[j].setPos(curr_p);
						curr_p.y += 75;
					}
					
					if (curr_sel == 1) {
						Main.sel1.splice(Main.sel1.indexOf(k), 1);
					}else {
						Main.sel2.splice(Main.sel2.indexOf(k), 1);
					}
				}
			}
			
			
			if (selected < max_selection) {
				next.ButtonText.text = "(" + (max_selection - selected).toString() + " more)";
			}else {
				next.ButtonText.text = "OK";
			}
			
			if (next.checkMouse(mouseP) && next.visible && next.ButtonText.text == "OK") {
				if (curr_sel == 1) {
					curr_sel = 2;
					selected = 0;
					title.htmlText = "Player 2, Select Your Heroes!";
					next.ButtonText.text = "(5 more)";
					var spr : Bitmap;
					for (i = 0; i < selections.length; i++) {
						spr = new Images["sel_"  +  (i + 1).toString() + "2"];
						selections[i].selSprite.bitmapData = spr.bitmapData;
					}
				}else {
					
					Main.nextPhase();
				}
				
			}
				
			return mouseP;
		}
		

	}

}
