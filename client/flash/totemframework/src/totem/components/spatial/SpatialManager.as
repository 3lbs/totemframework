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

package totem.components.spatial
{

	import totem.events.RemovableEventDispatcher;

	public class SpatialManager extends RemovableEventDispatcher implements ISpatialManager
	{

		public var spatialList : Array = new Array();

		public function SpatialManager()
		{
		}

		public function addSpatialObject( object : ISpatial2D ) : void
		{
			spatialList.push( object );
		}

		public function getCostToClosestItem( type : String ) : Number
		{
			return 1;
		}

		public function getSpatialList() : Array
		{
			return spatialList;
		}
	}
}
