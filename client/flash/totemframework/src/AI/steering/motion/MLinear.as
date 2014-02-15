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

package AI.steering.motion
{

	public class MLinear implements IMotion
	{
		public function MLinear()
		{
		}

		public function ease( timeElapsed : Number, duration : Number ) : Number
		{
			return timeElapsed / duration;
		}
	}
}
