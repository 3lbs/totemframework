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

	import AI.steering.ISteering;

	import totem.components.spatial.ISpatial2D;

	public interface ISteeringObject extends ISpatial2D
	{

		function setBehavior( behavior : ISteering ) : ISteering;

		function get steering() : ISteering;

		function get velocity() : Number;

		function set velocity( value : Number ) : void;
	}
}
