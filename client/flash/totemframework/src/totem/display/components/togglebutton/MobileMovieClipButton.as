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

package totem.display.components.togglebutton
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import totem.events.RemovableEventDispatcher;

	public class MobileMovieClipButton extends RemovableEventDispatcher
	{

		private static const HORIZONTAL_PADDING : Number = 28.0;

		private static const VERTICAL_PADDING : Number = 10.0;

		protected var DISABLED_FRAME : int = 3;

		protected var INACTIVE_FRAME : int = 1;

		protected var ROLLOVER_FRAME : int = 2;

		protected var SELECTED_FRAME : int = 2;

		/** @var Reference to MovieClip */
		protected var _movieClip : MovieClip;

		protected var enabled : Boolean;

		protected var isDown : Boolean;

		private var _currentFrame : int;

		/** @var Horizontal button padding */
		private var _horizontalPadding : Number;

		/** @var Reference to TextField */
		private var _label : TextField;

		private var _name : String;

		private var _selected : Boolean = false;

		/** @var Vertical button padding */
		private var _verticalPadding : Number;

		public function MobileMovieClipButton( mc : MovieClip )
		{
			_movieClip = mc;
			goToFrame( 1 );

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
						//_label.autoSize = TextFieldAutoSize.CENTER;
				}
			}

			// Button padding
			_horizontalPadding = HORIZONTAL_PADDING;
			_verticalPadding = VERTICAL_PADDING;

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
			goToFrame( DISABLED_FRAME );

			_movieClip.mouseEnabled = false;

			refresh();
		}

		/**
		 * Enable the button.
		 */
		public function enable() : void
		{
			attachButtonListeners();

			enabled = true;

			goToFrame( INACTIVE_FRAME );
			_movieClip.mouseEnabled = true;

			refresh();

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

		public function get selected() : Boolean
		{
			return _selected;
		}

		public function set selected( value : Boolean ) : void
		{
			if ( _selected == value )
				return;

			_selected = value;

			if ( _selected )
			{
				goToFrame( SELECTED_FRAME );
			}
			else
			{
				goToFrame( INACTIVE_FRAME );
			}
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
				// Re-size button
				var textWidth : Number = _label.textWidth;
				var textHeight : Number = _label.textHeight;

				_label.text = t;

				//_movieClip.width = textWidth + 2 * _horizontalPadding;

				// Only adjust height if the text does
				// not fit within the button
				if ( _movieClip.height < textHeight )
				{
					//_movieClip.height = textHeight + 2 * _verticalPadding;
				}
			}
		}

		/**
		 * Sets the vertical padding around the text.
		 *
		 * @param	a_padding	Vertical padding (in pixels )
		 */
		public function setVerticalPadding( padding : Number ) : void
		{
			_verticalPadding = padding;

			refresh();
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

		protected function goToFrame( frame : int ) : void
		{
			movieClip.gotoAndStop( frame );
			_currentFrame = frame;
		}

		/**
		 * Mouse handler function.
		 */
		protected function handleMouseEvent( event : MouseEvent ) : void
		{
			if ( !enabled || ( selected ))
			{
				return;
			}

			switch ( event.type )
			{
				case MouseEvent.ROLL_OVER:
				case MouseEvent.MOUSE_DOWN:
				case MouseEvent.MOUSE_OVER:
				{
					isDown = true;
					goToFrame( ROLLOVER_FRAME );
					break;
				}
				case MouseEvent.ROLL_OUT:
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_OUT:
				case MouseEvent.CLICK:
				{
					isDown = false;
					goToFrame( INACTIVE_FRAME );
					break;
				}
			}

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

			goToFrame( _currentFrame );
		}

		protected function resetContent() : void
		{
			goToFrame( INACTIVE_FRAME );
			isDown = false;
		}
	}
}
