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

package totem.monitors.simple
{

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import totem.events.RemovableEventDispatcher;
	import totem.structures.lists.SLinkedList;

	public class EventMonitor extends RemovableEventDispatcher
	{
		protected var _monitors : SLinkedList;

		protected var count : int;

		public function EventMonitor( target : IEventDispatcher = null )
		{
			super( target );

			_monitors = new SLinkedList();
		}

		public function addDispatcher( dispatcher : IEventDispatcher, eventType : String = Event.COMPLETE ) : void
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
