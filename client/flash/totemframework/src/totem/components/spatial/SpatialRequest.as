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

package totem.components.spatial
{

	import totem.core.Destroyable;

	public class SpatialRequest extends Destroyable
	{

		internal static var disposed : Vector.<SpatialRequest> = new Vector.<SpatialRequest>();

		public static function create( value : int ) : SpatialRequest
		{
			if ( disposed.length > 0 )
			{
				return disposed.pop().reset( value );
			}

			return new SpatialRequest( value );
		}

		public static function grow( count : int ) : void
		{
			while ( count-- )
			{
				disposed.push( new SpatialRequest( 0 ));
			}
		}

		private var _spatialList : Vector.<ISpatial2D> = new Vector.<ISpatial2D>();

		private var _type : int;

		public function SpatialRequest( value : int )
		{
			super();
			_type = value;
		}

		public function dispose() : void
		{

			_spatialList.length = 0;

			var idx : int = disposed.indexOf( this );

			if ( idx > -1 )
				return;

			disposed.push( this );
		}

		public function getSpatialList() : Vector.<ISpatial2D>
		{
			return _spatialList;
		}

		public function getTypes() : int
		{
			return _type;
		}

		public function hasType( t : int ) : Boolean
		{
			return ( _type & t ) == t;
		}

		public function reset( value : int ) : SpatialRequest
		{
			_spatialList.length = 0;

			_type = value;

			return this;
		}
	}
}

