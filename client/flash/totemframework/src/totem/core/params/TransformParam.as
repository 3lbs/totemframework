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

package totem.core.params
{

	public class TransformParam extends BaseParam
	{

		public var collision : Boolean = false;

		public var rotateX : Number = 0;

		public var rotateY : Number = 0;

		public var rotateZ : Number = 0;

		public var scaleX : Number = 1;

		public var scaleY : Number = 1;

		public var scaleZ : Number = 1;

		public var translateX : Number = 0;

		public var translateY : Number = 0;

		public var translateZ : Number = 0;

		public var visibility : Boolean = true;

		public function TransformParam()
		{
			super();
		}
	}
}
