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

package totem.utils.objectpool
{

	public class BasicObjectPool
	{
		private var objects_ : Array = [];

		private var size_ : uint = 0;

		public function clear() : void
		{
			objects_.length = 0;
			size_ = 0;
		}

		public function get() : *
		{
			if ( size_ )
				return objects_[( size_-- ) - 1 ];
			else
				throw Error( "Object pool empty" );
			return null;
		}

		public function isEmpty() : Boolean
		{
			return size_ == 0;
		}

		public function put( object : * ) : void
		{
			//pool full
			if ( objects_.length == size_ )
			{
				//non-empty, expand
				if ( objects_.length )
					objects_.length <<= 1;
				//empty, set size to one first
				else
					objects_.length = 1;
			}

			//put object into pool
			objects_[ size_++ ] = object;
		}
	}
}
