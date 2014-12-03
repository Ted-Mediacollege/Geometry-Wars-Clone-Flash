package nl.teddevos.geometrywars.gui.screens 
{
	import flash.geom.Point;
	import nl.teddevos.geometrywars.gui.GuiScreen;
	import nl.teddevos.geometrywars.gui.components.GuiButton;
	import nl.teddevos.geometrywars.gui.components.GuiText;
	import nl.teddevos.geometrywars.gui.components.GuiButtonMoving;
	import nl.teddevos.geometrywars.data.Highscore;
	import starling.events.Event;
	import nl.teddevos.geometrywars.network.HighscoreServer;
	import starling.display.Quad;
	import nl.teddevos.geometrywars.network.HighscoreDataEvent;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class GuiScreenResult extends GuiScreen
	{
		public var online_loading_text:GuiText;
		public var onlineLoaded:Boolean;
		
		private var playerName:String;
		private var playerScore:int;
		private var playerPos:int;
		private var gamemode:int;
		
		public function GuiScreenResult(pn:String, s:int, pos:int, g:int) 
		{
			playerName = pn;
			playerScore = s;
			playerPos = pos;
			gamemode = g;
		}
		
		override public function init():void
		{
			//main
			addText(new GuiText(1280, 200, "Highscore", "GameFont", 135, 0xFFFFFF, false, 0, 0, -screenWidth, 0));			
			var button_game:GuiButton = addButton(new GuiButtonMoving(0, screenWidth * 0.25, screenHeight * 0.93, 240, 44, "Play again", 90, 110, 0xFFFFFF, -240, screenHeight * 0.93));
			var button_back:GuiButton = addButton(new GuiButtonMoving(1, screenWidth * 0.75, screenHeight * 0.93, 240, 44, "Back to menu", 90, 110, 0xFFFFFF, screenWidth + 240, screenHeight * 0.93));
			
			//alpha bg
			var q:Quad = new Quad(1280, 480, 0x000000);
			q.y = screenHeight * 0.2;
			q.alpha = 0.5;
			addChild(q);
			
			//titles
			addText(new GuiText(450, 60, "Local Highscore", "GameFont", 60, 0xFFFFFF, false, screenWidth * 0.25 - 225, screenHeight * 0.2, -screenWidth * 0.25, screenHeight * 0.2));
			addText(new GuiText(450, 60, "Online Highscore", "GameFont", 60, 0xFFFFFF, false, screenWidth * 0.75 - 225, screenHeight * 0.2, screenWidth * 1.25, screenHeight * 0.2));
			
			var low:int = playerPos - 5;
			var high:int = playerPos + 5;
			
			if (low < 0)
			{
				high += -low;
				low = 0;
			}
			
			createList(Highscore.getSlicePlayers(low, high, gamemode), Highscore.getSliceScore(low, high, gamemode), Highscore.getLowestFor(low, high, gamemode), 0, screenHeight * 0.28, -500);
			online_loading_text = addText(new GuiText(400, 40, "Loading list...", "GameFont", 40, 0xFFFFFF, false, screenWidth * 0.6, screenHeight * 0.28, screenWidth + 500, screenHeight * 0.28));
					
			HighscoreServer.requestData("?t=1&g=" + gamemode + "&n=" + playerName + "&s=" + playerScore);
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
						return;
					}
					
					var a:Array = e.list.split("#");
					var b:Array;
					
					var p:Vector.<String> = new Vector.<String>();
					var s:Vector.<Number> = new Vector.<Number>();
					
					var l:int = a.length;
					var st:int = 0;
					for (var i:int = 0; i < l; i++ )
					{
						b = (a[i] as String).split(":");
						p.push((b[1] as String));
						s.push((b[2] as String));
						
						if (i == 0)
						{
							st = int(parseInt(b[0]));
						}
					}
					
					online_loading_text.visible = false;
					createList(p, s, new Point(st, st + 10), screenWidth * 0.5, screenHeight * 0.28, screenWidth + 500);
					onlineLoaded = true;
				}
				else
				{
					online_loading_text.textField.text = "Failed to load.";
				}
			}
		}
		
		public function createList(names:Vector.<String>, score:Vector.<Number>, pos:Point, px:Number, py:Number, sx:Number):void
		{
			var l:int = names.length;
			if (l == 0)
			{
				var t:GuiText = addText(new GuiText(300, 40, "No highscores found!", "GameFont", 40, 0xFFFFFF, false, px + 190, py, sx, py));
				t.textField.hAlign = "left";
				return;
			}
			
			var found:Boolean = false;
			var b:Boolean = false;
			var f:int = -1;
			
			if (5 < l)
			{
				if (playerName == names[5] && playerScore == score[5])
				{
					f = 5;
				}
			}
			
			for (var i:int = 0; i < l; i++ )
			{
				if (playerName == names[i] && playerScore == score[i] && !found && f == -1)
				{
					found = true;
					b = true;
				}
				else if (f == i)
				{
					found = true;
					b = true;
				}
				
				var t1:GuiText = addText(new GuiText(50, 40, (i + 1 + int(pos.x)) + ".", "GameFont", 40, b ? 0xFF7575 : 0xFFFFFF, false, px + 125, py + i * 40, sx, py + i * 40));
				t1.textField.hAlign = "left";
				
				var t2:GuiText = addText(new GuiText(400, 40, names[i], "GameFont", 40, b ? 0xFF7575 : 0xFFFFFF, false, px + 165, py + i * 40, sx, py + i * 40));
				t2.textField.hAlign = "left";
				
				var t3:GuiText = addText(new GuiText(300, 40, score[i] + "", "GameFont", 40, b ? 0xFF7575 : 0xFFFFFF, false, px + 380, py + i * 40, sx, py + i * 40));
				t3.textField.hAlign = "left";
				
				b = false;
			}
		}
		
		override public function tick():void
		{
		}
		
		override public function buttonPressed(b:GuiButton):void
		{
			if (b.id == 1)
			{
				switchGui(new GuiScreenMenu());
			}
			else if (b.id == 0)
			{
				switchGui(new GuiScreenGame(gamemode));
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