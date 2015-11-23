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
	import flash.filters.BitmapFilter;

	public class SelectedButton extends MovieClipButton implements IButton
	{
		protected const SELECTED : int = 10;

		protected const SELECTED_SOFT : int = 20;

		protected var SELECTED_STATE_FRAME : int = 2;

		protected const UN_SELECTED : int = 0;

		protected var _selected : int;

		private var _locked : Boolean = true;

		private var _viewed : Boolean;

		private var _viewedFilters : Array = new Array();

		public function SelectedButton( mc : MovieClip )
		{
			super( mc );
		}

		
		override public function destroy():void
		{
			_viewedFilters.length = 0;
			_viewedFilters = null;
			
			super.destroy();
		}
		
		public function get locked() : Boolean
		{
			return _locked;
		}

		public function set locked( value : Boolean ) : void
		{
			_locked = value;
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

			if ( _selected == SELECTED )
			{
				gotoAndStop( SELECTED_STATE_FRAME );
			}
			else
			{
				gotoAndStop( UP_STATE_FRAME );
			}
		}

		public function get viewed() : Boolean
		{
			return _viewed;
		}

		public function set viewed( value : Boolean ) : void
		{
			if ( value == _viewed )
				return;

			_viewed = value;

			if ( _viewedFilters.length )
			{
				var filters : Array = _movieClip.filters;
				var filter : BitmapFilter;
				var l : int = _viewedFilters.length;
				
				if ( _viewed )
				{
					while ( l-- )
					{
						filter = _viewedFilters[ l ];
						if ( filters.indexOf( filter ) == -1 )
						{
							filters.push( filter );
						}
					}
	
					_movieClip.filters = filters;
				}
				else
				{
					var idx : int;
					while ( l-- )
					{
						filter = _viewedFilters[ l ];
						if ( ( idx = filters.indexOf( filter ) ) > -1 )
						{
							filters.splice( idx, 1 );
						}
					}
				}
				
			}

		}

		public function get viewedFilters() : Array
		{
			return _viewedFilters;
		}

		public function set viewedFilters( value : Array ) : void
		{
			
			if ( value == _viewedFilters )
				return;
			
			if ( value == null )
			{
				viewed = false;
			}
			
			_viewedFilters = value;

		}

		override protected function handleMouseEvent( event : MouseEvent ) : void
		{
			if (( _selected == SELECTED && locked ) || !enabled )
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
