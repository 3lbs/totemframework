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

package AI.params
{

	import AI.steering.Moving2DComponent;

	import totem.core.params.Transform2DParam;

	public class MovingParam extends Transform2DParam
	{

		public var boundsBehavior : String = Moving2DComponent.BOUNDS_NONE;

		public var damping : Number;

		public var doesRotMatchHeading : Boolean;

		public var friction : Number;

		public var maxAccelleration : Number;

		public var maxSpeed : Number;

		public var maxTurnRate : Number;

		public function MovingParam()
		{
		}
	}
}

