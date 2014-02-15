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

	import totem.core.params.Transform2DParam;

	public class MovingParam extends Transform2DParam
	{

		public var damping : Number;

		public var doesRotMatchHeading : Boolean;

		public var friction : Number;

		public var maxAccelleration : Number;

		public var maxSpeed : Number;

		public var maxTurnRate : Number;

		public var neighborDistance : Number;

		public function MovingParam()
		{
		}
	}
}

