package nl.teddevos.geometrywars.entity.enemy 
{
	import nl.teddevos.geometrywars.world.World;
	import flash.geom.Point;
	
	public class EntityEnemySpin extends EntityEnemy
	{
		private static var box:Point = new Point(24, 24);
		
		public function EntityEnemySpin(x:Number, y:Number, vx:Number, vy:Number) 
		{
			super(x, y, vx, vy, 45, 1, 0xE7B3FF);
		}
		
		override public function tick(world:World):void
		{
			rotation += 10 / 180 * Math.PI;
			var dir:Number = Math.atan2((world.player.y - posY), (world.player.x - posX));
			velX = (velX * 4 + Math.cos(dir) * 6) / 5;
			velY = (velY * 4 + Math.sin(dir) * 6) / 5;
		}
			
		override public function onDeath(world:World):void
		{		
			world.particleManager.createExplosion(posX, posY, 30, 0xE7B3FF, 1.2, 0.05, 0, 180, 0);
			world.particleManager.createExplosion(posX, posY, 25, 0xCF66FF, 0.2, 1.0, 0, 180, 0);
		}
		
		override public function getBox():Point
		{
			return box;
		}
	}
}