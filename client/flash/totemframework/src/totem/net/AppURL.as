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

package totem.net
{

	import localization.LocalizationManager;

	public class AppURL
	{

		public static var ANIMATIONS : URLManager;

		public static var APPLICATION : URLManager;

		public static var ASSETS : URLManager;

		public static var DATA : URLManager;

		public static var IMAGES : URLManager;

		public static var READER : URLManager;

		public static var READER_ASSETS : URLManager;

		public static var RESOURCE : URLManager;

		public static var SOUNDS : URLManager;

		public static var UNITS : URLManager;

		public static function getURL( url : String, location : URLManager ) : String
		{
			return location.getURL( url );
		}

		public static function initialize( url : String ) : void
		{
			APPLICATION = URLManager.instance( url );

			RESOURCE = URLManager.instance( APPLICATION.getURL( "resources" ));

			ASSETS = URLManager.instance( RESOURCE.getURL( "assets" ));

			DATA = URLManager.instance( RESOURCE.getURL( "data" ));

			UNITS = URLManager.instance( DATA.getURL( "units" ));

			IMAGES = URLManager.instance( ASSETS.getURL( "images" ));

			ANIMATIONS = URLManager.instance( ASSETS.getURL( "animations" ));

			var readerRaw : URLManager = URLManager.instance( RESOURCE.getURL( "reader" ));

			READER_ASSETS = URLManager.instance( readerRaw.getURL( "assets" ));

			READER = URLManager.instance( readerRaw.getURL( LocalizationManager.getCurrentLocale().split("-").join("_")));

			SOUNDS = URLManager.instance( ASSETS.getURL( "sounds" ));
		}
	}
}
