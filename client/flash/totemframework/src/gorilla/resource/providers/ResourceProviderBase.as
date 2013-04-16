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

	import flash.utils.Dictionary;

	import gorilla.resource.Resource;

	import ladydebug.Logger;

	/**
	 * The ResourceProviderBase class provides useful functionality for implementing
	 * resource providers for the ResourceManager.
	 *
	 * Register a ResourceProvider by doing resourceManager.registerResourceProvider(new MyProvider());
	 */
	public class ResourceProviderBase implements IResourceProvider
	{
		/**
		 * Storage of resources known by this provider.
		 */
		protected var resources : Dictionary = new Dictionary();

		public function cancel( resource : Resource ) : void
		{
			Logger.warn( this, "cancel", "No cancel support in this resource provider." );
		}

		/**
		 * This method will request a resource from this ResourceProvider
		 */
		public function getResource( uri : String, type : Class, forceReload : Boolean = false ) : Resource
		{
			var resourceIdentifier : String = uri.toLowerCase() + type;
			return resources[ resourceIdentifier ];
		}

		/**
		 * This method will check if this provider has access to a specific Resource
		 */
		public function isResourceKnown( uri : String, type : Class ) : Boolean
		{
			var resourceIdentifier : String = uri.toLowerCase() + type;
			return ( resources[ resourceIdentifier ] != null );
		}

		public function setPriority( resource : Resource, priority : Number ) : void
		{
			Logger.warn( this, "setPriority", "No priority support in this resource provider." );
		}

		/**
		 * This method will unload resource
		 * @param uri
		 * @param type resource class
		 * @param resource
		 *
		 */
		public function unloadResource( uri : String, type : Class ) : void
		{
			var resourceIdentifier : String = uri.toLowerCase() + type;

			if ( resources[ resourceIdentifier ])
			{
				resources[ resourceIdentifier ] = null;
				delete resources[ resourceIdentifier ];
			}

		}

		/**
		 * This method will add a resource to the resource's Dictionary
		 */
		protected function addResource( uri : String, type : Class, resource : Resource ) : void
		{
			var resourceIdentifier : String = uri.toLowerCase() + type;
			resources[ resourceIdentifier ] = resource;
		}
	}
}
