package nl.teddevos.geometrywars.gui 
{
	import starling.events.Event;
	
	public class SwitchGuiEvent extends Event
	{
		public static const NEWGUI:String = "newGui";
		
		public var guiscreen:GuiScreen;
		
		public function SwitchGuiEvent(type:String, gui:GuiScreen, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			guiscreen = gui;
		}
	}
}