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

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getTimer;

	import org.osflash.signals.Signal;

	import totem.core.IDestroyable;
	import totem.core.time.TimeManager;

	/**
	 * Clock system.
	 */
	public final class GameTick extends Signal implements IDestroyable //implements ISystem
	{

		public static var TICKS_PER_SECOND : int = 30;

		/**
		 * The rate at which ticks are fired, in seconds.
		 */
		public static var TICK_RATE : Number = 1.0 / Number( TICKS_PER_SECOND );

		public static var TICK_RATE_MS : Number = TICK_RATE * 1000;

		private var _destroyed : Boolean;

		private var _displayObject : DisplayObject;

		private var _lastTime : Number;

		private var _rate : Number;

		public function GameTick( display : DisplayObject, r : Number = 30 )
		{
			super( Number );

			_displayObject = display;

			_rate = TICK_RATE_MS;

			//1 / _displayObject.frameRate

			if ( _displayObject.stage )
			{
				_displayObject.addEventListener( Event.ENTER_FRAME, tick );
			}
			else
			{
				_displayObject.addEventListener( Event.ADDED_TO_STAGE, handleAddToStage );
			}
		}

		public function destroy() : void
		{
			_destroyed = true;

			removeAll();
			_displayObject.removeEventListener( Event.ENTER_FRAME, tick );
			_displayObject = null;
		}

		public function get destroyed() : Boolean
		{
			return _destroyed;
		}

		public function get rate() : Number
		{
			return _rate;
		}

		public function set rate( value : Number ) : void
		{
			_rate = value;
		}

		protected function handleAddToStage( event : Event ) : void
		{
			_displayObject.removeEventListener( Event.ADDED_TO_STAGE, handleAddToStage );
			_displayObject.addEventListener( Event.ENTER_FRAME, tick );
		}

		private function tick( e : Event ) : void
		{

			var time : Number = getTimer();
			var dt : Number = time - _lastTime;

			if ( dt <= _rate )
				return;

			_lastTime = time;
			dispatch( TICK_RATE );
		}
	}
}

