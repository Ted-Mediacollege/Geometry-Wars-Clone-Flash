package nl.teddevos.geometrywars.gui.components 
{
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class GuiSlideItem extends Image
	{
		private var startPosX:Number;
		private var endPosX:Number;
		
		private var startScaleX:Number;
		private var startScaleY:Number;
		private var endScaleX:Number;
		private var endScaleY:Number;
		
		public var gamemodeID:int;
		
		public function GuiSlideItem(id:int, texture:Texture) 
		{
			super(texture);
			gamemodeID = id;
			pivotX = 250;
			pivotY = 175;
			y = 384;
			setTo(0);
		}
		
		public function setTo(pos:int):void
		{
			if (pos == gamemodeID)
			{
				scaleX = 1;
				scaleY = 1;
			}
			else
			{
				scaleX = 0.5;
				scaleY = 0.5;
			}
			
			x = 640 - ((pos - gamemodeID) * 450);
		}
		
		public function move(pos:int, zoom:Boolean):void
		{
			if (pos == gamemodeID && zoom)
			{
				startScaleX = scaleX;
				startScaleY = scaleY;
				endScaleX = 1;
				endScaleY = 1;
			}
			else if(zoom)
			{
				startScaleX = scaleX;
				startScaleY = scaleY;
				endScaleX = 0.5;
				endScaleY = 0.5;
			}
			else
			{
				startScaleX = scaleX;
				startScaleY = scaleY;
				endScaleX = 0.5;
				endScaleY = 0.5;
			}
			
			startPosX = x;
			endPosX = 640 - ((pos - gamemodeID) * 450);
		}
		
		public function tick(time:Number):void
		{
			time /= 5;
			x = (startPosX * time) + (endPosX * (1 - time));
			scaleX = (startScaleX * time) + (endScaleX * (1 - time));
			scaleY = (startScaleY * time) + (endScaleY * (1 - time));
		}
	}
}