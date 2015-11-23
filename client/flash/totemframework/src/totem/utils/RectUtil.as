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

	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import starling.utils.ScaleMode;

	public class RectUtil
	{

		public static const NONE : String = "none";

		/** Specifies that the rectangle fills the specified area without distortion
		 *  but possibly with some cropping, while maintaining the original aspect ratio. */
		public static const NO_BORDER : String = "noBorder";

		/** Specifies that the entire rectangle will be scaled to fit into the specified
		 *  area, while maintaining the original aspect ratio. This might leave empty bars at
		 *  either the top and bottom, or left and right. */
		public static const SHOW_ALL : String = "showAll";

		public static function fit( rectangle : Rectangle, into : Rectangle, scaleMode : String = SHOW_ALL, pixelPerfect : Boolean = false ) : Number
		{

			var width : Number = rectangle.width;
			var height : Number = rectangle.height;
			var factorX : Number = into.width / width;
			var factorY : Number = into.height / height;
			var factor : Number = 1.0;

			if ( scaleMode == ScaleMode.SHOW_ALL )
			{
				factor = factorX < factorY ? factorX : factorY;

				if ( pixelPerfect )
					factor = nextSuitableScaleFactor( factor, false );
			}
			else if ( scaleMode == ScaleMode.NO_BORDER )
			{
				factor = factorX > factorY ? factorX : factorY;

				if ( pixelPerfect )
					factor = nextSuitableScaleFactor( factor, true );
			}

			return factor;
		}

		public static function fitIntoRect( rectangle : Rectangle, into : Rectangle, fillRect : Boolean = true, align : String = Alignment.CENTER ) : Number
		{

			var s : Number = 1;

			return s;
		}

		private static function nextSuitableScaleFactor( factor : Number, up : Boolean ) : Number
		{
			var divisor : Number = 1.0;

			if ( up )
			{
				if ( factor >= 0.5 )
					return Math.ceil( factor );
				else
				{
					while ( 1.0 / ( divisor + 1 ) > factor )
						++divisor;
				}
			}
			else
			{
				if ( factor >= 1.0 )
					return Math.floor( factor );
				else
				{
					while ( 1.0 / divisor > factor )
						++divisor;
				}
			}

			return 1.0 / divisor;
		}
	}
}
