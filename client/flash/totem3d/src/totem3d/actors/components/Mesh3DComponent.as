
//------------------------------------------------------------------------------
//
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem3d.actors.components
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.entities.Mesh;
	import away3d.events.Object3DEvent;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;

	import flash.events.Event;
	import flash.geom.Vector3D;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.core.TotemComponent;

	import totem3d.events.MeshEvent;

	/**
	 *
	 * @author eddie
	 */
	public class Mesh3DComponent extends TotemComponent implements IMesh3DComponent
	{
		/**
		 *
		 * @default NAME of component
		 */
		public static const NAME : String = "MeshComponent";

		/**
		 *
		 */
		public function Mesh3DComponent( name : String = null )
		{
			super( name );
		}

		private var _loadingBox : Mesh;

		private var _isAnimated : Boolean;

		private var _loaded : Boolean = true;

		private var _mesh : Mesh;

		private var _scale : Number = 1;

		private var _scene : Scene3D;

		public const meshUpdate : ISignal = new Signal( Mesh3DComponent );

		public const onPositionChanged : ISignal = new Signal( Vector3D );

		private var _meshStatus : int = EMPTY;

		public static const EMPTY : int = 0;

		public static const LOADED : int = 1;

		public static const FAILED : int = 2;

		public function get meshStatus() : int
		{
			return _meshStatus;
		}

		/**
		 *
		 * @param scene
		 */
		public function addToScene( scene : Scene3D ) : void
		{
			if ( mesh )
			{
				if ( isInScene )
				{
					removeFromScene();
				}

				scene.addChild( mesh );

			}

			_scene = scene;
		}

		/**
		 *
		 * @return
		 */
		public function get animated() : Boolean
		{
			return _isAnimated;
		}

		/**
		 *
		 * @return
		 */
		public function get debugBox() : Mesh
		{
			if ( !_loadingBox )
			{
				var cube : CubeGeometry = new CubeGeometry();
				_loadingBox = new Mesh( cube, new ColorMaterial( Math.random() * 0xFFFFFF ));
				_loadingBox.name = "DebugLoadingBox";
			}

			return _loadingBox;
		}


		/**
		 *
		 * @return
		 */
		public function get isInScene() : Boolean
		{
			return mesh.parent != null;
		}

		/**
		 *
		 * @return Is final mesh loaded
		 */
		public function get loaded() : Boolean
		{
			return _loaded;
		}

		/**
		 *
		 * @return Mesh Position
		 */
		public function get position() : Vector3D
		{
			return _mesh.position;
		}

		/**
		 *
		 * @param value
		 */
		public function set position( value : Vector3D ) : void
		{
			if ( _mesh && !value.equals( position ))
			{
				_mesh.position = value;
			}
		}

		/**
		 *
		 */
		public function removeFromScene() : void
		{
			if ( mesh.parent )
			{
				mesh.parent.removeChild( mesh );
			}
		}

		/**
		 *
		 * @return
		 */
		public function get scale() : Number
		{
			return _scale;
		}

		/**
		 *
		 * @param value
		 */
		public function set scale( value : Number ) : void
		{
			if ( mesh )
			{
				mesh.scaleX = mesh.scaleY = mesh.scaleZ = value;
			}

			_scale = value;
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			var spatialComponent : Spatial3DComponent = getSibling( Spatial3DComponent );
			spatialComponent.onUpdateSpatial.add( handleSpatialUpdate );
		}

		protected function handleSpatialUpdate( position : Vector3D ) : void
		{
			this.position = position;
		}

		override protected function onRemove() : void
		{
			super.onRemove();

			removeFromScene();
		}

		public function set mesh( value : Mesh ) : void
		{


			if ( _loadingBox )
			{
				_loadingBox.dispose();
				_loadingBox = null;
			}

			if ( _mesh )
			{
				if ( _mesh.hasEventListener( Object3DEvent.POSITION_CHANGED ))
					_mesh.removeEventListener( Object3DEvent.POSITION_CHANGED, handlePositionChanged );

				if ( _mesh.parent )
				{
					_scene.removeChild( _mesh );
				}

				_mesh.material = null;
					// if it is poolable u should do that here
			}

			_mesh = value;

			// scale
			scale = _scale;

			if ( _scene )
			{

				_mesh.material = new ColorMaterial( Math.random() * 0xFFFFFF );
				_scene.addChild( _mesh );
			}

			_mesh.addEventListener( Object3DEvent.POSITION_CHANGED, handlePositionChanged );

			_meshStatus = LOADED;

			meshUpdate.dispatch( this );
		}

		protected function handlePositionChanged( event : Event ) : void
		{
			onPositionChanged.dispatch( mesh.position );
		}

		/**
		 *
		 * @return
		 */
		public function get mesh() : Mesh
		{
			if ( !_loaded || !_mesh )
			{
				return debugBox as Mesh;
			}

			return _mesh;
		}

	}
}

