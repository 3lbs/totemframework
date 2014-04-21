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

package totem.core.mvc.modular.mvcs
{

	import flash.utils.getTimer;

	import totem.core.time.ITicked;

	public class TimedModuleActor extends ModuleActor implements ITicked
	{

		private var _interval : Number = 0;

		private var _lastUpdate : Number = 0;

		public function TimedModuleActor()
		{
			super();
		}

		public function get interval() : Number
		{
			return _interval;
		}

		public function set interval( value : Number ) : void
		{
			_interval = value;
		}

		public final function onTick() : void
		{
			var time : Number = getTimer();

			var delta : Number = time - _lastUpdate;

			if ( delta < _interval )
			{
				return;
			}

			_lastUpdate = time;

			update( delta );
		}

		protected function update( time : Number ) : void
		{

		}
	}
}
