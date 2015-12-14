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

	import totem.components.animation.controller.AnimationHash;

	public class SkeletonDataParam
	{
		public var animationHashList : Vector.<AnimationHash>;

		public var armatureData : ArmatureDataParam;

		public var atlasID : String;

		public var fps : int;

		private var _animationInfo : Vector.<AnimationInfo> = new Vector.<AnimationInfo>();

		public function SkeletonDataParam()
		{
		}

		public function get animationInfo() : Vector.<AnimationInfo>
		{
			return _animationInfo;
		}

		public function set animationInfo( value : Vector.<AnimationInfo> ) : void
		{
			_animationInfo = value;
		}
	}
}
