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

package totem.core.params.display
{

	import totem.components.animation.controller.AnimationHash;
	import totem.core.params.animation.AnimationInfo;

	public class MovieClipParam extends AssetParam
	{

		public var animationHashList : Vector.<AnimationHash>;

		public var fps : int;

		public var name : String;

		private var _animationInfo : Vector.<AnimationInfo> = new Vector.<AnimationInfo>();

		public function MovieClipParam()
		{
			super();
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
