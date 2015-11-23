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

package totem.display
{

	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
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

		public static function exportPNG( path : String, bitmapData : BitmapData ) : void
		{
			var ba : ByteArray = PNGEncoder.encode( bitmapData );
			var file : File = new File( path );
			
			trace( file.nativePath );
			
			var fileStream : FileStream = new FileStream();
			fileStream.open( file, FileMode.WRITE );
			fileStream.writeBytes( ba );
			fileStream.close();

		}

		public static function generateCheckerboard( width : int, height : int, cellWidth : int = 32, cellHeight : int = 32, color1 : uint = 0xffe7e6e6, color2 : uint = 0xffd9d5d5 ) : BitmapData
		{
			var bitmapData : BitmapData = new BitmapData( width, height );
			var numRows : int = Math.ceil( height / cellHeight );
			var numCols : int = Math.ceil( width / cellWidth );

			var clipRect : Rectangle = new Rectangle( 0, 0, cellWidth, cellHeight );

			var y : int;
			var x : int;
			var lastColor : uint = color1;

			for ( y = 0; y < numRows; y++ )
			{
				for ( x = 0; x < numCols; x++ )
				{
					clipRect.y = y * cellHeight;
					clipRect.x = x * cellWidth;
					bitmapData.fillRect( clipRect, lastColor );

					lastColor = ( lastColor == color1 ) ? color2 : color1;

					if ( x + 1 == numCols && x % 2 != 0 )
						lastColor = ( lastColor == color1 ) ? color2 : color1;
				}
			}

			return bitmapData;
		}

		private static function filterEmptyPixels( item : uint, idx : uint, vector : Vector.<uint> ) : Boolean
		{
			return item != 0;
		}
	}
}

