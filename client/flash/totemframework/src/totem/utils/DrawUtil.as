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

	import flash.display.Graphics;

	public class DrawUtil
	{

		public static function drawGrid( numColumns : Number, numRows : Number, cellHeight : Number, cellWidth : Number, graphics : Graphics ) : void
		{
			graphics.clear();
			graphics.lineStyle( 1, 0x000000 );

			// we drop in the " + 1 " so that it will cap the right and bottom sides.
			for ( var col : Number = 0; col <= numColumns; col++ )
			{
				for ( var row : Number = 0; row <= numRows; row++ )
				{
					//trace(col, row);
					graphics.moveTo( col * cellWidth, 0 );
					graphics.lineTo( col * cellWidth, cellHeight * numRows );
					graphics.moveTo( 0, row * cellHeight );
					graphics.lineTo( cellWidth * numColumns, row * cellHeight );
				}
			}

		}

		public function DrawUtil()
		{
		}
	}
}
