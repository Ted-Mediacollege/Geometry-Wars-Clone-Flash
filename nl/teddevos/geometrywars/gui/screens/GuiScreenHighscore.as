package nl.teddevos.geometrywars.gui.screens 
{
	import nl.teddevos.geometrywars.gui.GuiScreen;
	import nl.teddevos.geometrywars.gui.components.GuiButton;
	import nl.teddevos.geometrywars.gui.components.GuiText;
	import nl.teddevos.geometrywars.gui.components.GuiButtonMoving;
	import nl.teddevos.geometrywars.data.Highscore;
	import nl.teddevos.geometrywars.network.HighscoreDataEvent;
	import nl.teddevos.geometrywars.network.HighscoreServer;
	import starling.display.Quad;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class GuiScreenHighscore extends GuiScreen
	{
		public var online_loading_text:GuiText;
		public var onlineLoaded:Boolean;
		
		private var highscore_text:Vector.<GuiText>;
		private var gamemode:int = 0;
		private var button_gamemode:GuiButton;
		
		public function GuiScreenHighscore() 
		{
		}
		
		override public function init():void
		{
			//main
			addText(new GuiText(1280, 200, "Highscore", "GameFont", 135, 0xFFFFFF, false, 0, 0, -screenWidth, 0));
			
			//alpha bg
			var q:Quad = new Quad(1280, 480, 0x000000);
			q.y = screenHeight * 0.2;
			q.alpha = 0.5;
			addChild(q);
			
			//buttons
			button_gamemode = addButton(new GuiButtonMoving(0, screenWidth * 0.5, screenHeight * 0.76, 370, 44, "Gamemode: Evolved", 70, 90, 0xFFFFFF, screenWidth + 240, screenHeight * 0.76));
			var button_back:GuiButton = addButton(new GuiButtonMoving(1, screenWidth * 0.5, screenHeight * 0.93, 240, 44, "Back to menu", 90, 110, 0xFFFFFF, screenWidth + 240, screenHeight * 0.93));
			
			//titles
			addText(new GuiText(450, 60, "Local Highscore", "GameFont", 60, 0xFFFFFF, false, screenWidth * 0.25 - 225, screenHeight * 0.2, -screenWidth * 0.25, screenHeight * 0.2));
			addText(new GuiText(450, 60, "Online Highscore", "GameFont", 60, 0xFFFFFF, false, screenWidth * 0.75 - 225, screenHeight * 0.2, screenWidth * 1.25, screenHeight * 0.2));
			
			highscore_text = new Vector.<GuiText>();
			online_loading_text = addText(new GuiText(400, 40, "Loading list...", "GameFont", 40, 0xFFFFFF, false, screenWidth * 0.6, screenHeight * 0.28, screenWidth + 500, screenHeight * 0.28));
			loadLists();
			
			addEventListener(HighscoreDataEvent.DATA, onHighscoreData);
			
			onlineLoaded = false;
		}
		
		public function onHighscoreData(e:HighscoreDataEvent):void
		{
			if (!onlineLoaded)
			{
				if (e.succes)
				{
					if (e.list.length < 3)
					{
						online_loading_text.textField.text = "No highscore found!";
						onlineLoaded = true;
						return;
					}
					
					var a:Array = e.list.split("#");
					var b:Array;
					
					var p:Vector.<String> = new Vector.<String>();
					var s:Vector.<Number> = new Vector.<Number>();
					
					var l:int = a.length;
					for (var i:int = 0; i < l; i++ )
					{
						b = (a[i] as String).split(":");
						p.push((b[1] as String));
						s.push((b[2] as String));
					}
					
					online_loading_text.visible = false;
					createList(p, s, screenWidth * 0.5, screenHeight * 0.28, screenWidth + 500);
					
					onlineLoaded = true;
				}
				else
				{
					online_loading_text.textField.text = "Failed to load. \n Check your connection!";
					HighscoreServer.requestData("?t=0&g=" + gamemode);
				}
			}
		}
		
		public function createList(names:Vector.<String>, score:Vector.<Number>, px:Number, py:Number, sx:Number):void
		{
			var l:int = names.length;
			if (l == 0)
			{
				var t:GuiText = addText(new GuiText(300, 40, "No highscores found!", "GameFont", 40, 0xFFFFFF, false, px + 190, py, sx, py));
				t.textField.hAlign = "left";
				
				highscore_text.push(t);
				return;
			}
			
			for (var i:int = 0; i < l; i++ )
			{
				var t1:GuiText = addText(new GuiText(50, 40, (i + 1) + ".", "GameFont", 40, 0xFFFFFF, false, px + 125, py + i * 32, sx, py + i * 32));
				t1.textField.hAlign = "left";
				
				var t2:GuiText = addText(new GuiText(400, 40, names[i], "GameFont", 40, 0xFFFFFF, false, px + 165, py + i * 32, sx, py + i * 32));
				t2.textField.hAlign = "left";
				
				var t3:GuiText = addText(new GuiText(300, 40, score[i] + "", "GameFont", 40, 0xFFFFFF, false, px + 380, py + i * 32, sx, py + i * 32));
				t3.textField.hAlign = "left";
				
				highscore_text.push(t1, t2, t3);
			}
		}
		
		private function loadLists():void
		{
			createList(Highscore.getSlicePlayers(0, 10, gamemode), Highscore.getSliceScore(0, 10, gamemode), 0, screenHeight * 0.28, -500);
			online_loading_text.textField.text = "Loading...";
			HighscoreServer.requestData("?t=0&g=" + gamemode);
			online_loading_text.visible = true;
		}
		
		private function resetLists():void
		{
			var l:int = highscore_text.length;
			for (var i:int = 0; i < l; i++ )
			{
				removeChild(highscore_text[i]);
			}
			highscore_text.splice(0, l);
		}
		
		override public function tick():void
		{
			if (!onlineLoaded && !HighscoreServer.loading)
			{
				HighscoreServer.requestData("?t=0");
			}
		}
		
		override public function buttonPressed(b:GuiButton):void
		{
			if (b.id == 1)
			{
				switchGui(new GuiScreenMenu());
			}
			else if (b.id == 0)
			{
				resetLists();
				gamemode++;
				if (gamemode > 2)
				{
					gamemode = 0;
				}
				loadLists();
				
				switch(gamemode)
				{
					case 0: button_gamemode.textField.text = "Gamemode: Evolved"; break;
					case 1: button_gamemode.textField.text = "Gamemode: Pacifism"; break;
					case 2: button_gamemode.textField.text = "Gamemode: Waves"; break;
					case 3: button_gamemode.textField.text = "Gamemode: King"; break;
				}
				
				onlineLoaded = false;
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