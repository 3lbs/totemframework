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

package totem.structures
{

	public class ProtectedIterator implements IIterator
	{
		private var _iterator : IIterator;

		public function ProtectedIterator( iterator : IIterator )
		{
			_iterator = iterator;
		}

		public function get hasNext() : Boolean
		{
			return _iterator.hasNext;
		}

		public function get next() : *
		{
			return _iterator.next;
		}

		public function remove() : *
		{
			return null;
		}

		public function reset() : void
		{
			_iterator.reset();
		}
	}
}
