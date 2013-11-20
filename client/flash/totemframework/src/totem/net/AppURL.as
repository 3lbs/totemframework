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

	public class AppURL
	{

		public static var APPLICATION : URLManager;

		public static var ASSETS : URLManager;

		public static var DATA : URLManager;

		public static var RESOURCE : URLManager;

		public static function initialize( url : String ) : void
		{
			APPLICATION = URLManager.instance( url );

			RESOURCE = URLManager.instance( APPLICATION.getURL( "resources" ));

			ASSETS = URLManager.instance( RESOURCE.getURL( "assets" ));

			DATA = URLManager.instance( RESOURCE.getURL( "data" ));
		}
	}
}
