package nl.teddevos.geometrywars.gui.screens 
{
	import flash.geom.Rectangle;
	import nl.teddevos.geometrywars.gui.components.GuiButton;
	import nl.teddevos.geometrywars.gui.components.GuiButtonMoving;
	import nl.teddevos.geometrywars.gui.components.GuiText;
	import nl.teddevos.geometrywars.gui.GuiScreen;
	import nl.teddevos.geometrywars.world.World;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import nl.teddevos.geometrywars.data.Settings;
	import nl.teddevos.geometrywars.PreLoader;
	import starling.display.Quad;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class GuiScreenSettings extends GuiScreen
	{
		private var button_music:GuiButton;
		private var button_sound:GuiButton;
		private var button_particle:GuiButton;
		private var button_glow:GuiButton;
		private var button_stars:GuiButton;
		private var button_debug:GuiButton;
		
		public function GuiScreenSettings() 
		{
			
		}
		
		override public function init():void
		{
			addText(new GuiText(1280, 200, "Settings", "GameFont", 135, 0xFFFFFF, false, 0, 0, -screenWidth, 0));
			var button_back:GuiButton = addButton(new GuiButtonMoving(0, screenWidth * 0.5, screenHeight * 0.9, 240, 44, "Back to menu", 90, 110, 0xFFFFFF, screenWidth + 240, screenHeight * 0.9));
						
			//alpha bg
			var q:Quad = new Quad(1280, 480, 0x000000);
			q.y = screenHeight * 0.2;
			q.alpha = 0.5;
			addChild(q);
			
			//sound
			//button_music = addButton(new GuiButtonMoving(10, screenWidth * 0.5, screenHeight * 0.31, 160, 40, "Music: ", 70, 90, 0xFFFFFF, -120, screenHeight * 0.31));
			//button_sound = addButton(new GuiButtonMoving(11, screenWidth * 0.5, screenHeight * 0.39, 160, 40, "Sound: ", 70, 90, 0xFFFFFF, screenWidth + 120, screenHeight * 0.39));	
			//button_music.textField.text = "Music: " + (Settings.MUSIC ? "ON" : "OFF");
			//button_sound.textField.text = "Sound: " + (Settings.SOUND ? "ON" : "OFF");
			
			button_particle = addButton(new GuiButtonMoving(12, screenWidth * 0.5, screenHeight * (0.47 - 0.1), 290, 40, "Max Particles: ", 70, 90, 0xFFFFFF, -220, screenHeight * (0.47 - 0.1)));
			button_particle.textField.text = "Max Particles: " + (Settings.PARTICLES * 2000);
			
			//glow
			button_glow = addButton(new GuiButtonMoving(13, screenWidth * 0.5, screenHeight * (0.55 - 0.1), 160, 40, "Glow: ", 70, 90, 0xFFFFFF, screenWidth + 120, screenHeight * (0.55 - 0.1)));
			button_glow.textField.text = "Glow: " + (Settings.GLOW ? "ON" : "OFF");
			
			//stars
			button_stars = addButton(new GuiButtonMoving(14, screenWidth * 0.5, screenHeight * (0.63 - 0.1), 160, 40, "Stars: ", 70, 90, 0xFFFFFF, -120, screenHeight * (0.63 - 0.1)));
			button_stars.textField.text = "Stars: " + (Settings.STARS ? "ON" : "OFF");
			
			//debug
			button_debug = addButton(new GuiButtonMoving(15, screenWidth * 0.5, screenHeight * (0.71 - 0.1), 160, 40, "Debug: ", 70, 90, 0xFFFFFF, screenWidth + 120, screenHeight * (0.71 - 0.1)));
			button_debug.textField.text = "Debug: " + (Settings.DEBUG ? "ON" : "OFF");
		}
		
		override public function tick():void
		{
		}
		
		override public function buttonPressed(b:GuiButton):void
		{
			if (b.id == 0)
			{
				switchGui(new GuiScreenMenu());
			}
			else if (b.id == 10)
			{
				Settings.MUSIC = !Settings.MUSIC;
				button_music.textField.text = "Music: " + (Settings.MUSIC ? "ON" : "OFF");
			}
			else if (b.id == 11)
			{
				Settings.SOUND = !Settings.SOUND;
				button_sound.textField.text = "Sound: " + (Settings.SOUND ? "ON" : "OFF");
			}
			else if (b.id == 12)
			{
				Settings.PARTICLES--;
				if (Settings.PARTICLES < 1)
				{
					Settings.PARTICLES = 4;
				}
				main.world.resetParticles();
				button_particle.textField.text = "Max Particles: " + (Settings.PARTICLES * 2000);
			}
			else if (b.id == 13)
			{
				Settings.GLOW = !Settings.GLOW;
				button_glow.textField.text = "Glow: " + (Settings.GLOW ? "ON" : "OFF");
				
				if (Settings.GLOW)
				{
					main.addGlow();
				}
				else
				{
					main.filter = null;
				}
			}
			else if (b.id == 14)
			{
				Settings.STARS = !Settings.STARS;
				button_stars.textField.text = "Stars: " + (Settings.STARS ? "ON" : "OFF");
			}
			else if (b.id == 15)
			{
				Settings.DEBUG = !Settings.DEBUG;
				button_debug.textField.text = "Debug: " + (Settings.DEBUG ? "ON" : "OFF");
				
				if (Settings.DEBUG)
				{
					PreLoader.preloader.starling.showStats = true;
				}
				else
				{
					PreLoader.preloader.starling.showStats = false;
				}
			}
		}
		
		override protected function onKeyDown(e:KeyboardEvent):void
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
	}
}