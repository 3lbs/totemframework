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

package totem.structures.lists
{

	import totem.structures.ITotemIterator;

	public class ListIterator implements ITotemIterator
	{
		private var _index : int;

		private var _list : IList;

		public function ListIterator( list : IList )
		{
			_list = list;
			reset();
		}

		public function get hasNext() : Boolean
		{
			return ( _index < _list.size - 1 );
		}

		public function get hasPrevious() : Boolean
		{
			return ( _index > -1 );
		}

		public function get next() : *
		{
			if ( !hasNext )
			{
				return null;
			}
			return _list.getElementAt( ++_index );
		}

		public function get nextIndex() : int
		{
			if ( !hasNext )
				return _list.size;
			else
				return _index + 1;
		}

		public function get previous() : *
		{
			if ( !hasPrevious )
			{
				return null;
			}
			return _list.getElementAt( _index-- );
		}

		public function get previousIndex() : int
		{
			if ( !hasPrevious )
				return -1;
			else
				return _index - 1;
		}

		public function remove() : *
		{
			if ( _index < 0 )
			{
				return null;
			}
			return _list.removeAt( _index );
		}

		public function reset() : void
		{
			_index = -1;
		}
	}
}
