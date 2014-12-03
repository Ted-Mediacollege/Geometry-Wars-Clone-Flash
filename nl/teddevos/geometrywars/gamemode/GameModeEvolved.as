package nl.teddevos.geometrywars.gamemode 
{
	import nl.teddevos.geometrywars.event.EventBase;
	import nl.teddevos.geometrywars.event.evolved.EventStart;
	import nl.teddevos.geometrywars.event.evolved.EventWakeup;
	import nl.teddevos.geometrywars.gui.screens.GuiScreenGame;
	import nl.teddevos.geometrywars.world.World;
	import nl.teddevos.geometrywars.event.evolved.easy.*;
	import nl.teddevos.geometrywars.event.evolved.normal.*;
	import nl.teddevos.geometrywars.util.MathHelper;
	
	public class GameModeEvolved extends GameMode
	{
		public function GameModeEvolved(w:World, g:GuiScreenGame) 
		{
			super(w, g);
		}
		
		override public function init():void
		{
			world.lives = 3;
			world.iconsEnabled = true;
		}
		
		override public function tick():void
		{
			
		}
		
		override public function onDeath():void
		{
			world.currentEvent = new EventWakeup();
		}
		
		override public function onNewEvent():EventBase
		{				
			return new EventNormalHoles();
			
			var r:int = 0;
			if (world.level == 0)
			{
				return new EventStart();
			}
			else if (world.level < 6)
			{
				r = MathHelper.nextInt(world.level < 3 ? 3 : 6);
				if (r < 2)
				{
					return new EventEasyRandom();
				}
				else if (r < 3)
				{
					return new EventEasySpam();
				}
				else
				{
					return new EventEasyHoles();
				}
			}
			else //level < 15
			{
				r = MathHelper.nextInt(6);
				if (r < 2)
				{
					return new EventNormalRandom();
				}
				else if (r < 4)
				{
					return new EventNormalHoles();
				}
				else
				{
					return new EventNormalDarts();
				}
			}
		}
		
		override public function getID():int
		{
			return 2;
		}
	}
}