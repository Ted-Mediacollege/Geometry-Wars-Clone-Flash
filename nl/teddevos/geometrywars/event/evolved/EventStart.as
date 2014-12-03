package nl.teddevos.geometrywars.event.evolved 
{
	import nl.teddevos.geometrywars.world.World;
	import nl.teddevos.geometrywars.util.MathHelper;
	import nl.teddevos.geometrywars.event.EventBase;
	
	public class EventStart extends EventBase
	{
		private var delay:int;
		
		public function EventStart() 
		{
			super("EventStart", 300);
			
			delay = 30;
		}
		
		override public function tick(world:World):void
		{
			delay--;
			if (delay < 0)
			{
				delay += 60;
				world.enemies.spawnPoint(MathHelper.nextInt(3) == 0 ? 1 : 0 , getRandSpawn(world));
			}
		}
	}
}