package nl.teddevos.geometrywars.entity.enemy 
{
	import nl.teddevos.geometrywars.world.World;
	import flash.geom.Point;
	
	public class EntityEnemySplitMini extends EntityEnemy
	{
		private static var box:Point = new Point(21, 21);
		
		private var randomRotation:Number;
		
		public function EntityEnemySplitMini(x:Number, y:Number, vx:Number, vy:Number) 
		{
			super(x, y, vx, vy, 0, 3, 0xEEC4FF);
			spawning = 0;
			
			randomRotation = -180 + (Math.random() * 360);
		}
		
		override public function tick(world:World):void
		{
			var dir:Number = Math.atan2((world.player.y - posY), (world.player.x - posX));
			velX = (velX * 4 + Math.cos(dir) * 4.0) / 5;
			velY = (velY * 4 + Math.sin(dir) * 4.0) / 5;
			
			randomRotation += 10;
			velX += Math.cos(randomRotation / 180 * Math.PI) * 1.2;
			velY += Math.sin(randomRotation / 180 * Math.PI) * 1.2; 
			rotation += randomRotation / 180 * Math.PI;
		}
			
		override public function onDeath(world:World):void
		{		
			world.particleManager.createExplosion(posX, posY, 30, 0xEEC4FF, 1.2, 0.05, 0, 180, 0);
			world.particleManager.createExplosion(posX, posY, 25, 0xE39CFF, 0.2, 1.0, 0, 180, 0);
		}
		
		override public function getBox():Point
		{
			return box;
		}
	}
}