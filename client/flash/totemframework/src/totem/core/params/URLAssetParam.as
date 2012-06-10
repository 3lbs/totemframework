package totem.core.params
{
	
	public class URLAssetParam extends BaseParam
	{
		
		private var _url : String;
		
		private var _destroyed : Boolean;
		
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
		
		public function destroy() : void
		{
			_destroyed = true;
		}
		
		public function get destroyed() : Boolean
		{
			return _destroyed;
		}
	}
}

