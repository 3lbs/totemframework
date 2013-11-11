/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package totem.core.input.simple
{

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import totem.core.time.ITicked;
	import totem.events.RemovableEventDispatcher;

	/**
	 * The input manager wraps the default input events produced by Flash to make
	 * them more game friendly. For instance, by default, Flash will dispatch a
	 * key down event when a key is pressed, and at a consistent interval while it
	 * is still held down. For games, this is not very useful.
	 *
	 * <p>The InputMap class contains several constants that represent the keyboard
	 * and mouse. It can also be used to facilitate responding to specific key events
	 * (OnSpacePressed) rather than generic key events (OnKeyDown).</p>
	 *
	 * @see InputMap
	 */
	public class InputManager extends RemovableEventDispatcher implements ITicked
	{
		private var stage : DisplayObject;

		private var _enabled : Boolean = false;

		private var _x : Number = 0;

		private var _y : Number = 0;

		/**
		 * Mouse X coordinate in stage coordinate system.
		 */
		public function get x() : Number
		{
			return _x;
		}

		/**
		 * Mouse Y coordinate in stage coordinate system.
		 */
		public function get y() : Number
		{
			return _y;
		}

		private var _prevX : Number = 0;

		private var _prevY : Number = 0;

		private var _dx : Number = 0;

		private var _dy : Number = 0;

		private var _downStatus : Boolean = false;

		private static var _instance : InputManager;

		public function InputManager( enforcer : InputSingletonEnforcer )
		{
			if ( !enforcer )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );
		}

		public static function getInstance() : InputManager
		{
			return _instance ||= new InputManager( new InputSingletonEnforcer());
		}

		/**
		 * @inheritDoc
		 */
		public function onTick() : void
		{

		}

		public function set mouseDispatcher( value : DisplayObject ) : void
		{
			if ( value )
			{
				_enabled = true;
				stage = value;
				stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
				//stage.addEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
				stage.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			}
			else
			{
				_enabled = false;
				stage.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
				//stage.removeEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
				stage.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );

				removeEventListeners();
			}
		}

		/**
		 * Simulates clicking the mouse button.
		 */
		public function simulateMouseDown() : void
		{
			dispatchEvent( new MouseEvent( MouseEvent.MOUSE_DOWN ));
		}

		/**
		 * Simulates releasing the mouse button.
		 */
		public function simulateMouseUp() : void
		{
			dispatchEvent( new MouseEvent( MouseEvent.MOUSE_UP ));
		}

		/**
		 * Simulates moving the mouse button. All this does is dispatch a mouse
		 * move event since there is no way to change the current cursor position
		 * of the mouse.
		 */
		public function simulateMouseMove() : void
		{
			dispatchEvent( new MouseEvent( MouseEvent.MOUSE_MOVE, true, false, Math.random() * 100, Math.random() * 100 ));
		}

		public function simulateMouseOver() : void
		{
			dispatchEvent( new MouseEvent( MouseEvent.MOUSE_OVER ));
		}

		public function simulateMouseOut() : void
		{
			dispatchEvent( new MouseEvent( MouseEvent.MOUSE_OUT ));
		}

		public function simulateMouseWheel() : void
		{
			dispatchEvent( new MouseEvent( MouseEvent.MOUSE_WHEEL ));
		}

		private function onMouseDown( event : MouseEvent ) : void
		{
			if ( _enabled )
			{
				stage.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
				stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
				stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
				dispatchEvent( event );
			}
		}

		private function onMouseUp( event : MouseEvent ) : void
		{
			if ( _enabled )
			{
				stage.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
				stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
				dispatchEvent( event );
			}
		}

		private function onMouseMove( event : MouseEvent ) : void
		{
			if ( _enabled )
			{
				//record previous position
				_prevX = _x;
				_prevY = _y;

				//record current position
				_x = stage.mouseX;
				_y = stage.mouseY;

				//calculate difference between frames
				_dx = _x - _prevX;
				_dy = _y - _prevY;

				//handle initial NaN exceptions when stage starts up
				if ( isNaN( _dx ))
					_dx = 0;

				if ( isNaN( _dy ))
					_dy = 0;
				dispatchEvent( event );
			}
		}

		private function onMouseOver( event : MouseEvent ) : void
		{
			if ( _enabled )
				dispatchEvent( event );
		}

		private function onMouseOut( event : MouseEvent ) : void
		{
			if ( _enabled )
				dispatchEvent( event );
		}

	/*private function onMouseWheel( event : MouseEvent ) : void
	{
		if ( _enabled )
			dispatchEvent( event );
	}*/

	}
}

class InputSingletonEnforcer
{
}
