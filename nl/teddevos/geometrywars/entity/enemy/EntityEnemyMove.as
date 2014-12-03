package nl.teddevos.geometrywars.entity.enemy 
{
	import nl.teddevos.geometrywars.world.World;
	import flash.geom.Point;
	import nl.teddevos.geometrywars.util.MathHelper;
	
	public class EntityEnemyMove extends EntityEnemy
	{
		private static var box:Point = new Point(24, 24);
		
		public function EntityEnemyMove(x:Number, y:Number, vx:Number, vy:Number) 
		{
			super(x, y, vx, vy, 45, 4, 0x86FF6E);
		}
		
		override public function tick(world:World):void
		{
			rotation += 10 / 180 * Math.PI;
			var dir:Number = Math.atan2((world.player.y - posY), (world.player.x - posX));
			velX = (velX * 4 + Math.cos(dir) * 5) / 5;
			velY = (velY * 4 + Math.sin(dir) * 5) / 5;
		}
			
		override public function onDeath(world:World):void
		{		
			world.particleManager.createExplosion(posX, posY, 30, 0xCAFFBF, 1.2, 0.05, 0, 180, 0);
			world.particleManager.createExplosion(posX, posY, 25, 0x86FF6E, 0.2, 1.0, 0, 180, 0);
		}
		
		override public function projectileCheck(px:Number, py:Number):void
		{
			var dis:Number = (200 - MathHelper.dis2(posX, posY, px, py)) / 40;
			var dir:Number = MathHelper.pointToDegree(px, py, posX, posY);
			velX += Math.cos(dir / 180 * Math.PI) * dis;
			velY += Math.sin(dir / 180 * Math.PI) * dis;
		}
		
		override public function getBox():Point
		{
			return box;
		}
	}
}