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

package totem3d.core.param
{

	import totem.core.params.BaseParam;

	public class TextureCompositeParam extends BaseParam
	{

		public var diffuseBitmapData : String = "";

		public var height : Number = 0;

		public var specularBitmapData : String = "";

		public var width : Number = 0;

		public function TextureCompositeParam()
		{
			super();
		}
	}
}
