package totem.net
{
	import flash.utils.Dictionary;

	public class URLManager
	{
		public static var ASSET_URL : String = "URLManager:AssetUrl";

		private static var _instances : Dictionary;
		
		private var _url:String;

		public function URLManager( type : String, singletonEnforcer : SingletonEnforcer )
		{
			if ( !singletonEnforcer )
				throw new Error( "This class is a multiton and cannot be instantiated manually. Use URLManager.instance instead." );
			
			_url = type;
		}

		public static function instance( type : String ) : URLManager
		{
			return ( _instances ||= new Dictionary())[ type ] ||= new URLManager( type, new SingletonEnforcer());
		}

		public function getURL( value : String ) : String
		{
			return _url + value;
		}
	}
}

class SingletonEnforcer
{
}

