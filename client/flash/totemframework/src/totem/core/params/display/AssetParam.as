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

package totem.core.params.display
{
	import totem.core.params.GameItemParam;

	public class AssetParam extends GameItemParam
	{

		public var assetName : String;

		public var atlasID : String;

		public var height : Number = 0;

		public var offsetX : Number = 0;

		public var offsetY : Number = 0;

		public var width : Number = 0;

		public function AssetParam()
		{
			super();
		}
	}
}
