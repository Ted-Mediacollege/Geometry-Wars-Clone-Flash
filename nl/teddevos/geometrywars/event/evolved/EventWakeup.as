package nl.teddevos.geometrywars.event.evolved 
{
	import nl.teddevos.geometrywars.world.World;
	import nl.teddevos.geometrywars.util.MathHelper;
	import nl.teddevos.geometrywars.event.EventBase;
	
	public class EventWakeup extends EventBase
	{
		private var delay:int;
		
		public function EventWakeup() 
		{
			super("EventWakeup", 240);
			
			delay = 45;
		}
		
		override public function tick(world:World):void
		{
			delay--;
			if (delay < 0)
			{
				delay += 30;
				world.enemies.spawnPoint(MathHelper.nextInt(4) == 0 ? 1 : 0 , getRandSpawn(world));
			}
		}
	}
}