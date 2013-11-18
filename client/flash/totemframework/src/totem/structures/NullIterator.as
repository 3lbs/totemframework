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

	public class NullIterator
	{
		public function NullIterator()
		{
		}

		public function get hasNext() : Boolean
		{
			return false;
		}

		public function get next() : *
		{
			return null;
		}

		public function remove() : *
		{
			return null;
		}

		public function reset() : void
		{
		}
	}
}
