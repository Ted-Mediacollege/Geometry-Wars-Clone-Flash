package nl.teddevos.geometrywars.gui 
{
	import nl.teddevos.geometrywars.gui.components.GuiText;
	import nl.teddevos.geometrywars.Main;
	import starling.display.Image;
	import starling.display.Sprite;
	import nl.teddevos.geometrywars.gui.components.GuiButton;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import nl.teddevos.geometrywars.PreLoader;
	
	public class GuiScreen extends Sprite
	{
		public var buttonList:Vector.<GuiButton>;
		public var textList:Vector.<GuiText>;
		public var main:Main;
		
		protected var screenWidth:int = 1280;
		protected var screenHeight:int = 768;
		
		protected var mX:Number;
		protected var mY:Number;
		
		private var delay:int;
		private var nextGui:GuiScreen;
		
		protected var keys:Boolean = true;
		protected var buttonSelected:int = 0;
		protected var buttonListSelected:int = 0;
		
		public function GuiScreen() 
		{
		}
		
		public function preInit(m:Main):void
		{
			main = m;
			buttonList = new Vector.<GuiButton>();
			textList = new Vector.<GuiText>();
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public function init():void
		{
		}
		
		public function tick():void
		{
		}
		
		public function preTick():void
		{	
			mX = PreLoader.preloader.mouseX;
			mY = PreLoader.preloader.mouseY;
				
			if (delay > 0)
			{
				delay--;
				if (delay == 0)
				{
					dispatchEvent(new SwitchGuiEvent(SwitchGuiEvent.NEWGUI, nextGui, true));
				}
				else
				{
					for (var j:int = buttonList.length - 1; j > -1; j-- )
					{
						buttonList[j].tick();
					}
					
					for (var m:int = textList.length - 1; m > -1; m-- )
					{
						textList[m].tick();
					}
				}
			}
			else
			{
				for (var i:int = buttonList.length - 1; i > -1; i-- )
				{
					buttonList[i].tick();
					
					if (buttonList[i].buttonX - buttonList[i].buttonWidth < mX && 
						buttonList[i].buttonX + buttonList[i].buttonWidth > mX && 
						buttonList[i].buttonY - buttonList[i].buttonHeight < mY && 
						buttonList[i].buttonY + buttonList[i].buttonHeight > mY && !keys)
					{
						if (!buttonList[i].hovering)
						{
							buttonList[i].hover(true);
							buttonListSelected = i;
							buttonSelected = buttonList[i].id;
						}
					}
					else if (buttonList[i].hovering && !keys)
					{
						buttonList[i].hover(false);
					}
				}
					
				for (var n:int = textList.length - 1; n > -1; n-- )
				{
					textList[n].tick();
				}
			}
		}
		
		public function switchGui(newGui:GuiScreen):void
		{
			if (delay == 0)
			{
				for (var i:int = buttonList.length - 1; i > -1; i-- )
				{
					buttonList[i].end();
				}
				
				for (var j:int = textList.length - 1; j > -1; j-- )
				{
					textList[j].end();
				}
				
				nextGui = newGui;
				delay = 10;
			}
		}
		
		public function buttonPressed(b:GuiButton):void
		{
		}
		
		public function preDestroy():void
		{
			removeEventListener(TouchEvent.TOUCH, onTouch);
			removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public function destroy():void
		{
		}
		
		public function addButton(button:GuiButton):GuiButton
		{
			buttonList.push(button);
			addChild(button);
			
			if (button.id == buttonSelected && buttonSelected > -1)
			{
				button.hover(true);
				buttonListSelected = buttonList.indexOf(button);
			}
			
			return button;
		}
		
		public function nextButton(dir:int):void
		{
			keys = true;
			if (buttonList.length > 1)
			{
				if (dir < 0)
				{
					if (!setHighestButton(buttonSelected + dir))
					{
						setHighestButton();
					}
				}
				else if (dir > 0)
				{
					if (!setLowestButton(buttonSelected + dir))
					{
						setLowestButton();
					}
				}
			}
		}
		
		private function setHighestButton(max:int = 99999):Boolean
		{
			var highest:int = 0;
			var j:int = 0;
			var l:int = buttonList.length;
			var found:Boolean = false;
			for (var i:int = 0; i < l; i++)
			{
				if (buttonList[i].id >= highest && buttonList[i].id <= max)
				{
					j = i;
					found = true;
					highest = buttonList[i].id;
				}
			}
			buttonList[buttonListSelected].hover(false);
			buttonList[j].hover(true);
			buttonListSelected = j;
			buttonSelected = buttonList[j].id;
			
			return found;
		}
		
		private function setLowestButton(min:int = 0):Boolean
		{
			var lowest:int = 99999;
			var j:int = 0;
			var l:int = buttonList.length;
			var found:Boolean = false;
			for (var i:int = 0; i < l; i++)
			{
				if (buttonList[i].id <= lowest && buttonList[i].id >= min)
				{
					j = i;
					found = true;
					lowest = buttonList[i].id;
				}
			}
			buttonList[buttonListSelected].hover(false);
			buttonList[j].hover(true);
			buttonListSelected = j;
			buttonSelected = buttonList[j].id;
			
			return found;
		}
		
		public function addText(t:GuiText):GuiText
		{
			textList.push(t);
			addChild(t);
			return t;
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			
		}
		
		protected function onTouch(e:TouchEvent):void
		{
			var t:Touch = e.getTouch(main);
			
			if (t)
			{
				if (t.phase == TouchPhase.HOVER || t.phase == TouchPhase.MOVED)
				{
					for (var j:int = buttonList.length - 1; j > -1; j-- )
					{
						if (buttonList[j].buttonX - buttonList[j].buttonWidth < mX && 
							buttonList[j].buttonX + buttonList[j].buttonWidth > mX && 
							buttonList[j].buttonY - buttonList[j].buttonHeight < mY && 
							buttonList[j].buttonY + buttonList[j].buttonHeight > mY)
						{
							keys = false;
						}
					}
				}
				else if (t.phase == TouchPhase.ENDED)
				{
					for (var i:int = buttonList.length - 1; i > -1; i-- )
					{
						if (buttonList[i].buttonX - buttonList[i].buttonWidth < mX && 
							buttonList[i].buttonX + buttonList[i].buttonWidth > mX && 
							buttonList[i].buttonY - buttonList[i].buttonHeight < mY && 
							buttonList[i].buttonY + buttonList[i].buttonHeight > mY)
						{
							buttonPressed(buttonList[i]);
							break;
						}
					}
				}
			}
		}
	}
}