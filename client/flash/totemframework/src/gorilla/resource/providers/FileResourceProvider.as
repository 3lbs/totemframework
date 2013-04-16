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

package gorilla.resource.providers
{

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.utils.ByteArray;

	import gorilla.resource.Resource;

	import ladydebug.Logger;

	public class FileResourceProvider extends ResourceProviderBase
	{

		public function FileResourceProvider()
		{
			super();
		}

		/**
		 * This method will request a resource from this ResourceProvider
		 */
		override public function getResource( uri : String, type : Class, forceReload : Boolean = false ) : Resource
		{
			var resourceIdentifier : String = uri.toLowerCase() + type;

			// if resource is known return it.
			if ( resources[ resourceIdentifier ] != null && !forceReload )
			{
				return resources[ resourceIdentifier ];
			}

			//If force reload, delete old resource first:
			if ( resources[ resourceIdentifier ] && forceReload )
			{
				resources[ resourceIdentifier ] = null;
				delete resources[ resourceIdentifier ];
			}

			if ( resources[ resourceIdentifier ] == null )
			{
				// create resource and provide it to the ResourceManager
				var resource : Resource = new type();
				resource.filename = uri;
				resources[ resourceIdentifier ] = resource;
			}
			else
				resource = resources[ resourceIdentifier ];

			var workingFile : File = new File( uri );

			var fileStream : FileStreamLoadItem = new FileStreamLoadItem();
			fileStream.id = resourceIdentifier;
			fileStream.addEventListener( ProgressEvent.PROGRESS, onFileProgress ); // Add our the progress event listener
			fileStream.addEventListener( Event.COMPLETE, onFileComplete ); // Add our the complete event listener

			fileStream.openAsync( workingFile, FileMode.READ );

			//var yourJSONdata : String = fileStream.readUTFBytes( fileStream.bytesAvailable );

			//( resources[( event.currentTarget as LoadingItem ).id ] as Resource ).fail( event.text );

			return resource;
		}

		override public function isResourceKnown( uri : String, type : Class ) : Boolean
		{
			try
			{
				const file : File = new File( uri );

			}
			catch ( error : Error )
			{
				Logger.warn( this, uri, error.message );
				return false;
			}

			return ( file.exists && !file.isDirectory );
		}

		protected function onFileComplete( event : Event ) : void
		{
			var fileStream : FileStreamLoadItem = event.target as FileStreamLoadItem;
			fileStream.removeEventListener( ProgressEvent.PROGRESS, onFileProgress );
			fileStream.removeEventListener( Event.COMPLETE, onFileComplete );

			if ( resources[ fileStream.id ] != null )
			{
				var resource : Resource = resources[ fileStream.id ];

				var byteArray : ByteArray = new ByteArray();
				fileStream.readBytes( byteArray );
				fileStream.close();

				resource.initialize( byteArray );

				byteArray = null;

			}

		}

		protected function onFileProgress( event : ProgressEvent ) : void
		{
			// TODO Auto-generated method stub

		}
	}
}
