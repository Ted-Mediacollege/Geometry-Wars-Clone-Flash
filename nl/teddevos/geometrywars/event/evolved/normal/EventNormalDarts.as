package nl.teddevos.geometrywars.event.evolved.normal {
	import nl.teddevos.geometrywars.world.World;
	import nl.teddevos.geometrywars.util.MathHelper;
	import nl.teddevos.geometrywars.event.EventBase;
	
	public class EventNormalDarts extends EventBase
	{
		public var spawned:Boolean = false;
		
		public function EventNormalDarts() 
		{
			super("EventNormalDarts", 190);
		}
		
		override public function tick(world:World):void
		{
			if (!spawned)
			{
				spawned = true;
				var i:int = 0;
				
				if (world.player.y > 0)
				{
					for (i = -14; i < 15; i++ )
					{
						world.enemies.dart(i * 50, -World.fieldHeight, 0);
					}
				}
				else
				{
					for (i = -14; i < 15; i++ )
					{
						world.enemies.dart(i * 50, World.fieldHeight, 2);
					}
				}
				
				if (world.player.x < 0)
				{
					for (i = -8; i < 9; i++ )
					{
						world.enemies.dart(World.fieldWidth, i * 50, 1);
					}
				}
				else
				{
					for (i = -8; i < 9; i++ )
					{
						world.enemies.dart(-World.fieldWidth, i * 50, 3);
					}
				}
			}
		}
	}
}