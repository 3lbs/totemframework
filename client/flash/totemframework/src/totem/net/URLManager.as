package totem.net
{
	import flash.utils.Dictionary;
	
	public class URLManager
	{
		
		public static var assetURL : String;
		
		public static var urlMap : Dictionary = new Dictionary ();
		
		public function URLManager()
		{
		}
		
		public static function getAssetURL( url : String ) : String
		{
			return assetURL + url;
		}
		
		public static function setURLByType( url : String, type : String ) : void
		{
			if ( !urlMap[ type ] )
				urlMap[ type ] = url;
		
		}
		
		public static function getURLByType( url : String, type : String ) : String
		{
			var s : String = urlMap[ type ];
			
			if ( s )
				return s + url;
			
			return null;
		}
	}
}

