package nl.teddevos.geometrywars.network 
{
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import nl.teddevos.geometrywars.Main;
	import flash.events.Event;
	
	public class HighscoreServer 
	{
		public static var loading:Boolean = false;
		public static var loader:URLLoader;
		
		public static function requestData(params:String = ""):void
		{
			if (!loading)
			{
				loading = true;
				
				try
				{
					loader = new URLLoader;
					var urlreq:URLRequest = new URLRequest("http://teddevos.nl/GAME_PHP_HIGHSCORES/GEOMETRY" + params);
					var urlvars: URLVariables = new URLVariables;
					loader.dataFormat = URLLoaderDataFormat.TEXT;
					loader.addEventListener(Event.COMPLETE, onListData);
					loader.addEventListener(IOErrorEvent.IO_ERROR, onIOerror);
					loader.load(urlreq);				
				}
				catch (e:Error)
				{
					Main.main.gui.dispatchEvent(new HighscoreDataEvent(HighscoreDataEvent.DATA, false, "", true));
				}
			}
		}
		
		private static function onIOerror(e:IOErrorEvent):void
		{
			loading = false;
			Main.main.gui.dispatchEvent(new HighscoreDataEvent(HighscoreDataEvent.DATA, false, "", true));
		}
		
		private static function onListData(e:Event):void
		{
			if (loading)
			{
				try
				{
					var reciever:URLLoader = URLLoader(e.target);
					var s:String = reciever.data;		
					
					Main.main.gui.dispatchEvent(new HighscoreDataEvent(HighscoreDataEvent.DATA, true, s, true));
				}
				catch (e:Error)
				{
					Main.main.gui.dispatchEvent(new HighscoreDataEvent(HighscoreDataEvent.DATA, false, "", true));
				}
				
				loader.removeEventListener(Event.COMPLETE, onListData);
				loading = false;
			}
		}
		
		public static function cancel():void
		{
			if (loading)
			{
				loading = false;
			}
		}
	}
}