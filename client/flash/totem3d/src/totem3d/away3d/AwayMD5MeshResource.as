package totem3d.away3d
{
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.ParserEvent;
	import away3d.loaders.parsers.MD5MeshParser;
	
	import flash.utils.ByteArray;
	
	import totem.resource.Resource;
	
	public class AwayMD5MeshResource extends Resource
	{
		private var _mesh : Mesh;
		
		private var _valid : Boolean;
		
		private var _parser : MD5MeshParser;
		
		public function AwayMD5MeshResource()
		{
			super ();
		}
		
		public function get mesh() : Mesh
		{
			return _mesh;
		}
		
		override public function initialize( data : * ) : void
		{
			if ( data is ByteArray )
			{
				// convert ByteArray data to a string
				data = ( data as ByteArray ).readUTFBytes ( ( data as ByteArray ).length );
			}
			
			_parser = new MD5MeshParser ();
			
			_parser.addEventListener ( ParserEvent.PARSE_COMPLETE, onParseComplete );
			_parser.addEventListener ( AssetEvent.ASSET_COMPLETE, onAssetComplete );
			_parser.parseAsync ( String ( data ) );
		
			//Logger.print ( this, "Got type error parsing XML: " + e.toString () );
			//_valid = false;
		
		}
		
		protected function onReadyForDependencies( event : ParserEvent ) : void
		{
			// TODO Auto-generated method stub
		
		}
		
		protected function onParseComplete( event : ParserEvent = null ) : void
		{
			removePaserListeners();
			_valid = true;
			
			onLoadComplete ();
		}
		
		private function removePaserListeners () : void
		{
			if ( _parser )
			{
				_parser.removeEventListener ( ParserEvent.PARSE_COMPLETE, onParseComplete );
				_parser.removeEventListener ( AssetEvent.ASSET_COMPLETE, onAssetComplete );
			}			
		}
		/**
		 * @inheritDoc
		 */
		override protected function onContentReady(content:*):Boolean 
		{
			return _valid;
		}
		
		protected function onAssetComplete( event : AssetEvent ) : void
		{
			if ( event.asset is Mesh )
				_mesh = event.asset as Mesh;
		}
		
		override public function destroy() : void
		{
			_mesh = null;
			
			removePaserListeners ();
			_parser = null;
		}
	}
}

