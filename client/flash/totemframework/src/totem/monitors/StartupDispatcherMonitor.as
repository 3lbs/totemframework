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

package totem.monitors
{

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import org.as3commons.collections.LinkedList;
	import org.as3commons.collections.framework.IIterator;

	import totem.monitors.startupmonitor.IStartupProxy;

	public class StartupDispatcherMonitor extends RequiredProxy
	{

		protected var _monitors : LinkedList;

		protected var count : int;

		public function StartupDispatcherMonitor( id : String = "" )
		{
			super( id );

			_monitors = new LinkedList();

		}

		public function addCompleteDispatcher( dispatcher : IStartupProxy, eventType : String = Event.COMPLETE ) : void
		{
			dispatcher.addEventListener( eventType, onComplete );
			_monitors.add( dispatcher );

			count += 1;
		}

		override public function destroy() : void
		{
			super.destroy();

			while ( _monitors.size > 0 )
				IEventDispatcher( _monitors.removeLast()).removeEventListener( Event.COMPLETE, onComplete );

			_monitors.clear();
			_monitors = null;
		}

		override public function start() : void
		{
			var itr : IIterator = _monitors.iterator();

			while ( itr.hasNext())
			{
				IStartupProxy( itr.next()).load();
			}
		}

		public function get totalDispatchers() : int
		{
			return _monitors.size;
		}

		protected function onComplete( eve : Event ) : void
		{
			var dispatcher : IEventDispatcher = eve.target as IEventDispatcher;
			dispatcher.removeEventListener( eve.type, onComplete );

			_monitors.remove( dispatcher );

			if ( _monitors.size == 0 )
			{
				finished();
			}
		}
	}
}
