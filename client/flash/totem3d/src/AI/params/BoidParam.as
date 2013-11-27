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
	import totem.components.motion.MovingParam;

	public class BoidParam extends MovingParam
	{

		public var neighborDistance : Number;

		public var searchDistance : Number;

		public function BoidParam()
		{
			super();
		}
	}
}
