package totem3d.core.datatypeobject
{
	import totem.core.params.URLAssetParam;
	
	public class Model3dParam extends URLAssetParam
	{
		[Marshall (type="com.totem.framework3d.core.datatypeobject.MeshParam")]
		public var meshData : MeshParam;
		
		public var textureData : Vector.<MaterialParam>;
		
		public var animationData : Vector.<AnimationParam>;
		
		public var title : String;
		
		public var material : String;
		
		public function Model3dParam()
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

