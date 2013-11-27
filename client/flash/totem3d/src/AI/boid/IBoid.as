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

package AI.boid
{

	import totem.components.motion.IMoveSpatialObject2D;

	public interface IBoid extends IMoveSpatialObject2D
	{

		/*function get parent():Entity;

		function set parent(a_value:Entity):void*/

		function getProperty( prop : Object ) : Object;

		function get neighborDistance() : Number;

		function set neighborDistance( value : Number ) : void;
		function setProperty( prop : Object, value : Object ) : void
	}
}

