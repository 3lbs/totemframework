package totem3d.core.dto
{
	import totem.core.params.URLAssetParam;
	import totem.net.URLManager;
	import totem.net.getURL;
	
	public class AnimationParam extends URLAssetParam
	{
		public var fps : int;
		
		public var loop : Boolean = false;
		
		public var actionSpeed : Number = 1;
		
		public function AnimationParam()
		{
		}
	}
}

