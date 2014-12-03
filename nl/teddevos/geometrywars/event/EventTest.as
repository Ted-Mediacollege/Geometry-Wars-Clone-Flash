package nl.teddevos.geometrywars.event 
{
	import flash.geom.Point;
	import nl.teddevos.geometrywars.world.World;
	import nl.teddevos.geometrywars.util.MathHelper;
	
	public class EventTest extends EventBase
	{
		private var delay:int;
		
		public function EventTest() 
		{
			super("EventTest", 100000);
			
			delay = 30;
		}
		
		override public function tick(world:World):void
		{
			delay--;
			if (delay < 0)
			{
				delay += 5;
				world.enemies.spawnPoint(MathHelper.nextInt(3) == 0 ? 1 : 0 , getRandSpawn(world));
			}
		}
	}
}