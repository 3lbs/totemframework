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

package gorilla.preloader
{

	import totem.events.RemovableEventDispatcher;

	public class ResourcePreloaderManager extends RemovableEventDispatcher
	{
		private static var _instance : ResourcePreloaderManager;

		public static function getInstance() : ResourcePreloaderManager
		{
			return _instance ||= new ResourcePreloaderManager( new SingletonEnforcer());
		}

		public function ResourcePreloaderManager( singletonEnforcer : SingletonEnforcer )
		{
			if ( !singletonEnforcer )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );
		}

		public function loadPreloadData( data : PreloaderParam ) : void
		{

		}

		public function loadStage( stage : int ) : void
		{

		}
	}
}

class SingletonEnforcer
{
}
