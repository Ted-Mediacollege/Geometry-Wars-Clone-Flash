package nl.teddevos.geometrywars 
{
	import flash.display.Sprite;
	import starling.core.Starling;
	import nl.teddevos.geometrywars.data.Settings;

	public class PreLoader extends Sprite 
	{
		public var starling:Starling;
		public static var preloader:PreLoader;
		
		[SWF(width="1280", height="720", frameRate="30", backgroundColor="#000000")]
		public function PreLoader()
		{
			preloader = this;
			
			starling = new Starling(Main, stage);
			starling.showStats = Settings.DEBUG;
			starling.start();
		}
	}
}