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

	public class Model3DParam extends URLAssetParam
	{

		public var frameSpeed : Number = 1;

		public var scale : Number = 1;

		public var textureURL : String = "";

		public var updateRoot : Boolean = false;
			
		public var materialName : String;
		
		
		public function Model3DParam()
		{
			
		}
	}
}

