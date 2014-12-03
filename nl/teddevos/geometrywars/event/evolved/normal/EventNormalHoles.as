package nl.teddevos.geometrywars.event.evolved.normal {
	import flash.geom.Point;
	import nl.teddevos.geometrywars.world.World;
	import nl.teddevos.geometrywars.util.MathHelper;
	import nl.teddevos.geometrywars.event.EventBase;
	
	public class EventNormalHoles extends EventBase
	{
		private var delay:int;
		private var first:Boolean;
		
		public function EventNormalHoles() 
		{
			super("EventNormalHoles", 500);
			
			delay = 12;
			first = true;
		}
		
		override public function tick(world:World):void
		{
			if (first)
			{
				first = false;
				var a:int = world.enemies.blackholes.length;
				for (var i:int = 0; i < 20; i++)
				{
					if (a > 2)
					{
						break;
					}
					
					var p:Point = getRandSpawn(world, 300);
					
					if (!isHoleNear(world, p.x, p.y, 300))
					{
						world.enemies.blackhole(p.x, p.y);
						a++;
					}
				}
			}
			
			delay--;
			if (delay < 0)
			{
				delay += 7;
				var p2:Point = getRandSpawn(world, 300);
				
				if (!isHoleNear(world, p2.x, p2.y, 150))
				{
					if (MathHelper.nextInt(32) == 0)
					{
						spawnBomb(world, p2.x, p2.y, 0, 20);
						delay += 40;
					}
					else
					{
						world.enemies.spawnXY(MathHelper.nextInt(5) == 0 ? MathHelper.nextInt(2) + 2 : MathHelper.nextInt(2), p2.x, p2.y);
					}
				}
			}
		}
	}
}