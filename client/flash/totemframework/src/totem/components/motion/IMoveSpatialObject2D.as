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

package totem.components.motion
{

	import totem.math.Vector2D;
	import totem.components.spatial.ISpatial2D;

	public interface IMoveSpatialObject2D extends ISpatial2D
	{
		
		function get maxAcceleration() : Number;
		
		function set maxAcceleration( value : Number ) : void;
		
		function get maxSpeed() : Number;
		
		function get velocity() : Vector2D;
		
		/**
		 * Position getter.
		 */
		function get position() : Vector2D;

		/**
		 * Position setter.
		 */
		//function set position( value : Vector2D ) : void;

		/**
		 * Rotation getter.
		 */
		function get rotation() : Number;

		/**
		 * Rotation setter.
		 */
		function set rotation( value : Number ) : void;

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
