package nl.teddevos.geometrywars.network 
{
	import starling.events.Event;

	public class HighscoreDataEvent extends Event
	{
		public static const DATA:String = "highscoreData";
		
		public var list:String;
		public var succes:Boolean;
		
		public function HighscoreDataEvent(type:String, suc:Boolean, d:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.list = d;
			this.succes = suc;
		}
	}
}