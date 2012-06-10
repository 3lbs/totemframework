package totem3d.core.datatypeobject
{
	import totem.net.URLManager;
	
	public class AnimationParam
	{
		public var fps : int;
		
		public var id : String;
		
		public var name : String;
		
		public var type : String;
		
		public var url : String;
		
		public var loop : Boolean = false;
		
		public var actionSpeed : Number = 1;
		
		private var _projectURL : String;
		
		public var updateRoot : Boolean = true;
		
		public function AnimationParam()
		{
		}
		
		public function setParentURL( value : String ) : void
		{
			_projectURL = value;
		}
		
		public function projectURL() : String
		{
			return URLManager.getAssetURL( url );
		}
	}
}

