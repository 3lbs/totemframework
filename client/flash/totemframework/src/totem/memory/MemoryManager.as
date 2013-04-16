package totem.memory
{

	import flash.events.IEventDispatcher;
	import flash.system.System;
	import flash.utils.setInterval;

	import totem.events.RemovableEventDispatcher;

	//http://gskinner.com/blog/archives/2006/08/as3_resource_ma_2.html

	public class MemoryManager extends RemovableEventDispatcher
	{
		public function MemoryManager( target : IEventDispatcher = null )
		{
			super( target );
		}

		// check our memory every 1 second:
		private var checkMemoryIntervalID : uint = setInterval( checkMemoryUsage, 1000 );

		private var showWarning : Boolean = true;

		private var warningMemory : uint = 1000 * 1000 * 500;

		private var abortMemory : uint = 1000 * 1000 * 625;

		private function checkMemoryUsage()
		{
			if ( System.totalMemory > warningMemory && showWarning )
			{
				// show an error to the user warning them that we're running out of memory and might quit
				// try to free up memory if possible
				showWarning = false; // so we don't show an error every second
			}
			else if ( System.totalMemory > abortMemory )
			{
				// save current user data to an LSO for recovery later?
				//abort();
			}
		}
	}
}
