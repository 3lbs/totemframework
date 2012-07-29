package totem3d.core.dto
{
	import totem.core.params.URLAssetParam;
	
	public class Model3DParam extends URLAssetParam
	{
		public var meshData : MeshParam;
		
		public var textureData : Vector.<MaterialParam>;
		
		public var animationData : Vector.<AnimationParam>;
		
		public var title : String;
		
		public var material : String;
		
		public var actionSpeed : Number = 1;
		
		public var updateRoot : Boolean = false;
		
		public function Model3DParam()
		{
		}
		
		public function create () : void
		{
			meshData = new MeshParam();
			
			textureData = new Vector.<MaterialParam>();
			
			animationData = new Vector.<AnimationParam>();
		}
	}
}

