package nl.teddevos.geometrywars.entity.enemy 
{
	import nl.teddevos.geometrywars.entity.EntityBase;
	import starling.display.Image;
	import starling.textures.Texture;
	import nl.teddevos.geometrywars.world.World;
	import flash.geom.Point;
	import nl.teddevos.geometrywars.util.MathHelper;
	
	public class EntityExplosion implements EntityBase
	{
		private static var box:Point = new Point(60, 60);
		
		public var posX:Number;
		public var posY:Number;
		private var rot:Number;
		public var rotation:Number;
		
		public var left:Point;
		public var right:Point;
		
		public function EntityExplosion(x:Number, y:Number) 
		{
			posX = x;
			posY = y;
			rot = Math.random() * 360;
			rotation = rot / 180 * Math.PI;
			
			left = new Point(-100, 0);
			right = new Point(100, 0);
			
			left.x = Math.cos(rotation + Math.PI) * 100;
			left.y = Math.sin(rotation + Math.PI) * 100;
			right.x = Math.cos(rotation) * 100;
			right.y = Math.sin(rotation) * 100;
			
			if (posX < -(World.fieldWidth - 125))
			{
				posX = -(World.fieldWidth - 125);
			}
			if (posY < -(World.fieldHeight - 125))
			{
				posY = -(World.fieldHeight - 125);
			}
			if (posX > World.fieldWidth - 125)
			{
				posX = World.fieldWidth - 125;
			}
			if (posY > World.fieldHeight - 125)
			{
				posY = World.fieldHeight - 125;
			}
		}
		
		public function checkDis(px:Number, py:Number):int
		{
			var d1:Number = MathHelper.dis2(posX + left.x, posY + left.y, px, py);
			var d2:Number = MathHelper.dis2(posX + right.x, posY + right.y, px, py);
			
			if (d1 < 30 || d2 < 30)
			{
				return 2;
			}
			if (d1 + d2 < 210)
			{
				return 1;
			}
			return 0;
		}
		
		public function tick(world:World):void
		{
			rot += 0.8;
			if (rot > 360)
			{
				rot -= 360;
			}
				
			rotation = rot / 180 * Math.PI;
			
			left.x = Math.cos(rotation + Math.PI) * 100;
			left.y = Math.sin(rotation + Math.PI) * 100;
			right.x = Math.cos(rotation) * 100;
			right.y = Math.sin(rotation) * 100;
		}
		
		public function onDeath(world:World):void
		{
			world.particleManager.createExplosion(posX, posY, 80, 0xFFFFFF, 1.9, 0.05, 0, 180, 0);
			world.particleManager.createExplosion(posX, posY, 45, 0xFFFFFF, 0.9, 1.0, 0, 180, 0);
		}
		
		public function getBox():Point
		{
			return box;
		}
	}
}