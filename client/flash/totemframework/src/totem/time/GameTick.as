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
	
	import org.osflash.signals.Signal;
	
	import totem.core.IDestroyable;

	/**
	 * Clock system.
	 */
	public final class GameTick extends Signal implements IDestroyable //implements ISystem
	{

		public var TICKS_PER_SECOND : int = 60;

		/**
		 * The rate at which ticks are fired, in seconds.
		 */
		public var TICK_RATE : Number = 1.0 / Number( TICKS_PER_SECOND );

		private var _destroyed : Boolean;

		private var _displayObject : DisplayObject;

		public function GameTick( display : DisplayObject )
		{
			super( Number );

			_displayObject = display;

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

		protected function handleAddToStage( event : Event ) : void
		{
			_displayObject.removeEventListener( Event.ADDED_TO_STAGE, handleAddToStage );
			_displayObject.addEventListener( Event.ENTER_FRAME, tick );
		}

		private function tick( e : Event ) : void
		{
			dispatch( TICK_RATE );
		}
	}
}

