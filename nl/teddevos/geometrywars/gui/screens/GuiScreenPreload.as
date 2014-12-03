package nl.teddevos.geometrywars.gui.screens 
{
	import nl.teddevos.geometrywars.gui.GuiScreen;
	import nl.teddevos.geometrywars.graphics.AssetsList;
	import nl.teddevos.geometrywars.gui.SwitchGuiEvent;
	import starling.display.Quad;
	import nl.teddevos.geometrywars.gui.components.GuiText;
	import nl.teddevos.geometrywars.util.ColorHelper;

	public class GuiScreenPreload extends GuiScreen
	{
		private var delay:int;
		private var loadingQuad:Quad;
		private var explosion:int;
		
		public function GuiScreenPreload() 
		{
			
		}
		
		override public function init():void
		{
			AssetsList.init();
			
			delay = 0;
			main.explosion = 1000;
			
			addText(new GuiText(1280, 200, "Loading...", "GameFont", 135, 0xFFFFFF, false, 0, 300, 0, 300));
			
			loadingQuad = new Quad(1, 20, 0xFF0000);
			loadingQuad.x = 640 - 45 * 5;
			loadingQuad.y = 520;
			addChild(loadingQuad);
			
			explosion = int((60 - delay) / 10);
		}
		
		override public function tick():void
		{
			delay++;
			if (delay > 90 && AssetsList.loaded)
			{
				main.explosion = 0;
				dispatchEvent(new SwitchGuiEvent(SwitchGuiEvent.NEWGUI, new GuiScreenMenu(), true));
			}
			else if (delay < 91)
			{
				loadingQuad.width = delay * 5;
				
				explosion--;
				if (explosion < 1)
				{
					explosion = int((90 - delay) / 10);
					main.world.particleManager.createExplosion(Math.random() * 704 * 2 - 704, Math.random() * 448 * 2 - 448, 40, ColorHelper.HUEtoHEX(80, 0.8, 0.7), 0.8, 0.2, 0, 180, 0);
					main.world.particleManager.createExplosion(Math.random() * 704 * 2 - 704, Math.random() * 448 * 2 - 448, 40, ColorHelper.HUEtoHEX(80, 0.8, 0.7), 0.8, 0.2, 0, 180, 0);
				}
			}
		}
	}
}