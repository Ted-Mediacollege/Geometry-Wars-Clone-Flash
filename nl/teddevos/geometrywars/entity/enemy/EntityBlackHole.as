package nl.teddevos.geometrywars.entity.enemy 
{
	import nl.teddevos.geometrywars.entity.EntityBase;
	import starling.display.Image;
	import starling.textures.Texture;
	import nl.teddevos.geometrywars.world.World;
	import flash.geom.Point;
	
	public class EntityBlackHole implements EntityBase
	{
		private static var box:Point = new Point(60, 60);
		private static var randomColor:Vector.<uint> = new <uint>[0xFFFFFF, 0xCCFFFC, 0xD2FFC9, 0xF2D863];
		
		public var posX:Number;
		public var posY:Number;
		public var color:uint = 0xFFFFFF;
		
		public var full:int = 0;
		public var health:int = 0;
		
		private var scaleR:Number;
		private var scaleV:Number;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		
		public function EntityBlackHole(x:Number, y:Number) 
		{
			posX = x;
			posY = y;
			color = 0xFF4545;
			
			scaleR = 0;
			scaleV = 4;
		}
		
		public function tick(world:World):void
		{
			world.particleManager.createExplosion(posX, posY, 10, 0xFFFFFF, 0.7, 0, 0, 180, 34);			
			
			if (scaleR > 0)
			{
				scaleV -= 1.2;
			}
			else if(scaleR < 0)
			{
				scaleV += 1.2;
			}
			scaleR += scaleV;
			
			scaleX = 1 + (scaleR / 180);
			scaleY = 1 + (scaleR / 180);
		}
		
		public function onDeath(world:World):void
		{
			world.particleManager.createExplosion(posX, posY, 160, 0xFFFFFF, 2.2, 0.25, 0, 180, 6);
			world.particleManager.createExplosion(posX, posY, 160, 0xCCFFFC, 2.0, 0.25, 0, 180, 6);
			world.particleManager.createExplosion(posX, posY, 160, 0xD2FFC9, 1.8, 0.25, 0, 180, 6);
			world.particleManager.createExplosion(posX, posY, 160, 0xF2D863, 1.2, 0.55, 0, 180, 6);
			
			world.particleManager.createExplosion(posX, posY, 80, 0xFFFFFF, 0.5, 0.8, 0, 180, 6);
			world.particleManager.createExplosion(posX, posY, 80, 0xCCFFFC, 0.5, 0.8, 0, 180, 6);
			world.particleManager.createExplosion(posX, posY, 80, 0xF2D863, 0.5, 0.8, 0, 180, 6);

			world.particleManager.createExplosion(posX, posY, 60, 0xFF4545, 0.25, 0.1, 0, 180, 115);
			
			var l:int = int(full * 1.5);
			for (var i:int = 0; i < l; i++ )
			{
				world.enemies.spawnXY(11, posX - 10 + (Math.random() * 20), posY - 10 + (Math.random() * 20));
			}
		}
		
		public function randomExplosion(world:World):void
		{
			var c:uint = randomColor[int(Math.random() * 4)];
			world.particleManager.createExplosion(posX, posY, 40, 0xFFFFFF, 1.0, 0.5, 0, 180, 6);
			world.particleManager.createExplosion(posX, posY, 40, c, 1.0, 0.5, 0, 180, 6);
		}
		
		public function getBox():Point
		{
			return box;
		}
	}
}