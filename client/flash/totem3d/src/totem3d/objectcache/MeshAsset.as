package totem3d.objectcache
{
	import away3d.events.AssetEvent;
	import away3d.library.AssetLibrary;
	import away3d.loaders.parsers.MD5AnimParser;
	import away3d.loaders.parsers.MD5MeshParser;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.casalib.events.RemovableEventDispatcher;
	
	import totem.assets.IAsset;
	
	public class MeshAsset extends RemovableEventDispatcher implements IAsset
	{
		public function MeshAsset( target : IEventDispatcher = null )
		{
			super ( target );
		}
		
		public function get data() : Object
		{
			return null;
		}
		
		public function load() : void
		{
			AssetLibrary.enableParser ( MD5MeshParser );
			AssetLibrary.enableParser ( MD5AnimParser );
			
			AssetLibrary.addEventListener ( AssetEvent.ASSET_COMPLETE, onAssetComplete );
			//AssetLibrary.load(new URLRequest("assets/" + MD5_DIR + "/" + MESH_NAME + ".md5mesh"));
		}
		
		private function onAssetComplete( eve : AssetEvent ) : void
		{
			//_mesh = event.asset as Mesh;
			//_mesh.material = _bodyMaterial;
			dispatchEvent ( new Event ( Event.COMPLETE ) );
		}
		
		public function isReady() : void
		{
		}
	}
}

