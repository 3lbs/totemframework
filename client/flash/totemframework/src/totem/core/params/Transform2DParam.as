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

package totem.core.params
{

	public class Transform2DParam
	{

		public var height : Number;

		public var rotate : Number = 0;

		public var scaleX : Number = 1;

		public var scaleY : Number = 1;

		public var translateX : Number = 0;

		public var translateY : Number = 0;

		public var visibility : Boolean = true;

		public var width : Number;

		public function Transform2DParam()
		{
			super();
		}
	}
}
