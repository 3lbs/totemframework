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

	import totem.components.spatial.ISpatial2D;
	import totem.math.Vector2D;

	public interface IMovingObject extends ISpatial2D
	{
		
		function get rotation() : Number;
		
		/**
		 * Rotation setter.
		 */
		function set rotation( value : Number ) : void;
		
		function get velocity() : Vector2D;
		
		
		
		function get maxAcceleration() : Number;
		
		function set maxAcceleration( value : Number ) : void;
		
		function get maxSpeed() : Number;
		
	}
}
