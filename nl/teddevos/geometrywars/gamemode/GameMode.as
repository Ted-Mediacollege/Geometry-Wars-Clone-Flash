package nl.teddevos.geometrywars.gamemode 
{
	import nl.teddevos.geometrywars.event.EventBase;
	import nl.teddevos.geometrywars.gui.screens.GuiScreenGame;
	import nl.teddevos.geometrywars.world.World;
	
	public class GameMode 
	{
		public var world:World;
		public var gui:GuiScreenGame;
		
		public function GameMode(w:World, g:GuiScreenGame) 
		{
			world = w;
			gui = g;
		}
		
		public function init():void
		{
			
		}
		
		public function tick():void
		{
			
		}
		
		public function onDeath():void
		{
			
		}
		
		public function onNewEvent():EventBase
		{
			return new EventBase("NULL", 2); 
		}
		
		public function getID():int
		{
			return 0;
		}
	}
}