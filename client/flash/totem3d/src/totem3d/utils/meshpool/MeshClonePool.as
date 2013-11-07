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

package totem3d.utils.meshpool
{

	import flare.core.Mesh3D;

	import flash.utils.Dictionary;

	public class MeshClonePool
	{
		public var initItem : Mesh3D;

		private var meshPool : Dictionary = new Dictionary();

		private var pool : Array;

		public function checkIn( item : Mesh3D ) : void
		{
			meshPool[ item ] = 0;
		}

		public function checkOut() : Mesh3D
		{
			var _item : Mesh3D = getEmptyNode();

			if ( _item )
			{
				meshPool[ _item ] = 1;
				return _item;
			}

			var key : Mesh3D = clone();
			meshPool[ key ] = 1;

			return key;
		}

		public function clone() : Mesh3D
		{
			return initItem.clone() as Mesh3D;
		}

		public function get currentSize() : int
		{
			return pool.length;
		}

		public function destroy() : void
		{
		}

		public function getAllMeshes() : Array
		{
			var keys : Array = [];

			for ( var key : * in meshPool )
				keys.push( key );
			return keys;
		}

		public function initialze( item : Mesh3D ) : void
		{
			initItem = item;
			meshPool[ item ] = 0;
		}

		public function get intstanceCount() : int
		{
			return getAllMeshes().length;
		}

		public function purge() : void
		{
			for ( var key : * in meshPool )
			{
				if ( key != initItem )
				{
					//  key.dispose(); ?
					meshPool[ key ] = null;
					delete meshPool[ key ];
				}
			}
		}

		public function resetAllMeshes() : void
		{
			for ( var key : * in meshPool )
				meshPool[ key ] = 0;
		}

		private function getEmptyNode() : Mesh3D
		{
			for ( var key : * in meshPool )
			{
				if ( meshPool[ key ] == 0 )
					return key;
			}
			return null;
		}
	}
}

