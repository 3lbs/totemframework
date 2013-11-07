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

package totem3d.core.param
{

	import totem.core.params.URLAssetParam;

	public class AnimationParam extends URLAssetParam
	{

		public var animationMode : int = 0;

		public var frameSpeed : int = 1;

		public var from : Number = 0;

		public var to : Number = 0;

		public function AnimationParam()
		{
		}

		[Transient]
		public function get length() : int
		{
			return to - from;
		}
	}
}

