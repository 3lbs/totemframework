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

package totem.structures.grids
{

	import totem.structures.ITotemIterator;
	import totem.structures.ProtectedIterator;
	import totem.utils.string.TabularText;

	public class Grid2D
	{
		protected var _grid : Vector.<Vector.<int>>;

		protected var _height : int;

		protected var _width : int;

		public function Grid2D( width : int = 0, height : int = 0, fillValue : int = 0, source : Array = null )
		{
			if ( !source )
			{
				_width = width;
				_height = height;
				clear( fillValue );
			}
			else
			{
				fromArray( source );
			}
		}

		public function addToCell( x : int, y : int, value : int ) : int
		{
			var oldValue : int = _grid[ y ][ x ];
			_grid[ y ][ x ] = oldValue + value;
			return oldValue;
		}

		public function clear( fillValue : int = 0 ) : void
		{
			_grid = new Vector.<Vector.<int>>( _height, true );

			var row : Vector.<int>;

			for ( var y : int = 0; y < _height; y++ )
			{
				row = new Vector.<int>( _width, true );

				for ( var x : int = 0; x < _width; x++ )
				{
					row[ x ] = fillValue;
				}
				_grid[ y ] = row;
			}
		}

		public function clearCell( x : int, y : int ) : int
		{
			var result : int = _grid[ y ][ x ];
			_grid[ y ][ x ] = 0;
			return result;
		}

		public function clone() : Grid2D
		{
			var g : Grid2D = new Grid2D( 0, 0, 0 );
			g.fromVector( _grid );
			return g;
		}

		public function contains( value : int ) : Boolean
		{
			for ( var y : int = 0; y < _height; y++ )
			{
				for ( var x : int = 0; x < _width; x++ )
				{
					if ( _grid[ y ][ x ] == value )
						return true;
				}
			}
			return false;
		}

		public function copy( x1 : int = 0, y1 : int = 0, x2 : int = 0, y2 : int = 0 ) : Grid2D
		{
			var result : Grid2D;

			/* If all arguments are zero, copy the whole grid */
			if (( x1 + x2 + y1 + y2 ) == 0 )
			{
				result = clone();
			}
			else
			{
				/* Check if either x coords or y coords are zero */
				var newX : int;
				var newY : int;
				var newWidth : int = ( x1 == 0 && x2 == 0 ) ? _width : ( x2 - x1 );
				var newHeight : int = ( y1 == 0 && y2 == 0 ) ? _height : ( y2 - y1 );

				result = new Grid2D( newWidth, newHeight );
				newWidth = newWidth + x1;
				newHeight = newHeight + y1;

				for ( var y : int = y1; y < newHeight; y++ )
				{
					newY = y - y1;

					for ( var x : int = x1; x < newWidth; x++ )
					{
						newX = x - x1;
						result.setCell( newX, newY, _grid[ y ][ x ]);
					}
				}
			}
			return result;
		}

		public function dump() : String
		{
			var s : String = "\n" + toString();
			var t : TabularText = new TabularText( _width );

			for ( var y : int = 0; y < _height; y++ )
			{
				var r : Array = [];

				for ( var x : int = 0; x < _width; x++ )
				{
					r.push( _grid[ y ][ x ]);
				}
				t.add( r );
			}

			return s + "\n" + t;
		}

		public function fill( x1 : int, y1 : int, x2 : int, y2 : int, value : int ) : void
		{
			if ( x1 >= _width || x2 >= _width || y1 >= _height || y2 >= _height )
			{
				throw new Error( toString() + " Fill coordinates are out" + "of bound: x1[" + x1 + "]  y1[" + y1 + "]  x2[" + x2 + "]  y2[" + y2 + "]" );
			}
			else
			{
				if ( x2 < x1 || y2 < y2 )
				{
					throw new Error( toString() + " Cannot fill with end" + "coords being smaller than start coords: x1[" + x1 + "]  y1[" + y1 + "]  x2[" + x2 + "]  y2[" + y2 + "]" );
				}
				else
				{
					for ( var y : int = y1; y <= y2; y++ )
					{
						for ( var x : int = x1; x <= x2; x++ )
						{
							_grid[ y ][ x ] = value;
						}
					}
				}
			}
		}

		public function fillRandom( minValue : int, maxValue : int ) : void
		{
			for ( var y : int = 0; y < _height; y++ )
			{
				for ( var x : int = 0; x < _width; x++ )
				{
					_grid[ y ][ x ] = minValue + ( Math.random() * ( maxValue - minValue + 1 ));
				}
			}
		}

		public function fillRange( startValue : int = 0 ) : void
		{
			for ( var y : int = 0; y < _height; y++ )
			{
				for ( var x : int = 0; x < _width; x++ )
				{
					_grid[ y ][ x ] = startValue;
					startValue++;
				}
			}
		}

		public function fromArray( source : Array ) : void
		{
			if ( source == null || source.length == 0 || !( source[ 0 ] is Array ) || ( source[ 0 ] as Array ).length == 0 )
			{
				throw new Error( toString() + " Tried to use an array that is null, empty or non-2D as a source!" );
			}
			else
			{
				var vec : Vector.<Vector.<int>> = new Vector.<Vector.<int>>();

				for each ( var a : Array in source )
				{
					var row : Vector.<int> = new Vector.<int>();

					for each ( var n : int in a )
					{
						row.push( n );
					}
					vec.push( row );
				}
				fromVector( vec );
			}
		}

		public function fromVector( source : Vector.<Vector.<int>> ) : void
		{
			if ( source == null || source.length == 0 || source[ 0 ].length == 0 )
			{
				throw new Error( toString() + " Tried to use an empty or non-2D vector as a source!" );
			}
			else
			{
				_grid = source.concat();
				_height = _grid.length;
				_width = _grid[ 0 ].length;
			}
		}

		public function getCell( x : int, y : int ) : int
		{
			return _grid[ y ][ x ];
		}

		public function get height() : int
		{
			return _height;
		}

		public function get isEmpty() : Boolean
		{
			for ( var y : int = 0; y < _height; y++ )
			{
				for ( var x : int = 0; x < _width; x++ )
				{
					if ( _grid[ y ][ x ] != 0 )
						return false;
				}
			}
			return true;
		}

		public function get iterator() : ITotemIterator
		{
			return ( new ProtectedIterator( new Grid2DIterator( _grid )));
		}

		public function multiplyToCell( x : int, y : int, value : int ) : int
		{
			var oldValue : int = _grid[ y ][ x ];
			_grid[ y ][ x ] = oldValue * value;
			return oldValue;
		}

		public function paste( grid : Grid2D, x : int = 0, y : int = 0 ) : void
		{
			if ( x >= _width || y >= _height )
			{
				throw new Error( toString() + " Start coordinates for paste" + " operation are out of bound: x[" + x + "]  y[" + y + "]" );
			}
			else
			{
				var y2 : int = ( grid.height - 1 ) + y;
				var x2 : int = ( grid.width - 1 ) + x;

				/* If the end coords are exceeding the grid's boundary, crop them */
				if ( y2 > _height - 1 )
					y2 = _height - 1;

				if ( x2 > _width - 1 )
					x2 = _width - 1;

				for ( var i : int = y; i <= y2; i++ )
				{
					for ( var j : int = x; j <= x2; j++ )
					{
						_grid[ i ][ j ] = grid.getCell( j - x, i - y );
					}
				}
			}
		}

		public function pasteFromVector( vector : Vector.<Vector.<int>>, x : int = 0, y : int = 0 ) : void
		{
			if ( x >= _width || y >= _height )
			{
				throw new Error( toString() + " Start coordinates for paste" + " operation are out of bound: x[" + x + "]  y[" + y + "]" );
			}
			else
			{
				var y2 : int = ( vector.length - 1 ) + y;
				var x2 : int = ( vector[ 0 ].length - 1 ) + x;

				/* If the end coords are exceeding the grid's boundary, crop them */
				if ( y2 > _height - 1 )
					y2 = _height - 1;

				if ( x2 > _width - 1 )
					x2 = _width - 1;

				for ( var i : int = y; i <= y2; i++ )
				{
					for ( var j : int = x; j <= x2; j++ )
					{
						_grid[ i ][ j ] = vector[ i - y ][ j - x ];
					}
				}
			}
		}

		public function resize( newWidth : int, newHeight : int, fillValue : int = 0 ) : void
		{
			var oldGrid : Vector.<Vector.<int>> = _grid.concat();
			_width = newWidth;
			_height = newHeight;
			clear( fillValue );
			pasteFromVector( oldGrid, 0, 0 );
		}

		public function setCell( x : int, y : int, value : int ) : int
		{
			var result : int = _grid[ y ][ x ];
			_grid[ y ][ x ] = value;
			return result;
		}

		public function get size() : int
		{
			return _height * _width;
		}

		public function toArray() : Array
		{
			var a : Array = new Array( _height );
			var row : Array;

			for ( var y : int = 0; y < _height; y++ )
			{
				row = new Array( _width );

				for ( var x : int = 0; x < _width; x++ )
				{
					row[ x ] = _grid[ y ][ x ];
				}
				a[ y ] = row;
			}
			return a;
		}

		public function toString() : String
		{
			return "[Grid2D] size=" + size + ", width=" + _width + ", height=" + _height;
		}

		public function get width() : int
		{
			return _width;
		}
	}
}

