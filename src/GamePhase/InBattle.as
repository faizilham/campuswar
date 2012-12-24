package GamePhase
{
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	
	 import adobe.utils.ProductManager;
	 import flash.display.MovieClip;
	 import flash.display.Bitmap;
	 import flash.geom.Point;
	 import flash.geom.Rectangle;
	 import flash.sampler.NewObjectSample;
	 import flash.text.TextField;
	 import flash.text.TextFormat;
	 import flash.text.TextFieldAutoSize;
	 import flash.ui.Keyboard;
	 import flash.events.MouseEvent;
	 import Components.Button;
	 import Components.Gauge;
	 import Components.Tile;
	 import Characters.*;
	 import Effects.*;
	 import Ammo.*;
	 
	public class InBattle extends BaseGame
	{
		//const
		private const max_turn : int = 25;
		
		//vars
		private var curr_turn : int;
		private var elapsed_turn:int;
		private var timer_counter : int;
		private var topleft : Point, bottomright : Point;
		
		//stat
		private var statContainer : MovieClip;
		private var button : Button;
		private var button2 : Button;
		private var charStat : TextField;
		private var gauge : Gauge;
		private var avatar : Bitmap;
		private var endbutton : Button;
		private var gameover : Boolean;
		private var skillbutton : Button;
		
		//texts
		private var title : TextField;
		
		//tile
		private var ObjTile : Array;
		private var TileStat : Array;
		
		//char
		private var player1 : Array;
		private var player2 : Array;
		private var curr_char : BaseChar;
		private var moving : Boolean;
		
		//effects & ammo
		private var effect : Array;
		private var ammo : Array;
		private var soundChanged : Boolean = false;
		
		public function InBattle(displayContainer:MovieClip) 
		{
			super(displayContainer);
			moving = false;
			
			curr_turn = 1;
			elapsed_turn = 1;
			effect = new Array();
			ammo = new Array();
			gameover = false;
			timer_counter = 0;
			
			var menubitmap :Bitmap = new Images["bg"];
			canvasBitmap.bitmapData = menubitmap.bitmapData;
		}
		
		override public function loadContent():void {
			super.loadContent();
			var i : int;
			
			//tile loader
			ObjTile = new Array();
			TileStat = new Array();
			
			var xStart : Number = (getScreenWidth() - (8 * 70 + 7 * 5))/2;
			var x : Number = xStart;
			var y : Number = 50;
			
			topleft = new Point(x, y);
			
			for (i = 0; i < 48; i++) {
				if (i > 0 && i % 8 == 0) {
					x = xStart;
					y += 75
				}
				ObjTile.push(new Tile(new Point(x, y)));
				TileStat.push(new Number(0));
				displayContainer.addChild(ObjTile[i]);
				x = x + 75;
			}
			
			bottomright = new Point(x - 30, y + 50);
			
			
			//chara loader
			player1 = new Array();
			
			for (i = 0; i < Main.sel1.length; i++) {
				switch(Main.sel1[i]) {
					case 0:
						player1.push(new Digisquid(ObjTile[i * 8].getPos(), 1,i));
					break;
					case 1:
						player1.push(new Robot(ObjTile[i * 8].getPos(),1,i));
					break;
					case 2:
						player1.push(new Mole(ObjTile[i * 8].getPos(),1,i));
					break;
					case 3:
						player1.push(new Snake(ObjTile[i * 8].getPos(),1,i));
					break;
					case 4:
						player1.push(new Wizard(ObjTile[i * 8].getPos(),1,i));
					break;
				}
				
				player1[i].InTile = i * 8;
				TileStat[i * 8] = 1;
				displayContainer.addChild(player1[i]);
			}
			
			player2 = new Array();
			
			for (i = 0; i < Main.sel2.length; i++) {
				switch(Main.sel2[i]) {
					case 0:
						player2.push(new Digisquid(ObjTile[7 + i * 8].getPos(),2,i));
					break;
					case 1:
						player2.push(new Robot(ObjTile[7 + i * 8].getPos(),2,i));
					break;
					case 2:
						player2.push(new Mole(ObjTile[7 + i * 8].getPos(),2,i));
					break;
					case 3:
						player2.push(new Snake(ObjTile[7 + i * 8].getPos(),2,i));
					break;
					case 4:
						player2.push(new Wizard(ObjTile[7 + i * 8].getPos(),2,i));
					break;
				}
				
				player2[i].InTile = 7 + i * 8;
				TileStat[7 + i * 8] = 2;
				displayContainer.addChild(player2[i]);
			}
			
			curr_char = null;
			
			//stat loader
			statContainer = new MovieClip();
			gauge = new Gauge(new Rectangle(80, 0, 250, 15));
			
			avatar = new Bitmap();
			avatar.x = 0; avatar.y = 0;
			
			charStat = new TextField();
			charStat.defaultTextFormat = new TextFormat("Calibri", 14, 0xFFFFFF);
			charStat.x = 80;
			charStat.y = 20;
			charStat.multiline = true;
			charStat.htmlText = "<b>Test</b><br/>name";
			charStat.autoSize = TextFieldAutoSize.LEFT;
			charStat.selectable = false;
			
			statContainer.addChild(gauge);
			statContainer.addChild(avatar);
			statContainer.addChild(charStat);
			
			statContainer.x = xStart;
			statContainer.y = 510;
			
			displayContainer.addChild(statContainer);
			
			endbutton = new Button(new Point(600, 510), "End Turn");
			skillbutton = new Button(new Point(490, 510), "Specials");
			displayContainer.addChild(endbutton);
			displayContainer.addChild(skillbutton);
			hideStatus();
			
			//text loader
			
			title = new TextField();
			title.defaultTextFormat = new TextFormat("Calibri", 20, 0xFFFFFF);
			title.autoSize = TextFieldAutoSize.CENTER;
			title.text = "Turn #1: Player 1";
			
			title.selectable = false;
			
			title.x = (getScreenWidth() - title.width) / 2;
			title.y = 10;
			
			displayContainer.addChild(title);		
		}
		
		override public function render(elapsedTime:Number):void {
			super.render(elapsedTime);

			//canvasBD.copyPixels(BG.bitmapData, new Rectangle(0, 0, BG.width, BG.height), new Point( -350, -50));
			/*BG.render(canvasBD);
			player.playerSprite.render(canvasBD);
			enemy.enemySprite.render(canvasBD);*/
		}
		
		override public function update(elapsedTime:Number):void {
			var i : int;
			super.update(elapsedTime);
			//if (curr_char != null) curr_char.update(elapsedTime);
			
			for (i = 0; i < player1.length; i++) {
				player1[i].update(elapsedTime);
			}
			
			
			for (i = 0; i < player2.length; i++) {
				player2[i].update(elapsedTime);
			}
			
			
			for (i = 0; i < ammo.length; i++) {
				if (ammo[i].area.x < topleft.x || ammo[i].area.x > bottomright.x || ammo[i].area.y < topleft.y || ammo[i].area.y > bottomright.y) {
					displayContainer.removeChild(ammo[i]);
					ammo.splice(i, 1);
				}else {
					ammo[i].Animate(elapsedTime);
				}
				
			}
			
			//collision check
			
			var curr_array : Array; 
			var j : int; var curr_ammo : BaseAmmo;
			
			curr_array = player1;
			for (i = 0; i < curr_array.length; i++) {
				for (j = 0; j < ammo.length; j++) {
					if (curr_array[i].hitTestObject(ammo[j]) && curr_array[i].uniqueID!=ammo[j].owner) {
						if(curr_array[i].playerstat[6]==0){
							curr_array[i].changeHP( -ammo[j].power); 
							
							Main.sfx = new SoundHandler("",SoundList.SFX_collision);
							Main.sfx.play();
							
							//effect.push(new Explosion(new Point(curr_array[i].area.x, curr_array[i].area.y)));
							//displayContainer.addChild(effect[effect.length - 1]);
							if (curr_array[i].HP>0){
								effect.push(new FlyText( (-ammo[j].power).toString(), true,new Point(curr_array[i].area.x, curr_array[i].area.y), 20));
								displayContainer.addChild(effect[effect.length - 1]);
							}
						}else {
							effect.push(new FlyText( "no effect!", true,new Point(curr_array[i].area.x, curr_array[i].area.y), 20));
							displayContainer.addChild(effect[effect.length - 1]);
						}
						displayContainer.removeChild(ammo[j]);
						ammo.splice(j, 1);
					}
				}
			}
				
			curr_array = player2;
			for (i = 0; i < curr_array.length; i++) {
				for (j = 0; j < ammo.length; j++) {
					if (curr_array[i].hitTestObject(ammo[j]) && curr_array[i].uniqueID!=ammo[j].owner) {
						if(curr_array[i].playerstat[6]==0){
							curr_array[i].changeHP( -ammo[j].power); 
							
							
							Main.sfx = new SoundHandler("",SoundList.SFX_collision);
							Main.sfx.play();
							
							//effect.push(new Explosion(new Point(curr_array[i].area.x, curr_array[i].area.y)));
							//displayContainer.addChild(effect[effect.length - 1]);
							if (curr_array[i].HP>0){
								effect.push(new FlyText( (-ammo[j].power).toString(), true,new Point(curr_array[i].area.x, curr_array[i].area.y), 20));
								displayContainer.addChild(effect[effect.length - 1]);
							}
						}else {
							effect.push(new FlyText( "no effect!", true,new Point(curr_array[i].area.x, curr_array[i].area.y), 20));
							displayContainer.addChild(effect[effect.length - 1]);
						}
						displayContainer.removeChild(ammo[j]);
						ammo.splice(j, 1);
					}
				}
			}
			
			
			//winning check
				if (player1.length == 0) {
					title.text = "Player 2 Wins! Press Next to Continue...";
					endbutton.ButtonText.text = "Next";
					gameover = true;
				}else if (player2.length == 0) {
					title.text = "Player 1 Wins! Press Next to Continue...";
					endbutton.ButtonText.text = "Next";
					gameover = true;
				}else{
					if (elapsed_turn > max_turn) {
						var hp1 : Number = 0;
						var hp2 : Number = 0;
						for (i = 0; i < player1.length; i++) {
							hp1 += player1[i].HP / player1[i].Max_HP;
						}
						for (i = 0; i < player2.length; i++) {
							hp2 += player2[i].HP / player2[i].Max_HP;
						}
						
						if (hp1 > hp2) {
							title.text = "Player 1 Wins! Press Next to Continue...";
						}else if (hp1 < hp2) {
							title.text = "Player 2 Wins! Press Next to Continue...";
						}else {
							title.text = "Draw! Press Next to Continue...";
						}
						endbutton.ButtonText.text = "Next";
						gameover = true;
					}
				}
				
				if (gameover && !soundChanged) {
					
					Main.bgm.stop();
					Main.bgm = null;
					Main.bgm = new SoundHandler(SoundList.BGM_win, null, -1);
					Main.bgm.setVolume(0.7);
					
					Main.bgm.play();
					soundChanged = true;
				}
			
			//removal
				
			for (i = 0; i < player1.length; i++) {
				if (player1[i].HP == 0) {
					TileStat[player1[i].InTile] = 0;
					displayContainer.removeChild(player1[i]);
					
					effect.push(new Explosion(new Point(player1[i].area.x, player1[i].area.y)));
					displayContainer.addChild(effect[effect.length - 1]);
					player1.splice(i, 1);
				}
			}
			
			for (i = 0; i < player2.length; i++) {
				if (player2[i].HP == 0) {
					TileStat[player2[i].InTile] = 0;
					displayContainer.removeChild(player2[i]);
					
					effect.push(new Explosion(new Point(player2[i].area.x, player2[i].area.y)));
					displayContainer.addChild(effect[effect.length - 1]);
					player2.splice(i, 1);
				}
			}
			
			for (i = 0; i < effect.length; i++) {
				
				if (effect[i].finish) {
					
					if (effect[i].id==1 && effect[i].pow!=0){
						effect.push(new FlyText( effect[i].pow.toString(), true, effect[i].position.clone(), 20));
						displayContainer.addChild(effect[effect.length - 1]);
					}else if (effect[i].id == 2) {
						effect.push(new FlyText( "mati!", true, effect[i].position.clone(), 20));
						displayContainer.addChild(effect[effect.length - 1]);
					}
					displayContainer.removeChild(effect[i]);
					effect.splice(i, 1);
					
					
					
				}else {
					effect[i].Animate(elapsedTime);
				}
			}
			
		}
		
		override public function mouseClick(mouseEvent : MouseEvent) : Point {
			var mouseP : Point = new Point(mouseEvent.stageX, mouseEvent.stageY);
						
			var i:int; var curr_array : Array; var j : int;
						
			if (endbutton.checkMouse(mouseP)) {
				if (gameover) {
					Main.nextPhase();
				}else {
					curr_turn = (curr_turn % 2) + 1;
					elapsed_turn += (curr_turn % 2);
					
					if (curr_char != null) {
						curr_char.unselect();
						deactivateTile();
						hideStatus();
					}
					
					if (elapsed_turn<=max_turn){
						title.text = "Turn #" + elapsed_turn.toString() + ": Player " + curr_turn.toString();
						Tlabel.text = "";
						if (curr_turn == 1) {
							//update stat
							for (i = 0; i < player2.length;i++){
								for (j = 1; j <= 7; j++) {
									if (j!=2 && j!=6 && player2[i].playerstat[j] > 0) player2[i].playerstat[j]--;
								}
							}
							
							for (i = 0; i < player1.length; i++) {
								player1[i].availableMove = player1[i].Movement;
								player1[i].attacking = false;
								
								if (player1[i].playerstat[6] > 0) player1[i].playerstat[6]--;
								
								//paralyzed
								if (player1[i].playerstat[1] > 0) {
									player1[i].availableMove = 0;
									player1[i].attacking = true;
								}
								
								//poisoned
								if (player1[i].playerstat[2] > 0) {
									if (player1[i].playerstat[6] == 0){
										player1[i].changeHP(-5); 
										if (player1[i].HP>0){
											effect.push(new FlyText( "-5", true,new Point(player1[i].area.x, player1[i].area.y), 20));
											displayContainer.addChild(effect[effect.length - 1]);
										}
									}else {
										effect.push(new FlyText( "no effect!", false,new Point(player1[i].area.x, player1[i].area.y), 20));
										displayContainer.addChild(effect[effect.length - 1]);
									}
								}
								
								//digging
								if (player1[i].playerstat[7] > 0) {
									player1[i].availableMove = 0;
									player1[i].attacking = true;
								}
								
								if (player1[i].cooldown > 0) player1[i].cooldown--;
								
							}
						}else {
							
							//update stat
							for (i = 0; i < player1.length;i++){
								for (j = 1; j <= 7; j++) {
									if (j!=2 && j!=6 && player1[i].playerstat[j] > 0) player1[i].playerstat[j]--;
								}
							}
							
							for (i = 0; i < player2.length; i++) {
								player2[i].availableMove = player2[i].Movement;
								player2[i].attacking = false;
								
								if (player2[i].playerstat[6] > 0) player2[i].playerstat[6]--;
								
								//paralyzed
								if (player2[i].playerstat[1] > 0) {
									player2[i].availableMove = 0;
									player2[i].attacking = true;
								}
								
								//poisoned
								if (player2[i].playerstat[2] > 0) {
									if (player2[i].playerstat[6] == 0){
										player2[i].changeHP(-5); 
										if (player2[i].HP>0){
											effect.push(new FlyText( "-5", true,new Point(player2[i].area.x, player2[i].area.y), 20));
											displayContainer.addChild(effect[effect.length - 1]);
										}
									}else {
										effect.push(new FlyText( "no effect!", false,new Point(player2[i].area.x, player2[i].area.y), 20));
										displayContainer.addChild(effect[effect.length - 1]);
									}
								}
								
								//digging
								if (player2[i].playerstat[7] > 0) {
									player2[i].availableMove = 0;
									player2[i].attacking = true;
								}
								
								if (player2[i].cooldown > 0) player2[i].cooldown--;
							}
						}
					}
				}
			}
			
			if (gameover) return mouseP;
			
			
			//activated tile click
			if(moving){
				for (i = 0; i < 48; i++) {
					if (ObjTile[i].checkMouse(mouseP) && ObjTile[i].stat==1 && i != curr_char.InTile) {
						 var k: int; var d1 : int; var d2 : int;
			
						var path : Array = findPath(curr_char.InTile, i, curr_char.availableMove);
						
						d1 = path.pop();
						curr_char.availableMove -= path.length;
						while (path.length > 0) {
							
							d2 = path.pop()

							k = int(ObjTile[d2].area.x - ObjTile[d1].area.x);
							for (j = 0;  j < int(Math.abs(k)); j += 5) {
								if (k > 0) {
									curr_char.target_pos.push(new Point(5, 0));
								}else {
									curr_char.target_pos.push(new Point(-5, 0));
								}
							}
							
							k = int(ObjTile[d2].area.y - ObjTile[d1].area.y);
							for (j = 0;  j < int(Math.abs(k)); j += 5) {
								if (k > 0) {
									curr_char.target_pos.push(new Point(0, 5));
								}else {
									curr_char.target_pos.push(new Point(0, -5));
								}
							}
							
							d1 = d2;
						}
						TileStat[i] = TileStat[curr_char.InTile];
						TileStat[curr_char.InTile]=0;
						curr_char.InTile = i;
						
						moving = false;
						curr_char.unselect();
						deactivateTile();
						hideStatus();
						
						break;
					}else if (ObjTile[i].checkMouse(mouseP) && ObjTile[i].stat == 2) {
						
						
						
						if (TileStat[i] == 1) {
							curr_array = player1;
						}else {
							curr_array = player2;
						}
						
						j = -1; 
						
						do {
							j++;							
						}while (j < (curr_array.length - 1) && curr_array[j].InTile!=i);
						var dx : Number = curr_array[j].area.x - curr_char.area.x;
						var dy : Number = curr_array[j].area.y - curr_char.area.y;
						
						if (Math.abs(dy) > Math.abs(dx)) {
							if (dy > 0) curr_char.setSpr(2);
							else curr_char.setSpr(0);
						}else {
							if (dx > 0) curr_char.setSpr(1);
							else curr_char.setSpr(3);
						}
							
						if (curr_char.Range > 1) {		
							Main.sfx = new SoundHandler("", SoundList.SFX_gun);
							Main.sfx.play();
							ammo.push(new testammo(curr_char.Attack,curr_char.uniqueID, new Point(curr_char.area.x+30, curr_char.area.y+30), new Point(curr_array[j].area.x + 30, curr_array[j].area.y + 30)));
							displayContainer.addChild(ammo[ammo.length - 1]);
						}else{				
							if (curr_array[j].playerstat[6]==0){
								curr_array[j].changeHP( -curr_char.Attack);
								effect.push(new Slash(new Point(curr_array[j].area.x, curr_array[j].area.y)));
								displayContainer.addChild(effect[effect.length - 1]);
								
								if (curr_array[j].HP > 0) {
									effect[effect.length - 1].pow = -curr_char.Attack;
									
								}else {
									effect[effect.length - 1].pow = 0;
								}
							}else {
								effect.push(new FlyText( "no effect!", false,new Point(curr_array[j].area.x, curr_array[j].area.y), 20));
								displayContainer.addChild(effect[effect.length - 1]);
							}
						}
						
						curr_char.availableMove = 0;
						curr_char.attacking = true;
						break;
					}else if (ObjTile[i].checkMouse(mouseP) && ObjTile[i].stat == 3) {
						specialSkill(i);
					}
				}
			}
			
			if (skillbutton.visible && skillbutton.checkMouse(mouseP)) {
				if (!curr_char.attacking && skillbutton.ButtonText.text == "Specials") {
					demarkTile();
					deactivateTile();
					floodSpecial(curr_char.InTile, curr_char.Range);
					skillbutton.ButtonText.text = "Attack";
					charStat.htmlText = curr_char.skillinfo;
				}else if (skillbutton.ButtonText.text == "Attack") {
					demarkTile();
					deactivateTile();
					floodPath(curr_char.InTile, curr_char.availableMove);
					if (!curr_char.attacking) floodRange(curr_char.InTile, curr_char.Range);
					skillbutton.ButtonText.text = "Specials";
					charStat.htmlText = curr_char.getInfoText();
				}
				skillbutton.ButtonText.setTextFormat(skillbutton.formatHover);
			}else{
				//enemy stat
				
				var sel_enemy : Boolean = false;
				
				if(!moving){
					if (curr_turn == 2) {
						curr_array = player1;
					}else {
						curr_array = player2;
					}
					
					for (i = 0; i < curr_array.length; i++) {
						if (curr_array[i].checkMouse(mouseP) && curr_array[i].visible) {
							moving = !moving;
							if (moving)	{
								curr_char = curr_array[i];
								curr_char.select();
								showEnemyStatus();
								sel_enemy = true;
							}else {
								curr_char.unselect();
								deactivateTile();
								hideStatus();
								sel_enemy = false;
							}
							break;
						}else {
							if(moving){
								moving = false;
								curr_char.unselect();
								deactivateTile();
								hideStatus();
								sel_enemy = false;
							}
						}
					}
				}
				
				
				//current player - move & attack
				
				if (curr_turn == 1) {
					curr_array = player1;
				}else {
					curr_array = player2;
				}
				
				for (i = 0; i < curr_array.length; i++) {
					if (curr_array[i].checkMouse(mouseP) && curr_array[i].visible) {
						moving = true;
						//if (moving)	{
							if (curr_char != null) curr_char.unselect();
							curr_char = curr_array[i];
							curr_char.select();
							demarkTile();
							deactivateTile();
							floodPath(curr_char.InTile, curr_char.availableMove);
							if (!curr_char.attacking) floodRange(curr_char.InTile, curr_char.Range);
							showStatus();
						/*}else {
							curr_char.unselect();
							deactivateTile();
							hideStatus();
						}*/
						break;
					}else {
						if(moving && !sel_enemy){
							moving = false;
							curr_char.unselect();
							deactivateTile();
							hideStatus();
						}
					}
				}
			}
			return mouseP;
		}
		
		private function specialSkill(tileid : int):void {
			var k : int = curr_char.charID;
			var curr_array : Array;
			var target : BaseChar;
			
			if (TileStat[tileid] == 1) {
				curr_array = player1;
			}else {
				curr_array = player2;
			}
			
			var j : int = -1; 
			
			do {
				j++;							
			}while (j < (curr_array.length - 1) && curr_array[j].InTile!=tileid);
			var dx : Number = curr_array[j].area.x - curr_char.area.x;
			var dy : Number = curr_array[j].area.y - curr_char.area.y;
			target = curr_array[j];
			
			/*if (Math.abs(dy) > Math.abs(dx)) {
				if (dy > 0) curr_char.setSpr(2);
				else curr_char.setSpr(0);
			}else {
				if (dx > 0) curr_char.setSpr(1);
				else curr_char.setSpr(3);
			}*/
			
			if (target.playerstat[6] > 0 && k!=3) {
				effect.push(new FlyText("no effect!", true,new Point(target.area.x, target.area.y), 20));
				displayContainer.addChild(effect[effect.length - 1]);
			}else{
				switch(k) {
					case 0:
						target.playerstat[6] = 1;
						effect.push(new FlyText("invulnerable!", false,new Point(target.area.x, target.area.y), 20));
						displayContainer.addChild(effect[effect.length - 1]);
					break;
					case 1:
						target.playerstat[1] = 2;
						effect.push(new FlyText("paralyzed!", true,new Point(target.area.x, target.area.y), 20));
						displayContainer.addChild(effect[effect.length - 1]);
					break;
					case 2:
						curr_char.playerstat[7] = 2;
						
						target.changeHP( -curr_char.Attack);
						effect.push(new Slash(new Point(target.area.x, target.area.y)));
						displayContainer.addChild(effect[effect.length - 1]);
						/*if (target.HP > 0) {
							effect.push(new FlyText(( -curr_char.Attack).toString(), true, new Point(target.area.x, target.area.y), 20));
							displayContainer.addChild(effect[effect.length - 1]);
						}*/
						
						if (target.HP > 0) {
							effect[effect.length - 1].pow = -curr_char.Attack;
						}else {
							effect[effect.length - 1].pow = 0;
						}
						
					break;
					case 3:
						target.changeHP(25)
						if (target.HP == target.Max_HP) {
							effect.push(new FlyText("full health!", false,new Point(target.area.x, target.area.y), 20));
						}else {
							effect.push(new FlyText("+25", false,new Point(target.area.x, target.area.y), 20));
						}
						displayContainer.addChild(effect[effect.length - 1]);
					break;
					case 4:
						target.playerstat[2] = 1; //permanent until cured
						effect.push(new FlyText("poisoned!", true,new Point(target.area.x, target.area.y), 20));
						displayContainer.addChild(effect[effect.length - 1]);
					break;
				}
			}
			curr_char.availableMove = 0;
			curr_char.attacking = true;
			curr_char.cooldown = 3;
		}
		
		private function showStatus():void {
			gauge.drawGauge(curr_char.HP, curr_char.Max_HP);
			charStat.htmlText = curr_char.getInfoText();
			avatar.bitmapData = curr_char.spr_avatar.bitmapData;
			skillbutton.ButtonText.text = "Specials";
			statContainer.visible = true;
			skillbutton.visible = curr_char.cooldown == 0;
		}
		
		private function showEnemyStatus():void {
			gauge.drawGauge(curr_char.HP, curr_char.Max_HP);
			charStat.htmlText = curr_char.getInfoEnemy();
			avatar.bitmapData = curr_char.spr_avatar.bitmapData;
			statContainer.visible = true;
		}
		
		private function hideStatus():void {
			statContainer.visible = false;
			skillbutton.visible = false;
		}
		
		private function toIndex(x: int, y: int) : int {
			return (8 * y + x);
		}
		
		private function toCoordinate(i : int) : Point {
			var x : int = i % 8;
			var y : int = (i - x) / 8;
			
			return new Point(x, y);
		}
		
		private function validPos(x : int, y :int):Boolean {
			return (0<=x) && (x<8) && (0<=y) && (y<6);
		}
		
		private function floodPath(n : int, step : int):void {
			var process : Array = new Array();
			var dx : Array  = new Array( 0, 1, 0, -1 );
			var dy : Array =  new Array(-1, 0, 1, 0);
			var p : Point; var c : Point; var i :int; var k :int;
			
			ObjTile[n].setStat(1);
			process.push(new Point(n, step));
					
			while (process.length > 0) {

				c = process[0];
				process.splice(0, 1);
				if (c.y > 0) {
					p = toCoordinate(c.x);
					for (i = 0; i < 4; i++) {
						if (validPos(p.x + dx[i], p.y + dy[i])) {
							k = toIndex(p.x + dx[i], p.y + dy[i]);
							if (ObjTile[k].mark == 0 && TileStat[k] == 0) {
								ObjTile[k].mark == 1;
								ObjTile[k].setStat(1);
								process.push(new Point(k, c.y-1));
							}
						}
					}
				}
			}
			
			demarkTile();
		}
		
		private function floodRange(n : int, step : int):void {
			var process : Array = new Array();
			var dx : Array  = new Array( 0, 1, 0, -1 );
			var dy : Array =  new Array(-1, 0, 1, 0);
			var p : Point; var c : Point; var i :int; var k :int;
			
			ObjTile[n].setStat(1);
			process.push(new Point(n, step));
			
			while (process.length > 0) {

				c = process[0];
				process.splice(0, 1);
				if (c.y > 0) {
					p = toCoordinate(c.x);
					for (i = 0; i < 4; i++) {
						if (validPos(p.x + dx[i], p.y + dy[i])) {
							k = toIndex(p.x + dx[i], p.y + dy[i]);
							if (ObjTile[k].mark == 0) {
								ObjTile[k].mark == 1;
								if (ObjTile[k].stat == 0 && TileStat[k] > 0 && TileStat[k] != TileStat[n]) ObjTile[k].setStat(2);
								process.push(new Point(k, c.y-1));
							}
						}
					}
				}
			}
			
			demarkTile();
			
		}
		
		private function floodSpecial(n : int, step : int):void {
			var id : int = curr_char.charID;
			var i :int;
			 
			if(id!=2){
				var process : Array = new Array();
				var dx : Array  = new Array( 0, 1, 0, -1 );
				var dy : Array =  new Array(-1, 0, 1, 0);
				var p : Point; var c : Point; var k :int; 
				
				
				if (id == 3 || id == 0) {
					ObjTile[n].setStat(3);
				}
				process.push(new Point(n, step));
				
				while (process.length > 0) {

					c = process[0];
					process.splice(0, 1);
					if (c.y > 0) {
						p = toCoordinate(c.x);
						for (i = 0; i < 4; i++) {
							if (validPos(p.x + dx[i], p.y + dy[i])) {
								k = toIndex(p.x + dx[i], p.y + dy[i]);
								if (ObjTile[k].mark == 0) {
									ObjTile[k].mark == 1;
									if (id == 0 || id == 3){
										if (ObjTile[k].stat == 0 && TileStat[k] > 0 && TileStat[k] == TileStat[n]) ObjTile[k].setStat(3);
									}else{
										if (ObjTile[k].stat == 0 && TileStat[k] > 0 && TileStat[k] != TileStat[n]) ObjTile[k].setStat(3);
									}
									process.push(new Point(k, c.y-1));
								}
							}
						}
					}
				}
				demarkTile();
			}else { //khusus mole
				for (i = 0; i < 48; i++) {
					if (TileStat[i] != TileStat[n] && TileStat[i] > 0) ObjTile[i].setStat(3);
				}
			}
			
		}
		
		private function findPath(start:int, dest: int, step:int) : Array {	
			var path : Array;
			if (start == dest) {
				path = new Array();
				path.push(dest);
				return path;				
			}else {
				if (step == 0) {
					return null;
					
				}else {
					var dx : Array  = new Array( 0, 1, 0, -1 );
					var dy : Array =  new Array( -1, 0, 1, 0);
					var ret : Array;
					
					var p : Point; var i :int; var k :int;
					p = toCoordinate(start);
					
					ObjTile[start].mark = 1;
					for (i = 0; i < 4; i++) {
						if (validPos(p.x + dx[i], p.y + dy[i])) {
							k = toIndex(p.x + dx[i], p.y + dy[i]);
							if (ObjTile[k].mark == 0 && TileStat[k] == 0) {
								ret = findPath(k, dest, step - 1);
								if (ret != null) {
									if (path == null) path = ret;
									else if (path.length > ret.length) path = ret;
								}
							}
						}
					}
					
					ObjTile[start].mark = 0;
					
					if (path != null) {
						path.push(start);
						return path;
					}else {
						return null;
					}
				}
			}
		}
		
		private function deactivateTile():void {
			var i:int;
			for (i = 0; i < 48; i++) {
				ObjTile[i].setStat(0);
			}
		}
		
		private function demarkTile():void {
			var i:int;
			for (i = 0; i < 48; i++) {
				ObjTile[i].mark = 0;
			}
		}
	
		
	}

}