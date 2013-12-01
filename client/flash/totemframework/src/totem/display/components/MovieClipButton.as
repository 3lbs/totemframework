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

package totem.display.components
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import totem.events.RemovableEventDispatcher;

	public class MovieClipButton extends RemovableEventDispatcher
	{

		protected var DOWN_STATE_FRAME : int = 3;

		protected var INACTIVE_STATE_FRAME : int = 4;

		protected var OVER_STATE_FRAME : int = 2;

		protected var UP_STATE_FRAME : int = 1;

		/** @var Reference to MovieClip */
		protected var _movieClip : MovieClip;

		private var _data : Object;

		/** @var Reference to TextField */
		private var _label : TextField;

		private var _name : String;

		private var enabled : Boolean;

		private var isDown : Boolean;

		public function MovieClipButton( mc : MovieClip )
		{
			_movieClip = mc;
			_movieClip.gotoAndStop( 1 );
			_movieClip.buttonMode = true;
			_movieClip.useHandCursor = true;

			// Detect button & label
			for ( var i : int = 0; i < mc.numChildren; i++ )
			{
				var child : DisplayObject = mc.getChildAt( i );

				// Label
				if ( child is TextField )
				{
					_label = child as TextField;

					_label.text = "";
					_label.mouseEnabled = false;
					_label.selectable = false;
				}
			}

			enable();
			// Add event listeners
			attachButtonListeners();
		}

		/**
		 * @return	Alpha value of the button
		 */
		public function get alpha() : Number
		{
			return _movieClip.alpha;
		}

		/**
		 * Sets the alpha value of the button.
		 *
		 * @param	a_alpha		New alpha value
		 */
		public function set alpha( a_alpha : Number ) : void
		{
			_movieClip.alpha = a_alpha;
		}

		public function get data() : Object
		{
			return _data;
		}

		public function set data( value : Object ) : void
		{
			_data = value;
		}

		/**
		 * Clean up.
		 */
		override public function destroy() : void
		{
			detachButtontListeners();
			super.destroy();

			_movieClip = null;

			_label = null;
		}

		/**
		 * Disable the button.
		 */
		public function disable() : void
		{
			detachButtontListeners();

			enabled = false;
			gotoAndStop( INACTIVE_STATE_FRAME );

			_movieClip.mouseEnabled = false;
		}

		/**
		 * Enable the button.
		 */
		public function enable() : void
		{
			attachButtonListeners();

			enabled = true;
			_movieClip.mouseEnabled = true;

			gotoAndStop( UP_STATE_FRAME );
		}

		public function gotoAndStop( frame : int ) : void
		{
			_movieClip.gotoAndStop( frame );
			refresh();
		}

		/**
		 * @return	Height of the button
		 */
		public function get height() : Number
		{
			return _movieClip.height;
		}

		/**
		 * @return	Reference to label TextField
		 */
		public function get label() : TextField
		{
			return _label;
		}

		/**
		 * @return	Reference to MovieClip container
		 */
		public function get movieClip() : MovieClip
		{
			return _movieClip;
		}

		public function get name() : String
		{
			return _name;
		}

		public function set name( value : String ) : void
		{
			_name = value;
		}

		/**
		 * Set the label text.
		 *
		 * @param	a_text	Label text
		 */
		public function setText( t : String ) : void
		{
			if ( _label )
			{
				_label.text = t;
			}
		}

		/**
		 * @return	Visibility of the button
		 */
		public function get visible() : Boolean
		{
			return _movieClip.visible;
		}

		/**
		 * Sets the visibility of the button.
		 *
		 * @param	a_visible	Visibility of the button
		 */
		public function set visible( value : Boolean ) : void
		{
			_movieClip.visible = value;
		}

		/**
		 * @return	Width of the button
		 */
		public function get width() : Number
		{
			return _movieClip.width;
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
			if ( !enabled )
			{
				return;
			}

			switch ( event.type )
			{
				case MouseEvent.ROLL_OVER:
				case MouseEvent.MOUSE_OVER:
					gotoAndStop( OVER_STATE_FRAME );
					break;
				case MouseEvent.MOUSE_DOWN:
					gotoAndStop( DOWN_STATE_FRAME );
					break;
				case MouseEvent.ROLL_OUT:
				case MouseEvent.MOUSE_OUT:
				case MouseEvent.MOUSE_UP:
				case MouseEvent.CLICK:
				{
					gotoAndStop( UP_STATE_FRAME );
					break;
				}
			}
			
			event.stopImmediatePropagation();

			dispatchEvent( event.clone());
		}

		/**
		 * Refresh button display.
		 */
		protected function refresh() : void
		{
			if ( _label )
			{
				setText( _label.text );
			}
			
		}

		protected function resetContent() : void
		{
			refresh();
			gotoAndStop( UP_STATE_FRAME );
		}
	}
}
