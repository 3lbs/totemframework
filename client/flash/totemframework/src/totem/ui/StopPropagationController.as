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

package totem.ui
{

	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;

	import totem.core.Destroyable;

	public class StopPropagationController extends Destroyable
	{
		private var _container : IEventDispatcher;

		private var _enabled : Boolean;

		public function StopPropagationController( containter : IEventDispatcher )
		{
			super();

			_container = containter;
		}

		override public function destroy() : void
		{
			super.destroy();

			enabled = false;

			_container = null;
		}

		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled( value : Boolean ) : void
		{
			_enabled = ( value ) ? attachButtonListeners() : detachButtontListeners();
		}

		/**
		 * Set up event listeners.
		 */
		protected function attachButtonListeners() : Boolean
		{
			_container.addEventListener( MouseEvent.ROLL_OVER, handleMouseEvent, false, -1 );
			_container.addEventListener( MouseEvent.ROLL_OUT, handleMouseEvent, false, -1 );
			_container.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseEvent, false, -1 );
			_container.addEventListener( MouseEvent.MOUSE_UP, handleMouseEvent, false, -1 );
			_container.addEventListener( MouseEvent.CLICK, handleMouseEvent, false, -1 );
			_container.addEventListener( MouseEvent.MOUSE_OVER, handleMouseEvent, false, -1 );
			_container.addEventListener( MouseEvent.MOUSE_OUT, handleMouseEvent, false, -1 );

			return true;
		}

		/**
		 * Remove event listeners.
		 */
		protected function detachButtontListeners() : Boolean
		{
			_container.removeEventListener( MouseEvent.ROLL_OVER, handleMouseEvent );
			_container.removeEventListener( MouseEvent.ROLL_OUT, handleMouseEvent );
			_container.removeEventListener( MouseEvent.MOUSE_DOWN, handleMouseEvent );
			_container.removeEventListener( MouseEvent.MOUSE_UP, handleMouseEvent );
			_container.removeEventListener( MouseEvent.CLICK, handleMouseEvent );
			_container.removeEventListener( MouseEvent.MOUSE_OVER, handleMouseEvent );
			_container.removeEventListener( MouseEvent.MOUSE_OUT, handleMouseEvent );

			return false;
		}

		protected function handleMouseEvent( event : MouseEvent ) : void
		{
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
	}
}
