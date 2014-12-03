package nl.teddevos.geometrywars.gui.components 
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class GuiButton extends Sprite
	{
		public var textField:TextField;
		private var defaultSize:int;
		private var jumpSize:int;
		
		public var buttonX:Number;
		public var buttonY:Number;
		public var buttonWidth:Number;
		public var buttonHeight:Number;
		
		public var hovering:Boolean;
		public var enabled:Boolean = false;
		
		public var id:int;
		
		public function GuiButton(i:int, px:Number, py:Number, w:Number, h:Number, t:String, s1:int, s2:int, c:uint, helpBox:Boolean = false) 
		{
			textField = new TextField(w * 2, h * 2, t, "GameFont", s1, c);
			textField.x = px - w;
			textField.y = py - h;
			addChild(textField);
			
			buttonX = px;
			buttonY = py;
			buttonWidth = w;
			buttonHeight = h;
			
			defaultSize = s1;
			jumpSize = s2;
			
			id = i;
			
			if (helpBox)
			{
				var q:Quad = new Quad(w * 2, h * 2, 0xFF0000);
				q.x = px - w;
				q.y = py - h;
				addChildAt(q, 0);
			}
		}
		
		public function tick():void
		{
			
		}
		
		public function end():void
		{
			
		}
		
		public function hover(h:Boolean):void
		{
			hovering = h;
			textField.fontSize = hovering ? jumpSize : defaultSize;
			textField.color = h ? 0xFF9999 : 0xFFFFFF;
		}
	}
}