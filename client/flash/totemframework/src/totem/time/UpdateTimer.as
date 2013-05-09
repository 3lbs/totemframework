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

package totem.time
{

	import flash.utils.clearTimeout;
	import flash.utils.setInterval;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.core.Destroyable;

	public class UpdateTimer extends Destroyable
	{

		public var updateSignal : ISignal = new Signal();

		private var _interval : Number;

		private var _timer : uint;

		private var isRunning : Boolean;

		public function UpdateTimer( time : Number = 1000 )
		{
			super();
			_interval = time;
		}

		override public function destroy() : void
		{
			super.destroy();

			if ( isRunning )
				stop();

			updateSignal.removeAll();
			updateSignal = null;
		}

		public function get interval() : Number
		{
			return _interval;
		}

		public function set interval( value : Number ) : void
		{
			_interval = value;
		}

		public function start() : void
		{
			if ( isRunning )
				return;

			isRunning = true;
			_timer = setInterval( onTick, _interval );
		}

		public function stop() : void
		{
			isRunning = false;
			clearTimeout( _timer );
		}

		protected function onTick() : void
		{
			updateSignal.dispatch();
		}
	}
}
