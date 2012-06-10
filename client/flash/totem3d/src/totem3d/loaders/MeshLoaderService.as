package totem3d.loaders
{
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.loaders.misc.AssetLoaderToken;
	import away3d.loaders.parsers.MD5MeshParser;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.casalib.events.RemovableEventDispatcher;
	
	public class MeshLoaderService extends RemovableEventDispatcher
	{
		public function MeshLoaderService()
		{
			super ();
			
			init();
		}
		
		private function init () : void
		{
			AssetLibrary.enableParser ( MD5MeshParser );
			
			AssetLibrary.addEventListener ( AssetEvent.ASSET_COMPLETE, handleMeshLoaded );
			AssetLibrary.addEventListener( LoaderEvent.LOAD_ERROR, handleMeshFailed );
		}
		
		public function loadMesh( url : String ) : void
		{
			//AssetLibrary.enableParser(MD5AnimParser);
			var token : AssetLoaderToken = AssetLibrary.load ( new URLRequest ( url ) );
		}
		
		private function handleMeshLoaded( event : AssetEvent ) : void
		{
			var mesh : Mesh = event.asset as Mesh;
			dispatchEvent ( new AssetEvent ( AssetEvent.ASSET_COMPLETE, mesh ) );
		}
		
		private function handleMeshFailed( eve : Event ) : void
		{
			dispatchEvent ( new AssetEvent ( LoaderEvent.LOAD_ERROR ) );
		}
		
		override public function destroy () : void
		{
			super.destroy();
			
			removeListeners ();
		}
		
		private function removeListeners():void
		{
			AssetLibrary.removeEventListener( AssetEvent.ASSET_COMPLETE, handleMeshLoaded );
			AssetLibrary.removeEventListener( LoaderEvent.LOAD_ERROR, handleMeshFailed );
		}
	}
}

