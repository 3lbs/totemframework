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

package totem.utils
{

	public class ColorUtil
	{
		public static const AQUA : uint = 0x00ffff;

		public static const BLACK : uint = 0x000000;

		public static const BLACK_ALPHA : uint = 0x00000000;

		public static const BLUE : uint = 0x0000ff;

		public static const CYAN : uint = 0x00FFFF;

		public static const FUCHSIA : uint = 0xff00ff;

		public static const GRAY : uint = 0x808080;

		public static const GREEN : uint = 0x008000;

		public static const GREY20 : uint = 0x333333;

		public static const GREY40 : uint = 0x666666;

		public static const GREY60 : uint = 0x999999;

		public static const GREY80 : uint = 0xCCCCCC;

		public static const LIME : uint = 0x00ff00;

		public static const MAGENTA : uint = 0xFF00FF;

		public static const MAROON : uint = 0x800000;

		public static const NAVY : uint = 0x000080;

		public static const OLIVE : uint = 0x808000;

		public static const PURPLE : uint = 0x800080;

		public static const RED : uint = 0xff0000;

		public static const SILVER : uint = 0xc0c0c0;

		public static const TEAL : uint = 0x008080;

		public static const WHITE : uint = 0xffffff;

		public static const WHITE_ALPHA : uint = 0xffff0000;

		public static const YELLOW : uint = 0xffff00;

		/** Returns the alpha part of an ARGB color (0 - 255). */
		public static function getAlpha( color : uint ) : int
		{
			return ( color >> 24 ) & 0xff;
		}

		/** Returns the blue part of an (A)RGB color (0 - 255). */
		public static function getBlue( color : uint ) : int
		{
			return color & 0xff;
		}

		public static function getColorFromHexString( color : String ) : uint
		{
			var r : RegExp = new RegExp( /#/g );
			var uintColor = uint( String( color ).replace( r, "0x" ));
			return uintColor;
		}

		/** Returns the green part of an (A)RGB color (0 - 255). */
		public static function getGreen( color : uint ) : int
		{
			return ( color >> 8 ) & 0xff;
		}

		public static function getHexString( color : uint ) : String
		{
			return "#" + color.toString( 16 );
		}

		/** Returns the red part of an (A)RGB color (0 - 255). */
		
		
		public static function getRandomColor () : int
		{
			return Math.random() * 0xFFFFFF;
		}
		
		
		
		public static function getRed( color : uint ) : int
		{
			return ( color >> 16 ) & 0xff;
		}

		public function ColorUtil()
		{
		}

		public static function hexToRGB( hex : Number ) : Object
		{
			var rgbObj : Object = { red: (( hex & 0xFF0000 ) >> 16 ), green: (( hex & 0x00FF00 ) >> 8 ), blue: (( hex & 0x0000FF ))};

			return rgbObj;
		}
	}
}
