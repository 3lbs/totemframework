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
package gorilla.resource
{

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	import gorilla.resource.providers.IResourceProvider;

	import ladydebug.Logger;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	/**
	 * @eventType com.pblabs.engine.resource.ResourceEvent.LOADED_EVENT
	 */
	[Event( name = "LOADED_EVENT", type = "totem.resource.ResourceEvent" )]
	/**
	 * @eventType com.pblabs.engine.resource.ResourceEvent.FAILED_EVENT
	 */
	[Event( name = "FAILED_EVENT", type = "totem.resource.ResourceEvent" )]
	/**
	 * A resource contains data for a specific type of game asset. This base
	 * class does not define what that type is, so subclasses should be created
	 * and used for each different type of asset.
	 *
	 * <p>The Resource class and any subclasses should never be instantiated
	 * directly. Instead, use the ResourceManager class.</p>
	 *
	 * <p>Usually, resources are created by loading data from a file, but this is not
	 * necessarily a requirement</p>
	 *
	 * @see ResourceManager
	 */
	public class Resource implements IResource
	{
		public var provider : IResourceProvider;

		protected var _didFail : Boolean = false;

		protected var _filename : String = null;

		protected var _isLoaded : Boolean = false;

		protected var _loader : Loader;

		protected var _referenceCount : int = 0;

		protected var _urlLoader : URLLoader;

		protected var complete : ISignal = new Signal( Resource );

		protected var failed : ISignal = new Signal( Resource );

		private var _id : *;

		public function completeCallback( resourceComplete : Function ) : void
		{
			complete.addOnce( resourceComplete );

			if ( _isLoaded && !_didFail )
			{
				complete.dispatch( this );
				failed.removeAll();
			}

		}

		public function get data() : *
		{
			return null;
		}

		/**
		 * Decrements the number of references to the resource. This should only ever be
		 * called by the ResourceManager.
		 */
		public function decrementReferenceCount() : void
		{
			_referenceCount--;
		}

		public function destroy() : void
		{
			_urlLoader = null;

			if ( _loader )
			{
				_loader.unloadAndStop();
				_loader = null;
			}

			complete.removeAll();
			complete = null;

			failed.removeAll();
			failed = null;

			provider = null;
		}

		/**
		 * Whether or not the resource failed to load. This is only valid after the resource
		 * has loaded, so being false only verifies a successful load if IsLoaded is true.
		 *
		 * @see #IsLoaded
		 */
		public function get didFail() : Boolean
		{
			return _didFail;
		}

		/**
		 * This method will be used by a Resource Provider to indicate that this
		 * resource has failed loading
		 */
		public function fail( message : String ) : void
		{
			onFailed( message );
		}

		public function failedCallback( resourceFails : Function ) : void
		{

			if ( _isLoaded )
			{
				if ( _didFail )
				{
					failed.dispatch( this );
					complete.removeAll();
				}
				failed.removeAll();
			}
			else
			{
				failed.addOnce( resourceFails );
			}
		}

		/**
		 * The filename the resource data was loaded from.
		 */
		public function get filename() : String
		{
			return _filename;
		}

		/**
		 * @private
		 */
		public function set filename( value : String ) : void
		{
			if ( _filename != null )
			{
				Logger.warn( this, "set filename", "Can't change the filename of a resource once it has been set." );
				return;
			}

			_filename = value;
		}

		public function get id() : *
		{
			return _id;
		}

		public function set id( value : * ) : void
		{

			if ( id != null )
			{
				// you cant change the ID of a resouces
				return;
			}
			_id = value;
		}

		/**
		 * Increments the number of references to the resource. This should only ever be
		 * called by the ResourceManager.
		 */
		public function incrementReferenceCount() : void
		{
			_referenceCount++;
		}

		/**
		 * initializes the resource with data from a byte array. This implementation loads
		 * the data with a content loader. If that behavior is not needed (XML doesn't need
		 * this, for example), this method can be overridden. Subclasses that do override this
		 * method must call onLoadComplete when they have finished loading and conditioning
		 * the byte array.
		 *
		 * @param data The data to initialize the resource with.
		 */
		public function initialize( data : * ) : void
		{
			if ( !( data is ByteArray ))
				throw new Error( "Default Resource can only process ByteArrays!" );

			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadComplete );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onDownloadError );
			loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onDownloadSecurityError );

			var _lc : LoaderContext = new LoaderContext( false, ApplicationDomain.currentDomain, null );
			_lc.allowCodeImport = true;

			loader.loadBytes( data, _lc );

			// Keep reference so the Loader isn't GC'ed.
			_loader = loader;
		}

		/**
		 * Whether or not the resource has been loaded. This only marks whether loading has
		 * been completed, not whether it succeeded. If this is true, DidFail can be checked
		 * to see if loading was successful.
		 *
		 * @see #DidFail
		 */
		public function get isLoaded() : Boolean
		{
			return _isLoaded;
		}

		/**
		 * Loads resource data from a file.
		 *
		 * @param filename The filename or url to load data from. A ResourceEvent will be
		 * dispatched when the load completes - LOADED_EVENT on successful load, or
		 * FAILED_EVENT if the load fails.
		 */
		public function load( filename : String ) : void
		{
			_filename = filename;

			var loader : URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener( Event.COMPLETE, onDownloadComplete );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onDownloadError );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onDownloadSecurityError );

			var request : URLRequest = new URLRequest();
			request.url = filename;

			loader.load( request );

			// Keep reference so the URLLoader isn't GC'ed.
			_urlLoader = loader;
		}

		/**
		 * The number of places this resource is currently referenced from. When this reaches
		 * zero, the resource will be unloaded.
		 */
		public function get referenceCount() : int
		{
			return _referenceCount;
		}

		/**
		 * This is called when the resource data has been fully loaded and conditioned.
		 * Returning true from this method means the load was successful. False indicates
		 * failure. Subclasses must implement this method.
		 *
		 * @param content The fully conditioned data for this resource.
		 *
		 * @return True if content contains valid data, false otherwise.
		 */
		protected function onContentReady( content : * ) : Boolean
		{
			return false;
		}

		protected function onDownloadComplete( event : Event ) : void
		{
			var data : ByteArray = (( event.target ) as URLLoader ).data as ByteArray;
			initialize( data );
		}

		protected function onDownloadError( event : IOErrorEvent ) : void
		{
			onFailed( event.text );
		}

		protected function onDownloadSecurityError( event : SecurityErrorEvent ) : void
		{
			onFailed( event.text );
		}

		protected function onFailed( message : String ) : void
		{
			_isLoaded = true;
			_didFail = true;
			Logger.error( this, "Load", "Resource " + _filename + " failed to load with error: " + message );

			failed.dispatch( this );
			complete.removeAll();

			_urlLoader = null;
			_loader = null;
		}

		/**
		 * Called when loading and conditioning of the resource data is complete. This
		 * must be called by, and only by, subclasses that override the initialize
		 * method.
		 *
		 * @param event This can be ignored by subclasses.
		 */
		protected function onLoadComplete( event : Event = null ) : void
		{
			if ( onContentReady( event ? event.target.content : null ))
			{
				_isLoaded = true;
				_urlLoader = null;
				_loader = null;

				failed.removeAll();
				complete.dispatch( this );


			}
			else
			{
				onFailed( "Got false from onContentReady - the data wasn't accepted." );
				return;
			}

		}

		/**
		 * The Loader object that was used to load this resource.
		 * This is set to null after onContentReady returns true.
		 */
		protected function get resourceLoader() : Loader
		{
			return _loader;
		}
	}
}

