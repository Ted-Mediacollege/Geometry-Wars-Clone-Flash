package nl.teddevos.geometrywars.entity 
{
	import nl.teddevos.geometrywars.world.World;
	import starling.display.Image;
	import nl.teddevos.geometrywars.graphics.AssetsList;
	import nl.teddevos.geometrywars.input.KeyInput;
	import flash.geom.Point
	import nl.teddevos.geometrywars.util.MathHelper;
	
	public class EntityPlayer extends Image implements EntityBase
	{
		private var box:Point = new Point(20, 20);
		
		public var rotationTarget:Number;
		public var rotationCurrent:Number;
		
		public var sprayR:Number;
		public var sprayV:Number;
		public var spraying:Boolean;
		
		public var inputDelay:int = 0;
		public var death:int = 0;
		
		public function EntityPlayer() 
		{
			super(AssetsList.assets.getTexture("player.png"));
			
			pivotX = width / 2;
			pivotY = height / 2;
			rotationTarget = -90;
			rotationCurrent = -90;
			rotation = -90;
			
			sprayR = 0;
			sprayV = 4;
			spraying = false;
		}
		
		public function tick(world:World):void
		{
			if (visible)
			{			
				var velX:Number = 0;
				var velY:Number = 0;
				
				if (KeyInput.W) { velY -= 12.5; }
				if (KeyInput.A) { velX -= 12.5; }
				if (KeyInput.S) { velY += 12.5; }
				if (KeyInput.D) { velX += 12.5; }
				
				if (x <= -(World.fieldWidth - box.x))
				{
					x = -(World.fieldWidth - box.x);
					velX = velX < 0 ? 0 : velX;
				}
				if (x >= World.fieldWidth - box.x)
				{
					x = World.fieldWidth - box.x;
					velX = velX > 0 ? 0 : velX;
				}
				if (y <= -(World.fieldHeight - box.y))
				{
					y = -(World.fieldHeight - box.y);
					velY = velY < 0 ? 0 : velY;
				}
				if (y >= World.fieldHeight - box.y)
				{
					y = World.fieldHeight - box.y;
					velY = velY > 0 ? 0 : velY;
				}
				
				if (velX != 0 && velY != 0)
				{
					velX = velX * 0.75;
					velY = velY * 0.75;
				}
				
				if (velX != 0 || velY != 0)
				{
					rotationTarget = Math.atan2(velY, velX) * 180 / Math.PI;
					
					if (rotationCurrent > 89 && rotationTarget < -89)
					{
						rotationCurrent -= 360;
					}
					if (rotationCurrent < -89 && rotationTarget > 89)
					{
						rotationCurrent += 360;
					}
				}
				
				rotationCurrent = (rotationTarget + rotationCurrent * 6) / 7;
				rotation = rotationCurrent / 180 * Math.PI;
				
				if (sprayR > 0)
				{
					sprayV -= 0.8;
				}
				else if(sprayR < 0)
				{
					sprayV += 0.8;
				}
				sprayR += sprayV;
				
				if ((velX != 0 || velY != 0) && !KeyInput.SPACE)
				{
					if (!spraying)
					{
						sprayR = 0;
						sprayV = 4;
						spraying = true;
					}
					
					world.particleManager.createExplosion(x, y, 1, 0xFF7429, 0.4, 0.1, rotationCurrent - 180 + sprayR, 1, 10);
					world.particleManager.createExplosion(x, y, 2, 0xFFBF29, 0.4, 0.1, rotationCurrent - 180, 4, 10);
					world.particleManager.createExplosion(x, y, 1, 0xFF7429, 0.4, 0.1, rotationCurrent - 180 - sprayR, 1, 10);
				}
				else
				{
					spraying = false;
				}
				
				var hl:int = world.enemies.blackholes.length, dis:Number = 0;
				for (var h:int = 0; h < hl; h++ )
				{
					if (Math.abs(world.enemies.blackholes[h].posX - x) < 300 &&  Math.abs(world.enemies.blackholes[h].posY - y) < 300)
					{
						dis = MathHelper.dis2(x, y, world.enemies.blackholes[h].posX, world.enemies.blackholes[h].posY);
						
						if (dis < 30)
						{
							onDeath(world);
							world.projectiles.onDeath(world);
							world.enemies.onDeath(world);
							world.lives--;
							return;
						}
						
						dis = dis - 300;
						dis = Math.pow(dis / 800, 2);
						velX += (world.enemies.blackholes[h].posX - x) * dis;
						velY += (world.enemies.blackholes[h].posY - y) * dis;
					}
				}
				
				x += velX;
				y += velY;
				
				inputDelay--;
				if (!KeyInput.SPACE && world.projectilesEnabled && (KeyInput.UP || KeyInput.DOWN || KeyInput.LEFT || KeyInput.RIGHT))
				{
					if (inputDelay < 0)
					{
						inputDelay = 3;
						world.projectiles.fire(world);
					}
				}
				else if(inputDelay < 0)
				{
					inputDelay = 0;
				}
				
				world.cameraX = (world.cameraX * 4 + (x / 1.6)) / 5;
				world.cameraY = (world.cameraY * 4 + (y / 1.6)) / 5;
			}
			else
			{
				death--;
				if (death == 0)
				{
					visible = true;
					inputDelay = 0;
					spraying = false;
				}
			}
		}
		
		public function onDeath(world:World):void
		{
			world.particleManager.createExplosion(x, y, 170, 0xFFFFFF, 2.4, 0.15, 0, 180, 0);
			world.particleManager.createExplosion(x, y, 600, 0xFFFFFF, 0.6, 1.8, 0, 180, 0);
			visible = false;
			death = 45;
			x = 0;
			y = 0;
		}
		
		public function getBox():Point
		{
			return box;
		}
	}
}