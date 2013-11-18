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

package totem.structures.arrays
{

	public class ArrayIterator
	{
		protected var _array : Array;

		protected var _index : int;

		public function ArrayIterator( array : Array )
		{
			_array = array;
			reset();
		}

		public function get hasNext() : Boolean
		{
			return ( _index < _array.length - 1 );
		}

		public function get next() : *
		{
			if ( !( _index < _array.length - 1 ))
			{
				return null;
			}
			return _array[ ++_index ];
		}

		public function remove() : *
		{
			if ( _index < 0 )
			{
				return null;
			}
			return _array.splice( _index--, 1 )[ 0 ];
		}

		public function reset() : void
		{
			_index = -1;
		}
	}
}
