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

	import totem.utils.MobileUtil;

	public class AppURL
	{

		public static var ACHIEVEMENTS : URLManager;

		public static var ANIMATIONS : URLManager;

		public static var APPLICATION : URLManager;

		public static var ASSETS : URLManager;

		public static var DATA : URLManager;

		public static var FONTS : URLManager;

		public static var IMAGES : URLManager;

		public static var READER : URLManager;

		public static var READER_ASSETS : URLManager;

		public static var RESOURCE : URLManager;

		public static var SOUNDS : URLManager;

		public static var SWFS : URLManager;

		public static var UI : URLManager;

		public static var UNITS : URLManager;

		private static var SIZE : URLManager;

		public static function getURL( url : String, location : URLManager ) : String
		{
			return location.getURL( url );
		}

		public static function initialize( url : String ) : void
		{
			var res : String = ( MobileUtil.isHD()) ? "2x" : "1x";

			APPLICATION = URLManager.instance( url );

			RESOURCE = URLManager.instance( APPLICATION.getURL( "res" ));

			SIZE = URLManager.instance( RESOURCE.getURL( res ));

			ASSETS = URLManager.instance( RESOURCE.getURL( "assets" ));

			DATA = URLManager.instance( RESOURCE.getURL( "data" ));

			UNITS = URLManager.instance( DATA.getURL( "units" ));

			ACHIEVEMENTS = URLManager.instance( DATA.getURL( "achievements" ));

			IMAGES = URLManager.instance( SIZE.getURL( "images" ));

			UI = URLManager.instance( SIZE.getURL( "ui" ));

			SWFS = URLManager.instance( ASSETS.getURL( "swfs" ));

			ANIMATIONS = URLManager.instance( SIZE.getURL( "animations" ));

			READER_ASSETS = URLManager.instance( SIZE.getURL( "reader" ));

			READER = URLManager.instance( RESOURCE.getURL( "reader" ));

			SOUNDS = URLManager.instance( ASSETS.getURL( "sounds" ));

			FONTS = URLManager.instance( ASSETS.getURL( "fonts" ));
		}
	}
}
