package totem.monitors.startupmonitor
{

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.swiftsuspenders.Injector;
	
	import totem.totem_internal;
	import totem.core.IInject;
	import totem.core.mvc.TotemContext;
	import totem.events.RemovableEventDispatcher;

	use namespace totem_internal;
	
	public class StartupMonitorProxy extends RemovableEventDispatcher
	{
		public static var NAME : String = "START_UP_MONITOR_PROXY";

		private var resourceList : Array;

		private var injector : Injector;

		public function StartupMonitorProxy( context : TotemContext )
		{
			
			resourceList = new Array();

			this.injector = context.getInjector();
		}

		public function loadResources() : void
		{
			doLoadResources();
		}

		private function doLoadResources() : void
		{
			for each ( var r : StartupResourceProxy in resourceList )
			{
				if ( r.isOkToLoad())
				{
					
					if ( r is IInject )
					{
						injector.injectInto( r );
					}
					
					r.addEventListener( Event.COMPLETE, onComplete, false, 0, true );
					r.addEventListener( ErrorEvent.ERROR, onFailed, false, 0, true );
					r.load();
				}
			}
		}

		public function addResource( r : StartupResourceProxy ) : void
		{
			resourceList.push( r );
		}

		private function onComplete( eve : Event ) : void
		{
			( eve.target as IEventDispatcher ).removeEventListener( Event.COMPLETE, onComplete );

			if ( isLoadingFinished())
			{
				resourceList.length = 0;
				dispatchEvent( new StartupEvent( StartupEvent.STARTUP_COMPLETE ));
			}
			else
			{
				doLoadResources();
			}
		}

		private function onFailed( eve : ErrorEvent ) : void
		{
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR ));
		}

		protected function isLoadingFinished() : Boolean
		{
			for each ( var r : StartupResourceProxy in resourceList )
			{
				if ( !r.isLoaded())
					return false;
			}
			return true;
		}
	}
}
