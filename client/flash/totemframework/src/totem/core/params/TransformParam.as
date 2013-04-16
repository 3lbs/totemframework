package totem.core.params
{
	
	public class TransformParam extends URLAssetParam
	{
		public var translateX : Number = 0;
		
		public var translateY : Number = 0;
		
		public var translateZ : Number = 0;
		
		public var scaleX : Number = 1;
		
		public var scaleY : Number = 1;
		
		public var scaleZ : Number = 1;
		
		public var rotateX : Number = 0;
		
		public var rotateY : Number = 0;
		
		public var rotateZ : Number = 0;
		
		public var visibility : Boolean = true;
		
		public var collision : Boolean = false;
		
		public function TransformParam()
		{
			super();
		}
	}
}