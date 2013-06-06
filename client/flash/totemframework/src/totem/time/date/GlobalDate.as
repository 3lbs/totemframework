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

package totem.time.date
{

	import totem.time.Stopwatch;

	public class GlobalDate
	{

		private static var _instance : GlobalDate;

		public static function getInstance() : GlobalDate
		{
			return _instance ||= new GlobalDate( new SingletonEnforcer());
		}

		private var _advanceTime : Number = 0;

		private var machineTime : Number = 0;

		private var stopWatch : Stopwatch = new Stopwatch();

		public function GlobalDate( singletonEnforcer : SingletonEnforcer )
		{
			if ( !singletonEnforcer )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );

			setTime( new Date().time );
		}

		public function advanceTime( time : Number ) : void
		{
			_advanceTime = time;
		}

		public function getTimezone() : Number
		{
			// Create two dates: one summer and one winter
			var d1 : Date = new Date( 0, 0, 1 );
			var d2 : Date = new Date( 0, 6, 1 );

			// largest value has no DST modifier
			var tzd : Number = Math.max( d1.timezoneOffset, d2.timezoneOffset );

			// convert to milliseconds
			return tzd * 60000;
		}

		public function setTime( time : Number ) : void
		{
			machineTime = time;
			stopWatch.start();
		}

		public function get time() : Number
		{
			return ( machineTime + stopWatch.time + _advanceTime );
		}
	}

}

class SingletonEnforcer
{
}
