package nl.teddevos.geometrywars.gamemode 
{
	import nl.teddevos.geometrywars.event.EventBase;
	import nl.teddevos.geometrywars.event.waves.EventWavesDoubleFull;
	import nl.teddevos.geometrywars.event.waves.EventWavesDoubleHalf;
	import nl.teddevos.geometrywars.event.waves.EventWavesStart;
	import nl.teddevos.geometrywars.event.waves.EventWavesWait;
	import nl.teddevos.geometrywars.gui.screens.GuiScreenGame;
	import nl.teddevos.geometrywars.world.World;
	
	public class GameModeWaves extends GameMode
	{
		public function GameModeWaves(w:World, g:GuiScreenGame) 
		{
			super(w, g);
		}
		
		override public function init():void
		{
			
		}
		
		override public function tick():void
		{
			
		}
		
		override public function onDeath():void
		{
			
		}
		
		override public function onNewEvent():EventBase
		{
			if (world.level == 0)
			{
				return new EventWavesStart();
			}
			else if(world.level < 3)
			{
				return new EventWavesDoubleHalf(200, 1);
			}
			else if(world.level < 8)
			{
				if (Math.random() * 4.0 < 1.0)
				{
					return new EventWavesDoubleFull(220, 2);
				}
				else
				{
					return new EventWavesDoubleHalf(150, 2);
				}
			}
			else if(world.level < 14)
			{
				if (world.enemies.len < 200)
				{
					if (Math.random() * 2.0 < 1.0)
					{
						return new EventWavesDoubleFull(200, 3);
					}
					else
					{
						return new EventWavesDoubleHalf(150, 3);
					}
				}
				else
				{
					return new EventWavesWait(50);
				}
			}
			else if(world.level < 25)
			{
				if (world.enemies.len < 250)
				{
					if (Math.random() * 3.0 < 2.0)
					{
						return new EventWavesDoubleFull(180, 4);
					}
					else
					{
						return new EventWavesDoubleHalf(140, 4);
					}
				}
				else
				{
					return new EventWavesWait(50);
				}
			}
			else
			{
				if (world.enemies.len < 300)
				{
					if (Math.random() * 4.0 < 2.0)
					{
						return new EventWavesDoubleFull(160, 5);
					}
					else
					{
						return new EventWavesDoubleHalf(120, 5);
					}
				}
				else
				{
					return new EventWavesWait(50);
				}
			}
		}
		
		override public function getID():int
		{
			return 2;
		}
	}
}