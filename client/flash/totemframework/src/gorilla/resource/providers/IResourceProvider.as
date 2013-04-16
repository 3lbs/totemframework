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

/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package gorilla.resource.providers
{

	import gorilla.resource.Resource;

	/**
	 * This interface should be implemented by objects that can provide resources
	 * to the resourceManager
	 */
	public interface IResourceProvider
	{

		function cancel( resource : Resource ) : void;

		/**
		 * This method is called when the ResourceManager requests a known
		 * resource from a ResourceProvider
		 */
		function getResource( uri : String, type : Class, forceReload : Boolean = false ) : Resource;
		/**
		 * This method is called when the ResourceManager gets a load request
		 * for a resource and will check all known ResourceProviders if it has
		 * the specific resource
		 */
		function isResourceKnown( uri : String, type : Class ) : Boolean;

		function setPriority( resource : Resource, priority : Number ) : void;

		function unloadResource( uri : String, type : Class ) : void
	}
}
