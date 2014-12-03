package nl.teddevos.geometrywars.entity.enemy 
{
	import nl.teddevos.geometrywars.world.World;
	import flash.geom.Point;
	
	public class EntityEnemyCircle extends EntityEnemy
	{
		private static var box:Point = new Point(20, 20);
		
		public function EntityEnemyCircle(x:Number, y:Number, vx:Number, vy:Number) 
		{
			super(x, y, vx, vy, 0, 5, 0xCCFFFC);
			spawning = 0;
		}
		
		override public function tick(world:World):void
		{
			var dir:Number = Math.atan2((world.player.y - posY), (world.player.x - posX));
			velX = (velX * 4 + Math.cos(dir) * 5) / 5;
			velY = (velY * 4 + Math.sin(dir) * 5) / 5;
		}
			
		override public function onDeath(world:World):void
		{		
			world.particleManager.createExplosion(posX, posY, 30, 0xCCFFFC, 1.2, 0.05, 0, 180, 0);
			world.particleManager.createExplosion(posX, posY, 25, 0x8DFCF5, 0.2, 1.0, 0, 180, 0);
		}
		
		override public function getBox():Point
		{
			return box;
		}
	}
}