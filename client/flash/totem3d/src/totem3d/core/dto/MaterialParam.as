//------------------------------------------------------------------------------
//
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem3d.core.dto
{
	import totem.core.params.BaseParam;
	
	
	public class MaterialParam extends BaseParam
	{
		
		
		public function MaterialParam()
		{
			super ();
		}
		
		public var alphaBlending : Boolean = false;
		
		public var alphaThreshold : Number = 0;
		
		public var alphaTexture : String;
		
		public var ambientColor : uint = 0xFFFFFF;
		
		public var ambientStrength : Number;
		
		public var bothSides : Boolean = false;
		
		public var diffuseTexture : String;
		
		public var glossStrength : uint = 0;
		
		public var glossTexture : String;
		
		public var normalTexture : String;
		
		public var repeat : Boolean = true;
		
		public var specularColor : uint = 0xFFFFFF;
		
		public var specularStrength : Number;
		
		public var specularTexture : String;
		
		public var twoSided : Boolean = false;
		
		public var useLight : Boolean = true;
	}
}

