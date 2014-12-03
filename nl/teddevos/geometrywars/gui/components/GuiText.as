package nl.teddevos.geometrywars.gui.components 
{
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class GuiText extends Sprite
	{
		public var textField:TextField;
		
		private var posX:Number;
		private var posY:Number;
		private var startX:Number;
		private var startY:Number;
		private var time:int;
		
		public function GuiText(w:Number, h:Number, text:String, fontName:String, fontSize:int, color:uint, bold:Boolean, px:Number, py:Number, sx:Number, sy:Number) 
		{
			textField = new TextField(w, h, text, fontName, fontSize, color, bold);
			addChild(textField);
				
			posX = px;
			posY = py;
			startX = sx;
			startY = sy;
			
			time = 10;
			
			textField.x = startX;
			textField.y = startY;
		}
		
		public function tick():void
		{
			if (time > 0)
			{
				time--;
				textField.x = ((startX * (time)) + (posX * (10 - time))) / 10;
				textField.y = ((startY * (time)) + (posY * (10 - time))) / 10;
				
				if (time == 0)
				{
					textField.x = posX;
					textField.y = posY;
				}
			}
		}
		
		public function end():void
		{
			var tempX:Number = startX;
			var tempY:Number = startY;
			
			startX = posX;
			startY = posY;
			posX = tempX;
			posY = tempY;
			
			time = 10;
		}
	}
}