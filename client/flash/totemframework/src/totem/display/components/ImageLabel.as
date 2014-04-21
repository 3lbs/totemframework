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
	import flash.text.TextField;

	import totem.events.RemovableEventDispatcher;

	public class ImageLabel extends RemovableEventDispatcher
	{
		private var _enabled : Boolean;

		private var _label : TextField;

		private var _labelText : String;

		private var _movieClip : MovieClip;

		public function ImageLabel( mc : MovieClip )
		{
			_movieClip = mc;
			_movieClip.gotoAndStop( 1 );

			findLabel();

			_enabled = true;
		}

		override public function destroy() : void
		{
			_label = null;

			_movieClip = null;

			super.destroy();
		}

		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled( value : Boolean ) : void
		{
			_enabled = value;

			var frame : int = ( value ) ? 1 : 2;
			_movieClip.gotoAndStop( frame );
			
			refresh();
		}

		/**
		 * Refresh button display.
		 */
		protected function refresh() : void
		{
			
			findLabel();
			
			if ( _label && _labelText )
			{
				setLabel( _labelText );
			}
			
		}
		
		public function setLabel( value : String ) : void
		{

			_labelText = value;

			if ( _label )
			{
				_label.htmlText = value;
			}
		}

		protected function findLabel() : void
		{
			// Detect button & label
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
