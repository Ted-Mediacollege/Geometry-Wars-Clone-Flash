package nl.teddevos.geometrywars.entity.enemy 
{
	import nl.teddevos.geometrywars.entity.EntityBase;
	import starling.display.Image;
	import starling.textures.Texture;
	import nl.teddevos.geometrywars.world.World;
	import flash.geom.Point;
	
	public class EntityEnemy implements EntityBase
	{
		private static var box:Point = new Point(20, 20);
		
		public var posX:Number;
		public var posY:Number;
		public var velX:Number;
		public var velY:Number;
		public var scaleable:Boolean = false;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var rotation:Number;
		public var spawning:int;
		public var collision:Boolean = true;
		
		public var id:int = 0;
		public var color:uint = 0xFFFFFF;
		
		public function EntityEnemy(x:Number, y:Number, vx:Number, vy:Number, r:Number, i:int, c:uint) 
		{
			posX = x;
			posY = y;
			velX = vx;
			velY = vy;
			rotation = r;
			spawning = -(8 * 3);
			
			id = i;
			color = c;
		}
		
		public function tick(world:World):void
		{
		}
				
		public function onDeath(world:World):void
		{
		}
		
		public function projectileCheck(px:Number, py:Number):void
		{
		}
		
		public function outOfScreenCheck():void
		{
			if 		(posX <= -(World.fieldWidth - box.x)) 	{ posX = -(World.fieldWidth - box.x);	velX = velX < 0 ? 0 : velX; }
			else if (posX >= World.fieldWidth - box.x) 		{ posX = World.fieldWidth - box.x;		velX = velX > 0 ? 0 : velX; }
			else if (posY <= -(World.fieldHeight - box.y))	{ posY = -(World.fieldHeight - box.y);	velY = velY < 0 ? 0 : velY; }
			else if (posY >= World.fieldHeight - box.y) 	{ posY = World.fieldHeight - box.y;		velY = velY > 0 ? 0 : velY; }
		}
		
		public function getBox():Point
		{
			return box;
		}
	}
}