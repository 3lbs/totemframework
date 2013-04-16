package totem.net
{
	public class URLManager
	{
		public static var ASSET_URL : URLManager;

		private var _url : String;

		public static var fileSeperator : String;
		
		public function URLManager( url : String, singletonEnforcer : SingletonEnforcer )
		{
			if ( !singletonEnforcer )
				throw new Error( "This class is a multiton and cannot be instantiated manually. Use URLManager.instance instead." );

			_url = url;
		}

		public static function instance( url : String ) : URLManager
		{
			return new URLManager( url, new SingletonEnforcer());
		}

		public function getURL( value : String = "" ) : String
		{
			if ( value && value.indexOf( _url ) > -1 )
				return value;

			
			var u : String = _url;
			
			
			return _url + (value || "");
		}
		
		public function getDeepURL( ...arg ) : String
		{
			
			var u : String = _url + arg[0];
			
			if ( arg.length > 1 )
			{
				for ( var i : int = 1; i<arg.length; ++i )
				{
					u += fileSeperator + arg[i]; 
				}
			}
			
			return u;
		}
		
		
	}
}

class SingletonEnforcer
{
}

