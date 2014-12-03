package nl.teddevos.geometrywars.event.waves 
{
	import nl.teddevos.geometrywars.world.World;
	import nl.teddevos.geometrywars.util.MathHelper;
	import nl.teddevos.geometrywars.event.EventBase;
	
	public class EventWavesStart extends EventBase
	{
		public function EventWavesStart() 
		{
			super("EventWavesStart", 50);
		}
		
		override public function start(world:World):void
		{
			world.enemies.dart(0, -World.fieldHeight, 0);
			world.enemies.dart(0, World.fieldHeight, 2);
			world.enemies.dart(World.fieldWidth, 0, 1);
			world.enemies.dart(-World.fieldWidth, 0, 3);
		}
		
		private function spawnRow(world:World, half:Boolean, side:int):void
		{
			var l:int = 0, i:int = 0, r:int = 0;
			if (half)
			{
				r = int(Math.random() * 2);
			}
			
			if (side == 0)
			{
				l = r == 0 ? 0 : 15;
				for (i = r == 0 ? 0 : -14; i < l; i++ )
				{
					world.enemies.dart(i * 50, -World.fieldHeight, 0);
				}
			}
			else if (side == 2)
			{
				l = r == 0 ? 0 : 15;
				for (i = r == 0 ? 0 : -14; i < l; i++ )
				{
					world.enemies.dart(i * 50, World.fieldHeight, 2);
				}
			}
			else if (side == 1)
			{
				l = r == 0 ? 0 : 9;
				for (i = r == 0 ? 0 : -8; i < l; i++ )
				{
					world.enemies.dart(World.fieldWidth, i * 50, 1);
				}
			}
			else if (side == 3)
			{
				l = r == 0 ? 0 : 9;
				for (i = r == 0 ? 0 : -8; i < l; i++ )
				{
					world.enemies.dart(-World.fieldWidth, i * 50, 3);
				}
			}
		}
	}
}