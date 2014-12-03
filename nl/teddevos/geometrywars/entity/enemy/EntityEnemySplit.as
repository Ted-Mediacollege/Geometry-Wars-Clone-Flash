package nl.teddevos.geometrywars.entity.enemy 
{
	import nl.teddevos.geometrywars.world.World;
	import flash.geom.Point;
	
	public class EntityEnemySplit extends EntityEnemy
	{
		private static var box:Point = new Point(26, 26);
		
		private var rotateR:Number;
		private var rotateV:Number;
		
		public function EntityEnemySplit(x:Number, y:Number, vx:Number, vy:Number) 
		{
			super(x, y, vx, vy, 0, 2, 0xEEC4FF);
			
			rotateR = -2;
			rotateV = 5;
		}
		
		override public function tick(world:World):void
		{
			var dir:Number = Math.atan2((world.player.y - posY), (world.player.x - posX));
			velX = (velX * 4 + Math.cos(dir) * 5) / 5;
			velY = (velY * 4 + Math.sin(dir) * 5) / 5;
			
			if (rotateR > 0)
			{
				rotateV -= 0.5;
			}
			else if(rotateR < 0)
			{
				rotateV += 0.5;
			}
			rotateR += rotateV;
			rotation += (rotateR / 5) / 180 * Math.PI;
		}
			
		override public function onDeath(world:World):void
		{		
			world.enemies.spawnXY(10, posX, posY);
			world.enemies.spawnXY(10, posX, posY);
			world.particleManager.createExplosion(posX, posY, 30, 0xEEC4FF, 1.2, 0.05, 0, 180, 0);
			world.particleManager.createExplosion(posX, posY, 25, 0xE39CFF, 0.2, 1.0, 0, 180, 0);
		}
		
		override public function getBox():Point
		{
			return box;
		}
	}
}