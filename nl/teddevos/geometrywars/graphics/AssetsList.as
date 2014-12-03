package nl.teddevos.geometrywars.graphics 
{
	import flash.filesystem.File;
	import starling.utils.AssetManager;
	
	public class AssetsList 
	{
		[Embed(source="../../../../../lib/Neon Nanoborg.otf", embedAsCFF="false", fontFamily="GameFont")]
		private static const gameFont:Class;
		
		private static var appDir:File;
		public static var assets:AssetManager;
		
		public static var loaded:Boolean = false;
		
		public static function init():void
		{
			appDir = File.applicationDirectory;
			assets = new AssetManager();
			assets.verbose = true;
			
			assets.enqueue(appDir.resolvePath("assets/background"));
			assets.enqueue(appDir.resolvePath("assets/entities"));
			assets.enqueue(appDir.resolvePath("assets/gui"));
			
			assets.loadQueue(
				function(ratio:Number):void 
				{
					if (ratio == 1.0) 
					{
						loaded = true;
					}
				}
			);
		}
	}
}