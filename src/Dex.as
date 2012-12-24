package  
{
	import Components.Button;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	
	/**
	 * ...
	 * @author Tubuh Hangat
	 */
	public class Dex extends MovieClip
	{
		
		private const InfoNum : int = 6;
		public var infotext : TextField;
		private var avatar : Bitmap;
		public var up : Sprite;
		public var down : Sprite;
		
		public var downHold : Boolean = false;
		public var upHold : Boolean = false;
		
		private var avalist : Array;
		private var infolist : Array;
		
		private var prev : Button;
		private var next : Button;
		private var now : int = 1;
		
		
		public function Dex(screenW : Number, screenH : Number) 
		{
			var i :int;
			prev = new Button(new Point(screenW / 2 - 170, screenH/2 + 220), "<<");
			prev.visible = false;
			next = new Button(new Point(screenW / 2 + 70, screenH/2 + 220), ">>");
			
			addChild(prev);
			addChild(next);
			
			avalist = new Array;
			infolist = new Array;
			
			avalist.push("dummy");
			for (i = 1; i <= InfoNum; i++) {
				avalist.push(new Images["dex" + i.toString()] as Bitmap);
			}
			
			
			infolist.push("dummy");
			for (i = 1; i <= InfoNum; i++) {
				infolist.push((new Texts["text" + i.toString()] as ByteArray).toString());
			}
			
			//textbox dan gambar
			infotext = new TextField();
			infotext.multiline = true;
			infotext.selectable = false;
			infotext.wordWrap = true;
			infotext.mouseWheelEnabled = true;
			infotext.x = 385;
			infotext.y = 145;
			infotext.width = 365;
			infotext.height = 325;
			infotext.defaultTextFormat = new TextFormat("Monotype Corsiva", 16,0x000000,null,null,null,null,null,TextFormatAlign.JUSTIFY);
			infotext.htmlText = infolist[1];
			
			
			avatar = new Bitmap();
			avatar.x = 25;
			avatar.y = 120;
			avatar.bitmapData = avalist[1].bitmapData;
			
			//scroll
			
			//atas
			up = new Sprite();
			var xs : Number = infotext.x;
			var ys: Number = infotext.y - 10;
			var mid:Number = infotext.x + infotext.width / 2;
			
			//kotak
			up.graphics.beginFill(0xFF9966);
			up.graphics.drawRect(xs, ys, infotext.width, 10);
			up.graphics.endFill();
			///segitiga
			up.graphics.beginFill(0x000000);
			up.graphics.drawTriangles(new <Number>[mid,ys+3,mid+2,ys+7,mid-2,ys+7]);
			up.graphics.endFill();
			
			//bawah
			down = new Sprite();
			ys = infotext.y + infotext.height;
			
			//kotak
			down.graphics.beginFill(0xFF9966);
			down.graphics.drawRect(xs, ys, infotext.width, 10);
			down.graphics.endFill();
			///segitiga
			down.graphics.beginFill(0x000000);
			down.graphics.drawTriangles(new <Number>[mid-2,ys+3,mid+2,ys+3,mid,ys+7]);
			down.graphics.endFill();
			
			down.addEventListener(MouseEvent.MOUSE_DOWN, scrollDownHold,false,0,true);
			down.addEventListener(MouseEvent.MOUSE_UP, scrollDownRelease,false,0,true);
			
			up.addEventListener(MouseEvent.MOUSE_DOWN, scrollUpHold,false,0,true);
			up.addEventListener(MouseEvent.MOUSE_UP, scrollUpRelease,false,0,true);
			up.visible = false;
			
			addChild(avatar);
			addChild(infotext);
			addChild(up);
			addChild(down);
			
			addEventListener(MouseEvent.CLICK, mouseClick,false,0,true);
		}
		
		private function scrollDownHold(mouseEvent : MouseEvent):void {
			downHold = true;
			up.visible = true;
		}
		
		private function scrollDownRelease(mouseEvent : MouseEvent):void {
			downHold = false;
		}
		
		private function scrollUpHold(mouseEvent : MouseEvent):void {
			upHold = true;
			down.visible = true;
		}
		
		private function scrollUpRelease(mouseEvent : MouseEvent):void {
			upHold = false;
		}
		
		private function mouseClick(mouseEvent : MouseEvent) : Point {
			var mouseP : Point = new Point(mouseEvent.stageX, mouseEvent.stageY);
			var updated : Boolean = false;
			
			if (!visible) return mouseP;
			
			if (prev.checkMouse(mouseP)&& prev.visible) {
				now--;
				next.visible = true;
				if (now == 1) prev.visible = false;
				
				avatar.bitmapData = avalist[now].bitmapData;
				infotext.htmlText = infolist[now];
				updated = true;
			}
			
			if (next.checkMouse(mouseP) && next.visible) {
				now++;
				prev.visible = true;
				if (now == InfoNum) next.visible = false;
				
				avatar.bitmapData = avalist[now].bitmapData;
				infotext.htmlText = infolist[now];
				updated = true;
			}
			
			if (updated) {
				infotext.scrollV = 1;
				up.visible = false;
				down.visible = infotext.scrollV < infotext.maxScrollV;
			}
			
			return mouseP
			
		}
	}

}