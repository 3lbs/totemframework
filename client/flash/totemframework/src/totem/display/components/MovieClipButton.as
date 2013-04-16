
package totem.display.components
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import totem.events.RemovableEventDispatcher;

	public class MovieClipButton extends RemovableEventDispatcher
	{
		private static const VERTICAL_PADDING : Number = 10.0;

		private static const HORIZONTAL_PADDING : Number = 28.0;

		/** @var Reference to MovieClip */
		protected var _movieClip : MovieClip;

		/** @var Reference to TextField */
		private var _label : TextField;

		/** @var Horizontal button padding */
		private var _horizontalPadding : Number;

		/** @var Vertical button padding */
		private var _verticalPadding : Number;

		private var enabled : Boolean;

		protected var INACTIVE_FRAME : int = 1;

		protected var ACTIVE_FRAME : int = 2;

		private var isDown : Boolean;

		public function MovieClipButton( mc : MovieClip )
		{
			_movieClip = mc;
			_movieClip.gotoAndStop( 1 );

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
					_label.autoSize = TextFieldAutoSize.CENTER;
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
		private function handleMouseEvent( event : MouseEvent ) : void
		{
			if ( !enabled )
			{
				return;
			}

			switch ( event.type )
			{
				case MouseEvent.ROLL_OVER:
				case MouseEvent.MOUSE_DOWN:
				case MouseEvent.MOUSE_OVER:
				case MouseEvent.CLICK:
				{
					isDown = true;
					movieClip.gotoAndStop( ACTIVE_FRAME );
					break;
				}
				case MouseEvent.ROLL_OUT:
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_OUT:
				{
					isDown = false;
					movieClip.gotoAndStop( INACTIVE_FRAME );
					break;
				}
			}

			/*if ( isDown && event.type == MouseEvent.MOUSE_MOVE )
			{
				if ( event.localX < movieClip.x ||
					event.localY < movieClip.y ||
					event.movementX > 10 ||
					event.movementY > 10 )
				{
					resetContent();
				}
			}*/

			if ( isDown )
			{
				dispatchEvent( event.clone());
			}

			//dispatchEvent( event.clone() );
		}

		protected function resetContent() : void
		{
			movieClip.gotoAndStop( INACTIVE_FRAME );
			isDown = false;
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

		/**
		 * Enable the button.
		 */
		public function enable() : void
		{
			attachButtonListeners();

			enabled = true;

			_movieClip.gotoAndStop( INACTIVE_FRAME );
			_movieClip.mouseEnabled = true;

			refresh();
		}

		public function gotoAndStop( frame : int ) : void
		{
			_movieClip.gotoAndStop( frame );

			refresh();
		}

		/**
		 * Disable the button.
		 */
		public function disable() : void
		{
			detachButtontListeners();

			enabled = false;
			_movieClip.gotoAndStop( _movieClip.totalFrames );

			_movieClip.mouseEnabled = false;

			refresh();
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
		 * Sets the alpha value of the button.
		 *
		 * @param	a_alpha		New alpha value
		 */
		public function set alpha( a_alpha : Number ) : void
		{
			_movieClip.alpha = a_alpha;
		}

		/**
		 * @return	Alpha value of the button
		 */
		public function get alpha() : Number
		{
			return _movieClip.alpha;
		}

		/**
		 * @return	Width of the button
		 */
		public function get width() : Number
		{
			return _movieClip.width;
		}

		/**
		 * @return	Height of the button
		 */
		public function get height() : Number
		{
			return _movieClip.height;
		}

		/**
		 * @return	Reference to MovieClip container
		 */
		public function get movieClip() : MovieClip
		{
			return _movieClip;
		}

		/**
		 * @return	Reference to label TextField
		 */
		public function get label() : TextField
		{
			return _label;
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

	}
}
