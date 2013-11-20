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

package totem3d.core.model
{

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import flare.basic.Scene3D;
	import flare.basic.Viewer3D;
	import flare.core.Camera3D;
	
	import totem.events.RemovableEventDispatcher;
	import totem.monitors.startupmonitor.IStartupProxy;
	import totem.utils.MobileUtil;

	public class Flare3DViewer3DModel extends RemovableEventDispatcher implements ITotemView3D, IStartupProxy
	{

		private var _viewer3D : Viewer3D;

		private var container : DisplayObjectContainer;

		public function Flare3DViewer3DModel( container : DisplayObjectContainer, id : String = "" )
		{
			this.container = container;
		}

		override public function destroy() : void
		{
			super.destroy();

			_viewer3D.dispose();
			_viewer3D = null;
		}

		public function load() : void
		{
			_viewer3D = new Viewer3D( container );
			_viewer3D.autoDispose = false;
			_viewer3D.addEventListener( Event.CONTEXT3D_CREATE, completeEvent );
		}

		public function reset() : void
		{
			_viewer3D.pause();
			_viewer3D.enableUpdateAndRender = false;

			var scene3D : Scene3D = _viewer3D.scene;

			while ( scene3D.children.length > 0 )
			{
				scene3D.removeChild( scene3D.children[ 0 ]);
			}

			scene3D.resetTransforms();

			_viewer3D.resetTransforms();

			var stage : Stage = container.stage;
			var viewPort : Rectangle = MobileUtil.viewRect();
			var camera : Camera3D = new Camera3D();
			_viewer3D.camera = camera;

			camera.viewPort = viewPort;
			_viewer3D.setViewport( 0, 0, viewPort.width, viewPort.height );

			_viewer3D.clearColor.setTo( 0, 0, 0 );
			_viewer3D.backgroundColor = 0xFFFFFF;
			_viewer3D.setupFrame(); // sets some global variables to use during the frame render..
			_viewer3D.context.clear(); // clear the back buffer.
			_viewer3D.render();

		}

		public function get viewer3D() : Viewer3D
		{
			return _viewer3D;
		}

		protected function completeEvent( event : Event ) : void
		{
			_viewer3D.removeEventListener( Event.CONTEXT3D_CREATE, completeEvent );
			reset();
			dispatchEvent( new Event( Event.COMPLETE ));
		}
	}
}
