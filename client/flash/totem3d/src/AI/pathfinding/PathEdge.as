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

package AI.pathfinding
{

	import AI.steering.behaviors.ABehavior;
	
	import totem.core.Destroyable;
	import totem.math.Vector2D;

	public class PathEdge extends Destroyable
	{

		public var behaviors : Vector.<ABehavior>;

		private var _destination : Vector2D = new Vector2D( 100, 300 );

		public function PathEdge()
		{
			super();
		}
		
		public function setPosition ( x : Number, y : Number ) : void
		{
			_destination.x = x;
			_destination.y = y;
		}

		public function get destination() : Vector2D
		{
			return _destination;
		}

		public function reset() : void
		{
			_destination.x = 0;
			_destination.y = 0;
			
			behaviors.length = 0;
		}
	}
}
