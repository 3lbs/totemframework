//------------------------------------------------------------------------------
//
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                
//    |::.. . |                
//    `-------'      
//                       
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.net
{

	import flash.filesystem.File;
	
	import ladydebug.Logger;

	public class URLManager
	{
		public static var ASSET_URL : URLManager;

		public static var fileSeperator : String = File.separator;

		public static function instance( url : String ) : URLManager
		{
			return new URLManager( url + File.separator, new SingletonEnforcer());
		}

		public static function safeDelimetedURL( value : String, delimiter : String = "|" ) : String
		{
			return value.split( fileSeperator ).join( delimiter );
		}

		private var _file : File;

		private var _url : String;

		public function URLManager( url : String, singletonEnforcer : SingletonEnforcer )
		{
			if ( !singletonEnforcer )
				throw new Error( "This class is a multiton and cannot be instantiated manually. Use URLManager.instance instead." );

			_url = url;
			_file = new File( _url );
		}

		public function getFileUrl( value : String ) : File
		{
			return _file.resolvePath( value );
		}

		public function getURL( value : String = "", delimiter : String = "|" ) : String
		{
			if ( value && value.indexOf( _url ) > -1 )
				return null;
			
			if ( value == "" )
				return _file.nativePath + fileSeperator;

			var results : String = value.replace( delimiter, fileSeperator );
			var tFile : File = _file.resolvePath( results );

			if ( !tFile.exists )
			{
				trace( "getURL",  "URL doesnt exsits",  tFile.nativePath );
				Logger.warn( this, "getURL", "URL doesnt exsits: " + tFile.nativePath );
			}
			
			return tFile.url;
		}
	}
}

class SingletonEnforcer
{
}

