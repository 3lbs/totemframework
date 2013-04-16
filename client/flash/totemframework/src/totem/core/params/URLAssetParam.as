package totem.core.params
{
	
	public class URLAssetParam extends BaseParam
	{
		
		private var _url : String;
		
		public var embeded : Boolean;
		
		public function URLAssetParam()
		{
			super ();
		}
		
		public function get url() : String
		{
			return _url;
		}
		
		public function set url( value : String ) : void
		{
			_url = value;
		}
	}
}

