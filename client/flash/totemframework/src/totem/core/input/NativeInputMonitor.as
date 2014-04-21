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

package totem.core.input
{

	import flash.display.Stage;
	import flash.events.MouseEvent;

	import totem.core.Destroyable;

	public class NativeInputMonitor extends Destroyable implements IInputMonitor
	{

		private var _enabled : Boolean = true;

		private var _observers : IMobileInput;

		private var _stage : Stage;

		public function NativeInputMonitor( stage : Stage )
		{
			super();

			_stage = stage;

			_stage.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );
			_stage.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp );
		}

		override public function destroy() : void
		{
			enabled = false;

			super.destroy();
		}

		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled( value : Boolean ) : void
		{
			_enabled = value;

			if ( _enabled )
			{
				_stage.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );
				_stage.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp );
			}
			else
			{
				_stage.removeEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );
				_stage.removeEventListener( MouseEvent.MOUSE_UP, handleMouseUp );
			}
		}

		public function subscribe( input : IMobileInput ) : void
		{
			_observers = input;
		}

		public function unSubscribe( input : IMobileInput ) : void
		{
			_observers = null;
		}

		protected function handleMouseDown( event : MouseEvent ) : void
		{
			if ( enabled )
			{
				_stage.addEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
				//_observers.handleTouchBegin( event.stageX, event.stageY );
			}
		}

		protected function handleMouseMove( event : MouseEvent ) : void
		{
			if ( enabled && _observers )
			{
				//_observers.handleTouchMove( event.stageX, event.stageY );
			}
		}

		protected function handleMouseUp( event : MouseEvent ) : void
		{
			if ( enabled && _observers )
			{
				_stage.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );
				_stage.removeEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
				//_observers.handleTouchEnd( event.stageX, event.stageY );
			}
		}
	}
}
