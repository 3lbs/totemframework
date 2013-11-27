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

	import totem.math.AABBox;

	public interface ISpatial2D
	{

		function get bounds() : AABBox;

		function get x() : Number

		function set x( value : Number ) : void

		function get y() : Number

		function set y( value : Number ) : void
	}
}
