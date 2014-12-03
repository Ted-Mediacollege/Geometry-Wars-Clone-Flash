package nl.teddevos.geometrywars.gui.screens 
{
	import nl.teddevos.geometrywars.gui.components.GuiButton;
	import nl.teddevos.geometrywars.gui.components.GuiButtonMoving;
	import nl.teddevos.geometrywars.gui.components.GuiSlideItem;
	import nl.teddevos.geometrywars.gui.components.GuiText;
	import nl.teddevos.geometrywars.gui.GuiScreen;
	import starling.display.Image;
	import nl.teddevos.geometrywars.graphics.AssetsList;
	import starling.display.Quad;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	public class GuiScreenSelect extends GuiScreen
	{
		public var startDelay:int = 10;
		public var endDelay:int = 0;
		public var moving:int = 0;
		public var pos:int = 0;
		public var MAX_GAMEMODES:int = 3;
		
		public var gamemodes:Vector.<GuiSlideItem>;
		
		public function GuiScreenSelect() 
		{
		}
		
		override public function init():void
		{
			buttonSelected = -1;
			
			addText(new GuiText(1280, 200, "GameModes", "GameFont", 135, 0xFFFFFF, false, 0, 0, -screenWidth, 0));
			var button_back:GuiButton = addButton(new GuiButtonMoving(0, screenWidth * 0.5, screenHeight * 0.93, 240, 44, "Back to menu", 90, 110, 0xFFFFFF, screenWidth + 240, screenHeight * 0.93));
						
			//alpha bg
			var q:Quad = new Quad(1280, 480, 0x000000);
			q.y = screenHeight * 0.2;
			q.alpha = 0.5;
			addChild(q);
			
			var images:Vector.<String> = new <String>["gamemode_evolved.png", "gamemode_pacifism.png", "gamemode_waves.png", "gamemode_king.png"];
			gamemodes = new Vector.<GuiSlideItem>();
			
			for (var i:int = 0; i < MAX_GAMEMODES; i++ )
			{
				var item:GuiSlideItem = new GuiSlideItem(i, AssetsList.assets.getTexture(images[i]));
				gamemodes.push(item);
				addChild(item);
			}
		}
		
		override protected function onKeyDown(e:KeyboardEvent):void
		{
			if ((e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.A) && pos > 0 && buttonSelected != 0)
			{
				moving = 5;
				pos--;
				for (var i:int = 0; i < MAX_GAMEMODES; i++ )
				{
					gamemodes[i].move(pos, true);
				}
				keys = true;
			}
			else if ((e.keyCode == Keyboard.RIGHT || e.keyCode == Keyboard.D) && pos < MAX_GAMEMODES - 1 && buttonSelected != 0)
			{
				moving = 5;
				pos++;
				for (var j:int = 0; j < MAX_GAMEMODES; j++ )
				{
					gamemodes[j].move(pos, true);
				}
				keys = true;
			}
			else if ((e.keyCode == Keyboard.UP || e.keyCode == Keyboard.W))
			{
				moving = 5;
				for (var k:int = 0; k < MAX_GAMEMODES; k++ )
				{
					gamemodes[k].move(pos, true);
				}
				keys = true;
				buttonSelected = -1;
				buttonList[0].hover(false);
			}
			else if ((e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.S))
			{
				moving = 5;
				for (var l:int = 0; l < MAX_GAMEMODES; l++ )
				{
					gamemodes[l].move(pos, false);
				}
				keys = true;
				buttonSelected = 0;
				buttonList[0].hover(true);
			}
			else if (e.keyCode == Keyboard.ENTER)
			{
				if (buttonSelected == 0)
				{
					buttonPressed(buttonList[buttonSelected]);
				}
				else
				{
					switchGui(new GuiScreenGame(pos));
				}
				endDelay = 10;
			}
		}
		
		override public function tick():void
		{
			if (startDelay > 0)
			{
				startDelay--;
				for (var a:int = 0; a < MAX_GAMEMODES; a++ )
				{
					gamemodes[a].alpha = 1 - (startDelay / 10);
				}
			}
			else if (endDelay > 0)
			{
				endDelay--;
				for (var c:int = 0; c < MAX_GAMEMODES; c++ )
				{
					gamemodes[c].alpha = endDelay / 10;
				}
			}
			else
			{
				if (moving > 0)
				{
					moving--;
					for (var b:int = 0; b < MAX_GAMEMODES; b++ )
					{
						gamemodes[b].tick(moving);
					}
				}
			}
		}
		
		override public function buttonPressed(b:GuiButton):void
		{
			if (b.id == 0)
			{
				switchGui(new GuiScreenMenu());
			}
		}
		
		override protected function onTouch(e:TouchEvent):void
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
					var b:Boolean = false;
					for (var i:int = buttonList.length - 1; i > -1; i-- )
					{
						if (buttonList[i].buttonX - buttonList[i].buttonWidth < mX && 
							buttonList[i].buttonX + buttonList[i].buttonWidth > mX && 
							buttonList[i].buttonY - buttonList[i].buttonHeight < mY && 
							buttonList[i].buttonY + buttonList[i].buttonHeight > mY)
						{
							buttonPressed(buttonList[i]);
							endDelay = 10;
							b = true;
							break;
						}
					}
					
					if (!b)
					{
						if (mX > 890 && pos < MAX_GAMEMODES - 1)
						{
							moving = 5;
							pos++;
							for (var k:int = 0; k < MAX_GAMEMODES; k++ )
							{
								gamemodes[k].move(pos, true);
							}
						}
						else if (mX < 390 && pos > 0)
						{
							moving = 5;
							pos--;
							for (var m:int = 0; m < MAX_GAMEMODES; m++ )
							{
								gamemodes[m].move(pos, true);
							}
						}
						else
						{
							switchGui(new GuiScreenGame(pos));
							endDelay = 10;
						}
					}
				}
			}
		}
	}
}