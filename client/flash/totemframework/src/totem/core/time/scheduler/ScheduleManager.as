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
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.core.time.scheduler
{

	import org.as3commons.collections.LinkedList;
	import org.as3commons.collections.framework.core.LinkedListIterator;

	import totem.core.TotemSystem;
	import totem.core.time.ITicked;
	import totem.time.date.globalTime;

	public class ScheduleManager extends TotemSystem implements ITicked
	{

		private var _interval : int = 3000;

		private var _lastTime : Number = 0;

		private var _processListIterator : LinkedListIterator;

		private var _startTime : Number = 0;

		private var processList : LinkedList = new LinkedList();

		public function ScheduleManager( name : String = null )
		{
			super( name );

			_processListIterator = processList.iterator() as LinkedListIterator;
		}

		override public function initialize() : void
		{
			super.initialize();
			_lastTime = globalTime();
		}

		public function get interval() : int
		{
			return _interval;
		}

		public function set interval( value : int ) : void
		{
			_interval = value;
		}

		public function get lastTime() : Number
		{
			return _lastTime;
		}

		public function onTick() : void
		{
			var time : Number = globalTime();

			if ( time - _lastTime < _interval )
				return;

			_lastTime = time;

			var entry : ISchedule;

			_processListIterator.start();

			while ( _processListIterator.hasNext())
			{
				entry = _processListIterator.next();

				if ( time > entry.duration )
				{
					entry.completeCallback();
					unsubscribe( entry );
				}
			}
		}

		public function subscribe( entry : ISchedule ) : void
		{
			if ( processList.has( entry ))
			{
				return;
			}

			if ( entry.duration <  globalTime() )
			{
				throw new Error("Time is in the past");
			}
			processList.add( entry );
		}

		public function unsubscribe( entry : ISchedule ) : Boolean
		{
			return processList.remove( entry );
		}
	}
}
