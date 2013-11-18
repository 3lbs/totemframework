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

	import totem.monitors.startupmonitor.IStartupProxy;
	import totem.structures.IIterator;
	import totem.structures.lists.SLinkedList;

	public class StartupDispatcherMonitor extends RequiredProxy
	{

		protected var _monitors : SLinkedList;

		protected var count : int;

		public function StartupDispatcherMonitor( id : String = "" )
		{
			super( id );

			_monitors = new SLinkedList();

		}

		public function addCompleteDispatcher( dispatcher : IStartupProxy, eventType : String = Event.COMPLETE ) : void
		{
			dispatcher.addEventListener( eventType, onComplete );
			_monitors.append( dispatcher );

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
			var itr : IIterator = _monitors.iterator;

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

			dispatchEvent( new Event( Event.CHANGE ));

			if ( _monitors.size == 0 )
			{
				dispatchEvent( new Event( Event.COMPLETE ));
			}
		}
	}
}
