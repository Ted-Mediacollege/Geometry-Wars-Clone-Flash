package nl.teddevos.geometrywars.input 
{
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class KeyInput 
	{
		public static var W:Boolean;
		public static var A:Boolean;
		public static var S:Boolean;
		public static var D:Boolean;
		public static var SPACE:Boolean;
		public static var UP:Boolean;
		public static var DOWN:Boolean;
		public static var LEFT:Boolean;
		public static var RIGHT:Boolean;
		
		public static function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.W) { W = true; }
			if (e.keyCode == Keyboard.A) { A = true; }
			if (e.keyCode == Keyboard.S) { S = true; }
			if (e.keyCode == Keyboard.D) { D = true; }
			if (e.keyCode == Keyboard.SPACE) { SPACE = true; }
			if (e.keyCode == Keyboard.UP) { UP = true; }
			if (e.keyCode == Keyboard.DOWN) { DOWN = true; }
			if (e.keyCode == Keyboard.LEFT) { LEFT = true; }
			if (e.keyCode == Keyboard.RIGHT) { RIGHT = true; }
		}
		
		public static function onKeyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.W) { W = false; }
			if (e.keyCode == Keyboard.A) { A = false; }
			if (e.keyCode == Keyboard.S) { S = false; }
			if (e.keyCode == Keyboard.D) { D = false; }
			if (e.keyCode == Keyboard.SPACE) { SPACE = false; }
			if (e.keyCode == Keyboard.UP) { UP = false; }
			if (e.keyCode == Keyboard.DOWN) { DOWN = false; }
			if (e.keyCode == Keyboard.LEFT) { LEFT = false; }
			if (e.keyCode == Keyboard.RIGHT) { RIGHT = false; }
		}
	}
}