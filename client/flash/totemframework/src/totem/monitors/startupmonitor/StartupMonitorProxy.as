//------------------------------------------------------------------------------
//
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                
//    |::.. . |                
//    `-------'      
//                       
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.monitors.startupmonitor
{

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import org.swiftsuspenders.Injector;
	import totem.core.IInject;
	import totem.core.mvc.TotemContext;
	import totem.events.RemovableEventDispatcher;

	import totem.totem_internal;

	use namespace totem_internal;

	public class StartupMonitorProxy extends RemovableEventDispatcher
	{
		public static var NAME : String = "START_UP_MONITOR_PROXY";

		private var injector : Injector;

		private var resourceList : Array;

		public function StartupMonitorProxy( context : TotemContext )
		{

			resourceList = new Array();

			this.injector = context.getInjector();
		}

		public function addResource( r : StartupResourceProxy ) : void
		{
			resourceList.push( r );
		}

		override public function destroy() : void
		{
			super.destroy();

			resourceList = null
			injector = null;
		}

		public function loadResources() : void
		{
			doLoadResources();
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
	}
}
