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

	import totem.core.IDestroyable;
	import totem.math.Vector2D;

	public interface IMotion extends IDestroyable
	{
		function calculate() : Vector2D;
		function setComponent( agent : IMoveSpatialObject2D ) : void;
	}
}
