package nl.teddevos.geometrywars.entity.projectile {
	import nl.teddevos.geometrywars.world.World;
	
	public class EntityProjectile 
	{
		public var posX:Number;
		public var posY:Number;
		public var velX:Number;
		public var velY:Number;
		public var rotation:Number;
		
		public function EntityProjectile(x:Number, y:Number, vx:Number, vy:Number, r:Number) 
		{
			posX = x;
			posY = y;
			velX = vx;
			velY = vy;
			rotation = r;
		}
		
		public function tick():int
		{
			posX += velX;
			posY += velY;
			
			if (posY + velY < -World.fieldHeight)
			{
				posY = -World.fieldHeight;
				return 90;
			}
			if (posY + velY > World.fieldHeight)
			{
				posY = World.fieldHeight;
				return -90;
			}
			if (posX + velX < -World.fieldWidth)
			{
				posX = -World.fieldWidth;
				return 0;
			}
			if (posX + velX > World.fieldWidth)
			{
				posX = World.fieldWidth;
				return 180;
			}
			
			return -91;
		}
	}
}