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

	import flash.events.Event;
	
	import flare.core.Pivot3D;
	import flare.loaders.Flare3DLoader;
	
	import gorilla.resource.DataResource;
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;
	
	import totem.monitors.AbstractMonitorProxy;
	import totem.time.Stopwatch;
	
	import totem3d.core.param.AnimationParam;

	public class Flare3DModelLoader extends AbstractMonitorProxy implements IModel3DLoader
	{

		public var sceneLoader : Flare3DLoader;

		private var animationParamsList : Vector.<AnimationParam>;

		private var forceReload : Boolean;

		private var url : String;

		private var timer:Stopwatch;

		public function Flare3DModelLoader( url : String, params : Vector.<AnimationParam> = null, reload : Boolean = false )
		{
			super( url );

			forceReload = reload;

			this.url = url;

			this.animationParamsList = params;
		}

		override public function destroy() : void
		{
			super.destroy();

			animationParamsList = null;

			sceneLoader.dispose();
			sceneLoader = null;
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
			trace("timer for load model! " + timer.time );
			// objectpool
			// register with sessioncache

			sceneLoader.removeEventListener( Event.COMPLETE, handleModelLoaded );
			complete();
		}

		public function getMesh ( value : String ) : Pivot3D
		{
			return sceneLoader.getChildByName( value );
		}
			
		private function handleDataFailed( resouce : Resource ) : void
		{
			throw new Error( "Failed to load mesh " + url );
			complete();
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
