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

package totem.utils
{

	
	
	
	
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	import org.casalib.util.StageReference;

	/**
	 * This class provides mobile devices information.
	 */
	public class MobileUtil
	{

		private static const _ANDROID_HD_HEIGHT : uint = 2560;

		private static const _ANDROID_HD_WIDTH : uint = 1600;

		private static const _IOS_MARGIN : uint = 40;

		private static const _IPAD_HEIGHT : uint = 1024;

		private static const _IPAD_RETINA_HEIGHT : uint = 2048;

		private static const _IPAD_RETINA_WIDTH : uint = 1536;

		private static const _IPAD_WIDTH : uint = 768;

		private static const _IPHONE5_RETINA_HEIGHT : uint = 1136;

		private static const _IPHONE_RETINA_HEIGHT : uint = 960;

		private static const _IPHONE_RETINA_WIDTH : uint = 640;

		private static var _STAGE : Stage;

		private static var _viewRect : Rectangle;

		public static function getViewHeight() : Number
		{
			return viewRect().height;
		}

		public static function getViewWidth() : Number
		{
			return viewRect().width;
		}

		public static function get iOS_MARGIN() : uint
		{
			return _IOS_MARGIN;
		}

		public static function get iPAD_HEIGHT() : uint
		{
			return _IPAD_HEIGHT;
		}

		public static function get iPAD_RETINA_HEIGHT() : uint
		{
			return _IPAD_RETINA_HEIGHT;
		}

		public static function get iPAD_RETINA_WIDTH() : uint
		{
			return _IPAD_RETINA_WIDTH;
		}

		public static function get iPAD_WIDTH() : uint
		{
			return _IPAD_WIDTH;
		}

		public static function get iPHONE5_RETINA_HEIGHT() : uint
		{
			return _IPHONE5_RETINA_HEIGHT;
		}

		public static function get iPHONE_RETINA_HEIGHT() : uint
		{
			return _IPHONE_RETINA_HEIGHT;
		}

		public static function get iPHONE_RETINA_WIDTH() : uint
		{
			return _IPHONE_RETINA_WIDTH;
		}

		public static function isAndroid() : Boolean
		{
			return ( Capabilities.version.substr( 0, 3 ) == "AND" );
		}

		public static function isAndroidDevice() : Boolean
		{
			return Capabilities.manufacturer.indexOf( 'Android' ) > -1;
		}

		public static function isHD() : Boolean
		{

			if ( isIOS())
			{
				return isRetina();
			}
			else
			{
				if ( !_STAGE )
					_STAGE = StageReference.getStage();

				if ( isLandscapeMode())
					return ( _STAGE.fullScreenWidth == _ANDROID_HD_HEIGHT );
				else
					return ( _STAGE.fullScreenWidth == _ANDROID_HD_WIDTH );

			}

			return false;
		}

		public static function isIOS() : Boolean
		{
			return ( Capabilities.version.substr( 0, 3 ) == "IOS" );
		}

		public static function isIOSDevice() : Boolean
		{
			return Capabilities.manufacturer.indexOf( "iOS" ) > -1;
		}

		public static function isIpad() : Boolean
		{

			if ( MobileUtil.isIOS())
			{

				if ( !_STAGE )
					_STAGE = StageReference.getStage();

				if ( isLandscapeMode())
					return ( _STAGE.fullScreenWidth == _IPAD_HEIGHT || _STAGE.fullScreenWidth == _IPAD_RETINA_HEIGHT || _STAGE.fullScreenHeight == _IPAD_HEIGHT || _STAGE.fullScreenHeight == _IPAD_RETINA_HEIGHT );
				else
					return ( _STAGE.fullScreenWidth == _IPAD_WIDTH || _STAGE.fullScreenWidth == _IPAD_RETINA_WIDTH || _STAGE.fullScreenHeight == _IPAD_WIDTH || _STAGE.fullScreenHeight == _IPAD_RETINA_WIDTH );

			}
			else
				return false;
		}

		public static function isIphone5() : Boolean
		{

			if ( MobileUtil.isIOS())
			{

				if ( !_STAGE )
					_STAGE = StageReference.getStage();

				return ( _STAGE.fullScreenHeight == _IPHONE5_RETINA_HEIGHT || _STAGE.fullScreenHeight == MobileUtil._IPHONE5_RETINA_HEIGHT - _IOS_MARGIN );

			}
			else
				return false;
		}

		public static function isLandscapeMode() : Boolean
		{

			if ( !_STAGE )
				_STAGE = StageReference.getStage();

			return ( _STAGE.fullScreenWidth > _STAGE.fullScreenHeight );
		}

		public static function isRetina() : Boolean
		{

			if ( MobileUtil.isIOS())
			{

				if ( !_STAGE )
					_STAGE = StageReference.getStage();

				if ( isLandscapeMode())
					return ( _STAGE.fullScreenWidth == _IPHONE_RETINA_HEIGHT || _STAGE.fullScreenWidth == _IPHONE5_RETINA_HEIGHT || _STAGE.fullScreenWidth == _IPAD_RETINA_HEIGHT || _STAGE.fullScreenHeight == _IPHONE_RETINA_HEIGHT || _STAGE.fullScreenHeight == _IPHONE5_RETINA_HEIGHT || _STAGE.fullScreenHeight == _IPAD_RETINA_HEIGHT );
				else
					return ( _STAGE.fullScreenWidth == _IPHONE_RETINA_WIDTH || _STAGE.fullScreenWidth == _IPAD_RETINA_WIDTH || _STAGE.fullScreenHeight == _IPHONE_RETINA_WIDTH || _STAGE.fullScreenHeight == _IPAD_RETINA_WIDTH );

			}
			else
				return false;
		}

		public static function isSlowMachine() : Boolean
		{

			var capabilites : String = Capabilities.os.toLowerCase();

			if ( capabilites.indexOf( "ipad1" ) > -1 )
				return true;

			if ( isHD())
				return false;

			return false;
		}

		public static function resetViewRect() : void
		{
			_viewRect = null;
		}

		public static function viewRect() : Rectangle
		{
			if ( !_STAGE )
				_STAGE = StageReference.getStage();

			return _viewRect ||= ( isIOS() ? new Rectangle( 0, 0, _STAGE.fullScreenWidth, _STAGE.fullScreenHeight ) : new Rectangle( 0, 0, _STAGE.stageWidth, _STAGE.stageHeight ));
		}
	}
}
