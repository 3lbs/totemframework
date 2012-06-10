//------------------------------------------------------------------------------
//
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem3d.components
{
	import away3d.containers.Scene3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	
	import flash.geom.Vector3D;
	
	import totem.core.Component;
	import totem.resource.Resource;
	import totem.resource.ResourceManager;
	
	import totem3d.away3d.AwayMD5MeshResource;
	import totem3d.events.MeshEvent;
	import totem3d.events.Model3DEvent;
	
	/**
	 *
	 * @author eddie
	 */
	public class MeshComponent extends Component
	{
		/**
		 *
		 * @default NAME of component
		 */
		public static const NAME : String = "MeshComponent";
		
		
		public static var MODEL_UPDATE_REFERECENE : String = "@" + NAME + ".position";
		
		/**
		 *
		 * @default
		 */
		public static const MODEL_REFERENCE : String = "@" + NAME + ".displayObject3D";
		
		
		public static const MESH_STATUS : String = "@" + NAME + ".meshStatus";
		
		/**
		 *
		 * @param entity
		 * @return
		 */
		/*public static function getComponent( entity : IEntity ) : MeshComponent
		{
			return entity.lookupComponentByName ( NAME ) as MeshComponent;
		}
		*/
		/**
		 *
		 */
		public function MeshComponent()
		{
			super ();
		}
		
		[Inject]
		/**
		 *
		 * @default
		 */
		public var resourceManager : ResourceManager;
		
		private var _loadingBox : Mesh;
		
		private var _isAnimated : Boolean;
		
		private var _loaded : Boolean = true;
		
		//public var meshController : MeshAdaptorController;
		
		private var _mesh : Mesh;
		
		private var _position : Vector3D;
		
		private var _scale : Number = 1;
		
		private var _scene : Scene3D;
		
		private var _x : Number = 0;
		
		private var _y : Number = 0;
		
		private var _z : Number = 0;
		
		private var meshResource : Resource;
		
		private var meshPositionUpdateEvent : MeshEvent = new MeshEvent ( MeshEvent.POSITION_CHANGE );
		
		private var meshUpdateEvent : MeshEvent = new MeshEvent ( MeshEvent.MESH_UPDATE );
		
		public var meshStatus : int = EMPTY;
		
		public static const EMPTY : int = 0;
		
		public static const LOADED : int = 1;
		
		public static const FAILED : int = 2;
		/**
		 *
		 * @param scene
		 */
		public function addToScene( scene : Scene3D ) : void
		{
			if ( displayObject3D )
			{
				if ( isInScene )
				{
					removeFromScene ();
				}
				
				scene.addChild ( displayObject3D );
				
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
				var cube : CubeGeometry = new CubeGeometry ();
				_loadingBox = new Mesh ( cube, new ColorMaterial ( 0x00FF00 ) );
			}
			
			return _loadingBox;
		}
		
		/**
		 *
		 * @return
		 */
		public function get displayObject3D() : Mesh
		{
			if ( !_loaded || !_mesh )
			{
				return debugBox as Mesh;
			}
			
			return _mesh;
		}
		
		/**
		 *
		 * @return
		 */
		public function get isInScene() : Boolean
		{
			return displayObject3D.parent != null;
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
			_position.x = x;
			_position.y = y;
			_position.z = z;
			
			return _position;
		}
		
		/**
		 *
		 * @param value
		 */
		public function set position( value : Vector3D ) : void
		{
			if ( !value.equals ( position ) )
			{
				x = value.x;
				y = value.y;
				z = value.z;
				
				//owner.eventDispatcher.dispatchEvent ( meshPositionUpdateEvent );
			}
		}
		
		/**
		 *
		 */
		public function removeFromScene() : void
		{
			if ( displayObject3D.parent )
			{
				displayObject3D.parent.removeChild ( displayObject3D );
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
			if ( displayObject3D )
			{
				displayObject3D.scaleX = displayObject3D.scaleY = displayObject3D.scaleZ = value;
					//displayObject3D.scale( value );
			}
			
			_scale = value;
		}
		
		/**
		 *
		 * @return
		 */
		public function get x() : Number
		{
			return _x;
		}
		
		/**
		 *
		 * @param value
		 */
		public function set x( value : Number ) : void
		{
			if ( displayObject3D )
			{
				displayObject3D.x = value;
			}
			_x = value;
		}
		
		/**
		 *
		 * @return
		 */
		public function get y() : Number
		{
			return _y;
		}
		
		/**
		 *
		 * @param value
		 */
		public function set y( value : Number ) : void
		{
			if ( displayObject3D )
			{
				displayObject3D.y = value;
			}
			_y = value;
		}
		
		/**
		 *
		 * @return
		 */
		public function get z() : Number
		{
			return _z;
		}
		
		/**
		 *
		 * @param value
		 */
		public function set z( value : Number ) : void
		{
			if ( displayObject3D )
			{
				displayObject3D.z = value;
			}
			_z = value;
		}
		
		override public function onAdded() : void
		{
			super.onAdded ();
			
			_position = new Vector3D ();
			
			//owner.eventDispatcher.addEventListener ( Model3DEvent.LOAD_MODEL, loadMesh, false, 0, true );
		}
		
		override public function onRemoved() : void
		{
			super.onRemoved ();
			
			meshPositionUpdateEvent = null;
			
			removeFromScene ();
			
			//owner.eventDispatcher.removeEventListener ( Model3DEvent.LOAD_MODEL, loadMesh );
		}
		
		private function loadMesh( eve : Model3DEvent ) : void
		{
			var url : String = eve.data as String;
			resourceManager.load ( url, AwayMD5MeshResource, handleMeshLoaded );
		}
		
		private function handleMeshLoaded( resource : AwayMD5MeshResource ) : void
		{
			// might need to clone
			mesh = resource.mesh;
			meshStatus = LOADED;
			
			//should be changed to signals
			//owner.eventDispatcher.dispatchEvent ( meshUpdateEvent );
		}
		
		private function set mesh( value : Mesh ) : void
		{
			
			if ( _mesh || _loadingBox )
			{
				_mesh ||= _loadingBox as Mesh;
				
				// this should get done over
				if ( _mesh.parent )
				{
					_scene.removeChild ( _mesh );
				}
				
				_mesh.material = null;
				
					// if it is poolable u should do that here
			}
			
			_mesh = value;
			
			
			// scale
			scale = _scale;
			
			position = _mesh.position;
			
			if ( _scene )
			{
				_scene.addChild ( _mesh );
			}
		
		}
	}
}

