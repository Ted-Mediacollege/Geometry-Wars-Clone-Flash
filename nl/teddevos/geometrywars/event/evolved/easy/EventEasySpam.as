package nl.teddevos.geometrywars.event.evolved.easy {
	import nl.teddevos.geometrywars.world.World;
	import nl.teddevos.geometrywars.util.MathHelper;
	import nl.teddevos.geometrywars.event.EventBase;
	
	public class EventEasySpam extends EventBase
	{
		private var delay:int;
		private var left:int;
		private var type:int;
		
		public function EventEasySpam() 
		{
			super("EventEasySpam", 400);
			
			delay = 7;
			
			var rt:int = MathHelper.nextInt(4);
			if (rt == 0)
			{
				type = 3;
				left = 7;
			}
			else
			{
				type = 0;
				left = 12;
			}
		}
		
		override public function tick(world:World):void
		{
			if (left > -1)
			{
				delay--;
				if (delay < 0)
				{
					var x:Number = -20 + Math.random() * 40;
					var y:Number = -20 + Math.random() * 40;
					
					delay += 15;
					world.enemies.spawnPoint(type, getCorner(0, x, y));
					world.enemies.spawnPoint(type, getCorner(1, x, y));
					world.enemies.spawnPoint(type, getCorner(2, x, y));
					world.enemies.spawnPoint(type, getCorner(3, x, y));
					left--;
				}
			}
		}
	}
}