package nl.teddevos.geometrywars.gui.screens 
{
	import flash.geom.Rectangle;
	import nl.teddevos.geometrywars.gamemode.GameMode;
	import nl.teddevos.geometrywars.gamemode.GameModeEvolved;
	import nl.teddevos.geometrywars.gamemode.GameModeKing;
	import nl.teddevos.geometrywars.gamemode.GameModePacifism;
	import nl.teddevos.geometrywars.gamemode.GameModeWaves;
	import nl.teddevos.geometrywars.gui.components.GuiButton;
	import nl.teddevos.geometrywars.gui.components.GuiButtonMoving;
	import nl.teddevos.geometrywars.gui.GuiScreen;
	import nl.teddevos.geometrywars.world.World;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.filters.BlurFilter;
	import nl.teddevos.geometrywars.gui.components.GuiText;
	import nl.teddevos.geometrywars.gui.SwitchGuiEvent;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import nl.teddevos.geometrywars.graphics.AssetsList;

	public class GuiScreenGame extends GuiScreen
	{
		private var text_score:GuiText;
		private var gameOverDelay:int = 30;
		private var gameMode:int = 0;
		
		private var paused:Boolean = false;
		private var pauseQuad:Quad;
		private var pause_title:GuiText;
		private var button_resume:GuiButton;
		private var button_quit:GuiButton;
		
		private var lives:Vector.<Image>;
		private var shields:Vector.<Image>;
		
		private var iconQuad:QuadBatch;
		private var healthIMG:Image;
		private var shieldIMG:Image;
		
		public function GuiScreenGame(gm:int) 
		{
			gameMode = gm;
		}
		
		override public function init():void
		{
			var gm:GameMode;
			switch(gameMode)
			{
				case 0: gm = new GameModeEvolved(main.world, this); break;
				case 1: gm = new GameModePacifism(main.world, this); break;
				case 2: gm = new GameModeWaves(main.world, this); break;
				case 3: gm = new GameModeKing(main.world, this); break;
				default: gm = new GameModeEvolved(main.world, this); break;
			}
			main.world.build(gm);
			
			clipRect = new Rectangle(0, 0, 1280, 768);
			
			text_score = addText(new GuiText(500, 50, "Score: 0", "GameFont", 60, 0xFFFFFF, false, screenWidth - 500, 0, -400, 0));
			text_score.textField.hAlign = "left";
			
			iconQuad = new QuadBatch();
			addChild(iconQuad);
			healthIMG = new Image(AssetsList.assets.getTexture("health.png"));
			shieldIMG = new Image(AssetsList.assets.getTexture("explosion_icon.png"));
		}
		
		override public function tick():void
		{
			text_score.textField.text = "Score: " + main.world.score;
			
			if (main.world.iconsEnabled)
			{
				iconQuad.reset();
				
				var i:int = 0;
				for (i = 0; i < main.world.lives; i++ )
				{
					healthIMG.x = 300 + i * 55;
					healthIMG.y = 8;
					iconQuad.addImage(healthIMG);
				}
				
				/*for (i = 0; i < 3; i++ )
				{
					shieldIMG.x = 520 + i * 55;
					shieldIMG.y = 2;
					iconQuad.addImage(shieldIMG);
				}*/
			}
			
			if (main.world.lives < 1)
			{
				gameOverDelay--;
				if (gameOverDelay < 1)
				{
					dispatchEvent(new SwitchGuiEvent(SwitchGuiEvent.NEWGUI, new GuiScreenGameOver(main.world.score, gameMode), true));
				}
			}
		}
		
		override public function destroy():void
		{
			main.world.paused = false;
			main.world.particleManager.paused = false;
			main.world.destory();
		}
		
		override protected function onKeyDown(e:KeyboardEvent):void
		{
			if (paused)
			{
				if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.A)
				{
					nextButton(-1);
				}
				else if (e.keyCode == Keyboard.RIGHT || e.keyCode == Keyboard.D)
				{
					nextButton(1);
				}
				else if (e.keyCode == Keyboard.UP || e.keyCode == Keyboard.W)
				{
					nextButton(-1);
				}
				else if (e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.S)
				{
					nextButton(1);
				}
				else if (e.keyCode == Keyboard.ENTER && keys)
				{
					buttonPressed(buttonList[buttonListSelected]);
				}
			}
			if (e.keyCode == Keyboard.ESCAPE)
			{
				pause();
			}
		}
		
		override public function buttonPressed(b:GuiButton):void
		{
			if (b.id == 0)
			{
				pause();
			}
			else if (b.id == 1)
			{
				switchGui(new GuiScreenMenu());
			}
		}
		
		public function pause():void
		{
			paused = !paused;
			
			if (paused)
			{
				main.world.paused = true;
				main.world.particleManager.paused = true;
				
				pauseQuad = new Quad(1280, 768, 0x000000);
				pauseQuad.alpha = 0.6;
				addChild(pauseQuad);
				
				pause_title = addText(new GuiText(1280, 200, "PAUSED", "GameFont", 155, 0xFFFFFF, false, 0, 0, screenWidth, 0));
				button_resume = addButton(new GuiButtonMoving(0, screenWidth * 0.5, screenHeight * 0.43, 250, 50, "Resume", 75, 105, 0xFFFFFF, -220, screenHeight * 0.43));
				button_quit = addButton(new GuiButtonMoving(1, screenWidth * 0.5, screenHeight * 0.57, 150, 50, "Quit", 75, 105, 0xFFFFFF, screenWidth, screenHeight * 0.57));
			}
			else
			{
				main.world.paused = false;
				main.world.particleManager.paused = false;
				
				removeChild(pauseQuad);
				removeChild(pause_title);
				removeChild(button_resume);
				removeChild(button_quit);
				
				textList.splice(textList.indexOf(pause_title), 1);
				buttonList.splice(buttonList.indexOf(button_resume), 1);
				buttonList.splice(buttonList.indexOf(button_quit), 1);
			}
		}
	}
}