package nl.teddevos.geometrywars.event 
{
	import nl.teddevos.geometrywars.world.World;
	import flash.geom.Point;
	import nl.teddevos.geometrywars.util.MathHelper;
	
	public class EventBase 
	{
		public var eventName:String;
		public var time:int = 0;
		public var maxEntities:int = 0;
		
		public function EventBase(n:String, t:int = 100, max:int = 999) 
		{
			eventName = n;
			time = t;
			maxEntities = max;
		}
		
		public function start(world:World):void
		{
			
		}
		
		public function tick(world:World):void
		{
			
		}
		
		public function getRandSpawn(world:World, width:int = 250):Point
		{
			var px:Number, py:Number, save:int;
			while (save < 100)
			{
				save++;
				px = (Math.random() * World.fieldWidth * 2) - World.fieldWidth;
				py = (Math.random() * World.fieldHeight * 2) - World.fieldHeight; 
				
				if (Math.abs(world.player.x - px) > width &&  Math.abs(world.player.y - py) > width)
				{
					return new Point(px, py);
				}
			}
			
			return new Point(0, 0);
		}
		
		public function getCorner(id:int = 0, randX:Number = 0, randY:Number = 0):Point
		{
			return new Point(id % 2 == 0 ? -(World.fieldWidth - 40 + randX) : World.fieldWidth - 40 + randX, id < 2 ? -(World.fieldHeight - 40 + randY) : World.fieldHeight - 40 + randY);
		}
		
		public function getRandCorner(world:World):Point
		{
			var px:Number, py:Number, save:int;
			while (save < 20)
			{
				save++;
				px = -(World.fieldWidth - 200) + (MathHelper.nextInt(2) == 0 ? World.fieldWidth * 2 - 400 : 0)
				py = -(World.fieldHeight - 200) + (MathHelper.nextInt(2) == 0 ? World.fieldHeight * 2 - 400 : 0)
				
				if (Math.abs(world.player.x - px) > 200 &&  Math.abs(world.player.y - py) > 200)
				{
					return new Point(px, py);
				}
			}
			
			return new Point(-1000, 0);
		}
		
		public function isHoleNear(world:World, x:Number, y:Number, width:int = 300):Boolean
		{
			var h:int = world.enemies.blackholes.length;
			for (var i:int = 0; i < h; i++ )
			{
				if (Math.abs(world.enemies.blackholes[i].posX - x) < width && Math.abs(world.enemies.blackholes[i].posY - y) < width)
				{
					return true;
				}
			}
			return false;
		}
		
		public function spawnBomb(world:World, x:Number, y:Number, id:int, amount:int):void
		{
			var r:Number = -180 + Math.random() * 360, w:Number = 0;
			for (var i:int = 0; i < amount; i++ )
			{
				r += Math.random() * 50;
				w+=3;
				world.enemies.spawnXY(id, x + Math.cos(r / 180 * Math.PI) * w, y + Math.sin(r / 180 * Math.PI) * w);
			}
		}
		
		public function spawnRing(world:World, id:int, width:Number, randWidth:Number, amount:int):void
		{
			var r:Number = -180 + Math.random() * 360, rand:Number = 0;
			for (var i:int = 0; i < amount; i++ )
			{
				r += Math.random() * 50;
				rand = width + randWidth * Math.random();
				world.enemies.spawnXY(id, world.player.x + Math.cos(r / 180 * Math.PI) * rand, world.player.y + Math.sin(r / 180 * Math.PI) * rand);
			}
		}
	}
}