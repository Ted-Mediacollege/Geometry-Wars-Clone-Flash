package nl.teddevos.geometrywars.gui.components 
{
	public class GuiButtonMoving extends GuiButton
	{
		private var startX:Number;
		private var startY:Number;
		private var time:int;
		
		public function GuiButtonMoving(i:int, px:Number, py:Number, w:Number, h:Number, t:String, s1:int, s2:int, c:uint, sX:Number, sY:Number, helpBox:Boolean = false) 
		{
			super(i, px, py, w, h, t, s1, s2, c, helpBox);
			
			startX = sX;
			startY = sY;
			time = 10;
			enabled = false;
			
			textField.x = startX - buttonWidth;
			textField.y = startY - buttonHeight;
		}
		
		override public function tick():void
		{
			if (time > 0)
			{
				time--;
				textField.x = ((startX * (time)) + (buttonX * (10 - time))) / 10 - buttonWidth;
				textField.y = ((startY * (time)) + (buttonY * (10 - time))) / 10 - buttonHeight;
				
				if (time == 0)
				{
					textField.x = buttonX - buttonWidth;
					textField.y = buttonY - buttonHeight;
				}
			}
			else
			{
				enabled = true;
			}
		}
		
		override public function end():void
		{
			var tempX:Number = startX;
			var tempY:Number = startY;
			
			startX = buttonX;
			startY = buttonY;
			buttonX = tempX;
			buttonY = tempY;
			
			time = 10;
		}
		
		private function max(n:Number, m:Number):Number
		{
			return n > m ? m : n < -m ? -m : n;
		}
	}
}