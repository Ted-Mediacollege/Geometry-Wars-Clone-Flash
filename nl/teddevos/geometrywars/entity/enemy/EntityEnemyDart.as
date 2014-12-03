package nl.teddevos.geometrywars.entity.enemy 
{
	import nl.teddevos.geometrywars.world.World;
	import flash.geom.Point;
	import nl.teddevos.geometrywars.util.MathHelper;
	
	public class EntityEnemyDart extends EntityEnemy
	{
		private static var box:Point = new Point(26, 26);
		
		private var dir:int;
		private var dirX:Number;
		private var dirY:Number;

		public function EntityEnemyDart(x:Number, y:Number, d:int) 
		{
			super(x, y, 0, 0, 0, 6, 0xFF5252);
			dirX = d == 1 ? -11 : d == 3 ? 11 : 0;
			dirY = d == 0 ? 11 : d == 2 ? -11 : 0;
			spawning = -(8 * 8);
			collision = false;
			
			dir = d;
			rotation = MathHelper.pointToDegree(0, 0, dirX, dirY) / 180 * Math.PI;
		}
		
		override public function tick(world:World):void
		{
			velX = dirX;
			velY = dirY;
			
			if (dir == 0 && posY > World.fieldHeight - 60)
			{
				dirY = -dirY;
				dir = 2;
				rotation = MathHelper.pointToDegree(0, 0, dirX, dirY) / 180 * Math.PI;
			}
			else if (dir == 1 && posX < -(World.fieldWidth - 60))
			{
				dirX = -dirX;
				dir = 3;
				rotation = MathHelper.pointToDegree(0, 0, dirX, dirY) / 180 * Math.PI;
			}
			else if (dir == 2 && posY < -(World.fieldHeight - 60))
			{
				dirY = -dirY;
				dir = 0;
				rotation = MathHelper.pointToDegree(0, 0, dirX, dirY) / 180 * Math.PI;
			}
			else if (dir == 3 && posX > World.fieldWidth - 60)
			{
				dirX = -dirX;
				dir = 1;
				rotation = MathHelper.pointToDegree(0, 0, dirX, dirY) / 180 * Math.PI;
			}
			
			world.particleManager.createExplosion(posX + Math.random() * 5, posY + Math.random() * 5, 2, 0xFF9C9C, 0.35, 0.02, (rotation * 180 / Math.PI) - 180, 2, Math.random() * 10);
		}
			
		override public function onDeath(world:World):void
		{		
			world.particleManager.createExplosion(posX, posY, 25, 0xFFD1D1, 1.2, 0.05, 0, 180, 0);
			world.particleManager.createExplosion(posX, posY, 20, 0xFF9C9C, 0.2, 1.0, 0, 180, 0);
		}
		
		override public function getBox():Point
		{
			return box;
		}
	}
}