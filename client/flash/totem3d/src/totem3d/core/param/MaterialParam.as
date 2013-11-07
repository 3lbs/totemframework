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

	import totem.core.params.URLAssetParam;

	public class MaterialParam extends URLAssetParam
	{

		public var alphaBlending : Boolean = false;

		public var alphaTexture : String;

		public var alphaThreshold : Number = 0;

		public var ambientColor : uint = 0xFFFFFF;

		public var ambientStrength : Number = 1;

		public var bothSides : Boolean = false;

		public var diffuseTexture : String;

		public var glossStrength : Number = 50;

		public var glossTexture : String;

		public var normalTexture : String;

		public var repeat : Boolean = true;

		public var specularColor : uint = 0xFFFFFF;

		public var specularStrength : Number = 1;

		public var specularTexture : String;

		public var twoSided : Boolean = false;

		public var useLight : Boolean = true;

		public function MaterialParam()
		{
			super();
		}
	}
}

