package totem.monitors.startupmonitor
{
	import flash.events.Event;

	public class StartupEvent extends Event
	{
		public static var INIT_COMPLETE : String = "INIT_COMPLETE";
		
		public static var STARTUP_COMPLETE:String = "STARTUP_COMPLETE";
		
		public function StartupEvent (name : String)
		{
			super (name);
		}

	}
}
