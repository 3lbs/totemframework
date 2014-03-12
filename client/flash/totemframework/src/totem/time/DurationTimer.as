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

package totem.time
{

	import flash.utils.getTimer;

	import totem.core.Destroyable;

	public class DurationTimer extends Destroyable
	{
		private var _duration : Number;

		private var _startTime : int;

		public function DurationTimer()
		{
			super();
		}

		public function isComplete() : Boolean
		{
			return timer > _duration;
		}

		public function start( time : int ) : void
		{
			_duration = time + timer;
			_startTime = timer;
		}

		private function get timer() : int
		{
			return getTimer();
		}
	}
}
