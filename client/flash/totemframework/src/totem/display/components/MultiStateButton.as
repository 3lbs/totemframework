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

package totem.display.components
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	import totem.events.RemovableEventDispatcher;
	import totem.utils.DestroyUtil;

	public class MultiStateButton extends RemovableEventDispatcher implements IButton
	{
		private var UP_STATE_FRAME : int;

		private var _currentState : ButtonState;

		private var _data : Object;

		private var _enabled : Boolean;

		/** @var Reference to TextField */
		private var _label : TextField;

		private var _labelText : String;

		private var _movieClip : MovieClip;

		private var _name : String;

		private var _selected : Boolean;

		private var states : Dictionary = new Dictionary();

		public function MultiStateButton( mc : MovieClip )
		{

			_movieClip = mc;
			_movieClip.gotoAndStop( 1 );
			_movieClip.buttonMode = true;
			_movieClip.useHandCursor = true;

			findLabel();

			attachButtonListeners();
		}

		public function addState( state : ButtonState ) : void
		{
			states[ state.name ] = state;
		}

		public function get data() : Object
		{
			if ( _currentState && _currentState.data )
			{
				return _currentState.data;
			}

			return _data;
		}

		public function set data( value : Object ) : void
		{
			_data = value;
		}

		override public function destroy() : void
		{

			detachButtontListeners();
			_movieClip = null;
			super.destroy();
			DestroyUtil.destroyDictionary( states );
			states = null;
		}

		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled( value : Boolean ) : void
		{
			_enabled = value;
		}

		public function getCurrentState() : ButtonState
		{
			return _currentState;
		}

		public function get name() : String
		{
			return _name;
		}

		public function set name( value : String ) : void
		{
			_name = value;
		}

		public function get selected() : Boolean
		{
			return _selected;
		}

		public function set selected( value : Boolean ) : void
		{
			_selected = value;
		}

		public function setState( name : String ) : void
		{
			if ( states[ name ])
			{
				_currentState = states[ name ];

				UP_STATE_FRAME = _currentState.UP_STATE_FRAME;

				resetContent();
			}
		}

		public function setText( value : String ) : void
		{
			_labelText = value;

			if ( _label )
			{
				_label.text = value;
			}
		}

		public function get stateName() : String
		{
			return _currentState ? _currentState.name : "";
		}

		/**
		 * Set up event listeners.
		 */
		protected function attachButtonListeners() : void
		{
			_movieClip.addEventListener( MouseEvent.ROLL_OVER, handleMouseEvent );
			_movieClip.addEventListener( MouseEvent.ROLL_OUT, handleMouseEvent );
			_movieClip.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseEvent );
			_movieClip.addEventListener( MouseEvent.MOUSE_UP, handleMouseEvent );
			_movieClip.addEventListener( MouseEvent.CLICK, handleMouseEvent );
			_movieClip.addEventListener( MouseEvent.MOUSE_OVER, handleMouseEvent );
			_movieClip.addEventListener( MouseEvent.MOUSE_OUT, handleMouseEvent );
		}

		/**
		 * Remove event listeners.
		 */
		protected function detachButtontListeners() : void
		{
			_movieClip.removeEventListener( MouseEvent.ROLL_OVER, handleMouseEvent );
			_movieClip.removeEventListener( MouseEvent.ROLL_OUT, handleMouseEvent );
			_movieClip.removeEventListener( MouseEvent.MOUSE_DOWN, handleMouseEvent );
			_movieClip.removeEventListener( MouseEvent.MOUSE_UP, handleMouseEvent );
			_movieClip.removeEventListener( MouseEvent.CLICK, handleMouseEvent );
			_movieClip.removeEventListener( MouseEvent.MOUSE_OVER, handleMouseEvent );
			_movieClip.removeEventListener( MouseEvent.MOUSE_OUT, handleMouseEvent );
		}

		/**
		 * Mouse handler function.
		 */
		protected function handleMouseEvent( event : MouseEvent ) : void
		{

			dispatchEvent( event.clone());

			event.updateAfterEvent();
			event.stopImmediatePropagation();
			event.stopPropagation();

		}

		/**
		 * Refresh button display.
		 */
		protected function refresh() : void
		{
			findLabel();

			if ( _label && _labelText )
			{
				setText( _labelText );
			}

		}

		protected function resetContent() : void
		{
			_movieClip.gotoAndStop( UP_STATE_FRAME );

			refresh();
		}

		private function findLabel() : void
		{
			for ( var i : int = 0; i < _movieClip.numChildren; i++ )
			{
				var child : DisplayObject = _movieClip.getChildAt( i );

				// Label
				if ( child is TextField )
				{
					_label = child as TextField;

					_label.text = "";
					_label.mouseEnabled = false;
					_label.selectable = false;
				}
			}

		}
	}
}
