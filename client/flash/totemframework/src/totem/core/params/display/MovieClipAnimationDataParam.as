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

package totem.core.params.display
{

	import totem.core.params.BaseParam;

	public class MovieClipAnimationDataParam extends BaseParam
	{
		
		public var atlasData : AtlasDataParam;
		
		public var animationDataList : Vector.<AnimationDataParam> = new Vector.<AnimationDataParam>();
		
		public var texturesName : String;
		
		public function MovieClipAnimationDataParam()
		{
			super();
			
			atlasData = new AtlasDataParam();
			animationDataList.push( new AnimationDataParam () );
			animationDataList.push( new AnimationDataParam () );
			animationDataList.push( new AnimationDataParam () );
		}
	}
}
