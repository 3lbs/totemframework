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

package totem.core.params.animation
{

	public class SkeletonDataParam
	{

		public var armatureData : ArmatureDataParam;

		public var fps : int;

		public var atlasID : String;

		private var _animationData : Vector.<AnimationDataParam> = new Vector.<AnimationDataParam>();

		public function SkeletonDataParam()
		{
		}

		public function get animationData() : Vector.<AnimationDataParam>
		{
			return _animationData;
		}

		public function set animationData( value : Vector.<AnimationDataParam> ) : void
		{
			_animationData = value;
		}
	}
}
