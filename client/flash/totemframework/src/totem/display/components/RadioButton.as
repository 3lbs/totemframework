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

	public class RadioButton extends SelectedButton
	{

		private var check : DisplayObject;

		public function RadioButton( mc : MovieClip )
		{
			super( mc );

			for ( var i : int = 0; i < mc.numChildren; i++ )
			{
				var child : DisplayObject = mc.getChildAt( i );

				// Label
				if ( child.name == "check" )
				{
					check = child;
				}
			}

		}

		override public function set enabled( value : Boolean ) : void
		{

			if ( value )
			{
				check.visible = selected;
			}
			else
			{
				check.visible = false;
			}

			super.enabled = value;
		}

		override public function set selected( value : Boolean ) : void
		{

			if ( !enabled )
			{
				return;
			}

			_selected = value ? SELECTED_SOFT : UN_SELECTED;

			if ( check )
			{
				check.visible = selected;

			}
		}

		override protected function handleMouseEvent( event : MouseEvent ) : void
		{
			if ( _selected == SELECTED_SOFT || !enabled )
			{
				return;
			}

			super.handleMouseEvent( event );
		}
	}
}
