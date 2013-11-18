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

package AI.spatial
{

	import totem.components.spatial.ISpatial2D;
	import totem.core.Destroyable;
	
	import totem3d.components.spatial.ISpatial3D;

	public class BoidIterator extends Destroyable
	{

		protected var _array : Vector.<ISpatial3D>;

		private var _index : int;

		private var _length : uint;

		public function BoidIterator()
		{
			_array = new Vector.<ISpatial3D>();
		}

		public function add( value : ISpatial3D ) : ISpatial3D
		{
			_array.push( value );
			reset();
			setLength();
			return value;
		}

		override public function destroy() : void
		{
			super.destroy();
			_array.length = 0;
			_array = null;
		}

		public function hasItem( item : ISpatial3D ) : Boolean
		{
			return _array.indexOf( item ) > -1;
		}

		public function hasNext() : Boolean
		{
			return ( _index < _array.length - 1 );
		}

		public function next() : ISpatial3D
		{
			if ( !( _index < _array.length - 1 ))
			{
				return null;
			}

			return _array[ ++_index ];
		}

		public function remove() : ISpatial3D
		{
			if ( _index < 0 )
			{
				throw new Error( "[ArrayIterator]" + " Tried to remove an element from the array before fetching the 'next' property." + " There is thus no element selected to remove." );
				return null;
			}
			return _array.splice( _index--, 1 )[ 0 ];
		}

		public function removeItem( item : ISpatial3D ) : ISpatial3D
		{
			var idx : int = _array.indexOf( item );

			if ( idx > -1 )
			{
				var value : ISpatial3D = _array.splice( _index--, 1 )[ 0 ];

				reset();
				setLength();

				return value;
			}
			
			return null;
		}

		public function reset() : void
		{
			_index = -1;

		}

		private function setLength() : void
		{
			_length = _array.length - 1;
		}
	}
}
