package totem3d.core.param
{
	import totem.core.params.URLAssetParam;
	
	public class Model3DParam extends URLAssetParam
	{
		public var scale : Number = 1;
		
		public var animationData : Vector.<AnimationParam> = new Vector.<AnimationParam>();
		
		public var frameSpeed : Number = 1;
		
		public var updateRoot : Boolean = false;
		
		public function Model3DParam()
		{
		}
	}
}

