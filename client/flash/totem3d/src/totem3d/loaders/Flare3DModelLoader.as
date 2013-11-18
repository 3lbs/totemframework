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

package totem3d.loaders
{

	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.loaders.Flare3DLoader;

	import flash.events.Event;

	import gorilla.resource.DataResource;
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;

	import totem.monitors.AbstractMonitorProxy;
	import totem.time.Stopwatch;
	import totem.utils.objectpool.ObjectPoolManager;

	import totem3d.components.Mesh3DComponent;
	import totem3d.utils.meshpool.Mesh3DPoolFactory;
	import totem3d.utils.meshpool.Mesh3DPoolHelper;

	public class Flare3DModelLoader extends AbstractMonitorProxy implements IModel3DLoader
	{

		public var meshID : *;

		public var meshName : String;

		public var poolMesh : Boolean = true;

		public var sceneLoader : Flare3DLoader;

		private var component : Mesh3DComponent;

		private var forceReload : Boolean;

		private var mesh : Mesh3D;

		private var timer : Stopwatch;

		private var url : String;

		public function Flare3DModelLoader( url : String, id : String = "", reload : Boolean = false )
		{
			super( id || url );

			forceReload = reload;

			this.url = url;

		}

		public function addComponent( component : Mesh3DComponent ) : void
		{

			this.component = component;

		}

		override public function destroy() : void
		{
			super.destroy();

			sceneLoader.dispose();
			sceneLoader = null;
		}

		public function getMesh() : Pivot3D
		{
			return mesh;
		}

		override public function start() : void
		{
			super.start();

			timer = new Stopwatch();
			timer.start();

			var resource : Resource = ResourceManager.getInstance().load( url, DataResource, forceReload );
			resource.completeCallback( handleDataLoaded );
			resource.failedCallback( handleDataFailed );

			//sceneLoader = new Flare3DLoader( url );
			//sceneLoader.addEventListener( Event.COMPLETE, handleModelLoaded, false, 0, true );
			//sceneLoader.load();

		}

		protected function handleModelLoaded( event : Event ) : void
		{

			// unload the data source or it will just stay around.
			ResourceManager.getInstance().unload( url, DataResource );

			timer.stop();
			sceneLoader.removeEventListener( Event.COMPLETE, handleModelLoaded );

			//mesh =  new Box("test", 50, 50, 50 ); 

			mesh = sceneLoader.getChildByName( meshName ) as Mesh3D;

			if ( poolMesh )
			{
				var objectPoolManager : ObjectPoolManager = ObjectPoolManager.getInstance();
				objectPoolManager.initObjectPool( meshID, 1, false, new Mesh3DPoolFactory( mesh ), new Mesh3DPoolHelper());
				mesh = objectPoolManager.checkOut( meshID ) as Mesh3D;
			}

			mesh.animationEnabled = false;
			mesh.stop();

			component.mesh = mesh;

			finished();
		}

		private function handleDataFailed( resouce : Resource ) : void
		{
			throw new Error( "Failed to load mesh " + url );
			finished();
		}

		private function handleDataLoaded( resource : DataResource ) : void
		{
			var data : * = resource.data;

			sceneLoader = new Flare3DLoader( data );
			sceneLoader.addEventListener( Event.COMPLETE, handleModelLoaded, false, 0, true );
			sceneLoader.load();
		}
	}
}
