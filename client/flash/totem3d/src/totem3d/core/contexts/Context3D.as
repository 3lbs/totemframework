package totem3d.core.contexts
{
	import away3d.containers.View3D;
	import away3d.debug.Trident;
	import away3d.primitives.CubeGeometry;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.geom.Vector3D;
	import flash.system.ApplicationDomain;
	
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.IInjector;
	
	import robotlegs.bender.framework.impl.Context;
	
	import totem3d.core.contexts.context3D.base.Mediator3DMap;
	import totem3d.core.contexts.context3D.core.IMediator3DMap;
	
	public class Context3D extends Context implements IContext
	{
		
		private var _view3D : View3D;
		
		private var _threeDeeMap : IMediator3DMap;
		
		private var _targetLookAt : Vector3D;
		
		private var box : CubeGeometry;
		
		private var trident : Trident;
		
		public function Context3D( contextView : DisplayObjectContainer = null, autoStartup : Boolean = true, parentInjector : IInjector = null, applicationDomain : ApplicationDomain = null )
		{
			//super ( null, contextView, autoStartup, parentInjector, applicationDomain );
		
		}
		
		public function get eventDispatcher () : IEventDispatcher
		{
			return null;
		}
		
		public function get view3D() : View3D
		{
			return _view3D || ( _view3D = new View3D () );
		}
		
		public function set view3D( value : View3D ) : void
		{
			_view3D = value;
		}
		
		public function get mediatorMap3D() : IMediator3DMap
		{
			return null;///_threeDeeMap ||= new Mediator3DMap ( view3D, injector.createChild (), reflector );
		}
		
		public function set mediatorMap3D( value : IMediator3DMap ) : void
		{
			_threeDeeMap = value;
		}
		
		protected function mapInjections() : void
		{
			//super.mapInjections ();
			//injector.mapValue ( View3D, view3D, "mainView" );
			//injector.mapValue ( IMediator3DMap, mediatorMap3D );
		}
		
		public function startup() : void
		{
			//super.startup ();
			
			view3D.camera.lens.far = 5000;
			view3D.camera.z = -200;
			view3D.camera.y = 160;
			view3D.camera.lookAt ( _targetLookAt = new Vector3D ( 0, 50, 0 ) );
		
		
		}
	}
}

