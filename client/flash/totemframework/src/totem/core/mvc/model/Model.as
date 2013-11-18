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

package totem.core.mvc.model
{

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import totem.events.RemovableEventDispatcher;
	import totem.monitors.startupmonitor.IStartupProxy;

	public class Model extends RemovableEventDispatcher implements IStartupProxy
	{

		[Inject]
		public var eventDispatcher : IEventDispatcher;

		public function Model( target : IEventDispatcher = null )
		{
			super( target );
		}

		public function load() : void
		{
			throw new Error( "Must be overriden" );
		}

		protected function dispatchContext( e : Event ) : void
		{
			if ( eventDispatcher.hasEventListener( e.type ))
				eventDispatcher.dispatchEvent( e );
		}
	}
}
