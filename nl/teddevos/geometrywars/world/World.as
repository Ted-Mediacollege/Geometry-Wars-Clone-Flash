package nl.teddevos.geometrywars.world 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import nl.teddevos.geometrywars.background.StarManager;
	import nl.teddevos.geometrywars.entity.enemy.EnemyEntities;
	import nl.teddevos.geometrywars.entity.enemy.EntityEnemy;
	import nl.teddevos.geometrywars.entity.EntityPlayer;
	import nl.teddevos.geometrywars.entity.projectile.ProjectileEntities;
	import nl.teddevos.geometrywars.event.evolved.easy.*;
	import nl.teddevos.geometrywars.event.evolved.*;
	import nl.teddevos.geometrywars.event.*;
	import nl.teddevos.geometrywars.event.evolved.normal.EventNormalDarts;
	import nl.teddevos.geometrywars.event.evolved.normal.EventNormalHoles;
	import nl.teddevos.geometrywars.event.evolved.normal.EventNormalRandom;
	import nl.teddevos.geometrywars.gamemode.GameMode;
	import nl.teddevos.geometrywars.particle.Particle;
	import nl.teddevos.geometrywars.particle.ParticleManager;
	import starling.display.Image;
	import starling.display.Sprite;
	import nl.teddevos.geometrywars.graphics.AssetsList;
	import starling.filters.BlurFilter;
	import nl.teddevos.geometrywars.input.KeyInput;
	import nl.teddevos.geometrywars.util.MathHelper;
	import starling.text.TextField;
	import nl.teddevos.geometrywars.data.Settings;
	
	public class World extends Sprite
	{
		public static var fieldWidth:int = 704;
		public static var fieldHeight:int = 448;
		
		public var cameraX:Number = 0;
		public var cameraY:Number = 0;
		
		public var fieldSprite:Sprite;
		private var starManager:StarManager;
		public var particleManager:ParticleManager;
		private var background_grid:Image;
		public var player:EntityPlayer;
		public var projectiles:ProjectileEntities;
		public var enemies:EnemyEntities;
		
		public var currentEvent:EventBase;
		public var level:int = 0;
		
		private var eventTestText:TextField;
		
		public var playing:Boolean = false;
		public var paused:Boolean = false;
		
		public var score:int;
		public var multiply:Number;
		public var lives:int;
		
		public var gamemode:GameMode;
		
		public var projectilesEnabled:Boolean;
		public var iconsEnabled:Boolean;
		
		public function World() 
		{
			this.touchable = false;

			fieldSprite = new Sprite();
			fieldSprite.clipRect = new Rectangle( -fieldWidth, -fieldHeight, fieldWidth * 2, fieldHeight * 2);
			addChild(fieldSprite);
			
			particleManager = new ParticleManager(new Particle(3, 3, 0xFFFFFF), 8000);
			fieldSprite.addChild(particleManager);
			
			playing = false;
			
			x = -640;
			y = -360;
		}
		
		public function build(g:GameMode):void
		{
			score = 0;
			multiply = 1;
			lives = 1;
			level = 0;
			
			iconsEnabled = false;
			projectilesEnabled = true;
			gamemode = g;
			gamemode.init();
			
			background_grid = new Image(AssetsList.assets.getTexture("background-full"));
			background_grid.pivotX = fieldWidth + 12;
			background_grid.pivotY = fieldHeight + 12;
			background_grid.touchable = false;
			addChildAt(background_grid, 0);
			
			if (Settings.STARS)
			{
				starManager = new StarManager(640, 384);
				addChild(starManager); 
			}
			
			eventTestText = new TextField(700, 200, "Debug info: \n Event: null, time: -1", "Arial", 40, 0xFFFFFF);
			eventTestText.x -= 350;
			eventTestText.y -= 100;
			//addChildAt(eventTestText, getChildIndex(fieldSprite) - 1);
			
			projectiles = new ProjectileEntities();
			fieldSprite.addChild(projectiles);
			
			enemies = new EnemyEntities();
			fieldSprite.addChild(enemies);
			
			player = new EntityPlayer();
			fieldSprite.addChild(player);
			
			currentEvent = gamemode.onNewEvent();
			currentEvent.start(this);
			
			playing = true;
		}
		
		public function destory():void
		{
			playing = false;
			currentEvent = null;
			
			removeChild(background_grid);
			background_grid = null;
			
			if (Settings.STARS)
			{
				removeChild(starManager); 
				starManager = null;
			}
			
			//removeChild(eventTestText);
			eventTestText = null;
			
			fieldSprite.removeChild(projectiles);
			projectiles = null;
			
			fieldSprite.removeChild(enemies);
			enemies = null;
			
			fieldSprite.removeChild(player);
			player = null;
			
			x = -640;
			y = -360;
			cameraX = 0;
			cameraY = 0;
		}
		
		public function addScore(a:int):void
		{
			multiply += 0.5;
			score += a * multiply;
		}
		
		public function resetParticles():void
		{
			fieldSprite.removeChild(particleManager);
			particleManager = new ParticleManager(new Particle(3, 3, 0xFFFFFF), Settings.PARTICLES * 2000);
			fieldSprite.addChild(particleManager);
		}
		
		public function tick():void
		{					
			x = -(cameraX - 640);
			y = -(cameraY - 360);
				
			if (playing && !paused)
			{
				var m:Number = new Date().time;				
				if (KeyInput.SPACE)
				{
					return;
				}
				
				player.tick(this);
				
				currentEvent.tick(this);
				currentEvent.time--;
				if (currentEvent.time < 0)
				{
					if (enemies.enemies.length < currentEvent.maxEntities)
					{
						level++;
						currentEvent = gamemode.onNewEvent();
						currentEvent.start(this);
					}
				}
				eventTestText.text = "Debug info: \n Event: " + currentEvent.eventName + " time: " + currentEvent.time + " \n eventLevel: " + level;
				
				if (Settings.STARS)
				{
					starManager.cameraX = cameraX;
					starManager.cameraY = cameraY;
				}
				
				projectiles.tick(this);

				var j:int = 0, deleted:Boolean = false, dis:Number = 0, h:int = 0, hl:int = enemies.blackholes.length, l:int = projectiles.projectiles.length;
				for (var i:int = enemies.enemies.length - 1; i > -1; i-- )
				{
					deleted = false;
					
					if (Math.abs(player.x - enemies.enemies[i].posX) < 30 && Math.abs(player.y - enemies.enemies[i].posY) < 30)
					{
						player.onDeath(this);
						projectiles.onDeath(this);
						enemies.onDeath(this);
						lives--;
						gamemode.onDeath();
						return;
					}
					else
					{
						for (h = 0; h < hl; h++ )
						{
							if (Math.abs(enemies.blackholes[h].posX - enemies.enemies[i].posX) < 300 &&  Math.abs(enemies.blackholes[h].posY - enemies.enemies[i].posY) < 300)
							{
								dis = MathHelper.dis2(enemies.enemies[i].posX, enemies.enemies[i].posY, enemies.blackholes[h].posX, enemies.blackholes[h].posY);
								
								if (dis < 40)
								{
									deleted = true;
									enemies.blackholes[h].full++;
									particleManager.createExplosion(enemies.blackholes[h].posX, enemies.blackholes[h].posY, 160, 0xFFFFFF, 2.1, 0.25, 0, 180, 6);
									particleManager.createExplosion(enemies.blackholes[h].posX, enemies.blackholes[h].posY, 80, enemies.enemies[i].color, 1.0, 0.8, 0, 180, 6);
									enemies.enemies.splice(i, 1);
									enemies.len--;
									break;
								}
								else
								{
									dis = dis - 300;
									dis = Math.pow(dis / 800, 2);
									enemies.enemies[i].velX += (enemies.blackholes[h].posX - enemies.enemies[i].posX) * dis;
									enemies.enemies[i].velY += (enemies.blackholes[h].posY - enemies.enemies[i].posY) * dis;
								}
							}
						}
						
						if (!deleted && projectilesEnabled)
						{
							for (j = 0; j < l; j++ )
							{
								if (Math.abs(projectiles.projectiles[j].posX - enemies.enemies[i].posX) < 150 && Math.abs(projectiles.projectiles[j].posY - enemies.enemies[i].posY) < 150)
								{
									enemies.enemies[i].projectileCheck(projectiles.projectiles[j].posX, projectiles.projectiles[j].posY);
									if (Math.abs(projectiles.projectiles[j].posX - enemies.enemies[i].posX) < enemies.enemies[i].getBox().x && Math.abs(projectiles.projectiles[j].posY - enemies.enemies[i].posY) < enemies.enemies[i].getBox().y)
									{
										addScore(1);
										enemies.enemies[i].onDeath(this);
										projectiles.len--;
										enemies.len--;
										projectiles.projectiles.splice(j, 1);
										enemies.enemies.splice(i, 1);
										l--;
										break;
									}
								}
							}
						}
					}
				}
				
				enemies.tick(this);
				
				l = enemies.explosions.length;
				for (j = l - 1; j > -1; j-- )
				{
					switch(enemies.explosions[j].checkDis(player.x, player.y))
					{
						case 1: enemies.eat(this, player.x, player.y, 300); enemies.explosions[j].onDeath(this); enemies.explosions.splice(j, 1); break;
						case 2: player.onDeath(this); projectiles.onDeath(this); enemies.onDeath(this); lives--; gamemode.onDeath(); return;
					}
				}
				//trace(((new Date().time) - m) + " enemies: " + enemies.len);
			}
		}
	}
}