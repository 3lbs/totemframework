package totem.startup.startupmanager
{
	import flash.events.EventDispatcher;
	
	import totem.startup.startupmanager.interfaces.IStartupProxy;
	import totem.startup.startupmanager.model.StartupMonitorProxy;
	import totem.startup.startupmanager.model.StartupResourceProxy;
	
	public class StartupMonitorWrapper extends EventDispatcher
	{
		private var monitor : StartupMonitorProxy;
		
		public function StartupMonitorWrapper()
		{
			super();
			
			//eventDispatcher = new EventDispatcher();
			
			monitor = new StartupMonitorProxy();
		}
		
		public function makeAndRegisterStartupResource( name : String, proxy : IStartupProxy ) : StartupResourceProxy
		{
			return null;
		}
		
		public function loadResources () : void
		{
		
		}
	}
}

