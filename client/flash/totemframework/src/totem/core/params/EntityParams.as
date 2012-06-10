package totem.core.params
{
	import totem.math.AABBox;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Vector3D;
	
	public class EntityParams
	{
		
		public var type:String;
		
		public var displayClass : Class;
		
		public var contextView : DisplayObjectContainer;
		
		public var bounds : AABBox;
		
		public var position : Vector3D;
		
		public function EntityParams()
		{
		}
	}
}

