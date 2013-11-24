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

package AI.steering.behaviors
{

	import totem.components.spatial.ISpatial2D;
	import totem.core.Destroyable;
	import totem.math.Vector2D;

	public class ABehavior extends Destroyable
	{

		public var agent : ISpatial2D;

		public var priority : int; // Order in which this will be calculated vs other behaviors

		public var probability : Number; // Probability this will be calculated in prioritized dithering

		public var weight : Number; // Amount the final force will be scaled by

		public function ABehavior( a_weight : Number = 1, a_priority : int = 1, a_probability : Number = 1 )
		{
			this.weight = a_weight;
			this.priority = a_priority;
			this.probability = a_probability;
		}

		public function calculate() : Vector2D
		{
			throw new Error( "<ABehavior> Abstract function -- Must be overriden!" );
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			agent = null;
			
		}
	}
}

