package nl.teddevos.geometrywars.entity.enemy 
{
	import nl.teddevos.geometrywars.world.World;
	import flash.geom.Point;
	
	public class EntityEnemySquare extends EntityEnemy
	{
		private static var box:Point = new Point(26, 26);
		
		private var scaleR:Number;
		private var scaleV:Number;
		
		public function EntityEnemySquare(x:Number, y:Number, vx:Number, vy:Number) 
		{
			super(x, y, vx, vy, 0, 0, 0xCCFFFC);
			
			scaleR = 0;
			scaleV = 4;
			scaleable = true;
		}
		
		override public function tick(world:World):void
		{
			var dir:Number = Math.atan2((world.player.y - posY), (world.player.x - posX));
			velX = (velX * 4 + Math.cos(dir) * 6) / 5;
			velY = (velY * 4 + Math.sin(dir) * 6) / 5;
			
			if (scaleR > 0)
			{
				scaleV -= 0.4;
			}
			else if(scaleR < 0)
			{
				scaleV += 0.4;
			}
			scaleR += scaleV;
			
			scaleX = 1 + (scaleR / 256);
			scaleY = 1 - (scaleR / 256);
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