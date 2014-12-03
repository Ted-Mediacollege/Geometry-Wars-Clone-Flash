package nl.teddevos.geometrywars.event.waves 
{
	import nl.teddevos.geometrywars.world.World;
	import nl.teddevos.geometrywars.util.MathHelper;
	import nl.teddevos.geometrywars.event.EventBase;
	
	public class EventWavesWait extends EventBase
	{
		public function EventWavesWait(t:int) 
		{
			super("EventWavesWait", t);
		}
	}
}