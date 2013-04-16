package totem.utils
{

	import flash.filesystem.File;

	public class URLUtil
	{
		public function URLUtil()
		{
		}

		/**
		 * Determine the file extension of a file.
		 * @param file A path to a file.
		 * @return The file extension.
		 *
		 */
		public static function getFileExtension( file : String ) : String
		{
			var extensionIndex : Number = file.lastIndexOf( "." );

			if ( extensionIndex == -1 )
			{
				//No extension
				return "";
			}
			else
			{
				return file.substr( extensionIndex + 1, file.length ).toLowerCase();
			}
		}

		public static function concatString( ... args ) : String
		{
			var result : String = args.join( File.separator );

			if ( getFileExtension( result ) == "" )
				result += File.separator;

			return result;
		}
	}
}
