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
	
	import totem.events.RemovableEventDispatcher;
	import totem.monitors.startupmonitor.IStartupProxy;

	public class AppDatabaseService extends RemovableEventDispatcher implements IStartupProxy
	{

		private static var _instance : AppDatabaseService;

		public static function createDatabase( p : String, url : String ) : AppDatabaseService
		{
			return _instance ||= new AppDatabaseService( new SingletonEnforcer(), p, url );
		}

		public static function getInstance() : AppDatabaseService
		{
			if ( !_instance )
				throw new Error( "Database has not been created" );

			return _instance;
		}

		public var gameProp : Object;

		public var newInstall : Boolean;

		protected var entityManager : EntityManager = EntityManager.instance;

		private var app : App;

		private var conn : SQLConnection;

		private var dbFile : File;

		private var password : String;

		public function AppDatabaseService( enforcer : SingletonEnforcer, p : String, url : String )
		{
			dbFile = File.applicationStorageDirectory.resolvePath( url );

			password = p;
			conn = new SQLConnection();
		}

		public function getApp() : App
		{
			return app;
		}

		override public function destroy() : void
		{
			super.destroy();
			conn.close();
		}

		public function getAppProp( key : String ) : *
		{
			return app.getAppProp( key );
		}

		public function getEncriptionKey( password : String ) : ByteArray
		{

			//var password : StrFing = "stewiegriffen";
			var keyGenerator : EncryptionKeyGenerator = new EncryptionKeyGenerator();

			if ( !keyGenerator.validateStrongPassword( password ))
			{
				//statusMsg.text = "The password must be 8-32 characters long. It must contain at least one lowercase letter, at least one uppercase letter, and at least one number or symbol.";
				return null;
			}

			var encryptionKey : ByteArray = keyGenerator.getEncryptionKey( password );

			return encryptionKey;

		}

		public function getList( clazz : Class ) : ArrayCollection
		{
			var list : ArrayCollection = EntityManager.instance.findAll( clazz );
			return list;
		}

		public function load() : void
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

			app = entityManager.loadItem( App, 1 ) as App;

			if ( !app )
			{
				app = new App();
			}

			//application.launches += 1;
			app.launches += 1;

			entityManager.save( app );

			dispatchEvent( new Event( Event.COMPLETE ));
		}

		public function removeData( data : * ) : void
		{
			//entityManager.startTransaction();
			EntityManager.instance.remove( data );			
			//entityManager.endTransaction();
		}

		public function saveData( data : * ) : void
		{
			var test : * = EntityManager.instance.save( data );
		}

		public function setAppProp( key : String, value : * ) : *
		{
			app.appProps[ key ] = value;
			updateApplication();
			return value;
		}

		public function updateApplication() : void
		{
			var test : * = EntityManager.instance.save( app );
		}
	}
}

class SingletonEnforcer
{
}
