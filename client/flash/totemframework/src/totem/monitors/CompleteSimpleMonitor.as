//------------------------------------------------------------------------------
//
//   Copyright 2012 
//   All rights reserved. 
//	
//	CompleteMonitor : tracks completion of objects
//  no failed check here.  If you need to check failed in dispatcher obhect, dispatch complete on failed
//  will write an CompleteOrFailMonitor that requires IRemovableDispatcher
//------------------------------------------------------------------------------

package totem.monitors
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import org.casalib.events.RemovableEventDispatcher;
	/**
	 *
	 * @author eddie
	 */
	public class CompleteSimpleMonitor extends RemovableEventDispatcher
	{
		
		/**
		 *
		 */
		public function CompleteSimpleMonitor()
		{
			numDispatchers = completed = 0;
		}
		
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
		 * @param ev
		 * @param eventType
		 */
		public function addDispatcher( ev : IEventDispatcher, eventType : String = Event.COMPLETE ) : void
		{
			numDispatchers += 1;
			ev.addEventListener ( eventType, onComplete );
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
			target.removeEventListener ( eve.type, onComplete );
			
			completed += 1;
			
			if ( completed == numDispatchers )
			{
				dispatchEvent ( new Event ( Event.COMPLETE ) );
			}
		}
	}
}


