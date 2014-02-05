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

package totem.ui.popup
{

	import flash.geom.Rectangle;
	
	import totem.display.layout.TSprite;

	public class BaseDialog extends TSprite
	{
		private var _initalized : Boolean;

		public var dialogRect : Rectangle;
		
		public function BaseDialog()
		{
			//addEventListener( Event.ADDED_TO_STAGE, onInit );
			initialize();
		}

		public function close() : void
		{

		}

		protected function initialize() : void
		{

		}
	}
}
