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

package totem.core.time
{

	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;

	import org.osflash.signals.Signal;

	/**
	 * Clock system.
	 */
	public final class Clock extends Signal //implements ISystem
	{

		private var _stage : Stage;

		private var _timestamp : int = 0;

		public function Clock()
		{
			super( Number );
		}

		public function dispose() : void
		{
			_stage.removeEventListener( Event.ENTER_FRAME, tick );

			removeAll();
			_stage = null;
		}

		[Inject]
		public function inject( stage : Stage ) : void
		{
			_stage = stage;
		}

		public function onAdd() : void
		{
			_stage.addEventListener( Event.ENTER_FRAME, tick );
		}

		/**
		 * Current timestamp in milliseconds.
		 */
		public function get timestamp() : int
		{
			return _timestamp;
		}

		private function tick( e : Event ) : void
		{
			_timestamp = getTimer();
			dispatch( 1 / _stage.frameRate );
		}
	}
}

