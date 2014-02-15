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

	import flash.geom.Rectangle;
	
	import org.as3commons.collections.LinkedList;
	
	import totem.core.TotemSystem;
	import totem.data.type.Point2d;

	public class SpatialManager extends TotemSystem implements ISpatialManager
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

		public function clippingFrustum( x : int, y : int, rectangle : Rectangle ) : void
		{

		}

		public function requestSpatial ( value : int ) : SpatialRequest
		{
			return null;
		}
		
		public function getCostToClosestItem( type : String ) : Number
		{
			return 1;
		}

		public function getSpatialList() : Array
		{
			return spatialList.toArray();
		}

		public function hasSpatialComponent( component : ISpatial2D ) : Boolean
		{
			return spatialList.has( component );
		}

		public function objectUnderPoint( pt : Point2d ) : ISpatial2D
		{

			return null;
		}

		public function removeSpatialObject( component : ISpatial2D ) : void
		{
			spatialList.remove( component );
		}
	}
}
