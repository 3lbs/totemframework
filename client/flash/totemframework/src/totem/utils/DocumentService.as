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
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.utils
{

	import flash.errors.IOError;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class DocumentService extends EventDispatcher
	{

		private static var _instance : DocumentService;

		public static function getInstance() : DocumentService
		{
			return _instance ||= new DocumentService( new SingletonEnforcer());
		}

		private var fileStream : FileStream;

		public function DocumentService( singletonEnforcer : SingletonEnforcer )
		{
			if ( !singletonEnforcer )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );

			fileStream = new FileStream();
		}

		public function readFile( file : File ) : String
		{
			var str : String;

			try
			{
				fileStream = new FileStream();
				fileStream.open( file, FileMode.READ );

				str = fileStream.readUTFBytes( fileStream.bytesAvailable );
				fileStream.close();
			}
			catch ( error : IOError )
			{
				ioErrorHandler();
			}

			return str;
		}

		public function writeFile( file : File, outData : String ) : void
		{
			fileStream = new FileStream();

			try
			{
				fileStream.open( file, FileMode.WRITE );

				outData = outData.replace( /\n/g, File.lineEnding );
				fileStream.writeUTFBytes( outData );
				fileStream.close();
			}
			catch ( error : IOError )
			{
				ioErrorHandler();
			}
		}

		private function ioErrorHandler() : void
		{
			// TODO Auto Generated method stub
			trace( "IoError" );
		}
	}
}

class SingletonEnforcer
{
}
