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

package application
{

	import com.adobe.air.crypto.EncryptionKeyGenerator;

	import flash.data.SQLConnection;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	import mx.collections.ArrayCollection;

	import nz.co.codec.flexorm.EntityManager;

	import totem.core.mvc.model.Model;

	public class AppDatabaseService extends Model
	{

		public static var application : App;

		public static var newInstall : Boolean;

		public static function getAppProp( key : String ) : *
		{
			return AppDatabaseService.application.getAppProp( key );
		}

		public static function getEncriptionKey( password : String ) : ByteArray
		{

			//var password : String = "stewiegriffen";
			var keyGenerator : EncryptionKeyGenerator = new EncryptionKeyGenerator();

			if ( !keyGenerator.validateStrongPassword( password ))
			{
				//statusMsg.text = "The password must be 8-32 characters long. It must contain at least one lowercase letter, at least one uppercase letter, and at least one number or symbol.";
				return null;
			}

			var encryptionKey : ByteArray = keyGenerator.getEncryptionKey( password );

			return encryptionKey;

		}

		public static function getList( clazz : Class ) : ArrayCollection
		{
			var allUsers : ArrayCollection = EntityManager.instance.findAll( clazz );
			return allUsers;
		}

		public static function removeData( data : * ) : void
		{
			//entityManager.startTransaction();
			EntityManager.instance.remove( data );
			//entityManager.endTransaction();
		}

		public static function saveData( data : * ) : void
		{
			var test : * = EntityManager.instance.save( data );
		}

		public static function setAppProp( key : String, value : * ) : *
		{
			AppDatabaseService.application.appProps[ key ] = value;
			updateApplication();
			return value;
		}

		public static function updateApplication() : void
		{
			var test : * = EntityManager.instance.save( application );
		}

		public var gameProp : Object;

		protected var entityManager : EntityManager = EntityManager.instance;

		private var conn : SQLConnection;

		private var dbFile : File;

		private var password : String;

		public function AppDatabaseService( p : String, url : String )
		{
			dbFile = File.applicationStorageDirectory.resolvePath( url );

			password = p;
			conn = new SQLConnection();
		}

		override public function destroy() : void
		{
			super.destroy();
			conn.close();
		}

		override public function load() : void
		{
			var encrytpedPassword : ByteArray = null; //UserConfig.getEncriptionKey( password );

			if ( conn == null )
			{
				throw new ArgumentError( "The database connection can't be null." );
			}

			if ( conn.connected )
			{
				throw new ArgumentError( "The database connection is already open." );
			}

			if ( dbFile.isDirectory )
			{
				throw new ArgumentError( "The file name must refer to an existing file (not a directory)." );
			}

			if ( !dbFile.exists )
			{
				newInstall = true;
			}
			entityManager.openSyncConnection( dbFile.nativePath );

			application = entityManager.loadItem( App, 1 ) as App;

			if ( !application )
			{
				application = new App();
			}

			//application.launches += 1;
			AppDatabaseService.application.launches += 1;

			entityManager.save( application );

			dispatchEvent( new Event( Event.COMPLETE ));
		}
	}
}

class SingletonEnforcer
{
}
