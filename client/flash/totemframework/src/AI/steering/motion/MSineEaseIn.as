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

	public class MSineEaseIn implements IMotion
	{

		private static const HALF_PI : Number = Math.PI / 2;

		public function MSineEaseIn()
		{
		}

		public function ease( timeElapsed : Number, duration : Number ) : Number
		{
			return -1 * Math.cos( timeElapsed / duration * HALF_PI ) + 1;
		}
	}
}
