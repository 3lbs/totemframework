package AI.params
{
	import totem.core.params.EntityParams;
	import totem.math.AABBox;
	
	public class BoidParams extends EntityParams
	{
		
		public var worldBounds : AABBox;
		
		public var parentNoid : String;
		
		public function BoidParams()
		{
		}
	}
}

