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

package totem.core.time
{

	import flash.utils.getTimer;

	import totem.time.Stopwatch;

	public class TickRegulator
	{

		public static const FREQUENCY_HIGH : int = 2;

		public static const FREQUENCY_LOW : int = 6;

		public static const FREQUENCY_MEDIUM : int = 4;

		public static const NO_FREQUENCY : int = 0;

		private var _frequency : int;

		private var _timestamp : Number;

		private var stopWatch : Stopwatch;

		private var tickCount : int = 1;

		public function TickRegulator( frequency : int = NO_FREQUENCY )
		{
			this.frequency = frequency;

			_timestamp = 1 / 60;

			stopWatch = new Stopwatch();
			stopWatch.start();
		}

		public function get frequency() : int
		{
			return _frequency;
		}

		public function set frequency( value : int ) : void
		{
			_frequency = value;
		}

		public function isReady() : Number
		{

			return _timestamp;

			if ( _frequency == NO_FREQUENCY )
			{
				return stopWatch.time;
			}

			if ( tickCount > _frequency )
			{
				tickCount = 0;
				return stopWatch.time;
			}

			tickCount++;
			return 0;
		}

		private function get timer() : int
		{
			return getTimer();
		}
	}
}
