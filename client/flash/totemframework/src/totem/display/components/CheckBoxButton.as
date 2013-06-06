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

	public class CheckBoxButton extends SelectedButton
	{
		private var check : DisplayObject;

		public function CheckBoxButton( mc : MovieClip )
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

		override public function set selected( value : Boolean ) : void
		{
			_selected = value ? SELECTED_SOFT : UN_SELECTED;

			if ( check )
			{
				check.visible = selected;
			}
		}
	}
}
