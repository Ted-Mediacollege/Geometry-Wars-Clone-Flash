package nl.teddevos.geometrywars.gui.screens 
{
	import nl.teddevos.geometrywars.gui.GuiScreen;
	import nl.teddevos.geometrywars.gui.components.GuiButton;
	import nl.teddevos.geometrywars.gui.components.GuiText;
	import nl.teddevos.geometrywars.gui.components.GuiButtonMoving;
	import starling.events.KeyboardEvent;
	import nl.teddevos.geometrywars.data.Highscore;
	import starling.display.Quad;
	
	public class GuiScreenGameOver extends GuiScreen
	{
		private var score:int = 0;
		private var playerName:String = "";
		private var name_text:GuiText;
		private var done_button:GuiButton;
		
		private var gamemode:int = 0;
		
		public function GuiScreenGameOver(s:int, g:int) 
		{
			score = s;
			gamemode = g;
		}
		
		override public function init():void
		{
			addText(new GuiText(1280, 200, "GAME OVER!", "GameFont", 155, 0xFFFFFF, false, 0, 0, screenWidth, 0));
						
			//alpha bg
			var q:Quad = new Quad(1280, 480, 0x000000);
			q.y = screenHeight * 0.2;
			q.alpha = 0.5;
			addChild(q);
			
			addText(new GuiText(1280, 60, "Your score: " + score, "GameFont", 90, 0xFFFFFF, false, 0, screenHeight * 0.32, -screenWidth, screenHeight * 0.32));
			
			addText(new GuiText(500, 60, "What is your name?", "GameFont", 70, 0xFFFFFF, false, screenWidth * 0.5 - 250, screenHeight * 0.55, screenWidth + 250, screenHeight * 0.55));
			name_text = addText(new GuiText(700, 60, "", "GameFont", 70, 0xFFFFFF, false, screenWidth * 0.5 - 350, screenHeight * 0.65, screenWidth + 250, screenHeight * 0.64));
			
			done_button = addButton(new GuiButtonMoving(0, screenWidth * 0.5, screenHeight * 0.93, 240, 44, "Continue", 90, 110, 0xFFFFFF, screenWidth + 240, screenHeight * 0.93));
		}
		
		override protected function onKeyDown(e:KeyboardEvent):void
		{
			if (((e.keyCode > 64 && e.keyCode < 91) || (e.keyCode > 47 && e.keyCode < 58)) && playerName.length < 10)
			{
				playerName += String.fromCharCode(e.keyCode);
			}
			else if (e.keyCode == 32 && playerName.length < 10)
			{
				playerName += " ";
			}
			else if (e.keyCode == 8)
			{
				playerName = playerName.substr(0, playerName.length - 1);
			}
			else if (e.keyCode == 13 && playerName.length > 0)
			{
				var pos:int = Highscore.addScore(playerName, score, gamemode);
				switchGui(new GuiScreenResult(playerName, score, pos, gamemode));
			}
			
			name_text.textField.text = playerName;
		}
		
		override public function tick():void
		{
			if (playerName.length > 0)
			{
				done_button.visible = true;
			}
			else
			{
				done_button.visible = false;
			}
		}
		
		override public function buttonPressed(b:GuiButton):void
		{
			if (playerName.length > 0)
			{
				var pos:int = Highscore.addScore(playerName, score, gamemode);
				switchGui(new GuiScreenResult(playerName, score, pos, gamemode));
			}
		}
		
		override public function destroy():void
		{
		}
	}
}