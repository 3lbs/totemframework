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

package totem3d.components
{

	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import flare.basic.Scene3D;
	import flare.core.Mesh3D;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.core.TotemComponent;
	import totem.utils.objectpool.ObjectPoolManager;
	
	import totem3d.loaders.IModel3DLoader;
	import totem3d.utils.meshpool.Mesh3DPoolFactory;
	import totem3d.utils.meshpool.Mesh3DPoolHelper;

	/**
	 *
	 * @author eddie
	 */
	public class Mesh3DComponent extends TotemComponent
	{

		public static const EMPTY : int = 0;

		public static const FAILED : int = 2;

		public static const LOADED : int = 1;

		/**
		 *
		 * @default NAME of component
		 */
		public static const NAME : String = "MeshComponent";

		public var meshUpdate : ISignal = new Signal( Mesh3DComponent );

		private var _isAnimated : Boolean;

		private var _loaded : Boolean = false;

		private var _mesh : Mesh3D;

		private var _meshID : String;

		//995-8111

		private var _meshName : String;

		private var _meshStatus : int = EMPTY;

		private var _poolMesh : Boolean = true;

		private var _scale : Number = 1;

		private var _scene : Scene3D;

		private var _visible : Boolean = true;

		private var loader : IModel3DLoader;

		/**
		 *
		 */
		public function Mesh3DComponent( name : String = null )
		{
			super( name || NAME );
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

				mesh.stop();
				mesh.prevFrame();

				meshUpdate.dispatch( this );

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
		 * @return
		 */
		public function get mesh() : Mesh3D
		{
			return _mesh;
		}

		public function set mesh( value : Mesh3D ) : void
		{
			removeFromScene();

			_loaded = false;
			_mesh = value;

			if ( _mesh )
			{
				_mesh.visible = _visible;

				addListeners();

				if ( _scene )
				{
					_scene.addChild( _mesh );
					_mesh.stop();
					_mesh.prevFrame();
				}
				_loaded = true;

				_meshStatus = LOADED;
			}

			meshUpdate.dispatch( this );
		}

		public function get meshID() : String
		{
			return _meshID;
		}

		public function set meshID( value : String ) : void
		{
			_meshID = value;
		}

		public function get meshName() : String
		{
			return _meshName;
		}

		public function set meshName( value : String ) : void
		{
			_meshName = value;
		}

		public function get meshStatus() : int
		{
			return _meshStatus;
		}

		public function get poolMesh() : Boolean
		{
			return _poolMesh;
		}

		public function set poolMesh( value : Boolean ) : void
		{
			_poolMesh = value;
		}

		/**
		 *
		 * @return Mesh Position
		 */
		public function get position() : Vector3D
		{
			return _mesh.getPosition();
		}

		/**
		 *
		 */
		public function removeFromScene() : void
		{
			if ( _mesh )
			{
				removeListeners();

				if ( _mesh.parent )
				{
					_mesh.parent.removeChild( _mesh );
				}
			}
		}

		public function removeMeshFromComponent() : Mesh3D
		{
			var tempMesh : Mesh3D;

			if ( _mesh )
			{
				if ( _mesh.parent )
				{
					_mesh.parent.removeChild( _mesh );
				}
				// if it is poolable u should do that here
				tempMesh = _mesh;
			}

			_mesh = null;

			return tempMesh;
		}

		public function rotateX( value : Number, local : Boolean = true, pivotPoint : Vector3D = null ) : void
		{
			if ( _mesh )
			{
				_mesh.rotateX( value, local, pivotPoint );
			}
		}

		public function rotateY( value : Number, local : Boolean = true, pivotPoint : Vector3D = null ) : void
		{
			if ( _mesh )
			{
				_mesh.rotateY( value, local, pivotPoint );
			}
		}

		public function rotateZ( value : Number, local : Boolean = true, pivotPoint : Vector3D = null ) : void
		{
			if ( _mesh )
			{
				_mesh.rotateZ( value, local, pivotPoint );
			}
		}

		public function get scene() : Scene3D
		{
			return _scene;
		}

		/**
		 *
		 * @param value
		 */
		public function setPosition( x : Number, y : Number, z : Number ) : void
		{
			if ( _mesh )
			{
				_mesh.setPosition( x, y, z );
			}
		}

		public function setRotation( x : Number, y : Number, z : Number ) : void
		{
			if ( _mesh )
			{
				_mesh.setRotation( x, y, z );
			}
		}

		public function setScale( _scaleX : Number, _scaleY : Number, _scaleZ : Number ) : void
		{
			if ( _mesh )
			{
				_mesh.setScale( _scaleX, _scaleY, _scaleZ );
			}
		}

		public function translateX( value : Number ) : void
		{
			if ( _mesh )
			{
				_mesh.translateX( value );
			}
		}

		public function translateY( value : Number ) : void
		{
			if ( _mesh )
			{
				_mesh.translateY( value );
			}
		}

		public function translateZ( value : Number ) : void
		{
			if ( _mesh )
			{
				_mesh.translateZ( value );
			}
		}

		public function get visible() : Boolean
		{
			return _visible;
		}

		public function set visible( value : Boolean ) : void
		{
			_visible = value;

			if ( _mesh )
			{
				_mesh.visible = value;
			}
		}

		override protected function onAdd() : void
		{
			super.onAdd();
		}

		override protected function onRemove() : void
		{
			super.onRemove();

			removeFromScene();

			removeListeners();

			meshUpdate.removeAll();
			meshUpdate = null;

			if ( poolMesh )
			{
				var objectPoolManager : ObjectPoolManager = ObjectPoolManager.getInstance();
				objectPoolManager.checkIn( _mesh, meshID );
			}
			else
			{
				_mesh.dispose();
			}

			_mesh = null;
		}

		private function addListeners() : void
		{
		}

		private function removeListeners() : void
		{

		}
	}
}

