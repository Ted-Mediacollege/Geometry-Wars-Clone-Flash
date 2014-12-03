package nl.teddevos.geometrywars.event.evolved.easy {
	import nl.teddevos.geometrywars.world.World;
	import nl.teddevos.geometrywars.util.MathHelper;
	import nl.teddevos.geometrywars.event.EventBase;
	
	public class EventEasyRandom extends EventBase
	{
		private var delay:int;
		
		public function EventEasyRandom() 
		{
			super("EventEasyRandom", 500);
			
			delay = 14;
		}
		
		override public function tick(world:World):void
		{
			delay--;
			if (delay < 0)
			{
				delay += 12;
				world.enemies.spawnPoint(MathHelper.nextInt(3) == 0 ? MathHelper.nextInt(2) + 2 : MathHelper.nextInt(2), getRandSpawn(world, 300));
			}
		}
	}
}