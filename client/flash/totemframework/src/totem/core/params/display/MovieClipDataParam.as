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
	import totem.core.params.animation.AnimationDataParam;

	public class MovieClipDataParam  extends AssetParam
	{

		public var fps : int;

		public var name : String;

		private var _animationData : Vector.<AnimationDataParam> = new Vector.<AnimationDataParam>();

		public function MovieClipDataParam()
		{
			super();
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
