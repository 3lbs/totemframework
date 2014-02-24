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

	import totem.core.TotemComponent;

	public class ScheduleComponent extends TotemComponent implements ISchedule
	{

		[Inject]
		public var scheduler : ScheduleManager;

		public function ScheduleComponent( name : String = null )
		{
			super( name );
		}

		public function completeCallback() : void
		{
		}

		public function get duration() : Number
		{
			return 0;
		}

		public function getElaspedTime() : Number
		{
			return 0;
		}

		public function start() : void
		{
		}

		public function get startTime() : Number
		{
			return 0;
		}

		public function subscribe() : void
		{
			scheduler.subscribe( this );
		}

		public function unscribe() : void
		{
			scheduler.unsubscribe( this );
		}
	}
}
