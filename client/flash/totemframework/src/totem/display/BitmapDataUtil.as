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

package totem.display
{

	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class BitmapDataUtil
	{

		public static function alphaPercentage( bitmapData : BitmapData ) : Number
		{

			var rect : Rectangle = bitmapData.rect;

			var pixels : Vector.<uint> = bitmapData.getVector( rect );

			var totalPixel : int = pixels.length;
			var nonEmptyPixels : Vector.<uint> = pixels.filter( filterEmptyPixels );
			var filledPixels : int = nonEmptyPixels.length;

			var percent : Number = filledPixels / totalPixel;
			return percent;
		}

		public static function byteArrayToBitmapData( bytes : ByteArray ) : BitmapData
		{
			var bd : BitmapData = new BitmapData( 1, 1 );
			var loader : Loader = new Loader();
			loader.loadBytes( bytes );
			bd.draw( loader );
			return bd;
		}

		private static function filterEmptyPixels( item : uint, idx : uint, vector : Vector.<uint> ) : Boolean
		{
			return item != 0;
		}
	}
}

