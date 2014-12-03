package nl.teddevos.geometrywars.event.waves 
{
	import nl.teddevos.geometrywars.world.World;
	import nl.teddevos.geometrywars.util.MathHelper;
	import nl.teddevos.geometrywars.event.EventBase;
	
	public class EventWavesDoubleHalf extends EventBase
	{
		public var random:int = 0;
		
		public function EventWavesDoubleHalf(t:int, r:int) 
		{
			super("EventWavesEasy", t);
			random = r;
		}
		
		override public function start(world:World):void
		{
			for (var i:int = 0; i < random; i++)
			{
				world.enemies.spawnPoint(MathHelper.nextInt(2) == 0 ? 1 : 0 , getRandSpawn(world));
			}
			
			if (world.player.y > -200)
			{
				if (world.player.y < 200 && Math.random() * 2 < 1)
				{
					spawnRow(world, true, 2);
				}
				else
				{
					spawnRow(world, true, 0);
				}
			}
			else
			{
				spawnRow(world, true, 2);
			}
			
			if (world.player.x < 450)
			{
				if (world.player.x > -450 && Math.random() * 2 < 1)
				{
					spawnRow(world, true, 3);
				}
				else
				{
					spawnRow(world, true, 1);
				}
			}
			else
			{
				spawnRow(world, true, 3);
			}
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
				l = r == 1 ? 0 : 14;
				for (i = r == 0 ? 0 : -13; i < l; i++ )
				{
					world.enemies.dart(i * 50, -World.fieldHeight, 0);
				}
			}
			else if (side == 2)
			{
				l = r == 1 ? 0 : 14;
				for (i = r == 0 ? 0 : -13; i < l; i++ )
				{
					world.enemies.dart(i * 50, World.fieldHeight, 2);
				}
			}
			else if (side == 1)
			{
				l = r == 1 ? 0 : 9;
				for (i = r == 0 ? 0 : -8; i < l; i++ )
				{
					world.enemies.dart(World.fieldWidth, i * 50, 1);
				}
			}
			else if (side == 3)
			{
				l = r == 1 ? 0 : 9;
				for (i = r == 0 ? 0 : -8; i < l; i++ )
				{
					world.enemies.dart(-World.fieldWidth, i * 50, 3);
				}
			}
		}
	}
}