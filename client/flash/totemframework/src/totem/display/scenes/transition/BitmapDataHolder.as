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

package totem.display.scenes.transition
{

	import flash.display.BitmapData;

	public class BitmapDataHolder
	{
		public var bitmapData : BitmapData

		public function BitmapDataHolder()
		{
		}
		
		public function dispose () : void
		{
			if ( bitmapData )
				bitmapData.dispose();
		}
	}
}
