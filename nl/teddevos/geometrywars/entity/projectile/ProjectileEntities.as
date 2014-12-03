package nl.teddevos.geometrywars.entity.projectile 
{
	import nl.teddevos.geometrywars.world.World;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import nl.teddevos.geometrywars.graphics.AssetsList;
	import starling.filters.BlurFilter;
	import nl.teddevos.geometrywars.input.KeyInput;
	import nl.teddevos.geometrywars.util.MathHelper;
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	
	public class ProjectileEntities extends QuadBatch
	{
		public var projectiles:Vector.<EntityProjectile>;
		public var len:int;
		private var img:Image;
		
		public function ProjectileEntities() 
		{
			super();
			
			projectiles = new Vector.<EntityProjectile>();
			len = 0;
			
			img = new Image(AssetsList.assets.getTexture("bullet.png"));
			img.pivotX = img.width;
			img.pivotY = img.height / 2;
			img.color = 0xFFDE3D;
		}
		
		public function fire(world:World):void
		{
			var dirX:Number = 0;
			var dirY:Number = 0;
			
			if (KeyInput.UP) { dirY -= 1; }
			if (KeyInput.LEFT) { dirX -= 1; }
			if (KeyInput.DOWN) { dirY += 1; }
			if (KeyInput.RIGHT) { dirX += 1; }
			
			if (dirX != 0 || dirY != 0)
			{
				var dir:Number = Math.atan2(dirY, dirX) * 180 / Math.PI;
				
				projectiles.push(new EntityProjectile(
					world.player.x + Math.cos((dir - 90) * Math.PI / 180.0) * 12, 
					world.player.y + Math.sin((dir - 90) * Math.PI / 180.0) * 12, 
					Math.cos(dir * Math.PI / 180.0) * 15, 
					Math.sin(dir * Math.PI / 180.0) * 15, 
					dir * Math.PI / 180
				));
				
				projectiles.push(new EntityProjectile(
					world.player.x + Math.cos((dir + 90) * Math.PI / 180.0) * 12, 
					world.player.y + Math.sin((dir + 90) * Math.PI / 180.0) * 12, 
					Math.cos(dir * Math.PI / 180.0) * 15, 
					Math.sin(dir * Math.PI / 180.0) * 15, 
					dir * Math.PI / 180
				));
				len += 2;
				
				/*
				var dir:Number = Math.atan2(dirY, dirX) * 180 / Math.PI;
				
				projectiles.push(new EntityProjectile(
					world.player.x + Math.cos((dir - 90) * Math.PI / 180.0) * 12, 
					world.player.y + Math.sin((dir - 90) * Math.PI / 180.0) * 12, 
					Math.cos((dir - 5) * Math.PI / 180.0) * 15, 
					Math.sin((dir - 5) * Math.PI / 180.0) * 15, 
					dir * Math.PI / 180
				));
				
				projectiles.push(new EntityProjectile(
					world.player.x, 
					world.player.y, 
					Math.cos(dir * Math.PI / 180.0) * 15, 
					Math.sin(dir * Math.PI / 180.0) * 15, 
					dir * Math.PI / 180
				));
				
				projectiles.push(new EntityProjectile(
					world.player.x + Math.cos((dir + 90) * Math.PI / 180.0) * 12, 
					world.player.y + Math.sin((dir + 90) * Math.PI / 180.0) * 12, 
					Math.cos((dir + 5) * Math.PI / 180.0) * 15, 
					Math.sin((dir + 5) * Math.PI / 180.0) * 15, 
					dir * Math.PI / 180
				));
				len+=3; 
				*/
			}
		}
		
		public function tick(world:World):void
		{
			reset();
			
			var col:int = 0;
			
			var h:int = 0, hl:int = world.enemies.blackholes.length, dis:Number = 0;
			for (var i:int = len - 1; i > -1; i--)
			{
 				col = projectiles[i].tick();
				if (col > -91)
				{
					world.particleManager.createExplosion(projectiles[i].posX, projectiles[i].posY, 20, 0xF2D863, 0.1, 0.5, col, 90, 0);
					projectiles.splice(i, 1);
					len--;
				}
				else
				{
					img.x = projectiles[i].posX += projectiles[i].velX;
					img.y = projectiles[i].posY += projectiles[i].velY;
					img.rotation = projectiles[i].rotation;
					addImage(img);
					
					for (h = 0; h < hl; h++ )
					{
						if (Math.abs(world.enemies.blackholes[h].posX - projectiles[i].posX) < 300 &&  Math.abs(world.enemies.blackholes[h].posY - projectiles[i].posY) < 300)
						{
							dis = MathHelper.dis2(projectiles[i].posX, projectiles[i].posY, world.enemies.blackholes[h].posX, world.enemies.blackholes[h].posY);
							
							if (dis < 40)
							{
								world.enemies.blackholes[h].health++;
								world.enemies.blackholes[h].randomExplosion(world);
								projectiles.splice(i, 1);
								len--;
								break;
							}
							else
							{
								if (dis < 150)
								{
									projectiles[i].rotation = MathHelper.pointToDegree(0, 0, projectiles[i].velX, projectiles[i].velY) / 180 * Math.PI;
								}
								
								dis = dis - 300;
								dis = Math.pow(dis / 1800, 2);
								projectiles[i].velX -= (world.enemies.blackholes[h].posX - projectiles[i].posX) * dis;
								projectiles[i].velY -= (world.enemies.blackholes[h].posY - projectiles[i].posY) * dis;
							}
						}
					}
				}
			}
		}
		
		public function onDeath(world:World):void
		{
			for (var i:int = len - 1; i > -1; i--)
			{
				world.particleManager.createExplosion(projectiles[i].posX, projectiles[i].posY, 20, 0xF2D863, 0.8, 0.5, 0, 180, 0);
			}
			
			projectiles = new Vector.<EntityProjectile>();
			len = 0;
		}
		
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
        {
            return new Rectangle(0,0,0,0);
        }
	}
}