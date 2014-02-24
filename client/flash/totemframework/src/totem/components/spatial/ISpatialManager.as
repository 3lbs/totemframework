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
	
	import totem.core.IDestroyable;
	import totem.data.type.Point2d;

	public interface ISpatialManager extends IDestroyable
	{

		function addSpatialObject( object : ISpatial2D ) : void;

		function clippingFrustum( x : int, y : int, rectangle : Rectangle ) : void;

		function hasSpatialComponent( component : ISpatial2D ) : Boolean;

		function objectUnderPoint( pt : Point2d ) : ISpatial2D;

		function removeSpatialObject( object : ISpatial2D ) : void;
		
		function requestSpatial ( value : int ) : SpatialRequest;
	}
}
