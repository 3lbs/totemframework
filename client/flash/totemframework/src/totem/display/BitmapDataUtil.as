package totem.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class BitmapDataUtil
	{
		public function BitmapDataUtil()
		{
		}
		
		public static function byteArrayToBitmapData ( bytes : ByteArray ) : BitmapData
		{
			var bd : BitmapData = new BitmapData( 1, 1 );
			var loader : Loader = new Loader();
			loader.loadBytes( bytes );
			bd.draw( loader );
			return bd;
		}
		
		
		public static function alphaPercentage( bitmapData : BitmapData ) : Number
		{
			
			var rect : Rectangle = bitmapData.rect;
			
			var pixels : Vector.<uint> = bitmapData.getVector ( rect );
			
			var totalPixel : int = pixels.length;
			var nonEmptyPixels : Vector.<uint> = pixels.filter ( filterEmptyPixels );
			var filledPixels : int = nonEmptyPixels.length;
			
			var percent : Number = filledPixels / totalPixel;
			return percent;
		}
		
		private static function filterEmptyPixels( item : uint, idx : uint, vector : Vector.<uint> ) : Boolean
		{
			return item != 0;
		}
	}
}

