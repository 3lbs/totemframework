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

package totem.loaders.starling
{

	import gorilla.resource.DragonBonesResource;
	import gorilla.resource.ResourceManager;
	
	import totem.monitors.RequiredProxy;

	public class DragonBonesLoader extends RequiredProxy
	{
		private var url : String;

		public function DragonBonesLoader( url : String, id : String = "" )
		{
			this.id = id || url;
			this.url = url;

			super( id );
		}

		override public function start() : void
		{

			super.start();
			
			var dragonResource : DragonBonesResource = ResourceManager.getInstance().load( url, DragonBonesResource ) as DragonBonesResource;
			dragonResource.completeCallback( handleArmatureLoaded );
		}

		protected function handleArmatureLoaded( resoure : DragonBonesResource ) : void
		{
			DragonBonesFactoryCache.getInstance().createIndex( id, resoure.factory );
			finished();
		}
	}
}
