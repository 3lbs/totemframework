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

package AI.steering
{

	import totem.core.IDestroyable;
	import totem.math.Vector2D;

	public interface ISteering extends IDestroyable
	{

		function isComplete() : Boolean;

		function moveTo( vector : Vector2D, easeType : Class = null ) : Number;

		function stop() : void;

		function update() : Boolean;
		
		function set pointDirection ( value : Boolean ) : void;
	}
}
