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

package totem.components.motion
{

	import AI.steering.TweenSteeringBehavior;

	import totem.components.spatial.ISpatial2D;
	import totem.math.Vector2D;

	public interface ISteeringObject extends ISpatial2D
	{

		/**
		 * Position getter.
		 */
		function get position() : Vector2D;

		function get steering() : TweenSteeringBehavior;
	/**
	 *
	 * Position setter.
	 */
		 //function set position( value : Vector2D ) : void;
	/**
	 * Size getter.
	 */
		 //function get size() : Point;
	/**
	 * Size setter.
	 */
		 //function set size( value : Point ) : void;
	}
}
