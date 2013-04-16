package totem3d.utils.meshpool
{

	import flash.utils.Dictionary;
	
	import flare.core.Mesh3D;

	public class MeshClonePool
	{
		public var initItem : Mesh3D;

		private var pool : Array;

		private var meshPool : Dictionary = new Dictionary();

		public function get currentSize() : int
		{
			return pool.length;
		}

		public function initialze( item : Mesh3D ) : void
		{
			initItem = item;
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

		public function checkIn( item : Mesh3D ) : void
		{
			meshPool[ item ] = 0;
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

		public function resetAllMeshes() : void
		{
			for ( var key : * in meshPool )
				meshPool[ key ] = 0;
		}

		public function get intstanceCount() : int
		{
			return getAllMeshes().length;
		}

		public function getAllMeshes() : Array
		{
			var keys : Array = [];

			for ( var key : * in meshPool )
				keys.push( key );
			return keys;
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

		public function clone() : Mesh3D
		{
			return initItem.clone() as Mesh3D;
		}

		public function destroy() : void
		{
		}
	}
}

