package nl.teddevos.geometrywars.data 
{
	import flash.geom.Point;
	
	public class Highscore 
	{
		public static var playerList:Vector.<Vector.<String>>;
		public static var scoreList:Vector.<Vector.<Number>>;
		
		public static var MAX_LENGTH:int = 50;
		
		public static function init(score:Array, players:Array, listSize:Array):void
		{
			playerList = new Vector.<Vector.<String>>();
			scoreList = new Vector.<Vector.<Number>>();
			
			for (var j:int = 0; j < 4; j++ )
			{
				playerList.push(new Vector.<String>());
				scoreList.push(new Vector.<Number>());
			}
			
			var l:int = score.length;
			var a:int = 0;
			var offset:int = 0;
			for (var i:int = 0; i < l; i++)
			{
				while (i - offset >= listSize[a])
				{
					if (a == 3)
					{
						break;
					}
					
					offset += listSize[a];
					a++;
				}
				
				if (i < MAX_LENGTH + offset)
				{
					playerList[a].push(players[i]);
					scoreList[a].push(score[i]);
				}
			}
		}
		
		public static function getSliceScore(start:int, end:int, gamemode:int):Vector.<Number>
		{
			if (start > scoreList[gamemode].length - 1)
			{
				return new Vector.<Number>();
			}
			
			if (end > scoreList[gamemode].length)
			{
				start -= end - scoreList[gamemode].length;
				end = scoreList[gamemode].length;
			}
			
			if (start < 0)
			{
				start = 0;
			}
			
			var list:Vector.<Number> = new Vector.<Number>();
			for (var i:int = start; i < end; i++ )
			{
				list.push(scoreList[gamemode][i]);
			}
			
			return list;
		}
		
		public static function getSlicePlayers(start:int, end:int, gamemode:int):Vector.<String>
		{
			if (start > playerList[gamemode].length - 1)
			{
				return new Vector.<String>();
			}
			
			if (end > playerList[gamemode].length)
			{
				start -= end - playerList[gamemode].length;
				end = playerList[gamemode].length;
			}
			
			if (start < 0)
			{
				start = 0;
			}
			
			var list:Vector.<String> = new Vector.<String>();
			for (var i:int = start; i < end; i++ )
			{
				list.push(playerList[gamemode][i]);
			}
			
			return list;
		}
		
		public static function getLowestFor(start:int, end:int, gamemode:int):Point
		{
			if (start > playerList[gamemode].length - 1)
			{
				return new Vector.<String>();
			}
			
			if (end > playerList[gamemode].length)
			{
				start -= end - playerList[gamemode].length;
				end = playerList[gamemode].length;
			}
			
			if (start < 0)
			{
				start = 0;
			}
			
			return new Point(start, end);
		}
		
		public static function addScore(player:String, score:Number, gamemode:int):int
		{
			var l:int = scoreList[gamemode].length;
			if (l == 0)
			{
				playerList[gamemode].push(player);
				scoreList[gamemode].push(score);
				SaveData.save();
				
				if (scoreList[gamemode].length >= MAX_LENGTH)
				{
					playerList[gamemode].pop();
					scoreList[gamemode].pop();
				}
				return 0;
			}
			
			for (var i:int = 0; i < l; i++ )
			{
				if (score > scoreList[gamemode][i])
				{
					playerList[gamemode].splice(i, 0, player);
					scoreList[gamemode].splice(i, 0, score);
					SaveData.save();
					
					if (scoreList[gamemode].length >= MAX_LENGTH)
					{
						playerList[gamemode].pop();
						scoreList[gamemode].pop();
					}
					return i;
				}
			}
			
			if (scoreList[gamemode].length < MAX_LENGTH)
			{
				playerList[gamemode].push(player);
				scoreList[gamemode].push(score);
				SaveData.save();
			}
			return scoreList[gamemode].length - 1;
		}
	}
}