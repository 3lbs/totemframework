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

	import totem.core.IDestroyable;
	import totem.core.api.IUID;
	import totem.data.type.Point2d;
	import totem.math.AABBox;
	import totem.math.Vector2D;

	public interface ISpatial2D extends IUID, IDestroyable
	{

		function get bounds() : AABBox;

		function contains( x : int, y : int ) : Boolean;

		function containsPoint( pt : Point2d ) : Boolean;

		function get depth() : int;

		function set depth( value : int ) : void;

		function getSpatialManager() : ISpatialManager;

		function get type() : int;

		function get x() : Number;

		function set x( value : Number ) : void;

		function get y() : Number;

		function set y( value : Number ) : void;
		
		function get position() : Vector2D;
	}
}
