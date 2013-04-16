package totem.monitors.startupmonitor
{
	import flash.events.Event;

	public class StartupFactoryProxy extends StartupResourceProxy
	{
		public function StartupFactoryProxy()
		{
			super(null);
		}

		override public function load():void
		{
			status=LOADING;
		}

		override protected function complete(eve:Event=null):void
		{
			_dependency.length=0;

			status=LOADED;

			dispatchEvent(new Event(Event.COMPLETE))
		}
	}
}
