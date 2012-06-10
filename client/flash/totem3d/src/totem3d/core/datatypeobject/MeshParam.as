package totem3d.core.datatypeobject
{
	import totem.core.params.URLAssetParam;
	
	public class MeshParam extends URLAssetParam
	{
		public var scale : Number = 1;
		
		public var meshName : String;
		
		public function MeshParam()
		{
			super();
		}
	
	}
}

