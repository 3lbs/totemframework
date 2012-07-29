package totem3d.core.model
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	
	import totem.core.ITotemSystem;
	import totem.core.time.ITicked;
	import totem.core.time.TimeManager;

	public class View3DManager implements ITicked, ITotemSystem
	{
		private var _view3D : View3D;
		
		[Inject]
		/**
		 *
		 * @default
		 */
		public var processManager : TimeManager;
		
		public function initialize () : void
		{
			processManager.addTickedObject( this );
		}
		
		public function onTick() : void
		{
			view3D.render();
		}

		public function View3DManager( view3D : View3D, name : String = null )
		{
			this.view3D = view3D;
			
			var _light : LightBase = new PointLight();
			_light.y = 5000;
			
			
			view3D.scene.addChild(_light);
		}

		public function addObjectContainer ( object : ObjectContainer3D ) : ObjectContainer3D
		{
			if ( _view3D )
			{
				return _view3D.scene.addChild( object );
			}
			
			return null;
		}
		
		public function removeObjectContainer ( object : ObjectContainer3D ) : void
		{
			if ( _view3D )
			{
				_view3D.scene.removeChild( object );
			}
		}
		
		public function contains ( object : ObjectContainer3D ) : Boolean
		{
			return _view3D.scene.contains( object );
		}
		
		public function setCamera ( camera : Camera3D ) : void
		{
			if ( _view3D )
			{
				_view3D.camera = camera;
			}
		}
		
		public function get view3D():View3D
		{
			return _view3D;
		}

		public function set view3D(value:View3D):void
		{
			_view3D = value;
		}
		
		public function onStart() : void
		{
			processManager.addTickedObject( this );
		}
		
		public function onStop() : void
		{
			processManager.removeTickedObject( this );
		}
		
		public function destroy () : void
		{
			
		}
	}
}
