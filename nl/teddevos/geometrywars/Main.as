package nl.teddevos.geometrywars 
{
	import nl.teddevos.geometrywars.world.World;
	import starling.display.Quad;
	import starling.display.Sprite;
	import nl.teddevos.geometrywars.gui.GuiScreen;
	import nl.teddevos.geometrywars.gui.SwitchGuiEvent;
	import starling.events.EnterFrameEvent;
	import nl.teddevos.geometrywars.gui.screens.GuiScreenPreload;
	import starling.events.KeyboardEvent;
	import nl.teddevos.geometrywars.input.KeyInput;
	import flash.geom.Rectangle;
	import starling.filters.BlurFilter;
	import nl.teddevos.geometrywars.util.ColorHelper;
	import nl.teddevos.geometrywars.data.SaveData;

	public class Main extends Sprite
	{
		public static var main:Main;
		public var gui:GuiScreen;
		public var world:World;
		
		public var explosion:int;
		public var hue:int = 80;
		
		public function Main() 
		{
			main = this;
			
			gui = new GuiScreenPreload();
			addChild(gui);
			gui.preInit(this);
			gui.init();
			
			SaveData.init();
			
			addGlow();
			
			world = new World();
			addChildAt(world, 1);
			
			clipRect = new Rectangle(0, 0, 1280, 768);

			addEventListener(SwitchGuiEvent.NEWGUI, switchGui);
			addEventListener(EnterFrameEvent.ENTER_FRAME, tick);
			addEventListener(KeyboardEvent.KEY_DOWN, KeyInput.onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP, KeyInput.onKeyUp);
		}
		
		public function addGlow():void
		{
			var b:BlurFilter = BlurFilter.createGlow(0xFFFFFF, 1, 1, 0.5);
			b.setUniformColor(false, 0xFFFFFF, 1);
			filter = b;
		}
		
		public function tick(e:EnterFrameEvent):void
		{
			gui.preTick();
			gui.tick();
			world.tick();
			
			if (!world.playing)
			{
				explosion--;
				if (explosion < 0)
				{
					explosion += 1;
					hue += 1;
					if (hue > 360)
					{
						hue -= 360;
					}
					
					world.particleManager.createExplosion(Math.random() * 704 * 2 - 704, Math.random() * 448 * 2 - 448, 40, ColorHelper.HUEtoHEX(hue, 0.8, 0.7), 0.8, 0.2, 0, 180, 0);
					world.particleManager.createExplosion(Math.random() * 704 * 2 - 704, Math.random() * 448 * 2 - 448, 40, ColorHelper.HUEtoHEX(hue, 0.8, 0.7), 0.8, 0.2, 0, 180, 0);
				}
			}
		}
		
		public function switchGui(e:SwitchGuiEvent):void
		{
			removeChild(gui);
			gui.preDestroy();
			gui.destroy();
			gui = e.guiscreen;
			addChild(gui);
			gui.preInit(this);
			gui.init();
		}
	}
}