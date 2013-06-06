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

	import totem.events.RemovableEventDispatcher;

	/**
	 *
	 * @author eddie
	 */
	public class FastEventMonitor extends RemovableEventDispatcher
	{

		/**
		 *
		 * @default
		 */
		protected var completed : int;

		/**
		 *
		 * @default
		 */
		protected var numDispatchers : int;

		/**
		 *
		 */
		public function FastEventMonitor()
		{
			numDispatchers = completed = 0;
		}

		/**
		 *
		 * @param ev
		 * @param eventType
		 */
		public function addDispatcher( ev : IEventDispatcher, eventType : String = Event.COMPLETE ) : void
		{
			numDispatchers += 1;
			ev.addEventListener( eventType, onComplete );
		}

		/**
		 *
		 * @return
		 */
		public function get totalDispatchers() : int
		{
			return numDispatchers;
		}

		private function onComplete( eve : Event ) : void
		{
			var target : IEventDispatcher = eve.target as IEventDispatcher;
			target.removeEventListener( eve.type, onComplete );

			completed += 1;

			if ( completed == numDispatchers )
			{
				dispatchEvent( new Event( Event.COMPLETE ));
			}
		}
	}
}

