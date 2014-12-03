package nl.teddevos.geometrywars.event.pacifism 
{
	import flash.geom.Point;
	import nl.teddevos.geometrywars.world.World;
	import nl.teddevos.geometrywars.util.MathHelper;
	import nl.teddevos.geometrywars.event.EventBase;
	
	public class EventPacifismStart extends EventBase
	{
		private var amount:int;
		
		public function EventPacifismStart(a:int) 
		{
			super("EventPacifismStart", 100);
			amount = a;
		}
		
		override public function start(world:World):void
		{
			if (world.enemies.len < 200)
			{
				var r:Point = getRandSpawn(world, 300);
				spawnBomb(world, r.x, r.y, 0, amount);
			}
			
			for (var i:int = world.enemies.explosionsLenght; i < 2; i++ )
			{
				var p:Point = getRandSpawn(world, 300);
				world.enemies.explosion(p.x, p.y);
			}
		}
	}
}