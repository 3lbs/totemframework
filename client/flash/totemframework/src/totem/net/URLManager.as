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

		private var _file : File;

		private var _url : String;

		public function URLManager( url : String, singletonEnforcer : SingletonEnforcer )
		{
			if ( !singletonEnforcer )
				throw new Error( "This class is a multiton and cannot be instantiated manually. Use URLManager.instance instead." );

			_url = url;
			_file = new File( _url );
		}

		public function getDeepURL( ... arg ) : String
		{
			var tFile : File = _file.clone();

			if ( arg.length > 0 )
			{
				for ( var i : int = 0; i < arg.length; ++i )
				{
					tFile = tFile.resolvePath( arg[ i ]);
				}
			}

			if ( !tFile.exists )
				Logger.warn( this, "getDeepUrl", "URL doesnt exsits: " + tFile.nativePath );

			return tFile.url;
		}

		public function getFileUrl( value : String ) : File
		{
			return _file.resolvePath( value );
		}

		public function getURL( value : String = "" ) : String
		{
			if ( value && value.indexOf( _url ) > -1 )
				return null;

			return _file.resolvePath( value || "" ).url;
		}

		public function getURLFromDelimtedString( value : String, delimiter : String = "|" ) : String
		{
			var tFile : File = _file.clone();
			var results : String = value.replace( delimiter, fileSeperator );
			tFile = tFile.resolvePath( results );

			if ( !tFile.exists )
				Logger.warn( this, "getURLFromDelimtedString", "URL doesnt exsits: " + tFile.nativePath );

			return tFile.url;
		}
	}
}

class SingletonEnforcer
{
}

