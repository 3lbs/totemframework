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

package totem.net
{

	import flash.filesystem.File;


	public class MobileURLConfig
	{

		public static const APPLICATION_DIRECTORY : URLManager = URLManager.instance( File.applicationDirectory.nativePath );

		public static const RESOURCE_DIRECTORY : URLManager = URLManager.instance( APPLICATION_DIRECTORY.getURL( "resources" ) );
		
		public static const ASSETS_DIRECTORY : URLManager = URLManager.instance( RESOURCE_DIRECTORY.getURL( "assets" ) );

		public static const DATA_DIRECTORY : URLManager = URLManager.instance( RESOURCE_DIRECTORY.getURL( "data" ) );
		
	}
}
