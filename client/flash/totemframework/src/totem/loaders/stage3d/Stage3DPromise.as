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

package totem.loaders.stage3d
{

	import flash.display.Stage;
	import flash.events.Event;

	import totem.loaders.stage3d.Stage3DEvent;
	import totem.loaders.stage3d.Stage3DManager;
	import totem.loaders.stage3d.Stage3DProxy;
	import totem.monitors.promise.Deferred;

	public class Stage3DPromise extends Deferred
	{
		private var _stageProxy : Stage3DProxy;

		public function Stage3DPromise( stage : Stage, color : int = 0x000000 )
		{
			var stage3DManager : Stage3DManager = Stage3DManager.getInstance( stage );

			// Create a new Stage3D proxy for the first Stage3D scene
			_stageProxy = stage3DManager.getFreeStage3DProxy();
			_stageProxy.addEventListener( Stage3DEvent.CONTEXT3D_CREATED, onContextCreated );
			_stageProxy.color = color;
		}

		protected function onContextCreated( event : Event ) : void
		{
			_stageProxy.removeEventListener( Stage3DEvent.CONTEXT3D_CREATED, onContextCreated );
			resolve( _stageProxy );

			_stageProxy = null;
		}
	}
}
