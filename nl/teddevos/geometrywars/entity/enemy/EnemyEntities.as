package nl.teddevos.geometrywars.entity.enemy 
{
	import flash.geom.Point;
	import nl.teddevos.geometrywars.world.World;
	import starling.display.QuadBatch;
	import starling.filters.BlurFilter;
	import starling.display.Image;
	import nl.teddevos.geometrywars.graphics.AssetsList;
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	import nl.teddevos.geometrywars.util.MathHelper;

	public class EnemyEntities extends QuadBatch
	{
		public var blackholes:Vector.<EntityBlackHole>;
		private var holeImg:Image;
		
		public var explosions:Vector.<EntityExplosion>;
		private var explosionImg:Image;
		public var explosionsLenght:int;
		
		public var enemies:Vector.<EntityEnemy>;
		public var len:int;
		private var imgList:Vector.<Image>;
		
		private var checkPoint:int;
		
		public function EnemyEntities() 
		{
			super();
			
			enemies = new Vector.<EntityEnemy>();
			blackholes = new Vector.<EntityBlackHole>();
			explosions = new Vector.<EntityExplosion>();
			
			var textureNames:Vector.<String> = new <String>["enemy_rectangle.png",	"enemy_spin.png",	"enemy_splitter.png",	"enemy_splittermini.png",	"enemy_move.png",	"enemy_circle.png",	"enemy_dart.png"];
			var textureColors:Vector.<uint> = new <uint>[	0x30F8FF, 				0xCF66FF, 			0xD875FF,				0xD875FF,					0x32FF6C,			0x30F8FF,			0xFF5252];
			var l:int = textureNames.length;
			imgList = new Vector.<Image>();
			
			for (var i:int = 0; i < l; i++ )
			{
				var img:Image = new Image(AssetsList.assets.getTexture(textureNames[i]));
				img.pivotX = img.width / 2;
				img.pivotY = img.height / 2;
				img.color = textureColors[i];
				imgList.push(img);
			}
			
			holeImg = new Image(AssetsList.assets.getTexture("blackhole.png"));
			holeImg.pivotX = holeImg.width / 2;
			holeImg.pivotY = holeImg.height / 2;
			holeImg.color = 0xFF4545;
			
			explosionImg = new Image(AssetsList.assets.getTexture("explosion.png"));
			explosionImg.pivotX = explosionImg.width / 2;
			explosionImg.pivotY = explosionImg.height / 2;
		}
		
		public function blackhole(px:Number, py:Number):void
		{
			blackholes.push(new EntityBlackHole(px, py));
		}
		
		public function explosion(px:Number, py:Number):void
		{
			explosions.push(new EntityExplosion(px, py));
		}
		
		public function dart(px:Number, py:Number, dir:int):void
		{
			enemies.push(new EntityEnemyDart(px, py, dir)); 
			len++;
		}
		
		public function spawnPoint(id:int, p:Point):void
		{
			spawnXY(id, p.x, p.y);
		}
		
		public function spawnXY(id:int, px:Number, py:Number):void
		{
			switch(id)
			{
				case 0: enemies.push(new EntityEnemySquare(px, py, 0, 0)); len++; return;
				case 1: enemies.push(new EntityEnemySpin(px, py, 0, 0)); len++; return;
				case 2: enemies.push(new EntityEnemySplit(px, py, 0, 0)); len++; return;
				case 3: enemies.push(new EntityEnemyMove(px, py, 0, 0)); len++; return;
				case 10: enemies.push(new EntityEnemySplitMini(px, py, 0, 0)); len++; return;
				case 11: enemies.push(new EntityEnemyCircle(px, py, 0, 0)); len++; return;
			}
		}
		
		public function tick(world:World):void
		{
			reset();
			
			var j:int = 0;
			var i:int = 0;
			var mX:Number = 0, mY:Number = 0;
			var e:EntityEnemy;
			var img:Image;
			
			var colCheckBegin:int = checkPoint;
			checkPoint += 50;
			var colCheckEnd:int = checkPoint;
			if (checkPoint >= len)
			{
				colCheckEnd = len;
				checkPoint = 0;
			}
			
			for (i = len - 1; i > -1; i--)
			{
				e = enemies[i];
				img = imgList[e.id];
				
				if (e.spawning == 0)
				{
					e.tick(world);
					if (e.collision)
					{
						for (j = colCheckBegin; j < colCheckEnd; j++ )
						{
							if(i != j && enemies[j].collision && getDist2(e.posX, e.posY, enemies[j].posX, enemies[j].posY) < 40)//Math.abs(e.posX - enemies[j].posX) < 40 && Math.abs(e.posY - enemies[j].posY) < 40)
							//if (i != j && getDist2(e.posX, e.posY, enemies[j].posX, enemies[j].posY) < 40)
							{
								if (Math.abs(e.posX - enemies[j].posX) < 40)//getDist1(e.posX, enemies[j].posX))
								{
									mX = (e.posX - enemies[j].posX) / 20;
									e.velX += mX;
									enemies[j].velX -= mX;
								}
								if (Math.abs(e.posY - enemies[j].posY) < 40)//getDist1(e.posY, enemies[j].posY))
								{
									mY = (e.posY - enemies[j].posY) / 20; 
									e.velY += mY;
									enemies[j].velY -= mY;
								}
							}
						}
					}
				}
				
				e.outOfScreenCheck();
				
				if (e.spawning < 0)
				{
					e.spawning++;
					img.rotation = e.rotation;
					img.x = e.posX;
					img.y = e.posY;
					
					img.scaleX = 2.0 + ((e.spawning % 5) / 5);
					img.scaleY = 2.0 + ((e.spawning % 5) / 5);
					addImage(img);
					
					img.scaleX = 1.0 + ((e.spawning % 5) / 5);
					img.scaleY = 1.0 + ((e.spawning % 5) / 5);
					addImage(img);
				}
				else
				{
					img.x = e.posX += e.velX;
					img.y = e.posY += e.velY;
					img.scaleX = e.scaleX;
					img.scaleY = e.scaleY;
					img.rotation = e.rotation;
					addImage(img);
				}
			}
			
			i = blackholes.length - 1;
			for (j = i; j > -1; j--)
			{
				if (blackholes[j].full > 14 || blackholes[j].health > 14)
				{
					blackholes[j].onDeath(world);
					blackholes.splice(j, 1);
				}
				else
				{
					blackholes[j].tick(world);
					holeImg.x = blackholes[j].posX;
					holeImg.y = blackholes[j].posY;
					holeImg.scaleX = blackholes[j].scaleX;
					holeImg.scaleY = blackholes[j].scaleY;
					addImage(holeImg);
				}
			}
			
			explosionsLenght = explosions.length - 1;
			for (j = explosionsLenght; j > -1; j--)
			{
				explosions[j].tick(world);
				explosionImg.x = explosions[j].posX;
				explosionImg.y = explosions[j].posY;
				explosionImg.rotation = explosions[j].rotation;
				addImage(explosionImg);
			}
		}
		
		public function eat(world:World, px:Number, py:Number, radius:Number, score:Boolean = true):void
		{
			for (var i:int = len - 1; i > -1; i--)
			{
				if (MathHelper.dis2(enemies[i].posX, enemies[i].posY, px, py) < radius)
				{
					if (score)
					{
						world.addScore(1);
					}
					enemies[i].onDeath(world);
					enemies.splice(i, 1);
					len--;
				}
			}
		}
		
		public function getDist1(x1:Number, x2:Number):Number
		{
			return Math.abs(x1 - x2);
		}
		
		public function getDist2(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			return Math.abs(x1 - x2) + Math.abs(y1 - y2);
		}
		
		public function onDeath(world:World):void
		{
			reset();
			for (var i:int = blackholes.length - 1; i > -1; i-- )
			{
				blackholes[i].onDeath(world);
			}
			for (var k:int = explosions.length - 1; k > -1; k-- )
			{
				explosions[k].onDeath(world);
			}
			for (var j:int = 0; j < len; j++ )
			{
				enemies[j].onDeath(world);
			}
			enemies = new Vector.<EntityEnemy>();
			blackholes = new Vector.<EntityBlackHole>();
			explosions = new Vector.<EntityExplosion>();
			len = 0;
		}
		
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
        {
            return new Rectangle(0,0,0,0);
        }
	}
}