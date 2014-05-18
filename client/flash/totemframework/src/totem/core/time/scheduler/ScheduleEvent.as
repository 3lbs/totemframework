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

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import totem.core.Destroyable;
	import totem.time.date.globalTime;

	public class ScheduleEvent extends Destroyable implements ISchedule
	{
		private var _dispatcher : IEventDispatcher;

		private var _duration : Number;

		private var _event : Event;

		private var _startTime : Number;

		public function ScheduleEvent( dispatcher : IEventDispatcher, event : Event )
		{
			super();

			_event = event;
			_dispatcher = dispatcher;
		}

		public function completeCallback() : void
		{
			_dispatcher.dispatchEvent( _event );

			destroy();
		}

		override public function destroy() : void
		{
			super.destroy();

			_event = null;
			_dispatcher = null;
		}

		public function get duration() : Number
		{
			return _duration;
		}

		public function set duration( value : Number ) : void
		{
			_duration = value;
		}

		public function getElaspedTime() : Number
		{
			return globalTime() - _startTime;
		}

		public function get startTime() : Number
		{
			return _startTime;
		}

		public function set startTime( value : Number ) : void
		{
			_startTime = value;
		}
	}
}
