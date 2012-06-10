package totem3d.core.controller
{
	import away3d.animators.SmoothSkeletonAnimator;
	import away3d.animators.data.SkeletonAnimationSequence;
	import away3d.animators.data.SkeletonAnimationState;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CubeGeometry;
	
	import totem.assets.IAsset;
	import totem3d.events.MeshEvent;
	
	import flash.events.IEventDispatcher;
	
	import org.casalib.events.RemovableEventDispatcher;
	
	public class MeshAdaptorController extends RemovableEventDispatcher implements IMeshLoader
	{
		private static const DEBUG_BOX:String = "DebugBox";
		
		private var _debugBox : CubeGeometry;
		
		private var _modelMesh : Mesh;
		
		private var _loaded : Boolean;
		;
		private var _isAnimated : Boolean;
		
		private var _bodyMaterial : TextureMaterial;
		
		private var _sequences : Vector.<SkeletonAnimationSequence>;
		
		private var _controller : SmoothSkeletonAnimator;
		
		//private var meshLoader : MeshLoaderService;
		
		public function MeshAdaptorController( a_animated : Boolean = false, target : IEventDispatcher = null )
		{
			super ( target );
			
			_isAnimated = a_animated;
			
			init ();
		}
		
		protected function init() : void
		{
			//meshLoader = new MeshLoaderService();
			//meshLoader.addEventListener( AssetEvent.ASSET_COMPLETE, handleMeshLoaded, false, 0, true );
			//meshLoader.addEventListener( LoaderEvent.LOAD_ERROR, handleMeshFailed, false, 0, true );
			_loaded = false;
			
			if ( animated )
				_controller = new SmoothSkeletonAnimator(SkeletonAnimationState(_modelMesh.animationState));
		
			//_controller.timeScale = _timeScale;
		
		}
		
		private function handleMeshLoaded( event : AssetEvent ):void
		{
			mesh = event.asset as Mesh;
			dispatchEvent( new MeshEvent( MeshEvent.MESH_COMPLETE ) );
		}
		
		private function handleMeshFailed ( event : LoaderEvent ) : void
		{
		
		}
		
		public function resourceLoader ( resource : IAsset ) :  void
		{
			//resource.addEventListener( Event.COMPLETE, 	
		}
		
		public function get mesh() : Mesh
		{
			if ( !_loaded || !_modelMesh )
			{
				return debugBox as Mesh;
			}
			return _modelMesh;
		}
		
		public function set mesh( value : Mesh ) : void
		{
			
			if ( value == null )
				return;
			
			_loaded = true;
			
			_modelMesh = value;
			
			dispatchEvent( new MeshEvent( MeshEvent.MESH_UPDATE ) );
		}
		
		public function get debugBox() : CubeGeometry
		{
			if ( !_debugBox )
			{
				_debugBox = new CubeGeometry ();
				_debugBox.name = DEBUG_BOX;
			}
			
			return _debugBox;
		}
		
		public function get loaded() : Boolean
		{
			return _loaded;
		}
		
		public function get animated() : Boolean
		{
			return _isAnimated;
		}
		
		override public function destroy() : void
		{
			if ( _modelMesh )
			{
				_modelMesh.dispose ();
				_modelMesh = null;
			}
			
			if ( _debugBox )
			{
				_debugBox.dispose ();
				_debugBox = null;	
			}
			
			//meshLoader.destroy();
			
			super.destroy();
		}
		
		public function get controller():SmoothSkeletonAnimator
		{
			return _controller;
		}
		
		
		public function loadMesh(url:String):void
		{
			//meshLoader.loadMesh( url );
			// TODO Auto Generated method stub
		
		}
	}
}

