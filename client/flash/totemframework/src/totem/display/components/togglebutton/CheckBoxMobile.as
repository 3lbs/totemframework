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

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class CheckBoxMobile extends ToggleButton
	{
		public function CheckBoxMobile( mc : MovieClip, data : Object = null )
		{
			super( mc, data );

		}

		/**
		 * Mouse handler function.
		 */
		override protected function handleMouseEvent( event : MouseEvent ) : void
		{
			if ( !enabled )
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
			
			dispatchEvent( event.clone());
		}
	}
}
