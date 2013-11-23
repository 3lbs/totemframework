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

	import org.as3commons.collections.LinkedList;

	import totem.core.System;

	public class SpatialManager extends System implements ISpatialManager
	{

		public var spatialList : LinkedList = new LinkedList();

		public function SpatialManager( name : String = null )
		{
			super( name );
		}

		public function addSpatialObject( component : ISpatial2D ) : void
		{
			if ( spatialList.has( component ))
				return;

			spatialList.add( component );
		}

		public function getCostToClosestItem( type : String ) : Number
		{
			return 1;
		}

		public function getSpatialList() : Array
		{
			return spatialList.toArray();
		}

		public function removeSpatialObject( component : ISpatial2D ) : void
		{
			spatialList.remove( component );
		}
	}
}
