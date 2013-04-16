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

	import gorilla.gorilla_internal;
	import gorilla.resource.Resource;

	import ladydebug.Logger;

	/**
	 * The EmbeddedResourceProvider provides the ResourceManager with the embedded
	 * resources that were loaded from ResourceBundle and ResourceBinding classes
	 *
	 * This class works using a singleton pattern so when resource bundles and/or
	 * resource bindings are initialized they will register the resources with
	 * the EmbeddedResourceProvider.instance
	 */
	public class EmbeddedResourceProvider extends ResourceProviderBase
	{

		// ------------------------------------------------------------
		// private and protected variables
		// ------------------------------------------------------------		
		private static var _instance : EmbeddedResourceProvider = null;

		// ------------------------------------------------------------
		// public getter/setter property functions
		// ------------------------------------------------------------

		/**
		 * The singleton instance of the resource manager.
		 */
		public static function getInstance() : EmbeddedResourceProvider
		{
			if ( !_instance )
				_instance = new EmbeddedResourceProvider( new EmbededSingletonEnforcer());

			return _instance;
		}

		// ------------------------------------------------------------
		// public methods
		// ------------------------------------------------------------

		/**
		* Contructor
		*
		* Calls the ResourceProvideBase constructor  - super();
		* to auto-register this provider with the ResourceManager
		*/
		public function EmbeddedResourceProvider( singletonEnforcer : EmbededSingletonEnforcer )
		{
			if ( !singletonEnforcer )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );
		}

		override public function unloadResource( uri : String, type : Class ) : void
		{
			// do nothing cant unload embeded resources
		}

		/**
		* This method is used by the ResourceBundle and ResourceBinding Class to
		* register the existance of a specific embedded resource
		*/
		gorilla_internal function registerResource( filename : String, resourceType : Class, data : * ) : void
		{
			// create a unique identifier for this resource
			var resourceIdentifier : String = filename.toLowerCase() + resourceType;

			// check if the resource has already been registered            
			if ( resources[ resourceIdentifier ])
			{
				Logger.warn( this, "registerEmbeddedResource", "A resource from file " + filename + " has already been embedded." );
				return;
			}

			// Set up the resource
			try
			{
				var resource : Resource = new resourceType();
				resource.filename = filename;
				resource.initialize( data );

				// keep the resource in the lookup dictionary                
				resources[ resourceIdentifier ] = resource;
			}
			catch ( e : Error )
			{
				Logger.error( this, "registerEmbeddedResources", "Could not instantiate resource " + filename + " due to error:\n" + e.toString());
				return;
			}
		}
	}
}

class EmbededSingletonEnforcer
{
}
