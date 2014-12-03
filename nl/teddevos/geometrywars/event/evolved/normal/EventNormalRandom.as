package nl.teddevos.geometrywars.event.evolved.normal {
	import nl.teddevos.geometrywars.world.World;
	import nl.teddevos.geometrywars.util.MathHelper;
	import nl.teddevos.geometrywars.event.EventBase;
	
	public class EventNormalRandom extends EventBase
	{
		private var delay:int;
		
		public function EventNormalRandom() 
		{
			super("EventNormalRandom", 600);
			
			delay = 7;
		}
		
		override public function tick(world:World):void
		{
			delay--;
			if (delay < 0)
			{
				if (MathHelper.nextInt(40) == 0)
				{
					delay += 45;
					spawnRing(world, 0, 400, 25, 20);
				}
				else
				{
					delay += 7;
					world.enemies.spawnPoint(MathHelper.nextInt(4) == 0 ? MathHelper.nextInt(2) + 2 : MathHelper.nextInt(2), getRandSpawn(world, 300));
				}
			}
		}
	}
}