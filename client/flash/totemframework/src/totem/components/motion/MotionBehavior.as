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

	import totem.events.RemovableEventDispatcher;
	import totem.math.Vector2D;

	public class MotionBehavior extends RemovableEventDispatcher implements IMotion
	{

		public var agent : IMoveSpatialObject2D;

		public function MotionBehavior()
		{
		}

		public function calculate() : Vector2D
		{
			return null;
		}

		public function setComponent( agent : IMoveSpatialObject2D ) : void
		{
			this.agent = agent;
		}
	}
}
