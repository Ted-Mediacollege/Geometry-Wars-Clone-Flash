package nl.teddevos.geometrywars.gui.screens 
{
	import flash.geom.Rectangle;
	import nl.teddevos.geometrywars.gui.components.GuiButton;
	import nl.teddevos.geometrywars.gui.components.GuiButtonMoving;
	import nl.teddevos.geometrywars.gui.components.GuiText;
	import nl.teddevos.geometrywars.gui.GuiScreen;
	import nl.teddevos.geometrywars.world.World;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.display.Quad;
	import flash.desktop.NativeApplication;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class GuiScreenMenu extends GuiScreen
	{
		public function GuiScreenMenu() 
		{
			
		}
		
		override public function init():void
		{
			addText(new GuiText(1280, 200, "Geometry Wars Clone", "GameFont", 155, 0xFFFFFF, false, 0, 0, screenWidth, 0));
			addText(new GuiText(200, 40, "Version 1.0 final", "GameFont", 40, 0xFFFFFF, false, screenWidth - 200, screenHeight - 40, -200, screenHeight - 40));
			
			//alpha bg
			var q:Quad = new Quad(1280, 480, 0x000000);
			q.y = screenHeight * 0.2;
			q.alpha = 0.5;
			addChild(q);
			
			var button_play:GuiButton = addButton(new GuiButtonMoving(0, screenWidth * 0.5, screenHeight * 0.37, 85, 44, "Play", 90, 120, 0xFFFFFF, -200, screenHeight * 0.37));
			var button_highscore:GuiButton = addButton(new GuiButtonMoving(1, screenWidth * 0.5, screenHeight * 0.49, 190, 44, "Highscore", 90, 120, 0xFFFFFF, screenWidth + 200, screenHeight * 0.49));
			var button_settings:GuiButton = addButton(new GuiButtonMoving(2, screenWidth * 0.5, screenHeight * 0.61, 170, 44, "Settings", 90, 120, 0xFFFFFF, -200, screenHeight * 0.61));
			var button_quit:GuiButton = addButton(new GuiButtonMoving(3, screenWidth * 0.5, screenHeight * 0.73, 85, 44, "Quit", 90, 120, 0xFFFFFF, screenWidth + 200, screenHeight * 0.73));
		}
		
		override public function tick():void
		{
		}
		
		override public function buttonPressed(b:GuiButton):void
		{
			if (b.id == 0)
			{
				switchGui(new GuiScreenSelect());
			}
			else if (b.id == 1)
			{
				switchGui(new GuiScreenHighscore());
			}
			else if (b.id == 2)
			{
				switchGui(new GuiScreenSettings());
			}
			else if (b.id == 3)
			{
				NativeApplication.nativeApplication.exit();
			}
		}
		
		override protected function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.A)
			{
				nextButton(-1);
			}
			else if (e.keyCode == Keyboard.RIGHT || e.keyCode == Keyboard.D)
			{
				nextButton(1);
			}
			else if (e.keyCode == Keyboard.UP || e.keyCode == Keyboard.W)
			{
				nextButton(-1);
			}
			else if (e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.S)
			{
				nextButton(1);
			}
			else if (e.keyCode == Keyboard.ENTER && keys)
			{
				buttonPressed(buttonList[buttonListSelected]);
			}
		}
	}
}