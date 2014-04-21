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

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class SelectedButton extends MovieClipButton implements IButton
	{
		protected const SELECTED : int = 10;

		protected const SELECTED_SOFT : int = 20;

		protected var SELECTED_STATE_FRAME : int = 2;

		protected const UN_SELECTED : int = 0;

		protected var _selected : int;

		public function SelectedButton( mc : MovieClip )
		{
			super( mc );
		}

		public function get selected() : Boolean
		{
			return _selected != UN_SELECTED;
		}

		public function set selected( value : Boolean ) : void
		{

			if ( !enabled )
			{
				return;
			}

			_selected = value ? SELECTED : UN_SELECTED;

			if ( _selected )
			{
				gotoAndStop( SELECTED_STATE_FRAME );
			}
			else
			{
				gotoAndStop( UP_STATE_FRAME );
			}
		}

		override protected function handleMouseEvent( event : MouseEvent ) : void
		{
			if ( _selected == SELECTED || !enabled )
			{
				return;
			}

			switch ( event.type )
			{
				case MouseEvent.CLICK:
				{
					selected = !selected;
					break;
				}
			}

			super.handleMouseEvent( event );
		}
	}
}
