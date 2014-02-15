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

package totem.components.animation
{

	public class AnimatorEnum
	{
		public static const LOOP : AnimatorEnum = new AnimatorEnum( 0 );

		public static const PLAY_ONCE : AnimatorEnum = new AnimatorEnum( 1 );

		private var _type : int;

		public function AnimatorEnum( type : int )
		{
			_type = type;
		}

		public function get type() : int
		{
			return _type;
		}
	}
}
