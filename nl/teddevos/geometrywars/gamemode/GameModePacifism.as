package nl.teddevos.geometrywars.gamemode 
{
	import nl.teddevos.geometrywars.event.EventBase;
	import nl.teddevos.geometrywars.event.pacifism.EventPacifismStart;
	import nl.teddevos.geometrywars.gui.screens.GuiScreenGame;
	import nl.teddevos.geometrywars.world.World;
	import nl.teddevos.geometrywars.util.MathHelper;
	
	public class GameModePacifism extends GameMode
	{
		public function GameModePacifism(w:World, g:GuiScreenGame) 
		{
			super(w, g);
		}
		
		override public function init():void
		{
			world.lives = 1;
			world.projectilesEnabled = false;
		}
		
		override public function tick():void
		{
			
		}
		
		override public function onDeath():void
		{
			
		}
		
		override public function onNewEvent():EventBase
		{		
			return new EventPacifismStart(6 + (world.level * 2));
		}
		
		override public function getID():int
		{
			return 2;
		}
	}
}