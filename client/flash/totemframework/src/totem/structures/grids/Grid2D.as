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

package totem.structures.grids
{

	import totem.structures.ITotemIterator;
	import totem.structures.ProtectedIterator;
	import totem.utils.string.TabularText;

	/**
	 * A two-dimensional grid that uses integers to populate it's cells. A cell with a
	 * value of 0 is considered to be empty. Any other value can be used to identify the
	 * cell's content, e.g. with a tile in a tile-based game.
	 */
	public class Grid2D
	{
		//-----------------------------------------------------------------------------------------
		// Constants
		//-----------------------------------------------------------------------------------------

		/** @private */
		protected var _grid : Vector.<Vector.<int>>;

		/** @private */
		protected var _height : int;

		/** @private */
		protected var _width : int;

		/**
		 * Constructs a new Grid2D instance. The grid will have the size of the specified
		 * width and height arguments and every cell is set to the value specified with the
		 * fillValue argument. Optionally a two dimensional source array can be specified
		 * whose values are used to populate the grid. The first three arguments are ignored
		 * if a source array was provided.
		 *
		 * @param width A value that determines how many cells wide the grid should be.
		 * @param height A value that determines how many cells high the grid should be.
		 * @param fillValue A value that is used to fill all cells in the new grid.
		 * @param source An array that is used as the source to populate the grid. The width
		 *            and height parameters are ignored and the dimensions of the specified
		 *            source array are used instead.
		 */
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

		/**
		 * Adds the specified value to the value that is stored in the grid cell at the
		 * specified x and y coordinates, if any and returns the old value of the cell.
		 *
		 * @param x The x coordinate in the grid.
		 * @param y The y coordinate in the grid.
		 * @param value The value to add to the specified coordinate.
		 * @return The value that was at the specified grid cell before.
		 */
		public function addToCell( x : int, y : int, value : int ) : int
		{
			var oldValue : int = _grid[ y ][ x ];
			_grid[ y ][ x ] = oldValue + value;
			return oldValue;
		}

		/**
		 * Clears the grid with the specified value as the initial value for every grid
		 * cell.
		 *
		 * @param fillValue The value to fill the grid with.
		 */
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

		/**
		 * Clears the cell that is at the specified x and y coordinate. This sets the cell
		 * to the value 0.
		 *
		 * @param x The x coordinate in the grid.
		 * @param y The y coordinate in the grid.
		 * @return The value that was at the specified grid cell before.
		 */
		public function clearCell( x : int, y : int ) : int
		{
			var result : int = _grid[ y ][ x ];
			_grid[ y ][ x ] = 0;
			return result;
		}

		/**
		 * Returns a clone of the Grid. The clone will be safe for use in that it doesn't
		 * maintain any references to the original Grid.
		 *
		 * @return A clone of the Grid.
		 */
		public function clone() : Grid2D
		{
			var g : Grid2D = new Grid2D( 0, 0, 0 );
			g.fromVector( _grid );
			return g;
		}

		/**
		 * Checks if the specified value exists in the Grid.
		 *
		 * @return true if the Grid contains the specified value or false if not.
		 */
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

		/**
		 * Copies a rectangular region from the grid defined by the specified x1, y1 and x2,
		 * y2 coordinates and returns this region as a new grid instance. If all coordinates
		 * are <code>0</code> the whole grid is copied and returned.
		 *
		 * @param x1 The start x coordinate of the region to copy.
		 * @param y1 The start y coordinate of the region to copy.
		 * @param x2 The end x coordinate of the region to copy.
		 * @param y2 The end y coordinate of the region to copy.
		 */
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

		/**
		 * Returns a formatted string representation of the Grid that can be used for
		 * debugging purposes.
		 *
		 * @return a formatted string representation of the Grid.
		 */
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

		//-----------------------------------------------------------------------------------------
		// Bulk Operations
		//-----------------------------------------------------------------------------------------

		/**
		 * Fills the rectangular region of the grid defined by the specified x1, y1 and x2,
		 * y2 coordinates with the specified value.
		 *
		 * @param x1 The start x coordinate of the fill area.
		 * @param y1 The start y coordinate of the fill area.
		 * @param x2 The end x coordinate of the fill area.
		 * @param y2 The end y coordinate of the fill area.
		 * @param value The fill value.
		 * @throws com.hexagonstar.exception.IllegalArgumentException if the specified start
		 *             coordinates are outside the existing grid dimensions.
		 * @throws com.hexagonstar.exception.IllegalArgumentException if the end coordinates
		 *             are smaller than the start coordinates.
		 */
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

		/**
		 * Fills the whole grid with random values in a range that starts from the specified
		 * minValue and ends with the specified maxValue (inclusive).
		 *
		 * @param minValue The minimum random value.
		 * @param maxValue The maximum random value.
		 */
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

		/**
		 * Fills the whole grid with integer values counting up from the specified
		 * startValue. After a call to this method every cell in the grid will hold a unique
		 * integer value.
		 *
		 * @param startValue The value to start filling the grid with.
		 */
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

		/**
		 * Uses the values of the specified 2D array to populate the grid.
		 *
		 * @param source The array from which the values to use to populate the grid.
		 * @throws com.hexagonstar.exception.DataStructureException if the specified array
		 *             is either null, empty or not a two-dimensional array.
		 */
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

		/**
		 * Uses the values of the specified 2D vector to populate the grid.
		 *
		 * @param source The vector from which the values to use to populate the grid.
		 * @throws com.hexagonstar.exception.DataStructureException if the specified vector
		 *             is either null, empty or not a two-dimensional vector.
		 */
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

		/**
		 * Returns the content of the cell in the grid that is at the specified x and y
		 * coordinate.
		 *
		 * @param x The x coordinate in the grid.
		 * @param y The y coordinate in the grid.
		 * @return The content of the grid cell at the specified x and y coordinate.
		 */
		public function getCell( x : int, y : int ) : int
		{
			return _grid[ y ][ x ];
		}

		/**
		 * Returns the height of the grid, measured in cells.
		 *
		 * @return The height of the grid, measured in cells.
		 */
		public function get height() : int
		{
			return _height;
		}

		/**
		 * Determines if the grid is completely empty, i.e. all cells have a value of 0.
		 * Any other value in a cell, negative or positive means that the grid is not
		 * empty.
		 *
		 * @return true if the grid is empty or false if not.
		 */
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

		/**
		 * Returns an iterator for iterating over the cells of the grid. The returned
		 * iterator is protected because the direct removing of elements is not allowed.
		 *
		 * @return An iterator to iterate over the cells of the grid.
		 */

		[Transient]
		public function get iterator() : ITotemIterator
		{
			return ( new ProtectedIterator( new Grid2DIterator( _grid )));
		}

		/**
		 * Multiplies the specified value to the value that is stored in the grid cell at
		 * the specified x and y coordinates and returns the old value of the cell.
		 *
		 * @param x The x coordinate in the grid.
		 * @param y The y coordinate in the grid.
		 * @param value The value to multiply to the specified coordinate.
		 * @return The value that was at the specified grid cell before.
		 */
		public function multiplyToCell( x : int, y : int, value : int ) : int
		{
			var oldValue : int = _grid[ y ][ x ];
			_grid[ y ][ x ] = oldValue * value;
			return oldValue;
		}

		/**
		 * Pastes the specified grid onto this grid starting at the specified x and y
		 * coordinate. If the pasted region's dimension exceeds the current size of the
		 * grid, the exceeding region is cropped.
		 *
		 * @param grid The grid to paste onto this grid.
		 * @param x The x coordinate at where to paste the grid.
		 * @param y The y coordinate at where to paste the grid.
		 * @throws com.hexagonstar.exception.IllegalArgumentException if the specified
		 *             coordinates are outside the existing grid dimensions.
		 */
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

		/**
		 * Pastes the specified 2D vector onto the grid starting at the specified x and y
		 * coordinate. If the pasted region's dimension exceeds the current size of the
		 * grid, the exceeding region is cropped.
		 *
		 * @param vector The 2D vector to paste onto the grid.
		 * @param x The x coordinate at where to paste the grid.
		 * @param y The y coordinate at where to paste the grid.
		 * @throws com.hexagonstar.exception.IllegalArgumentException if the specified
		 *             coordinates are outside the existing grid dimensions.
		 */
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

		/**
		 * Resizes the grid to the dimensions of the specified newWidth and newHeight. If
		 * the resulting grid dimension is larger than the old one, new cells are filled
		 * with the value specified in the fillValue argument.
		 *
		 * @param newWidth The new width (in cells) of the grid.
		 * @param newHeight The new height (in cells) of the grid.
		 * @param fillValue The value used to fill new cells if the new grid size is larger
		 *            than the old one.
		 */
		public function resize( newWidth : int, newHeight : int, fillValue : int = 0 ) : void
		{
			var oldGrid : Vector.<Vector.<int>> = _grid.concat();
			_width = newWidth;
			_height = newHeight;
			clear( fillValue );
			pasteFromVector( oldGrid, 0, 0 );
		}

		//-----------------------------------------------------------------------------------------
		// Modification Operations
		//-----------------------------------------------------------------------------------------

		/**
		 * Stores the specified value into the grid cell that is at the specified x and y
		 * coordinates and returns the value that was at this coordinate before.
		 *
		 * @param x The x coordinate in the grid.
		 * @param y The y coordinate in the grid.
		 * @param value That value that should be placed in the grid cell.
		 * @return The value that was at the specified grid cell before.
		 */
		public function setCell( x : int, y : int, value : int ) : int
		{
			var result : int = _grid[ y ][ x ];
			_grid[ y ][ x ] = value;
			return result;
		}

		//-----------------------------------------------------------------------------------------
		// Query Operations
		//-----------------------------------------------------------------------------------------

		/**
		 * Returns the size of the grid, or in other words how many cells the grid has.
		 *
		 * @return The cell amount of the grid.
		 */
		public function get size() : int
		{
			return _height * _width;
		}

		/**
		 * Returns a 2d array representation of the grid.
		 *
		 * @return A 2d array representation of the grid.
		 */
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

		/**
		 * Returns a string representation of the grid.
		 *
		 * @return A string representation of the grid.
		 */
		public function toString() : String
		{
			return "[Grid2D] size=" + size + ", width=" + _width + ", height=" + _height;
		}

		/**
		 * Returns the width of the grid, measured in cells.
		 *
		 * @return The width of the grid, measured in cells.
		 */
		public function get width() : int
		{
			return _width;
		}
	}
}

