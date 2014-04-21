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

	public class AtlasDataParam
	{

		public var atlasHDURL : String;

		public var atlasURL : String;

		public var generateMipMaps : Boolean;

		public var imageURL : String;

		public var id : String;

		public var imageHDURL : String;

		public function AtlasDataParam()
		{
			super();
		}

		public function getAtlasURL( hd : Boolean = false ) : String
		{
			return ( hd ) ? atlasHDURL : atlasURL;
		}
	}
}
