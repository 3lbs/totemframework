package totem.structures.grids
{
	import totem.structures.ITotemIterator;
	
	// ------------------------------------------------------------------------------------------------
	
	import totem.structures.ITotemIterator;
	
	/**
	 * @private
	 */
	final class Grid2DIterator implements ITotemIterator
	{
		private var _grid : Vector.<Vector.<int>>;
		
		private var _h : int;
		
		private var _w : int;
		
		private var _x : int;
		
		private var _y : int;
		
		public function Grid2DIterator( grid : Vector.<Vector.<int>> )
		{
			_grid = grid;
			_h = _grid.length;
			_w = _grid[ 0 ].length;
			reset();
		}
		
		public function get hasNext() : Boolean
		{
			if ( _y < _h - 1 )
			{
				return true;
			}
			return ( _x < _w );
		}
		
		public function get next() : *
		{
			var r : int;
			
			if ( _x == _w )
			{
				_x = 0;
				_y++;
			}
			
			if ( _y == _h )
			{
				throw new Error( "[Grid2DIterator] There is no next element in the grid to iterate over." );
				return null;
			}
			
			r = _grid[ _y ][ _x ];
			_x++;
			
			return r;
		}
		
		public function remove() : *
		{
			/* Not supported for grids! */
			return null;
		}
		
		public function reset() : void
		{
			_y = 0;
			_x = 0;
		}
	}

}