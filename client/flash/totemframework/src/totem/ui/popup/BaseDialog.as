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

package totem.ui.popup
{

	import totem.display.layout.TSprite;
	import totem.math.BoxRectangle;

	public class BaseDialog extends TSprite
	{

		public var completed : Boolean = true;

		public var dialogRect : BoxRectangle;

		private var _initalized : Boolean;

		public function BaseDialog()
		{
			initialize();
		}

		public function close() : void
		{

		}

		override public function set scaleX( value : Number ) : void
		{
			if ( dialogRect )
			{
				dialogRect.multiply( value );
			}

			super.scaleX = value;
		}

		protected function initialize() : void
		{

		}
	}
}
