package nl.teddevos.geometrywars.data 
{
	import flash.net.SharedObject;
	
	public class SaveData 
	{
		public static var saveFile:SharedObject;
		
		public static function init():void
		{
			saveFile = SharedObject.getLocal("geometrywars_clone_teddevos");
			load();
		}
		
		public static function load():void
		{
			var playerList:Array;
			var scoreList:Array;
			var size:Array;
			
			if (saveFile.data.players != null) { playerList = saveFile.data.players; } else { playerList = new Array(); }
			if (saveFile.data.score != null) { scoreList = saveFile.data.score; } else { scoreList = new Array(); }
			if (saveFile.data.size != null) { size = saveFile.data.size; } else { size = new Array(0, 0, 0, 0); }
			
			Highscore.init(scoreList, playerList, size);
		}
		
		public static function save():void
		{
			var player:Array = new Array();
			var score:Array = new Array();
			var size:Array = new Array();
			
			var i:int = 0, l:int = 0;
			
			for (var j:int = 0; j < 4; j++ )
			{
				l = Highscore.playerList[j].length;
				for (i = 0; i < l; i++)
				{
					player.push(Highscore.playerList[j][i]);
					score.push(Highscore.scoreList[j][i]);
				}
				
				size.push(l);
			}
			
			saveFile.data.players = player;
			saveFile.data.score = score;
			saveFile.data.size = size;
			
			saveFile.flush();
		}
		
		public static function reset():void
		{
			saveFile.clear();
		}
	}
}